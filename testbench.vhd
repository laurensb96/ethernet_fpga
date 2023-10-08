----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/07/2023 08:49:33 PM
-- Design Name: 
-- Module Name: testbench - Behavioral
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
use IEEE.numeric_std.ALL;

use work.array_pack.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench is
--  Port ( );
end testbench;

architecture Behavioral of testbench is
component arp_request is
    Port ( 
        clk, reset, enable :   in std_logic;
        SHA :           in mac_address;
        SPA :           in ipv4_address;
        THA :           in mac_address;
        TPA :           in ipv4_address;
        output :        out arp_payload
    );
end component arp_request;
signal sigCLK, sigRESET, sigENABLE : std_logic := '0';
signal sigSHA : mac_address := (others => x"00");
signal sigSPA : ipv4_address := (others => x"00");
signal sigTHA : mac_address := (others => x"00");
signal sigTPA : ipv4_address := (others => x"00");
signal sigOUTPUT : arp_payload;
begin
add_arp_instance: component arp_request
    port map (
        clk => sigCLK,
        reset => sigRESET,
        enable => sigENABLE,
        SHA => sigSHA,
        SPA => sigSPA,
        THA => sigTHA,
        TPA => sigTPA, 
        output => sigOUTPUT
    );
    
clk_process: process
begin
sigCLK <= '0';
wait for 10 ns;
sigCLK <= '1';
wait for 10 ns;
end process;

reset_process: process
begin
sigRESET <= '0';
sigENABLE <= '0';
wait for 50 ns;
sigRESET <= '1';
wait for 50 ns;
sigRESET <= '0';
sigENABLE <= '1';
wait for 50 ns;
sigENABLE <= '0';
wait for 200 ns;
sigRESET <= '1';
wait;
end process;

sigSHA(0) <= x"00";
sigSHA(1) <= x"DA";
sigSHA(2) <= x"00";
sigSHA(3) <= x"DA";
sigSHA(4) <= x"FF";
sigSHA(5) <= x"FE";

sigSPA(0) <= std_logic_vector(to_unsigned(192, 8));
sigSPA(1) <= std_logic_vector(to_unsigned(168, 8));
sigSPA(2) <= std_logic_vector(to_unsigned(2, 8));
sigSPA(3) <= std_logic_vector(to_unsigned(10, 8));

sigTPA <= sigSPA;
end Behavioral;
