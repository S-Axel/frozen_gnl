/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line_utils.c                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asabotie <asabotie@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2019/10/21 15:32:06 by asabotie          #+#    #+#             */
/*   Updated: 2019/10/30 19:13:57 by asabotie         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include "get_next_line.h"

size_t	ft_strlen(const char *s)
{
	size_t	len;

	len = 0;
	if (s == NULL)
		return (0);
	while (s[len])
		len++;
	return (len);
}

void	clear_ptr(void **ptr)
{
	if (ptr && *ptr)
	{
		free(*ptr);
		*ptr = NULL;
	}
}

char	*new_buf_list(t_buf_list **buf_list, int fd)
{
	t_buf_list	*new_buf_list;
	t_buf_list	*buf_list_it;

	if (!(new_buf_list = malloc(sizeof(*new_buf_list))))
		return (NULL);
	if (!(new_buf_list->buf = malloc(sizeof(char) * ((BUFFER_SIZE) + 1))))
	{
		free(new_buf_list);
		return (NULL);
	}
	new_buf_list->buf[0] = '\0';
	new_buf_list->fd = fd;
	new_buf_list->next = NULL;
	if (!*buf_list)
		*buf_list = new_buf_list;
	else
	{
		buf_list_it = *buf_list;
		while (buf_list_it->next)
			buf_list_it = buf_list_it->next;
		buf_list_it->next = new_buf_list;
	}
	return (new_buf_list->buf);
}

char	*get_buf_from_list(t_buf_list *buf_list, int fd)
{
	if (!buf_list)
		return (NULL);
	while (buf_list && buf_list->fd != fd)
		buf_list = buf_list->next;
	return (buf_list ? buf_list->buf : NULL);
}

void	free_buf_list_from_fd(t_buf_list **buf_list, int fd)
{
	t_buf_list	*buf_list_it;
	t_buf_list	*tmp;

	buf_list_it = *buf_list;
	if (buf_list_it->fd == fd)
	{
		*buf_list = buf_list_it->next;
		clear_ptr((void**)&(buf_list_it->buf));
		free(buf_list_it);
	}
	else
	{
		while (buf_list_it && buf_list_it->next && buf_list_it->next->fd != fd)
			buf_list_it = buf_list_it->next;
		if (buf_list_it && buf_list_it->next && buf_list_it->next->fd == fd)
		{
			clear_ptr((void**)&(buf_list_it->next->buf));
			tmp = buf_list_it->next;
			buf_list_it->next = buf_list_it->next->next;
			free(tmp);
		}
	}
}
