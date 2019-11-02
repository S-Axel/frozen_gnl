/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line.h                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asabotie <asabotie@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2019/10/19 12:27:12 by asabotie          #+#    #+#             */
/*   Updated: 2019/11/01 15:02:38 by asabotie         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef GET_NEXT_LINE_H
# define GET_NEXT_LINE_H
# define TRUE 1
# define FALSE 0
# define LINE_COMPLETE 1
# define LINE_NOT_COMPLETE 2
# define END_OF_FILE 3
# define ERROR -1
# define READ_LINE 1
# define FINISH 0

# include <sys/types.h>

typedef	struct	s_buf_list
{
	int					fd;
	char				*buf;
	struct s_buf_list	*next;
}				t_buf_list;

size_t			ft_strlen(const char *s);
void			clear_ptr(void **ptr);
char			*new_buf_list(t_buf_list **buf_list, int fd);
char			*get_buf_from_list(t_buf_list *list, int fd);
void			free_buf_list_from_fd(t_buf_list **buf_list, int fd);
int				get_next_line(int fd, char **line);

#endif
