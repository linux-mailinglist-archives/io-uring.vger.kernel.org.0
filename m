Return-Path: <io-uring+bounces-6526-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A580A3AB6C
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 23:02:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B90243A8798
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 22:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D09B1C701B;
	Tue, 18 Feb 2025 22:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="gPz4s2CO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB351D5CD3
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 22:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739916107; cv=none; b=O5SvAw6wUj9+LqLTzaOwAiZbgyc9+IjLv6giNZWNOx6dPpr6YUuu5YedPdk6wowuCgol23d9gHPPv/Kx5J+mTZtToTeZSaOEx2WG76LluuqnOq61a3GrYy3/8oOJoLMIzX+aFAe1O4J8kUcRzcflbHUXukekKoMogBZZqh57zcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739916107; c=relaxed/simple;
	bh=hx0Ol2zC53ViGWqkI6U1E08lp17uCfzWySD+Jv53ckc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNdH3SXaYV2goUuZGZHoBYgkfWH9whc6laUqIAnaIuBv6DQaOitCnRRdsZ2UnKjbUvBTvpNRapCozfP4ffJF1PROSKVbI5dvZ1ZGYqrzys7Qyyv1sZ9hOPUvFtm+Iny6AdUnwlzS2Ki29dWYcavD50lC89PSjdBjEiKA1lVFrJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=gPz4s2CO; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22114b800f7so57412445ad.2
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 14:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739916105; x=1740520905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ptPRb7uguGR3+ra0APMzhcXk6fGHS7pif0n+0v0yMKI=;
        b=gPz4s2COSHZbaubiMVzKl3FCaeSHv0Y7EGBeDXFTREEyET9HN9uxY6+ZqFAfA372nY
         l2dH35uk8cHrB7U5WK5udWAigj14KuRNxMB1FRlalohLtLfEIh68Yo2reVEqa2PfWHY3
         YkaMbC3245kKU8tHRgSGCry5SBtu4+wZtFFE4xFX3+V9dekefWpSkJt7ZAUMrsCI4UMC
         nfIkTAYP9hlZqCcvLcYqk/xOb5j5GYOBiicTkUBZ6QyW+Poh+HOh/uthxltbqzBVHuYE
         XpGgKX1rhGUVDguhO8onmQ81Mi+haX3SmHg8LlsEoKxdCQF3qERe/fe3PN+Z6CTMse0t
         NGBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739916105; x=1740520905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ptPRb7uguGR3+ra0APMzhcXk6fGHS7pif0n+0v0yMKI=;
        b=jwEqd8dOfRCwxfpz6//y9htTbnzvGGHfXzPuy6z/ejsR5PxQQq38zl+OAXupUd079A
         Hnc9iHuj+GRQmNKfv9gSonzccESySQgx1onJYB6MeWZvgCZSnJaos5dGIvcUl9+x3xcP
         DGBQ2UGGnUGE2Gbq+6xPi887Imwss/gDvzqYeXhdyHuBzY5fRvCaH5LPsS8GURDInJgR
         wSPA+D8cvqxJseboPEKtepw5tUH3kkE2OgLyjNIQ4bj6tu3E8ziDTRoJA+eRaE4lE8iz
         vQ8oDj4gsdhZXoWtUXOBKq/9gCKgwMeCsRBfwHvuw9iW1mq+S2WMEdnY5r4s8MC9RgC4
         xs/w==
X-Gm-Message-State: AOJu0YwMDvwxF6pcMPEitoggj5xrelDl3OXaY9OwEzwQPERcuLP9Ogu9
	exJ6pNPjSH14tKn/4sdswTyxeiPgqmKpxbysX5os0SHxUKWuzNfcQ2jSv/jQIdBc1eITJgyFL5k
	W
X-Gm-Gg: ASbGnctbJRk5aE60d4YQ+duVQR+uFNgBnK0lA6DKKcHtCVyEj5aGMWuxAvMvZnT4y2s
	uS+pbK4ET5cUtN6mGW6LSxEP7qXKJY5ac7w48KGX0tmkuehPefUlkuWeblWZqAym1Zek8ZdX0qJ
	vvNyA5c2IONbcxv1j/VfWoF5fyqBahr5OV70Q6elkWBrtYgzr6h7ff90wn04o2ozXg53blV9E25
	fUy2fxCdHWaZBwpv3bA98FHklWyqP7CA54FYLsp02H4n2Y7XapOZNzwji/H8ITBPRV8RJIoQMgy
X-Google-Smtp-Source: AGHT+IHYL19PJ4GFVZf2DQQxoKrsQN68oGJessiHsM+2OZG2wO+ChD7idgctGrlB+WLyOvrd5asBVA==
X-Received: by 2002:a17:902:ccca:b0:220:e362:9b1a with SMTP id d9443c01a7336-22170987b55mr18615455ad.25.1739916104643;
        Tue, 18 Feb 2025 14:01:44 -0800 (PST)
Received: from localhost ([2a03:2880:ff:13::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d545cff5sm92034245ad.125.2025.02.18.14.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 14:01:44 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH liburing v2 4/4] zcrx: add unit test
Date: Tue, 18 Feb 2025 14:01:36 -0800
Message-ID: <20250218220136.2238838-5-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250218220136.2238838-1-dw@davidwei.uk>
References: <20250218220136.2238838-1-dw@davidwei.uk>
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


