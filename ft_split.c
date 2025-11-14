/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_split.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jalju-be <jalju-be@student.42amman.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/08/28 23:55:25 by jalju-be          #+#    #+#             */
/*   Updated: 2025/11/11 19:42:04 by jalju-be         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

static int	words_count(char const *s, char c, size_t *start)
{
	int		flag;
	int		count;
	size_t	i;

	*start = 0;
	flag = 1;
	i = 0;
	count = 0;
	while (s[i])
	{
		if (s[i] != c && flag == 1)
		{
			count++;
			flag = 0;
		}
		if (s[i] == c && flag == 0)
			flag = 1;
		i++;
	}
	return (count);
}

static int	size_word(char const *s, char c, size_t start)
{
	size_t	j;
	int		i;

	j = start;
	if (s[j] == c)
		j++;
	i = 0;
	while (s[j] && s[j] != c)
	{
		i++;
		j++;
	}
	return (i);
}

static char	*create_word(char const *s, char c, size_t *start)
{
	char	*word;
	size_t	len;

	while (s[*start] == c)
		(*start)++;
	len = size_word(s, c, *start);
	word = ft_substr(s, *start, len);
	while (s[*start] && s[*start] != c)
		(*start)++;
	if (!word)
		return (NULL);
	return (word);
}

static void	free_all(char **s, int words)
{
	int	i;

	i = 0;
	while (i < words)
	{
		free(s[i]);
		i++;
	}
	free(s);
}

char	**ft_split(char const *s, char c)
{
	char		**arr;
	char		*word;
	size_t		start;
	int			words;
	int			i;

	i = 0;
	if (!s)
		return (NULL);
	words = words_count(s, c, &start);
	arr = (char **)malloc(sizeof(char *) * (words + 1));
	if (arr == NULL)
		return (NULL);
	while (i < words)
	{
		word = create_word(s, c, &start);
		if (word == NULL)
		{
			free_all(arr, i);
			return (NULL);
		}
		arr[i++] = word;
	}
	arr[i] = NULL;
	return (arr);
}
/*int	main()
{
	char *arr = "jihad-jalal-aljubeh-hi";
	char **arr2 = ft_split(arr, '-');
	int i = 0;
	int j = 0;
	while(arr2[i] != NULL)
	{
		j = 0;
		while(arr2[i][j] != '\0')
		{
			printf("%c",arr2[i][j]);
			j++;
		}
		printf("\n");
		i++;
	}
	free_all(arr2, 4);
	return 0;
}*/