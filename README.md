# Culsans - tightly-coupled cache coherence unit using the ACE protocol (Vivado XSIM Fork)

> **Aviso de Fork:** Este repositório é um fork do projeto original [planvtech/culsans](https://github.com/planvtech/culsans). O objetivo deste trabalho é propor e desenvolver um fork do projeto Culsans, reestruturando sua infraestrutura de simulação para suportar nativamente a ferramenta AMD/Xilinx Vivado. A escolha do Vivado justifica-se por fornecer suporte integral e gratuito às bibliotecas UVM, contornando a restrição de licenciamento comercial da feature de randomização presente na edição gratuita do QuestaSim.

## Introduction

Aim of this project is the development of a tightly-coupled cache coherence unit for a multicore processor based on [CVA6](https://github.com/openhwgroup/cva6). Like the ancient god, its responsibilities are to maintain order (and data consistency) among the memory accesses performed by the 2~4 CPUs which are part of the system.

## Principais Modificações e Correções (Vivado Integration)

A integração do simulador Vivado (XSIM) ao ecossistema Culsans exigiu a reestruturação do fluxo de compilação e verificação original. As seguintes adaptações foram implementadas neste repositório:

* Os prefixos SSH no arquivo `.gitmodules` foram substituídos por URLs HTTPS. Essa alteração garante a automação da resolução de dependências em ambientes sem chaves criptográficas pré-configuradas.
* A verificação de versão que abortava a execução caso o compilador não fosse estritamente a versão 8 do GCC foi desativada. Isso permitiu a compilação com toolchains atualizadas, como o GCC 13.2.
* Um script de automação em Python (`extract_sources.py`) foi desenvolvido para converter automaticamente as flags proprietárias do QuestaSim para a sintaxe nativa do Vivado.
* Foi aplicada uma refatoração pontual no pacote de testes do cache (`tb_dcache_pkg.sv`), renomeando a função problemática `empty` para `is_empty`. Esta adequação semântica contornou a falha do parser de resolução de nomes inerente à ferramenta da AMD/Xilinx.
* Uma condição de corrida (race condition) no arquivo `dcache_checker.sv` foi corrigida com a substituição da macro `WAIT_SIG` por um laço `while` que aguarda a conjunção dos sinais `cr_valid` e `cr_ready`, garantindo a aderência ao protocolo de handshake bidirecional.
* Uma segunda condição de corrida foi mitigada através da inserção de um laço de espera no escalonador (`request_scheduler.sv`), forçando a espera pela disponibilidade do verificador antes da injeção de uma nova transação.
* Uma macro privada `WAIT_DIRECT`, contendo um atraso procedural de `#0.1ps`, foi criada exclusivamente para o testbench `tb_ace_direct`. Essa abordagem de isolamento de macros garantiu que cada ambiente de verificação operasse com a sincronização de delta-cycles adequada, corrigindo o travamento da simulação durante a fase de aquecimento.
* Incompatibilidades na tipagem de mailboxes parametrizadas nos testes unitários (`culsans_tb`) foram corrigidas através da criação de aliases de tipo, garantindo a identidade nominal exigida pelo Vivado.

### Resultados de Verificação

* O testbench `tb_ace` executou de forma ininterrupta e concluiu com sucesso na rodada 44.056, alcançando 100% de cobertura funcional. 
* O ambiente processou um total de 44.057 transações, com uma taxa de acerto de cache de aproximadamente 89% para leituras.

## Getting started

```bash
git clone [https://github.com/igor-cintra/culsans_vivado.git](https://github.com/igor-cintra/culsans_vivado.git) --recursive
