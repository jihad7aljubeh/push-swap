/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   push_op.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/09 19:20:47 by jalju-be          #+#    #+#             */
/*   Updated: 2025/11/10 17:47:42 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

void	pa(t_stack **a, t_stack **b)
{
	t_stack	*node;

	if (!b || !*b)
		return ;
	node = *b;
	*b = node->next;
	node->next = *a;
	*a = node;
	write(1, "pa\n", 3);
}

void	pb(t_stack **a, t_stack **b)
{
	t_stack	*node;

	if (!a || !*a)
		return ;
	node = *a;
	*a = node->next;
	node->next = *b;
	*b = node;
	write(1, "pb\n", 3);
}
