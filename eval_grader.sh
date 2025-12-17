#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if push_swap exists
if [ ! -f "./push_swap" ]; then
    echo -e "${RED}Error: push_swap executable not found!${NC}"
    echo "Please compile first with: make"
    exit 1
fi

# Check if checker exists
CHECKER=""
if [ -f "./checker" ]; then
    CHECKER="./checker"
elif [ -f "./checker_linux" ]; then
    CHECKER="./checker_linux"
    chmod +x checker_linux
elif [ -f "./checker_Mac" ]; then
    CHECKER="./checker_Mac"
    chmod +x checker_Mac
fi

if [ -z "$CHECKER" ]; then
    echo -e "${RED}Error: checker not found!${NC}"
    echo "Please download checker_linux or checker_Mac"
    exit 1
fi

echo -e "${CYAN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║      PUSH_SWAP - 42 EVALUATION SHEET (100pts)      ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}\n"

TOTAL_SCORE=0

# ============================================
# PART 1: ERROR MANAGEMENT (10 points)
# ============================================
echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}PART 1: ERROR MANAGEMENT (10 points)${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}\n"

ERROR_SCORE=0

echo -e "${YELLOW}Test 1.1: No arguments (2 pts)${NC}"
RESULT=$(./push_swap 2>&1)
if [ -z "$RESULT" ]; then
    echo -e "${GREEN}✓ PASS: No output${NC}"
    ERROR_SCORE=$((ERROR_SCORE + 2))
else
    echo -e "${RED}✗ FAIL: Expected no output${NC}"
fi
echo ""

echo -e "${YELLOW}Test 1.2: Duplicate numbers (2 pts)${NC}"
RESULT=$(./push_swap 1 2 3 2 2>&1)
if echo "$RESULT" | grep -q "Error"; then
    echo -e "${GREEN}✓ PASS: Error displayed${NC}"
    ERROR_SCORE=$((ERROR_SCORE + 2))
else
    echo -e "${RED}✗ FAIL: Should display 'Error'${NC}"
fi
echo ""

echo -e "${YELLOW}Test 1.3: Non-numeric parameter (2 pts)${NC}"
RESULT=$(./push_swap 1 2 three 4 2>&1)
if echo "$RESULT" | grep -q "Error"; then
    echo -e "${GREEN}✓ PASS: Error displayed${NC}"
    ERROR_SCORE=$((ERROR_SCORE + 2))
else
    echo -e "${RED}✗ FAIL: Should display 'Error'${NC}"
fi
echo ""

echo -e "${YELLOW}Test 1.4: Number > INT_MAX (2 pts)${NC}"
RESULT=$(./push_swap 1 2 2147483648 2>&1)
if echo "$RESULT" | grep -q "Error"; then
    echo -e "${GREEN}✓ PASS: Error displayed${NC}"
    ERROR_SCORE=$((ERROR_SCORE + 2))
else
    echo -e "${RED}✗ FAIL: Should display 'Error'${NC}"
fi
echo ""

echo -e "${YELLOW}Test 1.5: Number < INT_MIN (2 pts)${NC}"
RESULT=$(./push_swap 1 2 -2147483649 2>&1)
if echo "$RESULT" | grep -q "Error"; then
    echo -e "${GREEN}✓ PASS: Error displayed${NC}"
    ERROR_SCORE=$((ERROR_SCORE + 2))
else
    echo -e "${RED}✗ FAIL: Should display 'Error'${NC}"
fi
echo ""

echo -e "${BLUE}Score Part 1: $ERROR_SCORE/10${NC}\n"
TOTAL_SCORE=$((TOTAL_SCORE + ERROR_SCORE))

# ============================================
# PART 2: IDENTITY TEST (5 points)
# ============================================
echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}PART 2: IDENTITY TEST (5 points)${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}\n"

IDENTITY_SCORE=0

echo -e "${YELLOW}Test 2.1: Single number (1 pt)${NC}"
RESULT=$(./push_swap 42 | wc -l)
if [ $RESULT -eq 0 ]; then
    echo -e "${GREEN}✓ PASS: 0 instructions${NC}"
    IDENTITY_SCORE=$((IDENTITY_SCORE + 1))
else
    echo -e "${RED}✗ FAIL: Should output nothing${NC}"
fi
echo ""

echo -e "${YELLOW}Test 2.2: Already sorted - 3 numbers (2 pts)${NC}"
RESULT=$(./push_swap 1 2 3 | wc -l)
if [ $RESULT -eq 0 ]; then
    echo -e "${GREEN}✓ PASS: 0 instructions${NC}"
    IDENTITY_SCORE=$((IDENTITY_SCORE + 2))
else
    echo -e "${RED}✗ FAIL: Should output nothing${NC}"
fi
echo ""

echo -e "${YELLOW}Test 2.3: Already sorted - 10 numbers (2 pts)${NC}"
RESULT=$(./push_swap 0 1 2 3 4 5 6 7 8 9 | wc -l)
if [ $RESULT -eq 0 ]; then
    echo -e "${GREEN}✓ PASS: 0 instructions${NC}"
    IDENTITY_SCORE=$((IDENTITY_SCORE + 2))
else
    echo -e "${RED}✗ FAIL: Should output nothing${NC}"
fi
echo ""

echo -e "${BLUE}Score Part 2: $IDENTITY_SCORE/5${NC}\n"
TOTAL_SCORE=$((TOTAL_SCORE + IDENTITY_SCORE))

# ============================================
# PART 3: SIMPLE VERSION - 3 NUMBERS (10 points)
# ============================================
echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}PART 3: SIMPLE VERSION - 3 NUMBERS (10 points)${NC}"
echo -e "${PURPLE}Maximum 3 operations${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}\n"

THREE_SCORE=0
THREE_TESTS=0
THREE_PASSED=0

test_three() {
    THREE_TESTS=$((THREE_TESTS + 1))
    MOVES=$(./push_swap $@ | wc -l)
    CHECK=$(./push_swap $@ | $CHECKER $@)
    
    if [ "$CHECK" = "OK" ] && [ $MOVES -le 3 ]; then
        echo -e "${GREEN}✓ [$@]: $MOVES moves${NC}"
        THREE_PASSED=$((THREE_PASSED + 1))
        return 0
    elif [ "$CHECK" = "OK" ]; then
        echo -e "${YELLOW}⚠ [$@]: $MOVES moves (sorted but > 3 moves)${NC}"
        return 1
    else
        echo -e "${RED}✗ [$@]: NOT SORTED${NC}"
        return 1
    fi
}

test_three 2 1 0
test_three 1 3 2
test_three 3 2 1
test_three 0 2 1
test_three 3 1 2

echo ""
if [ $THREE_PASSED -eq 5 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    THREE_SCORE=10
elif [ $THREE_PASSED -eq 4 ]; then
    THREE_SCORE=8
elif [ $THREE_PASSED -eq 3 ]; then
    THREE_SCORE=6
elif [ $THREE_PASSED -ge 2 ]; then
    THREE_SCORE=4
elif [ $THREE_PASSED -ge 1 ]; then
    THREE_SCORE=2
fi

echo -e "${BLUE}Score Part 3: $THREE_SCORE/10${NC}\n"
TOTAL_SCORE=$((TOTAL_SCORE + THREE_SCORE))

# ============================================
# PART 4: SIMPLE VERSION - 5 NUMBERS (15 points)
# ============================================
echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}PART 4: SIMPLE VERSION - 5 NUMBERS (15 points)${NC}"
echo -e "${PURPLE}Maximum 12 operations${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}\n"

FIVE_SCORE=0
FIVE_TESTS=0
FIVE_PASSED=0

for i in {1..10}; do
    ARG=$(seq 0 4 | shuf)
    FIVE_TESTS=$((FIVE_TESTS + 1))
    MOVES=$(./push_swap $ARG | wc -l)
    CHECK=$(./push_swap $ARG | $CHECKER $ARG)
    
    if [ "$CHECK" = "OK" ] && [ $MOVES -le 12 ]; then
        echo -e "${GREEN}✓ Test $i: $MOVES moves${NC}"
        FIVE_PASSED=$((FIVE_PASSED + 1))
    elif [ "$CHECK" = "OK" ]; then
        echo -e "${YELLOW}⚠ Test $i: $MOVES moves (> 12)${NC}"
    else
        echo -e "${RED}✗ Test $i: NOT SORTED${NC}"
    fi
done

echo ""
if [ $FIVE_PASSED -eq 10 ]; then
    FIVE_SCORE=15
elif [ $FIVE_PASSED -ge 8 ]; then
    FIVE_SCORE=12
elif [ $FIVE_PASSED -ge 6 ]; then
    FIVE_SCORE=9
elif [ $FIVE_PASSED -ge 4 ]; then
    FIVE_SCORE=6
elif [ $FIVE_PASSED -ge 2 ]; then
    FIVE_SCORE=3
fi

echo -e "${BLUE}Score Part 4: $FIVE_SCORE/15${NC}\n"
TOTAL_SCORE=$((TOTAL_SCORE + FIVE_SCORE))

# ============================================
# PART 5: MIDDLE VERSION - 100 NUMBERS (30 points)
# ============================================
echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}PART 5: MIDDLE VERSION - 100 NUMBERS (30 points)${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}\n"

total_100=0
points_100=0

for i in {1..5}; do
    ARG=$(seq 1 100 | shuf)
    MOVES=$(./push_swap $ARG | wc -l)
    CHECK=$(./push_swap $ARG | $CHECKER $ARG)
    total_100=$((total_100 + MOVES))
    
    if [ "$CHECK" != "OK" ]; then
        echo -e "${RED}✗ Test $i: NOT SORTED (0 pts)${NC}"
        continue
    fi
    
    if [ $MOVES -lt 700 ]; then
        echo -e "${GREEN}✓ Test $i: $MOVES moves ★★★★★ (5 pts)${NC}"
        points_100=$((points_100 + 5))
    elif [ $MOVES -lt 900 ]; then
        echo -e "${GREEN}✓ Test $i: $MOVES moves ★★★★☆ (4 pts)${NC}"
        points_100=$((points_100 + 4))
    elif [ $MOVES -lt 1100 ]; then
        echo -e "${YELLOW}⚠ Test $i: $MOVES moves ★★★☆☆ (3 pts)${NC}"
        points_100=$((points_100 + 3))
    elif [ $MOVES -lt 1300 ]; then
        echo -e "${YELLOW}⚠ Test $i: $MOVES moves ★★☆☆☆ (2 pts)${NC}"
        points_100=$((points_100 + 2))
    elif [ $MOVES -lt 1500 ]; then
        echo -e "${RED}✗ Test $i: $MOVES moves ★☆☆☆☆ (1 pt)${NC}"
        points_100=$((points_100 + 1))
    else
        echo -e "${RED}✗ Test $i: $MOVES moves ☆☆☆☆☆ (0 pts)${NC}"
    fi
done

avg_100=$((total_100 / 5))
HUNDRED_SCORE=$((points_100 * 30 / 25))

echo ""
echo -e "${BLUE}Average: $avg_100 moves${NC}"
echo -e "${BLUE}Points from tests: $points_100/25${NC}"
echo -e "${BLUE}Score Part 5: $HUNDRED_SCORE/30${NC}\n"
TOTAL_SCORE=$((TOTAL_SCORE + HUNDRED_SCORE))

# ============================================
# PART 6: ADVANCED VERSION - 500 NUMBERS (30 points)
# ============================================
echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}PART 6: ADVANCED VERSION - 500 NUMBERS (30 points)${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}\n"

total_500=0
points_500=0

for i in {1..5}; do
    ARG=$(seq 1 500 | shuf)
    MOVES=$(./push_swap $ARG | wc -l)
    CHECK=$(./push_swap $ARG | $CHECKER $ARG)
    total_500=$((total_500 + MOVES))
    
    if [ "$CHECK" != "OK" ]; then
        echo -e "${RED}✗ Test $i: NOT SORTED (0 pts)${NC}"
        continue
    fi
    
    if [ $MOVES -lt 5500 ]; then
        echo -e "${GREEN}✓ Test $i: $MOVES moves ★★★★★ (5 pts)${NC}"
        points_500=$((points_500 + 5))
    elif [ $MOVES -lt 7000 ]; then
        echo -e "${GREEN}✓ Test $i: $MOVES moves ★★★★☆ (4 pts)${NC}"
        points_500=$((points_500 + 4))
    elif [ $MOVES -lt 8500 ]; then
        echo -e "${YELLOW}⚠ Test $i: $MOVES moves ★★★☆☆ (3 pts)${NC}"
        points_500=$((points_500 + 3))
    elif [ $MOVES -lt 10000 ]; then
        echo -e "${YELLOW}⚠ Test $i: $MOVES moves ★★☆☆☆ (2 pts)${NC}"
        points_500=$((points_500 + 2))
    elif [ $MOVES -lt 11500 ]; then
        echo -e "${RED}✗ Test $i: $MOVES moves ★☆☆☆☆ (1 pt)${NC}"
        points_500=$((points_500 + 1))
    else
        echo -e "${RED}✗ Test $i: $MOVES moves ☆☆☆☆☆ (0 pts)${NC}"
    fi
done

avg_500=$((total_500 / 5))
FIVEHUNDRED_SCORE=$((points_500 * 30 / 25))

echo ""
echo -e "${BLUE}Average: $avg_500 moves${NC}"
echo -e "${BLUE}Points from tests: $points_500/25${NC}"
echo -e "${BLUE}Score Part 6: $FIVEHUNDRED_SCORE/30${NC}\n"
TOTAL_SCORE=$((TOTAL_SCORE + FIVEHUNDRED_SCORE))

# ============================================
# FINAL SCORE
# ============================================
echo -e "${CYAN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                  FINAL SCORE BREAKDOWN             ║${NC}"
echo -e "${CYAN}╠════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║  ${NC}Part 1 - Error Management:     ${GREEN}$ERROR_SCORE/10 pts${CYAN}          ║${NC}"
echo -e "${CYAN}║  ${NC}Part 2 - Identity Test:        ${GREEN}$IDENTITY_SCORE/5 pts${CYAN}           ║${NC}"
echo -e "${CYAN}║  ${NC}Part 3 - 3 Numbers:            ${GREEN}$THREE_SCORE/10 pts${CYAN}          ║${NC}"
echo -e "${CYAN}║  ${NC}Part 4 - 5 Numbers:            ${GREEN}$FIVE_SCORE/15 pts${CYAN}          ║${NC}"
echo -e "${CYAN}║  ${NC}Part 5 - 100 Numbers:          ${GREEN}$HUNDRED_SCORE/30 pts${CYAN}          ║${NC}"
echo -e "${CYAN}║  ${NC}Part 6 - 500 Numbers:          ${GREEN}$FIVEHUNDRED_SCORE/30 pts${CYAN}          ║${NC}"
echo -e "${CYAN}╠════════════════════════════════════════════════════╣${NC}"

if [ $TOTAL_SCORE -ge 95 ]; then
    echo -e "${CYAN}║  ${GREEN}TOTAL SCORE: $TOTAL_SCORE/100${CYAN}                              ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}\n"
    echo -e "${GREEN}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  🌟 OUTSTANDING! PERFECT OR NEAR-PERFECT SCORE! 🌟 ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"
elif [ $TOTAL_SCORE -ge 85 ]; then
    echo -e "${CYAN}║  ${GREEN}TOTAL SCORE: $TOTAL_SCORE/100${CYAN}                              ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}\n"
    echo -e "${GREEN}🎉 EXCELLENT! Your push_swap is very well optimized!${NC}"
elif [ $TOTAL_SCORE -ge 75 ]; then
    echo -e "${CYAN}║  ${GREEN}TOTAL SCORE: $TOTAL_SCORE/100${CYAN}                              ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}\n"
    echo -e "${GREEN}👍 GOOD! Solid implementation with room for optimization.${NC}"
elif [ $TOTAL_SCORE -ge 60 ]; then
    echo -e "${CYAN}║  ${YELLOW}TOTAL SCORE: $TOTAL_SCORE/100${CYAN}                              ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}\n"
    echo -e "${YELLOW}⚠️  PASS. Consider optimizing your sorting algorithm.${NC}"
elif [ $TOTAL_SCORE -ge 50 ]; then
    echo -e "${CYAN}║  ${YELLOW}TOTAL SCORE: $TOTAL_SCORE/100${CYAN}                              ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}\n"
    echo -e "${YELLOW}⚠️  BARELY PASS. Significant optimization needed.${NC}"
else
    echo -e "${CYAN}║  ${RED}TOTAL SCORE: $TOTAL_SCORE/100${CYAN}                              ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}\n"
    echo -e "${RED}❌ FAIL. Your algorithm needs major improvements.${NC}"
fi

echo ""
