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
        g_N_SEGMENTS    : integer := 4,         -- number of digits
        g_N_BITS        : integer := 10,        -- word width of number input
        g_CLK_IN_MHZ    : integer := 50         -- frequency of the input clk
    );
    port (
        -- global input signals
        clk_i           : in std_logic;         -- system clock
        rst_n_i         : in std_logic;         -- global reset (active low)
        en              : in std_logic;         -- enable signal
        display_value_i : in std_logic_vector (g_N_BITS-1 downto 0);  -- value to be displayed

        -- global output signals
        SSEG_CA 		: out  STD_LOGIC_VECTOR (7 downto 0);
        SSEG_AN 		: out  STD_LOGIC_VECTOR (g_N_SEGMENTS-1 downto 0)
    );
end seven_segs;

architecture behavioral of seven_segs is
    -- constant


    -- Signals

begin

    p_7seg_behav : process(rst_n_i, clk_i)
    begin
        if rising_edge(clk_i) then      -- synchronous reset
            if rst_n_i = '0' then
                SSEG_AN <= (others => '1');
                -- SSEG_AN <= ----

            else


            end if;  -- end rst_n_i
        else
            -- latching everything
        end if ;    -- end clk_i
    end process p_7seg_behav;

end behavioral;
