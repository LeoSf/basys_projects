----------------------------------------------------------------------------------
-- Company:             None
-- Engineer:            Leandro D. Medus
--
-- Create Date:         10:32:00 04/16/2020
-- Design Name:         bin_to_bcd
-- Module Name:         top - Behavioral
-- Project Name:        2_abacus_demo
-- Target Devices:
-- Tool versions:       Vivado 2019.1
-- Description:
--      Binary to BCD module converter.
--      Each BCD value is represented in bcd_values_o.
-- Dependencies:
--
-- Revision History:
--      04/16/2020  v0.01 File created
--
-- Additional Comments:
--     Error codes are not supported yet.
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;                       -- ieee 1076.3

entity bin_to_bcd is
    generic(
        g_N_BITS        : integer := 10;        -- word width of number input
        g_N_DIGITS      : integer := 4          -- number of digits
    );
    port (
        -- global input signals
        clk_i           : in std_logic;         -- system clock
        rst_n_i         : in std_logic;         -- acive low asynchronus
        en              : in std_logic;         -- enable signal
        bin_value_i     : in std_logic_vector (g_N_BITS-1 downto 0);  -- value to be displayed

        -- global output signals
        valid_o         : out std_logic;
        bcd_values_o    : out std_logic_vector (g_N_DIGITS*4-1 downto 0)
    );
end bin_to_bcd;

architecture behavioral of bin_to_bcd is
    -- constant


    -- Signals

begin

    p_binBCD_behav : process(rst_n_i, clk_i)
    begin
        if rst_n_i = '0' or en = '0' then      -- synchronous reset
            valid_o <= '0';
            bcd_values_o <= (others => '0');

        else
            if rising_edge(clk_i) then
                -- dummy outputs
                valid_o <= '1';
                bcd_values_o <= (others => '1');
                ---

            -- else
                -- latching everything

            end if;  -- end rst_n_i
        end if;    -- end clk_i
    end process p_binBCD_behav;

end behavioral;
