`include "uvm_macros.svh"
import uvm_pkg::*;

class packet extends uvm_object;

  `uvm_object_utils(packet)

  rand int data = 10;
  function new(string name = "packet");
    super.new(name);
  endfunction

  function void display(string s);
    $display("%s the value of data is %d", s, data);
  endfunction
endclass

class generator extends uvm_component;
  uvm_blocking_put_port #(packet) put_port;

  `uvm_component_utils(generator)

  packet pkt;

  function new(string name = "generator", uvm_component parent);
    super.new(name, parent);

    put_port = new("put_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    pkt = packet::type_id::create("pkt", this);
  endfunction

  task run_phase(uvm_phase phase);

    pkt.randomize();

    put_port.put(pkt);
  endtask
endclass

class driver extends uvm_driver;

  uvm_blocking_get_port #(packet) get_port;

  `uvm_component_utils(driver)

  packet pkt;

  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);

    get_port = new("get_port", this);
  endfunction

  task run_phase(uvm_phase phase);
    get_port.get(pkt);

    pkt.display("");
  endtask
endclass

class agent extends uvm_agent;
  generator gen_h;
  driver drv_h;

  `uvm_component_utils(agent)

  uvm_tlm_fifo #(packet) fifo_h;

  function new(string name = "agent", uvm_component parent);
    super.new(name, parent);

    fifo_h = new("fifo_h", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    gen_h = generator::type_id::create("gen_h", this);
    drv_h = driver::type_id::create("drv_h", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    gen_h.put_port.connect(fifo_h.put_export);

    drv_h.get_port.connect(fifo_h.get_export);
  endfunction
endclass

class test extends uvm_test;
  agent agent_h;

  `uvm_component_utils(test)

  function new(string name = "agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agent_h = agent::type_id::create("agent_h", this);
  endfunction
endclass

module top;
  initial begin
    run_test("test");
  end
endmodule
