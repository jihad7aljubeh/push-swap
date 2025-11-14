/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   error.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/09 20:30:00 by jalju-be          #+#    #+#             */
/*   Updated: 2025/11/10 17:48:36 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

int	error_exit(t_stack **stack)
{
	ft_putstr_fd("Error\n", 2);
	if (stack && *stack)
		free_stack(stack);
	exit(1);
	return (0);
}
