----------------------------------------------------------------------------------
-- Company:             None
-- Engineer:            Leandro D. Medus
--
-- Create Date:         10:32:00 04/16/2020
-- Design Name:         seven_segs
-- Module Name:         top - Behavioral
-- Project Name:        2_abacus_demo
-- Target Devices:
-- Tool versions:       Vivado 2019.1
-- Description:
--      7-Seg display control for Baysy 3 board.
-- Dependencies:
--
-- Revision History:
--      04/16/2020  v0.01 File created
--
-- Additional Comments:
--      This is a basic module to display only numbers on the seven segments
--      present on the Basys3 board.
--
-- TODOs:
--      * implement digital point on each segment.
--      * enable signal
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;                       -- ieee 1076.3

entity seven_segs is
    generic(
        g_N_SEGMENTS    : integer := 4;         -- number of digits
        g_N_BITS        : integer := 10;        -- word width of number input
        g_CLK_IN_MHZ    : integer := 100         -- frequency of the input clk
    );
    port (
        -- global input signals
        clk_i           : in std_logic;         -- system clock
        rst_n_i         : in std_logic;         -- global reset (active low)
        en_i            : in std_logic;         -- enable signal
        value_i         : in std_logic_vector (g_N_BITS-1 downto 0);  -- value to be displayed
        dp_i            : in std_logic_vector (g_N_SEGMENTS-1 downto 0);

        -- global output signals
        sseg_ca_o 		: out  std_logic_vector (7 downto 0);
        sseg_an_o 		: out  std_logic_vector (g_N_SEGMENTS-1 downto 0)
    );
end seven_segs;

architecture behavioral of seven_segs is
    -- constant
    -- timer max counter for a 1 MHz clock: 100,000,000 = clk cycles per second
    -- constant c_TMR_CNTR_MAX : unsigned(26 downto 0) := "101111101011110000100000000";
    constant c_TMR_CNTR_MAX : unsigned(26 downto 0) := to_unsigned(100000, 27);
    -- max value to display in the 7-seg: 9
    -- constant c_TMR_VAL_MAX : unsigned(3 downto 0) := "1001";
    constant c_TMR_VAL_MAX : unsigned(3 downto 0) := to_unsigned(9, 4);

    -- Signals
    --This is used to determine when the 7-segment display should be
    --incremented #TODO generics
    signal tmrCntr : unsigned(26 downto 0);

    --This counter keeps track of which number is currently being displayed
    --on the 7-segment. #TODO generics
    signal digit_val : std_logic_vector (3 downto 0);


    signal s_sseg_anodes : std_logic_vector (3 downto 0);


    signal display_id : unsigned (4 downto 0);


    signal values_bcd   : std_logic_vector ((g_N_SEGMENTS * 4 - 1) downto 0);
    signal module_ena   : std_logic;
    signal module_busy  : std_logic;
begin

    ADDER0: entity work.binary_to_bcd
    generic map(
        bits    => g_N_BITS,
        digits  => g_N_SEGMENTS
    )
    port map (
        clk         => clk_i,
        reset_n     => rst_n_i,
        ena         => module_ena,
        binary      => value_i,
        busy        => module_busy,
        bcd         => values_bcd
    );


    p_7seg_behav : process(rst_n_i, clk_i)
        variable upper_slice : integer;
        variable lower_slice : integer;

        variable upper_slice_i : integer := 3;
        variable lower_slice_i : integer := 0;

        variable upper_slice_u : natural := 3;
        variable lower_slice_u : natural := 0;
    begin
        if rst_n_i = '0'  then      -- asynchronous reset
            -- reset signals
            sseg_an_o  <= (others => '1');

        elsif rising_edge(clk_i) then
            sseg_an_o <= s_sseg_anodes;
        else
            -- latching everything
        end if ;    -- end rst_n_i
    end process p_7seg_behav;

    -- with display_id select
    --     digit_val <=    values_bcd(3 downto 0) when "00",
    --                     values_bcd(7 downto 4) when "01",
    --                     values_bcd(11 downto 8) when "10",
    --                     values_bcd(15 downto 12) when "11",
    --                     "1111" when others;  -- default: leds off

    -- asignación del valor bcd según el dígito activo
    with display_id select
        digit_val <=    std_logic_vector(to_unsigned(4, 4)) when "0000",
                        std_logic_vector(to_unsigned(3, 4)) when "0001",
                        std_logic_vector(to_unsigned(2, 4)) when "0010",
                        std_logic_vector(to_unsigned(1, 4)) when "0011",
                        "1111" when others;  -- default: leds off

    -- anodes activation as a function of the active seven segment
    with display_id select
        s_sseg_anodes <=    "1110" when "0000",
                            "1101" when "0001",
                            "1011" when "0010",
                            "0111" when "0011",
                            "1111" when others;  -- default: leds off



    -- with display_id select
    --     digit_val <=    values_bcd(3 downto 0) when "00" and  module_busy = '0',
    --                     values_bcd(7 downto 4) when "01" and  module_busy = '0',
    --                     values_bcd(11 downto 8) when "10" and  module_busy = '0',
    --                     values_bcd(15 downto 12) when "11" and  module_busy = '0',
    --                     "1111" when others;  -- default: leds off

    -- Encoding the current value to display to the necessary cathode
    -- signals to display n the seven segment digit (296)
    with digit_val select
        sseg_ca_o(6 downto 0) <= "1000000" when "0000",
            "1111001" when "0001",  -- 1
            "0100100" when "0010",  -- 2
            "0110000" when "0011",  -- 3
            "0011001" when "0100",  -- 4
            "0010010" when "0101",  -- 5
            "0000010" when "0110",  -- 6
            "1111000" when "0111",  -- 7
            "0000000" when "1000",  -- 8
            "0010000" when "1001",  -- 9
            "1111111" when others;  -- default: leds off

    -- disabling digital point for all digits
    sseg_ca_o(7) <= '1';

    --This process controls the counter that triggers the 7-segment
    --to be incremented. It counts 100,000,000 and then resets.
    timer_counter_process : process (rst_n_i, clk_i)
    begin
        if rst_n_i = '0'  then      -- asynchronous reset
            tmrCntr <= (others => '0');
        elsif (rising_edge(clk_i)) then
    		if (tmrCntr = c_TMR_CNTR_MAX) then
    			tmrCntr <= (others => '0');
    		else
    			tmrCntr <= tmrCntr + 1;
    		end if;
    	end if;
    end process;

    --This process increments the digit being displayed on the
    --7-segment display every second bacues clk is 100 MHz
    digit_inc_process : process (rst_n_i, clk_i)
    begin
        if rst_n_i = '0'  then      -- asynchronous reset
            display_id <= (others => '0');

    	elsif (rising_edge(clk_i)) then
    		if (tmrCntr = c_TMR_CNTR_MAX) then
    			if (display_id = c_TMR_VAL_MAX) then
    				display_id <= (others => '0');
    			else
    				display_id <= display_id + 1;
    			end if;
    		end if;
    	end if;
    end process;

end behavioral;
