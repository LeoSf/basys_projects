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
        sw_i    : in std_logic_vector (15 downto 0);

        -- global output signals
        leds_o  : out std_logic_vector (15 downto 0)
        );
end top;

architecture Behavioral of top is
begin

    -- led_on_o <= rst_n_i;

    leds_o <= sw_i;

end Behavioral;
