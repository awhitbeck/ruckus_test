#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/data/Xilinx/Vitis/2022.2/bin:/data/Xilinx/Vivado/2022.2/ids_lite/ISE/bin/lin64:/data/Xilinx/Vivado/2022.2/bin
else
  PATH=/data/Xilinx/Vitis/2022.2/bin:/data/Xilinx/Vivado/2022.2/ids_lite/ISE/bin/lin64:/data/Xilinx/Vivado/2022.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/awhitbe1/LDMX_fw/ARTY_UART/firmware/build/ARTY_A7_100/ARTY_A7_100_project.runs/synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log GPIO_demo.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source GPIO_demo.tcl
