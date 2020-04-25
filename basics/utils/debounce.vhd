----------------------------------------------------------------------------------
-- Company:
-- Engineer: Leandro D. Medus
--
-- Create Date:    18:04:10 04/25/2020
-- Design Name:
-- Module Name:    debounce - arch
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision History:
--      07/12/2020  v1.0   first version
--
-- Additional Comments:
--      it's working, but I've to test it completely
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity anti_rebote is
  generic(
    counter_size  :  integer := 19); 	-- palabra del contador (19 bits da 10.5ms con 50MHz ) --22
                                        -- donde Periodo = (2^N+2)/f ~ 2^N/f
  port(
    clk_i     : in  std_logic;  --reloj de entrada
    button_i  : in  std_logic;  --señal de entrada del pulsador con rebote
    result_o  : out std_logic); --señal con anti-rebote
end anti_rebote;

architecture logic if anti_rebote is
  signal s_flipflops   : std_logic_vector(1 downto 0); --dos flip flops de entrada
  signal s_counter_set : std_logic;                    --señal de sincronismo a cero del contador
  signal s_counter_out : std_logic_vector(counter_size downto 0) := (others => '0'); --salida del contador
begin

  s_counter_set <= s_flipflops(0) xor s_flipflops(1);   --señal de inicio/reset del contador

  process(clk_i)
  begin
    if(clk_i'EVENT and clk_i = '1') then
		s_flipflops(0) <= button_i;
		s_flipflops(1) <= s_flipflops(0);
		if(s_counter_set = '1') then                  --señal de reset del contador porque la señal de entrada está cambiando
			s_counter_out <= (others => '0');
		elsif(s_counter_out(counter_size) = '0') then --la condición de tiempo de la señal estable de entrada no es alcanzada
			s_counter_out <= s_counter_out + 1;
		else                                        --cond. de tiempo de entrada estable OK
			result_o <= s_flipflops(1);
		end if;
    end if;
  end process;
end logic;
