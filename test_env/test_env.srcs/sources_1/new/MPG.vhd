----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2021 07:52:09 PM
-- Design Name: 
-- Module Name: MPG - Behavioral
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

entity MPG is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
signal cnt: STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal Q1,Q2,Q3: STD_LOGIC:='0';

begin
process(clk)
begin
   if clk='1' and clk'event then
         cnt <= cnt + 1;
      end if;
end process;

process(clk)
begin
  if clk='1' and clk'event then
    if cnt=x"FFFF" then
       Q1<=btn;
     end if;
    end if;
end process;
  
process(clk)
begin
  if clk='1' and clk'event then
    Q2<=Q1;
    Q3<=Q2;
    end if;
end process;
  
enable <=Q2 and (not Q3);
end Behavioral;
