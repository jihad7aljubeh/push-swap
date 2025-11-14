NAME = push_swap

CC = cc
CFLAGS = -Wall -Wextra -Werror -I.

SRCS = main.c \
    push_swap.c \
    sort_four_five.c \
    push_op.c \
    swap_op.c \
    shift_op.c \
    rev_shift_op.c \
    stack_utils.c \
    init_stack.c \
    error.c \
    ft_atoi.c \
    ft_isdigit.c \
    ft_putstr_fd.c \
    ft_substr.c \
    ft_strlen.c

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