/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asabotie <asabotie@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2019/10/19 12:25:48 by asabotie          #+#    #+#             */
/*   Updated: 2019/11/01 15:26:41 by asabotie         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <unistd.h>
#include "get_next_line.h"

static ssize_t	get_char_pos(char *str, char c, ssize_t len)
{
	ssize_t	i;

	i = 0;
	while (i < len && str[i] != c)
		i++;
	return (str[i] == c ? i : -1);
}

static int		free_and_return_error(t_buf_list **buf_list, char **line)
{
	t_buf_list	*list;
	t_buf_list	*tmp;

	list = *buf_list;
	while (list)
	{
		clear_ptr((void**)&(list->buf));
		tmp = list;
		list = list->next;
		free(tmp);
	}
	*buf_list = NULL;
	clear_ptr((void**)line);
	return (ERROR);
}

static int		buf_to_line(char **line, ssize_t l_len, char *b, ssize_t b_len)
{
	char	*tmp;
	ssize_t	i;

	i = 0;
	if (!(tmp = malloc(sizeof(*tmp) * (l_len + b_len + 1))))
		return (ERROR);
	while (i < l_len + b_len)
	{
		if (i < l_len)
			tmp[i] = (*line)[i];
		else
			tmp[i] = b[i - l_len];
		i++;
	}
	tmp[i] = '\0';
	clear_ptr((void**)line);
	*line = tmp;
	return (FINISH);
}

static int		extract_line_from_buf(char *buf, ssize_t buf_len, char **line)
{
	ssize_t	buf_eol;
	ssize_t	line_len;
	ssize_t	i;

	line_len = ft_strlen(*line);
	buf_eol = get_char_pos(buf, '\n', buf_len);
	if (buf_eol != -1)
	{
		if (buf_to_line(line, line_len, buf, buf_eol) == ERROR)
			return (ERROR);
		i = 0;
		while (i < buf_len - buf_eol)
		{
			buf[i] = (buf + buf_eol + 1)[i];
			i++;
		}
		return (LINE_COMPLETE);
	}
	if (buf_to_line(line, line_len, buf, buf_len) == ERROR)
		return (ERROR);
	buf[0] = '\0';
	return (LINE_NOT_COMPLETE);
}

int				get_next_line(int fd, char **line)
{
	static t_buf_list	*buf_list = NULL;
	char				*buf;
	ssize_t				read_len;
	int					status;

	if (fd < 0 || line == NULL || (BUFFER_SIZE) < 1)
		return (free_and_return_error(&buf_list, line));
	*line = NULL;
	if (!(buf = get_buf_from_list(buf_list, fd))
			&& !(buf = new_buf_list(&buf_list, fd)))
		return (free_and_return_error(&buf_list, line));
	status = extract_line_from_buf(buf, ft_strlen(buf), line);
	while (status == LINE_NOT_COMPLETE)
	{
		if ((read_len = read(fd, buf, BUFFER_SIZE)) < 0)
			return (free_and_return_error(&buf_list, line));
		buf[read_len] = '\0';
		if ((status = extract_line_from_buf(buf, read_len, line)) == ERROR)
			return (free_and_return_error(&buf_list, line));
		if (status == LINE_NOT_COMPLETE && read_len < (BUFFER_SIZE))
			status = END_OF_FILE;
	}
	if (status == END_OF_FILE)
		free_buf_list_from_fd(&buf_list, fd);
	return (status == END_OF_FILE ? FINISH : READ_LINE);
}
