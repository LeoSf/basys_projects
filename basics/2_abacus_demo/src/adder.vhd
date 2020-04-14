----------------------------------------------------------------------------------
-- Company:             None
-- Engineer:            Leandro D. Medus
--
-- Create Date:         10:32:00 04/14/2020
-- Design Name:         adder
-- Module Name:         top - Behavioral
-- Project Name:        2_abacus_demo
-- Target Devices:
-- Tool versions:       Vivado 2019.1
-- Description:
--
-- Dependencies:
--
-- Revision History:
--      04/14/2020  v0.01 File created
--
-- Additional Comments:
--      Negative numbers not supported yet
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;                   -- ieee 1076.3

entity adder is
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
        done_o      : out std_logic;        -- operation complete
        overflow_o  : out std_logic;        -- overflow flag
        result_o    : out std_logic_vector (g_WORD_WIDTH-1 downto 0)  -- result
    );
end adder;

architecture behavioral of adder is
    -- constant
    constant c_MAX_VALUE : integer := 2 ** (g_WORD_WIDTH-1) - 1;

    -- Signals
    -- signal s_operand_1  : unsigned range 0 to (2 ** g_WORD_WIDTH)-1;
    -- signal s_operand_2  : unsigned range 0 to (2 ** g_WORD_WIDTH)-1;
    signal s_result     : integer range 0 to (2 ** g_WORD_WIDTH)-1;
begin

    p_top_behav : process(rst_n_i, clk_i)
    begin
        if rst_n_i = '0' then
            done_o <= '0';
            overflow_o <= '0';
            result_o <= (others => '0');
        else
            -- TBD
            s_result <= to_integer(unsigned(operand_1_i)) + to_integer(unsigned(operand_2_i));

            result_o <= std_logic_vector(to_unsigned(to_integer(unsigned(operand_1_i)) + to_integer(unsigned(operand_2_i)), result_o'length));

            done_o <= '1';
        end if ;
    end process p_top_behav;

end behavioral;
