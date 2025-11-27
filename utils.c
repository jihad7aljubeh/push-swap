/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/26 15:59:04 by jalju-be          #+#    #+#             */
/*   Updated: 2025/11/26 15:59:05 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

void	ft_error(void)
{
	write(2, "Error\n", 6);
	exit(1);
}

void	init_stack(t_stack *stack, int capacity)
{
	stack->arr = malloc(sizeof(int) * capacity);
	if (!stack->arr)
		ft_error();
	stack->size = 0;
	stack->capacity = capacity;
}

void	free_stack(t_stack *stack)
{
	if (stack->arr)
		free(stack->arr);
	stack->arr = NULL;
	stack->size = 0;
	stack->capacity = 0;
}

int	is_sorted(t_stack *stack)
{
	int	i;

	i = 0;
	while (i < stack->size - 1)
	{
		if (stack->arr[i] > stack->arr[i + 1])
			return (0);
		i++;
	}
	return (1);
}

int	ft_isdigit(int c)
{
	return (c >= '0' && c <= '9');
}
