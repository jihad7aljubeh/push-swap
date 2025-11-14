/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_atoi.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/08/09 15:05:05 by jalju-be          #+#    #+#             */
/*   Updated: 2025/11/11 19:41:53 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

int	ft_atoi(const char *str)
{
	int	i;
	int	sign;
	int	sum;

	i = 0;
	sign = 1;
	sum = 0;
	while (str[i] != '\0' && (str[i] == ' ' || ((str[i] >= 9 && str[i] <= 13))))
	{
		i++;
	}
	if (str[i] == '-' || str[i] == '+')
	{
		if (str[i] == '-')
			sign *= -1;
		i++;
	}
	while (str[i] != '\0' && (str[i] >= '0' && str[i] <= '9'))
	{
		sum = sum * 10 + (str[i] - '0');
		i++;
	}
	sum = sum * sign;
	return (sum);
}
/*int main ()
{
	printf("%d",ft_atoi("\t\n\r\v 465 \n"));
}*/