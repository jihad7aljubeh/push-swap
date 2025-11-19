/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   push_swap.h                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/15 00:00:00 by your_login        #+#    #+#             */
/*   Updated: 2025/11/19 20:46:07 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PUSH_SWAP_H
# define PUSH_SWAP_H

# include <unistd.h>
# include <stdlib.h>
# include <limits.h>

typedef struct s_stack
{
    int	*arr;
    int	size;
    int	capacity;
}	t_stack;

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
void	parse_args(t_stack *a, int argc, char **argv);

/* Utilities - utils.c */
void	ft_error(void);
void	init_stack(t_stack *stack, int capacity);
void	free_stack(t_stack *stack);
int		is_sorted(t_stack *stack);

/* Utilities - utils2.c */
void	ft_putstr_fd(char *s, int fd);
size_t	ft_strlen(const char *s);
int		ft_isdigit(int c);
void	normalize(t_stack *stack);

/* String to Integer - atoi.c */
int		ft_atoi(const char *str);

#endif