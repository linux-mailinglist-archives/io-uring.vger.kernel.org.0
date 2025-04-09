Return-Path: <io-uring+bounces-7448-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 01775A82E14
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 19:57:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BA6619E7481
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 17:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B46A7276046;
	Wed,  9 Apr 2025 17:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GtUI42Bc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1904270ECE
	for <io-uring@vger.kernel.org>; Wed,  9 Apr 2025 17:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744221463; cv=none; b=nkT8eHkzfhxeCdpyuIvyqgVzSvNfJ2dGXH7PGhX83AI1DaDC6SROB0tsG4v3iEzQg7m6omU0NM1uUFt8ONzGbwQDXblMcx/yAdUelUEQvG1PG2CWxneeyNIxFxCLGmjsrKV4f5pG9j6a9BSk6M4M4SiKLEVSc0o4vI3He5QC0yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744221463; c=relaxed/simple;
	bh=eoyBxtKFZcOYZy7vQa5UN3e2SEODGR1CnE7gCljp/PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2U6GTmjza3Lp8zxtx8D06hwxzlLeNtiMDJz0QATd6zNXSKfqjyyQYXQwU6IpQjry3HgdP7+8eo08q7SMwD9SAZ0XI/Gj2Sytn9oIGRem3sglFF88GBkWeXzyvY9fp9TEMGmWLeRcufJvGuxBVj0Gx811CLswNZGnKGtzUTUEt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GtUI42Bc; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3912fdddf8fso807769f8f.1
        for <io-uring@vger.kernel.org>; Wed, 09 Apr 2025 10:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744221459; x=1744826259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=74hgWduynwV1uLu5AG0yTpfATFAddT5+AqUR5fYeK3Y=;
        b=GtUI42BcjrramkTCBsC+h3nbQlvey/8FTQZgOQptT6gEWE5FeSUkbnB/paEo+9QkWu
         Ns/3SPzKCXcuruKsQHi8FFX7dC+2aWYTxQTLlZkV/zatlXMIL/U0bV3/n0QpSu81L23H
         2uEoZqzenDeutWmJEDP0dtV+Cfu1xOhNkqdRyd5Ql74M1vlmABTxH/x+mX9H+S/ev75K
         FQbbHpT20xtweAAN8SJFXHTYl6MDZEudCoNYCusHasI8gMWhIxcM9uO77U2S7w4t4DuQ
         DA3LRr8rtj/POG3bhtJ/4w1N3RtQJZTFAJem/DgliKQnCJdv9LPSp66MATmTa0Hkzih8
         k2zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744221459; x=1744826259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=74hgWduynwV1uLu5AG0yTpfATFAddT5+AqUR5fYeK3Y=;
        b=bQk2oyfNaMFSXFjyltY/c/1i5ay78/lV6k0zUthy0k8bVhLWLoRv094gQez791NVea
         PGZHKF5BLbklXhK01c4VScr6+Vpbs4Lem8jzCWgtPN8/xuZAqojdobERTZxmBtSXQLN/
         OCZNd2/WVvHmLRRipzcmi/gwswZlB/r6j1LaZFFo6p2dJC5OV+PXIH+uHH5NeTErTFHh
         sNEsEGAdjjt9PkQkWpkti/EQVIUWrz8KERjSZ8jnzbBqRzV6lPH26R12wou6zRPJ4ZDL
         aGvFkfGj8EmcoVkH/nOM7ul6G7phq9+upaHznQFDLhw7ZBEbKUtYCLzI6YC8k4S8Jvq0
         G0Vg==
X-Gm-Message-State: AOJu0YzD8auggdKQXOPapTvEQOiEyvcSjMYl99MWNCohYbVxpfvCgc2U
	awKQuOB2ri4Sfllq86P54kclxBfm6+mMGfENAa2YHqt26xS/3RjX750Iyg==
X-Gm-Gg: ASbGnctcs+F2AWZkCmp/PSWWvY6lIgeQfR65ff3F3CXRiq7HUiuh4WlliWgW94E93t+
	GDCJmgEmt50RUsj2QUqg4JrO6csmdjzwdp3vWyMmb3Ulv2320C5gkSf0V1Cn5hsPvKh0+hg5Rfn
	KRK+VR4xvh+UrOlVosxufZN51aB0FK2UMyGTISBw6/UMwBQAr4xrDq1+y4rVLxbu7w8az44WIfa
	55lBi7mUNUdP3lsIEuwR1xjVR1Cx68AlHdOhtbGm6Fnn21zkwaHh0cg/uKGSPGn9cn9KIZXW5f1
	+CfcwW+LcWK88IHWSyyJz31oEPCMmAm9kUHHfVvN1g35TYBMazlS66RTQhnCJQeU
X-Google-Smtp-Source: AGHT+IHP+e63QRsVaDMBusNk0J2aZ6/5i9viOSFFL3eKT4F6o/BpzkpQjlJAK70PdgXMXDaawgwmUg==
X-Received: by 2002:a05:6000:240b:b0:39c:30d8:32a4 with SMTP id ffacd0b85a97d-39d8e3397cbmr262325f8f.26.1744221459371;
        Wed, 09 Apr 2025 10:57:39 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.84])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39d8938a808sm2291470f8f.53.2025.04.09.10.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 10:57:38 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing 2/2] examples: add a zcrx example
Date: Wed,  9 Apr 2025 18:58:36 +0100
Message-ID: <1d9c7573840a5d1f1ab4f054dadfa68be8820821.1744221361.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1744221361.git.asml.silence@gmail.com>
References: <cover.1744221361.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Copy-pasted from selftests/.../iou_zcrx.c by David.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/Makefile |   1 +
 examples/zcrx.c   | 362 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 363 insertions(+)
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
index 00000000..2ac8af52
--- /dev/null
+++ b/examples/zcrx.c
@@ -0,0 +1,362 @@
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
+
+static void t_error(int status, int errnum, const char *format, ...)
+{
+	va_list args;
+	va_start(args, format);
+
+	vfprintf(stderr, format, args);
+	if (errnum)
+		fprintf(stderr, ": %s", strerror(errnum));
+
+	fprintf(stderr, "\n");
+	va_end(args);
+	exit(status);
+}
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
+
+static inline size_t get_refill_ring_size(unsigned int rq_entries)
+{
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
+static void add_recvzc_oneshot(struct io_uring *ring, int sockfd, size_t len)
+{
+	struct io_uring_sqe *sqe;
+
+	sqe = io_uring_get_sqe(ring);
+
+	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, sockfd, NULL, len, 0);
+	sqe->ioprio |= IORING_RECV_MULTISHOT;
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
+		char expected = 'a' + (received + i) % 26;
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
+	if (cqe->res == 0 && cqe->flags == 0 && cfg_oneshot_recvs == 0) {
+		stop = true;
+		return;
+	}
+
+	if (cqe->res < 0)
+		t_error(1, 0, "recvzc(): %d", cqe->res);
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
+		}
+		case 'v':
+			cfg_verify_data = true;
+			break;
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


