`include "uvm_macros.svh"
import uvm_pkg::*;

class seq_item extends uvm_sequence_item;
  `uvm_object_utils(seq_item)

  function new(string name = "seq_item");
    super.new(name);
  endfunction

endclass

class sequencer extends uvm_sequencer #(seq_item);
  `uvm_component_utils(sequencer)

  function new(string name = "sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass

class driver extends uvm_driver #(seq_item);
  `uvm_component_utils(driver)

  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);

      #50;

      seq_item_port.item_done();

      `uvm_info(get_type_name(), "after item_done called", UVM_LOW)
    end
  endtask
endclass

class sequence_ex extends uvm_sequence #(seq_item);
  `uvm_object_utils(sequence_ex)

  seq_item req;

  function new(string name = "sequence_ex");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "base seq inside body method", UVM_LOW)
    req = seq_item::type_id::create("req");

    wait_for_grant();

    assert (req.randomize());

    send_request(req);

    `uvm_info(get_type_name(), "BEFORE WAIT_ITEM_DONE", UVM_LOW)

    wait_for_item_done();
  endtask
endclass

class agent extends uvm_agent;
  sequencer sequencer_h;
  driver drv_h;
  `uvm_component_utils(agent)

  function new(string name = "agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    sequencer_h = sequencer::type_id::create("sequencer_h", this);
    drv_h = driver::type_id::create("drv_h", this);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    drv_h.seq_item_port.connect(sequencer_h.seq_item_export);

  endfunction

endclass

class env extends uvm_env;
  agent agent_h;
  `uvm_component_utils(env)

  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agent_h = agent::type_id::create("agent_h", this);

  endfunction

endclass

class test extends uvm_test;
  `uvm_component_utils(test)

  env env_h;

  sequence_ex seq_ex_h;


  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env_h = env::type_id::create("env_h", this);

    seq_ex_h = sequence_ex::type_id::create("seq_ex_h", this);

  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq_ex_h.start(env_h.agent_h.sequencer_h);
    phase.drop_objection(this);
  endtask

endclass

module tb;
  initial begin
    run_test("test");
  end
endmodule


