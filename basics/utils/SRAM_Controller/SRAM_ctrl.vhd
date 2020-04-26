library ieee;
use ieee.std_logic_1164.all;

entity sram_ctrl  is
  
  port (
    clk         : in    std_logic;      -- clock del sistema
    reset       : in    std_logic;      -- reset asincrónico

    -- señales desde y hacia el sistema principal
    mem         : in    std_logic;      -- mem
    rw          : in    std_logic;      -- read/write signal
    data_f2s    : in    std_logic;      -- a
    data_f2s    : in    std_logic_vector(15 downto 0);  -- datos a escribir
    addr        : in    std_logic_vector(17 downto 0);  -- dirección de la palabra
    ready       : out   std_logic;      -- señal de listo
    data_s2f_r  : out   std_logic_vector(15 downto 0);  -- registro de datos
    data_s2f_ur : out   std_logic_vector(15 downto 0);  -- registro de datos

    -- señales hacia y desde el chip
    ad          : out   std_logic_vector(17 downto 0);  -- dirección de salida
    we_n        : out   std_logic;  -- señal de write enable, activa por bajo
    oe_n        : out   std_logic;  -- señal de output enable, activa por bajo

    -- señales SRAM chip 
    dio_a       : inout std_logic_vector(15 downto 0);  -- señal de digital io
    ce_a_n      : out   std_logic;      -- señal de chip enable
    ub_a_n      : out   std_logic;      -- señal
    lb_a_n      : out   std_logic);     -- señal

end sram_ctrl ;

architecture arq of sram_ctrl is
  type state_type is (idle, rd1, rd2, wr1, wr2);  -- definición de la máquina de estados
  signal state_reg : state_type;        -- registro del estado de la FSM
  signal state_next : state_type;       -- registro para la lógica de próximo estado
  signal data_f2s_reg : std_logic_vector(15 downto 0);  -- data
  signal data_f2s_next : std_logic_vector(15 downto 0);  -- data
  signal data_s2f_reg : std_logic_vector(15 downto 0);  -- data
  signal data_s2f_next : std_logic_vector(15 downto 0);  -- data
  signal addr_reg, addr_next : std_logic_vector(17 downto 0);  -- registros de direcciones
  signal we_buf, oe_buf, tri_buf : std_logic;  -- señales
  signal we_reg, oe_reg, tri_reg : std_logic;  -- señales de registros
 
begin  -- arq
  -- Estados y registros de datos
  -- purpose:  
  -- type   : combinational
  -- inputs : clk,reset
  -- outputs:  
  process (clk,reset)
  begin  -- process
    if reset='1' then
      state_reg <= idle;
      addr_reg  <= (others=>'0');
      data_s2f_reg <= (others=>'0');
      data_f2s_reg <= (others=>'0');
      we_reg <= '0';
      oe_reg <= '0';
      tri_reg <= '0';
    elsif (clk'event and clk='1') then
      state_reg <= state_next;
      addr_reg  <= addr_next;
      data_s2f_reg <= data_s2f_next;
      data_f2s_reg <= data_f2s_next;
      we_reg <= we_buf;
      oe_reg <= oe_buf;
      tri_reg <= tri_buf;
    end if;  
  end process;

  --Lógica de próximo estado
  -- purpose:  
  -- type   : combinational
  -- inputs : state_reg, mem, rw, dio_a, addr, data_f2s, data_f2s_reg, data_s2f_reg, addr_reg
  -- outputs:  
  process (state_reg, mem, rw, dio_a, addr, data_f2s, data_f2s_reg, data_s2f_reg, addr_reg)
  begin  -- process
    addr_next <= addr_reg;
    data_f2s_next <= data_f2s_reg;
    data_s2f_next <= data_s2f_reg;
    ready <= '0';
    case state_reg is
      when idle =>
        if mem='0' then
          state_next <= idle;
        else
          addr_next <= addr;
          if rw='0' then                -- write
            state_next <= wr1;
            data_f2s_next <= data_f2s;
          else                          -- read
            state_next <= rd1;             
          end if;
        end if;
        ready <= '1';
      when wr1 =>
        state_next <= wr2;
      when wr2 =>
        state_next <= idle;
      when rd1 =>
        state_next <= rd2;
      when rd2 =>
        data_s2f_next <= dio_a;
        state_next <= idle;
    end case;
  end process;

  -- Lógica de salida "look-ahead"
  -- purpose:  
  -- type   : combinational
  -- inputs : state_next
  -- outputs:  
  process (state_next)
  begin  -- process
    tri_buf <= '1';                     -- default
    we_buf  <= '1';
    oe_buf  <= '1';
    case state_next is
      when idle =>
      when wr1 =>
        tri_buf <= '0';
        we_buf  <= '0';
      when wr2 =>
        tri_buf <= '0';
      when rd1 =>
        oe_buf <= '0';
      when rd2 =>
        oe_buf <= '0';
    end case;
  end process;

  -- para el sistema principal
  data_s2f_r <= data_s2f_reg;
  data_s2f_ur <= dio_a;

  -- para SRAM
  we_n <= we_reg;
  oe_n <= oe_reg;
  ad   <= addr_reg;

  -- E/S para el chip SRAM a
  ce_a_n <= '0';
  ub_a_n <= '0';
  lb_a_n <= '0';
  dio_a  <= data_f2s_reg when tri_reg='0' else
            (others=>'Z');

end arq;
