library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_sobel_x is 
    port(
        clk               : in STD_LOGIC;
        reset             : in STD_LOGIC;
        valid_data_1_in   : in STD_LOGIC;
        valid_data_2_in   : in STD_LOGIC;
        data_1_in         : in STD_LOGIC_VECTOR(7 downto 0);
        data_2_in         : in STD_LOGIC_VECTOR(7 downto 0);
        addr_in           : in STD_LOGIC_VECTOR(17 downto 0);
        "make" -f Makefile results.xml
make[1]: Entering directory '/home/lienard/Documents/SIFT_HDL/Src/Sobel/Sobel_x'
\
/snap/bin/ghdl -i --std=08  --workdir=sim_build --work=work /home/lienard/Documents/SIFT_HDL/Src/Sobel/Sobel_x/top_sobel_x.vhd /home/lienard/Documents/SIFT_HDL/Src/Sobel/Sobel_x/row_0/row_0.vhd /home/lienard/Documents/SIFT_HDL/Src/Sobel/Sobel_x/add/add.vhd && \
/snap/bin/ghdl -m --std=08  --workdir=sim_build -Psim_build --work=work top_sobel_x 
rm -f results.xml
COCOTB_TEST_MODULES=test_top_sobel_x COCOTB_TESTCASE= COCOTB_TEST_FILTER= COCOTB_TOPLEVEL=top_sobel_x TOPLEVEL_LANG=vhdl \
 /snap/bin/ghdl -r --std=08 --time-resolution=ps --workdir=sim_build -Psim_build --work=work top_sobel_x  --vpi=/home/lienard/anaconda3/lib/python3.9/site-packages/cocotb/libs/libcocotbvpi_ghdl.so --wave=wave.ghw  
loading VPI module '/home/lienard/anaconda3/lib/python3.9/site-packages/cocotb/libs/libcocotbvpi_ghdl.so'
     -.--ns INFO     gpi                                ..mbed/gpi_embed.cpp:93   in _embed_init_python              Using Python 3.9.19 interpreter at /home/lienard/anaconda3/bin/python
     -.--ns INFO     gpi                                ../gpi/GpiCommon.cpp:79   in gpi_print_registered_impl       VPI registered
VPI module loaded!
     0.00ns INFO     cocotb                             Running on GHDL version 3.0.0 (3.0.0.r0.g7de967c51) [Dunoon edition]
     0.00ns WARNING  gpi                                vpi_iterate returned NULL for type vpiInstance for object NULL
     0.00ns INFO     cocotb                             Seeding Python random module with 1759099129
     0.00ns INFO     cocotb                             Initialized cocotb v2.0.0 from /home/lienard/anaconda3/lib/python3.9/site-packages/cocotb
     0.00ns INFO     cocotb                             Running tests
     0.00ns INFO     cocotb.regression                  running test_top_sobel_x.test_add (1/1)
                                                            Test principal avec timeout global
###############
Iteration 0
###############
Value_1 : 81, Value_2 : 118
###############
Iteration 1
###############
Value_1 : 127, Value_2 : 104
###############
Iteration 2
###############
Value_1 : 104, Value_2 : 76
Sending data out request
   230.00ns WARNING  cocotb.Test test_add.test_add      top_sobel_x contains no child object named valid_data_out
                                                        Traceback (most recent call last):
                                                          File "/home/lienard/Documents/SIFT_HDL/Src/Sobel/Sobel_x/test_top_sobel_x.py", line 100, in test_add
                                                            await with_timeout(run_stimuli(dut), 1000, 'us')
                                                          File "/home/lienard/anaconda3/lib/python3.9/site-packages/cocotb/_extended_awaitables.py", line 411, in with_timeout
                                                            res = await First(timeout_timer, trigger)
                                                          File "/home/lienard/anaconda3/lib/python3.9/site-packages/cocotb/_extended_awaitables.py", line 203, in _wait
                                                            return completed[0].result()
                                                          File "/home/lienard/anaconda3/lib/python3.9/site-packages/cocotb/task.py", line 450, in result
                                                            return cast("Outcome[ResultType]", self._outcome).get()
                                                          File "/home/lienard/anaconda3/lib/python3.9/site-packages/cocotb/_outcomes.py", line 51, in get
                                                            raise self.error
                                                          File "/home/lienard/anaconda3/lib/python3.9/site-packages/cocotb/_extended_awaitables.py", line 73, in _wait_callback
                                                            return await trigger
                                                          File "/home/lienard/anaconda3/lib/python3.9/site-packages/cocotb/task.py", line 493, in __await__
                                                            return self.result()
                                                          File "/home/lienard/anaconda3/lib/python3.9/site-packages/cocotb/task.py", line 450, in result
                                                            return cast("Outcome[ResultType]", self._outcome).get()
                                                          File "/home/lienard/anaconda3/lib/python3.9/site-packages/cocotb/_outcomes.py", line 51, in get
                                                            raise self.error
                                                          File "/home/lienard/Documents/SIFT_HDL/Src/Sobel/Sobel_x/test_top_sobel_x.py", line 56, in run_stimuli
                                                            await with_timeout(RisingEdge(dut.valid_data_out), 600, 'ns')
                                                          File "/home/lienard/anaconda3/lib/python3.9/site-packages/cocotb/handle.py", line 484, in __getattr__
                                                            raise AttributeError(f"{self._path} contains no child object named {name}")
                                                        AttributeError: top_sobel_x contains no child object named valid_data_out
   230.00ns WARNING  cocotb.regression                  test_top_sobel_x.test_add failed
   230.00ns INFO     cocotb.regression                  **************************************************************************************
                                                        ** TEST                          STATUS  SIM TIME (ns)  REAL TIME (s)  RATIO (ns/s) **
                                                        **************************************************************************************
                                                        ** test_top_sobel_x.test_add      FAIL         230.00           0.00      78737.34  **
                                                        **************************************************************************************
                                                        ** TESTS=1 PASS=0 FAIL=1 SKIP=0                230.00           0.01      29679.11  **
                                                        **************************************************************************************
                                                        
make[1]: *** [/home/lienard/anaconda3/lib/python3.9/site-packages/cocotb_tools/makefiles/simulators/Makefile.ghdl:79: results.xml] Error 1
make[1]: Leaving directory '/home/lienard/Documents/SIFT_HDL/Src/Sobel/Sobel_x'
         : out STD_LOGIC;
        data_out          : out STD_LOGIC_VECTOR(13 downto 0);
        addr_out          : out STD_LOGIC_VECTOR(17 downto 0)    
    );
    end top_sobel_x;

architecture Behavioral of top_sobel_x is
    
    signal valid_out_row_0 : STD_LOGIC;
    signal valid_out_row_2 : STD_LOGIC;
    
    signal data_out_row_0  : STD_LOGIC_VECTOR(12 downto 0);
    signal data_out_row_2  : STD_LOGIC_VECTOR(12 downto 0);

    signal addr_out_row_0  : STD_LOGIC_VECTOR(17 downto 0);

begin

    row_0_inst : entity work.row_0
        port map(
            clk => clk,
            reset => reset,
            addr_in => addr_in,
            data_in => data_1_in,
            valid_in => valid_data_1_in,
            valid_out => valid_out_row_0,
            addr_out => addr_out_row_0,
            data_out => data_out_row_0
        );
    
    row_2_inst : entity work.row_0
       port map(
           clk => clk,
           reset => reset,
           addr_in => addr_in,
           data_in => data_2_in,
           valid_in => valid_data_2_in,
           valid_out => valid_out_row_2,
           addr_out => open, -- No used
           data_out => data_out_row_2
       );

    add_inst : entity work.add
        port map(
            clk => clk,
            reset => reset,
            valid_1 => valid_out_row_0,
            valid_2 => valid_out_row_2,
            data_1 => data_out_row_0,
            data_2 => data_out_row_2,
            addr_in => addr_out_row_0,
            valid_out => valid_out,
            result => data_out,
            addr_out => addr_out
        );

end Behavioral;
