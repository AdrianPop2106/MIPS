----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2021 01:49:39 PM
-- Design Name: 
-- Module Name: IF - Behavioral
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

entity Fetch is
    Port ( en : in STD_LOGIC;
           reset : in STD_LOGIC;
           jump : in STD_LOGIC;
           clk: in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           PC4 : out STD_LOGIC_VECTOR (15 downto 0);
           Instruction : out STD_LOGIC_VECTOR (15 downto 0);
           jumpAddress : in STD_LOGIC_VECTOR (15 downto 0);
           branchAddress : in STD_LOGIC_VECTOR (15 downto 0));
end Fetch;

architecture Behavioral of Fetch is
type instructiuni is array(0 to 255) of STD_LOGIC_VECTOR (15 downto 0);
signal rom:instructiuni:=(
0=>b"001_000_001_0010100", -- addi $1,$0,20 se stocheaza in cazul acesta 20 ca si descazut
1=>b"000_000_000_010_0_000", -- add $2,$0,$0 se stocheaza indexul locatiei din memorie
2=>b"000_000_000_011_0_000", -- add $3,$0,$0 se initializeaza cu 0 numarul de iteratii
3=>b"110_001_000_0000110", -- bltz $1,6 se va sarii peste 6 instructiuni daca valoarea din registrul $1 scade sub 0
4=>b"010_010_100_0000001", -- lw $4,1($2) se aduce elementul curent din sir
5=>b"000_001_100_001_0_001", -- sub $1,$1,$4 se scade valoarea din registrul $1 cu valoarea din registrul $4
6=>b"001_011_011_0000001", -- addi $3,$3,1 se incrementeaza numarul de scaderi realizate
7=>b"001_010_010_0000001", --addi $2,$2,1 se trece la urmatorul element din sir
8=>b"111_0000000000011", -- j 3 se sare inapoi la inceputul buclei
9=>b"000_001_011_001_0_101", --or $1,$1,$3 se realizeaza operatia de SAU pe biti intre descazut si numarul de scaderi realizate
others=>x"9999"
);
signal address:STD_LOGIC_VECTOR(15 downto 0);
signal ins:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal next_ins:STD_LOGIC_VECTOR(15 downto 0);

begin
 
 process(clk,reset)
 begin
    if reset='1' then
        ins<=x"0000";
    elsif rising_edge(clk)then 
        if en='1' then  
            ins<=next_ins;
        end if;
    end if;
 end process;
 Instruction<=rom(conv_integer(ins));
 PC4<=ins+1;
 address<= ins+1 when PCSrc='0' else branchAddress;
 next_ins<= jumpAddress when jump='1' else address;
 
end Behavioral;
