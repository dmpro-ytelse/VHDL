----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:18:32 09/21/2013 
-- Design Name: 
-- Module Name:    selection_core_control - Behavioral 
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

entity selection_core_control is
    Port ( clk 						: in  STD_LOGIC;
           reset  					: in  STD_LOGIC;
           selection_core_enable    : in  STD_LOGIC;
		   crossover_core_enable    : in STD_LOGIC;
           comparator_signal 		: in  STD_LOGIC_VECTOR (1 downto 0);
           update_fitness 			: out STD_LOGIC;
           update_chromosome 		: out STD_LOGIC;
           propagate_data 			: out STD_LOGIC;
           request_memory 			: out STD_LOGIC;
           fetch_fitness            : out STD_LOGIC;
           fetch_chromosome         : out STD_LOGIC;
           flush_registers          : out STD_logic
           
           );
end selection_core_control;

architecture Behavioral of selection_core_control is


component adder 
        generic(N : natural);
        port ( A : in std_logic_vector(N-1 downto 0);
               B : in std_logic_vector(N-1 downto 0);
               res: out std_logic_vector(N-1 downto 0);
               overflow : out std_logic
        );
end component adder;

--States
type state_type is (STATE_STALL, STATE_FETCH_FITNESS, STATE_FETCH_CHROMOSOME, STATE_COMPARE, STATE_INIT);
signal CURRENT_STATE, NEXT_STATE : state_type;

--Constants
constant GREATER_THAN : std_logic_vector(1 downto 0) := "10";
constant LESS_THAN : std_logic_vector (1 downto 0) := "01";
constant EQUAL : std_logic_vector (1 downto 0) := "00";

--Tournament related
constant TOURNAMENT_END : std_logic_vector(2 downto 0) := "111";
signal counter : std_logic_vector (2 downto 0) := (others => '0');
signal counter_res : std_logic_vector(2 downto 0);

--Misc
signal ground_signal : std_logic;


begin


ADDER_UNIT : Adder 
    generic map(N => 3)
    port map(
            A => "001",
            B => counter,
            res => counter_res,
            overflow => ground_signal
    );


RUN : process (clk, reset) 
begin 
    if reset = '1' then
        CURRENT_STATE <= STATE_INIT;
    elsif rising_edge(clk) then 
        if selection_core_enable = '1' then 
            CURRENT_STATE <= NEXT_STATE;
        end if;
    end if;  
end process RUN;


STATE_MACHINE : process (CURRENT_STATE, comparator_signal) 
begin 
    case CURRENT_STATE is 
    when STATE_FETCH_FITNESS =>
        -- Fetch data from memory
        request_memory <= '0';
        propagate_data <= '1';
        update_chromosome <= '0';
        --Increment tournament counter 
        counter <= counter_res;
        if counter_res = TOURNAMENT_END then
            counter <= (others => '0');
            --Enable crossover
            cross_over_enable <= '1';
            --Flush
            flush_registers <= '1';
            --Stall one cycle for crossover to finish ?
            NEXT_STATE <= STATE_STALL;
        end if;
        NEXT_STATE <= STATE_COMPARE;
    
    when STATE_COMPARE => 
        --Set appropiate signals
        request_memory <= '0';
        propagate_data <= '0';
        update_chromosome <= '0'; 
        
        case comparator_signal is 
        when GREATER_THAN => 
             -- The new fitness is the best
             update_fitness <= '1'; --Update best fitness register with new best
             request_memory <= '0';
             NEXT_STATE <= STATE_FETCH_CHROMOSOME;
             
        when LESS_THAN => 
             -- The old fitness is the best
             update_fitness <= '0';
             request_memory <= '1';
             NEXT_STATE <= STATE_STALL;
        
        when EQUAL =>
             -- They are equal
             update_fitness <= '1';
             --No need to request the chromosome from memmory
             NEXT_STATE <= STATE_STALL;
             
        when others => 
            --Dont care!
        end case;
    when STATE_FETCH_CHROMOSOME => 
        --Update chromosome register with new best
        propagate_data <= '1';
        update_chromosome <= '1';
        update_fitness <= '0';
        NEXT_STATE <= STATE_FETCH_FITNESS;
    
    
    when STATE_STALL =>
        --stall one cycle while waiting for memory
        request_memory <= '1';
        flush_registers <= '0';
        crossover_core_enable <= '0';
        NEXT_STATE <= STATE_FETCH_FITNESS;
       
    when STATE_INIT =>
        if selection_core_enable = '1' then
            request_memory <= '1';
            NEXT_STATE <= STATE_FETCH_FITNESS;
        end if;
    
    end case;
    
end process STATE_MACHINE;


end Behavioral;
