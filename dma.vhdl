library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dma is
	port(
		clk : in std_logic;
		snesreset : in std_logic;

		regrd, regwr : in std_logic;
		regaddr : in unsigned(3 downto 0);
		regin: in unsigned(7 downto 0);
		regout : out unsigned(7 downto 0);
		
		dmaaddr : out unsigned(22 downto 0);

		txstart : in std_logic;
		romen, memmode, memstart : out std_logic
	);
end dma;

architecture main of dma is
	signal mode : std_logic;
begin
	process
	begin
		wait until rising_edge(clk);
		
		if regwr = '1' then
			case to_integer(regaddr) is
			when 0 =>
				mode <= regin(0);
				romen <= not regin(1);
			when 1 =>
				dmaaddr(15 downto 8) <= regin;
			when 2 =>
				dmaaddr(22 downto 16) <= regin(6 downto 0);
			when others =>
			end case;
		end if;
		if snesreset = '0' then
			romen <= '1';
		end if;
	end process;
	
	memmode <= mode;
	dmaaddr(7 downto 0) <= (others => '0');
	memstart <= txstart when mode = '1' else '0';
end main;