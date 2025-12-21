/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   atoi.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/26 15:56:03 by jalju-be          #+#    #+#             */
/*   Updated: 2025/12/21 16:29:01 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

static int	ft_atoi_validate(long result, int sign)
{
	if ((sign == 1 && result > INT_MAX) || (sign == -1
			&& result > (long)INT_MAX + 1))
		ft_error();
	return (1);
}

static int	skip_whitespace(const char *str)
{
	int	i;

	i = 0;
	while (str[i] == ' ' || (str[i] >= 9 && str[i] <= 13))
		i++;
	return (i);
}

static long	parse_number(const char *str, int *i, int sign)
{
	long	result;
	int		start;

	result = 0;
	start = *i;
	while (str[*i] >= '0' && str[*i] <= '9')
	{
		result = result * 10 + (str[*i] - '0');
		ft_atoi_validate(result, sign);
		(*i)++;
	}
	if (*i == start)
		ft_error();
	return (result);
}

int	ft_atoi(const char *str)
{
	long	result;
	int		sign;
	int		i;

	i = skip_whitespace(str);
	if (str[i] == '\0')
		ft_error();
	sign = 1;
	if (str[i] == '-' || str[i] == '+')
	{
		if (str[i] == '-')
			sign = -1;
		i++;
		if (!ft_isdigit(str[i]))
			ft_error();
	}
	result = parse_number(str, &i, sign);
	i += skip_whitespace(&str[i]);
	if (str[i] != '\0')
		ft_error();
	return ((int)(result * sign));
}
