#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  MALLOC FAILURE INJECTION TEST${NC}"
echo -e "${BLUE}================================================${NC}\n"

# Compile malloc wrapper
echo "Compiling malloc wrapper..."
gcc -shared -fPIC -o libmalloc_wrapper.so malloc_wrapper.c -ldl 2>/dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to compile malloc wrapper${NC}"
    exit 1
fi

LEAK_COUNT=0
TEST_COUNT=0

test_malloc_fail() {
    local fail_at=$1
    local args="$2"
    local desc="$3"
    
    ((TEST_COUNT++))
    echo -n "Test $TEST_COUNT: $desc (fail at alloc #$fail_at)... "
    
    # Run with malloc wrapper and valgrind
    MALLOC_FAIL_AFTER=$fail_at LD_PRELOAD=./libmalloc_wrapper.so \
    valgrind --leak-check=full --show-leak-kinds=all \
             --errors-for-leak-kinds=all --error-exitcode=42 \
             --track-origins=yes --quiet \
             ./push_swap $args 2>&1 > /tmp/valgrind_out_$$.txt
    
    VALGRIND_EXIT=$?
    
    # Check for leaks
    if grep -qE "definitely lost|indirectly lost|possibly lost|still reachable" /tmp/valgrind_out_$$.txt; then
        echo -e "${RED}✗ LEAK${NC}"
        grep -E "lost|reachable" /tmp/valgrind_out_$$.txt | head -3
        ((LEAK_COUNT++))
    elif [ $VALGRIND_EXIT -eq 42 ]; then
        echo -e "${RED}✗ ERROR${NC}"
        ((LEAK_COUNT++))
    else
        echo -e "${GREEN}✓ CLEAN${NC}"
    fi
    
    rm -f /tmp/valgrind_out_$$.txt
}

echo -e "${YELLOW}Testing malloc failures at different allocation points:${NC}\n"

# Test failing at first malloc
test_malloc_fail 1 "5 4 3 2 1" "first malloc fails"

# Test failing at second malloc
test_malloc_fail 2 "5 4 3 2 1" "second malloc fails"

# Test with error inputs
test_malloc_fail 1 "1 2 2 3" "duplicate with early fail"
test_malloc_fail 2 "1 2 2 3" "duplicate with late fail"

# Test with larger inputs
test_malloc_fail 1 "$(seq 1 10 | tr '\n' ' ')" "10 numbers - first malloc"
test_malloc_fail 2 "$(seq 1 10 | tr '\n' ' ')" "10 numbers - second malloc"

# Test invalid inputs with malloc failures
test_malloc_fail 1 "abc" "invalid input with malloc fail"
test_malloc_fail 1 "2147483648" "overflow with malloc fail"

echo ""
echo -e "${BLUE}================================================${NC}"
if [ $LEAK_COUNT -eq 0 ]; then
    echo -e "${GREEN}  ✓ ALL MALLOC FAILURE TESTS PASSED${NC}"
    echo -e "${GREEN}  NO LEAKS EVEN WITH MALLOC FAILURES${NC}"
else
    echo -e "${RED}  ✗ MEMORY LEAKS: ${LEAK_COUNT}/${TEST_COUNT} failed${NC}"
    echo -e "${RED}  FIX: Ensure cleanup on malloc failures${NC}"
fi
echo -e "${BLUE}================================================${NC}\n"

# Cleanup
rm -f libmalloc_wrapper.so

exit $LEAK_COUNT
