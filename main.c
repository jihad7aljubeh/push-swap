/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jihad <jihad@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/26 15:57:49 by jalju-be          #+#    #+#             */
/*   Updated: 2025/12/01 02:54:13 by jihad            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

int	main(int argc, char **argv)
{
	t_stack		a;
	t_stack		b;

	if (argc < 2)
		return (0);
	a.arr = NULL;
	b.arr = NULL;
	init_stack(&a, argc - 1, NULL, NULL);
	init_stack(&b, argc - 1, &a, &b);
	parse_args(&a, &b, argc, argv);
	if (is_sorted(&a))
	{
		free_stack(&a);
		free_stack(&b);
		return (0);
	}
	normalize(&a, &a, &b);
	sort_stack(&a, &b);
	free_stack(&a);
	free_stack(&b);
	return (0);
}
