/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asabotie <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2019/10/19 19:38:34 by asabotie          #+#    #+#             */
/*   Updated: 2019/10/22 17:52:58 by asabotie         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include "get_next_line.h"

int	main(void)
{
	int	fd;
	char	*line = NULL;
	char	*file_to_read = "file_to_read";

	fd = open(file_to_read, O_RDONLY);
	if (fd != -1)
	{
		while (get_next_line(fd, &line) == 1)
		{
			printf("%s\n", line);
		}
		close(fd);
	}
	else
		printf("Couldn't open %s.\n", file_to_read);
	return (0);
}
