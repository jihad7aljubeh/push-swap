#!/bin/bash
# filepath: /home/jalju-be/core/milestone2/push_swap/malloc_checker.sh

# ============================================================================
#                          PUSH_SWAP MALLOC CHECKER
# ============================================================================
# Comprehensive memory leak detection using Valgrind
# Tests all aspects: basic operations, errors, edge cases, and stress tests
# ============================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Configuration
VALGRIND_OPTS="--leak-check=full --show-leak-kinds=all --track-origins=yes --errors-for-leak-kinds=definite,possible --error-exitcode=42"
LOG_FILE="valgrind_output.log"
DETAILED_LOG="detailed_failures.log"

# Counters
total_tests=0
passed_tests=0
failed_tests=0
leak_tests=0
error_tests=0

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo -e "\n${BOLD}${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${BLUE}  $1${NC}"
    echo -e "${BOLD}${BLUE}════════════════════════════════════════════════════════════${NC}\n"
}

print_section() {
    echo -e "\n${BOLD}${CYAN}┌──────────────────────────────────────────┐${NC}"
    echo -e "${BOLD}${CYAN}│  $1${NC}"
    echo -e "${BOLD}${CYAN}└──────────────────────────────────────────┘${NC}\n"
}

# Check prerequisites
check_requirements() {
    print_header "Checking Requirements"
    
    # Check valgrind
    if ! command -v valgrind &> /dev/null; then
        echo -e "${RED}✗ Valgrind is not installed${NC}"
        echo -e "${YELLOW}Install with: sudo apt-get install valgrind${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Valgrind found: $(valgrind --version | head -n1)${NC}"
    
    # Check if push_swap exists or needs compilation
    if [ ! -f "./push_swap" ]; then
        echo -e "${YELLOW}⚠ push_swap not found. Compiling...${NC}"
        make re > /dev/null 2>&1
        if [ ! -f "./push_swap" ]; then
            echo -e "${RED}✗ Compilation failed${NC}"
            exit 1
        fi
    fi
    echo -e "${GREEN}✓ push_swap binary ready${NC}"
}

# Run valgrind test
run_test() {
    local test_name="$1"
    local args="$2"
    local expect_error="$3"  # "error" if we expect Error output
    
    total_tests=$((total_tests + 1))
    
    # Progress indicator
    printf "${BLUE}[%03d]${NC} Testing: %-50s " "$total_tests" "$test_name"
    
    # Run valgrind
    valgrind $VALGRIND_OPTS \
             --log-file="$LOG_FILE" \
             ./push_swap $args > /dev/null 2>&1
    
    valgrind_exit=$?
    
    # Check program output for errors
    program_output=$(./push_swap $args 2>&1)
    
    # Parse valgrind output
    definitely_lost=$(grep "definitely lost:" "$LOG_FILE" | awk '{print $4}' | sed 's/,//g')
    indirectly_lost=$(grep "indirectly lost:" "$LOG_FILE" | awk '{print $4}' | sed 's/,//g')
    possibly_lost=$(grep "possibly lost:" "$LOG_FILE" | awk '{print $4}' | sed 's/,//g')
    still_reachable=$(grep "still reachable:" "$LOG_FILE" | awk '{print $4}' | sed 's/,//g')
    error_summary=$(grep "ERROR SUMMARY:" "$LOG_FILE" | awk '{print $4}')
    
    # Set defaults if empty
    definitely_lost=${definitely_lost:-0}
    indirectly_lost=${indirectly_lost:-0}
    possibly_lost=${possibly_lost:-0}
    error_summary=${error_summary:-0}
    
    # Determine if test passed
    has_leaks=false
    has_errors=false
    
    if [ "$definitely_lost" != "0" ] || [ "$indirectly_lost" != "0" ] || [ "$possibly_lost" != "0" ]; then
        has_leaks=true
        leak_tests=$((leak_tests + 1))
    fi
    
    if [ "$error_summary" != "0" ]; then
        has_errors=true
        error_tests=$((error_tests + 1))
    fi
    
    # Check if error was expected
    if [ "$expect_error" = "error" ]; then
        if echo "$program_output" | grep -q "Error"; then
            if [ "$has_leaks" = false ] && [ "$has_errors" = false ]; then
                echo -e "${GREEN}✓ PASS${NC}"
                passed_tests=$((passed_tests + 1))
            else
                echo -e "${RED}✗ FAIL (leak on error)${NC}"
                failed_tests=$((failed_tests + 1))
                log_failure "$test_name" "$args" "Error case with memory leak"
            fi
        else
            echo -e "${RED}✗ FAIL (no error)${NC}"
            failed_tests=$((failed_tests + 1))
            log_failure "$test_name" "$args" "Expected Error output"
        fi
    else
        if [ "$has_leaks" = false ] && [ "$has_errors" = false ]; then
            echo -e "${GREEN}✓ PASS${NC}"
            passed_tests=$((passed_tests + 1))
        else
            echo -e "${RED}✗ FAIL${NC}"
            failed_tests=$((failed_tests + 1))
            
            # Show leak details
            if [ "$has_leaks" = true ]; then
                echo -e "    ${RED}├─ Definitely lost: $definitely_lost bytes${NC}"
                echo -e "    ${RED}├─ Indirectly lost: $indirectly_lost bytes${NC}"
                echo -e "    ${RED}└─ Possibly lost: $possibly_lost bytes${NC}"
            fi
            if [ "$has_errors" = true ]; then
                echo -e "    ${RED}└─ Memory errors: $error_summary${NC}"
            fi
            
            log_failure "$test_name" "$args" "Memory leak detected"
        fi
    fi
    
    rm -f "$LOG_FILE"
}

# Log detailed failure information
log_failure() {
    local test_name="$1"
    local args="$2"
    local reason="$3"
    
    {
        echo "=========================================="
        echo "FAILED TEST: $test_name"
        echo "ARGS: $args"
        echo "REASON: $reason"
        echo "TIME: $(date)"
        echo "=========================================="
        echo ""
    } >> "$DETAILED_LOG"
}

# Generate random numbers
generate_random() {
    local count=$1
    local min=${2:--1000}
    local max=${3:-1000}
    shuf -i $min-$max -n $count | tr '\n' ' '
}

# ============================================================================
# Test Suites
# ============================================================================

test_empty_and_single() {
    print_section "Empty & Single Element Tests"
    run_test "No arguments" "" ""
    run_test "Single number: 42" "42" ""
    run_test "Single number: 0" "0" ""
    run_test "Single number: negative" "-42" ""
    run_test "Single number: INT_MAX" "2147483647" ""
    run_test "Single number: INT_MIN" "-2147483648" ""
}

test_two_elements() {
    print_section "Two Elements Tests"
    run_test "Two sorted: 1 2" "1 2" ""
    run_test "Two unsorted: 2 1" "2 1" ""
    run_test "Two negative: -5 -1" "-5 -1" ""
    run_test "Two with zero: 0 1" "0 1" ""
}

test_three_elements() {
    print_section "Three Elements Tests"
    run_test "Three sorted: 1 2 3" "1 2 3" ""
    run_test "Three case: 2 1 3" "2 1 3" ""
    run_test "Three case: 3 2 1" "3 2 1" ""
    run_test "Three case: 1 3 2" "1 3 2" ""
    run_test "Three case: 2 3 1" "2 3 1" ""
    run_test "Three case: 3 1 2" "3 1 2" ""
}

test_five_elements() {
    print_section "Five Elements Tests"
    run_test "Five sorted" "1 2 3 4 5" ""
    run_test "Five reverse" "5 4 3 2 1" ""
    run_test "Five random 1" "3 5 2 1 4" ""
    run_test "Five random 2" "2 4 1 5 3" ""
    run_test "Five with negatives" "-2 5 -8 10 0" ""
}

test_error_handling() {
    print_section "Error Handling Tests"
    run_test "Duplicate: 1 2 3 2" "1 2 3 2" "error"
    run_test "Duplicate: same number twice" "5 5" "error"
    run_test "Non-numeric: abc" "1 2 abc" "error"
    run_test "Non-numeric: with symbols" "1 @ 3" "error"
    run_test "Overflow: INT_MAX + 1" "2147483648" "error"
    run_test "Underflow: INT_MIN - 1" "-2147483649" "error"
    run_test "Invalid format: plus sign" "1 +2 3" "error"
    run_test "Invalid format: double minus" "1 --2 3" "error"
    run_test "Empty string in args" "1 '' 3" "error"
    run_test "Just spaces" "   " "error"
}

test_medium_stack() {
    print_section "Medium Stack Tests (10-50 elements)"
    run_test "10 random numbers" "$(generate_random 10)" ""
    run_test "20 random numbers" "$(generate_random 20)" ""
    run_test "30 random numbers" "$(generate_random 30)" ""
    run_test "50 random numbers" "$(generate_random 50)" ""
}

test_large_stack() {
    print_section "Large Stack Tests (100+ elements)"
    run_test "100 random numbers" "$(generate_random 100)" ""
    run_test "100 sorted ascending" "$(seq 1 100 | tr '\n' ' ')" ""
    run_test "100 sorted descending" "$(seq 100 -1 1 | tr '\n' ' ')" ""
}

test_stress() {
    print_section "Stress Tests"
    run_test "500 random numbers" "$(generate_random 500)" ""
    run_test "500 with negatives" "$(generate_random 500 -500 500)" ""
}

test_edge_cases() {
    print_section "Edge Cases"
    run_test "All negative" "-5 -4 -3 -2 -1" ""
    run_test "With zero: 0 -5 5" "0 -5 5" ""
    run_test "Large range: MIN to MAX" "-2147483648 0 2147483647" ""
    run_test "Many duplicates (error)" "1 1 1 1 1" "error"
    run_test "Alternating +/-" "-1 1 -2 2 -3 3" ""
}

# ============================================================================
# Summary and Reporting
# ============================================================================

print_summary() {
    print_header "Test Summary"
    
    local success_rate=0
    if [ $total_tests -gt 0 ]; then
        success_rate=$((passed_tests * 100 / total_tests))
    fi
    
    echo -e "${BOLD}Total Tests:${NC}      $total_tests"
    echo -e "${GREEN}${BOLD}Passed:${NC}           $passed_tests"
    echo -e "${RED}${BOLD}Failed:${NC}           $failed_tests"
    echo -e "${YELLOW}${BOLD}Tests with leaks:${NC} $leak_tests"
    echo -e "${YELLOW}${BOLD}Tests with errors:${NC} $error_tests"
    echo -e "${BOLD}Success Rate:${NC}     $success_rate%"
    
    echo ""
    
    if [ $failed_tests -eq 0 ]; then
        echo -e "${GREEN}${BOLD}"
        echo "╔════════════════════════════════════════════════════════════╗"
        echo "║                                                            ║"
        echo "║          🎉  ALL TESTS PASSED - NO LEAKS! 🎉              ║"
        echo "║                                                            ║"
        echo "╚════════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        rm -f "$DETAILED_LOG"
    else
        echo -e "${RED}${BOLD}"
        echo "╔════════════════════════════════════════════════════════════╗"
        echo "║                                                            ║"
        echo "║          ⚠️   MEMORY ISSUES DETECTED! ⚠️                   ║"
        echo "║                                                            ║"
        echo "╚════════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        echo -e "${YELLOW}See $DETAILED_LOG for detailed failure information${NC}"
    fi
}

# ============================================================================
# Main Execution
# ============================================================================

main() {
    # Clear old logs
    rm -f "$LOG_FILE" "$DETAILED_LOG"
    
    # Print banner
    clear
    echo -e "${BOLD}${MAGENTA}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                                                            ║"
    echo "║           PUSH_SWAP MALLOC CHECKER v2.0                   ║"
    echo "║                                                            ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Run checks
    check_requirements
    
    # Run test suites
    test_empty_and_single
    test_two_elements
    test_three_elements
    test_five_elements
    test_error_handling
    test_medium_stack
    test_large_stack
    test_stress
    test_edge_cases
    
    # Print summary
    print_summary
    
    # Cleanup
    make fclean > /dev/null 2>&1
    
    # Exit with appropriate code
    if [ $failed_tests -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
}

# Run main
main