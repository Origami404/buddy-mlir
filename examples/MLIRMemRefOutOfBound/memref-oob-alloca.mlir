
memref.global "private" @region_gv : memref<4xi32> = dense<[0, 1, 2, 3]>
memref.global "private" @canary_gv : memref<12xi32> = dense<202>
// 202 == 0xCA, means canary

func.func private @printMemrefI32(memref<*xi32>)

func.func @main() -> i32 {
  %region_init = memref.get_global @region_gv : memref<4xi32>
  %canary_init = memref.get_global @canary_gv : memref<12xi32>

  %region = memref.alloca() : memref<4xi32>
  // For somehow there will be a 192 byte long "gap" between this two allocation on stack
  %canary = memref.alloca() : memref<12xi32>

  memref.copy %region_init, %region : memref<4xi32> to memref<4xi32>
  memref.copy %canary_init, %canary : memref<12xi32> to memref<12xi32>

  // ===================== test code ============================//
  %c1 = arith.constant 1 : i32
  %c5 = arith.constant 5 : index

  %region_print = memref.cast %region : memref<4xi32> to memref<*xi32>
  %canary_print = memref.cast %canary : memref<12xi32> to memref<*xi32>

  %erases = memref.cast %region : memref<4xi32> to memref<?xi32>
  
  %val = memref.load %erases[%c5] : memref<?xi32>
  vector.print %val : i32

  memref.store %c1, %erases[%c5] : memref<?xi32>
  func.call @printMemrefI32(%region_print) : (memref<*xi32>) -> ()
  func.call @printMemrefI32(%canary_print) : (memref<*xi32>) -> ()

  %ret = arith.constant 0 : i32
  return %ret : i32
}
