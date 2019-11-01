/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asabotie <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2019/10/19 19:38:34 by asabotie          #+#    #+#             */
/*   Updated: 2019/10/31 15:17:07 by asabotie         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include "get_next_line.h"

int	main(void)
{
	int	fd1;
	int	fd2;
	char	*line = NULL;
	char	*file_to_read_1 = "file_to_read_1";
	char	*file_to_read_2 = "file_to_read_2";
	int	ret;

	fd = open(file_to_read, O_RDONLY);
	if (fd != -1)
	{
		while ((ret = get_next_line(fd, &line)) == 1)
		{
			printf("%s\n", line);
			free(line);
		}
		close(fd);
		printf("get_next_line return value: %d\n", ret);
	}
	else
		printf("Couldn't open %s.\n", file_to_read);
	return (0);
}
