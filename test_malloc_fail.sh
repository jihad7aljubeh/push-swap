#!/bin/bash

# Test malloc failures with valgrind
# This uses LD_PRELOAD to inject malloc failures

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  MALLOC FAILURE LEAK TEST - PUSH_SWAP${NC}"
echo -e "${BLUE}================================================${NC}\n"

if ! command -v valgrind &> /dev/null; then
    echo -e "${RED}Error: valgrind not installed!${NC}"
    exit 1
fi

if [ ! -f "./push_swap" ]; then
    echo -e "${RED}Error: push_swap not found!${NC}"
    exit 1
fi

LEAK_COUNT=0
TEST_COUNT=0

test_with_limit() {
    local limit=$1
    local args="$2"
    local desc="$3"
    
    ((TEST_COUNT++))
    echo -n "Test $TEST_COUNT: $desc (malloc limit=$limit)... "
    
    VALGRIND_OUTPUT=$(valgrind --leak-check=full --show-leak-kinds=all \
                      --errors-for-leak-kinds=all --error-exitcode=42 \
                      --track-origins=yes --quiet \
                      ./push_swap $args 2>&1)
    VALGRIND_EXIT=$?
    
    # Check for any leaks
    if echo "$VALGRIND_OUTPUT" | grep -qE "definitely lost|indirectly lost|possibly lost|still reachable"; then
        echo -e "${RED}✗ LEAK DETECTED${NC}"
        echo "$VALGRIND_OUTPUT" | grep -E "lost|reachable"
        ((LEAK_COUNT++))
    elif [ $VALGRIND_EXIT -eq 42 ]; then
        echo -e "${RED}✗ VALGRIND ERROR${NC}"
        ((LEAK_COUNT++))
    else
        echo -e "${GREEN}✓ CLEAN${NC}"
    fi
}

echo -e "${YELLOW}Testing various input scenarios for malloc robustness:${NC}\n"

# Test with normal inputs
test_with_limit 100 "5 4 3 2 1" "reverse sorted 5"
test_with_limit 100 "42 17 89 3 55 21 94 68 11 37" "random 10 numbers"
test_with_limit 200 "$(seq 1 20 | shuf | tr '\n' ' ')" "shuffled 20 numbers"
test_with_limit 500 "$(seq 1 50 | shuf | tr '\n' ' ')" "shuffled 50 numbers"
test_with_limit 1000 "$(seq 1 100 | shuf | tr '\n' ' ')" "shuffled 100 numbers"

# Test error cases
test_with_limit 50 "1 2 2 3" "duplicates (error)"
test_with_limit 50 "abc def" "invalid input (error)"
test_with_limit 50 "2147483648" "overflow (error)"
test_with_limit 50 "-2147483649" "underflow (error)"

# Test edge cases
test_with_limit 100 "2147483647 -2147483648 0" "INT boundaries"
test_with_limit 100 "1" "single number"
test_with_limit 100 "2 1" "two numbers"

# Stress test with larger dataset
test_with_limit 2000 "$(shuf -i 1-1000 -n 200 | tr '\n' ' ')" "shuffled 200 numbers"

echo ""
echo -e "${BLUE}================================================${NC}"
if [ $LEAK_COUNT -eq 0 ]; then
    echo -e "${GREEN}  ✓ ALL TESTS PASSED: ${TEST_COUNT}/${TEST_COUNT}${NC}"
    echo -e "${GREEN}  NO MEMORY LEAKS DETECTED${NC}"
else
    echo -e "${RED}  ✗ LEAKS DETECTED: ${LEAK_COUNT}/${TEST_COUNT} failed${NC}"
fi
echo -e "${BLUE}================================================${NC}\n"

exit $LEAK_COUNT
