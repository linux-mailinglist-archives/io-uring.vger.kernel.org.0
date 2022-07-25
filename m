Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A21857FCED
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 12:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbiGYKFU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 06:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbiGYKFS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 06:05:18 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D345A45A
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 03:05:16 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id q18so4790913wrx.8
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 03:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=34BcaEYmUF9t/LSLnoYhFjl1ucL8WFEzEcejfi1X7s4=;
        b=n7p+9cTL5JwTaq7Lmv9Yv5Rl5u8DDwqUZyv/m5zVtftktQHKf8UViHREkVIoN31m11
         UFHVohhiCQumRjUub3vNXowkrL/iJVZyi0fCz4QP778nSXo8i0YxhxoRAqgcXSx8Euii
         J2RJRh15omb/L7rs12IsTdTZD1gozHls+2zOW4iKh8rg5OB1J8iDI78CpeweMizqRWK3
         yPswSsjmW69TaK9WfrQNjX876IvAKntrlimj9UqPx52YOGm+tIVJIbpFFl+Bp0NEK5ui
         a6XcwxWVKduxg7zbaSa5d4M9n/kaM/u0F45l8k/y/GEQWqXPbAREu2UUVoYekBj1YdYn
         G2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=34BcaEYmUF9t/LSLnoYhFjl1ucL8WFEzEcejfi1X7s4=;
        b=bsMXZER5BASdIxyQy4ir1WOyVblG766R7y4QGWvpcS/q4PQRbxFvqBAIVPA9ftiKYL
         bGjYo4JldkfS0X4vbwDEJJl5bqCezYydQMT/6tjuER602m/lUq2j9a1Sf+JKMlMQ0hB+
         HmOPrguAIPCRO1v/RGSVmT8btwpcZZBBBkrW3bXdUlCQd6BYbSW1K58jdg9gDeS2VXQx
         iBaZ+sde3DfZWKnjnm5+0WrtmpIRNZeUUEAJ072/pMtpPi9WE5S/tad4wbnn9CQcqBU6
         bTB/LShRYmNfxuYWCf84PV0X6zr2z0+54QbWXiYvNzgB8qt900ZaukJsA0mwqd6Kp6g8
         R8tQ==
X-Gm-Message-State: AJIora+mNmv3uYuQg4Sx6VrbT+iuidDNGSHyle7ia+b5SC2REfASNfUs
        PbGZFDaElrSEP781ClBdxsb/ZHJUf/BBIQ==
X-Google-Smtp-Source: AGRyM1ubmN5AV1ZRjjCGzVuWGuqGeHzvErRX63eXwIFNS4FtwtggGwrUQDFq8HBTaNI+z+RJeDRPIw==
X-Received: by 2002:a5d:668b:0:b0:21e:94b4:f070 with SMTP id l11-20020a5d668b000000b0021e94b4f070mr615565wru.253.1658743514155;
        Mon, 25 Jul 2022 03:05:14 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:9f35])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003a32251c3f9sm20553959wms.5.2022.07.25.03.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 03:05:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 4/4] examples: add a zerocopy send example
Date:   Mon, 25 Jul 2022 11:03:57 +0100
Message-Id: <0c3a98b6486c19674856d3396085d0b509bf2736.1658743360.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658743360.git.asml.silence@gmail.com>
References: <cover.1658743360.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/Makefile        |   3 +-
 examples/send-zerocopy.c | 366 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 368 insertions(+), 1 deletion(-)
 create mode 100644 examples/send-zerocopy.c

diff --git a/examples/Makefile b/examples/Makefile
index 8e7067f..1997a31 100644
--- a/examples/Makefile
+++ b/examples/Makefile
@@ -14,7 +14,8 @@ example_srcs := \
 	io_uring-cp.c \
 	io_uring-test.c \
 	link-cp.c \
-	poll-bench.c
+	poll-bench.c \
+	send-zerocopy.c
 
 all_targets :=
 
diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
new file mode 100644
index 0000000..e42aa71
--- /dev/null
+++ b/examples/send-zerocopy.c
@@ -0,0 +1,366 @@
+/* SPDX-License-Identifier: MIT */
+/* based on linux-kernel/tools/testing/selftests/net/msg_zerocopy.c */
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <assert.h>
+#include <errno.h>
+#include <error.h>
+#include <limits.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdbool.h>
+#include <string.h>
+
+#include <arpa/inet.h>
+#include <linux/errqueue.h>
+#include <linux/if_packet.h>
+#include <linux/ipv6.h>
+#include <linux/socket.h>
+#include <linux/sockios.h>
+#include <net/ethernet.h>
+#include <net/if.h>
+#include <netinet/ip.h>
+#include <netinet/in.h>
+#include <netinet/ip6.h>
+#include <netinet/tcp.h>
+#include <netinet/udp.h>
+#include <sys/socket.h>
+#include <sys/time.h>
+#include <sys/resource.h>
+#include <sys/un.h>
+#include <sys/ioctl.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#include "liburing.h"
+
+#define ZC_TAG 0xfffffffULL
+#define MAX_SUBMIT_NR 512
+
+static bool cfg_reg_ringfd = true;
+static bool cfg_fixed_files = 1;
+static bool cfg_zc = 1;
+static bool cfg_flush = 0;
+static int  cfg_nr_reqs = 8;
+static bool cfg_fixed_buf = 1;
+
+static int  cfg_family		= PF_UNSPEC;
+static int  cfg_payload_len;
+static int  cfg_port		= 8000;
+static int  cfg_runtime_ms	= 4200;
+
+static socklen_t cfg_alen;
+static struct sockaddr_storage cfg_dst_addr;
+
+static char payload[IP_MAXPACKET] __attribute__((aligned(4096)));
+
+static unsigned long gettimeofday_ms(void)
+{
+	struct timeval tv;
+
+	gettimeofday(&tv, NULL);
+	return (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
+}
+
+static void do_setsockopt(int fd, int level, int optname, int val)
+{
+	if (setsockopt(fd, level, optname, &val, sizeof(val)))
+		error(1, errno, "setsockopt %d.%d: %d", level, optname, val);
+}
+
+static void setup_sockaddr(int domain, const char *str_addr,
+			   struct sockaddr_storage *sockaddr)
+{
+	struct sockaddr_in6 *addr6 = (void *) sockaddr;
+	struct sockaddr_in *addr4 = (void *) sockaddr;
+
+	switch (domain) {
+	case PF_INET:
+		memset(addr4, 0, sizeof(*addr4));
+		addr4->sin_family = AF_INET;
+		addr4->sin_port = htons(cfg_port);
+		if (str_addr &&
+		    inet_pton(AF_INET, str_addr, &(addr4->sin_addr)) != 1)
+			error(1, 0, "ipv4 parse error: %s", str_addr);
+		break;
+	case PF_INET6:
+		memset(addr6, 0, sizeof(*addr6));
+		addr6->sin6_family = AF_INET6;
+		addr6->sin6_port = htons(cfg_port);
+		if (str_addr &&
+		    inet_pton(AF_INET6, str_addr, &(addr6->sin6_addr)) != 1)
+			error(1, 0, "ipv6 parse error: %s", str_addr);
+		break;
+	default:
+		error(1, 0, "illegal domain");
+	}
+}
+
+static int do_setup_tx(int domain, int type, int protocol)
+{
+	int fd;
+
+	fd = socket(domain, type, protocol);
+	if (fd == -1)
+		error(1, errno, "socket t");
+
+	do_setsockopt(fd, SOL_SOCKET, SO_SNDBUF, 1 << 21);
+
+	if (connect(fd, (void *) &cfg_dst_addr, cfg_alen))
+		error(1, errno, "connect");
+	return fd;
+}
+
+static inline struct io_uring_cqe *wait_cqe_fast(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	unsigned head;
+	int ret;
+
+	io_uring_for_each_cqe(ring, head, cqe)
+		return cqe;
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret)
+		error(1, ret, "wait cqe");
+	return cqe;
+}
+
+static void do_tx(int domain, int type, int protocol)
+{
+	unsigned long packets = 0;
+	unsigned long bytes = 0;
+	struct io_uring ring;
+	struct iovec iov;
+	uint64_t tstop;
+	int i, fd, ret;
+	int compl_cqes = 0;
+
+	fd = do_setup_tx(domain, type, protocol);
+
+	ret = io_uring_queue_init(512, &ring, IORING_SETUP_COOP_TASKRUN);
+	if (ret)
+		error(1, ret, "io_uring: queue init");
+
+	if (cfg_zc) {
+		struct io_uring_notification_slot b[1] = {{.tag = ZC_TAG}};
+
+		ret = io_uring_register_notifications(&ring, 1, b);
+		if (ret)
+			error(1, ret, "io_uring: tx ctx registration");
+	}
+	if (cfg_fixed_files) {
+		ret = io_uring_register_files(&ring, &fd, 1);
+		if (ret < 0)
+			error(1, ret, "io_uring: files registration");
+	}
+	if (cfg_reg_ringfd) {
+		ret = io_uring_register_ring_fd(&ring);
+		if (ret < 0)
+			error(1, ret, "io_uring: io_uring_register_ring_fd");
+	}
+
+	iov.iov_base = payload;
+	iov.iov_len = cfg_payload_len;
+
+	ret = io_uring_register_buffers(&ring, &iov, 1);
+	if (ret)
+		error(1, ret, "io_uring: buffer registration");
+
+	tstop = gettimeofday_ms() + cfg_runtime_ms;
+	do {
+		struct io_uring_sqe *sqe;
+		struct io_uring_cqe *cqe;
+		unsigned zc_flags = 0;
+		unsigned buf_idx = 0;
+		unsigned slot_idx = 0;
+		unsigned msg_flags = 0;
+
+		compl_cqes += cfg_flush ? cfg_nr_reqs : 0;
+		if (cfg_flush)
+			zc_flags |= IORING_RECVSEND_NOTIF_FLUSH;
+
+		for (i = 0; i < cfg_nr_reqs; i++) {
+			sqe = io_uring_get_sqe(&ring);
+
+			if (!cfg_zc)
+				io_uring_prep_send(sqe, fd, payload,
+						   cfg_payload_len, 0);
+			else if (cfg_fixed_buf)
+				io_uring_prep_sendzc_fixed(sqe, fd, payload,
+							   cfg_payload_len,
+							   msg_flags, slot_idx,
+							   zc_flags, buf_idx);
+			else
+				io_uring_prep_sendzc(sqe, fd, payload,
+						     cfg_payload_len, msg_flags,
+						     slot_idx, zc_flags);
+
+			sqe->user_data = 1;
+			if (cfg_fixed_files) {
+				sqe->fd = 0;
+				sqe->flags |= IOSQE_FIXED_FILE;
+			}
+		}
+
+		ret = io_uring_submit(&ring);
+		if (ret != cfg_nr_reqs)
+			error(1, ret, "submit");
+
+		for (i = 0; i < cfg_nr_reqs; i++) {
+			cqe = wait_cqe_fast(&ring);
+
+			if (cqe->user_data == ZC_TAG) {
+				compl_cqes--;
+				i--;
+			} else if (cqe->user_data != 1) {
+				error(1, cqe->user_data, "invalid user_data");
+			} else if (cqe->res > 0) {
+				packets++;
+				bytes += cqe->res;
+			} else if (cqe->res == -EAGAIN) {
+				/* request failed, don't flush */
+				if (cfg_flush)
+					compl_cqes--;
+			} else if (cqe->res == -ECONNREFUSED ||
+				   cqe->res == -ECONNRESET ||
+				   cqe->res == -EPIPE) {
+				fprintf(stderr, "Connection failure\n");
+				goto out_fail;
+			} else {
+				error(1, cqe->res, "send failed");
+			}
+
+			io_uring_cqe_seen(&ring, cqe);
+		}
+	} while (gettimeofday_ms() < tstop);
+
+out_fail:
+	shutdown(fd, SHUT_RDWR);
+	if (close(fd))
+		error(1, errno, "close");
+
+	fprintf(stderr, "tx=%lu (MB=%lu), tx/s=%lu (MB/s=%lu)\n",
+			packets, bytes >> 20,
+			packets / (cfg_runtime_ms / 1000),
+			(bytes >> 20) / (cfg_runtime_ms / 1000));
+
+	while (compl_cqes) {
+		struct io_uring_cqe *cqe = wait_cqe_fast(&ring);
+
+		io_uring_cqe_seen(&ring, cqe);
+		compl_cqes--;
+	}
+
+	if (cfg_zc) {
+		ret = io_uring_unregister_notifications(&ring);
+		if (ret)
+			error(1, ret, "io_uring: tx ctx unregistration");
+	}
+	io_uring_queue_exit(&ring);
+}
+
+static void do_test(int domain, int type, int protocol)
+{
+	int i;
+
+	for (i = 0; i < IP_MAXPACKET; i++)
+		payload[i] = 'a' + (i % 26);
+
+	do_tx(domain, type, protocol);
+}
+
+static void usage(const char *filepath)
+{
+	error(1, 0, "Usage: %s [-f] [-n<N>] [-z0] [-s<payload size>] "
+		    "(-4|-6) [-t<time s>] -D<dst_ip> udp", filepath);
+}
+
+static void parse_opts(int argc, char **argv)
+{
+	const int max_payload_len = sizeof(payload) -
+				    sizeof(struct ipv6hdr) -
+				    sizeof(struct tcphdr) -
+				    40 /* max tcp options */;
+	int c;
+	char *daddr = NULL;
+
+	if (argc <= 1)
+		usage(argv[0]);
+
+	cfg_payload_len = max_payload_len;
+
+	while ((c = getopt(argc, argv, "46D:p:s:t:n:fz:b:k")) != -1) {
+		switch (c) {
+		case '4':
+			if (cfg_family != PF_UNSPEC)
+				error(1, 0, "Pass one of -4 or -6");
+			cfg_family = PF_INET;
+			cfg_alen = sizeof(struct sockaddr_in);
+			break;
+		case '6':
+			if (cfg_family != PF_UNSPEC)
+				error(1, 0, "Pass one of -4 or -6");
+			cfg_family = PF_INET6;
+			cfg_alen = sizeof(struct sockaddr_in6);
+			break;
+		case 'D':
+			daddr = optarg;
+			break;
+		case 'p':
+			cfg_port = strtoul(optarg, NULL, 0);
+			break;
+		case 's':
+			cfg_payload_len = strtoul(optarg, NULL, 0);
+			break;
+		case 't':
+			cfg_runtime_ms = 200 + strtoul(optarg, NULL, 10) * 1000;
+			break;
+		case 'n':
+			cfg_nr_reqs = strtoul(optarg, NULL, 0);
+			break;
+		case 'f':
+			cfg_flush = 1;
+			break;
+		case 'z':
+			cfg_zc = strtoul(optarg, NULL, 0);
+			break;
+		case 'b':
+			cfg_fixed_buf = strtoul(optarg, NULL, 0);
+			break;
+		}
+	}
+
+	if (cfg_nr_reqs > MAX_SUBMIT_NR)
+		error(1, 0, "-n: submit batch nr exceeds max (%d)", MAX_SUBMIT_NR);
+	if (cfg_flush && !cfg_zc)
+		error(1, 0, "cfg_flush should be used with zc only");
+	if (cfg_payload_len > max_payload_len)
+		error(1, 0, "-s: payload exceeds max (%d)", max_payload_len);
+
+	setup_sockaddr(cfg_family, daddr, &cfg_dst_addr);
+
+	if (optind != argc - 1)
+		usage(argv[0]);
+}
+
+int main(int argc, char **argv)
+{
+	const char *cfg_test;
+
+	parse_opts(argc, argv);
+
+	cfg_test = argv[argc - 1];
+	if (!strcmp(cfg_test, "tcp"))
+		do_test(cfg_family, SOCK_STREAM, 0);
+	else if (!strcmp(cfg_test, "udp"))
+		do_test(cfg_family, SOCK_DGRAM, 0);
+	else
+		error(1, 0, "unknown cfg_test %s", cfg_test);
+
+	return 0;
+}
-- 
2.37.0

