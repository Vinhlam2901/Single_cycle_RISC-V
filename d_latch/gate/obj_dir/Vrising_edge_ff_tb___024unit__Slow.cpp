// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vrising_edge_ff_tb.h for the primary calling header

#include "Vrising_edge_ff_tb___024unit.h"
#include "Vrising_edge_ff_tb__Syms.h"

//==========


void Vrising_edge_ff_tb___024unit___ctor_var_reset(Vrising_edge_ff_tb___024unit* vlSelf);

Vrising_edge_ff_tb___024unit::Vrising_edge_ff_tb___024unit(const char* _vcname__)
    : VerilatedModule(_vcname__)
 {
    // Reset structure values
    Vrising_edge_ff_tb___024unit___ctor_var_reset(this);
}

void Vrising_edge_ff_tb___024unit::__Vconfigure(Vrising_edge_ff_tb__Syms* _vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->vlSymsp = _vlSymsp;
}

Vrising_edge_ff_tb___024unit::~Vrising_edge_ff_tb___024unit() {
}

void Vrising_edge_ff_tb___024unit___ctor_var_reset(Vrising_edge_ff_tb___024unit* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrising_edge_ff_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+  Vrising_edge_ff_tb___024unit___ctor_var_reset\n"); );
    // Body
    vlSelf->__VmonitorNum = VL_RAND_RESET_Q(64);
    vlSelf->__VmonitorOff = VL_RAND_RESET_I(1);
}
