----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2022 04:23:24 PM
-- Design Name: 
-- Module Name: InstrucFile - Behavioral
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

entity InstrucFile is
    Port(
    clk : in STD_LOGIC;
    enable: in STD_LOGIC;
    reset: in STD_LOGIC;
    jump: in STD_LOGIC;
    pcsrc: in STD_LOGIC;
    jumpAddress: in STD_LOGIC_VECTOR(15 downto 0);
    branchAddress: in STD_LOGIC_VECTOR(15 downto 0);
    pc_after: out STD_LOGIC_VECTOR(15 downto 0);
    instruction: out STD_LOGIC_VECTOR(15 downto 0)
    );
end InstrucFile;

architecture Behavioral of InstrucFile is

signal pc : STD_LOGIC_VECTOR(15 downto 0);
signal mux_1 : STD_LOGIC_VECTOR(15 downto 0);
signal mux_2 : STD_LOGIC_VECTOR(15 downto 0);
signal pc_aux : STD_LOGIC_VECTOR(15 downto 0);

type array_memorie is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
signal ROM : array_memorie := (
b"001_000_001_0000101", --addi $1, $0, 5 -- 5
b"001_000_010_0000100", --addi $2, $0, 4 -- 4
b"000_001_010_011_0_010", --sub $3, $1, $2 -- 1
--b"011_000_011_0000001", --sw $3, 1($0)
--b"010_000_011_0000001", --lw $3, 1($0)
b"000_011_000_100_1_001", -- sll $4, $3, 1  -- 2
b"001_000_101_0000101", --addi $5, $0, 5 -- 5
b"001_101_110_0000011", --addi $6, $5, 3 -- 8
b"000_110_000_111_1_011", --srl $7, $6, 1 -- 4
b"000_100_111_001_0_000", --add $1, $4, $7 --  6
b"001_000_010_0000110", --addi $2, $0, 6 -- 6
b"100_010_001_0000011", --beq $1, $2, 3
b"001_000_010_0000001", --addi $2, $0, 1 -- 1
b"001_000_011_0000010", --addi $3, $0, 2 -- 2
b"000_010_011_000_0_110", --mult $2, $3 -- 2
b"000_010_011_100_0_100", --and $4, $2, $3 -- 0
b"001_000_001_0000100", --addi $1, $0, 4 -- 4
 
 others => "1111111111111111"
);

begin

pc_aux <= pc + 1;

mux_1 <= pc_aux when pcsrc = '0' else branchAddress;

mux_2 <= mux_1 when jump = '0' else jumpAddress;

process(clk, enable)
begin
    if rising_edge(clk) then 
  --  pc <= pc + 1;
        if reset = '1' then
            pc <= "0000000000000000";
        end if;
        if enable = '1' then
            pc <= mux_2;
        end if;
    end if;
end process;
        


pc_after <= pc + 1;

instruction <= ROM(conv_integer(pc(7 downto 0)));



end Behavioral;
