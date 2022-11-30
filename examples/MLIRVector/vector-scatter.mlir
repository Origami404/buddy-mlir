memref.global "private" @gv0 : memref<8xi32> = dense<[0, 1, 2, 3, 4, 5, 6, 7]>

memref.global "private" @gv1 : memref<8xi32> = dense<[0, 1, 2, 3, 4, 5, 6, 7]>

func.func private @printMemrefI32(memref<*xi32>)

func.func @main() -> i32 {
  // vector.scatter is also store with mask, but storing element in custom order, 
  // rather than sequentially:
  //    if (mask[0]) base[index[0]] = value[0]
  //    if (mask[1]) base[index[1]] = value[1]
  //    ...
  // As a comparison, that's what vector.maskedload doing:
  //    if (mask[0]) base[0] = value[0]
  //    if (mask[1]) base[1] = value[1]
  //    ...
  // Unlike vector.gather, vector.scatter does NOT support n-D vector storing. 

  // preparation for examples
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c4 = arith.constant 4 : index

  %base0 = memref.get_global @gv0 : memref<8xi32>
  %base1 = memref.get_global @gv1 : memref<8xi32>

  %base0_print = memref.cast %base0 : memref<8xi32> to memref<*xi32>
  %base1_print = memref.cast %base1 : memref<8xi32> to memref<*xi32>


  // scatter normal usage
  %mask0 = arith.constant dense<1> : vector<4xi1>
  %index0 = arith.constant dense<[3, 4, 2, 1]> : vector<4xi32>
  %value0 = arith.constant dense<[1000, 1001, 1002, 1003]> : vector<4xi32>
  
  vector.scatter %base0[%c0][%index0], %mask0, %value0
    : memref<8xi32>, vector<4xi32>, vector<4xi1>, vector<4xi32>

  func.call @printMemrefI32(%base0_print) : (memref<*xi32>) -> ()


  // with mask
  %mask1 = arith.constant dense<[1, 0, 1, 0]> : vector<4xi1>
  %index1 = arith.constant dense<[3, 4, 2, 1]> : vector<4xi32>
  %value1 = arith.constant dense<[1100, 1101, 1102, 1103]> : vector<4xi32>

  vector.scatter %base0[%c4][%index1], %mask1, %value1
    : memref<8xi32>, vector<4xi32>, vector<4xi1>, vector<4xi32>

  func.call @printMemrefI32(%base0_print) : (memref<*xi32>) -> ()


  // For the same reason as vector.store, index can be negative or out-of-bound,
  // the behavior will be specified by platform.
  %mask2 = arith.constant dense<1> : vector<4xi1>
  %index2 = arith.constant dense<[-1, -2, 5, 10]> : vector<4xi32>
  %value2 = arith.constant dense<[1200, 1201, 1202, 1203]> : vector<4xi32>

  vector.scatter %base0[%c4][%index2], %mask2, %value2
    : memref<8xi32>, vector<4xi32>, vector<4xi1>, vector<4xi32>

  func.call @printMemrefI32(%base0_print) : (memref<*xi32>) -> ()
  func.call @printMemrefI32(%base1_print) : (memref<*xi32>) -> ()

  %ret = arith.constant 0 : i32
  return %ret : i32
}
