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

entity tb_adder is
    generic(
        g_WORD_WIDTH : integer := 7
    );
end tb_adder;

architecture behavioral of tb_adder is

    -- component declarations
    component adder
        generic(
            g_WORD_WIDTH : integer := 8         -- word width of each operand
        );
        port (
            -- global input signals
            clk_i       : in  std_logic;        -- system clock
            rst_n_i     : in std_logic;         -- global reset (active low)

            -- signed operation not supported yet
            operand_1_i : in std_logic_vector (g_WORD_WIDTH-1 downto 0);  -- first opperand
            operand_2_i : in std_logic_vector (g_WORD_WIDTH-1 downto 0);  -- second operand

            -- global output signals
            valid_o      : out std_logic;       -- operation complete
            overflow_o  : out std_logic;        -- overflow flag
            result_o    : out std_logic_vector (g_WORD_WIDTH-1 downto 0)  -- result
        );
    end component;

    -- Clock period definitions
    constant c_CLK_PERIOD : time := 10 ns;

    --Inputs
    signal s_clk        : std_logic := '0';
    signal s_rst_n      : std_logic;
    signal s_din_1      : std_logic_vector(g_WORD_WIDTH-1 downto 0) := (others => '0');
    signal s_din_2      : std_logic_vector(g_WORD_WIDTH-1 downto 0) := (others => '0');

    --Outputs
    signal s_valid          : std_logic;
    signal s_ov             : std_logic;
    signal s_result_sum     : std_logic_vector(g_WORD_WIDTH-1 downto 0);

    -- Debugging Signals
    -- TBD

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: adder
    generic map(
        g_WORD_WIDTH    => 7
    )
    port map (
        clk_i           => s_clk,
        rst_n_i         => s_rst_n,
        operand_1_i     => s_din_1,
        operand_2_i     => s_din_2,
        valid_o         => s_valid,
        result_o        => s_result_sum,
        overflow_o      => s_ov
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
        variable v_number_1    : integer := 50;
        variable v_number_2    : integer := 0;

    begin
        s_rst_n <= '0';
        wait for 40 ns;
        s_rst_n <= '1';

        wait for c_CLK_PERIOD;

        for i in 1 to 100 loop

            s_din_1 <= std_logic_vector(to_unsigned(v_number_1, s_din_1'length));
            s_din_2 <= std_logic_vector(to_unsigned(v_number_2, s_din_2'length));

            wait for c_CLK_PERIOD;

            v_number_2 := v_number_2 + 1;
        end loop;

        report "end testbench" severity failure ;
    end process;

end behavioral;
