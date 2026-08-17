import os
import re
import glob

def main():
    log_file = 'dry_run.log'
    output_script = 'pass.sh'
    
    try:
        with open(log_file, 'r') as f:
            lines = f.readlines()
    except FileNotFoundError:
        print(f"Erro: Arquivo '{log_file}' não encontrado.")
        return

    top_module = 'culsans_tb'
    libraries = set(['work']) 
    
    # Regexes para capturar dados
    work_re = re.compile(r'-work\s+([^\s]+)')
    incdir_re = re.compile(r'\+incdir\+([^\s]+)')
    define_re = re.compile(r'\+define\+([^\s]+)')
    file_re = re.compile(r'([^\s]+\.(?:v|sv))\b')
    f_file_re = re.compile(r'-[fF]\s+([^\s]+)') # Captura listas de arquivos
    
    sys_cmds = ('mkdir', 'cp', 'ln', 'cd', 'export', 'echo', 'python')
    script_lines = []

    for line in lines:
        line = line.strip()
        if not line:
            continue
            
        if line.startswith(sys_cmds):
            script_lines.append(line)
            continue
            
        if line.startswith('vlog'):
            work_match = work_re.search(line)
            lib = work_match.group(1) if work_match else 'work'
            libraries.add(lib)
            
            # Extração da linha principal
            includes = incdir_re.findall(line)
            defines = define_re.findall(line)
            files = file_re.findall(line)
            
            # Busca profunda em arquivos .f / .flist
            f_files = f_file_re.findall(line)
            for f_file in f_files:
                try:
                    with open(f_file, 'r') as f_list:
                        f_content = f_list.read()
                        includes.extend(incdir_re.findall(f_content))
                        defines.extend(define_re.findall(f_content))
                        files.extend(file_re.findall(f_content))
                except FileNotFoundError:
                    print(f"Aviso: Arquivo de lista '{f_file}' não encontrado. Pode causar falhas.")

            if files:
                # Remove duplicatas mantendo a ordem original (vital para pacotes)
                files = list(dict.fromkeys(files))
                
                # --- INÍCIO DA AUTO-CORREÇÃO ---
                for i, f in enumerate(files):
                    if f.endswith('_config_pkg.sv') and not os.path.exists(f):
                        dir_path = os.path.dirname(f)
                        # Busca qualquer arquivo real que termine com _config_pkg.sv nessa pasta
                        possible_configs = glob.glob(os.path.join(dir_path, '*_config_pkg.sv'))
                        if possible_configs:
                            files[i] = possible_configs[0]
                            print(f"🔧 Auto-corrigido: {os.path.basename(f)} -> {os.path.basename(possible_configs[0])}")
                # --- FIM DA AUTO-CORREÇÃO ---

                inc_flags = ' '.join([f'-i {d}' for d in includes])
                def_flags = ' '.join([f'-d {d}' for d in defines])
                files_str = ' '.join(files)
                
                has_sv = any(f.endswith('.sv') for f in files)
                sv_flag = ' --sv' if has_sv else ''
                
                cmd = f"xvlog{sv_flag} -work {lib} {inc_flags} {def_flags} {files_str}"
                cmd = re.sub(r'\s+', ' ', cmd)
                script_lines.append(cmd)

    elaboration_libs = ' '.join([f'-L {lib}' for lib in libraries])
    xelab_cmd = f"xelab {elaboration_libs} work.{top_module} -debug typical -s work_snapshot"
    script_lines.append(xelab_cmd)
    script_lines.append("xsim work_snapshot -gui")

    with open(output_script, 'w') as sh:
        sh.write('#!/bin/bash\nset -e\n\n')
        for cmd in script_lines:
            sh.write(cmd + '\n')

    os.chmod(output_script, 0o755)
    print(f"Gerado {output_script} com expansão profunda de arquivos -f.")

if __name__ == '__main__':
    main()