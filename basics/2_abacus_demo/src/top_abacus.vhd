----------------------------------------------------------------------------------
-- Company:             None
-- Engineer:            Leandro D. Medus
--
-- Create Date:         18:17:00 04/12/2020
-- Design Name:         Abacus
-- Module Name:         top - Behavioral
-- Project Name:        2_abacus_demo
-- Target Devices:
-- Tool versions:       Vivado 2019.1
-- Description:
--
-- Dependencies:
--      adder.vhd
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
        clk_i       : in  std_logic;        -- system clock
        rst_n_i     : in std_logic;         -- global reset (active low)
        -- buttons
        btn_up_i    : in std_logic;
        btn_down_i  : in std_logic;
        btn_left_i  : in std_logic;
        btn_right_i : in std_logic;
        btn_center_i: in std_logic;
        -- switches
        sw_n1_i       : in std_logic_vector (6 downto 0);
        sw_n2_i       : in std_logic_vector (6 downto 0);

        -- global output signals
        -- leds
        led_on_o    : out std_logic;        -- led reset disable
        leds_n1_o      : out std_logic_vector (6 downto 0);
        leds_n2_o      : out std_logic_vector (6 downto 0)
    );
end top;

architecture Behavioral of top is
    -- signal declarations

    -- module declarations

begin
    -- module initializations

    p_top_behav : process(rst_n_i, clk_i)
    begin
        if rst_n_i = '0' then
            led_on_o <= '0';
            leds_n1_o <= (others => '0');
            leds_n2_o <= (others => '0');
        else
            led_on_o <= '1';
            -- TODO
            leds_n1_o <= (others => '1');
            leds_n2_o <= (others => '1');
        end if ;
    end process p_top_behav;

end Behavioral;