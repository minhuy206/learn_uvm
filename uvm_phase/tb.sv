`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
  `uvm_component_utils(driver)

  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("BUILD_PHASE", "BUILD PHASE CALLED FROM DRIVER COMPONENT", UVM_LOW);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("CONNECT_PHASE", "CONNECT PHASE CALLED FROM DRIVER COMPONENT", UVM_LOW)
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    `uvm_info("END_OF_ELABORATION_PHASE", "END OF ELABORATION PHASE CALLED FROM DRIVER COMPONENT", UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);

    `uvm_info("RUN PHASE", "RUN PHASE OBJECTION CALLED FROM DRIVER COMPONENT", UVM_LOW);

    #10;

    phase.drop_objection(this);
    `uvm_info("RUN PHASE", "RUN PHASE DROP OBJECTION CALLED FROM DRIVER COMPONENT", UVM_LOW);


    `uvm_info("RUN PHASE", "RUN PHASE CALLED FROM DRIVER COMPONENT", UVM_LOW);
  endtask
endclass

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  function new(string name = "monitor", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("BUILD_PHASE", "BUILD PHASE CALLED FROM MONITOR COMPONENT", UVM_LOW);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("CONNECT_PHASE", "CONNECT PHASE CALLED FROM MONITOR COMPONENT", UVM_LOW)
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    `uvm_info("END_OF_ELABORATION_PHASE", "END OF ELABORATION PHASE CALLED FROM MONITOR COMPONENT", UVM_LOW)
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);

    `uvm_info("RUN PHASE", "RUN PHASE OBJECTION CALLED FROM MONITOR COMPONENT", UVM_LOW);

    #50;

    phase.drop_objection(this);
    `uvm_info("RUN PHASE", "RUN PHASE DROP OBJECTION CALLED FROM MONITOR COMPONENT", UVM_LOW);

    `uvm_info("RUN PHASE", "RUN PHASE CALLED FROM MONITOR COMPONENT", UVM_LOW);
  endtask
endclass


class agent extends uvm_agent;
  `uvm_component_utils(agent)

  driver driver_h;
  monitor monitor_h;
  function new(string name = "agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("BUILD_PHASE", "BUILD PHASE CALLED FROM AGENT COMPONENT", UVM_LOW);

    driver_h = driver::type_id::create("driver_h", this);
    monitor_h = monitor::type_id::create("monitor_h", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("CONNECT_PHASE", "CONNECT PHASE CALLED FROM AGENT COMPONENT", UVM_LOW)
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    `uvm_info("END_OF_ELABORATION_PHASE", "END OF ELABORATION PHASE CALLED FROM AGENT COMPONENT", UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    `uvm_info("RUN PHASE", "RUN PHASE CALLED FROM AGENT COMPONENT", UVM_LOW);
  endtask
endclass

class env extends uvm_env;
  `uvm_component_utils(env)

  agent agent_h;
  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("BUILD_PHASE", "BUILD PHASE CALLED FROM ENV COMPONENT", UVM_LOW);

    agent_h = agent::type_id::create("agent_h", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("CONNECT_PHASE", "CONNECT PHASE CALLED FROM ENV COMPONENT", UVM_LOW)
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    `uvm_info("END_OF_ELABORATION_PHASE", "END OF ELABORATION PHASE CALLED FROM ENV COMPONENT", UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    `uvm_info("RUN PHASE", "RUN PHASE CALLED FROM ENV COMPONENT", UVM_LOW);
  endtask
endclass

class test extends uvm_test;
  `uvm_component_utils(test)

  env env_h;
  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("BUILD_PHASE", "BUILD PHASE CALLED FROM TEST COMPONENT", UVM_LOW);

    env_h = env::type_id::create("env_h", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("CONNECT_PHASE", "CONNECT PHASE CALLED FROM TEST COMPONENT", UVM_LOW)
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    `uvm_info("END_OF_ELABORATION_PHASE", "END OF ELABORATION PHASE CALLED FROM TEST COMPONENT", UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    `uvm_info("RUN PHASE", "RUN PHASE CALLED FROM TEST COMPONENT", UVM_LOW);
  endtask
endclass

module top;
  initial begin
    run_test("test");
  end
endmodule