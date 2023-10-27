library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library altera;
use altera.altera_syn_attributes.all;

entity MDIO is
port
(
	ENET_MDC 				: out std_logic;
	ENET_MDIO				: inout std_logic;
	CLK						: in std_logic;
	
	DIAG						: out std_logic_vector(3 downto 0)
);
end MDIO;

architecture behavioral of mdio is
type DATA_MAT is array (0 to 11) of std_logic_vector(15 downto 0);
type ADDR_MAT is array (0 to 11) of std_logic_vector(7 downto 0);
type RW_STATE is (READ, WRITE);
type RW_VEC is array (0 to 11) of RW_STATE;
signal TX_DATA, RX_DATA : DATA_MAT;
signal ADDR : ADDR_MAT;
signal RW_SEL : RW_VEC;
begin

TX_DATA(0) <= "1011000000000000";
ADDR(0) <= x"17";
RW_SEL(0) <= WRITE;

TX_DATA(1) <= "0000000000000101";
ADDR(1) <= x"1B";
RW_SEL(1) <= WRITE;

TX_DATA(2) <= "ZZZZZZZZZZZZZZZZ";
ADDR(2) <= x"18";
RW_SEL(2) <= READ;

DIAG <= RX_DATA(2)(7 downto 6) & RX_DATA(2)(1 downto 0);

p_transport:process(clk)
variable t, i, p : integer := 0;

constant PREAMBLE 					: std_logic_vector(31 downto 0) 	:= (others => '1');
constant ST								: std_logic_vector(1 downto 0) 	:= "01";
constant PHY_ADDR 					: std_logic_vector(4 downto 0) 	:= "00000";
variable FRAME							: std_logic_vector(63 downto 0) 	:= (others => '0');
variable OP, TA						: std_logic_vector(1 downto 0);

constant N_t : integer := 1000; 	-- division factor for incoming CLK signal (100 MHz -> 100 kHz)
constant N_f : integer := 64; 	-- length of MDIO frame
constant N_p : integer := 3;		-- number of packets to be read/written

begin
if(rising_edge(clk)) then
	if(p < N_p) then
		if(t = 0 and i = 0) then
			if(RW_SEL(p) = READ) then
				OP := "10";
				TA := "ZZ";
			else
				OP := "01";
				TA := "10";
			end if;
			FRAME := PREAMBLE & ST & OP & PHY_ADDR & ADDR(p)(4 downto 0) & TA & TX_DATA(p);
		end if;
		
		-- data read/write
		if(t = N_t/4-1) then											-- halfway before rising edge, set up data
			ENET_MDIO <= FRAME(N_f-1-i);
			if((i >= 48 AND i < N_f) AND OP = "10") then		-- reading from the PHY
				RX_DATA(p)(N_f-1-i) <= ENET_MDIO;
			end if;
		end if;
		
		-- indexing logic
		if(t = N_t-1 and i = N_f-1) then
			p := p + 1;
			t := 0;
			i := 0;
		elsif(t = N_t-1) then
			t := 0;
			i := i + 1;
		else
			t := t + 1;
		end if;
	end if;
end if;
end process;

p_clk:process(clk) is
variable t : integer := 0;
constant N_t : integer := 1000; 	-- division factor for incoming CLK signal (100 MHz -> 100 kHz)
begin
if(rising_edge(clk)) then
	-- clock generator
	if(t = 0) then											
		ENET_MDC <= '0';
	elsif(t = N_t/2) then
		ENET_MDC <= '1';
	end if;
	if(t = N_t-1) then
		t := 0;
	else
		t := t + 1;
	end if;
end if;
end process;
end behavioral;