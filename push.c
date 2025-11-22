/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   push.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jihad <jihad@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/15 00:00:00 by your_login        #+#    #+#             */
/*   Updated: 2025/11/22 21:44:06 by jihad            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

static void	push(t_stack *dst, t_stack *src, char c)
{
	int	i;

	if (src->size == 0)
		return ;
	i = dst->size;
	while (i > 0)
	{
		dst->arr[i] = dst->arr[i - 1];
		i--;
	}
	dst->arr[0] = src->arr[0];
	dst->size++;
	i = 0;
	while (i < src->size - 1)
	{
		src->arr[i] = src->arr[i + 1];
		i++;
	}
	src->size--;
	if (c == 'a')
		write(1, "pa\n", 3);
	else if (c == 'b')
		write(1, "pb\n", 3);
}

void	pa(t_stack *a, t_stack *b)
{
	push(a, b, 'a');
}

void	pb(t_stack *a, t_stack *b)
{
	push(b, a, 'b');
}
