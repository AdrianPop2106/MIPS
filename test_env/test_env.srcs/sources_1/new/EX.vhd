----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2021 03:33:53 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Execute is
    Port ( RD1 : in STD_LOGIC_VECTOR(15 downto 0);
           ALUSrc : in STD_LOGIC;
           RD2 : in STD_LOGIC_VECTOR(15 downto 0);
           ext_imm : in STD_LOGIC_VECTOR(15 downto 0);
           PC1 : in STD_LOGIC_VECTOR(15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR(2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR(2 downto 0);
           Zero : out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR(15 downto 0);
           branch_address:out STD_LOGIC_VECTOR(15 downto 0));
end Execute;

architecture Behavioral of Execute is
signal Op:STD_LOGIC_VECTOR(2 downto 0):="XXX";
signal ALUCtrl: STD_LOGIC_VECTOR(3 downto 0);
signal term1,term2,res: STD_LOGIC_VECTOR (15 downto 0);
begin
 term1<=rd1;
 term2<=rd2 when ALUSrc='0' else ext_imm;
 branch_address<=PC1+ext_imm;
 Op<=ALUOp;
 process(Op,func)
 begin
  if Op="000" then --tip R
     ALUCtrl<='0' & func;
  elsif Op="001" then
    ALUCtrl<="0000"; --(addi)
  elsif Op="010" then
    ALUCtrl<="0000";--lw
  elsif Op="011" then
    ALUCtrl<="0000";--sw
  elsif Op="100" then
    ALUCtrl<="0001";--(beq)
  elsif Op="101" then
    ALUCtrl<="1000";--(bgez)
  elsif Op<="110" then
    ALUCtrl<="1001";--(bltz)
  else ALUCtrl<="XXXX"; --inexistent
  end if;
 end process;
 
 process(rd1,rd2,term1,term2,sa,ALUCtrl)
 variable temp:STD_LOGIC_VECTOR(15 downto 0):=term1;
 variable nr:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
  begin
     case ALUCtrl is
         when "0000" => res<=term1+term2;
         when "0001" => res<=term1-term2;
         when "0010" => if sa='1' then res<=term1(14 downto 0) & '0'; end if;
         when "0011" => if sa='1' then res<='0' & term1(15 downto 1); end if;
         when "0100" => res<= term1 and term2;
         when "0101" => res<= term1 or term2;
         when "0110" => res<= term1 xor term2;
         when "0111" => res<=conv_std_logic_vector((conv_integer(term1) / conv_integer(term2)),16);
         when others=> null;
     end case;
 end process;
  ALURes<=res;
 process(ALUCtrl)
 begin
  if (ALUCtrl="0001" and res=x"0000") or (ALUCtrl="1000" and conv_integer(term1)>=0) or (ALUCtrl="1001" and conv_integer(term1)<0) then
    zero<='1';--beq,bgez,bltz
  else
    zero<='0';
  end if;
 end process;
 
end Behavioral;
