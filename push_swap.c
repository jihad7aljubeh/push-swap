/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   push_swap.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/26 15:57:58 by jalju-be          #+#    #+#             */
/*   Updated: 2025/12/21 16:28:53 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

int	check_duplicates(t_stack *stack)
{
	int	i;
	int	j;

	i = 0;
	while (i < stack->size)
	{
		j = i + 1;
		while (j < stack->size)
		{
			if (stack->arr[i] == stack->arr[j])
				return (1);
			j++;
		}
		i++;
	}
	return (0);
}

void	parse_args(t_stack *a, int argc, char **argv)
{
	int	i;

	i = 1;
	while (i < argc)
	{
		a->arr[i - 1] = ft_atoi(argv[i]);
		i++;
	}
	a->size = argc - 1;
}
