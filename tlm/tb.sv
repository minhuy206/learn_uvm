`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_object;

  `uvm_object_utils(transaction)

  rand int data;

  function new(string name = "transaction");
    super.new(name);
  endfunction

  function void display (string message);
    $display("%s: the value of data is %d", message, data);
  endfunction

endclass

class uvm_generator extends uvm_component;
  uvm_blocking_put_port#(transaction) put_port;

  `uvm_component_utils(uvm_generator)

  function new(string name = "uvm_generator", uvm_component parent);
    super.new(name, parent);

    put_port = new("put_port", this);
  endfunction

  task run_phase(uvm_phase phase);
    transaction txn;

    txn = transaction::type_id::create("txn");

    assert(txn.randomize());

    put_port.put(txn);
  endtask
endclass

class driver extends uvm_component;
  uvm_blocking_put_imp#(transaction, driver) put_imp;

  `uvm_component_utils(driver)

  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);

    put_imp = new("put_imp", this);
  endfunction

  task put(transaction txn);
    txn.display("");
  endtask
endclass

class agent extends uvm_agent;
  `uvm_component_utils(agent)

  uvm_generator gen_h;

  driver drv_h;

  function new(string name = "agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    gen_h = uvm_generator::type_id::create("gen_h", this);
    drv_h = driver::type_id::create("drv_h", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    gen_h.put_port.connect(drv_h.put_imp);
  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)

  agent agent_h;
  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase)

    agent_h = agent::type_id::create("agent_h", this);
  endfunction

endclass

module top;
  initial begin
    run_test("test");
  end
endmodule
