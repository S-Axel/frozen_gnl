/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asabotie <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2019/10/19 19:38:34 by asabotie          #+#    #+#             */
/*   Updated: 2019/10/28 14:08:25 by asabotie         ###   ########.fr       */
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
	int	ret;

	fd = open(file_to_read, O_RDONLY);
	if (fd != -1)
	{
		while ((ret = get_next_line(fd, &line)) == 1)
		{
			printf("%s\n", line);
		}
		close(fd);
		printf("get_next_line return value: %d\n", ret);
	}
	else
		printf("Couldn't open %s.\n", file_to_read);
	return (0);
}
