/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils2.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/15 00:00:00 by your_login        #+#    #+#             */
/*   Updated: 2025/11/19 21:30:00 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

void	ft_putstr_fd(char *s, int fd)
{
    int	i;

    i = 0;
    while (s[i])
    {
        write(fd, &s[i], 1);
        i++;
    }
}

size_t	ft_strlen(const char *s)
{
    size_t	i;

    i = 0;
    while (s[i])
        i++;
    return (i);
}

int	ft_isdigit(int c)
{
    return (c >= '0' && c <= '9');
}

void	normalize(t_stack *stack)
{
    int	i;
    int	j;
    int	rank;
    int	*sorted;

    sorted = malloc(sizeof(int) * stack->size);
    if (!sorted)
        ft_error();
    i = -1;
    while (++i < stack->size)
        sorted[i] = stack->arr[i];
    i = -1;
    while (++i < stack->size - 1)
    {
        j = i;
        while (++j < stack->size)
        {
            if (sorted[i] > sorted[j])
            {
                rank = sorted[i];
                sorted[i] = sorted[j];
                sorted[j] = rank;
            }
        }
    }
    i = -1;
    while (++i < stack->size)
    {
        j = -1;
        while (++j < stack->size)
        {
            if (stack->arr[i] == sorted[j])
            {
                stack->arr[i] = j;
                break ;
            }
        }
    }
    free(sorted);
}
