/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_isdigit.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/08/09 11:56:27 by jalju-be          #+#    #+#             */
/*   Updated: 2025/11/11 19:41:57 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

int	ft_isdigit(int a)
{
	if (a <= '9' && a >= '0')
		return (1);
	return (0);
}
/* int main(void)
{
	printf("%d\n",ft_isdigit('a'));
} */

/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/09 19:35:00 by jalju-be          #+#    #+#             */
/*   Updated: 2025/11/11 00:00:00 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

int	main(int ac, char **av)
{
    t_stack	*a;
    t_stack	*b;
    int		size;

    if (ac < 2)
        return (0);
    a = NULL;
    b = NULL;
    if (!init_stack(ac, av, &a))
        return (error_exit(&a));
    if (is_sorted(a))
    {
        free_stack(&a);
        return (0);
    }
    size = stack_size(a);
    if (size == 2)
        sort_two(&a);
    else if (size == 3)
        sort_three(&a);
    else if (size <= 5)
        sort_four_five(&a, &b);
    else
        radix_sort(&a, &b, get_max_bits(size));
    free_stack(&a);
    return (0);
}