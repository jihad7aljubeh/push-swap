/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   init_stack.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/09 19:40:00 by jalju-be          #+#    #+#             */
/*   Updated: 2025/11/10 17:48:37 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

static int	is_valid_number(char *str)
{
	int	i;

	i = 0;
	if (str[i] == '-' || str[i] == '+')
		i++;
	if (!str[i])
		return (0);
	while (str[i])
	{
		if (!ft_isdigit(str[i]))
			return (0);
		i++;
	}
	return (1);
}

static int	has_duplicate(t_stack *stack, int value)
{
	while (stack)
	{
		if (stack->value == value)
			return (1);
		stack = stack->next;
	}
	return (0);
}

static t_stack	*stack_new(int value)
{
	t_stack	*node;

	node = (t_stack *)malloc(sizeof(t_stack));
	if (!node)
		return (NULL);
	node->value = value;
	node->index = 0;
	node->next = NULL;
	return (node);
}

static void	assign_index(t_stack *stack)
{
	t_stack	*current;
	t_stack	*compare;
	int		index;

	current = stack;
	while (current)
	{
		index = 0;
		compare = stack;
		while (compare)
		{
			if (compare->value < current->value)
				index++;
			compare = compare->next;
		}
		current->index = index;
		current = current->next;
	}
}

int	init_stack(int ac, char **av, t_stack **a)
{
	int		i;
	long	num;
	t_stack	*new_node;

	i = 1;
	while (i < ac)
	{
		if (!is_valid_number(av[i]))
			return (0);
		num = ft_atoi(av[i]);
		if (num > INT_MAX || num < INT_MIN)
			return (0);
		if (has_duplicate(*a, (int)num))
			return (0);
		new_node = stack_new((int)num);
		if (!new_node)
		{
			free_stack(a);
			return (0);
		}
		stack_add_back(a, new_node);
		i++;
	}
	assign_index(*a);
	return (1);
}
