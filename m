Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E886AAE43
	for <lists+io-uring@lfdr.de>; Sun,  5 Mar 2023 06:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjCEFOT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Mar 2023 00:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjCEFOS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Mar 2023 00:14:18 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF87BDE3
        for <io-uring@vger.kernel.org>; Sat,  4 Mar 2023 21:14:16 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id f11so5775926wrv.8
        for <io-uring@vger.kernel.org>; Sat, 04 Mar 2023 21:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=47e0uDe5zg00iu3JDIRt440rjWoEC6R3P4KvRu4wJ5Y=;
        b=Rzdr5V+pwjDZipo1G+sXsVAJhYmbtmJ6UGQ62Hdvo+UL4StLRqAs1rNcOoR8axkSmv
         6D23kVptfERbzCWheVoUf3Px3gkt0cg7DIi78BPvZC7uoEUoOq2sfmtH8dwjIRVOubFL
         hXR4hinHWYUa1G3Xg7YIef0xg422PyB5rZiiI1Qn+n67sdlWM/rCfkN78CMscDAj1Iwm
         PMHCL/aD5e60M/GqxPhmm4T0MlQclBesdPYxVVo70qjSZPAv6YEYJzt9KHcVckAS2OX6
         R7YABSc2BuiMI977wzx3fLHyYZFnnAldw96fwHpk/XzGUw5jhsDPtLB0wNO1AVsK0Lk3
         0CXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=47e0uDe5zg00iu3JDIRt440rjWoEC6R3P4KvRu4wJ5Y=;
        b=hjHjx0mSlpM26KgLPfKlAJcilrQK/Up0TwOLzVuutqMcJE4xdjFPFITN3dWbXt4fmb
         bon4qRItQhRU1rNbwJoS1xGxHrZ/2dO+Mr2gACYnMjjK46PgOetwfrACJR1B+3ut2m0W
         wooZvaxOCU7e3PbBbBUtCi+N+n6wFyZr5t0VJ9oj2p36hmecBI9fxddqhGI8chMCRJy3
         WE+tXAF02UgSywoNOCgY7c+LM9ZLOzsLHzaDmYRKD+/RkEOrDJN1mTunczan00iPwyXC
         Z8peRwqeGvRQjU3kQ7zo8p3gBNahisOfPQAYXj63WG2gQLkd36XpZEsng7ZcTQqBi+fn
         0Vxg==
X-Gm-Message-State: AO0yUKU6MksgN+Zaf5YZO+T+WAQi9EnSOc8xiNcNoT5ZHjhufS+ePOEq
        rMz/P2qGhOwNwQsbNuP8OGkNoqEiY2Q=
X-Google-Smtp-Source: AK7set9LlIQ2wd09IXThCArOllVJbFseI8YBqfXucwlHmXuc9nCQP3oyfka5PuElObmqMGhISVY4Ug==
X-Received: by 2002:adf:f584:0:b0:2c9:b3a9:b080 with SMTP id f4-20020adff584000000b002c9b3a9b080mr4944837wro.16.1677993254992;
        Sat, 04 Mar 2023 21:14:14 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.92.184.threembb.co.uk. [94.196.92.184])
        by smtp.gmail.com with ESMTPSA id j4-20020adfff84000000b002cda9aa1dc1sm6524348wrr.111.2023.03.04.21.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 21:14:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 3/5] examples/send-zc: add multithreading
Date:   Sun,  5 Mar 2023 05:13:06 +0000
Message-Id: <d5077c17a54e7f92be28ef499c83d99f4d3eb175.1677993039.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677993039.git.asml.silence@gmail.com>
References: <cover.1677993039.git.asml.silence@gmail.com>
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

'-T <nr_threads>' will create the specified number of threads to test in
parallel. Each thread will have its own connection.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/Makefile        |   3 +
 examples/send-zerocopy.c | 116 ++++++++++++++++++++++++++-------------
 2 files changed, 81 insertions(+), 38 deletions(-)

diff --git a/examples/Makefile b/examples/Makefile
index ef79e42..ce33af9 100644
--- a/examples/Makefile
+++ b/examples/Makefile
@@ -10,6 +10,9 @@ ifneq ($(MAKECMDGOALS),clean)
 include ../config-host.mak
 endif
 
+LDFLAGS ?=
+override LDFLAGS += -L../src/ -luring -lpthread
+
 example_srcs := \
 	io_uring-close-test.c \
 	io_uring-cp.c \
diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index baa2bdf..683a965 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -11,6 +11,7 @@
 #include <stdbool.h>
 #include <stdarg.h>
 #include <string.h>
+#include <pthread.h>
 
 #include <sched.h>
 #include <arpa/inet.h>
@@ -42,6 +43,16 @@
 
 #define ZC_TAG 0xfffffffULL
 #define MAX_SUBMIT_NR 512
+#define MAX_THREADS 100
+
+struct thread_data {
+	pthread_t thread;
+	void *ret;
+	int idx;
+	unsigned long long packets;
+	unsigned long long bytes;
+	struct sockaddr_storage dst_addr;
+};
 
 static bool cfg_reg_ringfd = true;
 static bool cfg_fixed_files = 1;
@@ -51,17 +62,21 @@ static bool cfg_fixed_buf = 1;
 static bool cfg_hugetlb = 0;
 static bool cfg_defer_taskrun = 0;
 static int  cfg_cpu = -1;
+static unsigned  cfg_nr_threads = 1;
 
 static int  cfg_family		= PF_UNSPEC;
+static int  cfg_type		= 0;
 static int  cfg_payload_len;
 static int  cfg_port		= 8000;
 static int  cfg_runtime_ms	= 4200;
 
 static socklen_t cfg_alen;
-static struct sockaddr_storage cfg_dst_addr;
+static char *str_addr = NULL;
 
 static char payload_buf[IP_MAXPACKET] __attribute__((aligned(4096)));
 static char *payload;
+static struct thread_data threads[MAX_THREADS];
+static pthread_barrier_t barrier;
 
 /*
  * Implementation of error(3), prints an error message and exits.
@@ -125,12 +140,13 @@ static void setup_sockaddr(int domain, const char *str_addr,
 {
 	struct sockaddr_in6 *addr6 = (void *) sockaddr;
 	struct sockaddr_in *addr4 = (void *) sockaddr;
+	int port = cfg_port;
 
 	switch (domain) {
 	case PF_INET:
 		memset(addr4, 0, sizeof(*addr4));
 		addr4->sin_family = AF_INET;
-		addr4->sin_port = htons(cfg_port);
+		addr4->sin_port = htons(port);
 		if (str_addr &&
 		    inet_pton(AF_INET, str_addr, &(addr4->sin_addr)) != 1)
 			t_error(1, 0, "ipv4 parse error: %s", str_addr);
@@ -138,7 +154,7 @@ static void setup_sockaddr(int domain, const char *str_addr,
 	case PF_INET6:
 		memset(addr6, 0, sizeof(*addr6));
 		addr6->sin6_family = AF_INET6;
-		addr6->sin6_port = htons(cfg_port);
+		addr6->sin6_port = htons(port);
 		if (str_addr &&
 		    inet_pton(AF_INET6, str_addr, &(addr6->sin6_addr)) != 1)
 			t_error(1, 0, "ipv6 parse error: %s", str_addr);
@@ -148,21 +164,6 @@ static void setup_sockaddr(int domain, const char *str_addr,
 	}
 }
 
-static int do_setup_tx(int domain, int type, int protocol)
-{
-	int fd;
-
-	fd = socket(domain, type, protocol);
-	if (fd == -1)
-		t_error(1, errno, "socket t");
-
-	do_setsockopt(fd, SOL_SOCKET, SO_SNDBUF, 1 << 21);
-
-	if (connect(fd, (void *) &cfg_dst_addr, cfg_alen))
-		t_error(1, errno, "connect");
-	return fd;
-}
-
 static inline struct io_uring_cqe *wait_cqe_fast(struct io_uring *ring)
 {
 	struct io_uring_cqe *cqe;
@@ -178,11 +179,9 @@ static inline struct io_uring_cqe *wait_cqe_fast(struct io_uring *ring)
 	return cqe;
 }
 
-static void do_tx(int domain, int type, int protocol)
+static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 {
 	const int notif_slack = 128;
-	unsigned long packets = 0;
-	unsigned long bytes = 0;
 	struct io_uring ring;
 	struct iovec iov;
 	uint64_t tstop;
@@ -193,7 +192,14 @@ static void do_tx(int domain, int type, int protocol)
 	if (cfg_defer_taskrun)
 		ring_flags |= IORING_SETUP_DEFER_TASKRUN;
 
-	fd = do_setup_tx(domain, type, protocol);
+	fd = socket(domain, type, protocol);
+	if (fd == -1)
+		t_error(1, errno, "socket t");
+
+	do_setsockopt(fd, SOL_SOCKET, SO_SNDBUF, 1 << 21);
+
+	if (connect(fd, (void *)&td->dst_addr, cfg_alen))
+		t_error(1, errno, "connect, idx %i", td->idx);
 
 	ret = io_uring_queue_init(512, &ring, ring_flags);
 	if (ret)
@@ -220,6 +226,8 @@ static void do_tx(int domain, int type, int protocol)
 	if (ret)
 		t_error(1, ret, "io_uring: buffer registration");
 
+	pthread_barrier_wait(&barrier);
+
 	tstop = gettimeofday_ms() + cfg_runtime_ms;
 	do {
 		struct io_uring_sqe *sqe;
@@ -271,8 +279,8 @@ static void do_tx(int domain, int type, int protocol)
 				compl_cqes++;
 
 			if (cqe->res >= 0) {
-				packets++;
-				bytes += cqe->res;
+				td->packets++;
+				td->bytes += cqe->res;
 			} else if (cqe->res == -ECONNREFUSED || cqe->res == -EPIPE ||
 				   cqe->res == -ECONNRESET) {
 				fprintf(stderr, "Connection failure");
@@ -289,11 +297,6 @@ out_fail:
 	if (close(fd))
 		t_error(1, errno, "close");
 
-	fprintf(stderr, "tx=%lu (MB=%lu), tx/s=%lu (MB/s=%lu)\n",
-			packets, bytes >> 20,
-			packets / (cfg_runtime_ms / 1000),
-			(bytes >> 20) / (cfg_runtime_ms / 1000));
-
 	while (compl_cqes) {
 		struct io_uring_cqe *cqe = wait_cqe_fast(&ring);
 
@@ -303,14 +306,16 @@ out_fail:
 	io_uring_queue_exit(&ring);
 }
 
-static void do_test(int domain, int type, int protocol)
+
+static void *do_test(void *arg)
 {
-	int i;
+	struct thread_data *td = arg;
+	int protocol = 0;
 
-	for (i = 0; i < IP_MAXPACKET; i++)
-		payload[i] = 'a' + (i % 26);
+	setup_sockaddr(cfg_family, str_addr, &td->dst_addr);
 
-	do_tx(domain, type, protocol);
+	do_tx(td, cfg_family, cfg_type, protocol);
+	pthread_exit(&td->ret);
 }
 
 static void usage(const char *filepath)
@@ -333,7 +338,7 @@ static void parse_opts(int argc, char **argv)
 
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:dC:")) != -1) {
+	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:dC:T:")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -377,6 +382,11 @@ static void parse_opts(int argc, char **argv)
 		case 'C':
 			cfg_cpu = strtol(optarg, NULL, 0);
 			break;
+		case 'T':
+			cfg_nr_threads = strtol(optarg, NULL, 0);
+			if (cfg_nr_threads > MAX_THREADS)
+				t_error(1, 0, "too many threads\n");
+			break;
 		}
 	}
 
@@ -385,7 +395,7 @@ static void parse_opts(int argc, char **argv)
 	if (cfg_payload_len > max_payload_len)
 		t_error(1, 0, "-s: payload exceeds max (%d)", max_payload_len);
 
-	setup_sockaddr(cfg_family, daddr, &cfg_dst_addr);
+	str_addr = daddr;
 
 	if (optind != argc - 1)
 		usage(argv[0]);
@@ -393,7 +403,11 @@ static void parse_opts(int argc, char **argv)
 
 int main(int argc, char **argv)
 {
+	unsigned long long packets = 0, bytes = 0;
+	struct thread_data *td;
 	const char *cfg_test;
+	void *res;
+	int i;
 
 	parse_opts(argc, argv);
 	set_cpu_affinity();
@@ -411,11 +425,37 @@ int main(int argc, char **argv)
 
 	cfg_test = argv[argc - 1];
 	if (!strcmp(cfg_test, "tcp"))
-		do_test(cfg_family, SOCK_STREAM, 0);
+		cfg_type = SOCK_STREAM;
 	else if (!strcmp(cfg_test, "udp"))
-		do_test(cfg_family, SOCK_DGRAM, 0);
+		cfg_type = SOCK_DGRAM;
 	else
 		t_error(1, 0, "unknown cfg_test %s", cfg_test);
 
+	pthread_barrier_init(&barrier, NULL, cfg_nr_threads);
+
+	for (i = 0; i < IP_MAXPACKET; i++)
+		payload[i] = 'a' + (i % 26);
+
+	for (i = 0; i < cfg_nr_threads; i++) {
+		td = &threads[i];
+		td->idx = i;
+	}
+
+	for (i = 0; i < cfg_nr_threads; i++)
+		pthread_create(&threads[i].thread, NULL, do_test, td);
+
+	for (i = 0; i < cfg_nr_threads; i++) {
+		td = &threads[i];
+		pthread_join(td->thread, &res);
+		packets += td->packets;
+		bytes += td->bytes;
+	}
+
+	fprintf(stderr, "tx=%llu (MB=%llu), tx/s=%llu (MB/s=%llu)\n",
+		packets, bytes >> 20,
+		packets / (cfg_runtime_ms / 1000),
+		(bytes >> 20) / (cfg_runtime_ms / 1000));
+
+	pthread_barrier_destroy(&barrier);
 	return 0;
 }
-- 
2.39.1

