import os
import sys
import re

def main():
    # 1. Atualizado para o log que acabamos de trazer para a raiz
    log_file = 'run_read_cache_share.log'
    with open(log_file, 'r') as f:
        lines = f.readlines()

    sv_files = [
        '../../modules/cva6/core/include/cvxif_pkg.sv'
    ]
    vhdl_files = [] # Novo: Lista separada para os arquivos VHDL
    includes = []
    defines = []
    
    # 2. Atualizado para o top module correto deste teste
    top_module = 'culsans_tb'

    for line in lines:
        # Pega arquivos Verilog/SystemVerilog (.v ou .sv)
        matches_sv = re.findall(r'([^\s]+\.(?:v|sv))\b', line)
        for m in matches_sv:
            if m not in sv_files:
                sv_files.append(m)
                
        # Novo: Pega arquivos VHDL (.vhd) da UART do CVA6
        matches_vhdl = re.findall(r'([^\s]+\.vhd)\b', line)
        for m in matches_vhdl:
            if m not in vhdl_files:
                vhdl_files.append(m)

        inc_matches = re.findall(r'\+incdir\+([^\s]+)', line)
        for m in inc_matches:
            if m not in includes:
                includes.append(m)

        def_matches = re.findall(r'\+define\+([^\s]+)', line)
        for m in def_matches:
            if m not in defines:
                defines.append(m)

    # 3. Atualizado o diretório base! 
    # Como o make original foi rodado dentro de tests/integration,
    # todos os caminhos relativos (ex: ../../rtl) partem de lá, e não da raiz.
    tb_dir = os.path.abspath('tests/integration')
    
    # Resolve caminhos SV/Verilog
    abs_sv_files = []
    for f in sv_files:
        if not os.path.isabs(f):
            abs_f = os.path.abspath(os.path.join(tb_dir, f))
        else:
            abs_f = f
        abs_sv_files.append(abs_f)

    # Resolve caminhos VHDL
    abs_vhdl_files = []
    for f in vhdl_files:
        if not os.path.isabs(f):
            abs_f = os.path.abspath(os.path.join(tb_dir, f))
        else:
            abs_f = f
        abs_vhdl_files.append(abs_f)

    # Resolve Includes
    abs_includes = []
    for inc in includes:
        if not os.path.isabs(inc):
            abs_inc = os.path.abspath(os.path.join(tb_dir, inc))
        else:
            abs_inc = inc
        abs_includes.append(abs_inc)

    # 4. Nome do novo script shell gerado
    output_sh = 'run_vivado_read_cache.sh'

    with open(output_sh, 'w') as sh:
        sh.write('#!/bin/bash\nset -e\n\n')
        
        # Novo: Compila VHDL primeiro (se existir) usando xvhdl
        if abs_vhdl_files:
            vhdl_str = ' '.join(abs_vhdl_files)
            sh.write(f'echo "Compilando VHDL..."\n')
            sh.write(f'xvhdl -work work {vhdl_str}\n\n')

        # Compila SV/Verilog usando xvlog
        has_sv = any(f.endswith('.sv') for f in abs_sv_files)
        sv_flag = ' -sv' if has_sv else ''
        inc_flags = ' '.join([f'-i {d}' for d in abs_includes])
        
        # Remove defines vazios para evitar erro de sintaxe do xvlog
        def_flags = ' '.join([f'-d {d}' for d in defines if d]) 
        sv_str = ' '.join(abs_sv_files)
        
        sh.write(f'echo "Compilando SystemVerilog/Verilog..."\n')
        sh.write(f'xvlog -work work{sv_flag} {inc_flags} {def_flags} {sv_str}\n\n')
        
        # Elabora e Roda a simulação
        sh.write(f'echo "Elaborando design..."\n')
        sh.write(f'xelab -debug typical --timescale 1ns/1ps -top {top_module} -snapshot work_snapshot\n\n')
        
        sh.write(f'echo "Iniciando simulação no Vivado (xsim)..."\n')
        sh.write('xsim work_snapshot -R\n')

    os.chmod(output_sh, 0o755)
    print(f"Sucesso! Gerado '{output_sh}'.")
    print(f" -> Arquivos Verilog/SV: {len(abs_sv_files)}")
    print(f" -> Arquivos VHDL: {len(abs_vhdl_files)}")
    print("Ordem de compilação original mantida!")

if __name__ == '__main__':
    main()
