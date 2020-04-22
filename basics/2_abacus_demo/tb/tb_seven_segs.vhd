----------------------------------------------------------------------------------
-- Company:             None
-- Engineer:            Leandro D. Medus
--
-- Create Date:         11:36:00 04/14/2020
-- Design Name:         tb_adder
-- Module Name:         top - Behavioral
-- Project Name:        2_abacus_demo
-- Target Devices:
-- Tool versions:       Vivado 2019.1
-- Description:
--
-- Dependencies:
--      adder.vhd       (adder module)
-- Revision History:
--      04/14/2020  v0.01 File created
--
-- Additional Comments:
--
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;                       -- ieee 1076.3

entity tb_seven_segs is
    generic(
        g_WORD_WIDTH : integer := 7
    );
end tb_seven_segs;

architecture behavioral of tb_seven_segs is

    -- component declarations
    component seven_segs
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
    end component;

    -- Clock period definitions
    constant c_CLK_PERIOD : time := 10 ns;

    --Inputs
    signal s_clk        : std_logic := '0';
    signal s_rst_n      : std_logic;
    signal s_en         : std_logic;

    --Outputs
    signal s_sseg_katodes   : std_logic_vector (7 downto 0);
    signal s_sseg_anodes    : std_logic_vector (3 downto 0);


    -- Debugging Signals
    -- TBD

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: seven_segs
    generic map(
        g_N_SEGMENTS    => 4,
        g_N_BITS        => 10,
        g_CLK_IN_MHZ    => 100
    )
    port map (
        clk_i       => s_clk,
        rst_n_i     => s_rst_n,
        en_i        => s_en,
        dp_i        => (others => '1'),
        value_i     => std_logic_vector(to_unsigned(1023, 10)),
        sseg_ca_o   => s_sseg_katodes,
        sseg_an_o   => s_sseg_anodes
    );

    -- Clock process definitions
    p_clk_process : process
    begin
		s_clk <= '0';
		wait for c_CLK_PERIOD/2;
		s_clk <= '1';
		wait for c_CLK_PERIOD/2;
   end process;

   p_stim_proc: process
   begin
        s_rst_n <= '0';
        s_en <= '0';

        wait for 40 ns;
        s_rst_n <= '1';

        wait for 60 ns;
        s_en <= '1';


        wait for 10000 ns;
        report "[msg] Testbench end." severity failure ;
    end process;

end behavioral;
