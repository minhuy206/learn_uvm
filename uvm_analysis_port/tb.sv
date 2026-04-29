`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_object;
  int data = 20;

  `uvm_object_utils(transaction)

  function new(string name = "transaction");
    super.new(name);
  endfunction
endclass

class producer extends uvm_component;
  uvm_analysis_port #(transaction) producer_put;
  `uvm_component_utils(producer)

  transaction t_h;

  function new(string name = "transaction", uvm_component parent);
    super.new(name, parent);
    producer_put = new("producer_put", this);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    t_h = transaction::type_id::create("t_h", this);

    assert (t_h.randomize());

    `uvm_info(get_type_name(), $sformatf("the value of data is %d", t_h.data), UVM_NONE);

    producer_put.write(t_h);

  endtask

endclass

class consumer_a extends uvm_component;
  uvm_analysis_imp #(transaction, consumer_a) consumer_a_imp;

  transaction t_h;

  `uvm_component_utils(consumer_a)

  function new(string name = "consumer_a", uvm_component parent);
    super.new(name, parent);

    consumer_a_imp = new("consumer_a_imp", this);
  endfunction

  function void write(transaction t_h);
    `uvm_info(get_type_name(), $sformatf("received value is %0d", t_h.data), UVM_LOW);
  endfunction

endclass


class consumer_b extends uvm_component;
  uvm_analysis_imp #(transaction, consumer_b) consumer_b_imp;

  transaction t_h;

  `uvm_component_utils(consumer_b)

  function new(string name = "consumer_b", uvm_component parent);
    super.new(name, parent);

    consumer_b_imp = new("consumer_b_imp", this);
  endfunction

  function void write(transaction t_h);
    `uvm_info(get_type_name(), $sformatf("received value is %0d", t_h.data), UVM_LOW);
  endfunction

endclass

class consumer_c extends uvm_component;
  uvm_analysis_imp #(transaction, consumer_c) consumer_c_imp;

  transaction t_h;

  `uvm_component_utils(consumer_c)

  function new(string name = "consumer_c", uvm_component parent);
    super.new(name, parent);

    consumer_c_imp = new("consumer_c_imp", this);
  endfunction

  function void write(transaction t_h);
    `uvm_info(get_type_name(), $sformatf("received value is %0d", t_h.data), UVM_LOW);
  endfunction
endclass

class env extends uvm_env;
  `uvm_component_utils(env)

  producer   p_h;
  consumer_a c_a_h;
  consumer_b c_b_h;
  consumer_c c_c_h;

  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    p_h   = producer::type_id::create("p_h", this);
    c_a_h = consumer_a::type_id::create("c_a_h", this);
    c_b_h = consumer_b::type_id::create("c_b_h", this);
    c_c_h = consumer_c::type_id::create("c_c_h", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    p_h.producer_put.connect(c_a_h.consumer_a_imp);
    p_h.producer_put.connect(c_b_h.consumer_b_imp);
    p_h.producer_put.connect(c_c_h.consumer_c_imp);

  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)

  env env_h;

  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_h = env::type_id::create("env_h", this);
  endfunction

endclass

module top;
  initial begin
    run_test("test");
  end
endmodule

