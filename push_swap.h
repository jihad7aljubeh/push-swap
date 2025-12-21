/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   push_swap.h                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/26 15:59:30 by jalju-be          #+#    #+#             */
/*   Updated: 2025/12/21 21:12:35 by jalju-be         ###   ########.fr       */
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

void	sa(t_stack *a);
void	sb(t_stack *b);
void	ss(t_stack *a, t_stack *b);

void	pa(t_stack *a, t_stack *b);
void	pb(t_stack *a, t_stack *b);

void	ra(t_stack *a);
void	rb(t_stack *b);
void	rr(t_stack *a, t_stack *b);

void	rra(t_stack *a);
void	rrb(t_stack *b);
void	rrr(t_stack *a, t_stack *b);

void	radix_sort(t_stack *a, t_stack *b);

void	sort_three(t_stack *a);
void	sort_four(t_stack *a, t_stack *b);
void	sort_five(t_stack *a, t_stack *b);
void	sort_stack(t_stack *a, t_stack *b);

int		check_duplicates(t_stack *stack);
int		parse_args(t_stack *a, int argc, char **argv);

void	ft_error(void);
void	init_stack(t_stack *stack, int capacity);
void	free_stack(t_stack *stack);
int		is_sorted(t_stack *stack);
int		ft_isdigit(int c);
void	validate_args(int argc, char **argv);
void	free_stacks(t_stack *a, t_stack *b);

void	normalize(t_stack *stack);
void	free_all(t_stack *a, t_stack *b);

int		ft_atoi(const char *str);
int		is_valid_number(const char *str);

#endif