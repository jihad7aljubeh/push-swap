NAME = push_swap

CC = cc
CFLAGS = -Wall -Wextra -Werror

SRCS = main.c push_swap.c swap.c push.c shift.c rshift.c radix.c \
	   sort.c utils.c utils2.c atoi.c

OBJS = $(SRCS:.c=.o)

all: $(NAME)

$(NAME): $(OBJS)
	@echo "Linking $(NAME)..."
	@$(CC) $(CFLAGS) $(OBJS) -o $(NAME)
	@echo "✓ $(NAME) created successfully!"

%.o: %.c push_swap.h
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "Cleaning object files..."
	@rm -f $(OBJS)
	@echo "✓ Clean complete!"

fclean: clean
	@echo "Removing $(NAME)..."
	@rm -f $(NAME)
	@echo "✓ Full clean complete!"

re: fclean all

.PHONY: all clean fclean re
