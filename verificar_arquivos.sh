#!/bin/bash
set -e

# 1. LIMPEZA ÚNICA (Antes de qualquer compilação!)
echo "Limpando banco de dados anterior..."
rm -rf xsim.dir/

# 2. COMPILAÇÃO VHDL
echo "Compilando VHDL..."
xvhdl -work work \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/apb_uart/src/apb_uart.vhd \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/apb_uart/src/slib_clock_div.vhd \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/apb_uart/src/slib_counter.vhd \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/apb_uart/src/slib_edge_detect.vhd \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/apb_uart/src/slib_fifo.vhd \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/apb_uart/src/slib_input_filter.vhd \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/apb_uart/src/slib_input_sync.vhd \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/apb_uart/src/slib_mv_filter.vhd \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/apb_uart/src/uart_baudgen.vhd \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/apb_uart/src/uart_interrupt.vhd \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/apb_uart/src/uart_receiver.vhd \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/apb_uart/src/uart_transmitter.vhd

# 3. MAPEAMENTO BOTTOM-UP (SystemVerilog)
echo "Pré-compilando dependências base..."
CVA6_DIR="/home/igorcintra13/culsans_questa/modules/cva6"
CVA6_CORE="$CVA6_DIR/core"

# Pacotes Iniciais
CVA6_BASE_CONFIG=$(find $CVA6_DIR -name "cva6_config_pkg.sv" | head -n 1)
CVA6_TARGET_CONFIG="$CVA6_CORE/include/cv64a6_imafdc_sv39_wb_config_pkg.sv"

# A Ordem Inquebrável do CVA6 (Ajustada)
RISCV_PKG=$(find $CVA6_CORE -name "riscv_pkg.sv" | head -n 1)
ARIANE_DM_PKG=$(find $CVA6_CORE -name "ariane_dm_pkg.sv" | head -n 1)
RVFI_PKG=$(find $CVA6_DIR -name "rvfi_pkg.sv" | head -n 1)
ARIANE_PKG=$(find $CVA6_CORE -name "ariane_pkg.sv" | head -n 1)
CVXIF_PKG=$(find $CVA6_CORE -name "cvxif_pkg.sv" | head -n 1) # <--- Agora ele vem DEPOIS do ariane_pkg!
SNOOP_PKG=$(find $CVA6_DIR -name "snoop_pkg.sv" | head -n 1)

# Pacotes Externos (Vendor)
AXI_PKG=$(find $CVA6_DIR/vendor/pulp-platform -name "axi_pkg.sv" | head -n 1)
ACE_PKG=$(find $CVA6_DIR/vendor/planv -name "ace_pkg.sv" | head -n 1)

# Busca o pacote da FPU em qualquer lugar e pega a pasta dele automaticamente
FPNEW_PKG=$(find $CVA6_DIR -name "fpnew_pkg.sv" | head -n 1)
FPNEW_INC=$(dirname "$FPNEW_PKG")

# Busca o pacote matemático do common_cells (ADICIONE ESTA LINHA!)
CF_MATH_PKG=$(find $CVA6_DIR -name "cf_math_pkg.sv" | head -n 1)

# Restante dos pacotes (adicionada a exclusão do fpnew_pkg)
CVA6_OTHER_PKGS=$(find $CVA6_CORE -name "*_pkg.sv" ! -name "riscv_pkg.sv" ! -name "cvxif_pkg.sv" ! -name "ariane_pkg.sv" ! -name "*config_pkg.sv" ! -name "ariane_dm_pkg.sv" ! -name "rvfi_pkg.sv" ! -name "snoop_pkg.sv" ! -name "fpnew_pkg.sv")
CVA6_MODS=$(find $CVA6_CORE -name "*.sv" ! -name "*_pkg.sv" ! -path "*/tb/*" ! -name "riscv.sv")

# Busca de módulos instanciados mas não compilados
LZC_MOD=$(find $CVA6_DIR/vendor -name "lzc.sv" | head -n 1)
RR_ARB_MOD=$(find $CVA6_DIR/vendor -name "rr_arb_tree.sv" | head -n 1)
STREAM_ARB_FLUSH_MOD=$(find $CVA6_DIR/vendor -name "stream_arbiter_flushable.sv" | head -n 1)
STREAM_ARB_MOD=$(find $CVA6_DIR/vendor -name "stream_arbiter.sv" | head -n 1)

# Caminho absoluto para evitar que o Vivado pegue um "sram.sv" impostor em outra pasta
SRAM_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "sram.sv" ! -path "*/xsim.dir/*" -exec grep -l "USER_WIDTH" {} + | head -n 1)

# Busca o módulo lixeira de sinais
UNREAD_MOD=$(find $CVA6_DIR -name "unread.sv" | head -n 1)

# Busca das ferramentas de tracing de simulação
INSTR_TRACER_IF_MOD=$(find $CVA6_DIR -name "instr_tracer_if.sv" | head -n 1)
INSTR_TRACER_MOD=$(find $CVA6_DIR -name "instr_tracer.sv" | head -n 1)

# Busca das Tech Cells de memória
TC_SRAM_WRAPPER_MOD=$(find $CVA6_DIR -name "tc_sram_wrapper.sv" | head -n 1)
TC_SRAM_MOD=$(find $CVA6_DIR -name "tc_sram.sv" | head -n 1)

# O SRAM autêntico e definitivo que a Cache precisa
REAL_SRAM_MOD=$(find $CVA6_DIR -name "sram_pulp.sv" | head -n 1)

# Busca blindada: lê o código de todos os arquivos procurando exatamente a declaração "module lfsr" (com parênteses ou parâmetros)
LFSR_MOD=$(find /home/igorcintra13/culsans_questa -type f \( -name "*.sv" -o -name "*.v" \) -exec grep -lE "module[[:space:]]+lfsr[[:space:]#\(]" {} + | head -n 1)


# Busca o lfsr_8bit que o miss_handler está pedindo
LFSR_8BIT_MOD=$(find $CVA6_DIR -name "lfsr_8bit.sv" | head -n 1)

# Busca APENAS o Data Cache que possui o parâmetro AXI_ADDR_WIDTH (O Impostor-Killer)
STD_NBDCACHE_MOD=$(find $CVA6_DIR -type f -name "std_nbdcache.sv" -exec grep -l "AXI_ADDR_WIDTH" {} + | head -n 1)

# Busca blindada pelo multiplexador de stream
STREAM_MUX_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "*.sv" -exec grep -lE "module[[:space:]]+stream_mux\b" {} + | head -n 1)

# Busca blindada pelo demultiplexador de stream
STREAM_DEMUX_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "*.sv" -exec grep -lE "module[[:space:]]+stream_demux\b" {} + | head -n 1)

# Busca blindada pelo contador de bits (popcount)
POPCOUNT_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "*.sv" -exec grep -lE "module[[:space:]]+popcount\b" {} + | head -n 1)

# Busca blindada pelo Top-Level da Unidade de Ponto Flutuante (FPU)
FPNEW_TOP_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "*.sv" -exec grep -lE "module[[:space:]]+fpnew_top\b" {} + | head -n 1)

# Busca blindada pelo bloco de operações da FPU
FPNEW_OPGROUP_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "*.sv" -exec grep -lE "module[[:space:]]+fpnew_opgroup_block\b" {} + | head -n 1)

# Busca blindada pelo slice de formato da FPU
FPNEW_FMT_SLICE_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "*.sv" -exec grep -lE "module[[:space:]]+fpnew_opgroup_fmt_slice\b" {} + | head -n 1)

# Busca blindada pelo slice multi-formato da FPU
FPNEW_MULTIFMT_SLICE_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "*.sv" -exec grep -lE "module[[:space:]]+fpnew_opgroup_multifmt_slice\b" {} + | head -n 1)

# Busca blindada pelo Fused Multiply-Add (FMA) da FPU
FPNEW_FMA_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "*.sv" -exec grep -lE "module[[:space:]]+fpnew_fma\b" {} + | head -n 1)

# Busca blindada pelo classificador de ponto flutuante da FPU
FPNEW_CLASSIFIER_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "*.sv" -exec grep -lE "module[[:space:]]+fpnew_classifier\b" {} + | head -n 1)

# Busca blindada pelo bloco de arredondamento da FPU
FPNEW_ROUNDING_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "*.sv" -exec grep -lE "module[[:space:]]+fpnew_rounding\b" {} + | head -n 1)

# Busca blindada pelas operações não-computacionais da FPU
FPNEW_NONCOMP_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "*.sv" -exec grep -lE "module[[:space:]]+fpnew_noncomp\b" {} + | head -n 1)

# Busca blindada pelas operações não-computacionais da FPU
FPNEW_NONCOMP_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "*.sv" -exec grep -lE "module[[:space:]]+fpnew_noncomp\b" {} + | head -n 1)

# Busca blindada pelo divisor e calculador de raiz quadrada da FPU
FPNEW_DIVSQRT_MULTI_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "*.sv" -exec grep -lE "module[[:space:]]+fpnew_divsqrt_multi\b" {} + | head -n 1)

# Busca blindada pelo núcleo algorítmico de Divisão e Raiz Quadrada
DIV_SQRT_TOP_MVP_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "*.sv" -exec grep -lE "module[[:space:]]+div_sqrt_top_mvp\b" {} + | head -n 1)

# Busca pelo pacote de definições matemáticas do Div/Sqrt
DEFS_DIV_SQRT_MVP_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "*.sv" -exec grep -lE "package[[:space:]]+defs_div_sqrt_mvp\b" {} + | head -n 1)

# Busca pelo pré-processador do Div/Sqrt DIRETAMENTE pelo nome do arquivo
PREPROCESS_MVP_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "preprocess_mvp.sv" | head -n 1)

# Busca pelo motor iterativo (Non-Restoring Core) do Div/Sqrt
NRBD_NRSC_MVP_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "nrbd_nrsc_mvp.sv" | head -n 1)

# Busca pela Máquina de Estados (Controle) do motor iterativo
CONTROL_MVP_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "control_mvp.sv" | head -n 1)

# Busca pelo estágio de normalização/pós-processamento
NORM_DIV_SQRT_MVP_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "norm_div_sqrt_mvp.sv" | head -n 1)

# Busca pelo módulo de conversão de tipos (Cast) da FPU
FPNEW_CAST_MULTI_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "fpnew_cast_multi.sv" | head -n 1)

# Busca pelo bloco de iteração única do Div/Sqrt
ITERATION_DIV_SQRT_MVP_MOD=$(find /home/igorcintra13/culsans_questa -type f -name "iteration_div_sqrt_mvp.sv" | head -n 1)

# 4. COMPILAÇÃO MONOLÍTICA SYSTEMVERILOG
echo "Compilando SystemVerilog/Verilog..."

xvlog -work work -sv -d TB_HAS_LLC=1 \
echo "Arquivos presentes em CVA6_MODS:"
printf '%s\n' $CVA6_MODS | tee cva6_mods_lista.txt

echo "Arquivos suspeitos:"
printf '%s\n' $CVA6_MODS | grep -E "ace_intf|snoop_intf|std_nbdcache" || true

echo "Arquivos duplicados:"
printf '%s\n' $CVA6_MODS | sort | uniq -d

exit 0

-i $CVA6_CORE/include \
-i $CVA6_DIR/vendor/pulp-platform/common_cells/include \
-i $CVA6_DIR/vendor/pulp-platform/axi/include \
-i $CVA6_DIR/vendor/planv/ace/include \
-i $FPNEW_INC \
-i $CVA6_DIR/corev_apu/register_interface/include \
-i /home/igorcintra13/culsans_questa/modules/axi_llc/include \
-i /home/igorcintra13/culsans_questa/rtl/include \
$CVA6_BASE_CONFIG \
$CVA6_TARGET_CONFIG \
$RISCV_PKG \
$ARIANE_DM_PKG \
$RVFI_PKG \
$ARIANE_PKG \
$CVXIF_PKG \
$CF_MATH_PKG \
$AXI_PKG \
$FPNEW_PKG \
$ACE_PKG \
$SNOOP_PKG \
$CVA6_OTHER_PKGS \
$CVA6_DIR/vendor/pulp-platform/common_cells/src/delta_counter.sv \
$CVA6_DIR/vendor/pulp-platform/common_cells/src/counter.sv \
$CVA6_DIR/vendor/pulp-platform/common_cells/src/shift_reg.sv \
$CVA6_DIR/vendor/pulp-platform/common_cells/src/fifo_v3.sv \
$CVA6_DIR/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv \
$LZC_MOD \
$RR_ARB_MOD \
$STREAM_ARB_FLUSH_MOD \
$STREAM_ARB_MOD \
$TC_SRAM_MOD \
$TC_SRAM_WRAPPER_MOD \
$UNREAD_MOD \
$INSTR_TRACER_IF_MOD \
$INSTR_TRACER_MOD \
$LFSR_MOD \
$LFSR_8BIT_MOD \
$STREAM_MUX_MOD \
$STREAM_DEMUX_MOD \
$POPCOUNT_MOD \
$FPNEW_TOP_MOD \
$FPNEW_OPGROUP_MOD \
$FPNEW_FMT_SLICE_MOD \
$FPNEW_MULTIFMT_SLICE_MOD \
$FPNEW_FMA_MOD \
$FPNEW_CLASSIFIER_MOD \
$FPNEW_ROUNDING_MOD \
$FPNEW_NONCOMP_MOD \
$FPNEW_DIVSQRT_MULTI_MOD \
$DEFS_DIV_SQRT_MVP_MOD \
$PREPROCESS_MVP_MOD \
$ITERATION_DIV_SQRT_MVP_MOD \
$CONTROL_MVP_MOD \
$FPNEW_CAST_MULTI_MOD \
$NRBD_NRSC_MVP_MOD \
$NORM_DIV_SQRT_MVP_MOD \
$DIV_SQRT_TOP_MVP_MOD \
$CVA6_MODS \
$STD_NBDCACHE_MOD \
$REAL_SRAM_MOD \
/home/igorcintra13/culsans_questa/rtl/include/culsans_pkg.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/register_interface/src/reg_intf.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/tb/ariane_soc_pkg.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/riscv-dbg/src/dm_pkg.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/tb/ariane_axi_soc_pkg.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/tb/ariane.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/bootrom/bootrom.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/clint/axi_lite_interface.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/clint/clint.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/axi2apb/src/axi2apb_64_32.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/axi2apb/src/axi2apb.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/axi2apb/src/axi2apb_wrap.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/apb_timer/apb_timer.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/apb_timer/timer.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/axi_slice/src/axi_ar_buffer.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/axi_slice/src/axi_aw_buffer.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/axi_slice/src/axi_b_buffer.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/axi_slice/src/axi_r_buffer.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/axi_slice/src/axi_single_slice.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/axi_slice/src/axi_slice.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/axi_slice/src/axi_slice_wrap.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/axi_slice/src/axi_w_buffer.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/src/axi_riscv_atomics/src/axi_res_tbl.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/src/axi_riscv_atomics/src/axi_riscv_amos_alu.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/src/axi_riscv_atomics/src/axi_riscv_amos.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/src/axi_riscv_atomics/src/axi_riscv_amos_wrap.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/src/axi_riscv_atomics/src/axi_riscv_atomics_structs.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/src/axi_riscv_atomics/src/axi_riscv_atomics.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/src/axi_riscv_atomics/src/axi_riscv_atomics_wrap.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/src/axi_riscv_atomics/src/axi_riscv_lrsc.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/src/axi_riscv_atomics/src/axi_riscv_lrsc_wrap.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/axi_mem_if/src/axi2mem.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/rv_plic/rtl/rv_plic_target.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/rv_plic/rtl/rv_plic_gateway.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/rv_plic/rtl/prim_subreg.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/rv_plic/rtl/plic_regmap.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/rv_plic/rtl/plic_top.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/clic/src/mclic_reg_pkg.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/clic/src/mclic_reg_top.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/clic/src/clicint_reg_pkg.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/clic/src/clicint_reg_top.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/clic/src/clic_reg_adapter.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/clic/src/clic_gateway.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/clic/src/clic_target.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/clic/src/clic.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/riscv-dbg/src/dmi_cdc.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/riscv-dbg/src/dmi_jtag.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/riscv-dbg/src/dmi_jtag_tap.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/riscv-dbg/src/dm_csrs.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/riscv-dbg/src/dm_mem.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/riscv-dbg/src/dm_sba.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/riscv-dbg/src/dm_top.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/riscv-dbg/debug_rom/debug_rom.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/register_interface/src/apb_to_reg.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/register_interface/src/axi_to_reg.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/register_interface/src/reg_demux.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/register_interface/src/reg_err_slv.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/register_interface/src/axi_lite_to_reg.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_multicut.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/cb_filter_pkg.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/cb_filter.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/rstgen_bypass.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/rstgen.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/addr_decode.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/stream_register.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/stream_fifo.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/stream_xbar.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/onehot_to_bin.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/sub_per_hash.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_intf.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_cut.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_join.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_delayer.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_to_axi_lite.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_id_prepend.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_atop_filter.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_err_slv.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_mux.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_demux.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_xbar.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_isolate.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_burst_splitter.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_dw_upsizer.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_dw_downsizer.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_dw_converter.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/cdc_2phase.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/spill_register_flushable.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/spill_register.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/deprecated/fifo_v1.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/deprecated/fifo_v2.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/stream_delay.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/lfsr_16bit.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/id_queue.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/stream_fork.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/stream_filter.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/fall_through_register.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/tech_cells_generic/src/deprecated/cluster_clk_cells.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/tech_cells_generic/src/deprecated/pulp_clk_cells.sv \
/home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_clk.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/tb/ariane_testharness.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/tb/ariane_peripherals.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/tb/rvfi_tracer.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/tb/common/uart.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/tb/common/SimDTM.sv \
/home/igorcintra13/culsans_questa/modules/cva6/corev_apu/tb/common/SimJTAG.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_pkg.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_reg_pkg.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_burst_cutter.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_data_way.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_merge_unit.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_read_unit.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_reg_top.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_write_unit.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/eviction_refill/axi_llc_ax_master.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/eviction_refill/axi_llc_r_master.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/eviction_refill/axi_llc_w_master.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/hit_miss_detect/axi_llc_evict_box.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/hit_miss_detect/axi_llc_lock_box_bloom.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/hit_miss_detect/axi_llc_miss_counters.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/hit_miss_detect/axi_llc_tag_pattern_gen.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_chan_splitter.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_evict_unit.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_refill_unit.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_ways.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/hit_miss_detect/axi_llc_tag_store.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_config.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_hit_miss.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_top.sv \
/home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_reg_wrap.sv \
/home/igorcintra13/culsans_questa/modules/cva6//vendor/planv/ace/src/ace_intf.sv \
/home/igorcintra13/culsans_questa/modules/cva6//vendor/planv/ace/src/snoop_intf.sv \
/home/igorcintra13/culsans_questa/modules/cva6//vendor/planv/ace/src/ccu_fsm.sv \
/home/igorcintra13/culsans_questa/modules/cva6//vendor/planv/ace/src/ace_trs_dec.sv \
/home/igorcintra13/culsans_questa/modules/cva6//vendor/planv/ace/src/ace_ccu_top.sv \
/home/igorcintra13/culsans_questa/modules/cva6//corev_apu/tb/common/mock_uart.sv \
/home/igorcintra13/culsans_questa/rtl/src/culsans_peripherals.sv \
/home/igorcintra13/culsans_questa/rtl/src/culsans_test.sv \
/home/igorcintra13/culsans_questa/rtl/src/culsans_top.sv \
/home/igorcintra13/culsans_questa/modules/cva6//corev_apu/tb/common_verification/src/rand_id_queue.sv \
/home/igorcintra13/culsans_questa/modules/cva6//vendor/pulp-platform/axi/src/axi_test.sv \
/home/igorcintra13/culsans_questa/modules/cva6//vendor/planv/ace/src/ace_test.sv \
/home/igorcintra13/culsans_questa/modules/cva6//vendor/planv/ace/src/snoop_test.sv \
/home/igorcintra13/culsans_questa/modules/cva6//vendor/planv/ace/test/tb_ace_ccu_pkg.sv \
/home/igorcintra13/culsans_questa/modules/cva6//corev_apu/tb/tb_std_cache_subsystem/hdl/dcache_intf.sv \
/home/igorcintra13/culsans_questa/modules/cva6//corev_apu/tb/tb_std_cache_subsystem/hdl/icache_intf.sv \
/home/igorcintra13/culsans_questa/modules/cva6//corev_apu/tb/tb_std_cache_subsystem/hdl/sram_intf.sv \
/home/igorcintra13/culsans_questa/modules/cva6//corev_apu/tb/tb_std_cache_subsystem/hdl/amo_intf.sv \
/home/igorcintra13/culsans_questa/modules/cva6//corev_apu/tb/tb_std_cache_subsystem/hdl/tb_std_cache_subsystem_pkg.sv \
/home/igorcintra13/culsans_questa/tests/integration/tb/bootrom_64.sv \
/home/igorcintra13/culsans_questa/tests/integration/tb/culsans_tb.sv \
/home/igorcintra13/culsans_questa/tests/integration/tb/ila.sv

# 5. ELABORAÇÃO E SIMULAÇÃO
echo "Elaborando design..."
xelab -debug typical --timescale 1ns/1ps -top culsans_tb -snapshot work_snapshot

echo "Iniciando simulação no Vivado (xsim)..."
xsim work_snapshot -R
