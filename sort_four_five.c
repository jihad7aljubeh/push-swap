/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   sort_four_five.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/10 00:00:00 by jalju-be          #+#    #+#             */
/*   Updated: 2025/11/10 00:00:00 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

static int	find_min_pos(t_stack *a, int size)
{
    int		min_pos;
    int		i;
    t_stack	*temp;

    min_pos = 0;
    i = 0;
    temp = a;
    while (temp)
    {
        if (temp->index == 0 || (size == 4 && temp->index == 1))
            min_pos = i;
        temp = temp->next;
        i++;
    }
    return (min_pos);
}

static void	rotate_to_top(t_stack **a, int min_pos, int size)
{
    if (min_pos <= size / 2)
    {
        while (min_pos-- > 0)
            ra(a);
    }
    else
    {
        while (min_pos++ < size)
            rra(a);
    }
}

void	sort_four_five(t_stack **a, t_stack **b)
{
    int	size;
    int	min_pos;

    size = stack_size(*a);
    while (size > 3)
    {
        min_pos = find_min_pos(*a, size);
        rotate_to_top(a, min_pos, size);
        pb(a, b);
        size--;
    }
    sort_three(a);
    while (*b)
        pa(a, b);
}