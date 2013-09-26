----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:08:41 09/21/2013 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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

library WORK;
use WORK.ALU_CONSTANTS.ALL;

-- NOTE: UNTESTED!

entity ALU is
	
	generic(N : integer := 64);
	
	port(
		X		:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		Y		:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		R		:	out	STD_LOGIC_VECTOR(N-1 downto 0);
		FUNC	:	in	STD_LOGIC_VECTOR(3 downto 0);
		FLAGS	:	out ALU_FLAGS
	);
	
end ALU;

architecture Behavioral of ALU is
	
	component Adder is
		generic (N : integer := 64);
		port (
			A			:	in	STD_LOGIC_VECTOR(N-1 downto 0);
			B			:	in	STD_LOGIC_VECTOR(N-1 downto 0);
			R			:	out	STD_LOGIC_VECTOR(N-1 downto 0);
			CARRY_IN	:	in	STD_LOGIC;
			OVERFLOW	:	out	STD_LOGIC
		);
	end component;
	
	-- Adder signals
	signal add_a		:	STD_LOGIC_VECTOR(N-1 downto 0);
	signal add_b		:	STD_LOGIC_VECTOR(N-1 downto 0);
	signal add_carry_in	:	STD_LOGIC;
	signal add_overflow	:	STD_LOGIC;
	
	-- Result signals
	signal r_addsub	:	STD_LOGIC_VECTOR(N-1 downto 0);
	--signal r_mul	:	STD_LOGIC_VECTOR(N-1 downto 0);
	signal r_and	:	STD_LOGIC_VECTOR(N-1 downto 0);
	signal r_or		:	STD_LOGIC_VECTOR(N-1 downto 0);
	signal r_xor	:	STD_LOGIC_VECTOR(N-1 downto 0);
	
	-- Other signals
	signal y_new	:	STD_LOGIC_VECTOR(N-1 downto 0);
	signal result	:	STD_LOGIC_VECTOR(N-1 downto 0);
	
begin
	
	ADDER_SUBTRACTOR : Adder
	generic map (N => N)
	port map(
		A			=> X,
		B			=> y_new,
		R			=> r_addsub,
		CARRY_IN	=> add_carry_in,
		OVERFLOW	=> add_overflow
	);
	
	-- TODO: Multiplier!
	
	INVERT_Y : process(Y, FUNC)
	begin
		if FUNC = ALU_FUNC_SUB then
			y_new <= not Y;
			add_carry_in <= '1';
		else
			y_new <= Y;
			add_carry_in <= '0';
		end if;		
	end process INVERT_Y;
	
	LOGICS : process(X, Y, FUNC)
	begin
		r_and		<=	X and Y;
		r_or		<=	X or Y;
		r_xor		<=	X xor Y;
	end process LOGICS;
	
	--RESULTIFIER : process(FUNC, r_addsub, r_mul, r_and, r_or, r_xor)
	RESULTIFIER : process(FUNC, r_addsub, r_and, r_or, r_xor)
	begin
		case FUNC is
			when ALU_FUNC_ADD	=>	result <= r_addsub;
			when ALU_FUNC_SUB	=>	result <= r_addsub;
			--when ALU_FUNC_MUL	=>	result <= r_mul;
			when ALU_FUNC_AND	=>	result <= r_and;
			when ALU_FUNC_OR	=>	result <= r_or;
			when ALU_FUNC_XOR	=>	result <= r_xor;
			when others			=>	result <= ZERO64;
		end case;
	end process RESULTIFIER;
	
	-- TODO: Overflow!
	
	FLAGS.Positive	<= '1' when not (result = ZERO64) and result(N-1) = '0' else '0';
	FLAGS.Zero		<= '1' when result = ZERO64 else '0';
	FLAGS.Negative	<= '1' when result(N-1) = '1' else '0';
	
	R <= result;
	
end Behavioral;

