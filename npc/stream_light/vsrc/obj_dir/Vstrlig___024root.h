// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vstrlig.h for the primary calling header

#ifndef VERILATED_VSTRLIG___024ROOT_H_
#define VERILATED_VSTRLIG___024ROOT_H_  // guard

#include "verilated.h"


class Vstrlig__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vstrlig___024root final {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(rst,0,0);
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    VL_OUT16(led,15,0);
    SData/*15:0*/ strlig__DOT__temp;
    IData/*31:0*/ strlig__DOT__count;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<QData/*63:0*/, 1> __VstlTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vstrlig__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vstrlig___024root(Vstrlig__Syms* symsp, const char* namep);
    ~Vstrlig___024root();
    VL_UNCOPYABLE(Vstrlig___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
