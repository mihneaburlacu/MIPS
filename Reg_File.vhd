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

entity Reg_File is
    Port ( RA1 : in STD_LOGIC_VECTOR (3 downto 0);
           RA2 : in STD_LOGIC_VECTOR (3 downto 0);
           WA : in STD_LOGIC_VECTOR (3 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           WE : in STD_LOGIC;
           clk : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0));
end Reg_File;

architecture Behavioral of Reg_File is

type memorie is array (0 to 15) of std_logic_vector (15 downto 0);

signal mem: memorie := (
0=> "0000000000000000",
others => x"1111"
);

begin

RD1<=mem(conv_integer(RA1));
RD2<=mem(conv_integer(RA2));

process(clk,WE) 
 begin
 if rising_edge(clk) then
    if WE = '1' then
        mem(conv_integer(WA))<= WD;
    end if;
 end if;
end process;
 
end Behavioral;