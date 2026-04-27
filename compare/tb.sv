`include "uvm_macros.svh"
import uvm_pkg::*;

class base_packet extends uvm_object;

  int a, b;

  `uvm_object_utils(base_packet)

  function new(string name = "base_packet");
    super.new(name);
  endfunction

  function bit do_copy(uvm_object rhs, uvm_comparer comparer)
    base_packet base_packet_h;

    if(!$cast(base_packet_h, rhs))
      return 0;

    return (this.a == base_packet_h.a && this.b == base_packet_h.b);
  endfunction

endclass

module top:
  base_packet base_packet_h_1, base_packet_h_2;

  initial begin
    base_packet_h_1 = base_packet::type_id::create("base_packet_1");

    base_packet_h_2 = base_packet::type_id::create("base_packet_2");

    base_packet_h_1.a = 10;
    base_packet_h_1.b = 20;

    base_packet_h_2.a = 10;
    base_packet_h_2.b = 30;

    if (base_packet_h_1.compare(base_packet_h_2)) begin
      $display("equal");
    end else begin
      $display("not equal"); 
    end
  end
endmodule