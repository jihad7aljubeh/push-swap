/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jihad <jihad@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/26 15:59:04 by jalju-be          #+#    #+#             */
/*   Updated: 2025/12/01 02:53:02 by jihad            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

void	ft_error(t_stack *a, t_stack *b)
{
	if (a && a->arr)
		free_stack(a);
	if (b && b->arr)
		free_stack(b);
	write(2, "Error\n", 6);
	exit(1);
}

void	init_stack(t_stack *stack, int capacity, t_stack *a, t_stack *b)
{
	stack->arr = malloc(sizeof(int) * capacity);
	if (!stack->arr)
		ft_error(a, b);
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
