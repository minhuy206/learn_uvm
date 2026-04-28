`include "uvm_macros.svh"
import uvm_pkg::*;

class test extends uvm_test;
  `uvm_component_utils(test)

  int a = 50;

  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase)

    `uvm_report_info(get_type_name, "printing from build phase", UVM_LOW, "tb.sv", 18);
    // `uvm_info(get_type_name, $format("the value of a is %d", a), UVM_NONE);
  endfunction
endclass

module top;

  initial begin
    uvm_top.set_report_verbosity_level(UVM_LOW);
    uvm_top.set_report_severity_action(UVM_INFO, UVM_NO_ACTION);
    run_test("test");
  end
endmodule
