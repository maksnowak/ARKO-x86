EXEFILE = smul
OBJECTS = stringmultiply.o smul.o
CCFMT = -m32 -g
NASMFMT = -f elf32 -g -F dwarf
CCOPT = 
NASMOPT = -w+all

.c.o:
	cc $(CCFMT) $(CCOPT) -c $<

.s.o:
	nasm $(NASMFMT) $(NASMOPT) -l $*.lst $<

$(EXEFILE): $(OBJECTS)
	cc $(CCFMT) -o $@ $^
	
clean:
	rm *.o *.lst $(EXEFILE)
