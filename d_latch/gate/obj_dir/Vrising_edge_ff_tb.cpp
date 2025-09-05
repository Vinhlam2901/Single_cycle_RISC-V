// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vrising_edge_ff_tb.h"
#include "Vrising_edge_ff_tb__Syms.h"

//============================================================
// Constructors

Vrising_edge_ff_tb::Vrising_edge_ff_tb(VerilatedContext* _vcontextp__, const char* _vcname__)
    : vlSymsp{new Vrising_edge_ff_tb__Syms(_vcontextp__, _vcname__, this)}
    , data{vlSymsp->TOP.data}
    , clk{vlSymsp->TOP.clk}
    , q{vlSymsp->TOP.q}
    , rootp{&(vlSymsp->TOP)}
{
}

Vrising_edge_ff_tb::Vrising_edge_ff_tb(const char* _vcname__)
    : Vrising_edge_ff_tb(nullptr, _vcname__)
{
}

//============================================================
// Destructor

Vrising_edge_ff_tb::~Vrising_edge_ff_tb() {
    delete vlSymsp;
}

//============================================================
// Evaluation loop

void Vrising_edge_ff_tb___024root___eval_initial(Vrising_edge_ff_tb___024root* vlSelf);
void Vrising_edge_ff_tb___024root___eval_settle(Vrising_edge_ff_tb___024root* vlSelf);
void Vrising_edge_ff_tb___024root___eval(Vrising_edge_ff_tb___024root* vlSelf);
QData Vrising_edge_ff_tb___024root___change_request(Vrising_edge_ff_tb___024root* vlSelf);
#ifdef VL_DEBUG
void Vrising_edge_ff_tb___024root___eval_debug_assertions(Vrising_edge_ff_tb___024root* vlSelf);
#endif  // VL_DEBUG
void Vrising_edge_ff_tb___024root___final(Vrising_edge_ff_tb___024root* vlSelf);

static void _eval_initial_loop(Vrising_edge_ff_tb__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    Vrising_edge_ff_tb___024root___eval_initial(&(vlSymsp->TOP));
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial loop\n"););
        Vrising_edge_ff_tb___024root___eval_settle(&(vlSymsp->TOP));
        Vrising_edge_ff_tb___024root___eval(&(vlSymsp->TOP));
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = Vrising_edge_ff_tb___024root___change_request(&(vlSymsp->TOP));
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("falling_edge_ff.v", 1, "",
                "Verilated model didn't DC converge\n"
                "- See https://verilator.org/warn/DIDNOTCONVERGE");
        } else {
            __Vchange = Vrising_edge_ff_tb___024root___change_request(&(vlSymsp->TOP));
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vrising_edge_ff_tb::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vrising_edge_ff_tb::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vrising_edge_ff_tb___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        Vrising_edge_ff_tb___024root___eval(&(vlSymsp->TOP));
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = Vrising_edge_ff_tb___024root___change_request(&(vlSymsp->TOP));
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("falling_edge_ff.v", 1, "",
                "Verilated model didn't converge\n"
                "- See https://verilator.org/warn/DIDNOTCONVERGE");
        } else {
            __Vchange = Vrising_edge_ff_tb___024root___change_request(&(vlSymsp->TOP));
        }
    } while (VL_UNLIKELY(__Vchange));
}

//============================================================
// Invoke final blocks

void Vrising_edge_ff_tb::final() {
    Vrising_edge_ff_tb___024root___final(&(vlSymsp->TOP));
}

//============================================================
// Utilities

VerilatedContext* Vrising_edge_ff_tb::contextp() const {
    return vlSymsp->_vm_contextp__;
}

const char* Vrising_edge_ff_tb::name() const {
    return vlSymsp->name();
}
