Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9FA6A709D
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 17:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjCAQOA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 11:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjCAQN7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 11:13:59 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C20D2CC5B
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 08:13:58 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id l1so10750171wry.12
        for <io-uring@vger.kernel.org>; Wed, 01 Mar 2023 08:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=igvNa7PyXdnplqOJFyMw8vP4ahEamqmmn2S6RC/Th3w=;
        b=KTNQqLSg4Ea9PF/hsWwzvkUDYQV37QxRUkEGzfcTPvbgakAyWm3GQ16z7a22x8gVao
         vbqwAqZp3iG4Core3oCeriZ3Erybz7Z0ewzLWocRzytcTB7nVxDj90B+OdFN1hz8mlBw
         +VtKw6GqXHEI3cVA4ppxw4xOj7eD3PA7ub0rrjON3NzNcXkPP0efnxPzK+rGqsUE5OlI
         IJVKieCtss0z8t9X/MrBiUl28FfP/Jqzq7dObfEIPjUm0WH8/sY5J+IIPNEzvimEB7QP
         pQKMmCycj1yAWkuUkPHd31EmWUlBb0Cj9fEVMwpCb3MTjrN7rKx5pJHLpK+Sguy7x5oi
         smqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=igvNa7PyXdnplqOJFyMw8vP4ahEamqmmn2S6RC/Th3w=;
        b=SpJOrH1dhDb/MbDcegLYX+KEe8rV0pecLDMBJgBE3BCLXnOSlGnLnLGg5ip3SPhJ53
         GKO58Rbew9z7o4Baq7c6AUL377qNwzOMnxgKK6hCT70lRq+YY1wHXCLdTITr+lvgVBT2
         AMaL+aHC3JDXy1NliVAruoOJqj7ZhkoitH366a3MW339JZr5y3WkUOl/Irw+FiH0urzX
         XyfIHKpoQWDJE1EhKhS3k8lYOy6IRgeUeRuTuHikkAA1Z30UDoXiOhg3308Iqg06qBFT
         5La/4sdnI6bFV1NBqzZpQuF4bYNGcRObIs5wO3h2KV2qfMbN4yasb06SgxHOQDtX1mcJ
         RupQ==
X-Gm-Message-State: AO0yUKUxoL567aBBFRJiflsfVzVmjWnRX8upwK+x00l1ujX8GnQr7dB9
        4/nA5o1na0xyeuqmQn6QvIWQKalVfSI=
X-Google-Smtp-Source: AK7set/K6d6xoNx43iNEowUwDtCBWYLCZ3z2R3z1e5+wsajCh8LInAD/Nn6SMMRlfUdmXjKAQjK3og==
X-Received: by 2002:adf:e545:0:b0:2c7:cdf:e296 with SMTP id z5-20020adfe545000000b002c70cdfe296mr5389052wrm.66.1677687236415;
        Wed, 01 Mar 2023 08:13:56 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:94bb])
        by smtp.gmail.com with ESMTPSA id s2-20020adfeb02000000b002cda9aa1dc1sm2701474wrn.111.2023.03.01.08.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 08:13:56 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 3/3] examples/send-zc: add the receive part
Date:   Wed,  1 Mar 2023 16:10:12 +0000
Message-Id: <00e887532822d4744741655532be4fbede0f18b0.1677686850.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677686850.git.asml.silence@gmail.com>
References: <cover.1677686850.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

'-R' will switch the benchmark into the server mode accepting data. For
TCP the number of threads should match the number of threads of the
client. For UDP just one thread/connection should be enough.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 146 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 143 insertions(+), 3 deletions(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index c0549a1..75e516c 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -13,6 +13,7 @@
 #include <string.h>
 #include <pthread.h>
 
+#include <poll.h>
 #include <sched.h>
 #include <arpa/inet.h>
 #include <linux/errqueue.h>
@@ -53,6 +54,7 @@ struct thread_data {
 	unsigned long long packets;
 	unsigned long long bytes;
 	struct sockaddr_storage dst_addr;
+	int fd;
 };
 
 static bool cfg_reg_ringfd = true;
@@ -63,6 +65,7 @@ static bool cfg_fixed_buf = 1;
 static bool cfg_hugetlb = 0;
 static bool cfg_defer_taskrun = 0;
 static int  cfg_cpu = -1;
+static bool cfg_rx = 0;
 static unsigned  cfg_nr_threads = 1;
 
 static int  cfg_family		= PF_UNSPEC;
@@ -165,6 +168,135 @@ static void setup_sockaddr(int domain, const char *str_addr,
 	}
 }
 
+static int do_poll(int fd, int events)
+{
+	struct pollfd pfd;
+	int ret;
+
+	pfd.events = events;
+	pfd.revents = 0;
+	pfd.fd = fd;
+
+	ret = poll(&pfd, 1, -1);
+	if (ret == -1)
+		t_error(1, errno, "poll");
+
+	return ret && (pfd.revents & events);
+}
+
+/* Flush all outstanding bytes for the tcp receive queue */
+static int do_flush_tcp(struct thread_data *td, int fd)
+{
+	int ret;
+
+	/* MSG_TRUNC flushes up to len bytes */
+	ret = recv(fd, NULL, 1 << 21, MSG_TRUNC | MSG_DONTWAIT);
+	if (ret == -1 && errno == EAGAIN)
+		return 0;
+	if (ret == -1)
+		t_error(1, errno, "flush");
+	if (!ret)
+		return 1;
+
+	td->packets++;
+	td->bytes += ret;
+	return 0;
+}
+
+/* Flush all outstanding datagrams. Verify first few bytes of each. */
+static int do_flush_datagram(struct thread_data *td, int fd, int type)
+{
+	int ret, off = 0;
+	char buf[64];
+
+	/* MSG_TRUNC will return full datagram length */
+	ret = recv(fd, buf, sizeof(buf), MSG_DONTWAIT | MSG_TRUNC);
+	if (ret == -1 && errno == EAGAIN)
+		return 0;
+
+	if (ret == -1)
+		t_error(1, errno, "recv");
+	if (ret != cfg_payload_len)
+		t_error(1, 0, "recv: ret=%u != %u", ret, cfg_payload_len);
+	if (ret > sizeof(buf) - off)
+		ret = sizeof(buf) - off;
+	if (memcmp(buf + off, payload, ret))
+		t_error(1, 0, "recv: data mismatch");
+
+	td->packets++;
+	td->bytes += cfg_payload_len;
+	return 0;
+}
+
+static void do_setup_rx(int domain, int type, int protocol)
+{
+	struct sockaddr_storage addr = {};
+	struct thread_data *td;
+	int listen_fd, fd, i;
+
+	fd = socket(domain, type, protocol);
+	if (fd == -1)
+		t_error(1, errno, "socket r");
+
+	do_setsockopt(fd, SOL_SOCKET, SO_RCVBUF, 1 << 21);
+	do_setsockopt(fd, SOL_SOCKET, SO_RCVLOWAT, 1 << 16);
+	do_setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, 1);
+
+	setup_sockaddr(cfg_family, str_addr, &addr);
+
+	if (bind(fd, (void *)&addr, cfg_alen))
+		t_error(1, errno, "bind");
+
+	if (type != SOCK_STREAM) {
+		if (cfg_nr_threads != 1)
+			t_error(1, 0, "udp rx cant multithread");
+		threads[0].fd = fd;
+		return;
+	}
+
+	listen_fd = fd;
+	if (listen(listen_fd, cfg_nr_threads))
+		t_error(1, errno, "listen");
+
+	for (i = 0; i < cfg_nr_threads; i++) {
+		td = &threads[i];
+
+		fd = accept(listen_fd, NULL, NULL);
+		if (fd == -1)
+			t_error(1, errno, "accept");
+		td->fd = fd;
+	}
+
+	if (close(listen_fd))
+		t_error(1, errno, "close listen sock");
+}
+
+static void *do_rx(void *arg)
+{
+	struct thread_data *td = arg;
+	const int cfg_receiver_wait_ms = 400;
+	uint64_t tstop;
+	int ret, fd = td->fd;
+
+	tstop = gettimeofday_ms() + cfg_runtime_ms + cfg_receiver_wait_ms;
+	do {
+		if (cfg_type == SOCK_STREAM)
+			ret = do_flush_tcp(td, fd);
+		else
+			ret = do_flush_datagram(td, fd, cfg_type);
+
+		if (ret)
+			break;
+
+		do_poll(fd, POLLIN);
+	} while (gettimeofday_ms() < tstop);
+
+	if (close(fd))
+		t_error(1, errno, "close");
+	pthread_exit(&td->ret);
+	return NULL;
+}
+
 static inline struct io_uring_cqe *wait_cqe_fast(struct io_uring *ring)
 {
 	struct io_uring_cqe *cqe;
@@ -284,7 +416,7 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 				td->bytes += cqe->res;
 			} else if (cqe->res == -ECONNREFUSED || cqe->res == -EPIPE ||
 				   cqe->res == -ECONNRESET) {
-				fprintf(stderr, "Connection failure");
+				fprintf(stderr, "Connection failure\n");
 				goto out_fail;
 			} else if (cqe->res != -EAGAIN) {
 				t_error(1, cqe->res, "send failed");
@@ -317,6 +449,7 @@ static void *do_test(void *arg)
 
 	do_tx(td, cfg_family, cfg_type, protocol);
 	pthread_exit(&td->ret);
+	return NULL;
 }
 
 static void usage(const char *filepath)
@@ -339,7 +472,7 @@ static void parse_opts(int argc, char **argv)
 
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:dC:T:")) != -1) {
+	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:dC:T:R")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -388,6 +521,9 @@ static void parse_opts(int argc, char **argv)
 			if (cfg_nr_threads > MAX_THREADS)
 				t_error(1, 0, "too many threads\n");
 			break;
+		case 'R':
+			cfg_rx = 1;
+			break;
 		}
 	}
 
@@ -442,8 +578,12 @@ int main(int argc, char **argv)
 		td->idx = i;
 	}
 
+	if (cfg_rx)
+		do_setup_rx(cfg_family, cfg_type, 0);
+
 	for (i = 0; i < cfg_nr_threads; i++)
-		pthread_create(&threads[i].thread, NULL, do_test, td);
+		pthread_create(&threads[i].thread, NULL,
+				!cfg_rx ? do_test : do_rx, &threads[i]);
 
 	for (i = 0; i < cfg_nr_threads; i++) {
 		td = &threads[i];
-- 
2.39.1

