Steps to connect the Shakti IP

1. Transfer the TCL  and Verilog File on the Shakti Directory.
2. Check the Memory allocation of Base & Bound and allocate the  on "Soc.defines":-

    // below two lines are added
    `define MyNewBase         'h0005_0000
    `define MyNewBound        'h0005_FFFF

    `define MyNew_slave_num 7

3. Create the interface defination using of "Soc.bsv":-
    interface AXI4_Lite_Master_IFC#(`paddr, 32, 0) LUD_master;
    and 
    
    interface LUD_master = slow_fabric.v_to_slaves[`MyNew_slave_num];

4. Check the Slave Mapping in the design of "Soc.bsv":-

  function Bit#(TLog#(`Num_Slaves)) fn_slave_map (Bit#(`paddr) addr);
    Bit#(TLog#(`Num_Slaves)) slave_num = 0;
    if(addr >= `PWMClusterBase && addr <= `PWMClusterEnd)
      slave_num = `PWMCluster_slave_num;
    else if(addr >= `UARTClusterBase && addr <= `UARTClusterEnd)
      slave_num = `UARTCluster_slave_num;
    else if(addr >= `SPIClusterBase && addr <= `SPIClusterEnd)
      slave_num = `SPICluster_slave_num;
    else if(addr >= `MixedClusterBase && addr <= `MixedClusterEnd)
      slave_num = `MixedCluster_slave_num;
    else if(addr >= `PLICBase && addr <= `PLICEnd)
      slave_num = `MixedCluster_slave_num;
    else if(addr >= `BootBase && addr <= `BootEnd)
      slave_num = `Boot_slave_num;
    else if (addr >= `EthBase && addr <= `EthEnd)
      slave_num = `Eth_slave_num;
    else if (addr >= `MyNewBase && addr <= `MyNewBound)
      slave_num = `MyNew_slave_num;
    else if (addr >= `aximbase && addr <= `aximend)
      slave_num = `axim_slave_num;
    else
      slave_num = `Err_slave_num;
      
    return slave_num;
  endfunction:fn_slave_map

5.