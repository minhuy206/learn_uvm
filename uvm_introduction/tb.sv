class wr_txn;

  rand logic [7:0] data_in;

  virtual function void display();
    $display("base_txn: data_in = %0d", data_in);
  endfunction

endclass


class wr_txn2 extends wr_txn;

  rand logic [15:0] data_in;

  function void display();
    $display("base_txn2: data_in = %0d", data_in);
  endfunction

endclass


class generator;
  wr_txn wtxnh;
  wr_txn txn_type;

  mailbox #(wr_txn) gen_drv_mb;

  function new(mailbox #(wr_txn) gen_drv_mb, wr_txn txn_type);
    this.gen_drv_mb = gen_drv_mb;
    wtxnh = txn_type;
  endfunction
  
  task send_packet();
    assert(wtxnh.randomize());

    wtxnh.display();

    gen_drv_mb.put(wtxnh);

  endtask

endclass

class driver;
  mailbox#(wr_txn) gen_drv_mb;

  function new(mailbox#(wr_txn) gen_drv_mb);
    this.gen_drv_mb = gen_drv_mb;
  endfunction
  
  task drive_packet();
    wr_txn wtxnh;
    gen_drv_mb.get(wtxnh);

    wtxnh.display();
  endtask
endclass

class env;
  generator genh;
  driver drvh;
  wr_txn txn_type;

  mailbox#(wr_txn) mb;

  function new(wr_txn txn_type);
    mb = new();
    this.txn_type = txn_type;
    genh = new(mb, txn_type);
    drvh = new(mb);
  endfunction

  task run();
    genh.send_packet();
    drvh.drive_packet();
  endtask
endclass

module test;
  env envh;
  wr_txn txnh;
  wr_txn2 txnh2;

  initial begin
    txnh = new();
    txnh2 = new();
    envh = new(txnh2);
    envh.run();
    $display("test complete");
  end
endmodule