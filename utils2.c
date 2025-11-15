/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils2.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jihad <jihad@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/15 00:00:00 by your_login        #+#    #+#             */
/*   Updated: 2025/11/15 15:02:34 by jihad            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

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

int	find_min_index(t_stack *stack)
{
	int	i;
	int	min_idx;
	int	min_val;

	i = 0;
	min_idx = 0;
	min_val = stack->arr[0];
	while (i < stack->size)
	{
		if (stack->arr[i] < min_val)
		{
			min_val = stack->arr[i];
			min_idx = i;
		}
		i++;
	}
	return (min_idx);
}

static void	sort_array(int *sorted, int size)
{
	int	i;
	int	j;
	int	tmp;

	i = -1;
	while (++i < size - 1)
	{
		j = i;
		while (++j < size)
		{
			if (sorted[i] > sorted[j])
			{
				tmp = sorted[i];
				sorted[i] = sorted[j];
				sorted[j] = tmp;
			}
		}
	}
}

static void	map_to_index(t_stack *stack, int *sorted)
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
	int	*sorted;
	int	i;

	sorted = malloc(sizeof(int) * stack->size);
	if (!sorted)
		ft_error();
	i = -1;
	while (++i < stack->size)
		sorted[i] = stack->arr[i];
	sort_array(sorted, stack->size);
	map_to_index(stack, sorted);
	free(sorted);
}
