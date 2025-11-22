/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   shift.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jihad <jihad@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/15 00:00:00 by your_login        #+#    #+#             */
/*   Updated: 2025/11/22 21:43:52 by jihad            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

static void	rotate(t_stack *stack, char c)
{
	int	tmp;
	int	i;

	if (stack->size < 2)
		return ;
	tmp = stack->arr[0];
	i = 0;
	while (i < stack->size - 1)
	{
		stack->arr[i] = stack->arr[i + 1];
		i++;
	}
	stack->arr[stack->size - 1] = tmp;
	if (c == 'a')
		write(1, "ra\n", 3);
	else if (c == 'b')
		write(1, "rb\n", 3);
}

void	ra(t_stack *a)
{
	rotate(a, 'a');
}

void	rb(t_stack *b)
{
	rotate(b, 'b');
}

void	rr(t_stack *a, t_stack *b)
{
	rotate(a, 0);
	rotate(b, 0);
	write(1, "rr\n", 3);
}
