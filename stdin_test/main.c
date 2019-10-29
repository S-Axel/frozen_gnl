/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asabotie <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2019/10/19 19:38:34 by asabotie          #+#    #+#             */
/*   Updated: 2019/10/29 13:04:57 by asabotie         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

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
		printf("Your get_next_line returned '%d' with the following line: '%s'\n", ret, line);
	}
	printf("get_next_line return value: %d\n", ret);
	return (0);
}
