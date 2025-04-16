Return-Path: <io-uring+bounces-7479-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D559A8B499
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 11:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58D42169D1D
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 09:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C8A921348;
	Wed, 16 Apr 2025 09:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VBI2k0Ly"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAAB20E6E4
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 09:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744794021; cv=none; b=LNSPbmfg/TULdAMN5Ei1w/6PvDL8oDFYY6X2VPTpv0p4doZo3bvx+WeXZq2YH/Qdaz/wWbjbGczs3TYamySOURs2VVh9svPIYxwNHDnZkPWPH8t/Ijtnc0M2FO2R8XDgDYxl2LaShx2eH7+izTaHeGE1P7yN5tzXyR0yzUstbmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744794021; c=relaxed/simple;
	bh=+IXHp2xQdRG6g1eT0BwMkXXif3kSl2xQqQ+BJWhR3+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TeSWCSH3IlrYl/7ZkyUMu5bfusPrEjnzHmCBrS+r7UzfxH+Y7OmUeDoqmUaHKYLlA6RGURghK9V6vDrr1nhxqJoeT+QkoJjY2j4PiHa1WwcfuG2xQp3jBBX1WRkN3tWLzxKV7n/7QVS6l5HxoltxTQTiOcKZmjpTyykf0dy/gtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VBI2k0Ly; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-acb2faa9f55so162281366b.3
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 02:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744794017; x=1745398817; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f7gZKWPUL5KoBwEkOjSZmuNxEOeS/iwBeaXLzhXEhQQ=;
        b=VBI2k0Lyat/npycNJU/6G9ZiXWv+kminIf1i81WCgiFxSC2ZGgoUEpV2vEumX3RwiA
         2mcmgHzEynqyvuiNYmWp49K8kYFLI5pH+8QsVxrkspsS/GFa52hM65btmTHcS3b1DqAX
         QPSQnChop919uD+ShP6/PFF7U1LbAHE1A0c9KEGh7QXujy9uX+/HXdkR1LXBO/SxAEyv
         eznvo2sg16M8XwzgRBkUAwjEHuZmrA3mArJzcy2QnNm4mV87wTxaid+4EoFH1iAwDN5d
         h2YMAyNloH4za1QyjOcJEKAV2bEpuLGCF/DC8kTzsXXAAKClHmkfRUAjyc9B0wgemANP
         KCUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744794017; x=1745398817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f7gZKWPUL5KoBwEkOjSZmuNxEOeS/iwBeaXLzhXEhQQ=;
        b=VGQxHLV9SAxJT8cEyPIf1Lof70Le1DPo0VgUqcEzspRCeGdaRYH/oFRWe8+4AhI8SU
         ln2byA152abGKNvZsEGGnXvf+gwNHKGvTCA4EtVXvN8JZAoYhWDB24aA/LnrhLdi9O0n
         qB0xGGJ38aSs84wd35f9cDwAi4ZumHDOEmglhWlEjMvszcpHrE6qkjf/CIkH1ytNuL0j
         1tf/5SoezmbhhS8CNKAnFmrw7Y+056mwo1b2vFiD/PHgRc6/vq/zouRctA3UNyIpqKyt
         fMhTAPEhIesO43q4sBCo28J0tOK4J9vkloQWFUz21gkOah788RGPG6mGHLKC/TaNvXKm
         YfJg==
X-Gm-Message-State: AOJu0YzbAJeWEYoHwBZzPxQ1ORgdyST31cJGA7vl/h+F1tKuJeDm08io
	cdnR/TK2fAPp1g7gtr7XRFjJ0nwU8TTH6F4PGPca8ZBC9NaWiYvdSGYfng==
X-Gm-Gg: ASbGncsQYMpOi2cpS9+8QJPtDyL+MC0b0MlszEX0PEXfBUyx16ZdW96gDUrfwT3flYN
	V809Yic8QZXXJVt8ao/lTBZQKNyQdHiHw9dToTojWNQBAy4py1JQsMKGSKIqmy8IVUEGnCnnlB5
	uSc1wUYMI852qQAMXtOUlaPz7TcUMKPHcuDfjTNQoYM8Bp1q+y4Ty7KZElOtB8QCG+xJsWf1wWs
	XqgUfPoiVXxo4ybDbNj0xLjgkvbb4aNvVYa085jl45CZa4M52fjpWnfH9fTdS5nKBALuKdno5uw
	+V/aMqW9OGESU77Dc+dcAcax
X-Google-Smtp-Source: AGHT+IFmUNRkef1dmntRNjo4uOuH9k6EYkZ1soInusZHTRhHteuj1znyLi8Z53XTbfC0/NC1/uHKew==
X-Received: by 2002:a17:906:c145:b0:aca:c7c5:f935 with SMTP id a640c23a62f3a-acb42c9099dmr86528766b.61.1744794016347;
        Wed, 16 Apr 2025 02:00:16 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:d39e])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f45bc75b4fsm3378097a12.18.2025.04.16.02.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 02:00:15 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing 5/5] examples: add a zcrx example
Date: Wed, 16 Apr 2025 10:01:17 +0100
Message-ID: <9bdd5da3c77ca6229fdeb6949fa1f92180cc8a0c.1744793980.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1744793980.git.asml.silence@gmail.com>
References: <cover.1744793980.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Copy-pasted from selftests/.../iou_zcrx.c by David and brushed up on
top.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/Makefile |   1 +
 examples/zcrx.c   | 335 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 336 insertions(+)
 create mode 100644 examples/zcrx.c

diff --git a/examples/Makefile b/examples/Makefile
index 7b740ca9..47bdfbf3 100644
--- a/examples/Makefile
+++ b/examples/Makefile
@@ -32,6 +32,7 @@ example_srcs := \
 	send-zerocopy.c \
 	rsrc-update-bench.c \
 	proxy.c \
+	zcrx.c \
 	kdigest.c
 
 all_targets :=
diff --git a/examples/zcrx.c b/examples/zcrx.c
new file mode 100644
index 00000000..8393cfe3
--- /dev/null
+++ b/examples/zcrx.c
@@ -0,0 +1,335 @@
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
+#include <stdarg.h>
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
+#include "liburing.h"
+#include "helpers.h"
+
+#define PAGE_SIZE (4096)
+#define AREA_SIZE (8192 * PAGE_SIZE)
+#define SEND_SIZE (512 * 4096)
+
+static int cfg_port = 8000;
+static const char *cfg_ifname;
+static int cfg_queue_id = -1;
+static bool cfg_oneshot;
+static int cfg_oneshot_recvs;
+static bool cfg_verify_data = false;
+static struct sockaddr_in6 cfg_addr;
+
+static void *area_ptr;
+static void *ring_ptr;
+static size_t ring_size;
+static struct io_uring_zcrx_rq rq_ring;
+static unsigned long area_token;
+static int connfd;
+static bool stop;
+static size_t received;
+static __u32 zcrx_id;
+
+static inline size_t get_refill_ring_size(unsigned int rq_entries)
+{
+	ring_size = rq_entries * sizeof(struct io_uring_zcrx_rqe);
+	/* add space for the header (head/tail/etc.) */
+	ring_size += PAGE_SIZE;
+	return T_ALIGN_UP(ring_size, 4096);
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
+		t_error(1, 0, "bad interface name: %s", cfg_ifname);
+
+	area_ptr = mmap(NULL,
+			AREA_SIZE,
+			PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE,
+			0,
+			0);
+	if (area_ptr == MAP_FAILED)
+		t_error(1, 0, "mmap(): zero copy area");
+
+	ring_size = get_refill_ring_size(rq_entries);
+	ring_ptr = mmap(NULL,
+			ring_size,
+			PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE,
+			0,
+			0);
+	if (ring_ptr == MAP_FAILED)
+		t_error(1, 0, "mmap(): refill ring");
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
+		t_error(1, 0, "io_uring_register_ifq(): %d", ret);
+
+	rq_ring.khead = (unsigned int *)((char *)ring_ptr + reg.offsets.head);
+	rq_ring.ktail = (unsigned int *)((char *)ring_ptr + reg.offsets.tail);
+	rq_ring.rqes = (struct io_uring_zcrx_rqe *)((char *)ring_ptr + reg.offsets.rqes);
+	rq_ring.rq_tail = 0;
+	rq_ring.ring_entries = reg.rq_entries;
+
+	zcrx_id = reg.zcrx_id;
+	area_token = area_reg.rq_area_token;
+}
+
+static void add_accept(struct io_uring *ring, int sockfd)
+{
+	struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
+
+	io_uring_prep_accept(sqe, sockfd, NULL, NULL, 0);
+	sqe->user_data = 1;
+}
+
+static void add_recvzc(struct io_uring *ring, int sockfd)
+{
+	struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
+
+	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, sockfd, NULL, 0, 0);
+	sqe->ioprio |= IORING_RECV_MULTISHOT;
+	sqe->zcrx_ifq_idx = zcrx_id;
+	sqe->user_data = 2;
+}
+
+static void add_recvzc_oneshot(struct io_uring *ring, int sockfd, size_t len)
+{
+	struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
+
+	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, sockfd, NULL, len, 0);
+	sqe->ioprio |= IORING_RECV_MULTISHOT;
+	sqe->zcrx_ifq_idx = zcrx_id;
+	sqe->user_data = 2;
+}
+
+static void process_accept(struct io_uring *ring, struct io_uring_cqe *cqe)
+{
+	if (cqe->res < 0)
+		t_error(1, 0, "accept()");
+	if (connfd)
+		t_error(1, 0, "Unexpected second connection");
+
+	connfd = cqe->res;
+	if (cfg_oneshot)
+		add_recvzc_oneshot(ring, connfd, PAGE_SIZE);
+	else
+		add_recvzc(ring, connfd);
+}
+
+static void verify_data(char *data, size_t size, unsigned long seq)
+{
+	int i;
+
+	if (!cfg_verify_data)
+		return;
+
+	for (i = 0; i < size; i++) {
+		char expected = 'a' + (seq + i) % 26;
+
+		if (data[i] != expected)
+			t_error(1, 0, "payload mismatch at %i", i);
+	}
+}
+
+static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
+{
+	unsigned rq_mask = rq_ring.ring_entries - 1;
+	struct io_uring_zcrx_cqe *rcqe;
+	struct io_uring_zcrx_rqe *rqe;
+	uint64_t mask;
+	char *data;
+
+	if (cqe->res < 0)
+		t_error(1, 0, "recvzc(): %d", cqe->res);
+
+	if (cqe->res == 0 && cqe->flags == 0 && cfg_oneshot_recvs == 0) {
+		stop = true;
+		return;
+	}
+
+	if (cfg_oneshot) {
+		if (cqe->res == 0 && cqe->flags == 0 && cfg_oneshot_recvs) {
+			add_recvzc_oneshot(ring, connfd, PAGE_SIZE);
+			cfg_oneshot_recvs--;
+		}
+	} else if (!(cqe->flags & IORING_CQE_F_MORE)) {
+		add_recvzc(ring, connfd);
+	}
+
+	rcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
+	mask = (1ULL << IORING_ZCRX_AREA_SHIFT) - 1;
+	data = (char *)area_ptr + (rcqe->off & mask);
+
+	verify_data(data, cqe->res, received);
+	received += cqe->res;
+
+	/* processed, return back to the kernel */
+	rqe = &rq_ring.rqes[rq_ring.rq_tail & rq_mask];
+	rqe->off = (rcqe->off & ~IORING_ZCRX_AREA_MASK) | area_token;
+	rqe->len = cqe->res;
+	io_uring_smp_store_release(rq_ring.ktail, ++rq_ring.rq_tail);
+}
+
+static void server_loop(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	unsigned int head, count = 0;
+
+	io_uring_submit_and_wait(ring, 1);
+
+	io_uring_for_each_cqe(ring, head, cqe) {
+		if (cqe->user_data == 1)
+			process_accept(ring, cqe);
+		else if (cqe->user_data == 2)
+			process_recvzc(ring, cqe);
+		else
+			t_error(1, 0, "unknown cqe");
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
+
+	fd = socket(AF_INET6, SOCK_STREAM, 0);
+	if (fd == -1)
+		t_error(1, 0, "socket()");
+
+	enable = 1;
+	ret = setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(int));
+	if (ret < 0)
+		t_error(1, 0, "setsockopt(SO_REUSEADDR)");
+
+	ret = bind(fd, (struct sockaddr *)&cfg_addr, sizeof(cfg_addr));
+	if (ret < 0)
+		t_error(1, 0, "bind()");
+
+	if (listen(fd, 1024) < 0)
+		t_error(1, 0, "listen()");
+
+	flags |= IORING_SETUP_COOP_TASKRUN;
+	flags |= IORING_SETUP_SINGLE_ISSUER;
+	flags |= IORING_SETUP_DEFER_TASKRUN;
+	flags |= IORING_SETUP_SUBMIT_ALL;
+	flags |= IORING_SETUP_CQE32;
+
+	ret = io_uring_queue_init(512, &ring, flags);
+	if (ret)
+		t_error(1, ret, "ring init failed");
+
+	setup_zcrx(&ring);
+	add_accept(&ring, fd);
+
+	while (!stop)
+		server_loop(&ring);
+}
+
+static void usage(const char *filepath)
+{
+	t_error(1, 0, "Usage: %s (-4|-6) -p<port> -i<ifname> -q<rxq_id>", filepath);
+}
+
+static void parse_opts(int argc, char **argv)
+{
+	struct sockaddr_in6 *addr6 = (void *) &cfg_addr;
+	int c;
+
+	if (argc <= 1)
+		usage(argv[0]);
+
+	while ((c = getopt(argc, argv, "vp:i:q:o:")) != -1) {
+		switch (c) {
+		case 'p':
+			cfg_port = strtoul(optarg, NULL, 0);
+			break;
+		case 'i':
+			cfg_ifname = optarg;
+			break;
+		case 'o': {
+			cfg_oneshot = true;
+			cfg_oneshot_recvs = strtoul(optarg, NULL, 0);
+			break;
+		}
+		case 'q':
+			cfg_queue_id = strtoul(optarg, NULL, 0);
+			break;
+		case 'v':
+			cfg_verify_data = true;
+			break;
+		}
+	}
+
+	memset(addr6, 0, sizeof(*addr6));
+	addr6->sin6_family = AF_INET6;
+	addr6->sin6_port = htons(cfg_port);
+	addr6->sin6_addr = in6addr_any;
+}
+
+int main(int argc, char **argv)
+{
+	parse_opts(argc, argv);
+	run_server();
+	return 0;
+}
-- 
2.48.1


