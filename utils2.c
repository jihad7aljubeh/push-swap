/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils2.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/26 15:59:12 by jalju-be          #+#    #+#             */
/*   Updated: 2025/12/21 16:33:11 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

static void	bubble_sort(int *sorted, int size)
{
	int	i;
	int	j;
	int	tmp;

	i = -1;
	while (++i < size - 1)
	{
		j = -1;
		while (++j < size - i - 1)
		{
			if (sorted[j] > sorted[j + 1])
			{
				tmp = sorted[j];
				sorted[j] = sorted[j + 1];
				sorted[j + 1] = tmp;
			}
		}
	}
}

static void	assign_ranks(t_stack *stack, int *sorted)
{
	int	i;
	int	j;

	i = -1;
	while (++i < stack->size)
	{
		j = -1;
		while (++j < stack->size)
		{
			if (stack->arr[i] == sorted[j])
			{
				stack->arr[i] = j;
				break ;
			}
		}
	}
}

void	normalize(t_stack *stack)
{
	int	i;
	int	*sorted;

	sorted = malloc(sizeof(int) * stack->size);
	if (!sorted)
		ft_error();
	i = -1;
	while (++i < stack->size)
		sorted[i] = stack->arr[i];
	bubble_sort(sorted, stack->size);
	assign_ranks(stack, sorted);
	free(sorted);
}

void	free_all(t_stack *a, t_stack *b)
{
	free_stack(a);
	free_stack(b);
}

int	ft_isdigit(int c)
{
	return (c >= '0' && c <= '9');
}
