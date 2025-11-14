/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   shift_op.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/09 19:20:30 by jalju-be          #+#    #+#             */
/*   Updated: 2025/11/10 17:48:49 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

static void	shift(t_stack **stack)
{
	t_stack	*first;
	t_stack	*last;

	if (!stack || !*stack || !(*stack)->next)
		return ;
	first = *stack;
	last = *stack;
	while (last->next)
		last = last->next;
	*stack = first->next;
	first->next = NULL;
	last->next = first;
}

void	ra(t_stack **a)
{
	shift(a);
	write(1, "ra\n", 3);
}

void	rb(t_stack **b)
{
	shift(b);
	write(1, "rb\n", 3);
}

void	rr(t_stack **a, t_stack **b)
{
	shift(a);
	shift(b);
	write(1, "rr\n", 3);
}
