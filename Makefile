#################################################################################

 ###############################################################################
 ## Jason Brillante "Damdoshi"                                                ##
 ## Hanged Bunny Studio 2014-2018                                             ##
 ## "MyLib" V9.12                                                             ##
 ##                                                                           ##
 ## ------------------------------------------------------------------------- ##
 ## ------------------------------------ ---   -   --- ---- --  --   - --- -- ##
 ## ------------------------------------ ---- --- - -- --- - - - -- --  -- -- ##
 ## -----|\-//-------------------------- ---- ---   -- --- - -  --- -- - - -- ##
 ## -----||//___------------------------ ---- --- - -- ---   - ---- -- - - -- ##
 ## ----O  /    \----------------------- ---- --- - -- --- - - ---- -- --  -- ##
 ## ---<________/-----------------------   -   -   ---   - - - ---   - --- -- ##
 ## ------------------------------------------------------------------------- ##
 ##                                                                           ##
 ##                              - LibLapin -                                 ##
 ##                                                                           ##
 ###############################################################################

#################################################################################
## Information about the project                                               ##
#################################################################################

  NAME		=	liblapin.a
  TITLE		=	"LIBLAPIN - BUNNY LIBRARY"

#################################################################################
## Building details                                                            ##
#################################################################################

  LINKER	?=	ar rcs
  COMPILER	?=	g++

  EXTCONF	?=	-DBUNNY_ALLOCATOR_DEACTIVATED

  CONFIG	=	-W -Wall -fPIC -std=c++1z -Wno-write-strings		\
			-Wno-unused-result -Wno-format-security			\
			-Wno-frame-address					\
			$(EXTCONF)

  DEBUG		=	-O0 -Og -g -g3 -ggdb -DBUNNY_DEBUG -fprofile-arcs	\
			-ftest-coverage --coverage
# OPTIM		=	-O2

  RM		=	rm -f
  ECHO		=	/bin/echo -e
  LOGDIR	=	errors/

  HEADER	=	-I./include						\
			-I./include/deps/					\
			-I./external/include/					\
			-I/opt/local/include/

  DEFAULT	=	"\033[00m"
  PINK		=	"\033[1;35m"
  GREEN		=	"\033[0;32m"
  TEAL		=	"\033[1;36m"
  RED		=	"\033[0;31m"

#################################################################################
## Source                                                                      ##
#################################################################################

  SRC		=	$(shell find src2/ -name "*.cpp")
  OBJ		=	$(SRC:.cpp=.o)

#################################################################################
## Rules                                                                       ##
#################################################################################

all:			erase $(NAME)
$(NAME):		title $(OBJ)
			@$(LINKER) $(NAME) $(OBJ) 2>> $(LOGDIR)/$(NAME) &&	\
			 $(ECHO) $(TEAL) "[OK]" $(GREEN) $(NAME) $(DEFAULT) ||	\
			 $(ECHO) $(RED)  "[KO]" $(NAME) $(DEFAULT)
			@find $(LOGDIR)/$(NAME) -size 0 -delete || true
.cpp.o:
			@$(eval TRACE="$(addprefix $(LOGDIR), $(subst /,-, $<))")
			@$(COMPILER) -c $< -o $@ $(DEBUG) $(OPTIM) $(CONFIG)	\
			 $(HEADER) 2>> $(TRACE) &&				\
			 $(ECHO) $(TEAL) "[OK]" $(GREEN) $< $(DEFAULT) ||	\
			 $(ECHO) $(RED)  "[KO]" $< $(DEFAULT)
			@find $(TRACE) -size 0 -delete || true

#################################################################################
## Misc                                                                        ##
#################################################################################

title:
			@$(ECHO) $(TEAL) $(TITLE) $(DEFAULT)
			@mkdir -p $(LOGDIR)
clean:
			@find . -name "*.gc*" -delete
			@$(RM) $(OBJ) &&					\
			 $(ECHO) $(GREEN) "Object file deleted" $(DEFAULT) ||	\
			 $(ECHO) $(RED) "Error in clean rule!" $(DEFAULT)
fclean:			clean erase
			@(cd tests2 && ./clean.sh)
			@$(RM) $(NAME) &&					\
			 $(ECHO) $(GREEN) "Program deleted!" $(DEFAULT) ||	\
			 $(ECHO) $(RED) "Error in fclean rule!" $(DEFAULT)
re:			fclean all
erase:
			@$(RM) -r $(LOGDIR)/*.*
check:			all
			(cd tests2/ && ./run.sh)
doc:
			./generate_doc.php
install:
			./school_install.sh
.POSIX:
