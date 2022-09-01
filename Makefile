APPLET_NAME 			:= helloworldstk.HelloWorldSTK
APPLET_AID      		:= 0xd0:0x70:0x02:0xca:0x44:0x90:0x01:0x01
PACKAGE_NAME    		:= helloworldstk
PACKAGE_AID     		:= 0xd0:0x70:0x02:0xCA:0x44:0x90:0x01
PACKAGE_VERSION 		:= 1.0
MAX_MENU_ENTRY_TEXT		:= 15
MAX_MENU_ENTRIES 		:= 5
ACCESS_DOMAIN 			:= FF

JC 			:= javac
JAVA		:= java
JAVA_HOME	:= /usr/lib/jvm/default

SOURCES := $(wildcard src/**/*.java)
DEST := build
CLS := $(SOURCES:src/%.java=$(DEST)/%.class)
CAP_FILE := $(DEST)/$(PACKAGE_NAME)/javacard/$(PACKAGE_NAME).cap

JAVACARD_ROOT 		:= stks/oracle_javacard_sdks/jc221_kit
STK_ROOT 			:= stks/0319_805
JAVACARD_EXPORTS	:= $(JAVACARD_ROOT)/api_export_files
CONVERTER 			:= env JAVA_HOME=$(JAVA_HOME) $(JAVACARD_ROOT)/bin/converter
GP					:= java -jar lib/gp.jar
PARAMS_GEN			:= python lib/params_gen.py

CLASSPATH := $(JAVACARD_ROOT)/lib/api.jar:$(STK_ROOT)/sim.jar
JCFLAGS   := -target 1.1 -source 1.3 -g -d $(DEST) -classpath "$(CLASSPATH)" 
INSTALL_PARMAS := $(shell $(PARAMS_GEN) --enable-sim-toolkit --max-menu-entry-text $(MAX_MENU_ENTRY_TEXT) --max-menu-entries $(MAX_MENU_ENTRIES) --access-domain $(ACCESS_DOMAIN))

include keys.env

.PHONY: compile clean install delete

install: $(CAP_FILE) 
	$(GP) -d -v -i -install $(CAP_FILE) \
		-key-enc $(KEY_ENC) \
		-key-mac $(KEY_MAC) \
		-key-dek $(KEY_DEK) \
		-params $(INSTALL_PARMAS)

delete:
	$(GP) -delete $(PACKAGE_AID) \
		-key-enc $(KEY_ENC) \
		-key-mac $(KEY_MAC) \
		-key-dek $(KEY_DEK)

list:
	$(GP) -list \
		-key-enc $(KEY_ENC) \
		-key-mac $(KEY_MAC) \
		-key-dek $(KEY_DEK)

compile: $(CAP_FILE)

clean:
	rm -rf $(DEST)

$(CAP_FILE): $(CLS)
	$(CONVERTER) \
		-verbose \
		-classdir $(DEST) \
		-exportpath $(JAVACARD_ROOT)/api_export_files:$(STK_ROOT)/api_export_files \
		-applet $(APPLET_AID) $(APPLET_NAME) \
		$(PACKAGE_NAME) $(PACKAGE_AID) $(PACKAGE_VERSION)

$(DEST)/%.class: src/%.java | $(DEST)
	$(JC) $(JCFLAGS) $<

$(DEST):
	@mkdir -p $(DEST)