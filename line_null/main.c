/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asabotie <asabotie@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2019/10/19 19:38:34 by asabotie          #+#    #+#             */
/*   Updated: 2019/11/01 17:21:39 by asabotie         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include "get_next_line.h"

int	main(int ac, char **av)
{
	int	fd;
	int	ret;

if (ac != 2)
	{
		printf("Internal Error: Wrong number of arguments\n");
		return (1);
	}
	fd = open(av[1], O_RDONLY);
	if (fd != -1)
	{
		ret = get_next_line(fd, NULL);
		close(fd);
		printf("%d|\n", ret);
	}
	else
		printf("Couldn't open %s.\n", av[1]);
	return (0);
}
