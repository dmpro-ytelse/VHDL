----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-11-04 13:42
-- Tested:   NA
--
-- Description:
-- Test bench for GeneticController
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GeneticController_TB is
end GeneticController_TB;

architecture Behavioral of GeneticController_TB is
    
    component GeneticController is
        port (
            RATED_RQ    : out STD_LOGIC;
            RATED_ACK   : in  STD_LOGIC;
            UNRATED_RQ  : out STD_LOGIC;
            UNRATED_ACK : in  STD_LOGIC;
            SEL_0_RUN   : out STD_LOGIC;
            SEL_0_DONE  : in  STD_LOGIC;
            SEL_1_RUN   : out STD_LOGIC;
            SEL_1_DONE  : in  STD_LOGIC;
            STORE       : out STD_LOGIC;
            ENABLE      : in  STD_LOGIC;
            CLK	        : in  STD_LOGIC
        );
    end component;
    
    -- Inputs
    signal RATED_ACK   : STD_LOGIC := '0';
    signal UNRATED_ACK : STD_LOGIC := '0';
    signal SEL_0_DONE  : STD_LOGIC := '0';
    signal SEL_1_DONE  : STD_LOGIC := '0';
    signal ENABLE      : STD_LOGIC := '0';
    
    -- Outputs
    signal RATED_RQ   : STD_LOGIC := '0';
    signal UNRATED_RQ : STD_LOGIC := '0';
    signal SEL_0_RUN  : STD_LOGIC := '0';
    signal SEL_1_RUN  : STD_LOGIC := '0';
    signal STORE      : STD_LOGIC := '0';
    
    -- Clock
    constant clock_period : time := 10 ns;
    signal clock : STD_LOGIC;
    
begin
    
    UUT : GeneticController
    port map (
        RATED_RQ    => RATED_RQ,
        RATED_ACK   => RATED_ACK,
        UNRATED_RQ  => UNRATED_RQ,
        UNRATED_ACK => UNRATED_ACK,
        SEL_0_RUN   => SEL_0_RUN,
        SEL_0_DONE  => SEL_0_DONE,
        SEL_1_RUN   => SEL_1_RUN,
        SEL_1_DONE  => SEL_1_DONE,
        STORE       => STORE,
        ENABLE      => ENABLE,
        CLK	        => clock
    );
    
    CLOCK_SYNTHESIS : process
    begin
        clock <= '1';
        wait for clock_period/2;
        clock <= '0';
        wait for clock_period/2;
    end process;
    
    STIMULUS : process
    begin
        -- Hold reset state
        wait for 3 ns;
        wait for clock_period*10;
        
        -- Enable
        ENABLE <= '1';
        
        -- Wait for rated access
        wait for clock_period*3;
        
        -- Give access
        RATED_ACK <= '1';
        wait for clock_period;
        RATED_ACK <= '0';
        
        -- Prevent controller from restarting
        ENABLE <= '0';
        
        -- <Fetch and compare genes>
        wait for clock_period*8;
        
        -- Selectors are done
        SEL_0_DONE <= '1';
        SEL_1_DONE <= '1';
        
        -- Wait for unrated access
        wait for clock_period*3;
        
        -- Give access
        UNRATED_ACK <= '1';
        wait for clock_period;
        UNRATED_ACK <= '0';
        
        wait;
    end process;
    
end Behavioral;

