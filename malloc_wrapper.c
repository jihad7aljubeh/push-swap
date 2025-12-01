/* Malloc wrapper to simulate allocation failures */
#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int malloc_count = 0;
static int fail_after = -1;

void *malloc(size_t size)
{
    static void *(*real_malloc)(size_t) = NULL;
    
    if (!real_malloc)
        real_malloc = dlsym(RTLD_NEXT, "malloc");
    
    malloc_count++;
    
    if (fail_after > 0 && malloc_count >= fail_after)
        return NULL;
    
    return real_malloc(size);
}

void set_malloc_fail_after(int n)
{
    fail_after = n;
}

__attribute__((constructor))
void init(void)
{
    char *env = getenv("MALLOC_FAIL_AFTER");
    if (env)
        fail_after = atoi(env);
}
