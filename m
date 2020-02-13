Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B43FB15C109
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2020 16:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBMPIN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Feb 2020 10:08:13 -0500
Received: from mail-lj1-f175.google.com ([209.85.208.175]:33575 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbgBMPIN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Feb 2020 10:08:13 -0500
Received: by mail-lj1-f175.google.com with SMTP id y6so7003382lji.0
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2020 07:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sERHr2/Up3vmok5oE9m78EPT9j+qjhaMneIVOseolQk=;
        b=TZL5c2yTj/kzbJz9/6wc6vGHI1m2PpBp/PYzXPoNHSI1tutS/9BdMayAGMD9lQQ/QL
         ojeCurgF2H8Po7hGr3ZKRqbhakTYCjkKDGoAxchc1FexgBLGUykmgxKIdSltDhzmjeE4
         AxK3E64I10CbDNw4vivLZTS6DyGAQYHrclEr4OjX6iT4Jvfc0+lTMNiR811wfb+qd7Mg
         yUA88KqKcWzJOuNq5/uFNgttsX63KBS+m2JNr25ctL5uX7VAP9eOgWFIgLgVVealeV/Q
         VYRANSn41pwFoNpLiNSE8ycVJ+6o3Bj6wwnONGoPCvZqBxQ1vqTBjFvBBfFU8jqhgreQ
         Fn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sERHr2/Up3vmok5oE9m78EPT9j+qjhaMneIVOseolQk=;
        b=Khghd1qlhFFEaC7TnUV2E/FQBUO6p3lSwNLPKwm5HPo5ovFIdcH35+JEYxRNliHqXM
         6bu0zEnw/DIKVg+l1vii6DtmGznw7Gx838DzDPKsTqgxsN+6JyeS8Zh8C5uelV40/tlL
         T2JWyFJ4Du+B1wtVTVZfyqA1vDGc67w7VbsZG1OJKBUQIHKVfv/avosaa8pnfa8PTKdW
         lQR54Kxcj+zgicbPwtPe6MvWujnVgQ/FEZ/2jBJDacwEJqKDj8+CvUez+ss90+vpORay
         /3IMC7zfmbrDp6/OCXsI/0idf5pvyBXbcv8jj4vBU6v8tgEFiLYhd+KhaBt0q8lBhgRN
         BYjw==
X-Gm-Message-State: APjAAAXt6vZlEHNFiw/9MlYV1nuADWwfDaJprIne5HhaI2SNwXDTlkwa
        SptnPFghbZyiV0frGyY0wQdUIsnU
X-Google-Smtp-Source: APXvYqwAWEwQGwMaBGxTDG+ajG8N732M5RlOFAOKFjAG/WNBsm8ZjoSJBNpHaBWl+KYqHWGCnLh/mQ==
X-Received: by 2002:a05:651c:120d:: with SMTP id i13mr11353332lja.173.1581606487846;
        Thu, 13 Feb 2020 07:08:07 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id m3sm1403678lfl.97.2020.02.13.07.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 07:08:07 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
To:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
Date:   Thu, 13 Feb 2020 18:08:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/13/2020 3:33 AM, Carter Li 李通洲 wrote:
> Thanks for your reply.
> 
> You are right the nop isn't really a good test case. But I actually
> found this issue when benchmarking my echo server, which didn't use
> NOP of course.

If there are no hidden subtle issues in io_uring, your benchmark or the
used pattern itself, it's probably because of overhead on async punting
(copying iovecs, several extra switches, refcounts, grabbing mm/fs/etc,
io-wq itself).

I was going to tune async/punting stuff anyway, so I'll look into this.
And of course, there is always a good chance Jens have some bright insights

BTW, what's benefit of doing poll(fd)->read(fd), but not directly read()?

> Test case attached below. Use rust_echo_bench for benchmarking.
> https://github.com/haraldh/rust_echo_bench
> 
> 
> $ gcc link_recv.c -o link_recv -luring -O3 -DUSE_LINK=0
> $ ./link_recv 12345
> $ cargo run --release # On another console
> Benchmarking: 127.0.0.1:12345
> 50 clients, running 512 bytes, 60 sec.
> 
> Speed: 168264 request/sec, 168264 response/sec
> Requests: 10095846
> Responses: 10095844
> 
> $ gcc link_recv.c -o link_recv -luring -O3 -DUSE_LINK=1
> $ ./link_recv 12345
> $ cargo run --release # On another console
> Benchmarking: 127.0.0.1:12345
> 50 clients, running 512 bytes, 60 sec.
> 
> Speed: 112666 request/sec, 112666 response/sec
> Requests: 6760009
> Responses: 6759975
> 
> 
> I think `POLL_ADD(POLLIN)-RECV` and `POLL_ADD(POLLOUT)-SEND` are common use cases for networking ( for some reason a short read for SEND is not considered an error, `RECV-SEND` cannot be used in a link chain ). RECV/SEND won't block after polled. I expect better performance for fewer io_uring_enter syscalls. Could you please have a check with it?
> 
> Another more complex test case `POLL_ADD-READ_FIXED-WRITE_FIXED` I have posted on Github, which currently results in freeze.
> 
> https://github.com/axboe/liburing/issues/71
> 
> Carter
> 
> ---
> 
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> 
> #include <sys/socket.h>
> #include <sys/poll.h>
> #include <netinet/in.h>
> 
> #include <liburing.h>
> 
> #define BACKLOG 128
> #define MAX_MESSAGE_LEN 1024
> #define MAX_CONNECTIONS 1024
> #ifndef USE_LINK
> #   define USE_LINK 0
> #endif
> 
> enum { ACCEPT, POLL, READ, WRITE };
> 
> struct conn_info {
>     __u32 fd;
>     __u32 type;
> };
> 
> typedef char buf_type[MAX_CONNECTIONS][MAX_MESSAGE_LEN];
> 
> static struct io_uring ring;
> static unsigned cqe_count = 0;
> 
> int init_socket(int portno) {
>     int sock_listen_fd = socket(AF_INET, SOCK_STREAM, 0);
>     if (sock_listen_fd < 0) {
>         perror("socket");
>         return -1;
>     }
> 
>     struct sockaddr_in server_addr = {
>         .sin_family = AF_INET,
>         .sin_port = htons(portno),
>         .sin_addr = {
>             .s_addr = INADDR_ANY,
>         },
>     };
> 
>     if (bind(sock_listen_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
>         perror("bind");
>         return -1;
>     }
> 
>     if (listen(sock_listen_fd, BACKLOG) < 0) {
>         perror("listen");
>         return -1;
>     }
> 
>     return sock_listen_fd;
> }
> 
> static struct io_uring_sqe* get_sqe_safe() {
>     struct io_uring_sqe *sqe = io_uring_get_sqe(&ring);
>     if (__builtin_expect(!!sqe, 1)) {
>         return sqe;
>     } else {
>         io_uring_cq_advance(&ring, cqe_count);
>         cqe_count = 0;
>         io_uring_submit(&ring);
>         return io_uring_get_sqe(&ring);
>     }
> }
> 
> static void add_accept(int fd, struct sockaddr *client_addr, socklen_t *client_len) {
>     struct io_uring_sqe *sqe = get_sqe_safe();
>     struct conn_info conn_i = {
>         .fd = fd,
>         .type = ACCEPT,
>     };
> 
>     io_uring_prep_accept(sqe, fd, client_addr, client_len, 0);
>     memcpy(&sqe->user_data, &conn_i, sizeof(conn_i));
> }
> 
> static void add_poll(int fd, int poll_mask, unsigned flags) {
>     struct io_uring_sqe *sqe = get_sqe_safe();
>     struct conn_info conn_i = {
>         .fd = fd,
>         .type = POLL,
>     };
> 
>     io_uring_prep_poll_add(sqe, fd, poll_mask);
>     io_uring_sqe_set_flags(sqe, flags);
>     memcpy(&sqe->user_data, &conn_i, sizeof(conn_i));
> }
> 
> static void add_socket_read(int fd, size_t size, buf_type *bufs) {
>     struct io_uring_sqe *sqe = get_sqe_safe();
>     struct conn_info conn_i = {
>         .fd = fd,
>         .type = READ,
>     };
> 
>     io_uring_prep_recv(sqe, fd, (*bufs)[fd], size, MSG_NOSIGNAL);
>     memcpy(&sqe->user_data, &conn_i, sizeof(conn_i));
> }
> 
> static void add_socket_write(int fd, size_t size, buf_type *bufs, unsigned flags) {
>     struct io_uring_sqe *sqe = get_sqe_safe();
>     struct conn_info conn_i = {
>         .fd = fd,
>         .type = WRITE,
>     };
> 
>     io_uring_prep_send(sqe, fd, (*bufs)[fd], size, MSG_NOSIGNAL);
>     io_uring_sqe_set_flags(sqe, flags);
>     memcpy(&sqe->user_data, &conn_i, sizeof(conn_i));
> }
> 
> int main(int argc, char *argv[]) {
>     if (argc < 2) {
>         fprintf(stderr, "Please give a port number: %s [port]\n", argv[0]);
>         return 1;
>     }
> 
>     int portno = strtol(argv[1], NULL, 10);
>     int sock_listen_fd = init_socket(portno);
>     if (sock_listen_fd < 0) return -1;
>     printf("io_uring echo server listening for connections on port: %d\n", portno);
> 
> 
>     int ret = io_uring_queue_init(BACKLOG, &ring, 0);
>     if (ret < 0) {
>         fprintf(stderr, "queue_init: %s\n", strerror(-ret));
>         return -1;
>     }
> 
>     buf_type *bufs = (buf_type *)malloc(sizeof(*bufs));
> 
>     struct sockaddr_in client_addr;
>     socklen_t client_len = sizeof(client_addr);
>     add_accept(sock_listen_fd, (struct sockaddr *)&client_addr, &client_len);
> 
>     while (1) {
>         io_uring_submit_and_wait(&ring, 1);
> 
>         struct io_uring_cqe *cqe;
>         unsigned head;
> 
>         io_uring_for_each_cqe(&ring, head, cqe) {
>             ++cqe_count;
> 
>             struct conn_info conn_i;
>             memcpy(&conn_i, &cqe->user_data, sizeof(conn_i));
>             int result = cqe->res;
> 
>             switch (conn_i.type) {
>             case ACCEPT:
> #if USE_LINK
>                 add_poll(result, POLLIN, IOSQE_IO_LINK);
>                 add_socket_read(result, MAX_MESSAGE_LEN, bufs);
> #else
>                 add_poll(result, POLLIN, 0);
> #endif
>                 add_accept(sock_listen_fd, (struct sockaddr *)&client_addr, &client_len);
>                 break;
> 
> #if !USE_LINK
>             case POLL:
>                 add_socket_read(conn_i.fd, MAX_MESSAGE_LEN, bufs);
>                 break;
> #endif
> 
>             case READ:
>                 if (__builtin_expect(result <= 0, 0)) {
>                     shutdown(conn_i.fd, SHUT_RDWR);
>                 } else {
>                     add_socket_write(conn_i.fd, result, bufs, 0);
>                 }
>                 break;
> 
>             case WRITE:
> #if USE_LINK
>                 add_poll(conn_i.fd, POLLIN, IOSQE_IO_LINK);
>                 add_socket_read(conn_i.fd, MAX_MESSAGE_LEN, bufs);
> #else
>                 add_poll(conn_i.fd, POLLIN, 0);
> #endif
>                 break;
>             }
>         }
> 
>         io_uring_cq_advance(&ring, cqe_count);
>         cqe_count = 0;
>     }
> 
> 
>     close(sock_listen_fd);
>     free(bufs);
> }
> 
> 
> 
>> 2020年2月13日 上午1:11，Jens Axboe <axboe@kernel.dk> 写道：
>>
>> On 2/12/20 9:31 AM, Carter Li 李通洲 wrote:
>>> Hi everyone,
>>>
>>> IOSQE_IO_LINK seems to have very high cost, even greater then io_uring_enter syscall.
>>>
>>> Test code attached below. The program completes after getting 100000000 cqes.
>>>
>>> $ gcc test.c -luring -o test0 -g -O3 -DUSE_LINK=0
>>> $ time ./test0
>>> USE_LINK: 0, count: 100000000, submit_count: 1562500
>>> 0.99user 9.99system 0:11.02elapsed 99%CPU (0avgtext+0avgdata 1608maxresident)k
>>> 0inputs+0outputs (0major+72minor)pagefaults 0swaps
>>>
>>> $ gcc test.c -luring -o test1 -g -O3 -DUSE_LINK=1
>>> $ time ./test1
>>> USE_LINK: 1, count: 100000110, submit_count: 799584
>>> 0.83user 19.21system 0:20.90elapsed 95%CPU (0avgtext+0avgdata 1632maxresident)k
>>> 0inputs+0outputs (0major+72minor)pagefaults 0swaps
>>>
>>> As you can see, the `-DUSE_LINK=1` version emits only about half io_uring_submit calls
>>> of the other version, but takes twice as long. That makes IOSQE_IO_LINK almost useless,
>>> please have a check.
>>
>> The nop isn't really a good test case, as it doesn't contain any smarts
>> in terms of executing a link fast. So it doesn't say a whole lot outside
>> of "we could make nop links faster", which is also kind of pointless.
>>
>> "Normal" commands will work better. Where the link is really a win is if
>> the first request needs to go async to complete. For that case, the
>> next link can execute directly from that context. This saves an async
>> punt for the common case.
>>
>> -- 
>> Jens Axboe
>>
> 

-- 
Pavel Begunkov
