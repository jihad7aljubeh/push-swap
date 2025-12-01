/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   push_swap.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jihad <jihad@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/26 15:57:58 by jalju-be          #+#    #+#             */
/*   Updated: 2025/12/01 02:53:48 by jihad            ###   ########.fr       */
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

void	parse_args(t_stack *a, t_stack *b, int argc, char **argv)
{
	int	i;

	i = 1;
	while (i < argc)
	{
		a->arr[i - 1] = ft_atoi(argv[i], a, b);
		i++;
	}
	a->size = argc - 1;
	if (check_duplicates(a))
		ft_error(a, b);
}

int	ft_isdigit(int c)
{
	return (c >= '0' && c <= '9');
}
