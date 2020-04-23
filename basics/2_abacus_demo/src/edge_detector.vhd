----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Leandro D. Medus
-- 
-- Create Date:    18:04:10 07/12/2014 
-- Design Name: 
-- Module Name:    flanco - arch 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity flanco is
    Port ( 
		clk 		: in  std_logic;	-- clk para circuitos secuenciales
		rst_n 		: in  std_logic;	-- reset activo  por bajo
		config_re	: in  std_logic;	-- configuración del módulo: 	config_re = 1 - rising edge
										--								config_re = 0 - falling edge
        signal_in 	: in  std_logic;
        signal_re 	: out std_logic
	);
end flanco;

architecture arch of flanco is
	signal buf : std_logic_vector(1 downto 0);
begin

	process (clk, rst_n, signal_in)
	begin
		if rst_n = '0' then
			buf <= "00";
		elsif clk'event and clk='1' then
			buf(1) <= buf(0);
			buf(0) <= signal_in; 
		end if;
	end process;
	
	signal_re <= 	'1' when	(config_re = '1' and buf = "01") or
								(config_re = '0' and buf = "10") else 
					'0';
end arch;

