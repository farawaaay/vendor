@echo off
set xv_path=E:\\Xilinx\\Vivado\\2015.2\\bin
call %xv_path%/xsim fsm_sim_behav -key {Behavioral:sim_1:Functional:fsm_sim} -tclbatch fsm_sim.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
