----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2024 12:26:22 PM
-- Design Name: 
-- Module Name: average_calc - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity average_calc is
    port(clk: in std_logic;
         reset_gen: in std_logic;
         reset_avg: in std_logic;
         control: in std_logic_vector(2 downto 0);
         length: in std_logic_vector(2 downto 0);
         random_seq: out std_logic_vector (7 downto 0);
         avg: out std_logic_vector (7 downto 0));    
end average_calc;

architecture Behavioral of average_calc is
    signal D: std_logic_vector(7 downto 0);
    signal Q: std_logic_vector(7 downto 0);
    signal xor_value: std_logic;
    signal inter: std_logic;
    signal new_clk: std_logic;
    signal count: integer range 0 to 3 := 0;
    signal sum: unsigned (7 downto 0);
    signal avg_calc: unsigned (7 downto 0);
    signal DataIN: std_logic_vector (7 downto 0);
    signal count_sample: integer range 0 to 15 := 0;
begin
Sequence_Gen: process (clk, reset_gen)
    begin
        if reset_gen = '1' then
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
                    null;             
            end case;
        end if;
     end process Sequence_Gen;
     
D_FF: process(clk)
     begin
        if rising_edge(clk) then 
            if control = "001" then
                Q <= (others => new_clk);
            else
                Q <= D;
            end if;
        end if;
     end process D_FF;
     random_seq <= Q;

Average: process(clk, reset_avg)
        begin
            if rising_edge(clk) then
                if reset_avg = '1' then
                    avg <= (others => '0');
                    count <= 0;
                    sum <= (others => '0');
                else
                    count <= count + 1;
                    sum <= sum + unsigned(DataIN);
                    case length is
                        when "000" =>
                            null;
                        when "100" =>
                            if count = 2 then
                                avg_calc <= sum / 2;
                                avg <= std_logic_vector(avg_calc);
                                avg_calc <= (others => '0');
                                count <= 0;    
                            end if;
                        when "101" =>
                            if count = 4 then
                                avg_calc <= sum / 4;
                                avg <= std_logic_vector(avg_calc);
                                avg_calc <= (others => '0');
                                count <= 0;    
                            end if;
                        when "110" =>
                            if count = 8 then
                                avg_calc <= sum / 8;
                                avg <= std_logic_vector(avg_calc);
                                avg_calc <= (others => '0');
                                count <= 0;    
                            end if;
                        when "111" =>
                            if count = 15 then
                                avg_calc <= sum / 16;
                                avg <= std_logic_vector(avg_calc);
                                avg_calc <= (others => '0');
                                count <= 0;    
                            end if;
                        when others =>
                            null;
                    end case;
                end if;
            end if;
        end process Average;
end Behavioral;
