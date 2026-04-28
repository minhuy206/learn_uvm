`include "uvm_macros.svh"
import uvm_pkg::*;

class packet extends uvm_object;

  rand int data;
  rand reg [3:0] addr;
  rand logic enable;

  `uvm_object_utils_begin(packet)

    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_NOCOPY)
    `uvm_field_int(enable, UVM_NOCOMPARE)

  `uvm_object_utils_end

  function new(string name = "packet");
    super.new(name);
  endfunction

  function void display(string handle);
    $display("%s the value of data is %d and value of addr is %d and the value of enable is %d",
             handle, data, addr, enable);
  endfunction

endclass

module top;
  packet p_1_h, p_2_h;
  initial begin
    p_1_h = packet::type_id::create("p_1_h");
    p_2_h = packet::type_id::create("p_2_h");

    p_1_h.randomize();

    p_2_h.copy(p_1_h);
    p_1_h.display("p_1_h");
    p_2_h.display("p_2_h");
  end
endmodule
