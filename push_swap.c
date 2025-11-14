/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   push_swap.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/09 19:27:13 by jalju-be          #+#    #+#             */
/*   Updated: 2025/11/10 00:00:00 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

void	sort_two(t_stack **a)
{
    if ((*a)->index > (*a)->next->index)
        sa(a);
}

void	sort_three(t_stack **a)
{
    int	top;
    int	mid;
    int	bot;

    top = (*a)->index;
    mid = (*a)->next->index;
    bot = (*a)->next->next->index;
    if (top > mid && mid < bot && top < bot)
        sa(a);
    else if (top > mid && mid > bot && top > bot)
    {
        sa(a);
        rra(a);
    }
    else if (top > bot && bot > mid)
        ra(a);
    else if (mid > top && mid > bot && bot > top)
    {
        sa(a);
        ra(a);
    }
    else if (mid > bot && top < mid)
        rra(a);
}

void	radix_sort(t_stack **a, t_stack **b, int max_bits)
{
    int	i;
    int	j;
    int	size;

    i = 0;
    while (i < max_bits)
    {
        size = stack_size(*a);
        j = 0;
        while (j++ < size)
        {
            if ((((*a)->index >> i) & 1) == 0)
                pb(a, b);
            else
                ra(a);
        }
        while (*b)
            pa(a, b);
        i++;
    }
}

int	get_max_bits(int size)
{
    int	bits;

    bits = 0;
    while ((size - 1) >> bits)
        bits++;
    return (bits);
}
