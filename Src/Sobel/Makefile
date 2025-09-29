# Choisir le simulateur
SIM ?= ghdl
TOPLEVEL_LANG ?= vhdl

# Indiquer les fichiers sources
VHDL_SOURCES += $(PWD)/top_sobel.vhd
VHDL_SOURCES += $(PWD)/Sobel_x/top_sobel_x.vhd
VHDL_SOURCES += $(PWD)/Sobel_y/top_sobel_y.vhd
VHDL_SOURCES += $(PWD)/Sobel_y/row/row.vhd
VHDL_SOURCES += $(PWD)/Sobel_y/add_y/add_y.vhd
VHDL_SOURCES += $(PWD)/Sobel_x/add/add.vhd
VHDL_SOURCES += $(PWD)/Sobel_x/row_0/row_0.vhd


# Nom de l’entité top-level (ton DUT)
COCOTB_TOPLEVEL = top_sobel

# Nom du fichier Python contenant le test (sans .py)
COCOTB_TEST_MODULES = test_top_sobel

# (Optionnel) génération d’un fichier VCD pour les waves
EXTRA_ARGS += --std=08
SIM_ARGS += --wave=wave.ghw
# Inclure les règles cocotb
include $(shell cocotb-config --makefiles)/Makefile.sim


