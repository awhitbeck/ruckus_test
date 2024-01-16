# 
# Report generation script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
namespace eval ::optrace {
  variable script "/home/awhitbe1/LDMX_fw/ARTY_UART/firmware/build/ARTY_A7_100/ARTY_A7_100_project.runs/impl_1/GPIO_demo.tcl"
  variable category "vivado_impl"
}

# Try to connect to running dispatch if we haven't done so already.
# This code assumes that the Tcl interpreter is not using threads,
# since the ::dispatch::connected variable isn't mutex protected.
if {![info exists ::dispatch::connected]} {
  namespace eval ::dispatch {
    variable connected false
    if {[llength [array get env XILINX_CD_CONNECT_ID]] > 0} {
      set result "true"
      if {[catch {
        if {[lsearch -exact [package names] DispatchTcl] < 0} {
          set result [load librdi_cd_clienttcl[info sharedlibextension]] 
        }
        if {$result eq "false"} {
          puts "WARNING: Could not load dispatch client library"
        }
        set connect_id [ ::dispatch::init_client -mode EXISTING_SERVER ]
        if { $connect_id eq "" } {
          puts "WARNING: Could not initialize dispatch client"
        } else {
          puts "INFO: Dispatch client connection id - $connect_id"
          set connected true
        }
      } catch_res]} {
        puts "WARNING: failed to connect to dispatch server - $catch_res"
      }
    }
  }
}
if {$::dispatch::connected} {
  # Remove the dummy proc if it exists.
  if { [expr {[llength [info procs ::OPTRACE]] > 0}] } {
    rename ::OPTRACE ""
  }
  proc ::OPTRACE { task action {tags {} } } {
    ::vitis_log::op_trace "$task" $action -tags $tags -script $::optrace::script -category $::optrace::category
  }
  # dispatch is generic. We specifically want to attach logging.
  ::vitis_log::connect_client
} else {
  # Add dummy proc if it doesn't exist.
  if { [expr {[llength [info procs ::OPTRACE]] == 0}] } {
    proc ::OPTRACE {{arg1 \"\" } {arg2 \"\"} {arg3 \"\" } {arg4 \"\"} {arg5 \"\" } {arg6 \"\"}} {
        # Do nothing
    }
  }
}

proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    } elseif { [info exist ::env(HOST)] } {
      set host $::env(HOST)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
OPTRACE "impl_1" END { }
}

set_msg_config  -id {Synth 8-256}  -suppress 
set_msg_config  -id {Synth 8-5545}  -suppress 
set_msg_config  -id {Synth 8-5546}  -suppress 
set_msg_config  -id {Opt   31-422}  -suppress 
set_msg_config  -id {HDL 9-2216}  -suppress 
set_msg_config  -id {HDL 9-1061}  -suppress 
set_msg_config  -id {Runs 36-5}  -suppress 
set_msg_config  -id {VRFC 10-163}  -suppress 
set_msg_config  -id {VRFC 10-165}  -suppress 
set_msg_config  -id {Simtcl 6-16}  -suppress 
set_msg_config  -id {Simtcl 6-17}  -suppress 
set_msg_config  -id {Synth 8-113}  -suppress 
set_msg_config  -id {Constraints 18-4434}  -suppress 
set_msg_config  -id {Drc 23-20}  -suppress 
set_msg_config  -id {DRC CHECK-3}  -suppress 
set_msg_config  -id {DRC DPIP-1}  -suppress 
set_msg_config  -id {DRC DPOP-1}  -suppress 
set_msg_config  -id {DRC DPOP-2}  -suppress 
set_msg_config  -id {DRC LOCE-1}  -suppress 
set_msg_config  -id {DRC RTSTAT-10}  -suppress 
set_msg_config  -id {DRC REQP-1839}  -suppress 
set_msg_config  -id {DRC REQP-1840}  -suppress 
set_msg_config  -id {Synth 8-226}  -suppress 
set_msg_config  -id {Drc REQP-1857]}  -suppress 
set_msg_config  -id {Drc REQP-1858]}  -suppress 
set_msg_config  -id {DRC REQP-181}  -suppress 
set_msg_config  -id {DRC REQP-52}  -suppress 
set_msg_config  -id {BD 41-434}  -suppress 
set_msg_config  -id {Designutils 20-1318}  -suppress 
set_msg_config  -id {Common 17-301}  -suppress 
set_msg_config  -id {Pwropt 34-142}  -suppress 
set_msg_config  -id {Common 17-1361}  -suppress 
set_msg_config  -id {Vivado 12-4430}  -suppress 
set_msg_config  -id {Synth 8-312}  -suppress 
set_msg_config  -id {Vivado 12-1790}  -suppress 
set_msg_config  -id {Vivado 12-3645}  -suppress 
set_msg_config  -id {Project 1-486}  -suppress 
set_msg_config  -id {Project 1-560}  -suppress 
set_msg_config  -id {Designutils 20-1307}  -suppress 
set_msg_config  -id {filemgmt 56-12}  -suppress 
set_msg_config  -id {Vivado 12-5470}  -suppress 
set_msg_config  -id {Project 1-841}  -suppress 
set_msg_config  -id {Project 1-863}  -suppress 
set_msg_config  -id {Project 1-840}  -suppress 
set_msg_config  -id {Synth 8-4472}  -suppress 
set_msg_config  -id {Timing 38-3}  -new_severity {INFO} 
set_msg_config  -id {Synth 8-3848}  -new_severity {INFO} 
set_msg_config  -id {Synth 8-3936}  -new_severity {INFO} 
set_msg_config  -id {Synth 8-5733}  -new_severity {INFO} 
set_msg_config  -id {Synth 8-5858}  -new_severity {INFO} 
set_msg_config  -id {Constraints 18-550}  -new_severity {INFO} 
set_msg_config  -id {Vivado 12-1008}  -new_severity {INFO} 
set_msg_config  -id {Power 33-332}  -new_severity {INFO} 
set_msg_config  -id {Synth 8-3512}  -new_severity {ERROR} 
set_msg_config  -id {VRFC 10-664}  -new_severity {ERROR} 
set_msg_config  -id {Synth 8-4480}  -suppress 
set_msg_config  -id {filemgmt 20-1318}  -new_severity {ERROR} 
set_msg_config  -id {IP_Flow 19-1663}  -new_severity {ERROR} 
set_msg_config  -id {IP_Flow 19-11772}  -new_severity {ERROR} 
set_msg_config  -id {Vivado 12-508}  -new_severity {CRITICAL WARNING} 
set_msg_config  -id {Vivado 12-507}  -new_severity {CRITICAL WARNING} 
set_msg_config  -id {Vivado 12-627}  -new_severity {CRITICAL WARNING} 
set_msg_config  -id {Project 1-498}  -new_severity {CRITICAL WARNING} 
set_msg_config  -id {Synth 8-3330}  -new_severity {CRITICAL WARNING} 
set_msg_config  -id {Synth 8-3919}  -new_severity {CRITICAL WARNING} 
set_msg_config  -id {Synth 8-153}  -new_severity {CRITICAL WARNING} 
set_msg_config  -id {Synth 8-3331}  -suppress 
set_msg_config  -id {Synth 8-3295}  -new_severity {CRITICAL WARNING} 
set_msg_config  -id {Synth 8-5835}  -new_severity {CRITICAL WARNING} 
set_msg_config  -id {Route 35-328}  -new_severity {CRITICAL WARNING} 
set_msg_config  -id {Vivado 12-4430}  -new_severity {WARNING} 
set_msg_config  -id {Vivado 12-1387}  -new_severity {WARNING} 
set_msg_config  -id {BD 41-968}  -new_severity {WARNING} 
set_msg_config  -id {Vivado 12-1411}  -new_severity {ERROR} 
set_msg_config  -id {HDL 9-806}  -new_severity {ERROR} 
set_msg_config  -id {Opt 31-80}  -new_severity {ERROR} 
set_msg_config  -id {Route 35-14}  -new_severity {ERROR} 
set_msg_config  -id {Synth 8-3332}  -suppress 
set_msg_config  -id {AVAL-46}  -new_severity {ERROR} 
set_msg_config  -id {Timing 38-282}  -new_severity {ERROR} 
set_msg_config  -id {Common 17-356}  -new_severity {WARNING} 
set_msg_config  -id {Synth 8-6859}  -new_severity {ERROR} 
set_msg_config  -id {Synth 8-3352}  -new_severity {ERROR} 
set_msg_config  -id {MDRV-1}  -new_severity {ERROR} 
set_msg_config  -id {Synth 8-3848}  -new_severity {CRITICAL WARNING} 
set_msg_config  -id {Synth 8-327}  -new_severity {CRITICAL WARNING} 
set_msg_config  -id {Synth 8-614}  -new_severity {CRITICAL WARNING} 
set_msg_config  -id {Synth 8-5544}  -suppress 

OPTRACE "impl_1" START { ROLLUP_1 }
OPTRACE "Phase: Write Bitstream" START { ROLLUP_AUTO }
OPTRACE "write_bitstream setup" START { }
start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  set_param chipscope.maxJobs 8
  open_checkpoint GPIO_demo_routed.dcp
  set_property webtalk.parent_dir /home/awhitbe1/LDMX_fw/ARTY_UART/firmware/build/ARTY_A7_100/ARTY_A7_100_project.cache/wt [current_project]
OPTRACE "Write Bitstream: pre hook" START { }
  set src_rc [catch { 
    puts "source /home/awhitbe1/LDMX_fw/ARTY_UART/firmware/submodules/ruckus/vivado/messages.tcl"
    source /home/awhitbe1/LDMX_fw/ARTY_UART/firmware/submodules/ruckus/vivado/messages.tcl
  } _RESULT] 
  if {$src_rc} { 
    set tool_flow [get_property -quiet TOOL_FLOW [current_project -quiet]]
    if { $tool_flow eq {SDx} } { 
      send_gid_msg -id 2 -ssname VPL_TCL -severity ERROR $_RESULT
      send_gid_msg -id 3 -ssname VPL_TCL -severity ERROR "sourcing script /home/awhitbe1/LDMX_fw/ARTY_UART/firmware/submodules/ruckus/vivado/messages.tcl failed"
    } else {
      send_msg_id runtcl-1 status "$_RESULT"
      send_msg_id runtcl-2 status "sourcing script /home/awhitbe1/LDMX_fw/ARTY_UART/firmware/submodules/ruckus/vivado/messages.tcl failed"
    }
    return -code error
  }
OPTRACE "Write Bitstream: pre hook" END { }
set_property TOP GPIO_demo [current_fileset]
OPTRACE "read constraints: write_bitstream" START { }
OPTRACE "read constraints: write_bitstream" END { }
  set_property XPM_LIBRARIES {XPM_FIFO XPM_MEMORY} [current_project]
  catch { write_mem_info -force -no_partial_mmi GPIO_demo.mmi }
OPTRACE "write_bitstream setup" END { }
OPTRACE "write_bitstream" START { }
  write_bitstream -force GPIO_demo.bit 
OPTRACE "write_bitstream" END { }
OPTRACE "write_bitstream misc" START { }
OPTRACE "read constraints: write_bitstream_post" START { }
OPTRACE "read constraints: write_bitstream_post" END { }
OPTRACE "Write Bitstream: post hook" START { }
  set src_rc [catch { 
    puts "source /home/awhitbe1/LDMX_fw/ARTY_UART/firmware/submodules/ruckus/vivado/run/post/gui_write.tcl"
    source /home/awhitbe1/LDMX_fw/ARTY_UART/firmware/submodules/ruckus/vivado/run/post/gui_write.tcl
  } _RESULT] 
  if {$src_rc} { 
    set tool_flow [get_property -quiet TOOL_FLOW [current_project -quiet]]
    if { $tool_flow eq {SDx} } { 
      send_gid_msg -id 2 -ssname VPL_TCL -severity ERROR $_RESULT
      send_gid_msg -id 3 -ssname VPL_TCL -severity ERROR "sourcing script /home/awhitbe1/LDMX_fw/ARTY_UART/firmware/submodules/ruckus/vivado/run/post/gui_write.tcl failed"
    } else {
      send_msg_id runtcl-1 status "$_RESULT"
      send_msg_id runtcl-2 status "sourcing script /home/awhitbe1/LDMX_fw/ARTY_UART/firmware/submodules/ruckus/vivado/run/post/gui_write.tcl failed"
    }
    return -code error
  }
OPTRACE "Write Bitstream: post hook" END { }
  catch {write_debug_probes -quiet -force GPIO_demo}
  catch {file copy -force GPIO_demo.ltx debug_nets.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

OPTRACE "write_bitstream misc" END { }
OPTRACE "Phase: Write Bitstream" END { }
OPTRACE "impl_1" END { }
