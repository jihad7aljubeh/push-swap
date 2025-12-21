/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   rshift.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/26 15:58:35 by jalju-be          #+#    #+#             */
/*   Updated: 2025/12/21 16:28:43 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

static void	reverse_rotate(t_stack *stack, char c)
{
	int	tmp;
	int	i;

	if (stack->size < 2)
		return ;
	tmp = stack->arr[stack->size - 1];
	i = stack->size - 1;
	while (i > 0)
	{
		stack->arr[i] = stack->arr[i - 1];
		i--;
	}
	stack->arr[0] = tmp;
	if (c == 'a')
		write(1, "rra\n", 4);
	else if (c == 'b')
		write(1, "rrb\n", 4);
}

void	rra(t_stack *a)
{
	reverse_rotate(a, 'a');
}

void	rrb(t_stack *b)
{
	reverse_rotate(b, 'b');
}

void	rrr(t_stack *a, t_stack *b)
{
	reverse_rotate(a, 0);
	reverse_rotate(b, 0);
	write(1, "rrr\n", 4);
}
