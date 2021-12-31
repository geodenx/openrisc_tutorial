# OpenRISC on FPGA (2004)

[OpenRISC](http://www.opencores.org/pnews.cgi/list/or1k) とは、RTL (Register Transfer Level) の Verilog-HDL が公開されている 32 bit RISC CPU です。 gcc, binutils も移植され、uClinux なども動作しています。
[OpenCores](http://www.opencores.org) で配布されています。

ここでは配布されている [Tutorial](http://emsys.denayer.wenk.be/?proj=empro&page=intro) に沿って OpenRISC の構築方法を説明します。
具体的には、Altera の FPGA 上に OpenRISC を合成して、クロス開発環境を構築して、サンプルプログラムをコンパイルして、メモリに配置して実行します。
ただし、Tutorial と同じ環境が手に入らなかったので、ハードウェア構成やプログラムのローディング方法が Tutorial とは異なります。

OpenRISC is an open-source 32-bit RISC CPU written in Verilog, and distributed from OpenCores [opencores.org]. GCC and Binutils have been ported for the processor. uClinux also works on it.
Here, I explain how to configure OpenRISC along with a distributed tutorial. The explanation includes synthesizing OpenRISC on Altera FPGA,  building cross development environment,  compiling a sample program, and running the program allocated on memory. Although, I was not able to obtain the same environment as the tutorial, the hardware configuration and the way to load a program are different from the tutorial.

動作環境
- 評価ボード: 三菱電機マイコン機器ソフトウェア MMS PowerMedusa MU200-AP AP1500
- FPGA: Altera APEX2KE EP20K1500EBC652
- FPGA開発環境: Altera Qaurtus II version 4
- RTL開発環境: Cadence Verilog-XL 04.10.001-p
(そのまま合成するならば必ずしも必要ないですが、変更を加える場合は RTL simulation 無しでは辛いです。)
- Host PC: Windows (for Quartus II), Debian GNU/Linux sid (for gcc, binutils)

# Hardware
以下では、"Basic Custom OpenRISC System Hardware Tutorial (Altera)" の流れに沿って説明しますが、Tutorialとは違う方法で実装している部分も多いです。  Tutorial中で利用しているデバイスはStratixでしたが、手元にあるデバイスはAPEXです。 Stratixのメモリ(altsyncram)とAPEXのメモリ(lpm_ram_dq)ではbyte enableなど制御線が異なっているので、Tutorialの通りには配線できません。
また、評価ボードもTutorialと手元にあるものとは異なっています。 Tutorialではプログラムダウンロードやデバッグのため、JTAGケーブルを利用しています。 Tutorialで利用しているボードではFPGAのconfiguration用JTAG pin以外に、 FPGA内部のOpenRISC CPUのconfiguration用JTAG pinをFPGAのuser pinに割り当てXilinxのJTAGケーブルに接続しています。  手元のボードでOpenRISC用JTAG pinを用意できなかったので、プログラムをJTAGでダウンロードするのではなく、[Memory Initialization File](http://www.altera.co.jp/support/software/nativelink/quartus2/glossary/def_mif.html) (.mif) Description を利用して、 FPGA内部のSRAMの初期値としてプログラムをロードすることにしました。
こうすることで、user pinをJTAGに割り当ててdownloadしなくてもプログラムを実行できます。ただし、Quartus IIでの合成時にあらかじめプログラムをコンパイルし、MIFに変換しておく必要がありますので、プログラムを頻繁に入れ替えるには適していません。
そのような場合は、モニタプログラムをMIFで配置し、モニタプログラムでRS232CなどからRAMにプログラムを展開し実行するのが妥当だと思います。モニタは自作しないとなりませんが…。

## II Retreive Source Code
[OpenRISC Reference Platform (ORP)](http://www.opencores.org/projects.cgi/web/or1k/orp) をダウンロードします。cvs コマンドでなく [ORPsoc](http://www.opencores.org/projects.cgi/web/or1k/orpsoc) のCVSgetでdownloadしました。
```
$ tar zxvf or1k_orp_orp_soc.tar.gz
```

## III Adjust Source Code
`or1k/orp/orp_soc/rtl/verilog` 以下

### Delete unnecessary files
ディレクトリ audio, ethernet, ethernet.old, or1200.old, ps2, ps2.old, svga, uart16550.old と、
ファイルtdm_slave_if.v を削除

### Modiry `xsv_fpga_defines.v`
``define TARGET_VIRTEX` をコメントアウト

### Modify `xsv_fpga_top.v`
``include bench_defines.v` をコメントアウト

`module xsv_fpga_top1` part
```
2 global signals (clk, rstn)
2 uart signals (uart_stx, uart_srx)
7 jtag debug signals (jtag_tvref, jtag_tgnd, jtag_tck, jtag_tms, jtag_trst, jtag_tdi, jtag_tdo)
```
を残す。

`input and output` list
```
7 input: clk, rstn, uart_srx, jtag_tck, jtag_tms, jtag_trst, jtag_tdi
4 output: uart_stx, jtag_tvref, jtag_tgnd, jtag_tdo
```
を残す。

`internal wires` list

Debug core master i/f wires, Debug <-> RISC wires, RISC instruction master i/f wires, RISC data master i/f wires, RISC misc, SRAM controller slave i/f wires, UART16550 core slave i/f wires, UART external i/f wires, JTAG wires

を残す。

`assign` part

TutorialではPLLを用いて分周するが、手元のボードではFPGA外部分周器で10MHzの入力が可能なので、PLLは省略。
つまり、`assign wb_clk = clk;`はそのまま残す。

SRAM tri-state data, Ethernet tri-state, PS/2 Keyboard tri-state, Unused interrupts, RISC Instruction address for Flashは削除

Unused WISHBONE signalsは `assign wb_us_err_o = 1'b0;`だけ残す。

必要ならば、jtag_tvrefとjtag_tgndをVdd/GNDに固定
```
assign jtag_tvref = 1'b1;
assign jtag_tgnd = 1'b0;
```

`instantiations` part

Instantiation of the VGA CRT controller, Instantiation of the Audio controller, Instantiation of the Flash controller, Instantiation of the Ethernet 10/100 MAC, Instantiation of the PS/2 Keyboard Controller, Instantiation of the CPLD TDM

を削除。
残った、instantの宣言を修正
- ~~or1200_topのwb_clkをclkに変更~~ PLLを使わないのでwb_clkを繋げたままにしておく。
- or1200_topの最後の接続.pic_ints_iのpic_intsを20'b0に変更
- `sram_top sram_top` を `onchip_ram_top onchip_ram_top` に変更
- onchip_ram_top (sram_top) の // SRAM external 以下を削除
- uart_topの`.int_o(pic_ints[`APP_INT_UART])` を `.int_o()` に変更
- Traffic cop インスタンスを以下のように修正
  - MASTERS: Wishbone Initiatorの 0, 1, 2 を stub (Initiator 6, 7のよう)に置き換え
  - SLAVES: Wishbone Target 1, 2, 3, 4, 6を stub (Target 7, 8のよう)に置き換え
  - `.i4_wb_ack_o(wb_rdm_ack),`を`.i4_wb_ack_o(wb_rdm_ack_i),` に置き換え
  - `.i5_wb_adr_i(wb_rif_adr),を.i5_wb_adr_i(wb_rim_adr_o),`に置き換え 

以上の修正を加えた [xsv_fpga_top.v](xsv_fpga_top.v)

### Modify 1or1200/or1200_defines.v`
- Enable ``define OR1200_ALTERA_LPM`
- Disable ``define OR1200_XILINX_RAMB4`
- Enable ``define OR1200_NO_DC`, ``define OR1200_NO_IC`, ``define OR1200_NO_DMMU` and ``define OR1200_NO_IMMU`
- Disable ``define OR1200_CLKDIV_2_SUPPORTED`
- Disable ``define OR1200_RFRAM_DUALPORT`
- Enable ``define OR1200_RFRAM_GENERIC`
- Disable ``define OR1200_DU_TB_IMPLEMENTED

## ~~Modify `or1200/or1200_pc.v`~~
`or1200/or1200_cpu` になっていて、最初から `.genpc_stop_prefetch(1'b0)` になっていました。


## IV Add new components

### PLL component
FPGA外部の分周回路で10MHzのクロックを生成しFPGAに入力するため、省略しました。

### onchip RAM component
ここがORPにもTutorialにも含まれていない部分で苦労したところです。 TutorialではStratixを利用しているため、RAMはaltsyncramを利用します。 しかし、手元にあるデバイスはAPEXだったので、altsyncramは利用できません。 そこで入出力や動作がaltsyncramに似たものを作成できるlpm_ram_dqを利用しました。

StratixとAPEXはいろいろ違いはありますが、今回の一番の違いbyte enable信号の対応・未対応です。 altsyncramはbyte enable信号に対応していますが、lpm_ram_dqは対応していません。 OpenRISCはbyte accessがあり、Wishbone busのselect信号を利用するので、memoryにはbyte enable信号が必要です。 そこで、lpr_ram_dqを4つのbankに分割して作成し、byte enable信号をそれぞれのbankのwrite enableにデコードしました。

![system.png](../../blob/img/img/onchip_ram.png)

[onchip_ram.v](onchip_ram.v)

MIF Fileを呼んでいるので、onchip_ramをおいたdirectoryにonchip_ram_bank[0-3].mifを配置してください。
RTL simulationのための記述を含みます。`ifdefで分けてありますので、Quartus IIの合成では無視されます。

## V Synthesis, place & route, generating the bitstream
この手順に進む前に、onchip_ramの初期値 (MIF file)を用意しておく必要があります。 Softwareの項を先に読んで下さい。 <ol><li>Start Quartus II
- Create a new quartus project
- Select a directory
- Select the source files  
or1k/orp/orp_soc/rtl/verilog/以下で、 dbg_interface/dbg_*.v, or1200/or1200_*.v, uart16550/uart_*.v, uart16550/raminfr.v, xsv_fpga_top.v,  xsv_fpga_defines.v,  tc_top.vを選択します。  
また、onchip RAM component (onchip_ram.vとonchip_ram_bank[0-3].mif)を選択します。 onchip_ram_bank[0-3].mifについてはSoftware Tutorialで後述します。 MIFにあらかじめプログラムを記述するために、合成まえにプログラム開発環境を整えて、プログラムコンパイルしておく必要があります。
- include the library path names
- design entry synthesis tool
- select target family
- target component
- finish
- pin assign xsv_fpga_topの入出力pinを直接FPGAのpinにassignしてもいいのですが、 いつも評価ボード用のVerilog-HDLファイルを用意しているので、その中でxsv_fpga_topを呼び出します。 こうすることとで、pin assigmentをproject毎に再設定する必要がなくなります。
```
xsv_fpga_top xsv_fpga_top(OSC, RESET, RD1_OUT, TD1_IN,
                             jtag_tvref, jtag_tgnd,
                             jtag_tck, jtag_tms, jtag_trst, jtag_tdi, jtag_tdo);
```
今回はOpenRISC用のJTAGを利用しないので、debugモジュールをdisableにしておかないとなりません。 そこで、そのxsv_fpga_topを呼んでいる一番top levelのverilogでJTAGのpinの処理をしました。
```
wire  jtag_tck;
   assign  jtag_tck = 0;
   wire  jtag_tdo; // NC
   assign  jtag_tdo = 1'bz;
   wire  jtag_tms;
   assign  jtag_tms = 0;
   wire  jtag_tdi;
   assign  jtag_tdi = 0;
   wire  jtag_tvref; // NC
   assign  jtag_tvref = 1'bz;
   wire  jtag_tgnd; // NC
   assign  jtag_tgnd = 1'bz;
   wire  jtag_trst;
   assign  jtag_trst = 0; // 1?
```
- compilation  
Fitterの結果を引用します。
```
+---------------------------------------------------------------+
; Fitter Summary                                                ;
+-----------------------+---------------------------------------+
; Fitter Status         ; Successful - Fri Jul 09 10:56:02 2004 ;
; Revision Name         ; xsv_fpga_top                          ;
; Top-level Entity Name ; mu200                                 ;
; Family                ; APEX20KE                              ;
; Device                ; EP20K1500EBC652-3                     ;
; Total logic elements  ; 10,237 / 51,840 ( 19 % )              ;
; Total pins            ; 275 / 488 ( 56 % )                    ;
; Total memory bits     ; 196,864 / 442,368 ( 44 % )            ;
; Total PLLs            ; 0 / 4 ( 0 % )                         ;
+-----------------------+---------------------------------------+
```

## VI Download and test the OpenRISC
評価ボードとPCをRS232Cで接続し、シリアルターミナルを9600bpsで接続しておきます。 JTAGを接続して、*.sofをFPGAにdownloadします。 downloadが終ると自動的にreset vectorにおいたプログラムを実行開始します。 ターミナルに、"Hello World!"と表示されれば成功です。


# Software
"Basic Custom OpenRISC system Software Tutorial"を参考に、Debian GNU/Linux sid上で、 クロス開発環境、サンプルプログラム、実行バイナリ(Motorola S format)からMIFへの変換プログラムを用意しました。

## II GCC installation
gcc (クロス開発環境をコンパイルするためのコンパイラ) Tutorialではホスト用のgccは2.95.x or 2.96が必要と書かれていますが、とりあえず既存の環境で構築してみました。
```
$ gcc -v
gcc version 3.3.4 (Debian 1:3.3.4-2)
```
ただし、Debian sid (unstable)では、flexが新しすぎてクロスコンパイラ用のgccをうまくコンパイルできなかったので、flexはstable版に戻しました。
```
$ flex --version
flex version 2.5.31
# apt-get remove flex
# apt-get install flex/stable
$ flex --version
flex version 2.5.4
```

## III GNU Toolchain Installation
CVSからsourceを取得。
```
$ export CVSROOT=:pserver:anonymous@cvs.opencores.org:/cvsroot/anonymous
$ cvs login
$ cvs -z9 co or1k/binutils
$ cvs -z9 co or1k/gcc-3.2.3
$ cvs -z9 co or1k/gdb-5.0
$ cvs -z9 co or1k/hello-uart
```

binutils-2.11.93
```
$ export LANG=C
$ cd or1k; mkdir b-b; cd b-b
$ ../binutils/configure --target=or32-uclinux
$ make
# make install
```

gcc-3.2.3
```
$ cd ../or1k; mkdir b-gcc; cd b-gcc;
$ ../gcc-3.2.3/configure --target=or32-uclinux --with-gnu-as \
--with-gnu-ld --verbose --enable-languages=c
$ make
# make install
```

gdb-5.0
```
$ cd ../or1k; mkdir b-gcc; cd b-gcc;
$ ../gdb-5.0/configure --target=or32-uclinux
$ make
# make install
```

## IV Hello World
RS232Cに"Hello World!"を出力するサンプルプログラムをコンパイルします。
- `or1k/hello-uart/board.h` を修正  
clock 10MHz, RS232C 9600bps

```
#define IN_CLK         10000000
#define STACK_SIZE     0x1000
#define UART_BAUD_RATE 9600
#define UART_BASE      0x90000000
#define REG8(add)      *((volatile unsigned char *)(add))
#define REG16(add)     *((volatile unsigned short *)(add))
#define REG32(add)     *((volatile unsigned long *)(add))
```

- or1k/hello-uart/ram.ld を修正
```
ram     : ORIGIN = 0x00002000, LENGTH = 0x00002000
```

- make
  - [Makefile](Makefile)  
or1k/hello-uart/Makefileと入れ替え
  - [srec2mif.pl](srec2mif.pl)  
srec (Motorola S format)からMIF fileを生成するPerl script。or1k/hello-uart/に入れる
  - [srec2rtl.pl](srec2rtl.pl)
srec (Motorola S format)からonchip_ram.vからincludeされるRTL記述を生成する Perl script。
合成するだけならばRTL simulationはしないので要らない。
or1k/hello-uart/に入れる。

```
$ cd ../or1k/hello-uart
$ make
or32-uclinux-gcc -g -c -o reset.o reset.S  -Wa,-alnds=reset.log
or32-uclinux-gcc -g -c -o hello.o hello.c  -Wa,-alnds=hello.log
or32-uclinux-ld -Tram.ld -o hello.or32 reset.o hello.o 
or32-uclinux-objcopy -O srec hello.or32 hello.srec
or32-uclinux-objcopy -O ihex hello.or32 hello.ihex
or32-uclinux-objdump -S hello.or32 > hello.S
./srec2mif.pl hello.srec
./srec2rtl.pl hello.srec
```
生成された onchip_ram_bank[0-3].mif (MIF file), onchip_ram_bank[0-3].v (RTL simulation用) を onchip_ram.v と同じdirectoryに移動 (symbolic linkしておくと便利)。 MIFの準備ができたので、Quartusでの合成手順に進む。 

# References
- [OpenRISC](http://www.opencores.org/pnews.cgi/list/or1k)
  - OpenRISC 1000 Architecture Manual
  - OpenRISC 1000: GNU Toolchain Port
- [Tutorials](http://emsys.denayer.wenk.be/?proj=empro&page=intro) Resarch Group Digital Techniques, Hogeschool voor Wetenschap & Kunst.
  - Basic Custom OpenRISC System Hardware Tutorial (Altera)
  - Basic Custom OpenRISC System Hardware Tutorial (Xilinx)
  - Basic Custom OpenRISC system Software Tutorial
- [OR1K uClinux and simulator installation](http://www.asisi.co.uk/or1k.html)
