/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   push_swap.h                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jihad <jihad@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/26 15:59:30 by jalju-be          #+#    #+#             */
/*   Updated: 2025/12/01 02:56:45 by jihad            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PUSH_SWAP_H
# define PUSH_SWAP_H

# include <unistd.h>
# include <stdlib.h>
# include <limits.h>

typedef struct s_stack
{
	int		*arr;
	int		size;
	int		capacity;
}	t_stack;

typedef struct s_stacks
{
	t_stack	*a;
	t_stack	*b;
}	t_stacks;

/* Stack Operations - swap.c */
void	sa(t_stack *a);
void	sb(t_stack *b);
void	ss(t_stack *a, t_stack *b);

/* Stack Operations - push.c */
void	pa(t_stack *a, t_stack *b);
void	pb(t_stack *a, t_stack *b);

/* Stack Operations - shift.c */
void	ra(t_stack *a);
void	rb(t_stack *b);
void	rr(t_stack *a, t_stack *b);

/* Stack Operations - rshift.c */
void	rra(t_stack *a);
void	rrb(t_stack *b);
void	rrr(t_stack *a, t_stack *b);

/* Sorting Algorithms - radix.c */
void	radix_sort(t_stack *a, t_stack *b);

/* Sorting Algorithms - sort.c */
void	sort_three(t_stack *a);
void	sort_four(t_stack *a, t_stack *b);
void	sort_five(t_stack *a, t_stack *b);
void	sort_stack(t_stack *a, t_stack *b);

/* Parsing - push_swap.c */
int		check_duplicates(t_stack *stack);
void	parse_args(t_stack *a, t_stack *b, int argc, char **argv);

/* Utilities - utils.c */
void	ft_error(t_stack *a, t_stack *b);
void	init_stack(t_stack *stack, int capacity, t_stack *a, t_stack *b);
void	free_stack(t_stack *stack);
int		is_sorted(t_stack *stack);
int		ft_isdigit(int c);

/* Utilities - utils2.c */
void	normalize(t_stack *stack, t_stack *a, t_stack *b);

/* String to Integer - atoi.c */
int		ft_atoi(const char *str, t_stack *a, t_stack *b);

#endif