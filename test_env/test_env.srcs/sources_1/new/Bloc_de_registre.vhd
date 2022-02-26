----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/16/2021 04:31:05 PM
-- Design Name: 
-- Module Name: Bloc_de_registre - Behavioral
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

entity Bloc_de_registre is
    Port ( ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           we: in STD_LOGIC;
           RegWrite: in STD_LOGIC;
           clk: in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end Bloc_de_registre;

architecture Behavioral of Bloc_de_registre is

type registru_array is array(0 to 15) of STD_LOGIC_VECTOR (15 downto 0);
signal registru_bloc:registru_array:=(
0=>x"0000",
1=>x"0015",
2=>x"0033",
3=>x"0003",
4=>x"0028",
5=>x"0038",
6=>x"0027",
7=>x"0013",
8=>x"0002",
others=>"XXXXXXXXXXXXXXXX"
);

begin
 rd1<=registru_bloc(conv_integer(ra1));
 rd2<=registru_bloc(conv_integer(ra2));

  process(clk)
   begin
   if rising_edge(clk) then -- bloc de registre
          if we='1' then
            if RegWrite='1' then
                registru_bloc(conv_integer(wa))<=wd;
            end if;
       end if;
    end if;
  end process;
end Behavioral;
