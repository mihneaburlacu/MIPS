----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2022 04:47:54 PM
-- Design Name: 
-- Module Name: mips - Behavioral
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

entity mips is
Port ( btn : in STD_LOGIC_VECTOR (4 downto 0);
           clk : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end mips;

architecture Behavioral of mips is

component SSD is
    Port ( Digit : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component MPG is
    Port (btn : in STD_LOGIC;
          clk : in STD_LOGIC;
          enable : out STD_LOGIC);
end component;

component InstrucFile is
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
end component;

component InstructionDecode is
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
end component;

component controlUnit is
    Port (
            instr: in std_logic_vector(2 downto 0);
            RegDst: out std_logic;
            ExtOp: out std_logic;
            ALUSrc: out std_logic;
            Branch: out std_logic;
            Jump: out std_logic;
            ALUOp: out std_logic_vector(2 downto 0);
            MemWrite: out std_logic;
            MemToReg: out std_logic;
            RegWrite: out std_logic
            );
end component;

component unitate_executie is
    Port (
        RD1: in STD_LOGIC_VECTOR(15 downto 0);
        RD2: in STD_LOGIC_VECTOR(15 downto 0);
        Ext_imm: in STD_LOGIC_VECTOR(15 downto 0);
        pc_after: in STD_LOGIC_VECTOR(15 downto 0);
        func: in std_logic_vector(2 downto 0);
        sa: in STD_LOGIC;
        ALUSrc: in STD_LOGIC;
        ALUOp: in STD_LOGIC_VECTOR(2 downto 0);
        Zero: out STD_LOGIC;
        ALURes: out STD_LOGIC_VECTOR(15 downto 0);
        BranchAddress: out STD_LOGIC_VECTOR(15 downto 0)   
     );
end component;

component memory_unit is
    Port (
        clk: in std_logic;
        MemWrite: in std_logic;
        ALUResIn: in std_logic_vector(15 downto 0);
        WriteData: in std_logic_vector(15 downto 0);
        MemData: out std_logic_vector(15 downto 0);
        ALUResOut: out std_logic_vector(15 downto 0)
     );
end component;

signal enable_MPG1 : STD_LOGIC;
signal enable_MPG2 : STD_LOGIC;
signal enable1 : STD_LOGIC;
signal enable2 : STD_LOGIC;
signal jumpAddress : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal branchAddress : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal pc_after: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal instruction: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal out_ssd : std_logic_vector(15 downto 0) := "0000000000000000";
signal wdRF : STD_LOGIC_VECTOR (15 downto 0);
signal ExtImm : STD_LOGIC_VECTOR (15 downto 0);
signal rd1RF: std_logic_vector(15 downto 0);
signal rd2RF: std_logic_vector(15 downto 0);
signal sa : std_logic;
signal func : std_logic_vector(2 downto 0);
signal RegDst : STD_LOGIC;
signal ExtOp : STD_LOGIC;
signal RegWrite : STD_LOGIC;
signal ALUSrc: STD_LOGIC;
signal ALUOp: STD_LOGIC_VECTOR(2 downto 0);
signal Branch: STD_LOGIC;
signal Jump: STD_LOGIC;
signal MemWrite: STD_LOGIC;
signal MemtoReg: STD_LOGIC;
signal zero: STD_LOGIC;
signal ALURes: STD_LOGIC_VECTOR(15 downto 0);
signal ALUResOut: STD_LOGIC_VECTOR(15 downto 0);
signal MemData: STD_LOGIC_VECTOR(15 downto 0);
signal pcsrc: STD_LOGIC;

begin

monopulse1: MPG port map(btn(0), clk, enable_MPG1);
monopulse2: MPG port map(btn(1), clk, enable_MPG2);
insfile: InstrucFile port map(clk, enable_MPG1, enable_MPG2, Jump, pcsrc, jumpAddress, branchAddress, pc_after, instruction); 
sevenSeg: SSD port map(out_ssd, clk, cat, an);
insDec: InstructionDecode port map(clk, instruction, wdRF, RegWrite, RegDst, ExtOp, rd1RF, rd2RF, ExtImm, sa, func);
control_unit: controlUnit port map(instruction(15 downto 13), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemToReg, RegWrite);
ALU: unitate_executie port map(rd1RF, rd2RF, ExtImm, pc_after, func, sa, ALUSrc, ALUOp, zero, ALURes, branchAddress);
memoryUnit: memory_unit port map(clk, MemWrite, ALURes, rd2RF, MemData, ALUResOut);

--rw <= RegWrite and btn(1);
--mw <= MemWrite and btn(1);
wdRF <= ALUResOut when MemToReg = '0' else MemData;
pcsrc <= Branch and zero;
jumpAddress <= "000" & instruction(12 downto 0);

process(sw(7 downto 5))
begin
    case sw(7 downto 5) is
        when "000" => out_ssd <= instruction;
        when "001" => out_ssd <= pc_after;
        when "010" => out_ssd <= rd1RF;
        when "011" => out_ssd <= rd2RF;
        when "100" => out_ssd <= ExtImm;
        when "101" => out_ssd <= ALURes;
        when "110" => out_ssd <= MemData;
        when "111" => out_ssd <= wdRF;
    end case;
end process;

led(15) <= RegDst;
led(14) <= ExtOp;
led(13) <= ALUSrc;
led(12) <= Branch;
led(11) <= Jump;
led(10 downto 8) <= ALUOp;
led(7) <= MemWrite;
led(6) <= MemToReg;
led(5) <= RegWrite;

--out_ssd <= instruction when sw(7) = '0' else pc_after;

end Behavioral;
