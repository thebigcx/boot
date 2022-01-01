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

    FILE *in = fopen("dist/mbr.bin", "r");
    
    fseek(in, 0, SEEK_END);
    size_t len = ftell(in);
    fseek(in, 0, SEEK_SET);

    char *buf = malloc(len);
    
    fread(buf, 3, 1, in);
    fwrite(buf, 3, 1, disk);
    
    fseek(in, 0x3e, SEEK_SET);
    fseek(disk, 0x3e, SEEK_SET);

    fread(buf, len - 0x3e, 1, in);
    fwrite(buf, len - 0x3e, 1, disk);
    fclose(in);

    fclose(disk);
    return EXIT_SUCCESS;
}
