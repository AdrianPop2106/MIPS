----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2021 09:17:47 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

signal digits,PC4,Instruction,rd1,rd2,Ext_Imm,wd,branchA,ALURes,MemData: STD_LOGIC_VECTOR (15 downto 0);--Fetch --MIPS
signal jumpA:STD_LOGIC_VECTOR(15 downto 0);
signal func:STD_LOGIC_VECTOR(2 downto 0);
signal ALUOp:STD_LOGIC_VECTOR(2 downto 0);
signal en1,en2,PCSrc,RegDst,ExtOp,ALUSrc,Branch,jump,MemWrite,MemtoReg,RegWrite,sa,zero:STD_LOGIC;

component MPG is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digit : in STD_LOGIC_VECTOR (15 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component Bloc_de_registre is
    Port ( ra1 : in STD_LOGIC_VECTOR (3 downto 0);
           ra2 : in STD_LOGIC_VECTOR (3 downto 0);
           wa : in STD_LOGIC_VECTOR (3 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           we: in STD_LOGIC;
           clk: in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component Fetch is
    Port ( en : in STD_LOGIC;
           reset : in STD_LOGIC;
           jump : in STD_LOGIC;
           clk: in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           PC4 : out STD_LOGIC_VECTOR (15 downto 0);
           Instruction : out STD_LOGIC_VECTOR (15 downto 0);
           jumpAddress : in STD_LOGIC_VECTOR (15 downto 0);
           branchAddress : in STD_LOGIC_VECTOR (15 downto 0));
end component;

component Decode is
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
end component;

component Execute is
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
end component;

component MEM is
    Port ( MemWrite : in STD_LOGIC;
           clk:in STD_LOGIC;
           enable:in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0));
end component;

begin
m1: MPG port map(btn=>btn(0),clk=>clk,enable=>en1);
m2: MPG port map(btn=>btn(1),clk=>clk,enable=>en2);
f:Fetch port map(en1,en2,jump,clk,PCSrc,PC4,Instruction,jumpA,branchA);
d:Decode port map(clk,Instruction,wd,en1,RegWrite,RegDst,ExtOp,rd1,rd2,Ext_imm,func,sa);
e:Execute port map(rd1,ALUSrc,rd2,Ext_imm,PC4,sa,func,ALUOp,zero,ALURes,branchA);
me:MEM port map(MemWrite,clk,en1,ALURes,rd2,MemData);
  
  wd<=ALURes when MemtoReg='0' else MemData;--write back
  jumpA<="000" & Instruction(12 downto 0);
  PCSrc<=zero and Branch;
 process(Instruction)
 begin
    RegDst<='0';
    ExtOp<='0';
    ALUSrc<='0';
    Branch<='0';
    jump<='0';
    ALUOp<="000";
    MemWrite<='0';
    MemtoReg<='0';
    RegWrite<='0';
    
    case (instruction(15 downto 13)) is
        when "000"=>--tip R
            RegDst<='1';
            RegWrite<='1';
            ALUOp<="000";
        when "001"=>--addi
            ExtOp<='1';
            ALUSrc<='1';
            RegWrite<='1';
            ALUOp<="001";
        when "010"=>--lw
            ExtOp<='1';
            ALUSrc<='1';
            RegWrite<='1';
            MemtoReg<='1';
            ALUOp<="010";
        when "011"=>--sw
            ALUSrc<='1';
            ExtOp<='1';
            MemWrite<='1';
            ALUOp<="011";
        when "100"=>--beq
            ExtOp<='1';
            Branch<='1';
            ALUOp<="100";
        when "101"=>--bgez
            ExtOp<='1';
            Branch<='1';
            ALUOp<="101";
        when "110"=>--bltz
            ExtOp<='1';
            Branch<='1';
            ALUOp<="110";
        when "111"=>--jump
            jump<='1';
        when others=>
            RegDst<='X';
            ExtOp<='X';
            ALUSrc<='X';
            Branch<='X';
            jump<='X';
            ALUOp<="XXX";
            MemWrite<='X';
            MemtoReg<='X';
            RegWrite<='X';
    end case; 
 end process;  

s: SSD port map(clk,digits,cat,an);

 process(sw(7 downto 5),Instruction,PC4,rd1,rd2,wd,Ext_Imm,MemData,ALURes)
 begin
    case (sw(7 downto 5)) is
        when "000"=>
            digits<=Instruction;
        when "001"=>
            digits<=PC4;
        when "010"=>
            digits<=rd1;
        when "011"=>
            digits<=rd2;
        when "100"=>
            digits<=Ext_imm;
        when "101"=>
            digits<=ALURes;
        when "110"=>
            digits<=MemData;
        when "111"=>
            digits<=wd;
        when others => digits<=x"9999";
    end case;
 end process;
 led(0)<=RegDst;
 led(1)<= ExtOp;
 led(2)<=ALUSrc;
 led(3)<=Branch;
 led(4)<=jump;
 led(5)<=MemWrite;
 led(6)<=MemtoReg;
 led(7)<=RegWrite;
end behavioral;