/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/26 15:57:48 by jalju-be          #+#    #+#             */
/*   Updated: 2025/12/21 21:15:56 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

int	is_empty_or_whitespace(const char *str)
{
	int	i;

	i = 0;
	if (!str || str[0] == '\0')
		return (1);
	while (str[i])
	{
		if (str[i] != ' ' && str[i] != '\t' && str[i] != '\n'
			&& str[i] != '\r' && str[i] != '\v' && str[i] != '\f')
			return (0);
		i++;
	}
	return (1);
}

void	validate_args(int argc, char **argv)
{
	int	i;

	i = 1;
	while (i < argc)
	{
		if (!argv[i] || argv[i][0] == '\0')
			ft_error();
		if (is_empty_or_whitespace(argv[i]))
			ft_error();
		if (is_valid_number(argv[i]) == 0)
			ft_error();
		i++;
	}
}

void	exit_it(t_stack *a, t_stack *b)
{
	free_all(a, b);
	ft_error();
}

int	main(int argc, char **argv)
{
	t_stack		a;
	t_stack		b;

	if (argc < 2)
		return (0);
	validate_args(argc, argv);
	init_stack(&a, argc - 1);
	init_stack(&b, argc - 1);
	if (!parse_args(&a, argc, argv))
		exit_it(&a, &b);
	if (check_duplicates(&a))
		exit_it(&a, &b);
	if (is_sorted(&a))
	{
		free_all(&a, &b);
		return (0);
	}
	normalize(&a);
	sort_stack(&a, &b);
	free_all(&a, &b);
	return (0);
}
