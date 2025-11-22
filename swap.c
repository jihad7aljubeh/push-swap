/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   swap.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jihad <jihad@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/15 00:00:00 by your_login        #+#    #+#             */
/*   Updated: 2025/11/22 21:43:44 by jihad            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

static void	swap(t_stack *stack, char c)
{
	int	tmp;

	if (stack->size < 2)
		return ;
	tmp = stack->arr[0];
	stack->arr[0] = stack->arr[1];
	stack->arr[1] = tmp;
	if (c == 'a')
		write(1, "sa\n", 3);
	else if (c == 'b')
		write(1, "sb\n", 3);
}

void	sa(t_stack *a)
{
	swap(a, 'a');
}

void	sb(t_stack *b)
{
	swap(b, 'b');
}

void	ss(t_stack *a, t_stack *b)
{
	swap(a, 0);
	swap(b, 0);
	write(1, "ss\n", 3);
}
