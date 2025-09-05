// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VFULL_ADDER_TB__SYMS_H_
#define VERILATED_VFULL_ADDER_TB__SYMS_H_  // guard

#include "verilated_heavy.h"

// INCLUDE MODEL CLASS

#include "Vfull_adder_tb.h"

// INCLUDE MODULE CLASSES
#include "Vfull_adder_tb___024root.h"

// SYMS CLASS (contains all model state)
class Vfull_adder_tb__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vfull_adder_tb* const __Vm_modelp;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vfull_adder_tb___024root       TOP;

    // CONSTRUCTORS
    Vfull_adder_tb__Syms(VerilatedContext* contextp, const char* namep, Vfull_adder_tb* modelp);
    ~Vfull_adder_tb__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
