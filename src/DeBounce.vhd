
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
entity DeBounce is
    port (
        Clock : in STD_LOGIC;
        Reset : in STD_LOGIC;
        button_in : in STD_LOGIC;
        pulse_out : out STD_LOGIC
    );
end DeBounce;
architecture behav of DeBounce is
    constant COUNT_MAX : INTEGER := 50000000; --20000000 //50000000 //500000000
    constant BTN_ACTIVE : STD_LOGIC := '1';
    signal count : INTEGER := 0;
    type state_type is (idle, wait_time);
    signal state : state_type := idle;
begin
    process (Reset, Clock)
    begin
        if (Reset = '1') then
            state <= idle;
            pulse_out <= '0';
        elsif (rising_edge(Clock)) then
            case (state) is
                when idle =>
                    if (button_in = BTN_ACTIVE) then
                        state <= wait_time;
                    else
                        state <= idle;
                    end if;
                    pulse_out <= '0';
                when wait_time =>
                    if (count = COUNT_MAX) then
                        count <= 0;
                        if (button_in = BTN_ACTIVE) then
                            pulse_out <= '1';
                        end if;
                        state <= idle;
                    else
                        count <= count + 1;
                    end if;
            end case;
        end if;
    end process;
end architecture behav;
