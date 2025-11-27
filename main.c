/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/26 15:57:49 by jalju-be          #+#    #+#             */
/*   Updated: 2025/11/26 15:57:51 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

int	main(int argc, char **argv)
{
	t_stack		a;
	t_stack		b;

	if (argc < 2)
		return (0);
	init_stack(&a, argc - 1);
	init_stack(&b, argc - 1);
	parse_args(&a, argc, argv);
	if (is_sorted(&a))
	{
		free_stack(&a);
		free_stack(&b);
		return (0);
	}
	normalize(&a);
	sort_stack(&a, &b);
	free_stack(&a);
	free_stack(&b);
	return (0);
}
