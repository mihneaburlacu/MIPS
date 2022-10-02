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

entity InstructionDecode is
    Port ( clk : in std_logic;
           instr : in STD_LOGIC_VECTOR (15 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           rd1: out std_logic_vector(15 downto 0);
           rd2: out std_logic_vector(15 downto 0);
           ExtImm : out STD_LOGIC_VECTOR (15 downto 0);
           sa : out std_logic;
           func : out std_logic_vector(2 downto 0));
end InstructionDecode;

architecture Behavioral of InstructionDecode is

signal rs:std_logic_vector(3 downto 0);
signal rd:std_logic_vector(3 downto 0);
signal rt:std_logic_vector(3 downto 0);
signal wadr:std_logic_vector(3 downto 0);

component Reg_File is
    Port ( RA1 : in STD_LOGIC_VECTOR (3 downto 0);
           RA2 : in STD_LOGIC_VECTOR (3 downto 0);
           WA : in STD_LOGIC_VECTOR (3 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           WE : in STD_LOGIC;
           clk : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;

begin

rs <= "0"&Instr(12 downto 10);
rt <= "0"&Instr(9 downto 7);
rd <= "0"&Instr(6 downto 4);
wadr <=rt when RegDst = '0' else rd when RegDst = '1';
sa <= Instr(3);
func <= Instr(2 downto 0);
process(ExtOp)
        Begin 
            case ExtOp is
                     when '0' => ExtImm <= "000000000" & instr(6 downto 0);
                     when others => ExtImm(6 downto 0) <= instr(6 downto 0);     
                                    ExtImm(15 downto 7) <= (others=>instr(6));
            end case;
        end process;

RF: Reg_File port map(rs, rt, wadr, wd, RegWrite, clk, rd1, rd2);

end Behavioral;
