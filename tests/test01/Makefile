# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: asabotie <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/10/19 19:29:28 by asabotie          #+#    #+#              #
#    Updated: 2019/10/19 19:38:15 by asabotie         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


SRCS		=	${PATH}/get_next_line.c \
			${PATH}/get_next_line_utils.c \
			main.c

OBJS		=	${SRCS:.c=.o}

NAME		=	gnl_test

CFLAGS		=	-Wall -Wextra -Werror -I${PATH}

CC		=	gcc

RM		=	rm -f

all:		${NAME}

${NAME}:	${OBJS}	
			 ${CC} - o ${NAME} ${OBJS}

clean:		
			${RM} ${OBJS} ${OBJSBONUS}

fclean:		clean
			${RM} ${NAME}

re:			fclean all

.PHONY:		 all clean fclean re

