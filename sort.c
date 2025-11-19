/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   sort.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/15 00:00:00 by your_login        #+#    #+#             */
/*   Updated: 2025/11/19 21:30:00 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

static int	find_min_index(t_stack *stack)
{
    int	i;
    int	min_idx;
    int	min_val;

    min_idx = 0;
    min_val = stack->arr[0];
    i = 1;
    while (i < stack->size)
    {
        if (stack->arr[i] < min_val)
        {
            min_val = stack->arr[i];
            min_idx = i;
        }
        i++;
    }
    return (min_idx);
}

void	sort_three(t_stack *a)
{
    if (a->arr[0] > a->arr[1] && a->arr[1] < a->arr[2]
        && a->arr[0] < a->arr[2])
        sa(a);
    else if (a->arr[0] > a->arr[1] && a->arr[1] > a->arr[2])
    {
        sa(a);
        rra(a);
    }
    else if (a->arr[0] > a->arr[1] && a->arr[1] < a->arr[2]
        && a->arr[0] > a->arr[2])
        ra(a);
    else if (a->arr[0] < a->arr[1] && a->arr[1] > a->arr[2]
        && a->arr[0] < a->arr[2])
    {
        sa(a);
        ra(a);
    }
    else if (a->arr[0] < a->arr[1] && a->arr[1] > a->arr[2]
        && a->arr[0] > a->arr[2])
        rra(a);
}

void	sort_four(t_stack *a, t_stack *b)
{
    int	min_idx;

    min_idx = find_min_index(a);
    if (min_idx == 1)
        sa(a);
    else if (min_idx == 2)
    {
        ra(a);
        ra(a);
    }
    else if (min_idx == 3)
        rra(a);
    pb(a, b);
    sort_three(a);
    pa(a, b);
}

void	sort_five(t_stack *a, t_stack *b)
{
    int	min_idx;

    min_idx = find_min_index(a);
    if (min_idx == 1)
        sa(a);
    else if (min_idx == 2)
    {
        ra(a);
        ra(a);
    }
    else if (min_idx == 3)
    {
        rra(a);
        rra(a);
    }
    else if (min_idx == 4)
        rra(a);
    pb(a, b);
    sort_four(a, b);
    pa(a, b);
}

void	sort_stack(t_stack *a, t_stack *b)
{
    if (is_sorted(a))
        return ;
    if (a->size == 2)
        sa(a);
    else if (a->size == 3)
        sort_three(a);
    else if (a->size == 4)
        sort_four(a, b);
    else if (a->size == 5)
        sort_five(a, b);
    else
        radix_sort(a, b);
}