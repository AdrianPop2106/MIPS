----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2021 08:37:27 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
    Port ( MemWrite : in STD_LOGIC;
           clk:in STD_LOGIC;
           enable:in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0));
end MEM;

architecture Behavioral of MEM is
type memory is array(0 to 128) of STD_LOGIC_VECTOR (15 downto 0);
signal ram:memory:=(
0=>x"0000",
1=>x"0001",
2=>x"0002",
3=>x"0003",
4=>x"0004",
5=>x"0005",
6=>x"0006",
7=>x"0007",
8=>x"0008",
others=>x"0000"
);
begin
process(clk)
  begin
    if rising_edge(clk) then -- RAM
            if enable='1' then
                if MemWrite='1' then
                    ram(conv_integer(ALURes))<=rd2; 
                end if;
            end if;
       end if;
  end process;
 MemData<=ram(conv_integer(ALURes));
end Behavioral;
