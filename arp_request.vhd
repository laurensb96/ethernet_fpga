----------------------------------------------------------------------------------
-- Company: LBEngineering
-- Engineer: Laurens Buijs
-- 
-- Create Date: 10/08/2023 12:05:00 PM
-- Design Name: 
-- Module Name: arp_request - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: creates an ARP Request message, when provided with:
-- Source MAC address, source IPv4 address
-- Target MAC address, target IPv4 address
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package array_pack is
    type arp_payload is array (0 to 27) of std_logic_vector(7 downto 0);
    type mac_address is array (0 to 5) of std_logic_vector(7 downto 0);
    type ipv4_address is array (0 to 3) of std_logic_vector(7 downto 0);
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.array_pack.all;

entity arp_request is
    Port ( 
        clk, reset, enable :    in std_logic;
        SHA :                   in mac_address;
        SPA :                   in ipv4_address;
        THA :                   in mac_address;
        TPA :                   in ipv4_address;
        output :                out arp_payload
    );
end arp_request;

architecture Behavioral of arp_request is
constant SHA_OFFSET : integer := 8;
constant SPA_OFFSET : integer := 14;
constant THA_OFFSET : integer := 18;
constant TPA_OFFSET : integer := 24;

begin

-- functionally, the process outputs the data similar to an SR-flipflop with dominant reset
proc_request:process(clk)
variable varHTYPE, varPTYPE : std_logic_vector(15 downto 0);
variable varHLEN, varPLEN : std_logic_vector(7 downto 0);
variable varOPER : std_logic_vector(15 downto 0);
variable varSHA, varTHA : mac_address;
variable varSPA, varTPA : ipv4_address;
variable varOutput : arp_payload := (others => x"00");
begin
if(rising_edge(clk)) then
    if(reset = '1') then
        varOutput(0 to 27) := (others => x"00");
    elsif(enable = '1') then
        varHTYPE := x"0001"; -- Ethernet hardware
        varPTYPE := x"0800"; -- IPv4 protocol
        varHLEN := x"06"; -- MAC address length
        varPLEN := x"04"; -- IP address length
        varOPER := x"0001"; -- ARP Request
        
        varSHA := SHA; -- source MAC address
        varSPA := SPA; -- source IPv4 address
        varTHA := THA;
        varTPA := TPA;
        
        varOutput(0) := varHTYPE(15 downto 8);
        varOutput(1) := varHTYPE(7 downto 0);
        varOutput(2) := varPTYPE(15 downto 8);
        varOutput(3) := varPTYPE(7 downto 0);
        varOutput(4) := varHLEN;
        varOutput(5) := varPLEN;
        varOutput(6) := varOPER(15 downto 8);
        varOutput(7) := varOPER(7 downto 0);
        
        for i in 0 to 5 loop                    -- copy 6 address bytes
            varOutput(SHA_OFFSET+i) := varSHA(i);  -- set SHA
            varOutput(THA_OFFSET+i) := varTHA(i);  -- set THA
        end loop;
        for i in 0 to 3 loop                    -- copy 6 address bytes
            varOutput(SPA_OFFSET+i) := varSPA(i);  -- set SPA
            varOutput(TPA_OFFSET+i) := varTPA(i);  -- set TPA
        end loop;
    end if;
output <= varOutput;
end if;
end process;

end Behavioral;
