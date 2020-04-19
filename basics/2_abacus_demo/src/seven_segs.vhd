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
--      This is a basic module to display only numbers on the Basys3 board.
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
        display_value_i : in std_logic_vector (g_N_BITS-1 downto 0);  -- value to be displayed

        -- global output signals
        sseg_ca_o 		: out  std_logic_vector (7 downto 0);
        sseg_an_o 		: out  std_logic_vector (g_N_SEGMENTS-1 downto 0)
    );
end seven_segs;

architecture behavioral of seven_segs is
    -- constant
    -- constant c_TMR_CNTR_MAX : std_logic_vector(26 downto 0) := "101111101011110000100000000"; --100,000,000 = clk cycles per second
    -- constant c_TMR_VAL_MAX : std_logic_vector(3 downto 0) := "1001"; --9
    constant c_TMR_CNTR_MAX : unsigned(26 downto 0) := "101111101011110000100000000"; --100,000,000 = clk cycles per second
    constant c_TMR_VAL_MAX : unsigned(3 downto 0) := "1001"; --9

    -- Signals
    --This is used to determine when the 7-segment display should be
    --incremented #TODO generics
    signal tmrCntr : unsigned(26 downto 0) := (others => '0');

    --This counter keeps track of which number is currently being displayed
    --on the 7-segment. #TODO generics
    -- signal digit_val : std_logic_vector(3 downto 0) := (others => '0');
    signal digit_val : unsigned (3 downto 0) := (others => '0');

begin

    p_7seg_behav : process(rst_n_i, clk_i)
    begin
        if rst_n_i = '0'  then      -- asynchronous reset
            -- reset signals
            sseg_an_o  <= (others => '1');

        elsif rising_edge(clk_i) then
            -- SSEG_AN <= ----
            sseg_an_o <= (others => '0');
        else
            -- latching everything
        end if ;    -- end rst_n_i
    end process p_7seg_behav;

    -- Encoding the current value to display to the necessary cathode
    -- signals to display n the seven segment digit (296)
    with digit_val select
    	sseg_ca_o <=  "01000000" when "0000",
                    "01111001" when "0001",
                    "00100100" when "0010",
                    "00110000" when "0011",
                    "00011001" when "0100",
                    "00010010" when "0101",
                    "00000010" when "0110",
                    "01111000" when "0111",
                    "00000000" when "1000",
                    "00010000" when "1001",
                    "11111111" when others; -- default: leds off

    --This process controls the counter that triggers the 7-segment
    --to be incremented. It counts 100,000,000 and then resets.
    timer_counter_process : process (rst_n_i, clk_i)
    begin
        if rst_n_i = '0'  then      -- asynchronous reset
            tmrCntr <= (others => '0');
            -- tmrCntr <= 0;
            -- tmrVal <= (others => '0');

        elsif (rising_edge(clk_i)) then
    		if (tmrCntr = c_TMR_CNTR_MAX) then
    			tmrCntr <= (others => '0');
                -- tmrCntr <= 0;
    		else
    			tmrCntr <= tmrCntr + 1;
    		end if;
    	end if;
    end process;

    --This process increments the digit being displayed on the
    --7-segment display every second.
    timer_inc_process : process (rst_n_i, clk_i)
    begin
        if rst_n_i = '0'  then      -- asynchronous reset
            -- tmrVal <= (others => '0');

    	elsif (rising_edge(clk_i)) then
    		if (tmrCntr = c_TMR_CNTR_MAX) then
    			if (digit_val = c_TMR_VAL_MAX) then
    				digit_val <= (others => '0');
    			else
    				digit_val <= digit_val + 1;
    			end if;
    		end if;
    	end if;
    end process;

end behavioral;
