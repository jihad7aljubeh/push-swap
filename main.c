/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/09 19:35:00 by jalju-be          #+#    #+#             */
/*   Updated: 2025/11/10 17:45:00 by jalju-be         ###   ########.fr       */
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
		sa(&a);
	else if (size == 3)
		sort_three(&a);
	else
		radix_sort(&a, &b, get_max_bits(size));
	free_stack(&a);
	return (0);
}
