/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asabotie <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2019/10/19 19:38:34 by asabotie          #+#    #+#             */
/*   Updated: 2019/10/28 14:13:44 by asabotie         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include "get_next_line.h"

int	main(void)
{
	int	ret;
	char	*split;

	split = NULL;
	ret = get_next_line(-1, &split);
	printf("get_next_line return value: %d\n", ret);
	return (0);
}
