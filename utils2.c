/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils2.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jihad <jihad@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/15 00:00:00 by your_login        #+#    #+#             */
/*   Updated: 2025/11/22 21:43:31 by jihad            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

void	ft_putstr_fd(char *s, int fd)
{
	int	i;

	i = 0;
	while (s[i])
	{
		write(fd, &s[i], 1);
		i++;
	}
}

size_t	ft_strlen(const char *s)
{
	size_t	i;

	i = 0;
	while (s[i])
		i++;
	return (i);
}

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
