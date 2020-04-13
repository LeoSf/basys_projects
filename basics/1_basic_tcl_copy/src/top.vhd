----------------------------------------------------------------------------------
-- Company:             None
-- Engineer:            Leandro D. Medus
--
-- Create Date:         18:17:00 04/12/2020
-- Design Name:         Logistic Sigmoid 2nd Order Aproximation
-- Module Name:         top - Behavioral
-- Project Name:        0_basics_sw_leds
-- Target Devices:
-- Tool versions:       Vivado 2019.1
-- Description:
--
-- Dependencies:
--
-- Revision History:
--      04/12/2020  v0.01 File created
--
-- Additional Comments:
--
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- ieee 1076.3

entity top is
    Port (
        -- global input signals
        clk_i   : in  std_logic;      -- local clock
        rst_n_i : in std_logic;
        sw_i    : in std_logic_vector (15 downto 1);

        -- global output signals
        led_on_o: out std_logic;
        leds_o  : out std_logic_vector (15 downto 1)
        );
end top;

architecture Behavioral of top is
begin

    p_top_behav : process (rst_n_i, clk_i)
    begin
        if rising_edge(clk_i) then      -- synchronous reset
            if rst_n_i = '0' then
                -- default values of the module after reset
                led_on_o <= '0';
                leds_o <= (others => '0');
            else
                led_on_o <= '1';

                leds_o <= sw_i;
            end if;
        end if;

    end process p_top_behav;

end Behavioral;
