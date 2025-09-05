// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VRISING_EDGE_FF_TB__SYMS_H_
#define VERILATED_VRISING_EDGE_FF_TB__SYMS_H_  // guard

#include "verilated_heavy.h"

// INCLUDE MODEL CLASS

#include "Vrising_edge_ff_tb.h"

// INCLUDE MODULE CLASSES
#include "Vrising_edge_ff_tb___024root.h"

// SYMS CLASS (contains all model state)
class Vrising_edge_ff_tb__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vrising_edge_ff_tb* const __Vm_modelp;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vrising_edge_ff_tb___024root   TOP;

    // CONSTRUCTORS
    Vrising_edge_ff_tb__Syms(VerilatedContext* contextp, const char* namep, Vrising_edge_ff_tb* modelp);
    ~Vrising_edge_ff_tb__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
