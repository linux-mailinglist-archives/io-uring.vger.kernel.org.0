Return-Path: <io-uring+bounces-6379-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 337CAA32F24
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 20:00:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E186A7A37F9
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 18:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E084263C9E;
	Wed, 12 Feb 2025 18:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ceH6qeKs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82052263C85
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 18:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739386759; cv=none; b=Elyku7hz/20FFEPUpKWhHS1iYDfYVxQiyFTa17pArvQevPRC8Ut1AhUBwllJYvMLlMtY6Cyoi6CHMlXaSAg/yNiyKWxlZQ4R4eqVVOpx9SOE6zn21t8wk5sKk/LIv8JkNmS5HAXu5kJ4vUTp1lFJ212E9Ajjk4W8pfO9tuuweSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739386759; c=relaxed/simple;
	bh=zwEaT1fzCA6pZ/DniFaCt9D40j2W53weGLCTLMkrfvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5/C2KM6mR1Y5H0liisHiMOVhbzxjNWfy1rzWdRPu60clJK3QIGFW+WVzupxHKtf8KpcCG9F85PEeZZk+Wqz/HAuZIM5nCrnxFjwsEK4lJfj6Ao2UqhSW3RC+rwDTmJ5mD4PJhdeCblJQbyL619pnMSTT508vRCWEKqKqqqtCvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ceH6qeKs; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21f74c4e586so212275ad.0
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 10:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739386757; x=1739991557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mHHS+FPDLO3skgLo3fHZNTV70X52xj2EYXoCt0zXgCA=;
        b=ceH6qeKskOMG4ns6Rs/JRfahbhwifQL46Jvks893yp59faFsEx9PoNPpkkzngEB7vM
         GC7ZrHJXR8Hylp6ShaRLY14lCIxeOmJbEc3vSb/bLsVx3sMTlta+X0iT4SPrb224UVuu
         bKCWNySUcsU8RpTb1NBmMed/a6uGw/Hfo6TsrIFzW1EKP6A0FpGjCKo4rSNzJYagVNs+
         Ro8UGgl2qTXOifuBBqt44rrm0wnR9ak/7ieFlgYhoXGbUPzEdCnRPcZUXNeyCWpVlKV4
         DBA1tLIkBw68eRJ0RIeMEkg3i9TBdNM8jEPBBzINCvTptbhqYGPEtjH9GqYZcZLxSC9N
         7P+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739386757; x=1739991557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mHHS+FPDLO3skgLo3fHZNTV70X52xj2EYXoCt0zXgCA=;
        b=XtuBDAmyAvvMINBBEjf7YE9p1l7CiaNj70EzfoEz1/MkbmLG8qYi37Rv5yK2Ks7sFR
         YtI8uwHdSNapitTzEKYrPgfo20BU/fjcQ9fExMjSQ2Bk5To700PTUHP45d5fHW9zdSJC
         i4le5AOaP1V872aObtoIgVyYakhuDPcGqqLn9vTUrn6STDl5zvVw40ourvjweqComcC8
         kIJLu1JR2uNX41eRz7aYzLIEL6RA+bU8oZjMU4AmssbGQLlgn5dMYinlTwqBU+cfo7n0
         mLiLo/HG7geW8ILNeFRkyOZ13+tPFTWi63qrouqp+U9JeSTwfD4wnosDLh6pmYp2550f
         xyog==
X-Gm-Message-State: AOJu0YwkzjHVz75QxjVd2S4YoFSdika2BCMht0b3foOIkYNedbFesPqn
	rKxaO9f0teT2GPvZ2iOvNk+whjnPagcd24WvLGPT7EMZ4WUyhul2+inlsNrSdOjSpUk/ez0xSKy
	X
X-Gm-Gg: ASbGncu/DJu4CnUQzJOzvu2orqZSdLwHyYbLxmY/N3KvNZz/GtFEXhFbiG9xcaKdNb/
	mlZHMla7U7AwpMRt8pXw29cPhfcD9Szi5/+LiXKI2W9R/4+GRUj4+yMbw0hPbKw+UthRlx8FGRv
	/gHkk4Fst6yPx/rrkeBXTZLXnuB2sXU+qAx287AUTq/OvC6kHIWrdXw2mKKDqzYJeJ849WvPP++
	CDs8qnvIXReKWBNi9NgGoC1SoLOtOmbVfk3CY5WnkYrmJnuuhJR0WKCruA+aDAOsc1ktXBrmRvL
X-Google-Smtp-Source: AGHT+IEu2sFpRUu/vz72LicjAXvdeF+AOE/7q4V9lBD5XoIVDQa4eOH26VNDxF33jXM9Dvn7GNm/Cg==
X-Received: by 2002:a17:903:230c:b0:216:7ee9:2227 with SMTP id d9443c01a7336-220bdfee0c7mr64830895ad.36.1739386756756;
        Wed, 12 Feb 2025 10:59:16 -0800 (PST)
Received: from localhost ([2a03:2880:ff:43::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f3655164bsm116851585ad.85.2025.02.12.10.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 10:59:16 -0800 (PST)
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
Subject: [PATCH net-next v13 11/11] io_uring/zcrx: add selftest
Date: Wed, 12 Feb 2025 10:58:01 -0800
Message-ID: <20250212185859.3509616-12-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250212185859.3509616-1-dw@davidwei.uk>
References: <20250212185859.3509616-1-dw@davidwei.uk>
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
 .../testing/selftests/drivers/net/hw/Makefile |   5 +
 .../selftests/drivers/net/hw/iou-zcrx.c       | 426 ++++++++++++++++++
 .../selftests/drivers/net/hw/iou-zcrx.py      |  64 +++
 4 files changed, 497 insertions(+)
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
index 21ba64ce1e34..7efc47c89463 100644
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
@@ -38,3 +41,5 @@ include ../../../lib.mk
 # YNL build
 YNL_GENS := ethtool netdev
 include ../../../net/ynl.mk
+
+$(OUTPUT)/iou-zcrx: LDLIBS += -luring
diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.c b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
new file mode 100644
index 000000000000..010c261d2132
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
@@ -0,0 +1,426 @@
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
+static int cfg_server;
+static int cfg_client;
+static int cfg_port = 8000;
+static int cfg_payload_len;
+static const char *cfg_ifname;
+static int cfg_queue_id = -1;
+static struct sockaddr_in6 cfg_addr;
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
+static int parse_address(const char *str, int port, struct sockaddr_in6 *sin6)
+{
+	int ret;
+
+	sin6->sin6_family = AF_INET6;
+	sin6->sin6_port = htons(port);
+
+	ret = inet_pton(sin6->sin6_family, str, &sin6->sin6_addr);
+	if (ret != 1) {
+		/* fallback to plain IPv4 */
+		ret = inet_pton(AF_INET, str, &sin6->sin6_addr.s6_addr32[3]);
+		if (ret != 1)
+			return -1;
+
+		/* add ::ffff prefix */
+		sin6->sin6_addr.s6_addr32[0] = 0;
+		sin6->sin6_addr.s6_addr32[1] = 0;
+		sin6->sin6_addr.s6_addr16[4] = 0;
+		sin6->sin6_addr.s6_addr16[5] = 0xffff;
+	}
+
+	return 0;
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
+	rqe->off = (rcqe->off & ~IORING_ZCRX_AREA_MASK) | area_token;
+	rqe->len = cqe->res;
+	io_uring_smp_store_release(rq_ring.ktail, ++rq_ring.rq_tail);
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
+	fd = socket(AF_INET6, SOCK_STREAM, 0);
+	if (fd == -1)
+		error(1, 0, "socket()");
+
+	enable = 1;
+	ret = setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(int));
+	if (ret < 0)
+		error(1, 0, "setsockopt(SO_REUSEADDR)");
+
+	ret = bind(fd, &cfg_addr, sizeof(cfg_addr));
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
+	fd = socket(AF_INET6, SOCK_STREAM, 0);
+	if (fd == -1)
+		error(1, 0, "socket()");
+
+	if (connect(fd, &cfg_addr, sizeof(cfg_addr)))
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
+	char *addr = NULL;
+	int ret;
+	int c;
+
+	if (argc <= 1)
+		usage(argv[0]);
+	cfg_payload_len = max_payload_len;
+
+	while ((c = getopt(argc, argv, "46sch:p:l:i:q:")) != -1) {
+		switch (c) {
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
+	memset(addr6, 0, sizeof(*addr6));
+	addr6->sin6_family = AF_INET6;
+	addr6->sin6_port = htons(cfg_port);
+	addr6->sin6_addr = in6addr_any;
+	if (addr) {
+		ret = parse_address(addr, cfg_port, addr6);
+		if (ret)
+			error(1, 0, "receiver address parse error: %s", addr);
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
index 000000000000..ea0a346c3eff
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
@@ -0,0 +1,64 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+import re
+from os import path
+from lib.py import ksft_run, ksft_exit
+from lib.py import NetDrvEpEnv
+from lib.py import bkg, cmd, ethtool, wait_port_listen
+
+
+def _get_rx_ring_entries(cfg):
+    output = ethtool(f"-g {cfg.ifname}", host=cfg.remote).stdout
+    values = re.findall(r'RX:\s+(\d+)', output)
+    return int(values[1])
+
+
+def _get_combined_channels(cfg):
+    output = ethtool(f"-l {cfg.ifname}", host=cfg.remote).stdout
+    values = re.findall(r'Combined:\s+(\d+)', output)
+    return int(values[1])
+
+
+def _set_flow_rule(cfg, chan):
+    output = ethtool(f"-N {cfg.ifname} flow-type tcp6 dst-port 9999 action {chan}", host=cfg.remote).stdout
+    values = re.search(r'ID (\d+)', output).group(1)
+    return int(values)
+
+
+def test_zcrx(cfg) -> None:
+    cfg.require_v6()
+
+    combined_chans = _get_combined_channels(cfg)
+    if combined_chans < 2:
+        raise KsftSkipEx('at least 2 combined channels required')
+    rx_ring = _get_rx_ring_entries(cfg)
+
+    rx_cmd = f"{cfg.bin_remote} -s -p 9999 -i {cfg.ifname} -q {combined_chans - 1}"
+    tx_cmd = f"{cfg.bin_local} -c -h {cfg.remote_v6} -p 9999 -l 12840"
+
+    try:
+        ethtool(f"-G {cfg.ifname} rx 64", host=cfg.remote)
+        ethtool(f"-X {cfg.ifname} equal {combined_chans - 1}", host=cfg.remote)
+        flow_rule_id = _set_flow_rule(cfg, combined_chans - 1)
+
+        with bkg(rx_cmd, host=cfg.remote, exit_wait=True):
+            wait_port_listen(9999, proto="tcp", host=cfg.remote)
+            cmd(tx_cmd)
+    finally:
+        ethtool(f"-N {cfg.ifname} delete {flow_rule_id}", host=cfg.remote)
+        ethtool(f"-X {cfg.ifname} default", host=cfg.remote)
+        ethtool(f"-G {cfg.ifname} rx {rx_ring}", host=cfg.remote)
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


