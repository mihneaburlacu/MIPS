----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2022 04:27:19 PM
-- Design Name: 
-- Module Name: unitate_executie - Behavioral
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

entity unitate_executie is
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
end unitate_executie;

architecture Behavioral of unitate_executie is

signal ALUCtrl: STD_LOGIC_VECTOR(2 downto 0);
signal outMux: STD_LOGIC_VECTOR(15 downto 0);
signal outAlu: STD_LOGIC_VECTOR(15 downto 0);
signal addOp: STD_LOGIC_VECTOR(15 downto 0);
signal subOp: STD_LOGIC_VECTOR(15 downto 0);
signal shiftLeft: STD_LOGIC_VECTOR(15 downto 0);
signal shiftRight: STD_LOGIC_VECTOR(15 downto 0);
signal andOP: STD_LOGIC_VECTOR(15 downto 0);
signal orOp: STD_LOGIC_VECTOR(15 downto 0);
signal mult: STD_LOGIC_VECTOR(15 downto 0);
signal xorOp: STD_LOGIC_VECTOR(15 downto 0);

begin

outMux <= RD2 when ALUSrc = '0' else Ext_imm;

process(ALUOp)
begin
    case ALUOp is
    when "000" =>
        case func is
        when "000" => ALUCtrl <=  "000"; --add
        when "010" => ALUCtrl <= "001"; --sub
        when "001" => ALUCtrl <= "010"; --sll
        when "011" => ALUCtrl <= "011"; --srl
        when "100" => ALUCtrl <= "100"; --and
        when "101" => ALUCtrl <= "101"; --or
        when "110" => ALUCtrl <= "110"; -- mult
        when others => ALUCtrl <= "111"; --xor
        end case;
    when "001" => ALUCtrl <= "000"; --add
    when "010" => ALUCtrl <= "000";
    when "011" => ALUCtrl <= "000";
    when "100" => ALUCtrl <= "001"; --sub
    when "101" => ALUCtrl <= "100"; --and
    when "110" => ALUCtrl <= "101"; --or
    when others => ALUCtrl <= "000";
    end case;
end process;

addOp <= RD1 + outMux;
subOp <= RD1 - outMux;
shiftLeft <= RD1(14 downto 0) & "0" when sa = '1';
shiftRight <= "0" & RD1(15 downto 1) when sa = '1';
andOp <= RD1 and outMux;
orOp <= RD1 or outMux;
mult <= RD1(7 downto 0) * outMux(7 downto 0);
xorOp <= RD1 xor outMux;

process(ALUCtrl)
begin
    case ALUCtrl is
        when "000" => outAlu <= addOp;
        when "001" => outAlu <= subOp;
        when "010" => outAlu <= shiftLeft;
        when "011" => outAlu <= shiftRight;
        when "100" => outAlu <= andOp;
        when "101" => outAlu <= orOp;
        when "110" => outAlu <= mult;
        when others => outAlu <= xorOp;
     end case;
end process;

ALURes <= outAlu;

Zero <= '1' when outAlu = x"0000"  else '0'; 

BranchAddress <= Ext_imm + pc_after;
        
end Behavioral;
