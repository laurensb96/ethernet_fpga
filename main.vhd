-- Copyright (C) 2023  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library altera;
use altera.altera_syn_attributes.all;

entity main is
	generic
	(
		CLK_FREQ : integer := 125e6
	);
	port
	(
-- {ALTERA_IO_BEGIN} DO NOT REMOVE THIS LINE!

		altera_reserved_tck : in std_logic;
		altera_reserved_tdi : in std_logic;
		altera_reserved_tdo : out std_logic;
		altera_reserved_tms : in std_logic;
		CLK : in std_logic;
		ENET_MDC : out std_logic;
		ENET_MDIO : inout std_logic;
		LED0 : out std_logic;
		LED1 : out std_logic;
		LED2 : out std_logic;
		LED3 : out std_logic;
		RGMII_RXCLK : in std_logic;
		RGMII_RXCTL : in std_logic;
		RGMII_RXD : in std_logic_vector(3 downto 0)
-- {ALTERA_IO_END} DO NOT REMOVE THIS LINE!

	);

-- {ALTERA_ATTRIBUTE_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_ATTRIBUTE_END} DO NOT REMOVE THIS LINE!
end main;

architecture ppl_type of main is

-- {ALTERA_COMPONENTS_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_COMPONENTS_END} DO NOT REMOVE THIS LINE!
signal sigLED : std_logic_vector(3 downto 0) := (others => '0');
signal rx_data: std_logic_vector(7 downto 0) := (others => '0');
signal rx_status : std_logic_vector(1 downto 0) := (others => '0');
signal rx_clock : std_logic := '0';

component RGMII_RX IS
	PORT
	(
		datain		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		inclock		: IN STD_LOGIC ;
		dataout_h		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		dataout_l		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
END component RGMII_RX;
component mdio is
port
(
	ENET_MDC				: out std_logic;
	ENET_MDIO 			: inout std_logic;
	CLK					: in std_logic;
	
	DIAG					: out std_logic_vector(3 downto 0)
);
end component mdio;
begin
-- {ALTERA_INSTANTIATION_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_INSTANTIATION_END} DO NOT REMOVE THIS LINE!

u2:rgmii_rx port map(RGMII_RXD, RGMII_RXCLK, rx_data(3 downto 0), rx_data(7 downto 4));
u3:mdio port map(ENET_MDC, ENET_MDIO, CLK, sigLED);

--rx_process:process(RGMII_RXCLK)
--begin
--if(rising_edge(RGMII_RXCLK)) then
--	if(rx_data = x"FF") then
--		sigLED <= "1111";
--	end if;
--end if;
--end process;

 LED0 <= not sigLED(0);
 LED1 <= not sigLED(1);
 LED2 <= not sigLED(2);
 LED3 <= not sigLED(3);
end;









