/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asabotie <asabotie@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2019/10/19 19:38:34 by asabotie          #+#    #+#             */
/*   Updated: 2019/11/04 16:04:57 by asabotie         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include "get_next_line.h"

int	main(void)
{
	char	*line = NULL;
	int	ret;

	while ((ret = get_next_line(0, &line)) == 1)
	{
		printf("%d|%s\n", ret, line);
		free(line);
		line = NULL;
	}
	printf("%d|%s\n", ret, line);
	free(line);
	line = NULL;
	return (0);
}
