LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY crossover_core_split_tb IS
END crossover_core_split_tb;
 
ARCHITECTURE behavior OF crossover_core_split_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT crossover_core_split
    PORT(
         enabled : IN  std_logic;
         random_number : IN  std_logic_vector(31 downto 0);
         parent1 : IN  std_logic_vector(63 downto 0);
         parent2 : IN  std_logic_vector(63 downto 0);
         child1 : OUT  std_logic_vector(63 downto 0);
         child2 : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal enabled : std_logic := '0';
   signal random_number : std_logic_vector(31 downto 0) := (others => '0');
   signal parent1 : std_logic_vector(63 downto 0) := (others => '0');
   signal parent2 : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal child1 : std_logic_vector(63 downto 0);
   signal child2 : std_logic_vector(63 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: crossover_core_split PORT MAP (
          enabled => enabled,
          random_number => random_number,
          parent1 => parent1,
          parent2 => parent2,
          child1 => child1,
          child2 => child2
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		
		--Choosing completely different bitpatterns (from now on referred to as "standard parents"):
		parent1 <= "1111111111111111000000000000000011111111111111110000000000000000";
		parent2 <= "0000000000000000111111111111111100000000000000001111111111111111";
		
		--Choosing 11, with ending bit-pattern 1011, value for as opening random number:
		random_number <= "00001111000011110000111100001011";
		
		wait for 40 ns;
		
		enabled <= '1';
		
		wait for 40 ns;
		
		--Change in parents should cause change in children:
		parent1 <= "1111111111111111000000000000000011000011111111110000000000011110";
		parent2 <= "0000000000000000111111111111111100111100000000001111111111100001";
		
		wait for 40 ns;
		
		--Change from parents to children should not be possible while not enabled:
		enabled <='0';
		wait for 40 ns;
		parent1 <= "1111111111111111000000000000000011111111111111110000000000000000";
		parent2 <= "0000000000000000111111111111111100000000000000001111111111111111";
		
		wait for 40 ns;
		
		--Re-enabling should allow change:
		enabled <='1';
		wait for 40 ns;
		
		--Change in random-number should cause change in children:
		--(setting to 9, with ending bit-pattern 1001)
		random_number <= "00001111000011110000111100001001";
		
		wait for 40 ns;
		
		--Change from random number to children should not be possible while not enabled:
		enabled <='0';
		wait for 40 ns;
		--(setting to 18, with ending bit-pattern 10010)
		random_number <= "00001111000011110000111100010010";
		
		wait for 40 ns;
		
		--Re-enabling should allow change:
		enabled <='1';
		wait for 40 ns;
		
		--Parents and random should change multiple times without changing children while not enabled:
		enabled <='0';
		parent1 <= "1111000011110000111100001111000000000000000000000000000000000000";
		parent2 <= "0000111100001111000011110000111111111111111111111111111111111111";
		wait for 40 ns;
		
		random_number <= "00001111111111111111111111111111";
		wait for 40 ns;
		
		-- (Setting back to "Standard parents")
		parent1 <= "1111111111111111000000000000000011111111111111110000000000000000";
		parent2 <= "0000000000000000111111111111111100000000000000001111111111111111";
		wait for 40 ns;
		
		-- (Setting random back to 18)
		random_number <= "00001111000011110000111100010010";
		wait for 40 ns;
		
		--Parents with equal bits in crossover-slots should produce same bits in same slots in both children:
		enabled <= '1';
		
		--(1111 set in bits 3-0, and 0000 set in bits 11-8)
		parent1 <= "1111111111111111000000000000000011111111111111110000000000001111";
		parent2 <= "0000000000000000111111111111111100000000000000001111000011111111";
		
		wait for 40 ns;
		
		--Going from bit number 0 to 63 for the next 64 tests:
		
		-- (Setting back to "Standard parents")
		parent1 <= "1111111111111111000000000000000011111111111111110000000000000000";
		parent2 <= "0000000000000000111111111111111100000000000000001111111111111111";
		
		random_number <= (31 downto 0 => '0');
		
		-- Number 00
		random_number <= "00000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 01
		random_number <= "00000000000000000000000000000001";
		wait for 40 ns;
		
		-- Number 02
		random_number <= "00000000000000000000000000000010";
		wait for 40 ns;
		
		-- Number 03
		random_number <= "00000000000000000000000000000011";
		wait for 40 ns;
		
		-- Number 04
		random_number <= "00000000000000000000000000000100";
		wait for 40 ns;
		
		-- Number 05
		random_number <= "00000000000000000000000000000101";
		wait for 40 ns;
		
		-- Number 06
		random_number <= "00000000000000000000000000000110";
		wait for 40 ns;
		
		-- Number 07
		random_number <= "00000000000000000000000000000111";
		wait for 40 ns;
		
		-- Number 08
		random_number <= "00000000000000000000000000001000";
		wait for 40 ns;
		
		-- Number 09
		random_number <= "00000000000000000000000000001001";
		wait for 40 ns;
		
		-- Number 10
		random_number <= "00000000000000000000000000001010";
		wait for 40 ns;
		
		-- Number 11
		random_number <= "00000000000000000000000000001011";
		wait for 40 ns;
		
		-- Number 12
		random_number <= "00000000000000000000000000001100";
		wait for 40 ns;
		
		-- Number 13
		random_number <= "00000000000000000000000000001101";
		wait for 40 ns;
		
		-- Number 14
		random_number <= "00000000000000000000000000001110";
		wait for 40 ns;
		
		-- Number 15
		random_number <= "00000000000000000000000000001111";
		wait for 40 ns;
		
		-- Number 16
		random_number <= "00000000000000000000000000010000";
		wait for 40 ns;
		
		-- Number 17
		random_number <= "00000000000000000000000000010001";
		wait for 40 ns;
		
		-- Number 18
		random_number <= "00000000000000000000000000010010";
		wait for 40 ns;
		
		-- Number 19
		random_number <= "00000000000000000000000000010011";
		wait for 40 ns;
		
		-- Number 20
		random_number <= "00000000000000000000000000010100";
		wait for 40 ns;
		
		-- Number 21
		random_number <= "00000000000000000000000000010101";
		wait for 40 ns;
		
		-- Number 22
		random_number <= "00000000000000000000000000010110";
		wait for 40 ns;
		
		-- Number 23
		random_number <= "00000000000000000000000000010111";
		wait for 40 ns;
		
		-- Number 24
		random_number <= "00000000000000000000000000011000";
		wait for 40 ns;
		
		-- Number 25
		random_number <= "00000000000000000000000000011001";
		wait for 40 ns;
		
		-- Number 26
		random_number <= "00000000000000000000000000011010";
		wait for 40 ns;
		
		-- Number 27
		random_number <= "00000000000000000000000000011011";
		wait for 40 ns;
		
		-- Number 28
		random_number <= "00000000000000000000000000011100";
		wait for 40 ns;
		
		-- Number 29
		random_number <= "00000000000000000000000000011101";
		wait for 40 ns;
		
		-- Number 30
		random_number <= "00000000000000000000000000011110";
		wait for 40 ns;
		
		-- Number 31
		random_number <= "00000000000000000000000000011111";
		wait for 40 ns;
		
		-- Number 32
		random_number <= "00000000000000000000000000100000";
		wait for 40 ns;
		
		-- Number 33
		random_number <= "00000000000000000000000000100001";
		wait for 40 ns;
		
		-- Number 34
		random_number <= "00000000000000000000000000100010";
		wait for 40 ns;
		
		-- Number 35
		random_number <= "00000000000000000000000000100011";
		wait for 40 ns;
		
		-- Number 36
		random_number <= "00000000000000000000000000100100";
		wait for 40 ns;
		
		-- Number 37
		random_number <= "00000000000000000000000000100101";
		wait for 40 ns;
		
		-- Number 38
		random_number <= "00000000000000000000000000100110";
		wait for 40 ns;
		
		-- Number 39
		random_number <= "00000000000000000000000000100111";
		wait for 40 ns;
		
		-- Number 40
		random_number <= "00000000000000000000000000101000";
		wait for 40 ns;
		
		-- Number 41
		random_number <= "00000000000000000000000000101001";
		wait for 40 ns;
		
		-- Number 42
		random_number <= "00000000000000000000000000101010";
		wait for 40 ns;
		
		-- Number 43
		random_number <= "00000000000000000000000000101011";
		wait for 40 ns;
		
		-- Number 44
		random_number <= "00000000000000000000000000101100";
		wait for 40 ns;
		
		-- Number 45
		random_number <= "00000000000000000000000000101101";
		wait for 40 ns;
		
		-- Number 46
		random_number <= "00000000000000000000000000101110";
		wait for 40 ns;
		
		-- Number 47
		random_number <= "00000000000000000000000000101111";
		wait for 40 ns;
		
		-- Number 48
		random_number <= "00000000000000000000000000110000";
		wait for 40 ns;
		
		-- Number 49
		random_number <= "00000000000000000000000000110001";
		wait for 40 ns;
		
		-- Number 50
		random_number <= "00000000000000000000000000110010";
		wait for 40 ns;
		
		-- Number 51
		random_number <= "00000000000000000000000000110011";
		wait for 40 ns;
		
		-- Number 52
		random_number <= "00000000000000000000000000110100";
		wait for 40 ns;
		
		-- Number 53
		random_number <= "00000000000000000000000000110101";
		wait for 40 ns;
		
		-- Number 54
		random_number <= "00000000000000000000000000110110";
		wait for 40 ns;
		
		-- Number 55
		random_number <= "00000000000000000000000000110111";
		wait for 40 ns;
		
		-- Number 56
		random_number <= "00000000000000000000000000111000";
		wait for 40 ns;
		
		-- Number 57
		random_number <= "00000000000000000000000000111001";
		wait for 40 ns;
		
		-- Number 58
		random_number <= "00000000000000000000000000111010";
		wait for 40 ns;
		
		-- Number 59
		random_number <= "00000000000000000000000000111011";
		wait for 40 ns;
		
		-- Number 60
		random_number <= "00000000000000000000000000111100";
		wait for 40 ns;
		
		-- Number 61
		random_number <= "00000000000000000000000000111101";
		wait for 40 ns;
		
		-- Number 62
		random_number <= "00000000000000000000000000111110";
		wait for 40 ns;
		
		-- Number 63
		random_number <= "00000000000000000000000000111111";
		wait for 40 ns;
		
		-- Changes in other bits than bitnumber 5-0 should not matter
		random_number <= "11110000000000000000000000111111";
		wait for 40 ns;

      wait;
   end process;

END;