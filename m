Return-Path: <io-uring+bounces-5558-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE3199F5BCB
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:41:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E133B16C409
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9A8814AD2B;
	Wed, 18 Dec 2024 00:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="shyj43gp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04229142900
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482303; cv=none; b=GnQ66E5EAhmMV9hKvXGm2t5Hx7gT36+vuQhWdPYSvj3G3Au1WkjnrtfzzIMLYvpE5Rz9i5CQqIGfytogcL4RXcPdJi+5QDQCr0dUVLXlr31f2CjZg4c73d78ON4Wmdg4VWt4kd3iL5+C/xeTypFMGL38fj/ERLKJWut4S/JN8qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482303; c=relaxed/simple;
	bh=lcMzOgRhe6foeYQtk6KkeLA/bpoDBr4lIE7RfzJXV8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/6QRAaJ3LrZurShAR4Ol1E3lvy+rTI2Dpig2Bwca3lKYhDfZV1BnQ8nRhUzA4TaQwNOc10flsXh7x3Ne30fn8YReb6mxfbyU636YWlCMIW2t3hGPgIbK7u8ejd1xQ+M869bfts3WLWnkA3C46y2uiJxMth+rRXhKOCiRx5EDx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=shyj43gp; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-215770613dbso40305365ad.2
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482300; x=1735087100; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z8jcULxy4J4nEWnjbRQtdx9qrQ+/W+M/aJAJhHd6jtw=;
        b=shyj43gpJAFYGUrdxfEUsB5gzfN+gelcykMY7RpZEW6UDElgIeW1DqtW09/JR9sPLw
         xNYeLpdirKMHvhSx3/Jn2NkwlqmccwONHT+wYh/58aqF2MkIOFBBbOuXljhOAWZqgPv4
         AIajGx+nYyT3TuXBEViz4BRKOxFOtGAp63a9TRGRZVACb7w9BPRwy31HwIgpyvr2mx1H
         d56hJh9U5Kff7pB3slS4h91WlL6F3VCeKzYnTvmSBbLU6sFf51cat3jOWKKSRHHqcCJN
         nIVY/9Vufc24itEA0ilSvrMFSLGdtbTC/4gW6MS9PaSs1Vmq4LaE/5SER3cAgvESvcAL
         qQnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482300; x=1735087100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z8jcULxy4J4nEWnjbRQtdx9qrQ+/W+M/aJAJhHd6jtw=;
        b=SLM7hwSggLQDRR0qdFE1e+YUlgPh6zT3LSwG4SQ3DTOnAjD41u35R6X4ge04wNicZ1
         kJIuFeevxX2eH/S6D3v7yLJw6tOu71oRsuj51hI0/vaZKTikmkpBoSb6zyD3IA9KRu3u
         wwSNF8db3kL/DJwmpdkl8d2RVafrLZ4s4gVAtHw79ejlOXwvSsa/W7ZKy1kwpt84rEB8
         Gkxt9/hzbLP9SuG+iKVqnpvmADNcotCuWr1OBcylz+s5ok606/JO0zZq7xSS3gkegViW
         qssbMsxFM4zCA2deZKGICbz/ilitqud4aJcIxYaloQuFYpVxjWoMKoc5Xf8Ln8gwteDs
         vHpg==
X-Gm-Message-State: AOJu0YwM0yR5xsWR2SZjXDL12gQCZIQ3iXCGzYTlokIDdVtp7AWoQbwr
	gYNxIxprRWvnkxUHJLpc0i2MHKrh9qC2fM6858SlXToPlrzUfMA/+WfP4AEI3v3LRgKrGPAeYg+
	1
X-Gm-Gg: ASbGncsHRy7FSY44LJTNm08PZbIxd5KDYl+4FpOlNQsrVoI36qCHGNavGTVlVovXJfo
	Mr7qkZ0cM6VGlPnK5KehH217juuYW06WMazmSv9IxRsGkZYiRdWDl+khFBTo4ZTZ4OIZVhZN/mw
	H6Tvf+Aj85w6g2f6JOGCYwDoFPcDSqX4nNFtMRt6AkJthmWlSQ6xV+Q8h4O7NMuABTDFstOEQx3
	FPSCfy75Iwgs08phOcmDdtYlALb+Rut55OyaLfg
X-Google-Smtp-Source: AGHT+IHhbs8hnUkijpIBsA19GBm92dgIfwCbdbCV150kccfSg1woTlw1lhnJ56BZr04LHs9VOVNg3A==
X-Received: by 2002:a17:902:e5ca:b0:215:4394:40b5 with SMTP id d9443c01a7336-218d724abe7mr10351165ad.43.1734482300179;
        Tue, 17 Dec 2024 16:38:20 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-218a1e50aadsm65065375ad.156.2024.12.17.16.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:38:19 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v9 20/20] io_uring/zcrx: add selftest
Date: Tue, 17 Dec 2024 16:37:46 -0800
Message-ID: <20241218003748.796939-21-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241218003748.796939-1-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a selftest for io_uring zero copy Rx. This test cannot run locally
and requires a remote host to be configured in net.config. The remote
host must have hardware support for zero copy Rx as listed in the
documentation page. The test will restore the NIC config back to before
the test and is idempotent.

liburing is required to compile the test and be installed on the remote
host running the test.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 .../selftests/drivers/net/hw/.gitignore       |   2 +
 .../testing/selftests/drivers/net/hw/Makefile |   6 +
 .../selftests/drivers/net/hw/iou-zcrx.c       | 432 ++++++++++++++++++
 .../selftests/drivers/net/hw/iou-zcrx.py      |  64 +++
 4 files changed, 504 insertions(+)
 create mode 100644 tools/testing/selftests/drivers/net/hw/iou-zcrx.c
 create mode 100755 tools/testing/selftests/drivers/net/hw/iou-zcrx.py

diff --git a/tools/testing/selftests/drivers/net/hw/.gitignore b/tools/testing/selftests/drivers/net/hw/.gitignore
index e9fe6ede681a..6942bf575497 100644
--- a/tools/testing/selftests/drivers/net/hw/.gitignore
+++ b/tools/testing/selftests/drivers/net/hw/.gitignore
@@ -1 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+iou-zcrx
 ncdevmem
diff --git a/tools/testing/selftests/drivers/net/hw/Makefile b/tools/testing/selftests/drivers/net/hw/Makefile
index 21ba64ce1e34..5431af8e8210 100644
--- a/tools/testing/selftests/drivers/net/hw/Makefile
+++ b/tools/testing/selftests/drivers/net/hw/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0+ OR MIT
 
+TEST_GEN_FILES = iou-zcrx
+
 TEST_PROGS = \
 	csum.py \
 	devlink_port_split.py \
@@ -10,6 +12,7 @@ TEST_PROGS = \
 	ethtool_rmon.sh \
 	hw_stats_l3.sh \
 	hw_stats_l3_gre.sh \
+	iou-zcrx.py \
 	loopback.sh \
 	nic_link_layer.py \
 	nic_performance.py \
@@ -38,3 +41,6 @@ include ../../../lib.mk
 # YNL build
 YNL_GENS := ethtool netdev
 include ../../../net/ynl.mk
+
+$(OUTPUT)/iou-zcrx: CFLAGS += -I/usr/include/
+$(OUTPUT)/iou-zcrx: LDLIBS += -luring
diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.c b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
new file mode 100644
index 000000000000..12f71e3e111e
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
@@ -0,0 +1,432 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <assert.h>
+#include <errno.h>
+#include <error.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <arpa/inet.h>
+#include <linux/errqueue.h>
+#include <linux/if_packet.h>
+#include <linux/ipv6.h>
+#include <linux/socket.h>
+#include <linux/sockios.h>
+#include <net/ethernet.h>
+#include <net/if.h>
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
+#include <netinet/tcp.h>
+#include <netinet/udp.h>
+#include <sys/epoll.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/resource.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/un.h>
+#include <sys/wait.h>
+
+#include <liburing.h>
+
+#define PAGE_SIZE (4096)
+#define AREA_SIZE (8192 * PAGE_SIZE)
+#define SEND_SIZE (512 * 4096)
+#define min(a, b) \
+	({ \
+		typeof(a) _a = (a); \
+		typeof(b) _b = (b); \
+		_a < _b ? _a : _b; \
+	})
+#define min_t(t, a, b) \
+	({ \
+		t _ta = (a); \
+		t _tb = (b); \
+		min(_ta, _tb); \
+	})
+
+#define ALIGN_UP(v, align) (((v) + (align) - 1) & ~((align) - 1))
+
+static int cfg_family = PF_UNSPEC;
+static int cfg_server;
+static int cfg_client;
+static int cfg_port = 8000;
+static int cfg_payload_len;
+static const char *cfg_ifname;
+static int cfg_queue_id = -1;
+
+static socklen_t cfg_alen;
+static struct sockaddr_storage cfg_addr;
+
+static char payload[SEND_SIZE] __attribute__((aligned(PAGE_SIZE)));
+static void *area_ptr;
+static void *ring_ptr;
+static size_t ring_size;
+static struct io_uring_zcrx_rq rq_ring;
+static unsigned long area_token;
+static int connfd;
+static bool stop;
+static size_t received;
+
+static unsigned long gettimeofday_ms(void)
+{
+	struct timeval tv;
+
+	gettimeofday(&tv, NULL);
+	return (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
+}
+
+static inline size_t get_refill_ring_size(unsigned int rq_entries)
+{
+	size_t size;
+
+	ring_size = rq_entries * sizeof(struct io_uring_zcrx_rqe);
+	/* add space for the header (head/tail/etc.) */
+	ring_size += PAGE_SIZE;
+	return ALIGN_UP(ring_size, 4096);
+}
+
+static void setup_zcrx(struct io_uring *ring)
+{
+	unsigned int ifindex;
+	unsigned int rq_entries = 4096;
+	int ret;
+
+	ifindex = if_nametoindex(cfg_ifname);
+	if (!ifindex)
+		error(1, 0, "bad interface name: %s", cfg_ifname);
+
+	area_ptr = mmap(NULL,
+			AREA_SIZE,
+			PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE,
+			0,
+			0);
+	if (area_ptr == MAP_FAILED)
+		error(1, 0, "mmap(): zero copy area");
+
+	ring_size = get_refill_ring_size(rq_entries);
+	ring_ptr = mmap(NULL,
+			ring_size,
+			PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE,
+			0,
+			0);
+
+	struct io_uring_region_desc region_reg = {
+		.size = ring_size,
+		.user_addr = (__u64)(unsigned long)ring_ptr,
+		.flags = IORING_MEM_REGION_TYPE_USER,
+	};
+
+	struct io_uring_zcrx_area_reg area_reg = {
+		.addr = (__u64)(unsigned long)area_ptr,
+		.len = AREA_SIZE,
+		.flags = 0,
+	};
+
+	struct io_uring_zcrx_ifq_reg reg = {
+		.if_idx = ifindex,
+		.if_rxq = cfg_queue_id,
+		.rq_entries = rq_entries,
+		.area_ptr = (__u64)(unsigned long)&area_reg,
+		.region_ptr = (__u64)(unsigned long)&region_reg,
+	};
+
+	ret = io_uring_register_ifq(ring, &reg);
+	if (ret)
+		error(1, 0, "io_uring_register_ifq(): %d", ret);
+
+	rq_ring.khead = (unsigned int *)((char *)ring_ptr + reg.offsets.head);
+	rq_ring.ktail = (unsigned int *)((char *)ring_ptr + reg.offsets.tail);
+	rq_ring.rqes = (struct io_uring_zcrx_rqe *)((char *)ring_ptr + reg.offsets.rqes);
+	rq_ring.rq_tail = 0;
+	rq_ring.ring_entries = reg.rq_entries;
+
+	area_token = area_reg.rq_area_token;
+}
+
+static void add_accept(struct io_uring *ring, int sockfd)
+{
+	struct io_uring_sqe *sqe;
+
+	sqe = io_uring_get_sqe(ring);
+
+	io_uring_prep_accept(sqe, sockfd, NULL, NULL, 0);
+	sqe->user_data = 1;
+}
+
+static void add_recvzc(struct io_uring *ring, int sockfd)
+{
+	struct io_uring_sqe *sqe;
+
+	sqe = io_uring_get_sqe(ring);
+
+	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, sockfd, NULL, 0, 0);
+	sqe->ioprio |= IORING_RECV_MULTISHOT;
+	sqe->user_data = 2;
+}
+
+static void process_accept(struct io_uring *ring, struct io_uring_cqe *cqe)
+{
+	if (cqe->res < 0)
+		error(1, 0, "accept()");
+	if (connfd)
+		error(1, 0, "Unexpected second connection");
+
+	connfd = cqe->res;
+	add_recvzc(ring, connfd);
+}
+
+static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
+{
+	unsigned rq_mask = rq_ring.ring_entries - 1;
+	struct io_uring_zcrx_cqe *rcqe;
+	struct io_uring_zcrx_rqe *rqe;
+	struct io_uring_sqe *sqe;
+	uint64_t mask;
+	char *data;
+	ssize_t n;
+	int i;
+
+	if (cqe->res == 0 && cqe->flags == 0) {
+		stop = true;
+		return;
+	}
+
+	if (cqe->res < 0)
+		error(1, 0, "recvzc(): %d", cqe->res);
+
+	if (!(cqe->flags & IORING_CQE_F_MORE))
+		add_recvzc(ring, connfd);
+
+	rcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
+
+	n = cqe->res;
+	mask = (1ULL << IORING_ZCRX_AREA_SHIFT) - 1;
+	data = (char *)area_ptr + (rcqe->off & mask);
+
+	for (i = 0; i < n; i++) {
+		if (*(data + i) != payload[(received + i)])
+			error(1, 0, "payload mismatch");
+	}
+	received += n;
+
+	rqe = &rq_ring.rqes[(rq_ring.rq_tail & rq_mask)];
+	rqe->off = (rcqe->off & IORING_ZCRX_AREA_MASK) | area_token;
+	rqe->len = cqe->res;
+	IO_URING_WRITE_ONCE(*rq_ring.ktail, ++rq_ring.rq_tail);
+}
+
+static void server_loop(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	unsigned int count = 0;
+	unsigned int head;
+	int i, ret;
+
+	io_uring_submit_and_wait(ring, 1);
+
+	io_uring_for_each_cqe(ring, head, cqe) {
+		if (cqe->user_data == 1)
+			process_accept(ring, cqe);
+		else if (cqe->user_data == 2)
+			process_recvzc(ring, cqe);
+		else
+			error(1, 0, "unknown cqe");
+		count++;
+	}
+	io_uring_cq_advance(ring, count);
+}
+
+static void run_server(void)
+{
+	unsigned int flags = 0;
+	struct io_uring ring;
+	int fd, enable, ret;
+	uint64_t tstop;
+
+	fd = socket(cfg_family, SOCK_STREAM, 0);
+	if (fd == -1)
+		error(1, 0, "socket()");
+
+	enable = 1;
+	ret = setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(int));
+	if (ret < 0)
+		error(1, 0, "setsockopt(SO_REUSEADDR)");
+
+	ret = bind(fd, (const struct sockaddr *)&cfg_addr, sizeof(cfg_addr));
+	if (ret < 0)
+		error(1, 0, "bind()");
+
+	if (listen(fd, 1024) < 0)
+		error(1, 0, "listen()");
+
+	flags |= IORING_SETUP_COOP_TASKRUN;
+	flags |= IORING_SETUP_SINGLE_ISSUER;
+	flags |= IORING_SETUP_DEFER_TASKRUN;
+	flags |= IORING_SETUP_SUBMIT_ALL;
+	flags |= IORING_SETUP_CQE32;
+
+	io_uring_queue_init(512, &ring, flags);
+
+	setup_zcrx(&ring);
+
+	add_accept(&ring, fd);
+
+	tstop = gettimeofday_ms() + 5000;
+	while (!stop && gettimeofday_ms() < tstop)
+		server_loop(&ring);
+
+	if (!stop)
+		error(1, 0, "test failed\n");
+}
+
+static void run_client(void)
+{
+	ssize_t to_send = SEND_SIZE;
+	ssize_t sent = 0;
+	ssize_t chunk, res;
+	int fd;
+
+	fd = socket(cfg_family, SOCK_STREAM, 0);
+	if (fd == -1)
+		error(1, 0, "socket()");
+
+	if (connect(fd, (void *)&cfg_addr, cfg_alen))
+		error(1, 0, "connect()");
+
+	while (to_send) {
+		void *src = &payload[sent];
+
+		chunk = min_t(ssize_t, cfg_payload_len, to_send);
+		res = send(fd, src, chunk, 0);
+		if (res < 0)
+			error(1, 0, "send(): %d", sent);
+		sent += res;
+		to_send -= res;
+	}
+
+	close(fd);
+}
+
+static void usage(const char *filepath)
+{
+	error(1, 0, "Usage: %s (-4|-6) (-s|-c) -h<server_ip> -p<port> "
+		    "-l<payload_size> -i<ifname> -q<rxq_id>", filepath);
+}
+
+static void parse_opts(int argc, char **argv)
+{
+	const int max_payload_len = sizeof(payload) -
+				    sizeof(struct ipv6hdr) -
+				    sizeof(struct tcphdr) -
+				    40 /* max tcp options */;
+	struct sockaddr_in6 *addr6 = (void *) &cfg_addr;
+	struct sockaddr_in *addr4 = (void *) &cfg_addr;
+	char *addr = NULL;
+	int c;
+
+	if (argc <= 1)
+		usage(argv[0]);
+	cfg_payload_len = max_payload_len;
+
+	while ((c = getopt(argc, argv, "46sch:p:l:i:q:")) != -1) {
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
+		case 's':
+			if (cfg_client)
+				error(1, 0, "Pass one of -s or -c");
+			cfg_server = 1;
+			break;
+		case 'c':
+			if (cfg_server)
+				error(1, 0, "Pass one of -s or -c");
+			cfg_client = 1;
+			break;
+		case 'h':
+			addr = optarg;
+			break;
+		case 'p':
+			cfg_port = strtoul(optarg, NULL, 0);
+			break;
+		case 'l':
+			cfg_payload_len = strtoul(optarg, NULL, 0);
+			break;
+		case 'i':
+			cfg_ifname = optarg;
+			break;
+		case 'q':
+			cfg_queue_id = strtoul(optarg, NULL, 0);
+			break;
+		}
+	}
+
+	if (cfg_server && addr)
+		error(1, 0, "Receiver cannot have -h specified");
+
+	switch (cfg_family) {
+	case PF_INET:
+		memset(addr4, 0, sizeof(*addr4));
+		addr4->sin_family = AF_INET;
+		addr4->sin_port = htons(cfg_port);
+		addr4->sin_addr.s_addr = htonl(INADDR_ANY);
+
+		if (addr &&
+		    inet_pton(AF_INET, addr, &(addr4->sin_addr)) != 1)
+			error(1, 0, "ipv4 parse error: %s", addr);
+		break;
+	case PF_INET6:
+		memset(addr6, 0, sizeof(*addr6));
+		addr6->sin6_family = AF_INET6;
+		addr6->sin6_port = htons(cfg_port);
+		addr6->sin6_addr = in6addr_any;
+
+		if (addr &&
+		    inet_pton(AF_INET6, addr, &(addr6->sin6_addr)) != 1)
+			error(1, 0, "ipv6 parse error: %s", addr);
+		break;
+	default:
+		error(1, 0, "illegal domain");
+	}
+
+	if (cfg_payload_len > max_payload_len)
+		error(1, 0, "-l: payload exceeds max (%d)", max_payload_len);
+}
+
+int main(int argc, char **argv)
+{
+	const char *cfg_test = argv[argc - 1];
+	int i;
+
+	parse_opts(argc, argv);
+
+	for (i = 0; i < SEND_SIZE; i++)
+		payload[i] = 'a' + (i % 26);
+
+	if (cfg_server)
+		run_server();
+	else if (cfg_client)
+		run_client();
+
+	return 0;
+}
diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
new file mode 100755
index 000000000000..3998d0ad504f
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
@@ -0,0 +1,64 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+from os import path
+from lib.py import ksft_run, ksft_exit
+from lib.py import NetDrvEpEnv
+from lib.py import bkg, cmd, wait_port_listen
+
+
+def _get_rx_ring_entries(cfg):
+    eth_cmd = "ethtool -g {} | awk '/RX:/ {{count++}} count == 2 {{print $2; exit}}'"
+    res = cmd(eth_cmd.format(cfg.ifname), host=cfg.remote)
+    return int(res.stdout)
+
+
+def _get_combined_channels(cfg):
+    eth_cmd = "ethtool -l {} | awk '/Combined:/ {{count++}} count == 2 {{print $2; exit}}'"
+    res = cmd(eth_cmd.format(cfg.ifname), host=cfg.remote)
+    return int(res.stdout)
+
+
+def _set_flow_rule(cfg, chan):
+    eth_cmd = "ethtool -N {} flow-type tcp6 dst-port 9999 action {} | awk '{{print $NF}}'"
+    res = cmd(eth_cmd.format(cfg.ifname, chan), host=cfg.remote)
+    return int(res.stdout)
+
+
+def test_zcrx(cfg) -> None:
+    cfg.require_v6()
+    cfg.require_cmd("awk", remote=True)
+
+    combined_chans = _get_combined_channels(cfg)
+    if combined_chans < 2:
+        raise KsftSkipEx('at least 2 combined channels required')
+    rx_ring = _get_rx_ring_entries(cfg)
+
+    rx_cmd = f"{cfg.bin_remote} -6 -s -p 9999 -i {cfg.ifname} -q {combined_chans - 1}"
+    tx_cmd = f"{cfg.bin_local} -6 -c -h {cfg.remote_v6} -p 9999 -l 12840"
+
+    try:
+        cmd(f"ethtool -G {cfg.ifname} rx 64", host=cfg.remote)
+        cmd(f"ethtool -X {cfg.ifname} equal {combined_chans - 1}", host=cfg.remote)
+        flow_rule_id = _set_flow_rule(cfg, combined_chans - 1)
+
+        with bkg(rx_cmd, host=cfg.remote, exit_wait=True):
+            wait_port_listen(9999, proto="tcp", host=cfg.remote)
+            cmd(tx_cmd)
+    finally:
+        cmd(f"ethtool -N {cfg.ifname} delete {flow_rule_id}", host=cfg.remote)
+        cmd(f"ethtool -X {cfg.ifname} default", host=cfg.remote)
+        cmd(f"ethtool -G {cfg.ifname} rx {rx_ring}", host=cfg.remote)
+
+
+def main() -> None:
+    with NetDrvEpEnv(__file__) as cfg:
+        cfg.bin_local = path.abspath(path.dirname(__file__) + "/../../../drivers/net/hw/iou-zcrx")
+        cfg.bin_remote = cfg.remote.deploy(cfg.bin_local)
+
+        ksft_run(globs=globals(), case_pfx={"test_"}, args=(cfg, ))
+    ksft_exit()
+
+
+if __name__ == "__main__":
+    main()
-- 
2.43.5


