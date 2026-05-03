// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
import uvm_pkg::*;

class sequence_item extends uvm_sequence_item;
  `uvm_object_utils(sequence_item)

  rand int data_1;
  rand int data_2;

  function new(string name = "sequence_item");
    super.new(name);
  endfunction

endclass

class sequence_1 extends uvm_sequence;
  sequence_item req;

  `uvm_object_utils(sequence_1)

  function new(string name = "sequence_1");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "inside body task of sequence_1", UVM_LOW)
    req = sequence_item::type_id::create("req");
    wait_for_grant();
    req.randomize();
    send_request(req);
    wait_for_item_done();
  endtask
endclass

class sequence_2 extends uvm_sequence;
  sequence_item req;

  `uvm_object_utils(sequence_2)

  function new(string name = "sequence_2");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "inside body task of sequence_2", UVM_LOW)
    req = sequence_item::type_id::create("req");
    wait_for_grant();
    req.randomize();
    send_request(req);
    wait_for_item_done();
  endtask
endclass

class sequencer_1 extends uvm_sequencer #(sequence_item);
  `uvm_component_utils(sequencer_1)

  function new(string name = "sequencer_1", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass


class sequencer_2 extends uvm_sequencer #(sequence_item);
  `uvm_component_utils(sequencer_2)

  function new(string name = "sequencer_2", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

class virtual_sequencer extends uvm_sequencer #(sequence_item);
  `uvm_component_utils(virtual_sequencer)
  sequencer_1 seqrh1;
  sequencer_2 seqrh2;
  function new(string name = "virtual_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass

class virtual_sequence extends uvm_sequence;
  sequence_1  seqh1;
  sequence_2  seqh2;

  sequencer_1 seqrh1;
  sequencer_2 seqrh2;

  `uvm_object_utils(virtual_sequence)
  `uvm_declare_p_sequencer(virtual_sequencer)

  function new(string name = "virtual_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "INSIDE VIRTUAL SEQUENCE", UVM_LOW)

    seqh1 = sequence_1::type_id::create("seqh1");

    seqh2 = sequence_2::type_id::create("seqh2");

    seqh1.start(p_sequencer.seqrh1);
    seqh2.start(p_sequencer.seqrh2);
  endtask

endclass



class base_driver extends uvm_driver #(sequence_item);
  `uvm_component_utils(base_driver)

  function new(string name = "base_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);

      drive(req);

      seq_item_port.item_done();
    end
  endtask

  virtual task drive(sequence_item req);
    `uvm_info(get_type_name(), "DRIVING FROM THE BASE DRIVER", UVM_LOW)

    #50;
  endtask
endclass

class driver_1 extends base_driver;
  `uvm_component_utils(driver_1)

  function new(string name = "driver_1", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task driver(sequence_item req);
    `uvm_info(get_type_name(), "DRIVING FROM THE DRIVER_1", UVM_LOW)

    #50;
  endtask
endclass


class driver_2 extends base_driver;
  `uvm_component_utils(driver_2)

  function new(string name = "driver_2", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task driver(sequence_item req);
    `uvm_info(get_type_name(), "DRIVING FROM THE DRIVER_2", UVM_LOW)

    #50;
  endtask
endclass

class agent_1 extends uvm_agent;
  `uvm_component_utils(agent_1)

  driver_1 drvh1;
  sequencer_1 seqrh1;

  function new(string name = "agent_1", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    drvh1  = driver_1::type_id::create("drvh1", this);
    seqrh1 = sequencer_1::type_id::create("seqrh1", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    drvh1.seq_item_port.connect(seqrh1.seq_item_export);
  endfunction
endclass


class agent_2 extends uvm_agent;
  `uvm_component_utils(agent_2)

  driver_2 drvh2;
  sequencer_2 seqrh2;

  function new(string name = "agent_2", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    drvh2  = driver_2::type_id::create("drvh2", this);
    seqrh2 = sequencer_2::type_id::create("seqrh2", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    drvh2.seq_item_port.connect(seqrh2.seq_item_export);
  endfunction
endclass

class env extends uvm_env;
  `uvm_component_utils(env)

  agent_1 agenth1;
  agent_2 agenth2;
  virtual_sequencer v_seqrh;

  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agenth1 = agent_1::type_id::create("agenth1", this);
    agenth2 = agent_2::type_id::create("agenth2", this);
    v_seqrh = virtual_sequencer::type_id::create("v_seqrh", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    v_seqrh.seqrh1 = agenth1.seqrh1;
    v_seqrh.seqrh2 = agenth2.seqrh2;
  endfunction

endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  virtual_sequence v_seqh;
  env envh;

  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    envh = env::type_id::create("envh", this);

  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    v_seqh = virtual_sequence::type_id::create("v_seqh", this);

    v_seqh.start(envh.v_seqrh);

    phase.drop_objection(this);

  endtask
endclass

module top;
  initial begin
    run_test("test");
  end
endmodule

