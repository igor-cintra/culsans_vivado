#!/bin/bash
set -e

# Captura o nome do teste passado no terminal (padrão: read_cache_share)
TESTNAME=${1:-read_cache_share}
MODE=$2
if [ "${MODE^^}" == "GUI" ]; then
    XSIM_FLAG="-gui"
    echo " -> Modo de simulação: INTERFACE GRÁFICA (GUI)"
else
    XSIM_FLAG="-R"
    echo " -> Modo de simulação: TERMINAL (Batch)"
fi

CORES=2

# Muda para a pasta de testes
cd /home/igorcintra13/culsans_questa/tests/integration

echo "=========================================================="
echo " [Fase 0] Limpando compilações anteriores de software..."
echo "=========================================================="
make clean_sw
rm -rf xsim.dir *.pb *.wdb *.jou *.log

echo "=========================================================="
echo " [Fase 1] Compilando o software RISC-V para: $TESTNAME"
echo "=========================================================="
# Executa a compilação cruzada do software antes de mexer com o Vivado
make -s sw TEST=$TESTNAME NB_CORES=$CORES CC="riscv64-unknown-elf-gcc --specs=picolibc.specs" RV_GCC="riscv64-unknown-elf-gcc --specs=picolibc.specs"

echo "=========================================================="
echo " [Fase 2] Compilando e elaborando o hardware (Vivado)"
echo "=========================================================="

# Passo 1: Analise Sequencial SV
xvlog -work work -sv --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/corev_apu/register_interface/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/planv/ace/include/ --include /home/igorcintra13/culsans_questa/modules/axi_llc/include --include /home/igorcintra13/culsans_questa/rtl/include --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/ --include /home/igorcintra13/culsans_questa/modules/cva6/common/local/util/  \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/fpga-support/rtl/SyncDpRam.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/fpga-support/rtl/AsyncDpRam.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/fpga-support/rtl/AsyncThreePortRam.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/include/cv64a6_imafdc_sv39_wb_config_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/include/riscv_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/common/local/rvfi/rvfi_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/include/ariane_dm_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/include/ariane_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/src/axi_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/planv/ace/src/ace_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/planv/ace/src/snoop_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/include/ariane_axi_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/include/ariane_ace_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/include/wt_cache_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/include/std_cache_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/include/axi_intf.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/include/instr_tracer_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/include/cvxif_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cvxif_example/include/cvxif_instr_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cvxif_fu.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cvxif_example/cvxif_example_coprocessor.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cvxif_example/instr_decoder.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/cf_math_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/fifo_v3.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/lfsr.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/lfsr_8bit.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/stream_arbiter.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/stream_arbiter_flushable.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/stream_mux.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/stream_demux.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/lzc.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/rr_arb_tree.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/shift_reg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/unread.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/popcount.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/exp_backoff.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/counter.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/src/delta_counter.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpnew_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpnew_cast_multi.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpnew_classifier.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpnew_divsqrt_multi.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpnew_fma_multi.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpnew_fma.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpnew_noncomp.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpnew_opgroup_block.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpnew_opgroup_fmt_slice.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpnew_opgroup_multifmt_slice.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpnew_rounding.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpnew_top.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpu_div_sqrt_mvp/hdl/control_mvp.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpu_div_sqrt_mvp/hdl/div_sqrt_top_mvp.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpu_div_sqrt_mvp/hdl/iteration_div_sqrt_mvp.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpu_div_sqrt_mvp/hdl/norm_div_sqrt_mvp.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpu_div_sqrt_mvp/hdl/nrbd_nrsc_mvp.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/openhwgroup/cvfpu/src/fpu_div_sqrt_mvp/hdl/preprocess_mvp.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cva6.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/alu.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/fpu_wrap.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/branch_unit.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/compressed_decoder.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/controller.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cva6_clic_controller.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/csr_buffer.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/csr_regfile.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/decoder.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/ex_stage.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/instr_realign.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/id_stage.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/issue_read_operands.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/issue_stage.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/load_unit.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/load_store_unit.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/lsu_bypass.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/mult.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/multiplier.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/serdiv.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/perf_counters.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/ariane_regfile_ff.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/ariane_regfile_fpga.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/re_name.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/scoreboard.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/store_buffer.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/amo_buffer.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/store_unit.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/commit_stage.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/axi_shim.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/frontend/btb.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/frontend/bht.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/frontend/ras.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/frontend/instr_scan.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/frontend/instr_queue.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/frontend/frontend.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cache_subsystem/wt_dcache_ctrl.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cache_subsystem/wt_dcache_mem.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cache_subsystem/wt_dcache_missunit.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cache_subsystem/wt_dcache_wbuffer.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cache_subsystem/wt_dcache.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cache_subsystem/cva6_icache.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cache_subsystem/wt_cache_subsystem.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cache_subsystem/wt_axi_adapter.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cache_subsystem/tag_cmp.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cache_subsystem/axi_adapter.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cache_subsystem/miss_handler.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cache_subsystem/cache_ctrl.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cache_subsystem/snoop_cache_ctrl.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cache_subsystem/cva6_icache_axi_wrapper.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cache_subsystem/std_cache_subsystem.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/cache_subsystem/std_nbdcache.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/pmp/src/pmp.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/pmp/src/pmp_entry.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/common/local/util/instr_tracer_if.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/common/local/util/instr_tracer.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/common/local/util/tc_sram_wrapper.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/common/local/util/sram_pulp.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/mmu_sv39/mmu.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/mmu_sv39/ptw.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/mmu_sv39/tlb.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/mmu_sv39x4/cva6_mmu_sv39x4.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/mmu_sv39x4/cva6_ptw_sv39x4.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/core/mmu_sv39x4/cva6_tlb_sv39x4.sv \


# Passo 2: Analise Sequencial SV
xvlog -work work -sv --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/corev_apu/register_interface/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/planv/ace/include/ --include /home/igorcintra13/culsans_questa/modules/axi_llc/include --include /home/igorcintra13/culsans_questa/rtl/include  \
  /home/igorcintra13/culsans_questa/modules/cva6/corev_apu/register_interface/src/reg_intf.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/corev_apu/tb/ariane_soc_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/corev_apu/riscv-dbg/src/dm_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/cva6/corev_apu/tb/ariane_axi_soc_pkg.sv \


# Passo 3: Analise Sequencial VHDL
xvhdl -work work -2008 \
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
  /home/igorcintra13/culsans_questa/modules/cva6/corev_apu/fpga/src/apb_uart/src/uart_transmitter.vhd \


# Passo 4: Analise Sequencial SV
xvlog -work work -sv --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/corev_apu/register_interface/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/planv/ace/include/ --include /home/igorcintra13/culsans_questa/modules/axi_llc/include --include /home/igorcintra13/culsans_questa/rtl/include  \
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


# Passo 5: Analise Sequencial SV
xvlog -work work -sv --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/corev_apu/register_interface/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/planv/ace/include/ --include /home/igorcintra13/culsans_questa/modules/axi_llc/include --include /home/igorcintra13/culsans_questa/rtl/include --define TB_HAS_LLC=0 \
  /home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_pkg.sv \
  /home/igorcintra13/culsans_questa/modules/axi_llc/src/axi_llc_reg_pkg.sv \


# Passo 6: Analise Sequencial SV
xvlog -work work -sv --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/corev_apu/register_interface/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/planv/ace/include/ --include /home/igorcintra13/culsans_questa/modules/axi_llc/include --include /home/igorcintra13/culsans_questa/rtl/include --define TB_HAS_LLC=0 \
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


# Passo 7: Analise Sequencial SV
xvlog -work work -sv --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/corev_apu/register_interface/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/planv/ace/include/ --include /home/igorcintra13/culsans_questa/modules/axi_llc/include --include /home/igorcintra13/culsans_questa/rtl/include --define TB_HAS_LLC=0 \
  /home/igorcintra13/culsans_questa/rtl/include/culsans_pkg.sv \


# Passo 8: Analise Sequencial SV
xvlog -work work -sv --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/corev_apu/register_interface/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/planv/ace/include/ --include /home/igorcintra13/culsans_questa/modules/axi_llc/include --include /home/igorcintra13/culsans_questa/rtl/include --define TB_HAS_LLC=0 \
  /home/igorcintra13/culsans_questa/modules/cva6//vendor/planv/ace/src/ace_intf.sv \
  /home/igorcintra13/culsans_questa/modules/cva6//vendor/planv/ace/src/snoop_intf.sv \
  /home/igorcintra13/culsans_questa/modules/cva6//vendor/planv/ace/src/ccu_fsm.sv \
  /home/igorcintra13/culsans_questa/modules/cva6//vendor/planv/ace/src/ace_trs_dec.sv \
  /home/igorcintra13/culsans_questa/modules/cva6//vendor/planv/ace/src/ace_ccu_top.sv \
  /home/igorcintra13/culsans_questa/modules/cva6//corev_apu/tb/common/mock_uart.sv \
  /home/igorcintra13/culsans_questa/rtl/src/culsans_peripherals.sv \
  /home/igorcintra13/culsans_questa/rtl/src/culsans_test.sv \
  /home/igorcintra13/culsans_questa/rtl/src/culsans_top.sv \


# Passo 9: Analise Sequencial SV
xvlog -work work -sv --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/corev_apu/register_interface/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/planv/ace/include/ --include /home/igorcintra13/culsans_questa/modules/axi_llc/include --include /home/igorcintra13/culsans_questa/rtl/include --define TB_HAS_LLC=0 --define ISOLATE_DUT_ONLY=1 \
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


# Passo 10: Analise Sequencial SV
xvlog -work work -sv --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/common_cells/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/pulp-platform/axi/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/corev_apu/register_interface/include/ --include /home/igorcintra13/culsans_questa/modules/cva6/vendor/planv/ace/include/ --include /home/igorcintra13/culsans_questa/modules/axi_llc/include --include /home/igorcintra13/culsans_questa/rtl/include --define TB_HAS_LLC=0 --define ISOLATE_DUT_ONLY=1 \
  /home/igorcintra13/culsans_questa/tests/integration/tb/bootrom_64.sv \
  /home/igorcintra13/culsans_questa/tests/integration/tb/culsans_tb.sv \
  /home/igorcintra13/culsans_questa/tests/integration/tb/ila.sv \


# Passo Final: Elaboracao e Simulacao
#xelab -debug typical -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --timescale 1ns/1ps -top culsans_tb -snapshot work_snapshot --ignore_assertions -mt off --O0 --relax
env -u LIBRARY_PATH xelab -debug typical -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --timescale 1ns/1ps -top culsans_tb -snapshot work_snapshot --ignore_assertions -mt off --O0 --relax -v 0

echo "=========================================================="
echo " [Fase 3] Extraindo endereço 'tohost' e iniciando XSIM"
echo "=========================================================="

# Usa o nm para ler o ELF, acha a linha do tohost e corta apenas a primeira coluna (o endereço hexadecimal)
TOHOST_ADDR=$(riscv64-unknown-elf-nm testlist/$TESTNAME/main.riscv | grep -w tohost | awk '{print $1}')

# ==============================================================================
# 1. Gera o script Tcl (O Monitor Cardíaco)
# ==============================================================================
cat > batch_control.tcl << 'EOF'
puts ">>> ANTES: [current_time]"
run 1 ns
puts ">>> DEPOIS 1ns: [current_time]"

run 1 ns
puts ">>> DEPOIS 2ns: [current_time]"

run 3 ns
puts ">>> DEPOIS 5ns: [current_time]"

run 5 ns
puts ">>> DEPOIS 10ns: [current_time]"

run 10 ns
puts ">>> DEPOIS 20ns: [current_time]"

run 20 ns
puts ">>> DEPOIS 40ns: [current_time]"

quit

EOF

# ==============================================================================
# 2. Chama o XSIM com a sua estrutura antiga + lendo o script Tcl
# ==============================================================================
echo ">>> Disparando XSIM..."

#xsim work_snapshot $XSIM_FLAG -testplusarg TESTNAME=$TESTNAME -testplusarg tohost_addr=$TOHOST_ADDR -tclbatch batch_control.tcl
xsim work_snapshot -testplusarg TESTNAME=$TESTNAME -testplusarg tohost_addr=$TOHOST_ADDR -tclbatch batch_control.tcl

echo ">>> Simulacao finalizada!"

