/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   atoi.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jihad <jihad@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/11/15 00:00:00 by your_login        #+#    #+#             */
/*   Updated: 2025/11/15 15:21:19 by jihad            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

static int	ft_atoi_validate(long result, int sign)
{
	if ((sign == 1 && result > 2147483647)
		|| (sign == -1 && result > 2147483648))
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

	result = 0;
	while (str[*i] >= '0' && str[*i] <= '9')
	{
		result = result * 10 + (str[*i] - '0');
		ft_atoi_validate(result, sign);
		(*i)++;
	}
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
	}
	result = parse_number(str, &i, sign);
	i += skip_whitespace(&str[i]);
	if (str[i] != '\0')
		ft_error();
	return ((int)(result * sign));
}
