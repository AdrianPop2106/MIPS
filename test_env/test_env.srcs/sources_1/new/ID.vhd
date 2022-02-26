----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2021 11:45:48 AM
-- Design Name: 
-- Module Name: Decode - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decode is
    Port ( clk : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (15 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           enable:in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           Ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end Decode;

architecture Behavioral of Decode is
signal wa:STD_LOGIC_VECTOR(2 downto 0);

component Bloc_de_registre is
    Port ( ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           we: in STD_LOGIC;
           RegWrite: in STD_LOGIC;
           clk: in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;

begin
 rf:Bloc_de_registre port map(instr(12 downto 10),instr(9 downto 7),wa,wd,enable,RegWrite,clk,rd1,rd2);
 wa<=instr(9 downto 7) when RegDst='0' else instr(6 downto 4);
 func<=instr(2 downto 0);
 sa<=instr(3);
 process(Instr,ExtOp)
 begin
    if ExtOp='1' and Instr(6)='1'  then
        Ext_Imm<="111111111" & Instr(6 downto 0);
   else
        Ext_Imm<="000000000" & Instr(6 downto 0);
    end if;
 end process;
end Behavioral;
