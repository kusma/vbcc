
# used to create vbcc, vc and ucpp
CC = gcc -std=c9x -g -DHAVE_AOS4 #-DHAVE_ECPP -DHAVE_MISRA
LDFLAGS = -lm
MKDIR = mkdir -p
RM = rm -f
INSTALL = install

ifdef COMSPEC
X = .exe
endif

# native version; used to create dtgen
NCC = $(CC)
NLDFLAGS = $(LDFLAGS)

all: bin bin/vc$X bin/vprof$X bin/vbcc$(TARGET)$X #bin/vcpp$X

install: all
	$(INSTALL) -D bin/vc$X $(DESTDIR)/bin/vc$X
	$(INSTALL) -D bin/vprof$X $(DESTDIR)/bin/vprof$X
	$(INSTALL) -D bin/vbcc$(TARGET)$X $(DESTDIR)/bin/vbcc$(TARGET)$X

install-doc: doc/vbcc.pdf
	$(INSTALL) -D doc/vbcc.pdf $(DESTDIR)/share/doc/vbcc/vbcc.pdf

bin:
	$(MKDIR) bin

clean:
	$(RM) bin/* $(vcppobjs) $(bobjects) $(fobjects) $(sobjects) $(tasm) $(mbasic) $(minicomp) $(vscobjects)

vbccs: bin/vbccs$(TARGET)

bin/vc$X: frontend/vc.c
	$(CC) frontend/vc.c -o $@ $(LDFLAGS)

bin/vprof$X: vprof/vprof.c
	$(CC) vprof/vprof.c -o $@ $(LDFLAGS)

doc/vbcc.pdf:
	(cd doc; texi2dvi --pdf vbcc.texi)

doc/vbcc.html:
	(cd doc;texi2html -split=chapter -nosec_nav -frames vbcc.texi)
	sed -e s/vbcc_13/vbcc_1/ <doc/vbcc_frame.html >doc/vbcc.html

vcppobjs = vcpp/cpp.o vcpp/eval.o vcpp/getopt.o vcpp/hideset.o vcpp/include.o \
	   vcpp/lex.o vcpp/macro.o vcpp/nlist.o vcpp/tokens.o vcpp/unix.o

vbcc.tar.gz:
	(cd ..;tar zcvf vbcc.tar.gz vbcc/Makefile vbcc/*.[ch] vbcc/datatypes/*.[ch] vbcc/doc/*.texi vbcc/frontend/vc.c vbcc/machines/*/machine.[ch] vbcc/machines/*/machine.dt vbcc/machines/*/schedule.[ch] vbcc/ucpp/*.[ch] vbcc/ucpp/README vbcc/vprof/vprof.c vbcc/vsc/vsc.[ch])

bin/osekrm$X: osekrm.c
	$(CC) osekrm.c -o $@

dist: bin/osekrm$X
	mv supp.h t1
	mv supp.c t2
	mv main.c t3
	mv machines/ppc/machine.c t4
	mv declaration.c t5
	mv flow.c t6
	mv ic.c t7
	mv parse_expr.c t8
	mv statements.c t9
	mv rd.c t10
	mv type_expr.c t11
	bin/osekrm$X <t1 >supp.h
	bin/osekrm$X <t2 >supp.c
	bin/osekrm$X <t3 >main.c
	bin/osekrm$X <t4 >machines/ppc/machine.c
	bin/osekrm$X <t5 >declaration.c
	bin/osekrm$X <t6 >flow.c
	bin/osekrm$X <t7 >ic.c
	bin/osekrm$X <t8 >parse_expr.c
	bin/osekrm$X <t9 >statements.c
	bin/osekrm$X <t10 >rd.c
	bin/osekrm$X <t11 >type_expr.c
	make vbcc.tar.gz
	mv t1 supp.h
	mv t2 supp.c
	mv t3 main.c
	mv t4 machines/ppc/machine.c
	mv t5 declaration.c
	mv t6 flow.c
	mv t7 ic.c
	mv t8 parse_expr.c
	mv t9 statements.c
	mv t10 rd.c
	mv t11 type_expr.c	

bin/vcpp$X: $(vcppobjs)
	$(CC) $(LDFLAGS) $(vcppobjs) -o $@

vcpp/cpp.o: vcpp/cpp.c vcpp/cpp.h
	$(CC) -c -Ivcpp vcpp/cpp.c -o $@

vcpp/eval.o: vcpp/eval.c vcpp/cpp.h
	$(CC) -c -Ivcpp vcpp/eval.c -o $@

vcpp/getopt.o: vcpp/getopt.c
	$(CC) -c -Ivcpp vcpp/getopt.c -o $@

vcpp/hideset.o: vcpp/hideset.c vcpp/cpp.h
	$(CC) -c -Ivcpp vcpp/hideset.c -o $@

vcpp/include.o: vcpp/include.c vcpp/cpp.h
	$(CC) -c -Ivcpp vcpp/include.c -o $@

vcpp/lex.o: vcpp/lex.c vcpp/cpp.h
	$(CC) -c -Ivcpp vcpp/lex.c -o $@

vcpp/macro.o: vcpp/macro.c vcpp/cpp.h
	$(CC) -c -Ivcpp vcpp/macro.c -o $@

vcpp/nlist.o: vcpp/nlist.c vcpp/cpp.h
	$(CC) -c -Ivcpp vcpp/nlist.c -o $@

vcpp/tokens.o: vcpp/tokens.c vcpp/cpp.h
	$(CC) -c -Ivcpp vcpp/tokens.c -o $@

vcpp/unix.o: vcpp/unix.c vcpp/cpp.h
	$(CC) -c -Ivcpp vcpp/unix.c -o $@

TRGDIR = machines/$(TARGET)

bobjects = $(TRGDIR)/main.o $(TRGDIR)/vars.o $(TRGDIR)/declaration.o \
	   $(TRGDIR)/parse_expr.o $(TRGDIR)/type_expr.o $(TRGDIR)/ic.o \
	   $(TRGDIR)/machine.o $(TRGDIR)/statements.o \
	   $(TRGDIR)/supp.o $(TRGDIR)/dt.o \
           $(TRGDIR)/assert.o $(TRGDIR)/cpp.o $(TRGDIR)/hash.o \
           $(TRGDIR)/lexer.o $(TRGDIR)/macro.o $(TRGDIR)/mem.o \
           $(TRGDIR)/eval.o
#           $(TRGDIR)/AdjList.o $(TRGDIR)/DUChain.o \
#           $(TRGDIR)/ICodeInsertion.o $(TRGDIR)/NodeList.o \
#           $(TRGDIR)/RAllocMain.o $(TRGDIR)/Web.o

fobjects = $(TRGDIR)/opt.o $(TRGDIR)/av.o $(TRGDIR)/rd.o $(TRGDIR)/regs.o \
	   $(TRGDIR)/flow.o $(TRGDIR)/cse.o $(TRGDIR)/cp.o $(TRGDIR)/loop.o \
	   $(TRGDIR)/alias.o $(bobjects)

sobjects = $(TRGDIR)/opts.o $(TRGDIR)/regss.o $(bobjects)

tasm	 = $(TRGDIR)/supp.o $(TRGDIR)/tasm.o $(TRGDIR)/dt.o \
	   $(TRGDIR)/opt.o $(TRGDIR)/av.o $(TRGDIR)/rd.o $(TRGDIR)/regs.o \
	   $(TRGDIR)/flow.o $(TRGDIR)/cse.o $(TRGDIR)/cp.o $(TRGDIR)/loop.o \
	   $(TRGDIR)/alias.o $(TRGDIR)/machine.o

mbasic	 = $(TRGDIR)/supp.o $(TRGDIR)/mbasic.o $(TRGDIR)/dt.o \
	   $(TRGDIR)/opt.o $(TRGDIR)/av.o $(TRGDIR)/rd.o $(TRGDIR)/regs.o \
	   $(TRGDIR)/flow.o $(TRGDIR)/cse.o $(TRGDIR)/cp.o $(TRGDIR)/loop.o \
	   $(TRGDIR)/alias.o $(TRGDIR)/machine.o

minicomp	 = $(TRGDIR)/supp.o $(TRGDIR)/minicompg.tab.o $(TRGDIR)/minicomp.o $(TRGDIR)/dt.o \
	   $(TRGDIR)/opt.o $(TRGDIR)/av.o $(TRGDIR)/rd.o $(TRGDIR)/regs.o \
	   $(TRGDIR)/flow.o $(TRGDIR)/cse.o $(TRGDIR)/cp.o $(TRGDIR)/loop.o \
	   $(TRGDIR)/alias.o $(TRGDIR)/machine.o

vscobjects = $(TRGDIR)/vsc.o $(TRGDIR)/schedule.o

bin/vbcc$(TARGET)$X: $(fobjects)
	$(CC) $(LDFLAGS) $(fobjects) -o $@

bin/vbccs$(TARGET)$X: $(sobjects)
	$(CC) $(LDFLAGS) $(sobjects) -o $@

bin/vsc$(TARGET)$X: $(vscobjects)
	$(CC) $(LDFLAGS) $(vscobjects) -o $@

bin/tasm$(TARGET)$X: $(tasm)
	$(CC) $(LDFLAGS) $(tasm) -o $@

bin/mbasic$(TARGET)$X: $(mbasic)
	$(CC) $(LDFLAGS) $(mbasic) -o $@

bin/minicomp$(TARGET)$X: $(minicomp)
	$(CC) $(LDFLAGS) $(minicomp) -o $@

bin/dtgen$X: datatypes/dtgen.c datatypes/datatypes.h datatypes/dtconv.h
	$(NCC) datatypes/dtgen.c -o $@ -Idatatypes $(NLDFLAGS)

$(TRGDIR)/dt.h: bin/dtgen$X $(TRGDIR)/machine.dt
	bin/dtgen$X $(TRGDIR)/machine.dt $(TRGDIR)/dt.h $(TRGDIR)/dt.c

$(TRGDIR)/dt.c: bin/dtgen$X $(TRGDIR)/machine.dt
	bin/dtgen$X $(TRGDIR)/machine.dt $(TRGDIR)/dt.h $(TRGDIR)/dt.c

$(TRGDIR)/dt.o: $(TRGDIR)/dt.h $(TRGDIR)/dt.c
	$(CC) -c $(TRGDIR)/dt.c -o $@ -I$(TRGDIR) -Idatatypes

$(TRGDIR)/tasm.o: tasm.c supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c tasm.c -o $@ -I$(TRGDIR)

$(TRGDIR)/mbasic.o: mbasic.c supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c mbasic.c -o $@ -I$(TRGDIR)

$(TRGDIR)/minicomp.o: minicomp.c minicomp.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c minicomp.c -o $@ -I$(TRGDIR)

$(TRGDIR)/minicompg.tab.o: minicompg.y minicomplexer.c minicomp.h supp.h
	bison minicompg.y
	$(CC) -c minicompg.tab.c -o $@ -I$(TRGDIR)

$(TRGDIR)/supp.o: supp.c supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c supp.c -o $@ -I$(TRGDIR)

$(TRGDIR)/main.o: main.c vbc.h supp.h vbcc_cpp.h ucpp/cpp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c main.c -o $@ -I$(TRGDIR)

$(TRGDIR)/vars.o: vars.c vbc.h supp.h $(TRGDIR)/machine.h errors.h $(TRGDIR)/dt.h
	$(CC) -c vars.c -o $@ -I$(TRGDIR)

$(TRGDIR)/declaration.o: declaration.c vbc.h supp.h vbcc_cpp.h ucpp/cpp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c declaration.c -o $@ -I$(TRGDIR)

$(TRGDIR)/parse_expr.o: parse_expr.c vbc.h supp.h vbcc_cpp.h ucpp/cpp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c parse_expr.c -o $@ -I$(TRGDIR)

$(TRGDIR)/type_expr.o: type_expr.c vbc.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c type_expr.c -o $@ -I$(TRGDIR)

$(TRGDIR)/ic.o: ic.c vbc.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c ic.c -o $@ -I$(TRGDIR)

$(TRGDIR)/statements.o: statements.c vbc.h supp.h vbcc_cpp.h ucpp/cpp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c statements.c -o $@ -I$(TRGDIR)

$(TRGDIR)/opt.o: opt.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c opt.c -o $@ -I$(TRGDIR)

$(TRGDIR)/av.o: av.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c av.c -o $@ -I$(TRGDIR)

$(TRGDIR)/rd.o: rd.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c rd.c -o $@ -I$(TRGDIR)

$(TRGDIR)/regs.o: regs.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c regs.c -o $@ -I$(TRGDIR)

$(TRGDIR)/flow.o: flow.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c flow.c -o $@ -I$(TRGDIR)

$(TRGDIR)/cse.o: cse.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c cse.c -o $@ -I$(TRGDIR)

$(TRGDIR)/cp.o: cp.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c cp.c -o $@ -I$(TRGDIR)

$(TRGDIR)/loop.o: loop.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c loop.c -o $@ -I$(TRGDIR)

$(TRGDIR)/alias.o: alias.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c alias.c -o $@ -I$(TRGDIR)

$(TRGDIR)/preproc.o: preproc.c vbpp.h supp.h vbc.h $(TRGDIR)/dt.h
	$(CC) -c preproc.c -o $@ -I$(TRGDIR)

$(TRGDIR)/assert.o: ucpp/assert.c ucpp/cpp.h ucpp/mem.h ucpp/hash.h ucpp/tune.h $(TRGDIR)/dt.h
	$(CC) -DNO_UCPP_ERROR_FUNCTIONS -c ucpp/assert.c -o $@ -I$(TRGDIR)

$(TRGDIR)/cpp.o: ucpp/cpp.c ucpp/cpp.h ucpp/mem.h ucpp/hash.h ucpp/tune.h $(TRGDIR)/dt.h
	$(CC) -DNO_UCPP_ERROR_FUNCTIONS -c ucpp/cpp.c -o $@ -I$(TRGDIR)

$(TRGDIR)/hash.o: ucpp/hash.c ucpp/cpp.h ucpp/mem.h ucpp/hash.h ucpp/tune.h $(TRGDIR)/dt.h
	$(CC) -DNO_UCPP_ERROR_FUNCTIONS -c ucpp/hash.c -o $@ -I$(TRGDIR)

$(TRGDIR)/lexer.o: ucpp/lexer.c ucpp/cpp.h ucpp/mem.h ucpp/hash.h ucpp/tune.h $(TRGDIR)/dt.h
	$(CC) -DNO_UCPP_ERROR_FUNCTIONS -c ucpp/lexer.c -o $@ -I$(TRGDIR)

$(TRGDIR)/macro.o: ucpp/macro.c ucpp/cpp.h ucpp/mem.h ucpp/hash.h ucpp/tune.h $(TRGDIR)/dt.h
	$(CC) -DNO_UCPP_ERROR_FUNCTIONS -c ucpp/macro.c -o $@ -I$(TRGDIR)

$(TRGDIR)/mem.o: ucpp/mem.c ucpp/cpp.h ucpp/mem.h ucpp/hash.h ucpp/tune.h $(TRGDIR)/dt.h
	$(CC) -DNO_UCPP_ERROR_FUNCTIONS -c ucpp/mem.c -o $@ -I$(TRGDIR)

$(TRGDIR)/eval.o: ucpp/eval.c ucpp/cpp.h ucpp/mem.h ucpp/tune.h $(TRGDIR)/dt.h
	$(CC) -DNO_UCPP_ERROR_FUNCTIONS -c ucpp/eval.c -o $@ -I$(TRGDIR)

$(TRGDIR)/machine.o: $(TRGDIR)/machine.c supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h dwarf2.c
	$(CC) -c $(TRGDIR)/machine.c -o $@ -I$(TRGDIR) -I.

$(TRGDIR)/opts.o: opt.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c -DNO_OPTIMIZER opt.c -o $@ -I$(TRGDIR)

$(TRGDIR)/regss.o: regs.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c -DNO_OPTIMIZER regs.c -o $@ -I$(TRGDIR)

$(TRGDIR)/vsc.o: vsc/vsc.h vsc/vsc.c $(TRGDIR)/schedule.h
	$(CC) -c vsc/vsc.c -o $@ -I$(TRGDIR)

$(TRGDIR)/schedule.o: vsc/vsc.h $(TRGDIR)/schedule.h $(TRGDIR)/schedule.c
	$(CC) -c $(TRGDIR)/schedule.c -o $@ -I$(TRGDIR) -Ivsc


# Graph coloring register allocator by Alex
$(TRGDIR)/AdjList.o: GCRegAlloc/AdjList.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c GCRegAlloc/AdjList.c -o $@ -IGCRegAlloc -I$(TRGDIR)

$(TRGDIR)/DUChain.o: GCRegAlloc/DUChain.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c GCRegAlloc/DUChain.c -o $@ -IGCRegAlloc -I$(TRGDIR)

$(TRGDIR)/ICodeInsertion.o: GCRegAlloc/ICodeInsertion.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c GCRegAlloc/ICodeInsertion.c -o $@ -IGCRegAlloc -I$(TRGDIR)

$(TRGDIR)/NodeList.o: GCRegAlloc/NodeList.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c GCRegAlloc/NodeList.c -o $@ -IGCRegAlloc -I$(TRGDIR)

$(TRGDIR)/RAllocMain.o: GCRegAlloc/RAllocMain.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c GCRegAlloc/RAllocMain.c -o $@ -IGCRegAlloc -I$(TRGDIR)

$(TRGDIR)/Web.o: GCRegAlloc/Web.c opt.h supp.h $(TRGDIR)/machine.h $(TRGDIR)/dt.h
	$(CC) -c GCRegAlloc/Web.c -o $@ -IGCRegAlloc -I$(TRGDIR)
