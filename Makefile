SOURCES := $(shell find . -name "*.asm")
TARGETS := $(SOURCES:%.asm=%.gb)
INCLUDES := $(shell find . -name "*.inc")

all: $(TARGETS)

%.o: %.asm $(INCLUDES)
	rgbasm -h -i include/ -o $@ $<
	
%.gb: %.o
	rgblink -o $@ -n $(@:%.gb=%.sym) $<
	rgbfix -jv -t $(shell echo $(notdir $(@:%.gb=%)) | tail -c 15) $@
	
clean:
	@rm -f $(TARGETS) $(TARGETS:%.gb=%.sym) $(TARGETS:%.gb=%.o)
