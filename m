Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8043929AA49
	for <lists+io-uring@lfdr.de>; Tue, 27 Oct 2020 12:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898976AbgJ0LIJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 27 Oct 2020 07:08:09 -0400
Received: from de-smtp-delivery-103.mimecast.com ([51.163.158.103]:47580 "EHLO
        de-smtp-delivery-103.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2898975AbgJ0LII (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Oct 2020 07:08:08 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Oct 2020 07:08:05 EDT
Received: from vistrexch4.vi.vector.int (vistrannat0.vector-informatik.com
 [217.89.139.174]) (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-29-soiJiehCMoSsdKkIZjMfWA-1; Tue, 27 Oct 2020 12:01:26 +0100
X-MC-Unique: soiJiehCMoSsdKkIZjMfWA-1
From:   "Frederich, Jens" <Jens.Frederich@vector.com>
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Question about the optimal receiving TCP streams via io_uring
Thread-Topic: Question about the optimal receiving TCP streams via io_uring
Thread-Index: AdasTOgblLwO26ydRFujff30ATQR6w==
Date:   Tue, 27 Oct 2020 11:01:25 +0000
Message-ID: <73bd83cd579246acb1f15bb38f5dc90e@vector.com>
Accept-Language: de-DE, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.77.26]
x-g-data-mailsecurity-for-exchange-state: 0
x-g-data-mailsecurity-for-exchange-error: 0
x-g-data-mailsecurity-for-exchange-sender: 23
x-g-data-mailsecurity-for-exchange-server: e312ed88-0b29-4eb3-8405-66bbc4e212d4
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CDE3A201 smtp.mailfrom=jens.frederich@vector.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: vector.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

I would like to receive n 10 Gbps TCP or UDP streams (jumbo frames) as fast as possible and write each socket stream to a file on a fast XFS storage. How can I optimally implement this with io_uring? I want to use io_uring for network and file IO and the CPU load should keeping low. I would like to know your opinions. My first naive implementation looks like this, But I can't get more than 1Gbps through by one TCP stream:

#include <errno.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <sys/poll.h>
#include <sys/socket.h>
#include <unistd.h>

#include "liburing.h"

#define MAX_CONNECTIONS     4096
#define BACKLOG             512
#define MAX_MESSAGE_LEN     9000
#define BUFFERS_COUNT       MAX_CONNECTIONS

struct Stream_Server {
    int port;
    struct io_uring_params ring_params;
    struct io_uring ring;
    int socket_listen_fd;
    struct sockaddr_in next_client_address;
    socklen_t next_client_address_size;
    uint64_t total_cqe_count;

    struct Data_Analyzer *data_analyzer;
};

enum {
    ACCEPT,
    READ,
    WRITE,
    PROVIDE_BUFFERS,
};

typedef struct conn_info {
    __u32 fd;
    __u16 type;
    __u16 bid;
} conn_info;

char bufs[BUFFERS_COUNT][MAX_MESSAGE_LEN] = {0};
int socket_buffers_group_id = 1337;
int mdf_file_buffers_group_id = 1338;

void make_accept_sqe_and_submit(struct io_uring *ring, int fd, struct sockaddr *client_address, socklen_t *client_address_size, __u8 flags) {
    struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
    io_uring_prep_accept(sqe, fd, client_address, client_address_size, 0);
    io_uring_sqe_set_flags(sqe, flags);

    conn_info *conn_i = (conn_info *)&sqe->user_data;
    conn_i->fd = fd;
    conn_i->type = ACCEPT;
    conn_i->bid = 0;
}

void make_socket_read_sqe_and_submit(struct io_uring *ring, int fd, unsigned gid, size_t message_size, __u8 flags) {
    struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
    io_uring_prep_recv(sqe, fd, NULL, message_size, 0);
    io_uring_sqe_set_flags(sqe, flags);
    sqe->buf_group = gid;

    conn_info *conn_i = (conn_info *)&sqe->user_data;
    conn_i->fd = fd;
    conn_i->type = READ;
    conn_i->bid = 0;
}

void make_socket_write_sqe_and_submit(struct io_uring *ring, int fd, __u16 bid, size_t message_size, __u8 flags) {
    struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
    io_uring_prep_send(sqe, fd, &bufs[bid], message_size, 0);
    io_uring_sqe_set_flags(sqe, flags);

    conn_info *conn_i = (conn_info *)&sqe->user_data;
    conn_i->fd = fd;
    conn_i->type = WRITE;
    conn_i->bid = bid;
}

// @Temporary:  support n file streams
int outfd = -1;
off_t file_offset = 0;
int file_index = 0;

void make_file_write_sqe_and_submit(struct io_uring *ring, int socket_fd, __u16 bid, size_t message_size, off_t file_offset, __u8 flags) {
    struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
    io_uring_prep_write(sqe, outfd, &bufs[bid], message_size, file_offset);
    io_uring_sqe_set_flags(sqe, flags);

    conn_info *conn_i = (conn_info *)&sqe->user_data;
    conn_i->fd = socket_fd;
    conn_i->type = WRITE;
    conn_i->bid = bid;
}

void make_provide_buffers_sqe_and_submit(struct io_uring *ring, __u16 bid, unsigned gid) {
    struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
    io_uring_prep_provide_buffers(sqe, bufs[bid], MAX_MESSAGE_LEN, 1, gid, bid);

    conn_info *conn_i = (conn_info *)&sqe->user_data;
    conn_i->fd = 0;
    conn_i->type = PROVIDE_BUFFERS;
    conn_i->bid = 0;
}

struct Stream_Server *stream_server = NULL;

void main_loop_process_cqes() {
    struct io_uring_cqe *cqe;
    unsigned head;
    stream_server->total_cqe_count = 0;

    while (1) {
        uint64_t cqe_count = 0;

        io_uring_submit_and_wait(&stream_server->ring, 1);
        //io_uring_submit(&stream_server->ring);

        io_uring_for_each_cqe(&stream_server->ring, head, cqe) {
            cqe_count += 1;

            conn_info *conn_i = (conn_info *)&cqe->user_data;

            if (cqe->res == -ENOBUFS) {
                fprintf(stdout, "bufs in automatic buffer selection empty, this should not happen...\n");
                fflush(stdout);
                exit(1);
            } else if (conn_i->type == PROVIDE_BUFFERS) {
                if (cqe->res < 0) {
                    printf("cqe->res = %d\n", cqe->res);
                    exit(1);
                }
            } else if (conn_i->type == ACCEPT) {
                int sock_conn_fd = cqe->res;
                if (sock_conn_fd >= 0) {
                    outfd = open("/brick_storage/test_io_file.out", O_WRONLY | O_CREAT | O_TRUNC, 0644);
                    if (outfd < 0) {
                        perror("open outfile");
                        exit(1);
                    }

                    make_socket_read_sqe_and_submit(&stream_server->ring, sock_conn_fd, socket_buffers_group_id, MAX_MESSAGE_LEN, IOSQE_BUFFER_SELECT);
                }

                // new connected client; read data from socket and re-add accept to monitor for new connections
                make_accept_sqe_and_submit(&stream_server->ring, stream_server->socket_listen_fd, (struct sockaddr *)&stream_server->next_client_address, &stream_server->next_client_address_size, 0);
            } else if (conn_i->type == READ) {
                int bytes_read = cqe->res;
                if (cqe->res <= 0) {
                    // connection closed or error
                    shutdown(conn_i->fd, SHUT_RDWR);
                } else {
                    // bytes have been read into bufs, now add write to socket sqe
                    int bid = cqe->flags >> 16;

                    /*
                      int *data = (int *)&bufs[bid];
                      int *count = (int *) data;
                      int *id = (int *) data + 1;
                      printf("read cqe: bid %d, fd %d, count %d, id %d, bytes_read %d\n", bid, conn_i->fd, *count, *id, bytes_read);
                    */

                    file_index += 1;
                    file_offset += bytes_read;
                    make_file_write_sqe_and_submit(&stream_server->ring, conn_i->fd, bid, bytes_read, file_offset, 0);
                }
            } else if (conn_i->type == WRITE) {
                // write has been completed, first re-add the buffer
                make_provide_buffers_sqe_and_submit(&stream_server->ring, conn_i->bid, socket_buffers_group_id);

                // @Speed: Too late? What's the optimal way to keep receiving socket data as fast as possible?
                make_socket_read_sqe_and_submit(&stream_server->ring, conn_i->fd, socket_buffers_group_id, MAX_MESSAGE_LEN, IOSQE_BUFFER_SELECT);
            }
        }

        io_uring_cq_advance(&stream_server->ring, cqe_count);
        stream_server->total_cqe_count += cqe_count;
    }
}

int stream_server_proc(struct Stream_Server *_stream_server) {
    stream_server = _stream_server;
    stream_server->next_client_address_size = sizeof(stream_server->next_client_address);

    struct sockaddr_in serv_addr = { 0 };

    stream_server->socket_listen_fd = socket(AF_INET, SOCK_STREAM /* | SOCK_NONBLOCK */, 0);
    const int val = 1;
    setsockopt(stream_server->socket_listen_fd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(stream_server->port);
    serv_addr.sin_addr.s_addr = INADDR_ANY;

    if (bind(stream_server->socket_listen_fd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("Error binding socket...\n");
        exit(1);
    }
    if (listen(stream_server->socket_listen_fd, BACKLOG) < 0) {
        perror("Error listening on socket...\n");
        exit(1);
    }
    printf("listening for connections on port: %d\n", stream_server->port);

    memset(&stream_server->ring_params, 0, sizeof(stream_server->ring_params));

    if (io_uring_queue_init_params(2048, &stream_server->ring, &stream_server->ring_params) < 0) {
        perror("io_uring_init_failed...\n");
        exit(1);
    }

    struct io_uring_probe *probe;
    probe = io_uring_get_probe_ring(&stream_server->ring);
    if (!probe || !io_uring_opcode_supported(probe, IORING_OP_PROVIDE_BUFFERS)) {
        printf("Buffer select not supported, skipping...\n");
        exit(0);
    }
    free(probe);

    // first time, register buffers for buffer selection
    {
        struct io_uring_sqe *sqe;
        struct io_uring_cqe *cqe;

        sqe = io_uring_get_sqe(&stream_server->ring);
        io_uring_prep_provide_buffers(sqe, bufs, MAX_MESSAGE_LEN, BUFFERS_COUNT, socket_buffers_group_id, 0);

        io_uring_submit(&stream_server->ring);
        io_uring_wait_cqe(&stream_server->ring, &cqe);
        if (cqe->res < 0) {
            printf("cqe->res = %d\n", cqe->res);
            exit(1);
        }
        io_uring_cqe_seen(&stream_server->ring, cqe);
    }

    // add first accept SQE to monitor for new incoming connections
    make_accept_sqe_and_submit(&stream_server->ring, stream_server->socket_listen_fd, (struct sockaddr *)&stream_server->next_client_address, &stream_server->next_client_address_size, 0);

    main_loop_process_cqes();
}

Grüße / Regards
Jens Frederich

