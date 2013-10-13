----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:09:38 10/03/2013 
-- Design Name: 
-- Module Name:    instruction_fetch - Behavioral 
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

entity fetch_stage is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           pc_update : in STD_LOGIC;
           pc_src : in STD_LOGIC;
           pc_input : in STD_LOGIC_VECTOR(31 downto 0);
           pc_incremented : out STD_LOGIC_VECTOR(31 downto 0);
           pc_signal : out STD_LOGIC_VECTOR(31 downto 0));
end fetch_stage;

architecture Behavioral of fetch_stage is

--COMPONENT declerations
component multiplexor
    generic (N : NATURAL);
    port (sel : in STD_LOGIC;
          in0 : in STD_LOGIC_VECTOR(N-1 downto 0);
          in1 : in STD_LOGIC_VECTOR(N-1 downto 0);
          output : out STD_LOGIC_VECTOR(N-1 downto 0));
end component;

component Adder
    generic (N : NATURAL);
    port ( A			: in	STD_LOGIC_VECTOR(N-1 downto 0);
           B			: in	STD_LOGIC_VECTOR(N-1 downto 0);
		   R			: out	STD_LOGIC_VECTOR(N-1 downto 0);
		   CARRY_IN	    : in	STD_LOGIC;
		   OVERFLOW	    : out	STD_LOGIC
	);
end component;


component pc 
    port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           pc_update : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR(31 downto 0);
           addr_out : out STD_LOGIC_VECTOR(31 downto 0));
end component;

-- SIGNAL declerations
signal ground_signal : STD_LOGIC; 
signal pc_input_signal : STD_LOGIC_VECTOR(31 downto 0);
signal pc_incremented_signal : STD_LOGIC_VECTOR(31 downto 0);
signal pc_out_signal         : STD_LOGIC_VECTOR(31 downto 0);

begin


PC_SRC_MUX : multiplexor 
generic map(N => 32)
port map( sel => pc_src, 
          in0 => pc_incremented_signal, 
          in1 => pc_input,
          output => pc_input_signal);
          
          
PROGRAM_COUNTER_MAP : pc 
port map(clk => clk, 
         reset => reset, 
         pc_update => pc_update, 
         addr => pc_input_signal, 
         addr_out => pc_out_signal);
         

PC_INCREMENTER_MAP : Adder 
generic map(N => 32)
port map( A => pc_out_signal, 
          B => "00000000000000000000000000000001", 
          R => pc_incremented_signal,
          CARRY_IN => '0',
          OVERFLOW => ground_signal);
         
         
-- Pass the incremented value and the pc addr to the next stage
pc_incremented <= pc_incremented_signal;
pc_signal <= pc_out_signal;

end Behavioral;