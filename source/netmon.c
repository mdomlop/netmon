#include <stdio.h>
#include <unistd.h> /* sleep */
#include <stdlib.h> /* exit */
#include <string.h>
#include <dirent.h> /* readdir */

#define PROGRAM     "NetMon"
#define EXECUTABLE  "netmon"
#define DESCRIPTION "Simple console network traffic monitor for Linux."
#define VERSION     "1.0"
#define AUTHOR      "Manuel Domínguez López"
#define MAIL        "zqbzybc@tznvy.pbz"
#define URL         "https://github.com/mdomlop/netmon"
#define LICENSE     "GPLv3+"

#define KIBIBYTE 1024
#define MEBIBYTE 1024 * 1024
#define GIBIBYTE 1024 * 1024 * 1024
#define TEBIBYTE 1024.0 * 1024 * 1024 * 1024
#define PEBIBYTE 1024.0 * 1024 * 1024 * 1024 * 1024
#define EXBIBYTE 1024.0 * 1024 * 1024 * 1024 * 1024 * 1024
#define ZEBIBYTE 1024.0 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024
#define YOBIBYTE 1024.0 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024

#define fromKIB 1.0 * 1024
#define fromMIB 1.0 * 1024 * 1024
#define fromGIB 1.0 * 1024 * 1024 * 1024
#define fromTIB 1.0 * 1024 * 1024 * 1024 * 1024
#define fromPIB 1.0 * 1024 * 1024 * 1024 * 1024 * 1024
#define fromEIB 1.0 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024
#define fromZIB 1.0 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024
#define fromYIB 1.0 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024

#define toKIB 1.0 / 1024
#define toMIB 1.0 / 1024 / 1024
#define toGIB 1.0 / 1024 / 1024 / 1024
#define toTIB 1.0 / 1024 / 1024 / 1024 / 1024
#define toPIB 1.0 / 1024 / 1024 / 1024 / 1024 / 1024
#define toEIB 1.0 / 1024 / 1024 / 1024 / 1024 / 1024 / 1024
#define toZIB 1.0 / 1024 / 1024 / 1024 / 1024 / 1024 / 1024 / 1024
#define toYIB 1.0 / 1024 / 1024 / 1024 / 1024 / 1024 / 1024 / 1024 / 1024

#define DIRADDR "/sys/class/net/"
#define RXADDR  "/statistics/rx_bytes"
#define TXADDR  "/statistics/tx_bytes"

/* Select RX or TX */
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


unsigned long int readbytes(char * iface, int rcv)
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
        return strtoul(bytes, NULL, 10);
    return 0;
}


int main(int argc, char ** argv)
{
    char * interface;
    unsigned long int previous_rx = 0;
    unsigned long int previous_tx = 0;
    unsigned long int current_rx = 0;
    unsigned long int current_tx = 0;
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


    while (1) {
		/* Caching values */
		previous_rx = readbytes(interface, RX);
		previous_tx = readbytes(interface, TX);
        sleep(1);
        current_rx = readbytes(interface, RX);
        current_tx = readbytes(interface, TX);

        rx_f = current_rx - previous_rx;
        tx_f = current_tx - previous_tx;

        printf("[%s] ", interface);

		/* Rx */
        if (rx_f < KIBIBYTE)
            printf("Rx: %3.2f B/s ", rx_f);
		else if (rx_f < MEBIBYTE)
            printf("Rx: %3.2f KiB/s ", rx_f / toKIB);
		else if (rx_f < GIBIBYTE)
            printf("Rx: %3.2f MiB/s ", rx_f / toMIB);
		else if (rx_f < TEBIBYTE)
            printf("Rx: %3.2f GiB/s ", rx_f / toGIB);
		else if (rx_f < PEBIBYTE)
            printf("Rx: %3.2f TiB/s ", rx_f / toTIB);
		else if (rx_f < EXBIBYTE)
            printf("Rx: %3.2f PiB/s ", rx_f / toPIB);
		else if (rx_f < ZEBIBYTE)
            printf("Rx: %3.2f EiB/s ", rx_f / toEIB);
		else if (rx_f < YOBIBYTE)
            printf("Rx: %3.2f ZiB/s ", rx_f / toZIB);
		else
            printf("Rx: %3.2f YiB/s ", rx_f / toYIB);

		/* Tx */
        if (tx_f < KIBIBYTE)
            printf("Tx: %3.2f B/s ", tx_f);
		else if (tx_f < MEBIBYTE)
            printf("Tx: %3.2f KiB/s ", tx_f / toKIB);
		else if (tx_f < GIBIBYTE)
            printf("Tx: %3.2f MiB/s ", tx_f / toMIB);
		else if (tx_f < TEBIBYTE)
            printf("Tx: %3.2f GiB/s ", tx_f / toGIB);
		else if (tx_f < PEBIBYTE)
            printf("Tx: %3.2f TiB/s ", tx_f / toTIB);
		else if (tx_f < EXBIBYTE)
            printf("Tx: %3.2f PiB/s ", tx_f / toPIB);
		else if (tx_f < ZEBIBYTE)
            printf("Tx: %3.2f EiB/s ", tx_f / toEIB);
		else if (tx_f < YOBIBYTE)
            printf("Tx: %3.2f ZiB/s ", tx_f / toZIB);
		else
            printf("Tx: %3.2f YiB/s ", tx_f / toYIB);



		/* Total Rx */
        if (current_rx < KIBIBYTE)
            printf("TRx: %lu B ", current_rx);
		else if (current_rx < MEBIBYTE)
            printf("TRx: %3.2f KiB ", current_rx / toKIB);
		else if (current_rx < GIBIBYTE)
            printf("TRx: %3.2f MiB ", current_rx / toMIB);
		else if (current_rx < TEBIBYTE)
            printf("TRx: %3.2f GiB ", current_rx / toGIB);
		else if (current_rx < PEBIBYTE)
            printf("TRx: %3.2f TiB ", current_rx / toTIB);
		else if (current_rx < EXBIBYTE)
            printf("TRx: %3.2f PiB ", current_rx / toPIB);
		else if (current_rx < ZEBIBYTE)
            printf("TRx: %3.2f EiB ", current_rx / toEIB);
		else if (current_rx < YOBIBYTE)
            printf("TRx: %3.2f ZiB ", current_rx / toZIB);
		else
            printf("TRx: %3.2f YiB ", current_rx / toYIB);


		/* Total Tx */
        if (current_tx < KIBIBYTE)
            printf("TTx: %lu B", current_tx);
		else if (current_tx < MEBIBYTE)
            printf("TTx: %3.2f KiB", current_tx / toKIB);
		else if (current_tx < GIBIBYTE)
            printf("TTx: %3.2f MiB", current_tx / toMIB);
		else if (current_tx < TEBIBYTE)
            printf("TTx: %3.2f GiB", current_tx / toGIB);
		else if (current_tx < PEBIBYTE)
            printf("TTx: %3.2f TiB", current_tx / toTIB);
		else if (current_tx < EXBIBYTE)
            printf("TTx: %3.2f PiB", current_tx / toPIB);
		else if (current_tx < ZEBIBYTE)
            printf("TTx: %3.2f EiB", current_tx / toEIB);
		else if (current_tx < YOBIBYTE)
            printf("TTx: %3.2f ZiB", current_tx / toZIB);
		else
            printf("TTx: %3.2f YiB", current_tx / toYIB);

		printf("\n");
    }

    return 0;
}


