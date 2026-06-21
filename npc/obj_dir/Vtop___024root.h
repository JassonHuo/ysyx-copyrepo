// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtop.h for the primary calling header

#ifndef VERILATED_VTOP___024ROOT_H_
#define VERILATED_VTOP___024ROOT_H_  // guard

#include "verilated.h"
class Vtop___024unit;


class Vtop__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtop___024root final {
  public:
    // CELLS
    Vtop___024unit* __PVT____024unit;

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(rst,0,0);
    CData/*0:0*/ top__DOT__pc_en_wb_pc;
    CData/*3:0*/ top__DOT__alu_op_idu_exu;
    CData/*1:0*/ top__DOT__pc_src_idu_exu;
    CData/*1:0*/ top__DOT__reg_src_idu_exu;
    CData/*0:0*/ top__DOT__alu_src_idu_exu;
    CData/*0:0*/ top__DOT__wen_idu_exu;
    CData/*3:0*/ top__DOT__raddr1_wbu_gpr;
    CData/*3:0*/ top__DOT__raddr2_wbu_gpr;
    CData/*0:0*/ top__DOT__mem_wen_idu_exu;
    CData/*0:0*/ top__DOT__valid_idu_exu;
    CData/*1:0*/ top__DOT__width_idu_exu;
    CData/*0:0*/ top__DOT__break_idu_pc;
    CData/*0:0*/ top__DOT__idu0__DOT____VdfgExtracted_h87ea21a1__0;
    CData/*1:0*/ top__DOT__lsu0__DOT__mem_data;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __VstlPhaseResult;
    CData/*0:0*/ __VicoFirstIteration;
    CData/*0:0*/ __VicoPhaseResult;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __VactPhaseResult;
    CData/*0:0*/ __VnbaPhaseResult;
    VL_OUT(pc,31,0);
    VL_IN(inst,31,0);
    VL_OUT(a0,31,0);
    IData/*31:0*/ top__DOT__pc_wb_pc;
    IData/*31:0*/ top__DOT__imm_idu_exu;
    IData/*31:0*/ top__DOT__rdata_gpr_idu;
    IData/*31:0*/ top__DOT__rdata_lsu_wbu;
    IData/*31:0*/ top__DOT__pc0__DOT__pc;
    IData/*31:0*/ top__DOT__idu0__DOT__Iimm;
    IData/*31:0*/ top__DOT__gpr0__DOT__Gpr__DOT__rdata2;
    IData/*31:0*/ top__DOT__exu0__DOT__pc_sync_in;
    IData/*31:0*/ top__DOT__exu0__DOT__alu0__DOT__z;
    IData/*31:0*/ __Vfunc_pmem_read__1__Vfuncout;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<IData/*31:0*/, 16> top__DOT__gpr0__DOT__Gpr__DOT__rf;
    VlUnpacked<QData/*63:0*/, 1> __VstlTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VicoTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;
    VlUnpacked<CData/*0:0*/, 3> __Vm_traceActivity;

    // INTERNAL VARIABLES
    Vtop__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vtop___024root(Vtop__Syms* symsp, const char* namep);
    ~Vtop___024root();
    VL_UNCOPYABLE(Vtop___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
