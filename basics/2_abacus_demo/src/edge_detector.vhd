----------------------------------------------------------------------------------
-- Company:
-- Engineer: Leandro D. Medus
--
-- Create Date:    18:04:10 07/12/2014
-- Design Name:
-- Module Name:    edge_detector - arch
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision History:
--      07/12/2014  v0.01   File created
--      04/24/2020  v1.0    Standard names
--
-- Additional Comments:
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity edge_detector is
    Port (
		clk_i 		: in  std_logic;	-- clk_i para circuitos secuenciales
		rst_n_i 	: in  std_logic;	-- reset activo  por bajo
		edge_cfg_i	: in  std_logic;	-- configuración del módulo: 	edge_cfg_i = 1 - rising edge
										--								edge_cfg_i = 0 - falling edge
        signal_i 	: in  std_logic;    -- input signal
        edge_o 	    : out std_logic     -- edge detecion
	);
end edge_detector;

architecture behavioral of edge_detector is
	signal s_buff : std_logic_vector(1 downto 0);
begin

    p_detector_behav : process (clk_i, rst_n_i, signal_i)
	begin
		if rst_n_i = '0' then
			s_buff <= "00";
		elsif clk_i'event and clk_i='1' then
			s_buff(1) <= s_buff(0);
			s_buff(0) <= signal_i;
		end if;
	end process;

	edge_o <= 	'1' when    (edge_cfg_i = '1' and s_buff = "01") or
                            (edge_cfg_i = '0' and s_buff = "10")
                            else '0';
end behavioral;
