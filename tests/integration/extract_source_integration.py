import os
import re

def expand_flist(flist_path, cwd, all_files_set):
    files = []
    includes = []
    defines = []
    if not os.path.exists(flist_path):
        print(f"AVISO: Flist nao encontrado: {flist_path}")
        return files, includes, defines
        
    with open(flist_path, 'r') as f:
        for line in f:
            line = line.strip()
            
            # Converte sintaxe de Makefile $(VAR) para bash ${VAR}
            line = re.sub(r'\$\(([^)]+)\)', r'${\1}', line)
            line = os.path.expandvars(line)
            
            # Pula linhas em branco ou comentários
            if not line or line.startswith('#') or line.startswith('//'):
                continue
                
            incs = re.findall(r'(?:\+incdir\+|-I\s*)([^\s+-][^\s]*)', line)
            for inc in incs:
                includes.append(os.path.abspath(os.path.join(cwd, inc)) if not os.path.isabs(inc) else inc)
                line = line.replace(f'+incdir+{inc}', '').replace(f'-I {inc}', '').replace(f'-I{inc}', '')
                
            defs = re.findall(r'(?:\+define\+|-D\s*)([a-zA-Z0-9_]+(?:=[^\s]+)?)', line)
            for d in defs:
                defines.append(d)
                line = line.replace(f'+define+{d}', '').replace(f'-D {d}', '').replace(f'-D{d}', '')
                
            sub_flists = re.findall(r'-f\s+([^\s]+)', line)
            for sf in sub_flists:
                abs_sf = os.path.abspath(os.path.join(cwd, sf)) if not os.path.isabs(sf) else sf
                sf_files, sf_incs, sf_defs = expand_flist(abs_sf, cwd, all_files_set)
                files.extend(sf_files)
                includes.extend(sf_incs)
                defines.extend(sf_defs)
                line = line.replace(f'-f {sf}', '').replace(f'-f{sf}', '')
                
            # Extrai os arquivos dividindo a linha por espaços (muito mais seguro que Regex!)
            for token in line.split():
                if token.endswith('.v') or token.endswith('.sv'):
                    abs_f = os.path.abspath(os.path.join(cwd, token)) if not os.path.isabs(token) else token
                    
                    if os.path.exists(abs_f):
                        if abs_f not in all_files_set:
                            files.append(abs_f)
                            all_files_set.add(abs_f)
                    else:
                        print(f"AVISO: Arquivo ignorado pois nao foi encontrado no disco: {abs_f}")
                        
    return files, includes, defines

def main():
    log_file = 'dry_run_integration.log'
    out_script = 'run_vivado_integration.sh'
    if not os.path.exists(log_file):
        print(f"ERRO: Arquivo {log_file} não encontrado.")
        return

    tb_dir = os.path.abspath('.')
    
    # Ensina todas as variações de nomes de variáveis de configuração do CVA6
    config_name = 'cv64a6_imafdc_sv39_wb'
    os.environ['CVA6_REPO_DIR'] = os.path.abspath(os.path.join(tb_dir, '../../modules/cva6'))
    os.environ['target'] = config_name
    os.environ['TARGET'] = config_name
    os.environ['TARGET_CFG'] = config_name
    os.environ['CVA6_CONFIG'] = config_name
    os.environ['CVA6_CFG'] = config_name

    with open(log_file, 'r') as f:
        lines = f.readlines()

    top_module = 'culsans_tb' 
    all_files_set = set() 

    with open(out_script, 'w') as sh:
        sh.write('#!/bin/bash\nset -e\n\n')
        sh.write(f'# Muda para a pasta de testes\n')
        sh.write(f'cd {tb_dir}\n\n')
        
        step = 1
        for line in lines:
            line = line.strip()
            
            line = re.sub(r'\$\(([^)]+)\)', r'${\1}', line)
            line = os.path.expandvars(line)
            
            if line.startswith('vlog'):
                abs_files = []
                # Pega arquivos de forma segura, separando por espaço
                inline_files = [tok for tok in line.split() if tok.endswith('.v') or tok.endswith('.sv')]
                
                for f in inline_files:
                    abs_f = os.path.abspath(os.path.join(tb_dir, f)) if not os.path.isabs(f) else f
                    
                    if os.path.exists(abs_f):
                        if abs_f not in all_files_set:
                            abs_files.append(abs_f)
                            all_files_set.add(abs_f)
                    else:
                        print(f"AVISO: Arquivo SV ignorado pois nao existe: {abs_f}")
                
                inline_incs = re.findall(r'(?:\+incdir\+|-I\s*)([^\s+-][^\s]*)', line)
                abs_incs = [os.path.abspath(os.path.join(tb_dir, inc)) if not os.path.isabs(inc) else inc for inc in inline_incs]
                inline_defs = re.findall(r'(?:\+define\+|-D\s*)([a-zA-Z0-9_]+(?:=[^\s]+)?)', line)
                
                flists = re.findall(r'-f\s+([^\s]+)', line)
                for flist in flists:
                    abs_flist = os.path.abspath(os.path.join(tb_dir, flist)) if not os.path.isabs(flist) else flist
                    f_files, f_incs, f_defs = expand_flist(abs_flist, tb_dir, all_files_set)
                    abs_files.extend(f_files)
                    abs_incs.extend(f_incs)
                    inline_defs.extend(f_defs)
                
                final_incs = list(dict.fromkeys(abs_incs))
                final_defs = list(dict.fromkeys(inline_defs))
                
                if abs_files:
                    inc_flags = ' '.join([f'--include {d}' for d in final_incs])
                    def_flags = ' '.join([f'--define {d}' for d in final_defs])
                    
                    sh.write(f'# Passo {step}: Analise Sequencial SV\n')
                    sh.write(f'xvlog -work work -sv {inc_flags} {def_flags} \\\n')
                    for f in abs_files:
                        sh.write(f'  {f} \\\n')
                    sh.write('\n\n')
                    step += 1

            elif line.startswith('vcom'):
                abs_files = []
                inline_files = [tok for tok in line.split() if tok.endswith('.vhd')]
                
                for f in inline_files:
                    abs_f = os.path.abspath(os.path.join(tb_dir, f)) if not os.path.isabs(f) else f
                    
                    if os.path.exists(abs_f):
                        if abs_f not in all_files_set:
                            abs_files.append(abs_f)
                            all_files_set.add(abs_f)
                    else:
                        print(f"AVISO: Arquivo VHDL ignorado pois nao existe: {abs_f}")
                
                if abs_files:
                    sh.write(f'# Passo {step}: Analise Sequencial VHDL\n')
                    sh.write('xvhdl -work work -2008 \\\n')
                    for f in abs_files:
                        sh.write(f'  {f} \\\n')
                    sh.write('\n\n')
                    step += 1

        sh.write('# Passo Final: Elaboracao e Simulacao\n')
        sh.write(f'xelab -debug typical -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --timescale 1ns/1ps -top {top_module} -snapshot work_snapshot\n\n')
        sh.write('xsim work_snapshot -R\n')

    os.chmod(out_script, 0o755)
    print("Sucesso! Caminhos processados corretamente sem usar Regex.")

if __name__ == '__main__':
    main()