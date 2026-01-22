library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity second is
  port
    (
        clk, reset, up : in  std_ulogic;        -- Register control
        load       : in  std_ulogic;        -- Load signal
        inp        : in  std_ulogic_vector(3 downto 0);  -- Start value
        count      : out std_ulogic_vector(3 downto 0);  -- Count value
        max_count  : out std_ulogic;         -- Maximum count flag
        min_count : out std_ulogic          -- Minimum count flag
    );
end second;

-- The architecture below describes a 4-bit up counter. When the counter
-- reaches its maximum value, the signal max_count is activated.

architecture RTL of second is
    --  Declarative region
    signal next_count : u_unsigned(3 downto 0);
    signal increment : u_unsigned (3 downto 0) := "0000";
begin
    --  Statement region
    -- Combinational logic used for register input
    -- (two's complement is eff'ing wacky, but legal) 
    increment <= 
        "0001" when up = '1' else 
        "1111";
    
    -- (increment OR decrement depending on 'up')
    next_count <= 
        unsigned(inp) when load = '1' else
        unsigned(count) + increment;

    REGISTERS: process (clk) is
    begin
        -- Synchronous reset
        if rising_edge(clk) then
            count <= 
                (others => '0') when reset else 
                std_logic_vector(next_count);
        end if;
    end process;

    -- Concurrent signal assignment
    max_count <= 
        '1' when count = "1111" else 
        '0';
        
    min_count <=
        '1' when count = "0000" else
        '0';
end RTL;
