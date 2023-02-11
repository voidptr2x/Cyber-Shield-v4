// sudo apt-get install libpcap-dev
#include <pcap.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

void process_packet(u_char *user, const struct pcap_pkthdr *header, const u_char *packet) {
    // destination address/port
    struct sockaddr_in dest_addr;
    memset(&dest_addr, 0, sizeof(dest_addr));
    dest_addr.sin_addr.s_addr = packet[16] << 24 | packet[17] << 16 | packet[18] << 8 | packet[19];
    dest_addr.sin_port = packet[22] << 8 | packet[23];
    char dest_ip[INET_ADDRSTRLEN];
    inet_ntop(AF_INET, &dest_addr.sin_addr, dest_ip, INET_ADDRSTRLEN);
    printf("Destination address/port: %s:%d\n", dest_ip, ntohs(dest_addr.sin_port));

    // source address/port
    struct sockaddr_in src_addr;
    memset(&src_addr, 0, sizeof(src_addr));
    src_addr.sin_addr.s_addr = packet[12] << 24 | packet[13] << 16 | packet[14] << 8 | packet[15];
    src_addr.sin_port = packet[20] << 8 | packet[21];
    char src_ip[INET_ADDRSTRLEN];
    inet_ntop(AF_INET, &src_addr.sin_addr, src_ip, INET_ADDRSTRLEN);
    printf("Source address/port: %s:%d\n", src_ip, ntohs(src_addr.sin_port));

    // bytes received
    printf("Bytes received: %d\n", header->len);

    printf("Data: ");
    // print the packet data
    for (int i = 0; i < header->len; i++)
        printf("%02x ", packet[i]);
    printf("\n");
}

int main(int argc, char *argv[]) {
    char *dev, errbuf[PCAP_ERRBUF_SIZE];
    pcap_t *handle;

    // find a device to capture packets on
    dev = pcap_lookupdev(errbuf);
    if (dev == NULL) {
        fprintf(stderr, "Couldn't find default device: %s\n", errbuf);
        return 1;
    }
    printf("Device: %s\n", dev);
    // open the device for capturing
    handle = pcap_open_live(dev, BUFSIZ, 1, 1000, errbuf);
    if (handle == NULL) {
        fprintf(stderr, "Couldn't open device %s: %s\n", dev, errbuf);
        return 2;
    }

    // apply a filter to capture only TCP or UDP packets
    struct bpf_program fp;
    char filter_exp[] = "tcp or udp";
    if (pcap_compile(handle, &fp, filter_exp, 0, PCAP_NETMASK_UNKNOWN) == -1) {
        fprintf(stderr, "Couldn't parse filter %s: %s\n", filter_exp, pcap_geterr(handle));
        return 3;
    }
    if (pcap_setfilter(handle, &fp) == -1) {
        fprintf(stderr, "Couldn't install filter %s: %s\n", filter_exp, pcap_geterr(handle));
        return 4;
    }

    // start capturing packets
    printf("Capturing packets...\n");
    pcap_loop(handle, 0, process_packet, NULL);

    pcap_freecode(&fp);
    pcap_close(handle);

    return 0;
}