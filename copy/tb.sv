`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_object;
  `uvm_object_utils(transaction)

  bit [3:0] addr;
  bit [7:0] data;

  function new(string name = "transaction");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);
    transaction t_h;

    $cast(t_h, rhs);

    this.addr = t_h.addr;
    this.data = t_h.data;

    super.do_copy(t_h);
  endfunction

  function void display(string message);
    $display("[%s]: the value of addr: %0d and the value of data is %0d", message, addr, data);
  endfunction

endclass

module test;
  transaction t_h_1, t_h_2;

  initial begin
    t_h_1 = transaction::type_id::create("t_h_1");
    t_h_2 = transaction::type_id::create("t_h_2");

    t_h_1.data = 50;
    t_h_1.addr = 10;

    t_h_2.copy(t_h_1);

    t_h_1.display("t_h_1");
    t_h_2.display("t_h_2");
  end
endmodule