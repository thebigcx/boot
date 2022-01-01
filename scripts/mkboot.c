#include <stdio.h>
#include <stdlib.h>

void usage()
{
    printf("usage: mkboot <disk>\n");
}

int main(int argc, char **argv)
{
    if (argc < 2)
    {
        usage();
        return EXIT_FAILURE;
    }

    FILE *disk = fopen(argv[1], "r+");
    if (!disk)
    {
        char msg[64];
        snprintf(msg, 64, "mkboot: %s", argv[1]);
        perror(msg);
    }
    
    return EXIT_SUCCESS;
}
