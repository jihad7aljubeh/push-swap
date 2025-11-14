/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   push_swap.h                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/09 19:02:30 by jalju-be          #+#    #+#             */
/*   Updated: 2025/11/11 00:00:00 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PUSH_SWAP_H
# define PUSH_SWAP_H

# include <limits.h>
# include <stdlib.h>
# include <unistd.h>
# include <stddef.h>

typedef struct s_stack
{
    int				value;
    int				index;
    struct s_stack	*next;
}	t_stack;

/* Libft functions */
int		ft_atoi(const char *str);
int		ft_isdigit(int c);
void	ft_putstr_fd(char *s, int fd);
char	*ft_substr(char const *s, unsigned int start, size_t len);
size_t	ft_strlen(const char *s);

/* Push operations */
void	pa(t_stack **a, t_stack **b);
void	pb(t_stack **a, t_stack **b);

/* Swap operations */
void	sa(t_stack **a);
void	sb(t_stack **b);
void	ss(t_stack **a, t_stack **b);

/* Shift operations (rotate) */
void	ra(t_stack **a);
void	rb(t_stack **b);
void	rr(t_stack **a, t_stack **b);

/* Reverse shift operations (reverse rotate) */
void	rra(t_stack **a);
void	rrb(t_stack **b);
void	rrr(t_stack **a, t_stack **b);

/* Stack utils */
int		stack_size(t_stack *stack);
int		is_sorted(t_stack *stack);
void	free_stack(t_stack **stack);
t_stack	*stack_last(t_stack *stack);
void	stack_add_back(t_stack **stack, t_stack *new);

/* Parsing and init */
int		init_stack(int ac, char **av, t_stack **a);
int		error_exit(t_stack **stack);

/* Sorting algorithms */
void	sort_two(t_stack **a);
void	sort_three(t_stack **a);
void	sort_four_five(t_stack **a, t_stack **b);
void	radix_sort(t_stack **a, t_stack **b, int max_bits);
int		get_max_bits(int size);

#endif