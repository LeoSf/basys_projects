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
    generic (
        g_WORD_WIDTH : integer := 7
    );
    port (
        -- global input signals
        clk_i           : in std_logic;        -- system clock
        rst_n_i         : in std_logic;         -- global reset (active low)
        -- buttons
        btn_up_i        : in std_logic;
        btn_down_i      : in std_logic;
        btn_left_i      : in std_logic;
        btn_right_i     : in std_logic;
        btn_center_i    : in std_logic;
        -- switches
        sw_n1_i         : in std_logic_vector (g_WORD_WIDTH-1 downto 0);
        sw_n2_i         : in std_logic_vector (g_WORD_WIDTH-1 downto 0);

        -- global output signals
        -- leds
        led_on_o        : out std_logic;        -- led reset disable
        leds_n1_o       : out std_logic_vector (g_WORD_WIDTH-1 downto 0);
        leds_n2_o       : out std_logic_vector (g_WORD_WIDTH-1 downto 0);

        sseg_ca_o 		: out  std_logic_vector (7 downto 0);
        sseg_an_o 		: out  std_logic_vector (3 downto 0)
    );
end top;

architecture Behavioral of top is
    -- signal declarations
    signal s_result_sum : std_logic_vector (g_WORD_WIDTH-1 downto 0);

    -- module declarations

begin
    -- module initializations
    ADDER0: entity work.adder
    generic map(
        g_WORD_WIDTH    => g_WORD_WIDTH
    )
    port map (
        clk_i           => clk_i,
        rst_n_i         => rst_n_i,
        operand_1_i     => sw_n1_i,
        operand_2_i     => sw_n2_i,
        valid_o         => open,
        result_o        => s_result_sum,
        overflow_o      => open
    );

    SEVENSEGS: entity work.seven_segs
    generic map(
        g_N_SEGMENTS    => 4,
        g_N_BITS        => 10,
        g_CLK_IN_MHZ    => 100
    )
    port map (
        clk_i           => clk_i,
        rst_n_i         => rst_n_i,
        en_i            => '1',
        dp_i            => (others => '1'),
        value_i         => std_logic_vector(to_unsigned(1023, 10)), --
        sseg_ca_o       => sseg_ca_o,
        sseg_an_o       => sseg_an_o
    );

    p_top_behav : process(rst_n_i, clk_i)
    begin
        if rst_n_i = '0' then
            led_on_o <= '0';
            leds_n1_o <= (others => '0');
            leds_n2_o <= (others => '0');
        else
            led_on_o <= '1';
            -- TODO
            leds_n1_o <= sw_n1_i;
            leds_n2_o <= sw_n2_i;
        end if ;
    end process p_top_behav;

end Behavioral;
