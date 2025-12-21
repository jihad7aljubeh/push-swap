*This project has been created as part of the 42 curriculum by jalju-be.*

# push_swap

## Description

push_swap is an algorithmic project that sorts a list of integers using two stacks  
(stack **a** and stack **b**) and a limited set of operations.  
The goal is to produce a **correct** and **as small as possible** sequence of operations
that sorts stack **a** in ascending order.

The program:
- takes a list of integers as command‑line arguments,
- validates them (format, duplicates, integer limits),
- builds stack **a**,
- outputs a sequence of operations on stdout that will sort the stack.

### Available operations

- `sa` / `sb` / `ss` – swap the first two elements of stack a / stack b / both  
- `pa` / `pb` – push the top element from b to a / from a to b  
- `ra` / `rb` / `rr` – rotate a / b / both (first element becomes last)  
- `rra` / `rrb` / `rrr` – reverse rotate a / b / both (last element becomes first)

## Instructions

### Compilation

From the project root:

```sh
make
```

This builds the `push_swap` executable defined in the [Makefile](Makefile).

### Usage

```sh
./push_swap <list of integers>
```

Example:

```sh
./push_swap 3 2 5 1 4
```

The program prints a sequence of operations, one per line.

### Checking with the 42 checker

If you have the provided `checker_linux` binary in the same directory:

```sh
./push_swap 3 2 5 1 4 | ./checker_linux 3 2 5 1 4
```

- `OK` – the list is correctly sorted  
- `KO` – the list is not correctly sorted  
- `Error` – invalid input

### Cleaning

```sh
make clean   # remove object files
make fclean  # remove object files and the push_swap binary
make re      # full rebuild
```

## Project structure (overview)

- `main.c` – argument handling, stack initialization, and call to the sorter  
- `push_swap.c` – argument parsing and duplicate checks  
- `swap.c`, `push.c`, `shift.c`, `rshift.c` – implementation of all allowed operations  
- `sort.c` – specific small‑case sort (3, 4, 5 elements) and dispatcher  
- `radix.c` – radix sort for larger inputs (using normalized indices)  
- `utils.c`, `utils2.c` – stack utilities, normalization, validation, memory handling  
- `atoi.c` – custom `ft_atoi` with error and overflow checks  
- `push_swap.h` – type definitions and function prototypes

## Resources

### Algorithm & C references

- 42 **push_swap** subject PDF (official rules and requirements)  
- General stack and sorting references:
  - CLRS – *Introduction to Algorithms* (sorting chapters)
  - Radix sort explanations (binary / LSD radix sort)
- C programming references:
  - `man 3 malloc`, `man 3 free`, `man 3 write`
  - ISO C integer limits: `<limits.h>` (`INT_MIN`, `INT_MAX`)

### AI usage

AI (GitHub Copilot / ChatGPT‑style tools) was used for:

- Writing and rephrasing this `README.md`
- Getting high‑level explanations of radix sort and small‑case sorting strategies

All core code (stack structure, operations, parsing, error handling, sorting
algorithms, and overall design) was written and debugged manually.