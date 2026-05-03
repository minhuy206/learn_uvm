`include "uvm_macros.svh"
import uvm_pkg::*;

class producer extends uvm_component;
  uvm_put_port #(int) tlm_put;
  int data;

  `uvm_component_utils(producer)

  function new(string name = "producer", uvm_component parent);
    super.new(name, parent);

    tlm_put = new("tlm_put", this);
  endfunction

  task run_phase(uvm_phase phase);

    super.run_phase(phase);

    data = 20;

    `uvm_info(get_type_name(), $sformatf("the value of data is %0d", data), UVM_LOW);

    tlm_put.put(data);

    tlm_put.try_put(data);

    tlm_put.can_put();
  endtask
endclass

class consumer extends uvm_component;

  uvm_put_imp #(int, consumer) tlm_imp;
  `uvm_component_utils(consumer)

  function new(string name = "consumer", uvm_component parent);
    super.new(name, parent);

    tlm_imp = new("tlm_imp", this);
  endfunction

  task put(int val);

    #10;
    `uvm_info(get_type_name(), $sformatf("received the data: %0d", val), UVM_LOW);
  endtask

  function bit try_put(int val);
    `uvm_info(get_type_name(), $sformatf("received try put value: %0d", val), UVM_LOW);
    return 1;
  endfunction

  function bit can_put();
    `uvm_info(get_type_name(), $sformatf("inside can put"), UVM_NONE);
  endfunction

endclass

class env extends uvm_env;
  `uvm_component_utils(env)

  producer pr_h;
  consumer cr_h;

  function new(string name = "env", uvm_component parent);
    super.new(name, parent);

  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    pr_h = producer::type_id::create("pr_h", this);
    cr_h = consumer::type_id::create("cr_h", this);

  endfunction

  function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    pr_h.tlm_put.connect(cr_h.tlm_imp);
  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)

  env env_h;

  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    env_h = env::type_id::create("env_h", this);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);

    #50;

    phase.drop_objection(this);
  endtask
endclass

module top;
  initial begin
    run_test("test");
  end
endmodule
