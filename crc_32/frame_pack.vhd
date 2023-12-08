library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package FRAME_PACK is
	constant N : integer := 1600;
	type DATA_MAT is array (0 to N-1) of std_logic_vector(7 downto 0);
	type DATA_ARR is array (0 to N*8-1) of std_logic;
	type CRC32_ARR is array (0 to 255) of std_logic_vector (31 downto 0);
end package FRAME_PACK;