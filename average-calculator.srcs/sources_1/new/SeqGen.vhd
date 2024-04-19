----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2024 12:32:36 PM
-- Design Name: 
-- Module Name: SeqGen - Behavioral
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
use IEEE.Std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity SeqGen is
    port(clk: in std_logic;
         reset : in std_logic;
         Control: in std_logic_vector(2 downto 0);
         random_seq: out std_logic_vector (7 downto 0));
end SeqGen;

architecture Behavioral of SeqGen is
    signal D: std_logic_vector(7 downto 0);
    signal Q: std_logic_vector(7 downto 0);
    signal xor_value: std_logic;
    signal inter: std_logic;
    signal new_clk: std_logic;
    signal count: integer range 0 to 3 := 0;
begin
    process (clk, reset)
    begin
        if reset = '1' then
            D <= (others => '0'); 
        elsif rising_edge(clk) then
            case control is 
                when "000" => 
                random_seq <= "00000000";
                
                when "001" =>
                    if count = 3 then 
                        count <= 0;
                        new_clk <= not new_clk;
                    else
                        count <= count + 1;
                    end if;
                
                when "010" =>
                   Q(7) <= '0';
                   Q(6) <= '0'; 
                   Q(5) <= '0'; 
                   Q(4) <= '0'; 
                   Q(3) <= '0'; 
                   Q(2) <= '0'; 
                   Q(1) <= '0'; 
                   Q(0) <= '0'; 
                when "011" =>
                   Q(7) <= '0';
                   Q(6) <= '0'; 
                   Q(5) <= '0'; 
                   Q(4) <= '0'; 
                   Q(3) <= '0'; 
                   Q(2) <= '0'; 
                   Q(1) <= '0'; 
                   Q(0) <= '0'; 
                
                when "110" =>
                    Q(4) <= '0';
                    Q(5) <= '0';
                    Q(6) <= '0';
                    Q(7) <= '0';
                    xor_value <= Q(0) xor Q(3);
                    D(0) <= xor_value;
               
                when "111" =>
                    xor_value <= Q(1) xor Q(2);
                    inter <= xor_value;
                    xor_value <= Q(3) xor Q(7);
                    xor_value <= xor_value xor inter;
                    D(0) <= xor_value;
                
                when others =>
                    random_seq <= "00000000"; 
            
            end case;
        end if;
     end process;
     
     process(clk)
     begin
        if rising_edge(clk) then 
            if control = "001" then
                Q <= (others => new_clk);
            else
                Q <= D;
            end if;
        end if;
     end process;
     random_seq <= Q;
end Behavioral;
