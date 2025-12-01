#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Counters
TOTAL_POINTS=0
MAX_POINTS=125
LEAK_ERRORS=0
TOTAL_LEAK_TESTS=0

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}    PUSH_SWAP STRICT EVALUATION - 42${NC}"
echo -e "${BLUE}================================================${NC}\n"

# Check if push_swap exists
if [ ! -f "./push_swap" ]; then
    echo -e "${RED}Error: push_swap executable not found!${NC}"
    echo -e "${YELLOW}Run 'make' first${NC}"
    exit 1
fi

# Check if valgrind is installed
if ! command -v valgrind &> /dev/null; then
    echo -e "${RED}Error: valgrind not installed!${NC}"
    echo -e "${YELLOW}Install with: sudo apt-get install valgrind${NC}"
    exit 1
fi

# Check if checker exists
if [ ! -f "./checker_linux" ]; then
    echo -e "${YELLOW}Warning: checker_linux not found. Will only count operations.${NC}"
    CHECKER_EXISTS=0
else
    CHECKER_EXISTS=1
fi

# Function to test with checker
test_checker() {
    local args="$1"
    if [ $CHECKER_EXISTS -eq 1 ]; then
        result=$(./push_swap $args | ./checker_linux $args)
        echo "$result"
    else
        echo "SKIP"
    fi
}

# Function to count operations
count_ops() {
    local args="$1"
    ./push_swap $args 2>/dev/null | wc -l
}

# Strict valgrind test function
strict_valgrind_test() {
    local test_name="$1"
    local args="$2"
    ((TOTAL_LEAK_TESTS++))
    
    echo -n "  Valgrind: $test_name... "
    
    VALGRIND_OUTPUT=$(valgrind --leak-check=full --show-leak-kinds=all \
                      --errors-for-leak-kinds=all --error-exitcode=42 \
                      --track-origins=yes --quiet \
                      ./push_swap $args 2>&1)
    VALGRIND_EXIT=$?
    
    # Check for any leaks
    if echo "$VALGRIND_OUTPUT" | grep -q "definitely lost"; then
        echo -e "${RED}✗ DEFINITELY LOST${NC}"
        echo "$VALGRIND_OUTPUT" | grep "definitely lost"
        ((LEAK_ERRORS++))
        return 1
    elif echo "$VALGRIND_OUTPUT" | grep -q "indirectly lost"; then
        echo -e "${RED}✗ INDIRECTLY LOST${NC}"
        echo "$VALGRIND_OUTPUT" | grep "indirectly lost"
        ((LEAK_ERRORS++))
        return 1
    elif echo "$VALGRIND_OUTPUT" | grep -q "possibly lost"; then
        echo -e "${RED}✗ POSSIBLY LOST${NC}"
        echo "$VALGRIND_OUTPUT" | grep "possibly lost"
        ((LEAK_ERRORS++))
        return 1
    elif echo "$VALGRIND_OUTPUT" | grep -q "still reachable"; then
        echo -e "${RED}✗ STILL REACHABLE${NC}"
        echo "$VALGRIND_OUTPUT" | grep "still reachable"
        ((LEAK_ERRORS++))
        return 1
    elif [ $VALGRIND_EXIT -eq 42 ]; then
        echo -e "${RED}✗ VALGRIND ERROR (exit 42)${NC}"
        ((LEAK_ERRORS++))
        return 1
    elif echo "$VALGRIND_OUTPUT" | grep -q "Invalid read"; then
        echo -e "${RED}✗ INVALID READ${NC}"
        ((LEAK_ERRORS++))
        return 1
    elif echo "$VALGRIND_OUTPUT" | grep -q "Invalid write"; then
        echo -e "${RED}✗ INVALID WRITE${NC}"
        ((LEAK_ERRORS++))
        return 1
    elif echo "$VALGRIND_OUTPUT" | grep -q "Invalid free"; then
        echo -e "${RED}✗ INVALID FREE${NC}"
        ((LEAK_ERRORS++))
        return 1
    else
        echo -e "${GREEN}✓ CLEAN${NC}"
        return 0
    fi
}

echo -e "${MAGENTA}=== STRICT MEMORY LEAK TESTS (CRITICAL) ===${NC}\n"

# Test 1: No arguments
echo "Test 1: No arguments"
strict_valgrind_test "no args" ""

# Test 2: Already sorted
echo "Test 2: Already sorted (1 2 3 4 5)"
strict_valgrind_test "sorted" "1 2 3 4 5"

# Test 3: Reverse sorted
echo "Test 3: Reverse sorted (5 4 3 2 1)"
strict_valgrind_test "reverse" "5 4 3 2 1"

# Test 4: Random small
echo "Test 4: Random small (3 1 4 2)"
strict_valgrind_test "random small" "3 1 4 2"

# Test 5: Duplicates (ERROR case)
echo "Test 5: Duplicates - ERROR case (1 2 2 3)"
strict_valgrind_test "duplicates" "1 2 2 3"

# Test 6: Invalid character (ERROR case)
echo "Test 6: Invalid char - ERROR case (1 a 2)"
strict_valgrind_test "invalid char" "1 a 2"

# Test 7: Overflow (ERROR case)
echo "Test 7: INT_MAX overflow - ERROR case (2147483648)"
strict_valgrind_test "overflow" "2147483648"

# Test 8: Underflow (ERROR case)
echo "Test 8: INT_MIN underflow - ERROR case (-2147483649)"
strict_valgrind_test "underflow" "-2147483649"

# Test 9: Mixed valid/invalid
echo "Test 9: Mixed signs (42 -17 0 89 -3)"
strict_valgrind_test "mixed signs" "42 -17 0 89 -3"

# Test 10: Large set (100 numbers)
echo "Test 10: Large set (100 numbers)"
ARG_100=$(shuf -i 1-5000 -n 100 | tr '\n' ' ')
strict_valgrind_test "100 numbers" "$ARG_100"

# Test 11: Whitespace in argument
echo "Test 11: Whitespace in argument"
strict_valgrind_test "whitespace" '1 "  2" 3'

# Test 12: Leading zeros
echo "Test 12: Leading zeros (001 002 003)"
strict_valgrind_test "leading zeros" "001 002 003"

# Test 13: INT_MAX valid
echo "Test 13: INT_MAX valid (2147483647)"
strict_valgrind_test "INT_MAX" "2147483647 1 2"

# Test 14: INT_MIN valid
echo "Test 14: INT_MIN valid (-2147483648)"
strict_valgrind_test "INT_MIN" "-2147483648 1 2"

# Test 15: Empty string argument
echo "Test 15: Empty string"
strict_valgrind_test "empty string" '""'

echo ""
if [ $LEAK_ERRORS -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✓ ALL MEMORY TESTS PASSED (${TOTAL_LEAK_TESTS}/${TOTAL_LEAK_TESTS})    ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}\n"
else
    echo -e "${RED}╔════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ✗ MEMORY TESTS FAILED: ${LEAK_ERRORS}/${TOTAL_LEAK_TESTS}         ║${NC}"
    echo -e "${RED}║  CRITICAL: FIX ALL LEAKS BEFORE EVAL  ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════╝${NC}\n"
    echo -e "${RED}EVALUATION FAILED - Memory leaks detected!${NC}\n"
    exit 1
fi

echo -e "${BLUE}=== PART 1: ERROR MANAGEMENT (15 points) ===${NC}\n"

ERRORS_PASSED=0
ERRORS_TOTAL=5

# Test 1: Non-numeric argument
echo -n "Test 1: Non-numeric argument (abc)... "
./push_swap abc 2>&1 | grep -q "Error"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ PASS${NC}"
    ((ERRORS_PASSED++))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 2: Argument bigger than INT_MAX
echo -n "Test 2: Argument > INT_MAX (2147483648)... "
./push_swap 2147483648 2>&1 | grep -q "Error"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ PASS${NC}"
    ((ERRORS_PASSED++))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 3: Argument smaller than INT_MIN
echo -n "Test 3: Argument < INT_MIN (-2147483649)... "
./push_swap -2147483649 2>&1 | grep -q "Error"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ PASS${NC}"
    ((ERRORS_PASSED++))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 4: Duplicates
echo -n "Test 4: Duplicate numbers (1 2 2 3)... "
./push_swap 1 2 2 3 2>&1 | grep -q "Error"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ PASS${NC}"
    ((ERRORS_PASSED++))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 5: No arguments
echo -n "Test 5: No arguments... "
OUTPUT=$(./push_swap 2>&1)
if [ -z "$OUTPUT" ]; then
    echo -e "${GREEN}✓ PASS${NC}"
    ((ERRORS_PASSED++))
else
    echo -e "${RED}✗ FAIL (should output nothing)${NC}"
fi

ERROR_POINTS=$((ERRORS_PASSED * 3))
TOTAL_POINTS=$((TOTAL_POINTS + ERROR_POINTS))
echo -e "\n${YELLOW}Error Management: $ERRORS_PASSED/$ERRORS_TOTAL tests passed (${ERROR_POINTS}/15 points)${NC}\n"

echo -e "${BLUE}=== PART 2: IDENTITY TEST (5 points) ===${NC}\n"

IDENTITY_PASSED=0

# Test already sorted
echo -n "Test: Already sorted list (1 2 3 4 5)... "
OUTPUT=$(./push_swap 1 2 3 4 5)
if [ -z "$OUTPUT" ]; then
    echo -e "${GREEN}✓ PASS (no operations)${NC}"
    IDENTITY_PASSED=1
    TOTAL_POINTS=$((TOTAL_POINTS + 5))
else
    echo -e "${RED}✗ FAIL (should output nothing)${NC}"
fi

echo -e "\n${YELLOW}Identity Test: ${IDENTITY_PASSED}/1 test passed ($((IDENTITY_PASSED * 5))/5 points)${NC}\n"

echo -e "${BLUE}=== PART 3: SIMPLE VERSION (25 points) ===${NC}\n"

SIMPLE_PASSED=0
SIMPLE_TOTAL=5

# Test 2 numbers
echo -n "Test 1: 2 numbers (2 1)... "
OPS=$(count_ops "2 1")
RESULT=$(test_checker "2 1")
if [ "$RESULT" = "OK" ] || [ "$RESULT" = "SKIP" ]; then
    if [ $OPS -le 1 ]; then
        echo -e "${GREEN}✓ PASS (${OPS} op)${NC}"
        ((SIMPLE_PASSED++))
    else
        echo -e "${YELLOW}⚠ WORKS but ${OPS} ops (should be ≤1)${NC}"
    fi
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 3 numbers - multiple cases
echo -n "Test 2: 3 numbers (2 1 3)... "
OPS=$(count_ops "2 1 3")
RESULT=$(test_checker "2 1 3")
if [ "$RESULT" = "OK" ] || [ "$RESULT" = "SKIP" ]; then
    if [ $OPS -le 3 ]; then
        echo -e "${GREEN}✓ PASS (${OPS} ops)${NC}"
        ((SIMPLE_PASSED++))
    else
        echo -e "${YELLOW}⚠ WORKS but ${OPS} ops (should be ≤3)${NC}"
    fi
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 5 numbers - multiple cases
echo -n "Test 3: 5 numbers (5 4 3 2 1)... "
OPS=$(count_ops "5 4 3 2 1")
RESULT=$(test_checker "5 4 3 2 1")
if [ "$RESULT" = "OK" ] || [ "$RESULT" = "SKIP" ]; then
    if [ $OPS -le 12 ]; then
        echo -e "${GREEN}✓ PASS (${OPS} ops)${NC}"
        ((SIMPLE_PASSED++))
    else
        echo -e "${YELLOW}⚠ WORKS but ${OPS} ops (should be ≤12)${NC}"
    fi
else
    echo -e "${RED}✗ FAIL${NC}"
fi

echo -n "Test 4: 5 numbers (1 5 2 4 3)... "
OPS=$(count_ops "1 5 2 4 3")
RESULT=$(test_checker "1 5 2 4 3")
if [ "$RESULT" = "OK" ] || [ "$RESULT" = "SKIP" ]; then
    if [ $OPS -le 12 ]; then
        echo -e "${GREEN}✓ PASS (${OPS} ops)${NC}"
        ((SIMPLE_PASSED++))
    else
        echo -e "${YELLOW}⚠ WORKS but ${OPS} ops (should be ≤12)${NC}"
    fi
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Random 5
ARG_5=$(shuf -i 1-5000 -n 5 | tr '\n' ' ')
echo -n "Test 5: 5 random numbers... "
OPS=$(count_ops "$ARG_5")
RESULT=$(test_checker "$ARG_5")
if [ "$RESULT" = "OK" ] || [ "$RESULT" = "SKIP" ]; then
    if [ $OPS -le 12 ]; then
        echo -e "${GREEN}✓ PASS (${OPS} ops)${NC}"
        ((SIMPLE_PASSED++))
    else
        echo -e "${YELLOW}⚠ WORKS but ${OPS} ops (should be ≤12)${NC}"
    fi
else
    echo -e "${RED}✗ FAIL${NC}"
fi

SIMPLE_POINTS=$((SIMPLE_PASSED * 5))
TOTAL_POINTS=$((TOTAL_POINTS + SIMPLE_POINTS))
echo -e "\n${YELLOW}Simple Version: ${SIMPLE_PASSED}/${SIMPLE_TOTAL} tests passed (${SIMPLE_POINTS}/25 points)${NC}\n"

echo -e "${BLUE}=== PART 4: MIDDLE VERSION - 100 NUMBERS (30 points) ===${NC}\n"

MIDDLE_POINTS=0
MIDDLE_TESTS=5
PASSED_100=0

for i in $(seq 1 $MIDDLE_TESTS); do
    ARG_100=$(shuf -i 1-5000 -n 100 | tr '\n' ' ')
    OPS=$(count_ops "$ARG_100")
    RESULT=$(test_checker "$ARG_100")
    
    echo -n "Test $i (100 numbers): "
    
    if [ "$RESULT" = "KO" ]; then
        echo -e "${RED}✗ FAIL (incorrect sort)${NC}"
        continue
    fi
    
    if [ $OPS -lt 700 ]; then
        echo -e "${GREEN}✓ EXCELLENT (${OPS} ops) - 5/5${NC}"
        MIDDLE_POINTS=$((MIDDLE_POINTS + 5))
        ((PASSED_100++))
    elif [ $OPS -lt 900 ]; then
        echo -e "${GREEN}✓ VERY GOOD (${OPS} ops) - 4/5${NC}"
        MIDDLE_POINTS=$((MIDDLE_POINTS + 4))
        ((PASSED_100++))
    elif [ $OPS -lt 1100 ]; then
        echo -e "${GREEN}✓ GOOD (${OPS} ops) - 3/5${NC}"
        MIDDLE_POINTS=$((MIDDLE_POINTS + 3))
        ((PASSED_100++))
    elif [ $OPS -lt 1300 ]; then
        echo -e "${YELLOW}✓ OK (${OPS} ops) - 2/5${NC}"
        MIDDLE_POINTS=$((MIDDLE_POINTS + 2))
        ((PASSED_100++))
    elif [ $OPS -lt 1500 ]; then
        echo -e "${YELLOW}✓ ACCEPTABLE (${OPS} ops) - 1/5${NC}"
        MIDDLE_POINTS=$((MIDDLE_POINTS + 1))
        ((PASSED_100++))
    else
        echo -e "${RED}⚠ TOO MANY OPS (${OPS} ops) - 0/5${NC}"
    fi
done

TOTAL_POINTS=$((TOTAL_POINTS + MIDDLE_POINTS))
echo -e "\n${YELLOW}Middle Version (100): ${PASSED_100}/${MIDDLE_TESTS} tests passed (${MIDDLE_POINTS}/30 points)${NC}\n"

echo -e "${BLUE}=== PART 5: ADVANCED VERSION - 500 NUMBERS (50 points) ===${NC}\n"

ADVANCED_POINTS=0
ADVANCED_TESTS=5
PASSED_500=0

for i in $(seq 1 $ADVANCED_TESTS); do
    ARG_500=$(shuf -i 1-10000 -n 500 | tr '\n' ' ')
    OPS=$(count_ops "$ARG_500")
    RESULT=$(test_checker "$ARG_500")
    
    echo -n "Test $i (500 numbers): "
    
    if [ "$RESULT" = "KO" ]; then
        echo -e "${RED}✗ FAIL (incorrect sort)${NC}"
        continue
    fi
    
    if [ $OPS -lt 5500 ]; then
        echo -e "${GREEN}✓ EXCELLENT (${OPS} ops) - 10/10${NC}"
        ADVANCED_POINTS=$((ADVANCED_POINTS + 10))
        ((PASSED_500++))
    elif [ $OPS -lt 7000 ]; then
        echo -e "${GREEN}✓ VERY GOOD (${OPS} ops) - 8/10${NC}"
        ADVANCED_POINTS=$((ADVANCED_POINTS + 8))
        ((PASSED_500++))
    elif [ $OPS -lt 8500 ]; then
        echo -e "${GREEN}✓ GOOD (${OPS} ops) - 6/10${NC}"
        ADVANCED_POINTS=$((ADVANCED_POINTS + 6))
        ((PASSED_500++))
    elif [ $OPS -lt 10000 ]; then
        echo -e "${YELLOW}✓ OK (${OPS} ops) - 4/10${NC}"
        ADVANCED_POINTS=$((ADVANCED_POINTS + 4))
        ((PASSED_500++))
    elif [ $OPS -lt 11500 ]; then
        echo -e "${YELLOW}✓ ACCEPTABLE (${OPS} ops) - 2/10${NC}"
        ADVANCED_POINTS=$((ADVANCED_POINTS + 2))
        ((PASSED_500++))
    else
        echo -e "${RED}⚠ TOO MANY OPS (${OPS} ops) - 0/10${NC}"
    fi
done

TOTAL_POINTS=$((TOTAL_POINTS + ADVANCED_POINTS))
echo -e "\n${YELLOW}Advanced Version (500): ${PASSED_500}/${ADVANCED_TESTS} tests passed (${ADVANCED_POINTS}/50 points)${NC}\n"

echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}                 FINAL SCORE${NC}"
echo -e "${BLUE}================================================${NC}"
echo -e "${GREEN}                ${TOTAL_POINTS}/${MAX_POINTS} points${NC}"
echo -e "${CYAN}        Memory Tests: ${TOTAL_LEAK_TESTS}/${TOTAL_LEAK_TESTS} CLEAN${NC}"
echo -e "${BLUE}================================================${NC}\n"

# Grade interpretation
if [ $TOTAL_POINTS -ge 115 ]; then
    echo -e "${GREEN}🌟 EXCELLENT! Outstanding work!${NC}"
elif [ $TOTAL_POINTS -ge 100 ]; then
    echo -e "${GREEN}✓ VERY GOOD! Keep it up!${NC}"
elif [ $TOTAL_POINTS -ge 80 ]; then
    echo -e "${YELLOW}✓ GOOD! Room for optimization.${NC}"
elif [ $TOTAL_POINTS -ge 60 ]; then
    echo -e "${YELLOW}⚠ ACCEPTABLE. Consider improving efficiency.${NC}"
else
    echo -e "${RED}✗ NEEDS WORK. Review your algorithm.${NC}"
fi

echo ""
exit 0
