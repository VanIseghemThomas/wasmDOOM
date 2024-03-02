SOURCE_DIR=src
OUT_DIR=public/wasm
OUT_NAME=wasm-doom

# ONLY UNTIL THE WAD FILE LOADER IS IMPLEMENTED
PREFLOAD_WAD ?= $(shell echo $$PREFLOAD_WAD)
PREFLOAD_WAD := $(or $(PREFLOAD_WAD),doom.wad)
$(Using PRELOAD_WAD=$(PRELOAD_WAD))

SDL_CFLAGS = -D_REENTRANT -D_THREAD_SAFE -s USE_SDL=2
INCLUDES=-Iinclude 
# For MacOS SDL2 install with homebrew
INCLUDES+=-I/opt/homebrew/include
# TODO - Look into Linux and Windows SDL2 install paths
CC=emcc
CFLAGS+= $(INCLUDES) $(SDL_CFLAGS)
CFLAGS+=-Wall -DFEATURE_SOUND --preload-file $(PRELOAD_WAD)@doom-data.wad
CFLAGS+=-sEXPORTED_RUNTIME_METHODS=FS,callMain -sMODULARIZE=1 -sEXPORT_ES6 -sINVOKE_RUN=0
LIBS+=-lm -lSDL2 -lSDL2_mixer `sdl2-config --cflags --libs`
OBJDIR=$(SOURCE_DIR)/build
OUTPUT=$(OUT_DIR)/$(OUT_NAME)
SRC_DOOM = i_main.o \
			dummy.o \
			am_map.o \
			doomdef.o  \
			doomstat.o  \
			dstrings.o  \
			d_event.o  \
			d_items.o  \
			d_iwad.o  \
			d_loop.o  \
			d_main.o  \
			d_mode.o  \
			d_net.o  \
			f_finale.o  \
			f_wipe.o  \
			g_game.o  \
			hu_lib.o  \
			hu_stuff.o  \
			info.o  \
			i_cdmus.o  \
			i_endoom.o  \
			i_joystick.o  \
			i_scale.o  \
			i_sound.o  \
			i_sdlmusic.o   \
			i_sdlsound.o \
			i_system.o  \
			i_timer.o  \
			i_input.o   \
			i_video.o   \
			mus2mid.o   \
			memio.o  \
			m_argv.o  \
			m_bbox.o  \
			m_cheat.o  \
			m_config.o  \
			m_controls.o  \
			m_fixed.o  \
			m_menu.o  \
			m_misc.o  \
			m_random.o  \
			p_ceilng.o  \
			p_doors.o  \
			p_enemy.o  \
			p_floor.o  \
			p_inter.o  \
			p_lights.o  \
			p_map.o  \
			p_maputl.o  \
			p_mobj.o  \
			p_plats.o  \
			p_pspr.o  \
			p_saveg.o  \
			p_setup.o  \
			p_sight.o  \
			p_spec.o  \
			p_switch.o  \
			p_telept.o  \
			p_tick.o  \
			p_user.o  \
			r_bsp.o  \
			r_data.o  \
			r_draw.o  \
			r_main.o  \
			r_plane.o  \
			r_segs.o  \
			r_sky.o  \
			r_things.o  \
			sha1.o  \
			sounds.o  \
			statdump.o  \
			st_lib.o   \
			st_stuff.o   \
			s_sound.o   \
			tables.o   \
			v_video.o   \
			wi_stuff.o   \
			w_checksum.o   \
			w_file.o   \
			w_main.o   \
			w_wad.o   \
			z_zone.o   \
			w_file_stdc.o  

OBJS += $(addprefix $(OBJDIR)/, $(SRC_DOOM))

# First check if the WAD file actually exists
ifeq (,$(wildcard $(PRELOAD_WAD)))
$(error WAD file $(PRELOAD_WAD) does not exist)
endif

all:	 $(OUTPUT)

clean:
	rm -rf $(OBJDIR)
	rm -f $(OUTPUT)
	rm -f $(OUTPUT).exe
	rm -f $(OUTPUT).gdb
	rm -f $(OUTPUT).map
	rm -f $(OUTPUT).html
	rm -f $(OUTPUT).js
	rm -f $(OUTPUT).wasm
	rm -f $(OUTPUT).data

$(OUTPUT):	$(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) \
	-o $(OUTPUT).html $(LIBS) 

$(OBJS): | $(OBJDIR)

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(OBJDIR)/%.o:	$(SOURCE_DIR)/%.c

	$(CC) $(CFLAGS) -c $< -o $@


