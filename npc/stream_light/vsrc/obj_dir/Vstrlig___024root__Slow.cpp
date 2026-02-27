// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vstrlig.h for the primary calling header

#include "Vstrlig__pch.h"

void Vstrlig___024root___ctor_var_reset(Vstrlig___024root* vlSelf);

Vstrlig___024root::Vstrlig___024root(Vstrlig__Syms* symsp, const char* namep)
 {
    vlSymsp = symsp;
    vlNamep = strdup(namep);
    // Reset structure values
    Vstrlig___024root___ctor_var_reset(this);
}

void Vstrlig___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vstrlig___024root::~Vstrlig___024root() {
    VL_DO_DANGLING(std::free(const_cast<char*>(vlNamep)), vlNamep);
}
