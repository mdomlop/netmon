#include <stdio.h>
#include <unistd.h> /* sleep */
#include <stdlib.h> /* exit */
#include <string.h>
#include <dirent.h>

#define MEBIBYTE 1024 * 1024

#define DIRADDR "/sys/class/net/"
#define RXADDR  "/statistics/rx_bytes"
#define TXADDR  "/statistics/tx_bytes"
#define RX 1
#define TX 0

void list_interfaces(void)
{
    DIR * dptr;
    struct dirent * dir;
    dptr = opendir(DIRADDR);
    if (dptr)
    {
        while ((dir = readdir(dptr)) != NULL)
        {
            if (dir->d_name[0] != '.') /* Skip hidden files */
                fprintf(stderr, "%s ", dir -> d_name);
        }
        closedir(dptr);
        puts("\n");
    }
}


int readbytes(char * iface, int rcv)
{
    char bytes[1024];
    char path[255]; 
    FILE * fptr;
    int fscanf_ok;

    strcpy(path, DIRADDR);
    strcat(path, iface);

    if (rcv)
        strcat(path, RXADDR);
    else
        strcat(path, TXADDR);

    if ((fptr = fopen(path, "r")) == NULL) {
        fprintf(stderr, "\nERROR: Network interface not found: %s\n"
                "\nThe available interfaces are: ", iface);
        
        list_interfaces();
        /* Program exits if file pointer returns NULL. */
        exit(1);
    }

    /* Reads text until newline is encountered */
    fscanf_ok = fscanf(fptr, "%[^\n]", bytes);
    fclose(fptr);

    if (fscanf_ok)
        return atoi(bytes);
    return 0;
}


int main(int argc, char ** argv)
{
    char * interface;
    int previous_rx = 0;
    int previous_tx = 0;
    int current_rx = 0;
    int current_tx = 0;
    float rx_f;
    float tx_f;

    if (argc != 2)
    {
        fprintf(stderr, "\nUsage:\n\n"
                "  %s INTERFACE"
                    
                "\n\nWhere INTERFACE is one of the "
                "interfaces on `/sys/class/net' directory.\n"
                "\nThe available interfaces are: ", argv[0]);
        list_interfaces();
        return 1;
    }

    interface = argv[2 - 1];


    previous_rx = readbytes(interface, RX); /* Caching values */
    previous_tx = readbytes(interface, TX);

    while (1) {
        sleep(1);
        current_rx = readbytes(interface, RX);
        current_tx = readbytes(interface, TX);
        rx_f = current_rx - previous_rx;
        tx_f = current_tx - previous_tx;

        if (rx_f < MEBIBYTE)
            printf("Received: %.2f KiB/s ", rx_f / 1024);
        else
            printf("Received: %.2f MiB/s ", rx_f / 1024 / 1024);

        if (tx_f < MEBIBYTE)
            printf("Transmitted: %.2f KiB/s\n", tx_f / 1024);
        else
            printf("Transmitted: %.2f MiB/s\n", tx_f / 1024 / 1024);

        previous_rx = current_rx;
        previous_tx = current_tx;
    }

    return 0;
}


