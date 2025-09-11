Return-Path: <io-uring+bounces-9737-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8E7BB53051
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 13:27:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2059FA071F5
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 11:26:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA7831B131;
	Thu, 11 Sep 2025 11:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BVbpo2ET"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BB0314B75
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 11:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757589912; cv=none; b=fKh6MUFtDnOfpaxcyat1iCukGXyRm/YxaJmkPCePi5D0xsXiNjQxILQhzaiabQQduDxLNPcEeVK7ld+a6MhL7AKkuvDoipFjs0F/I0pKEDE95HmtO/VIgyoOaDIfqfdIOoWWEn/WJRlrbHkaMaAuDSUYfOh7ss6UROP2LjMx0nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757589912; c=relaxed/simple;
	bh=tTSf8G9SgjRoGh5WNPU7AYrLPSkBsdIso8HlcDKTCbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIG9SNoX88nFGPHPpgm80grrW+d9NRh5fKsCRSSX9N7peZA/IJpmhkDihIyMIUbGidEFiSpOZ2IDvFtSs7Wp5gtCFbiYzwznWjGJYfak6eVk5Pv+nca+4tJR0kaLQffvq5ucZgDRF0Wa/a7EFPJ7QfyW9129eY75nbfeqRb6v6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BVbpo2ET; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45df7cb7f6bso2590055e9.3
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 04:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757589908; x=1758194708; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NY5lnAhO4Pm3HVgbLRrmMUQyS5Jy55TygX+avhIQNsw=;
        b=BVbpo2ET1EyqUXD1/f+hqoIaPBECVsYQOYq+ZIiilUp/joxNEgSNlhTwwt2zrzc9ej
         pE9q2lHThezSxfJWaYrsWzZ6jk6GGwp781Cc3wT9Roy2yyox2S4nUBJzDnU4ZJPXHPLg
         3lPDgsJouqRRVX+jzKDa8hMN8owJ6ZNbgUbeXhiZcB/KqG+aUaQsSpCVb4lTU2L+wVNg
         DGFTMWcb+rVjEDMBVOGr1Q+m+Wvq3UaleqsrXItLAD9BH5RMJO7UvQ0Y2VvVi35pBa4n
         g5TzdjRDjxhhr77vwiOSMN2qHS4/GwYUIG6A3AATesJaw0eJytDlcrW7OkrfqCxFjvjj
         r6pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757589908; x=1758194708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NY5lnAhO4Pm3HVgbLRrmMUQyS5Jy55TygX+avhIQNsw=;
        b=hTJ5l5cBeIEh/G0qeF2vyk+y4Qu/HS9XeuYwjZ1nBATjkTaw9IW6XxPCFq9By74xOg
         UoI+BFVUfiJz2F/PTqtr5ioW+syVtfmVeK1cZB/s70mZKpVftQOsIcQXQhEQTAGpvsae
         RiJiglAayZlU3khECnm9IWYhe68pZeuIQb9b5wSmiVNW7zSz8vjiA2PCTWDUAJDC05NK
         vgHk234Pu3W5VaxJoPH6HKkFuEMiJcxshrQ8/cHswTYae5oFf8iPwqru3d8IBAZ336ex
         /+BQCSZqvED3ho72Z3gRcQerms/VmyUkRiGFfFxM/ziul2ryM4njmXpU71/Y8NUpqWht
         uVNw==
X-Gm-Message-State: AOJu0YwHVXw+scZ9KYlYl6Hq3uyYRBz1jW3OARqlBaZKsy6Nf1CIjCIq
	Fl5+M5Twn9/61zOAp0l/ztTtf8rF1YXt9YOHcZRvqK0MlSyrYSrmGr/zg4fkow==
X-Gm-Gg: ASbGncsndbrckVzvs/cP/wDh1gmAjbiG2Jpl+PPux1NAF/O55znqZeiFtEcVEjidPQj
	8GRJh8e+9mgNnj4uZcSGjmTE+YmhSQVxBfsq2CYSffLPMOdo79wL01JsE5ojC77W+4o5maqdYvB
	P9mzOf/fPjfGhTRKvK+ZdJQhi8ZusBBBfp/b1Y5oaoqwDiiDV2+QJa/BNEcw/BCBFa2GCp2YIBx
	eFN9TYTgylJ8YlB4DGdyUduKuk6d1ZjISN7Syp8SVz0SpVZa1IgCAtDKIEXFG9kDdVG64AEjJ77
	nNID+MvacC2rEpIZ3A1R/qnlmhnhmM70eJ2ufL3L0dH6nOdmzqqjIErisW0WuVdSk++jpPQclm5
	fH3ityg==
X-Google-Smtp-Source: AGHT+IGMHcOwZumhzM4UOpA8ZE1bWxINHSzrc04ntRrsRZ9Oxfnm+7XRuR2UYVPNZ2A+ArbYN68Tbg==
X-Received: by 2002:a05:600c:4fc5:b0:456:1204:e7e6 with SMTP id 5b1f17b1804b1-45dddea5200mr182496945e9.11.1757589907694;
        Thu, 11 Sep 2025 04:25:07 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a309])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607d822fsm2095608f8f.53.2025.09.11.04.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 04:25:07 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 6/6] tests: add mock file based tests
Date: Thu, 11 Sep 2025 12:26:31 +0100
Message-ID: <16826e149fb343a9a00e0a445c0cd286ddbcb598.1757589613.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1757589613.git.asml.silence@gmail.com>
References: <cover.1757589613.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tests io_uring cmds with vectored registered buffers, which relies on
io_uring mock files. Also test read/write.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/Makefile    |   1 +
 test/mock_file.c | 373 +++++++++++++++++++++++++++++++++++++++++++++++
 test/mock_file.h |  47 ++++++
 3 files changed, 421 insertions(+)
 create mode 100644 test/mock_file.c
 create mode 100644 test/mock_file.h

diff --git a/test/Makefile b/test/Makefile
index 626ae674..c1afda5c 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -256,6 +256,7 @@ test_srcs := \
 	vec-regbuf.c \
 	timestamp.c \
 	ring-query.c \
+	mock_file.c \
 	# EOL
 
 # Please keep this list sorted alphabetically.
diff --git a/test/mock_file.c b/test/mock_file.c
new file mode 100644
index 00000000..e7c3c669
--- /dev/null
+++ b/test/mock_file.c
@@ -0,0 +1,373 @@
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <poll.h>
+#include <assert.h>
+
+#include "liburing.h"
+#include "test.h"
+#include "helpers.h"
+
+#include "mock_file.h"
+
+static struct io_uring mgr_ring;
+static __u64 mock_features;
+static int mgr_fd;
+
+static bool has_feature(int feature)
+{
+	return mock_features >= feature;
+}
+
+static int setup_mgr(void)
+{
+	struct io_uring_mock_probe mp;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret;
+
+	ret = mgr_fd = open("/dev/io_uring_mock", O_RDWR);
+	if (mgr_fd < 0) {
+		printf("no io_uring mock files, skip\n");
+		return T_EXIT_SKIP;
+	}
+
+	ret = io_uring_queue_init(8, &mgr_ring, 0);
+	if (ret) {
+		fprintf(stderr, "mgr ring setup failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	memset(&mp, 0, sizeof(mp));
+	sqe = io_uring_get_sqe(&mgr_ring);
+	t_sqe_prep_cmd(sqe, mgr_fd, IORING_MOCK_MGR_CMD_PROBE);
+	sqe->addr  = (__u64)(unsigned long)&mp;
+	sqe->len = sizeof(mp);
+
+	ret = t_submit_and_wait_single(&mgr_ring, &cqe);
+	if (ret || cqe->res) {
+		fprintf(stderr, "probe cmd failed %i %i\n", ret, cqe->res);
+		return T_EXIT_FAIL;
+	}
+
+	io_uring_cqe_seen(&mgr_ring, cqe);
+	mock_features = mp.features;
+	return 0;
+}
+
+static int create_mock_file(struct io_uring_mock_create *mc)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret;
+
+	sqe = io_uring_get_sqe(&mgr_ring);
+	t_sqe_prep_cmd(sqe, mgr_fd, IORING_MOCK_MGR_CMD_CREATE);
+	sqe->addr  = (__u64)(unsigned long)mc;
+	sqe->len = sizeof(*mc);
+
+	ret = t_submit_and_wait_single(&mgr_ring, &cqe);
+	if (ret || cqe->res) {
+		fprintf(stderr, "file create cmd failed %i %i\n", ret, cqe->res);
+		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&mgr_ring, cqe);
+	return 0;
+}
+
+static int t_copy_regvec(struct io_uring *ring, int mock_fd,
+			 struct iovec *iov, unsigned iov_len, char *buf,
+			 bool from_iov)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret;
+
+	sqe = io_uring_get_sqe(ring);
+	t_sqe_prep_cmd(sqe, mock_fd, IORING_MOCK_CMD_COPY_REGBUF);
+	sqe->addr3 = (__u64)(unsigned long)buf;
+	sqe->addr = (__u64)(unsigned long)iov;
+	sqe->len = iov_len;
+	if (from_iov)
+		sqe->file_index = IORING_MOCK_COPY_FROM;
+	sqe->buf_index = from_iov ? 0 : 1;
+	sqe->user_data = 43;
+	sqe->uring_cmd_flags |= IORING_URING_CMD_FIXED;
+
+	ret = t_submit_and_wait_single(ring, &cqe);
+	if (ret)
+		t_error(1, ret, "submit/wait failed");
+
+	ret = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	return ret;
+}
+
+static int t_copy_verify_regvec(struct io_uring *ring, int mock_fd,
+				struct iovec *iov, unsigned iov_len, char *buf,
+				bool from_iov)
+{
+	struct iovec iov2;
+	int ret;
+
+	ret = t_copy_regvec(ring, mock_fd, iov, iov_len, buf, from_iov);
+	if (ret < 0 || ret != t_iovec_data_length(iov, iov_len))
+		return ret < 0 ? ret : -1;
+
+	iov2.iov_base = buf;
+	iov2.iov_len = -1U;
+
+	ret = t_compare_data_iovec(iov, iov_len, &iov2, 1);
+	if (ret) {
+		fprintf(stderr, "iovec1 data mismatch %i\n", ret);
+		return -1;
+	}
+	return 0;
+}
+
+static int test_regvec_cmd(struct io_uring *ring, int mock_fd)
+{
+	struct iovec buf_iovec[2];
+	struct iovec iov[8];
+	size_t size = 4096 * 32;
+	char *buf_src, *buf_dst;
+	int i, ret;
+
+	buf_src = aligned_alloc(4096, size);
+	buf_dst = aligned_alloc(4096, size);
+	if (!buf_src || !buf_dst)
+		t_error(0, -ENOMEM, "can't allocate buffers");
+
+	for (i = 0; i < size; i++)
+		buf_src[i] = 'a' + (i % 26);
+
+	buf_iovec[0].iov_base = buf_src;
+	buf_iovec[0].iov_len = size;
+	buf_iovec[1].iov_base = buf_dst;
+	buf_iovec[1].iov_len = size;
+	ret = t_register_buffers(ring, buf_iovec, 2);
+	if (ret) {
+		free(buf_src);
+		free(buf_dst);
+		return ret == T_SETUP_SKIP ? 0 : T_EXIT_FAIL;
+	}
+
+	memset(buf_dst, 0, size);
+	iov[0].iov_len = size;
+	iov[0].iov_base = buf_src;
+	ret = t_copy_verify_regvec(ring, mock_fd, iov, 1, buf_dst, true);
+	if (ret < 0) {
+		fprintf(stderr, "t_copy_verify_regvec iovec1 failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	memset(buf_dst, 0, size);
+	iov[0].iov_len = size;
+	iov[0].iov_base = buf_dst;
+	ret = t_copy_verify_regvec(ring, mock_fd, iov, 1, buf_src, false);
+	if (ret < 0) {
+		fprintf(stderr, "t_copy_verify_regvec iovec1 reverse failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	memset(buf_dst, 0, size);
+	iov[0].iov_base = buf_src;
+	iov[0].iov_len = 5;
+	iov[1].iov_base = buf_src + 5;
+	iov[1].iov_len = 11;
+	iov[2].iov_base = buf_src + (4096 - 127);
+	iov[2].iov_len = 127;
+	iov[3].iov_base = buf_src + (4096 - 127);
+	iov[3].iov_len = 127 + 4096 + 13;
+	iov[4].iov_base = buf_src + 4 * 4096;
+	iov[4].iov_len = 4096 + 73;
+	iov[5].iov_base = buf_src + 7 * 4096 + 127;
+	iov[5].iov_len = 4096 * 11 + 132;
+	assert(t_iovec_data_length(iov, 6) <= size);
+	ret = t_copy_verify_regvec(ring, mock_fd, iov, 6, buf_dst, true);
+	if (ret < 0) {
+		fprintf(stderr, "t_copy_verify_regvec iovec6 failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	memset(buf_dst, 0, size);
+	iov[0].iov_base = buf_dst;
+	iov[0].iov_len = 5;
+	iov[1].iov_base = buf_dst + 5;
+	iov[1].iov_len = 11;
+	iov[2].iov_base = buf_dst + (4096 - 127);
+	iov[2].iov_len = 127;
+	iov[3].iov_base = buf_dst + 4 * 4096;
+	iov[3].iov_len = 4096 + 73;
+	iov[4].iov_base = buf_dst + 7 * 4096 + 127;
+	iov[4].iov_len = 4096 * 11 + 132;
+	assert(t_iovec_data_length(iov, 5) <= size);
+	ret = t_copy_verify_regvec(ring, mock_fd, iov, 5, buf_src, false);
+	if (ret < 0) {
+		fprintf(stderr, "t_copy_verify_regvec iovec6 reverse failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	free(buf_src);
+	free(buf_dst);
+	return 0;
+}
+
+static int test_cmds(void)
+{
+	struct io_uring_mock_create mc;
+	struct io_uring ring;
+	int ret, mock_fd;
+
+	memset(&mc, 0, sizeof(mc));
+	if (create_mock_file(&mc))
+		return T_EXIT_FAIL;
+	mock_fd = mc.out_fd;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return 1;
+	}
+
+	if (has_feature(IORING_MOCK_FEAT_CMD_COPY)) {
+		ret = test_regvec_cmd(&ring, mock_fd);
+		if (ret) {
+			fprintf(stderr, "test_regvec_cmd() failed\n");
+			return T_EXIT_FAIL;
+		}
+	} else {
+		printf("skip test_regvec_cmd()\n");
+	}
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+static int test_reads(struct io_uring *ring, int mock_fd, void *buffer)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int io_len = 4096;
+	int nr_reqs = 16;
+	int i, ret;
+
+	for (i = 0; i < nr_reqs; i++) {
+		sqe = io_uring_get_sqe(ring);
+		io_uring_prep_read(sqe, mock_fd, buffer, io_len, 0);
+		sqe->user_data = i;
+	}
+
+	ret = io_uring_submit(ring);
+	if (ret != nr_reqs) {
+		fprintf(stderr, "submit got %d, wanted %d\n", ret, nr_reqs);
+		return T_EXIT_FAIL;
+	}
+
+	for (i = 0; i < nr_reqs; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret) {
+			fprintf(stderr, "wait_cqe=%d\n", ret);
+			return T_EXIT_FAIL;
+		}
+		if (cqe->res != io_len) {
+			fprintf(stderr, "unexpected cqe res %i, data %i\n",
+				cqe->res, (int)cqe->user_data);
+			return T_EXIT_FAIL;
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+	return 0;
+}
+
+static int test_rw(void)
+{
+	void *buffer;
+	struct io_uring ring;
+	int ret, i;
+
+	if (!has_feature(IORING_MOCK_FEAT_RW_ZERO)) {
+		printf("no mock read-write support, skip\n");
+		return T_EXIT_SKIP;
+	}
+
+	buffer = malloc(4096);
+	if (!buffer) {
+		fprintf(stderr, "can't allocate buffers\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = io_uring_queue_init(32, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return 1;
+	}
+
+	for (i = 0; i < 8; i++) {
+		struct io_uring_mock_create mc;
+		bool nowait = i & 1;
+		bool async = i & 2;
+		bool poll = i & 4;
+		int mock_fd;
+
+		memset(&mc, 0, sizeof(mc));
+		if (poll) {
+			if (!has_feature(IORING_MOCK_FEAT_POLL))
+				continue;
+			mc.flags |= IORING_MOCK_CREATE_F_POLL;
+		}
+		if (nowait) {
+			if (!has_feature(IORING_MOCK_FEAT_RW_NOWAIT))
+				continue;
+			mc.flags |= IORING_MOCK_CREATE_F_SUPPORT_NOWAIT;
+		}
+		if (async) {
+			if (!has_feature(IORING_MOCK_FEAT_RW_ASYNC))
+				continue;
+			mc.rw_delay_ns = 1000 * 1000 * 50;
+		}
+		mc.file_size = 10 * (1UL << 20);
+		if (create_mock_file(&mc))
+			return T_EXIT_FAIL;
+		mock_fd = mc.out_fd;
+
+		ret = test_reads(&ring, mock_fd, buffer);
+		if (ret) {
+			fprintf(stderr, "rw failed %i/%i/%i\n",
+				nowait, async, poll);
+			return T_EXIT_FAIL;
+		}
+
+		close(mock_fd);
+	}
+
+	free(buffer);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	ret = setup_mgr();
+	if (ret)
+		return ret;
+
+	ret = test_cmds();
+	if (ret)
+		return T_EXIT_FAIL;
+
+	ret = test_rw();
+	if (ret) {
+		fprintf(stderr, "test_rw failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	io_uring_queue_exit(&mgr_ring);
+	close(mgr_fd);
+	return 0;
+}
diff --git a/test/mock_file.h b/test/mock_file.h
new file mode 100644
index 00000000..debeee8e
--- /dev/null
+++ b/test/mock_file.h
@@ -0,0 +1,47 @@
+#ifndef LINUX_IO_URING_MOCK_FILE_H
+#define LINUX_IO_URING_MOCK_FILE_H
+
+#include <linux/types.h>
+
+enum {
+	IORING_MOCK_FEAT_CMD_COPY,
+	IORING_MOCK_FEAT_RW_ZERO,
+	IORING_MOCK_FEAT_RW_NOWAIT,
+	IORING_MOCK_FEAT_RW_ASYNC,
+	IORING_MOCK_FEAT_POLL,
+
+	IORING_MOCK_FEAT_END,
+};
+
+struct io_uring_mock_probe {
+	__u64		features;
+	__u64		__resv[9];
+};
+
+enum {
+	IORING_MOCK_CREATE_F_SUPPORT_NOWAIT			= 1,
+	IORING_MOCK_CREATE_F_POLL				= 2,
+};
+
+struct io_uring_mock_create {
+	__u32		out_fd;
+	__u32		flags;
+	__u64		file_size;
+	__u64		rw_delay_ns;
+	__u64		__resv[13];
+};
+
+enum {
+	IORING_MOCK_MGR_CMD_PROBE,
+	IORING_MOCK_MGR_CMD_CREATE,
+};
+
+enum {
+	IORING_MOCK_CMD_COPY_REGBUF,
+};
+
+enum {
+	IORING_MOCK_COPY_FROM			= 1,
+};
+
+#endif
-- 
2.49.0


