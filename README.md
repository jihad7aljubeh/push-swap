# push_swap

`push_swap` is an algorithmic project from the 42 curriculum whose goal is to **sort a stack of integers** using **a very limited set of operations** and **as few moves as possible**.

You must:

- Implement a sorting program `push_swap` that prints the sequence of operations.
- Optionally implement a checker program `checker` that validates a given list of operations.
- Respect strict rules on allowed instructions and input handling.

---

## 📚 Table of Contents

- [Overview](#overview)
- [Project Objectives](#project-objectives)
- [Program Descriptions](#program-descriptions)
  - [`push_swap`](#push_swap)
  - [`checker` (bonus)](#checker-bonus)
- [Input & Error Handling](#input--error-handling)
- [Allowed Operations](#allowed-operations)
- [Algorithm](#algorithm)
  - [Small stacks](#small-stacks)
  - [Bigger stacks](#bigger-stacks)
- [Project Structure](#project-structure)
- [Compilation](#compilation)
- [Usage](#usage)
- [Examples](#examples)
- [Norme & Constraints](#norme--constraints)
- [Testing](#testing)
- [Author](#author)

---

## Overview

You are given a list of integers as arguments:

```bash
./push_swap 2 1 3 6 5 8
```

Your program must:

1. **Sort them in ascending order** using **two stacks** (`a` and `b`).
2. Use only a predefined set of stack operations (`sa`, `pb`, `ra`, etc.).
3. **Output the sequence of operations** on `stdout`.

The challenge is to generate an algorithm that:

- Always sorts correctly.
- Uses **as few operations as possible** (efficiency is graded).
- Handles all edge cases and invalid input.

---

## Project Objectives

- Understand and implement **stack** data structures.
- Design and implement **sorting algorithms** under constraints.
- Work with **complex input parsing** and **error handling**.
- Optimize for **time and operation count**, not just correctness.
- Respect the **42 Norme** while keeping code modular and readable.

---

## Program Descriptions

### `push_swap`

- **Name:** `push_swap`
- **Usage:**  
  ```bash
  ./push_swap <list of integers>
  ```
- **Behavior:**
  - If the input is already sorted → print nothing and exit.
  - Otherwise → print a list of operations (one per line) that will sort stack `a`.
  - No other output or debug logs are allowed during evaluation.

### `checker` (bonus)

If you implemented the bonus part:

- **Name:** `checker`
- **Usage:**
  ```bash
  ./checker <list of integers>
  ```
  Then it reads operations from **stdin** and applies them to the stacks:
  - If after applying all operations stack `a` is sorted and stack `b` is empty:
    - Print `OK`
  - Otherwise:
    - Print `KO`

---

## Input & Error Handling

The program must handle:

- Multiple arguments:
  ```bash
  ./push_swap 3 2 1
  ```
- Single argument with spaces:
  ```bash
  ./push_swap "3 2 1"
  ```

### Valid input

- Each argument must be a **valid integer** (within `INT_MIN` and `INT_MAX`).
- No duplicates are allowed.

### On error

In case of:
- Non-numeric values
- Values out of integer range
- Duplicates
- Empty input

The program must:

- Write `Error\n` to `stderr`.
- Exit with a non-zero status.
- Not perform any operation.

---

## Allowed Operations

You can only use these instructions (printed one per line by `push_swap`):

### Swap

- `sa` – swap the first two elements at the top of stack `a`
- `sb` – swap the first two elements at the top of stack `b`
- `ss` – `sa` and `sb` at the same time

### Push

- `pa` – take the first element at the top of `b` and put it at the top of `a`
- `pb` – take the first element at the top of `a` and put it at the top of `b`

### Rotate

- `ra` – shift all elements of `a` up by 1 (first becomes last)
- `rb` – shift all elements of `b` up by 1
- `rr` – `ra` and `rb` at the same time

### Reverse rotate

- `rra` – shift all elements of `a` down by 1 (last becomes first)
- `rrb` – shift all elements of `b` down by 1
- `rrr` – `rra` and `rrb` at the same time

---

## Algorithm

The exact strategy is up to you, but a common and efficient approach is:

### Small stacks

- **2 elements:**  
  - Simple `sa` if needed.
- **3 elements:**  
  - Hardcoded minimal instruction sequences depending on the order.
- **Up to 5 elements:**  
  - Push smallest elements to `b`, sort remaining 3 in `a`, then push back.

### Bigger stacks

Some popular strategies:

- **Indexing / Normalization:**
  - Replace each value by its index in the sorted order (0, 1, 2, …).
  - This simplifies comparisons and helps with bitwise or chunk-based sorting.

- **Radix sort (binary):**
  - Iterate over bits of indexed numbers.
  - Push elements with current bit = 0 to `b`, then push back to `a`.
  - Complexity: ~`O(n * log n)` with a relatively low move count.

- **Chunk-based algorithm:**
  - Divide the range of values into “chunks”.
  - Move chunk by chunk from `a` to `b`, placing them in the right order, then push back.

Your README can briefly describe what you chose:

> In this implementation, small stacks (≤ 5 elements) are sorted with specific cases, while bigger stacks are sorted using an indexed **radix sort** algorithm to keep the number of operations relatively low.

*(Adapt the line above to your real algorithm if needed.)*

---

## Project Structure

A typical `push_swap` repository might look like:

```text
.
├── includes/
│   └── push_swap.h
├── src/
│   ├── main.c
│   ├── parse_args.c
│   ├── init_stack.c
│   ├── operations_swap.c
│   ├── operations_push.c
│   ├── operations_rotate.c
│   ├── operations_reverse_rotate.c
│   ├── sort_small.c
│   ├── sort_big.c
│   ├── utils_stack.c
│   └── utils_general.c
├── bonus/
│   ├── checker.c                  # (bonus)
│   ├── checker_utils.c            # (bonus)
│   └── get_next_line_*.[ch]       # (if used for reading stdin)
├── libft/                         # (if you reuse your libft)
├── Makefile
└── README.md
```

> If your structure is different, you can adjust this section to match your actual file organization.

---

## Compilation

With a standard `Makefile`:

```bash
make          # builds push_swap
make bonus    # (if implemented) builds checker
make clean
make fclean
make re
```

This typically produces:

- `push_swap` in the root directory
- `checker` (for bonus)

If you want to compile manually:

```bash
cc -Wall -Wextra -Werror \
    src/*.c -Iincludes -o push_swap
```

(Adjust paths according to your repo.)

---

## Usage

### Sorting with `push_swap`

```bash
./push_swap 2 1 3
sa
```

The printed operations are what a checker or evaluator will use to test your algorithm.

To see the resulting sequence and also run it through your own checker:

```bash
./push_swap 4 67 3 87 23 9 | ./checker 4 67 3 87 23 9
# Expected output (if sorted correctly): OK
```

### Using `checker` alone (bonus)

```bash
# Manually type operations
./checker 3 2 1
sa
rra
<Ctrl-D>  # end of input
```

Or pipe a list of moves:

```bash
echo -e "pb\npb\nsa\npa\npa" | ./checker 3 2 1
```

---

## Examples

```bash
./push_swap 3 2 1
sa
rra
```

```bash
./push_swap 1 2 3 4 5
# no output (already sorted)
```

```bash
./push_swap 2 3 1 5 4
pb
sa
pa
sa
ra
ra
```

*(The exact output depends on your algorithm.)*

---

## Norme & Constraints

- Code must follow the **42 Norme**.
- No memory leaks or invalid frees.
- No global variables (unless strictly allowed by your campus rules).
- Only allowed functions from the subject + your own (and possibly `libft` if permitted).
- No additional output besides the required instructions (and `Error` for invalid input).

---

## Testing

You can test your project with:

- Your own scripts and random tests:

  ```bash
  ARG=$(seq 1 100 | shuf | tr '\n' ' ')
  ./push_swap $ARG | ./checker $ARG
  ```

- Community testers (search GitHub for):
  - `push_swap_tester`
  - `push_swap_visualizer`
  - `42_push_swap_tester`

Visualizers can help you see how your stacks change during the operations and help you optimize your algorithm.

---

## Author

- **Login:** `jalju-be`  
- **School:** 42  
- **GitHub:** [jihad7aljubeh](https://github.com/jihad7aljubeh)
