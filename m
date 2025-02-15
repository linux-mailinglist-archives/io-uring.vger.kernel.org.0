Return-Path: <io-uring+bounces-6472-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D15A36BFD
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 05:19:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD7E03AC813
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 04:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A24401624F5;
	Sat, 15 Feb 2025 04:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="jxv3IxL8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779EF158D8B
	for <io-uring@vger.kernel.org>; Sat, 15 Feb 2025 04:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739593144; cv=none; b=rNf0Nq1Gu74F/FnrfJbs6PdU5ObWVz0WA8jM+H+OrI5A8lD5iIzuP+I8OCx0gpZx3NNmD4IzwVBFkEtgkfyYY9bRGPmpc2FgZo0jDA2x2qDUNyvUB34mcszXU22nbt6sP9Yh2ldgkpM16kIDADYOBUNltHXiUPBfdKvpmk2u7xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739593144; c=relaxed/simple;
	bh=hx0Ol2zC53ViGWqkI6U1E08lp17uCfzWySD+Jv53ckc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bv/4GjSmpvvIiDQh3qHLAtClahNTIkyVlJyHydGrQ1pGp08VUiGzEF+xvvFMDB48in83Qj36XkfZ1a5RSchNNHNdYBETnFVbkgey0Zl/EmVc80p3vwh4tB7boGT2YJhpB7D2EilKN2EdqnhbzJyqoATAK38K/QH935sMqwBc5uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=jxv3IxL8; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2fc042c9290so4384978a91.0
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 20:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739593141; x=1740197941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ptPRb7uguGR3+ra0APMzhcXk6fGHS7pif0n+0v0yMKI=;
        b=jxv3IxL8TMri8YSyfdwsVF4hWJu43SrITFgW3sn7Xb9z7WzIQyu7oDDDXSguuxpReo
         rQf/k/Loeq8Ot4dWvX4W0kOVCC651YNrt700+q61gC2MXpJfRqDfl3bUP4pzjGypjqRB
         JYTaNlHVmZe9Jh2xZaYMzSHan1Ruj+l01Z45SjrXwfd3nWeHNp6z+q/mdWxAxU12ZxoV
         qvrdJ0TFje76edkKYPk+cum/Ce7m5lezLZNksAEboEXKYnCrDrPvMIdmBDaUE0UsAEC7
         CB0pCD1bu6jWDW974p00yY9UNq5+MKK+lEl36Nwysdm78HeHaWzwZ7/GBx+H4pd0tPCJ
         sJfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739593141; x=1740197941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ptPRb7uguGR3+ra0APMzhcXk6fGHS7pif0n+0v0yMKI=;
        b=jG0t/AFuX81WPJPelmzNyEgcmEuLLECbc8KD1xJWV4unvKdX4m5rRQPMYf+uQGOmk9
         Pi+aDWG9TATPAUcY9oexrO0txh5sJqporiUeg6tIAKYFBsuh+C8g8SU3Otnt6mdZH88H
         YYFD9OC04nrPpGmxkzKWOQFUXohQ/AfBzUPxYDvHVUj5WDLrkruZz4TYdJ913El6YFXL
         tg2pwb2r3SHOdZAL7rBo4SwE6yXF/LLa4sgQmFwtYRE1ENxNmweIFFfMsQi/ITiq4qAu
         Z/+x/PmDaQpmN06QBpscF/0F2dTnbhtqJ4TrZhiJX2heva9LNkf4YRw8aye9xZpRcRwq
         wnPA==
X-Gm-Message-State: AOJu0YypCzt81XjGAqN6CWP4NoB3ZU/bPmC/F37p6AgxoeuitWEPaCim
	5lQ+pSV93zsON+l1O/Pxcok9e0SpC6tgKVMFQbEReXp3DD6QCFght/evhJLusmQ7/QncYsAYxt0
	p
X-Gm-Gg: ASbGnctDiy2gA3SfzRSZeUJqHM55sczrX0XrpZPRTA50FyU7QVTJQy32z33yG/2+XvY
	6/lITrix1jcAPJIvdu7x9mQCoAhO3brRNQMieKpN/17mjcNiK8R/Fr8Yopt9uu437WCmIMkjMh7
	AmLBa56/j7tzVSmFYdxDQ/YI6GeyKrDVEO8KcfOouoi+LC6+rMIjJj+2wUQvrWxIx5CzyBsYZak
	KyzNpVLSJATh8ZUU/kRU6AGBAqlng3sKCcp2DK9zn2yBoOmbRpFITQ8Goixyrhf+W6xyWDLfWE=
X-Google-Smtp-Source: AGHT+IEhzLeyQDRYi5v2XqVc5pFjjkE7xj6X6K5WWkDFD7XJjZZS5Hi8igUzkyep6rTzUsPZ7nMoLA==
X-Received: by 2002:a17:90b:4c43:b0:2f4:43ce:dcea with SMTP id 98e67ed59e1d1-2fc41045022mr2506869a91.25.1739593141499;
        Fri, 14 Feb 2025 20:19:01 -0800 (PST)
Received: from localhost ([2a03:2880:ff:7::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fc13ad2f20sm3920842a91.23.2025.02.14.20.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 20:19:01 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH liburing v1 3/3] zcrx: add unit test
Date: Fri, 14 Feb 2025 20:18:57 -0800
Message-ID: <20250215041857.2108684-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250215041857.2108684-1-dw@davidwei.uk>
References: <20250215041857.2108684-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tests for registration and a basic recv test. No zero copy is actually
happening but it does test the copy fallback.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 test/Makefile |   1 +
 test/zcrx.c   | 918 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 919 insertions(+)
 create mode 100644 test/zcrx.c

diff --git a/test/Makefile b/test/Makefile
index 64e1480867d4..d92379ad9ed0 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -239,6 +239,7 @@ test_srcs := \
 	wakeup-hang.c \
 	wq-aff.c \
 	xattr.c \
+	zcrx.c \
 	# EOL
 
 # Please keep this list sorted alphabetically.
diff --git a/test/zcrx.c b/test/zcrx.c
new file mode 100644
index 000000000000..d3221d3c2b83
--- /dev/null
+++ b/test/zcrx.c
@@ -0,0 +1,918 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Simple test case showing using send and recv through io_uring
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <arpa/inet.h>
+#include <sys/mman.h>
+#include <sys/socket.h>
+#include <sys/types.h>
+#include <pthread.h>
+#include <net/if.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+static unsigned int ifidx, rxq;
+
+/* the hw rxq must consume 128 of these pages, leaving 4 left */
+#define AREA_PAGES	132
+#define PAGE_SIZE	4096
+#define AREA_SZ		AREA_PAGES * PAGE_SIZE
+#define RQ_ENTRIES	128
+/* this is one more than the # of free pages after filling hw rxq */
+#define LOOP_COUNT	5
+#define DEV_ENV_VAR	"NETIF"
+#define RXQ_ENV_VAR	"NETRXQ"
+#define RING_FLAGS	(IORING_SETUP_DEFER_TASKRUN | \
+			 IORING_SETUP_CQE32 | \
+			 IORING_SETUP_SINGLE_ISSUER)
+
+static char str[] = "iv5t4dl500w7wsrf14fsuq8thptto0z7i2q62z1p8dwrv5u4kaxpqhm2rb7bapddi5gfkh7f9695eh46t2o5yap2y43gstbsq3n90bg1i7zx1m4wojoqbuxhsrw4s4y3sh9qp57ovbaa2o9yaqa7d4to2vak1otvgkoxs5t0ovjbe6roginrjeh906kmjn1289jlho9a1bud02ex4xr3cvfcybpl6axnr117p0aesb3070wlvj91en7tpf8nyb1e";
+
+#define MSG_SIZE 512
+
+#define PORT	10202
+#define HOST	"127.0.0.1"
+
+static int probe_zcrx(void *area)
+{
+	struct io_uring_zcrx_area_reg area_reg = {
+		.addr = (__u64)(unsigned long)area,
+		.len = AREA_SZ,
+		.flags = 0,
+	};
+	struct io_uring_zcrx_ifq_reg reg = {
+		.if_idx = ifidx,
+		.if_rxq = rxq,
+		.rq_entries = RQ_ENTRIES,
+		.area_ptr = (__u64)(unsigned long)&area_reg,
+	};
+	struct io_uring ring;
+	int ret;
+
+	ret = t_create_ring(8, &ring, RING_FLAGS);
+	if (ret == T_SETUP_SKIP) {
+		fprintf(stderr, "required ring flags are not supported, skip\n");
+		return T_EXIT_SKIP;
+	}
+	if (ret) {
+		fprintf(stderr, "probe ring setup failure\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = io_uring_register_ifq(&ring, &reg);
+	if (ret == -EINVAL) {
+		fprintf(stderr, "zcrx is not supported, skip\n");
+		return T_EXIT_SKIP;
+	}
+	if (ret) {
+		fprintf(stderr, "probe zcrx register fail %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+	io_uring_queue_exit(&ring);
+	return T_EXIT_PASS;
+}
+
+static int try_register_ifq(struct io_uring_zcrx_ifq_reg *reg)
+{
+	struct io_uring ring;
+	int ret;
+
+	ret = t_create_ring(8, &ring, RING_FLAGS);
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		exit(T_EXIT_FAIL);
+	}
+
+	ret = io_uring_register_ifq(&ring, reg);
+	io_uring_queue_exit(&ring);
+	return ret;
+}
+
+static int test_invalid_if(void *area)
+{
+	int ret;
+	struct io_uring_zcrx_area_reg area_reg = {
+		.addr = (__u64)(unsigned long)area,
+		.len = AREA_SZ,
+		.flags = 0,
+	};
+	struct io_uring_zcrx_ifq_reg reg = {
+		.if_idx = -1,
+		.if_rxq = rxq,
+		.rq_entries = RQ_ENTRIES,
+		.area_ptr = (__u64)(unsigned long)&area_reg,
+	};
+
+	ret = try_register_ifq(&reg);
+	if (ret != -EINVAL && ret != -ENODEV) {
+		fprintf(stderr, "registered invalid IF %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	reg.if_idx = ifidx;
+	reg.if_rxq = -1;
+
+	ret = try_register_ifq(&reg);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "registered invalid IFQ %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+	return T_EXIT_PASS;
+}
+
+static int test_invalid_ifq_collision(void *area)
+{
+	struct io_uring ring, ring2;
+	struct io_uring_zcrx_area_reg area_reg = {
+		.addr = (__u64)(unsigned long)area,
+		.len = AREA_SZ,
+		.flags = 0,
+	};
+	struct io_uring_zcrx_ifq_reg reg = {
+		.if_idx = ifidx,
+		.if_rxq = rxq,
+		.rq_entries = RQ_ENTRIES,
+		.area_ptr = (__u64)(unsigned long)&area_reg,
+	};
+	int ret;
+
+	ret = t_create_ring(8, &ring, RING_FLAGS);
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+	ret = t_create_ring(8, &ring2, RING_FLAGS);
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "ring2 create failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = io_uring_register_ifq(&ring, &reg);
+	if (ret) {
+		fprintf(stderr, "initial registration failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	/* register taken ifq */
+	ret = io_uring_register_ifq(&ring, &reg);
+	if (!ret) {
+		fprintf(stderr, "registered taken queue\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = io_uring_register_ifq(&ring2, &reg);
+	if (!ret) {
+		fprintf(stderr, "registered taken queue ring2\n");
+		return T_EXIT_FAIL;
+	}
+
+	io_uring_queue_exit(&ring);
+	io_uring_queue_exit(&ring2);
+	return T_EXIT_PASS;
+}
+
+static int test_rq_setup(void *area)
+{
+	int ret;
+	struct io_uring_zcrx_area_reg area_reg = {
+		.addr = (__u64)(unsigned long)area,
+		.len = AREA_SZ,
+		.flags = 0,
+	};
+
+	struct io_uring_zcrx_ifq_reg reg = {
+		.if_idx = ifidx,
+		.if_rxq = rxq,
+		.rq_entries = 0,
+		.area_ptr = (__u64)(unsigned long)&area_reg,
+	};
+
+	ret = try_register_ifq(&reg);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "registered 0 rq entries\n");
+		return T_EXIT_FAIL;
+	}
+
+	reg.rq_entries = (__u32)-1;
+
+	ret = try_register_ifq(&reg);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "registered unlimited nr of rq entries\n");
+		return T_EXIT_FAIL;
+	}
+
+	reg.rq_entries = RQ_ENTRIES - 1;
+	ret = try_register_ifq(&reg);
+	if (ret != 0) {
+		fprintf(stderr, "ifq registration failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	if (reg.rq_entries == RQ_ENTRIES - 1) {
+		fprintf(stderr, "registered non pow2 refill entries %i\n",
+			reg.rq_entries);
+		return T_EXIT_FAIL;
+	}
+
+	return T_EXIT_PASS;
+}
+
+static int test_null_area_reg_struct(void)
+{
+	int ret;
+
+	struct io_uring_zcrx_ifq_reg reg = {
+		.if_idx = ifidx,
+		.if_rxq = rxq,
+		.rq_entries = RQ_ENTRIES,
+		.area_ptr = (__u64)(unsigned long)0,
+	};
+
+	ret = try_register_ifq(&reg);
+	return ret ? T_EXIT_PASS : T_EXIT_FAIL;
+}
+
+static int test_null_area(void)
+{
+	int ret;
+
+	struct io_uring_zcrx_area_reg area_reg = {
+		.addr = (__u64)(unsigned long)0,
+		.len = AREA_SZ,
+		.flags = 0,
+	};
+
+	struct io_uring_zcrx_ifq_reg reg = {
+		.if_idx = ifidx,
+		.if_rxq = rxq,
+		.rq_entries = RQ_ENTRIES,
+		.area_ptr = (__u64)(unsigned long)&area_reg,
+	};
+
+	ret = try_register_ifq(&reg);
+	return ret ? T_EXIT_PASS : T_EXIT_FAIL;
+}
+
+static int test_misaligned_area(void *area)
+{
+	int ret;
+	struct io_uring_zcrx_area_reg area_reg = {
+		.addr = (__u64)(unsigned long)(area + 1),
+		.len = AREA_SZ,
+		.flags = 0,
+	};
+
+	struct io_uring_zcrx_ifq_reg reg = {
+		.if_idx = ifidx,
+		.if_rxq = rxq,
+		.rq_entries = RQ_ENTRIES,
+		.area_ptr = (__u64)(unsigned long)&area_reg,
+	};
+
+	if (!try_register_ifq(&reg))
+		return T_EXIT_FAIL;
+
+	area_reg.addr = (__u64)(unsigned long)area;
+	area_reg.len = AREA_SZ - 1;
+	ret = try_register_ifq(&reg);
+	return ret ? T_EXIT_PASS : T_EXIT_FAIL;
+}
+
+static int test_larger_than_alloc_area(void *area)
+{
+	int ret;
+	struct io_uring_zcrx_area_reg area_reg = {
+		.addr = (__u64)(unsigned long)area,
+		.len = AREA_SZ + 4096,
+		.flags = 0,
+	};
+
+	struct io_uring_zcrx_ifq_reg reg = {
+		.if_idx = ifidx,
+		.if_rxq = rxq,
+		.rq_entries = RQ_ENTRIES,
+		.area_ptr = (__u64)(unsigned long)&area_reg,
+	};
+
+	ret = try_register_ifq(&reg);
+	return ret ? T_EXIT_PASS : T_EXIT_FAIL;
+}
+
+static int test_area_access(void)
+{
+	struct io_uring_zcrx_area_reg area_reg = {
+		.len = AREA_SZ,
+		.flags = 0,
+	};
+	struct io_uring_zcrx_ifq_reg reg = {
+		.if_idx = ifidx,
+		.if_rxq = rxq,
+		.rq_entries = RQ_ENTRIES,
+		.area_ptr = (__u64)(unsigned long)&area_reg,
+	};
+	int i, ret;
+	void *area;
+
+	for (i = 0; i < 2; i++) {
+		int ro = i & 1;
+		int prot = ro ? PROT_READ : PROT_WRITE;
+
+		area = mmap(NULL, AREA_SZ, prot,
+			    MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
+		if (area == MAP_FAILED) {
+			perror("mmap");
+			return T_EXIT_FAIL;
+		}
+
+		area_reg.addr = (__u64)(unsigned long)area;
+
+		ret = try_register_ifq(&reg);
+		if (ret != -EFAULT) {
+			fprintf(stderr, "registered unaccessible memory\n");
+			return T_EXIT_FAIL;
+		}
+
+		munmap(area, AREA_SZ);
+	}
+
+	return T_EXIT_PASS;
+}
+
+static int create_ring_with_ifq(struct io_uring *ring, void *area)
+{
+	struct io_uring_zcrx_area_reg area_reg = {
+		.addr = (__u64)(unsigned long)area,
+		.len = AREA_SZ,
+		.flags = 0,
+	};
+	struct io_uring_zcrx_ifq_reg reg = {
+		.if_idx = ifidx,
+		.if_rxq = rxq,
+		.rq_entries = RQ_ENTRIES,
+		.area_ptr = (__u64)(unsigned long)&area_reg,
+	};
+	int ret;
+
+	ret = t_create_ring(128, ring, RING_FLAGS);
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = io_uring_register_ifq(ring, &reg);
+	if (ret) {
+		io_uring_queue_exit(ring);
+		fprintf(stderr, "ifq register failed %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+	return 0;
+}
+
+static void test_io_uring_prep_zcrx(struct io_uring_sqe *sqe, int fd, int ifq)
+{
+	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, fd, NULL, 0, 0);
+	sqe->zcrx_ifq_idx = ifq;
+	sqe->ioprio |= IORING_RECV_MULTISHOT;
+}
+
+static struct io_uring_cqe *submit_and_wait_one(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	int ret;
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		return NULL;
+	}
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+		return NULL;
+	}
+
+	return cqe;
+}
+
+static int test_invalid_invalid_request(void *area)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct io_uring ring;
+	int ret, fds[2];
+
+	ret = create_ring_with_ifq(&ring, area);
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "ifq-ring create failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = t_create_socket_pair(fds, true);
+	if (ret) {
+		fprintf(stderr, "t_create_socket_pair failed: %d\n", ret);
+		return ret;
+	}
+
+	/* invalid file */
+	sqe = io_uring_get_sqe(&ring);
+	test_io_uring_prep_zcrx(sqe, ring.ring_fd, 0);
+
+	cqe = submit_and_wait_one(&ring);
+	if (!cqe) {
+		fprintf(stderr, "submit_and_wait_one failed\n");
+		return T_EXIT_FAIL;
+	}
+	if (cqe->flags & IORING_CQE_F_MORE) {
+		fprintf(stderr, "unexpected F_MORE for invalid fd\n");
+		return T_EXIT_FAIL;
+	}
+	if (cqe->res != -ENOTSOCK) {
+		fprintf(stderr, "zcrx for non-socket file\n");
+		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	/* invalid ifq idx */
+	sqe = io_uring_get_sqe(&ring);
+	test_io_uring_prep_zcrx(sqe, fds[0], 1);
+
+	cqe = submit_and_wait_one(&ring);
+	if (!cqe) {
+		fprintf(stderr, "submit_and_wait_one failed\n");
+		return T_EXIT_FAIL;
+	}
+	if (cqe->flags & IORING_CQE_F_MORE) {
+		fprintf(stderr, "unexpected F_MORE for invalid fd\n");
+		return T_EXIT_FAIL;
+	}
+	if (cqe->res != -EINVAL) {
+		fprintf(stderr, "zcrx recv with non-existent zcrx ifq\n");
+		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	close(fds[0]);
+	close(fds[1]);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+struct recv_data {
+	pthread_barrier_t connect;
+	pthread_barrier_t startup;
+	pthread_barrier_t barrier;
+	pthread_barrier_t finish;
+
+	int accept_fd;
+	char buf[MSG_SIZE];
+	void *area;
+	void *ring_ptr;
+	unsigned int ring_sz;
+	struct io_uring_zcrx_rq rq_ring;
+};
+
+static int recv_prep(struct io_uring *ring, struct recv_data *rd, int *sock)
+{
+	struct sockaddr_in saddr;
+	struct io_uring_sqe *sqe;
+	int sockfd, ret, val, use_fd;
+	socklen_t socklen;
+
+	memset(&saddr, 0, sizeof(saddr));
+	saddr.sin_family = AF_INET;
+	saddr.sin_addr.s_addr = htonl(INADDR_ANY);
+	saddr.sin_port = htons(PORT);
+
+	sockfd = socket(AF_INET, SOCK_STREAM, 0);
+	if (sockfd < 0) {
+		perror("socket");
+		return 1;
+	}
+
+	val = 1;
+	setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
+
+	ret = bind(sockfd, (struct sockaddr *)&saddr, sizeof(saddr));
+	if (ret < 0) {
+		perror("bind");
+		goto err;
+	}
+
+	ret = listen(sockfd, 1);
+	if (ret < 0) {
+		perror("listen");
+		goto err;
+	}
+
+	pthread_barrier_wait(&rd->connect);
+
+	socklen = sizeof(saddr);
+	use_fd = accept(sockfd, (struct sockaddr *)&saddr, &socklen);
+	if (use_fd < 0) {
+		perror("accept");
+		goto err;
+	}
+
+	rd->accept_fd = use_fd;
+	pthread_barrier_wait(&rd->startup);
+	pthread_barrier_wait(&rd->barrier);
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, use_fd, NULL, 0, 0);
+	sqe->zcrx_ifq_idx = 0;
+	sqe->ioprio |= IORING_RECV_MULTISHOT;
+	sqe->user_data = 2;
+
+	ret = io_uring_submit(ring);
+	if (ret <= 0) {
+		fprintf(stderr, "submit failed: %d\n", ret);
+		goto err;
+	}
+
+	*sock = sockfd;
+	return 0;
+err:
+	close(sockfd);
+	return 1;
+}
+
+static struct io_uring_zcrx_rqe* get_refill_entry(struct io_uring_zcrx_rq *rq_ring)
+{
+	unsigned mask = rq_ring->ring_entries - 1;
+	struct io_uring_zcrx_rqe* rqe;
+
+	rqe = &rq_ring->rqes[rq_ring->rq_tail & mask];
+	rq_ring->rq_tail++;
+	return rqe;
+}
+
+static void refill_garbage(struct recv_data *rd, uint64_t area_token)
+{
+	struct io_uring_zcrx_rq *rq_ring = &rd->rq_ring;
+	struct io_uring_zcrx_rqe* rqe;
+	int i = 0;
+
+	/* invalid area */
+	rqe = get_refill_entry(rq_ring);
+	rqe->off = (area_token + 1) << IORING_ZCRX_AREA_SHIFT;
+	i++;
+
+	/* invalid area offset */
+	rqe = get_refill_entry(rq_ring);
+	rqe->off = AREA_SZ | (area_token << IORING_ZCRX_AREA_SHIFT);
+	rqe->off += AREA_SZ;
+	i++;
+
+	for (; i < rq_ring->ring_entries; i++) {
+		rqe = get_refill_entry(rq_ring);
+		rqe->off = ((uint64_t)1 << IORING_ZCRX_AREA_SHIFT) - 1;
+	}
+
+	io_uring_smp_store_release(rq_ring->ktail, rq_ring->rq_tail);
+}
+
+static int do_recv(struct io_uring *ring, struct recv_data *rd,
+		   uint64_t refill_area_token)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_zcrx_cqe *zcqe;
+	int i, ret;
+
+	refill_garbage(rd, refill_area_token);
+
+	for (i = 0; i < LOOP_COUNT - 1; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret) {
+			fprintf(stdout, "wait_cqe: %d\n", ret);
+			return 1;
+		}
+		if (cqe->res == -EINVAL) {
+			fprintf(stdout, "recv not supported, skipping\n");
+			goto out;
+		}
+		if (cqe->res < 0) {
+			fprintf(stderr, "failed recv cqe: %d\n", cqe->res);
+			goto err;
+		}
+		if (cqe->res - 1 != strlen(str)) {
+			fprintf(stderr, "got wrong length: %d/%d\n", cqe->res,
+								(int) strlen(str) + 1);
+			goto err;
+		}
+
+		zcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
+		uint64_t mask = (1ULL << IORING_ZCRX_AREA_SHIFT) - 1;
+		uint64_t off = zcqe->off & mask;
+		void *addr = (char *)rd->area + off;
+		ret = strncmp(str, addr, sizeof(str));
+		if (ret != 0) {
+			fprintf(stderr, "recv incorrect payload: %s\n", (const char *)addr);
+			goto err;
+		}
+
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stdout, "wait_cqe: %d\n", ret);
+		return 1;
+	}
+	if (cqe->res != -ENOMEM) {
+		fprintf(stdout, "final recv cqe did not return ENOMEM\n");
+		goto err;
+	}
+
+out:
+	io_uring_cqe_seen(ring, cqe);
+	pthread_barrier_wait(&rd->finish);
+	return 0;
+err:
+	io_uring_cqe_seen(ring, cqe);
+	pthread_barrier_wait(&rd->finish);
+	return 1;
+}
+
+static void *recv_fn(void *data)
+{
+	struct recv_data *rd = data;
+	struct io_uring_params p = { };
+	struct io_uring ring;
+	int ret, sock;
+
+	p.flags = RING_FLAGS;
+	ret = t_create_ring_params(8, &ring, &p);
+	if (ret == T_SETUP_SKIP) {
+		ret = 0;
+		goto err;
+	} else if (ret < 0) {
+		goto err;
+	}
+
+	struct io_uring_zcrx_area_reg area_reg = {
+		.addr = (__u64)(unsigned long)rd->area,
+		.len = AREA_SZ,
+		.flags = 0,
+	};
+
+	struct io_uring_zcrx_ifq_reg reg = {
+		.if_idx = ifidx,
+		.if_rxq = rxq,
+		.rq_entries = RQ_ENTRIES,
+		.area_ptr = (__u64)(unsigned long)&area_reg,
+	};
+
+	ret = io_uring_register_ifq(&ring, &reg);
+	if (ret != 0) {
+		fprintf(stderr, "register_ifq failed: %d\n", ret);
+		goto err_ring_exit;
+	}
+
+	/*
+	rd->ring_ptr = mmap(
+		0,
+		reg.offsets.mmap_sz,
+		PROT_READ | PROT_WRITE,
+		MAP_SHARED | MAP_POPULATE,
+		ring.enter_ring_fd,
+		IORING_OFF_RQ_RING
+	);
+
+	rd->ring_sz = reg.offsets.mmap_sz;
+	*/
+	rd->rq_ring.khead = (__u32*)((char*)rd->ring_ptr + reg.offsets.head);
+	rd->rq_ring.ktail = (__u32*)((char*)rd->ring_ptr + reg.offsets.tail);
+	rd->rq_ring.rqes = (struct io_uring_zcrx_rqe*)((char*)rd->ring_ptr + reg.offsets.rqes);
+	rd->rq_ring.rq_tail = 0;
+	rd->rq_ring.ring_entries = reg.rq_entries;
+
+	ret = recv_prep(&ring, rd, &sock);
+	if (ret) {
+		fprintf(stderr, "recv_prep failed: %d\n", ret);
+		goto err;
+	}
+	ret = do_recv(&ring, rd, area_reg.rq_area_token);
+
+	close(sock);
+	close(rd->accept_fd);
+err_ring_exit:
+	io_uring_queue_exit(&ring);
+err:
+	return (void *)(intptr_t)ret;
+}
+
+static int do_send(struct recv_data *rd)
+{
+	struct sockaddr_in saddr;
+	struct iovec iov = {
+		.iov_base = str,
+		.iov_len = sizeof(str),
+	};
+	struct io_uring ring;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int i, sockfd, ret;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue init failed: %d\n", ret);
+		return 1;
+	}
+
+	memset(&saddr, 0, sizeof(saddr));
+	saddr.sin_family = AF_INET;
+	saddr.sin_port = htons(PORT);
+	inet_pton(AF_INET, HOST, &saddr.sin_addr);
+
+	sockfd = socket(AF_INET, SOCK_STREAM, 0);
+	if (sockfd < 0) {
+		perror("socket");
+		goto err2;
+	}
+
+	pthread_barrier_wait(&rd->connect);
+
+	ret = connect(sockfd, (struct sockaddr *)&saddr, sizeof(saddr));
+	if (ret < 0) {
+		perror("connect");
+		goto err;
+	}
+
+	pthread_barrier_wait(&rd->startup);
+
+	for (i = 0; i < LOOP_COUNT; i++) {
+		sqe = io_uring_get_sqe(&ring);
+		io_uring_prep_send(sqe, sockfd, iov.iov_base, iov.iov_len, 0);
+		sqe->user_data = 1;
+	}
+
+	ret = io_uring_submit(&ring);
+	if (ret <= 0) {
+		fprintf(stderr, "submit failed: %d\n", ret);
+		goto err;
+	}
+
+	pthread_barrier_wait(&rd->barrier);
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (cqe->res == -EINVAL) {
+		fprintf(stdout, "send not supported, skipping\n");
+		goto err;
+	}
+	if (cqe->res != iov.iov_len) {
+		fprintf(stderr, "failed cqe: %d\n", cqe->res);
+		goto err;
+	}
+
+	pthread_barrier_wait(&rd->finish);
+
+	close(sockfd);
+	io_uring_queue_exit(&ring);
+	return 0;
+
+err:
+	close(sockfd);
+err2:
+	io_uring_queue_exit(&ring);
+	pthread_barrier_wait(&rd->finish);
+	return 1;
+}
+
+static int test_recv(void *area)
+{
+	pthread_t recv_thread;
+	struct recv_data rd;
+	int ret;
+	void *retval;
+
+	memset(&rd, 0, sizeof(rd));
+	pthread_barrier_init(&rd.connect, NULL, 2);
+	pthread_barrier_init(&rd.startup, NULL, 2);
+	pthread_barrier_init(&rd.barrier, NULL, 2);
+	pthread_barrier_init(&rd.finish, NULL, 2);
+	rd.area = area;
+
+	ret = pthread_create(&recv_thread, NULL, recv_fn, &rd);
+	if (ret) {
+		fprintf(stderr, "Thread create failed: %d\n", ret);
+		return 1;
+	}
+
+	do_send(&rd);
+	pthread_join(recv_thread, &retval);
+	return (intptr_t)retval;
+}
+
+int main(int argc, char *argv[])
+{
+	char *dev, *rxq_str, *rxq_end;
+	void *area_outer, *area;
+	int ret;
+
+	if (argc > 1)
+		return 0;
+
+	area_outer = mmap(NULL, AREA_SZ + 8192, PROT_NONE,
+		MAP_ANONYMOUS | MAP_PRIVATE | MAP_NORESERVE, -1, 0);
+	if (area_outer == MAP_FAILED) {
+		perror("mmap");
+		return T_EXIT_FAIL;
+	}
+
+	area = mmap(area_outer, AREA_SZ, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (area == MAP_FAILED) {
+		perror("mmap");
+		return T_EXIT_FAIL;
+	}
+
+	dev = getenv(DEV_ENV_VAR);
+	if (!dev)
+		return T_EXIT_SKIP;
+
+	ifidx = if_nametoindex(dev);
+	if (!ifidx)
+		return T_EXIT_SKIP;
+
+	rxq_str = getenv(RXQ_ENV_VAR);
+	if (!rxq_str)
+		return T_EXIT_SKIP;
+
+	rxq = strtol(rxq_str, &rxq_end, 10);
+	if (rxq_end == rxq_str || *rxq_end != '\0')
+		return T_EXIT_SKIP;
+
+	ret = probe_zcrx(area);
+	if (ret != T_EXIT_PASS)
+		return ret;
+
+	ret = test_rq_setup(area);
+	if (ret) {
+		fprintf(stderr, "test_invalid_reg_struct failed\n");
+		return ret;
+	}
+
+	ret = test_null_area_reg_struct();
+	if (ret) {
+		fprintf(stderr, "test_null_area_reg_struct failed\n");
+		return ret;
+	}
+
+	ret = test_null_area();
+	if (ret) {
+		fprintf(stderr, "test_null_area failed\n");
+		return ret;
+	}
+
+	ret = test_misaligned_area(area);
+	if (ret) {
+		fprintf(stderr, "test_misaligned_area failed\n");
+		return ret;
+	}
+
+	ret = test_larger_than_alloc_area(area);
+	if (ret) {
+		fprintf(stderr, "test_larger_than_alloc_area failed\n");
+		return ret;
+	}
+
+	ret = test_area_access();
+	if (ret) {
+		fprintf(stderr, "test_area_access failed\n");
+		return ret;
+	}
+
+	ret = test_invalid_if(area);
+	if (ret) {
+		fprintf(stderr, "test_invalid_if failed\n");
+		return ret;
+	}
+
+	ret = test_invalid_ifq_collision(area);
+	if (ret) {
+		fprintf(stderr, "test_invalid_ifq_collision failed\n");
+		return ret;
+	}
+
+	ret = test_invalid_invalid_request(area);
+	if (ret) {
+		fprintf(stderr, "test_invalid_ifq_collision failed\n");
+		return ret;
+	}
+
+	ret = test_recv(area);
+	if (ret) {
+		fprintf(stderr, "test_recv failed\n");
+		return ret;
+	}
+
+	munmap(area, AREA_SZ);
+	return 0;
+}
-- 
2.43.5


