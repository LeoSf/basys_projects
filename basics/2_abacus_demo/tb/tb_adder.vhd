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
use ieee.numeric_std.all;               -- ieee 1076.3

entity tb_adder is
    generic(
        g_WORD_WIDTH : integer :=7
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
            valid_o      : out std_logic;        -- operation complete
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
    signal  s_dout      : std_logic_vector(g_WORD_WIDTH-1 downto 0);

    -- Debugging Signals
    -- TBD

begin




end behavioral;
