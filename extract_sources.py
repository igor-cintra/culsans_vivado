import os
import sys
import re

def main():
    log_file = 'dry_run.log'
    with open(log_file, 'r') as f:
        lines = f.readlines()

    files = []
    includes = []
    defines = []
    top_module = 'tb_ace'

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

    # REMOVIDO: A ordenação artificial de _pkg.sv. 
    # Vamos confiar na ordem exata em que o Questa compilou no dry_run.log.
    sorted_files = abs_files

    with open('run_vivado.sh', 'w') as sh:
        sh.write('#!/bin/bash\nset -e\n\n')
        has_sv = any(f.endswith('.sv') for f in sorted_files)
        sv_flag = ' -sv' if has_sv else ''
        inc_flags = ' '.join([f'-i {d}' for d in abs_includes])
        def_flags = ' '.join([f'-d {d}' for d in defines])
        files_str = ' '.join(sorted_files)
        
        sh.write(f'xvlog -work work{sv_flag} {inc_flags} {def_flags} {files_str}\n\n')
        sh.write(f'xelab -debug typical --timescale 1ns/1ps -top {top_module} -snapshot work_snapshot\n\n')
        sh.write('xsim work_snapshot -R\n')

    os.chmod('run_vivado.sh', 0o755)
    print(f"Gerado run_vivado.sh com {len(sorted_files)} arquivos, mantendo a ordem ORIGINAL do Makefile.")

if __name__ == '__main__':
    main()
