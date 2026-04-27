`include "uvm_macros.svh"
import uvm_pkg::*;

class base_driver extends uvm_driver;
  `uvm_component_utils(base_driver)

  function new(string name = "base_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass

class child_driver_1 extends base_driver;
  `uvm_component_utils(child_driver)

  function new(string name = "child_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

class base_agent extends uvm_agent;
  `uvm_component_utils(base_agent)

  base_driver base_driver_h;

  function new(string name = "base_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    base_driver_h = base_driver::type_id::create("base_driver_h", this);
  endfunction
endclass

class child_agent extends base_agent;
  `uvm_component_utils(child_agent)

  function new(string name = "child_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

class env extends uvm_env;
  `uvm_component_utils(env)

  base_agent base_agent_h;

  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    base_agent_h = base_agent::type_id::create("base_agent_h", this);
    super.build_phase(phase);
  endfunction

endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  env env_h;

  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    uvm_factory factory = uvm_factory::get();

    // set_type_override_by_type(base_agent::get_type(), child_agent::get_type());
    // set_type_override_by_type(base_driver::get_type(), child_driver::get_type());

    `ifdef DRV1
    set_inst_override_by_type("env_h.base_agent_h", base_driver::get_type(), child_driver_1::get_type());
    `elsif DRV2
    set_inst_override_by_type("env_h.base_agent_h", base_driver::get_type(), child_driver_2::get_type());
    `endif


    env_h = env::type_id::create("env_h", this);

    super.build_phase(phase);
    
    factory.print();
  endfunction

endclass

module top;
  initial begin
    run_test("test");
  end
endmodule
