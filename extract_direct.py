import os
import sys
import re

def main():
    # 1. Lê o log específico do teste direto
    log_file = 'dry_run_ace_direct.log'
    with open(log_file, 'r') as f:
        lines = f.readlines()

    files = []
    includes = []
    defines = []
    # 2. Top-level atualizado
    top_module = 'tb_ace_direct'

    for line in lines:
        matches = re.findall(r'[\w/\\.-]+\.(?:v|sv)\b', line)
        for m in matches:
            if m not in files:
                files.append(m)
        inc_matches = re.findall(r'\+incdir\+([^\s]+)', line)
        for m in inc_matches:
            if m not in includes:
                includes.append(m)
        def_matches = re.findall(r'\+define\+([^\s]+)', line)
        for m in def_matches:
            if m not in defines:
                defines.append(m)

    # 3. Diretório base da simulação do cache
    tb_dir = os.path.abspath('modules/cva6/corev_apu/tb/tb_wb_dcache')
    
    abs_files = []
    for f in files:
        if not os.path.isabs(f):
            abs_f = os.path.abspath(os.path.join(tb_dir, f))
        else:
            abs_f = f
        abs_files.append(abs_f)

    abs_includes = []
    for inc in includes:
        if not os.path.isabs(inc):
            abs_inc = os.path.abspath(os.path.join(tb_dir, inc))
        else:
            abs_inc = inc
        abs_includes.append(abs_inc)

    sorted_files = abs_files

    # 4. Gera um script de execução com nome exclusivo para este teste
    with open('run_vivado_direct.sh', 'w') as sh:
        sh.write('#!/bin/bash\nset -e\n\n')
        has_sv = any(f.endswith('.sv') for f in sorted_files)
        sv_flag = ' -sv' if has_sv else ''
        inc_flags = ' '.join([f'-i {d}' for d in abs_includes])
        def_flags = ' '.join([f'-d {d}' for d in defines])
        files_str = ' '.join(sorted_files)
        
        sh.write(f'xvlog -work work{sv_flag} {inc_flags} {def_flags} {files_str}\n\n')
        # Adicionado um nome de snapshot único para não conflitar
        sh.write(f'xelab -debug typical --timescale 1ns/1ps -top {top_module} -snapshot work_snapshot_direct\n\n')
        # Execução limpa sem firmware
        sh.write('xsim work_snapshot_direct -R\n')

    os.chmod('run_vivado_direct.sh', 0o755)
    print(f"Gerado run_vivado_direct.sh com {len(sorted_files)} arquivos para o alvo {top_module}.")

if __name__ == '__main__':
    main()
