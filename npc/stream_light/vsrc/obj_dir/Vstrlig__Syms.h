// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VSTRLIG__SYMS_H_
#define VERILATED_VSTRLIG__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vstrlig.h"

// INCLUDE MODULE CLASSES
#include "Vstrlig___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES) Vstrlig__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vstrlig* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vstrlig___024root              TOP;

    // CONSTRUCTORS
    Vstrlig__Syms(VerilatedContext* contextp, const char* namep, Vstrlig* modelp);
    ~Vstrlig__Syms();

    // METHODS
    const char* name() const { return TOP.vlNamep; }
};

#endif  // guard
