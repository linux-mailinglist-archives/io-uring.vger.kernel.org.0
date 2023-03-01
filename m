Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D223C6A709E
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 17:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjCAQOB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 11:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjCAQN7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 11:13:59 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8310423C66
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 08:13:57 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id h11so2065693wrm.5
        for <io-uring@vger.kernel.org>; Wed, 01 Mar 2023 08:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uHr5i057W1LM9EO6PQPpMU+CDIWhLlR30DFdy7/Zr8s=;
        b=VvmJYlSrKI/+78saX3GPIMwXfgm1Aeiqw/+krnxlVTv0DZVhByym4XaV1rTuwyc2am
         FFI1s3gbh3JjSGdizk9aQVeo0Yqt/+4zRUdAKzhe0q52aE0CUwv/j98aPcxh9iSvj1D6
         iJuxVUWz2p5jPQh2Bn6XjJeN7mS7BI6gKhZyBB3gf6wbG4HdZVEi0xQYhKTiQMiYPEVM
         O1kEtIOFTwdYQrq5OltZ58BthPinIldxPEDiglzYpNYwHKC4HK+IeUcjio9S32mc5y0G
         X+H7ScizcylyNHKURzE1eNl9jRbNGDusYtLgOtS/83tZPuoPe21cFtjJpSqb8XTU5AfX
         I88Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uHr5i057W1LM9EO6PQPpMU+CDIWhLlR30DFdy7/Zr8s=;
        b=cevasl379S1qh4cX0dL9mhl9t8qWa2SwUKUa1zRZ9IdKfnigsrU8l3lKFqQT7HBdTk
         xzkN/klb372PbdgmkMnCF/rhKK/G9fyE1IjZ9JS944rxTjOoUuQTtzxjysdcJcoh3k4W
         Y/TMVzaAHBL6bzTgglepGqjl8wIT6CpveevXBJW5VZ8Vc6L3PNpOzrLKSJjvfTt3otPF
         1XEXogHQymZXu+WT5VI9G+MP6d59gNPqx8yeplwqEyRKFNH9v9mIJFPmfTeHh2ssd2Uq
         49yIG5bxxSWRjkNUDi5of68Vxo2FARjRl7QbSYnmUYLBg9gMTej4ZzcYfAKX7ZdRKORP
         ZI0Q==
X-Gm-Message-State: AO0yUKUXJkEh825IjH2GIKOt2hgQk4SUHdFRUeLaT/KZhLHdsCot/3qW
        uDgXjOIOQqxEiu83HC00L74SPLIN2zc=
X-Google-Smtp-Source: AK7set/wEILgp7IaNOuCS+8yHioYC5qCX2e1KujRzbtylAmLVtLTyNjFacvsPU3ix9/LVqrmyfe72w==
X-Received: by 2002:a5d:5967:0:b0:2c7:17db:bf5c with SMTP id e39-20020a5d5967000000b002c717dbbf5cmr5223171wri.25.1677687235897;
        Wed, 01 Mar 2023 08:13:55 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:94bb])
        by smtp.gmail.com with ESMTPSA id s2-20020adfeb02000000b002cda9aa1dc1sm2701474wrn.111.2023.03.01.08.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 08:13:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/3] examples/send-zc: add multithreading
Date:   Wed,  1 Mar 2023 16:10:11 +0000
Message-Id: <fb2f89faceac038fce5f4f078530223964162df9.1677686850.git.asml.silence@gmail.com>
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

'-T <nr_threads>' will create the specified number of threads to test in
parallel. Each thread will have its own connection.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/Makefile        |   3 +
 examples/send-zerocopy.c | 116 ++++++++++++++++++++++++++-------------
 2 files changed, 81 insertions(+), 38 deletions(-)

diff --git a/examples/Makefile b/examples/Makefile
index e561e05..20ac53c 100644
--- a/examples/Makefile
+++ b/examples/Makefile
@@ -10,6 +10,9 @@ ifneq ($(MAKECMDGOALS),clean)
 include ../config-host.mak
 endif
 
+LDFLAGS ?=
+override LDFLAGS += -L../src/ -luring -lpthread
+
 example_srcs := \
 	io_uring-cp.c \
 	io_uring-test.c \
diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index a86106f..c0549a1 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -11,6 +11,7 @@
 #include <stdbool.h>
 #include <stdarg.h>
 #include <string.h>
+#include <pthread.h>
 
 #include <sched.h>
 #include <arpa/inet.h>
@@ -43,6 +44,16 @@
 
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
@@ -52,17 +63,21 @@ static bool cfg_fixed_buf = 1;
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
@@ -126,12 +141,13 @@ static void setup_sockaddr(int domain, const char *str_addr,
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
@@ -139,7 +155,7 @@ static void setup_sockaddr(int domain, const char *str_addr,
 	case PF_INET6:
 		memset(addr6, 0, sizeof(*addr6));
 		addr6->sin6_family = AF_INET6;
-		addr6->sin6_port = htons(cfg_port);
+		addr6->sin6_port = htons(port);
 		if (str_addr &&
 		    inet_pton(AF_INET6, str_addr, &(addr6->sin6_addr)) != 1)
 			t_error(1, 0, "ipv6 parse error: %s", str_addr);
@@ -149,21 +165,6 @@ static void setup_sockaddr(int domain, const char *str_addr,
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
@@ -179,11 +180,9 @@ static inline struct io_uring_cqe *wait_cqe_fast(struct io_uring *ring)
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
@@ -194,7 +193,14 @@ static void do_tx(int domain, int type, int protocol)
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
@@ -221,6 +227,8 @@ static void do_tx(int domain, int type, int protocol)
 	if (ret)
 		t_error(1, ret, "io_uring: buffer registration");
 
+	pthread_barrier_wait(&barrier);
+
 	tstop = gettimeofday_ms() + cfg_runtime_ms;
 	do {
 		struct io_uring_sqe *sqe;
@@ -272,8 +280,8 @@ static void do_tx(int domain, int type, int protocol)
 				compl_cqes++;
 
 			if (cqe->res >= 0) {
-				packets++;
-				bytes += cqe->res;
+				td->packets++;
+				td->bytes += cqe->res;
 			} else if (cqe->res == -ECONNREFUSED || cqe->res == -EPIPE ||
 				   cqe->res == -ECONNRESET) {
 				fprintf(stderr, "Connection failure");
@@ -290,11 +298,6 @@ out_fail:
 	if (close(fd))
 		t_error(1, errno, "close");
 
-	fprintf(stderr, "tx=%lu (MB=%lu), tx/s=%lu (MB/s=%lu)\n",
-			packets, bytes >> 20,
-			packets / (cfg_runtime_ms / 1000),
-			(bytes >> 20) / (cfg_runtime_ms / 1000));
-
 	while (compl_cqes) {
 		struct io_uring_cqe *cqe = wait_cqe_fast(&ring);
 
@@ -304,14 +307,16 @@ out_fail:
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
@@ -334,7 +339,7 @@ static void parse_opts(int argc, char **argv)
 
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:dC:")) != -1) {
+	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:dC:T:")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -378,6 +383,11 @@ static void parse_opts(int argc, char **argv)
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
 
@@ -386,7 +396,7 @@ static void parse_opts(int argc, char **argv)
 	if (cfg_payload_len > max_payload_len)
 		t_error(1, 0, "-s: payload exceeds max (%d)", max_payload_len);
 
-	setup_sockaddr(cfg_family, daddr, &cfg_dst_addr);
+	str_addr = daddr;
 
 	if (optind != argc - 1)
 		usage(argv[0]);
@@ -394,7 +404,11 @@ static void parse_opts(int argc, char **argv)
 
 int main(int argc, char **argv)
 {
+	unsigned long long packets = 0, bytes = 0;
+	struct thread_data *td;
 	const char *cfg_test;
+	void *res;
+	int i;
 
 	parse_opts(argc, argv);
 	set_cpu_affinity();
@@ -412,11 +426,37 @@ int main(int argc, char **argv)
 
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

