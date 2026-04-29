`include "uvm_macros.svh"
import uvm_pkg::*;

class class_a extends uvm_component;
  `uvm_component_utils(class_a)

  function new(string name = "class_a", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void display();
    `uvm_info(get_type_name(), "inside class a", UVM_LOW)
  endfunction
endclass

class class_c extends uvm_component;
  `uvm_component_utils(class_c)

  function new(string name = "class_c", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void display();
    `uvm_info(get_type_name(), "inside class c", UVM_LOW)
  endfunction
endclass

class class_b extends uvm_component;
  `uvm_component_utils(class_b)

  class_c cc;
  int ctrl;

  function new(string name = "class_b", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(int)::get(this, "", "control", ctrl))
      `uvm_fatal(get_type_name(), "get function failed")

    if (ctrl) cc = class_c::type_id::create("cc", this);

    cc.display();
  endfunction

  function void display();
    `uvm_info(get_type_name(), "inside class b", UVM_NONE)
  endfunction
endclass

class env extends uvm_env;
  `uvm_component_utils(env)

  class_a ca;

  class_b cb;

  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    ca = class_a::type_id::create("ca", this);
    cb = class_b::type_id::create("cb", this);
  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)

  int ctrl   = 1;

  env env_h;

  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env_h = env::type_id::create("env_h", this);

    uvm_config_db#(int)::set(this, "*", "control", ctrl);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    env_h.ca.display();
    env_h.cb.display();
  endtask
endclass

module top;
  initial begin
    run_test("test");
  end
endmodule
