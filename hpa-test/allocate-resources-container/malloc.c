/*
 * From https://stackoverflow.com/questions/44312720/how-to-allocate-a-large-memory-in-c
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    if (argc != 2)  {
	printf("Specify the number of Megabytes to reserve, max 1024\n");
	return 1;
    }
    int mb = atoi(argv[1]);
    if (mb > 1024 || mb < 1) {
	printf("Specify the number of Megabytes to reserve, max 1024\n");
	return 1;
    }

    size_t mem_size = 1024 * 1024 * mb;
    printf("MEMSIZE: %lu\n", mem_size);
    printf("SIZE OF: void*:%lu\n", sizeof(void*));
    printf("SIZE OF: char*:%lu\n", sizeof(char*));
    void *based = malloc(mem_size);  //mem_size = 1024^3
    int stage = 65536;
    int initialized = 0;
    if (based) {
        printf("Allocated %zu Bytes from %p to %p\n", mem_size, based, based + mem_size);
    } else {
        printf("Error in allocation.\n");
        return 1;
    }
    int n = 0;
    while (initialized < mem_size) {  //initialize it in batches
        //printf("%6d %p-%p\n", n, based+initialized, based+initialized+stage);
        n++;
        memset((char *)based + initialized, '$', stage);
        initialized += stage;
    }

    sleep(3600);

    free(based);

    return 0;
}
