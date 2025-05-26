Return-Path: <io-uring+bounces-8111-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BD1E4AC3ABB
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 09:35:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EE8818902C0
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 07:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7555B258A;
	Mon, 26 May 2025 07:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8CNFG3t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C13D1B0420
	for <io-uring@vger.kernel.org>; Mon, 26 May 2025 07:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748244915; cv=none; b=l+7ymT1qjAD8c3/gH84zlgrYVOg1NknomruborTCaBt+OLJvSjNqBxitu8XecAaIbsCtQhoQU+SwDnfWwQfZ2AwUe6+RnaBNTxNrJOubM+98YfFjcLXyIOKPCmuCCH4UxLi8XGMJEsdPhZ0kP8zfycQ4ZhFSsaHn82cO6J84CxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748244915; c=relaxed/simple;
	bh=ENVTC7nWrKDjdLKPm0QrJxukTbS9948aVh8f6Gv+PT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZF7AXlPVJ+Tah/K8XAECwxx44vnxio1C8RuTgYDqYbcy5glq3IhrCuXqTzAnmvaaQrkhaFrvlcJ3hDx0T1ge+0jKiX5mSDSixOtftEPttcCfokRX9VeV1JqYAALy3ARqwHs0MuYVyRknq5/J3TyuRNpw8G19CyGjTOuGf+qiIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e8CNFG3t; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ad5273c1fd7so371005066b.1
        for <io-uring@vger.kernel.org>; Mon, 26 May 2025 00:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748244911; x=1748849711; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4HGM2SQvbbb/r9/hEvcUABzXrUimTbdgBEgPqplgVd4=;
        b=e8CNFG3tGd7gF7D7mqeQv3o5X816llPLoAasmkWq8fJl6dcTfGWQ2dEk2FhP14zVUd
         d/tj0OkWswzJkNZ3c1q3bwQSFE1kkkm5E6PIr9JBYQ/UwmiRVM6hAvRKS6O3hXLfV3BB
         a3aWHLCjjiIVl9BwsbAQxl/dMY9ux5b9jyBj8SOx/lWmQIwmbHlVvixLde0xmv7pQ1dT
         FFrpuLSPCdH5JQfITTmg9d0pg8uYnlsNKTkyDkMojohs7stDgW6K1nGZ3kPcPpL6DcDF
         PwaH8JIUaG+kJs5DrPKV3HBjhdDPFx+dO58eyA+rd6sIJrmP2dFaE6N77Pq30Qad20KT
         W9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748244911; x=1748849711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4HGM2SQvbbb/r9/hEvcUABzXrUimTbdgBEgPqplgVd4=;
        b=jU12ALGCw716Qm+IWcvaIbhzefqS27dwcxGW0NDMPJk4HvorEIWZDmJhwFPq/fVNm5
         dRLYSM4AI7iawb6/nEBzpsbJkE87mQZb6HY0OIKXGe6KdBPYVVRn/XAXlZgKvfEn2NLw
         yEmIT2vzYAAjmDVbtcxCF3ovBwp1YcXsz1QI1B7JFtv36zze/M1VXRFF2J56TBZzsWch
         BFKhClGv1PF1PxYBwCQ66fVTOze7T4irGxNshiS6iunZWJ4+z9ZSf7xjRWlV6GbWx39B
         7UW8TvlhpCYdUFZ61VT+5Zj3S7gWln3npmWl+cYYpopc6M5qvA+fnM169KSxXF/ed0ZN
         w5/g==
X-Gm-Message-State: AOJu0YyzFqd7YAZ2604h+O+XM/x/3ba/ifJufStAOyPuIptOnVSp1bxV
	J59avgA9013qw/wk4ePb02TmK+1JwJdzmoCDHcsl9N0ndHG4n4mo9Y/M3N/7Xg==
X-Gm-Gg: ASbGncthFBJUW8elloHz1+D5dnpD2jPBU5F0/ADnjaugAmm8cr9zOVRlEDNEyFaIGIG
	ZqOzh30jkLS7k+c67NsZtwbBmBJ2fkeCcgMtOzvKLdbIghCmRdnjdqItBJnAEWvLq3PX0bjUPc3
	iyRogqNa/mBAEbAm7kJWLEAl0rckJwDujSqOlCDt9DuIwkVrvy9dMKw356pkRRCDzQnwEte2+5W
	G83N8mtyyhipqdW4ZIHby4jbbeySLKZ5d1SZH9hFT3ntRTFGam+CsdM3EwuWJRT02ZZ17t31DCP
	Wl3nDLzs2Vsw1fHmXzJ04NbOHImLu1szPIzY4ZFMSuhntDqZunroq/i3QlPR7Owj
X-Google-Smtp-Source: AGHT+IFYfAdFJ2L8FxfJgpHji3X1MYWNPxF8SS79jXZjXtmrc9lQwqgusJh/vbuHrH7B3jL6zG6jpg==
X-Received: by 2002:a17:907:7f8a:b0:ad1:a87d:3cd0 with SMTP id a640c23a62f3a-ad85b0ad5bamr721125766b.17.1748244911001;
        Mon, 26 May 2025 00:35:11 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.24])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d43840esm1622780266b.87.2025.05.26.00.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 00:35:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 1/2] tests: test cmd regvec support with mock file
Date: Mon, 26 May 2025 08:36:17 +0100
Message-ID: <8398c230325218a4b9ac3d2d9dab2cbe6ecadde3.1748244826.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748244826.git.asml.silence@gmail.com>
References: <cover.1748244826.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tests io_uring cmds with vectored registered buffers, which relies on
io_uring mock files.t

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/Makefile     |   1 +
 test/mock.h       |  47 +++++++++
 test/mock_tests.c | 260 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 308 insertions(+)
 create mode 100644 test/mock.h
 create mode 100644 test/mock_tests.c

diff --git a/test/Makefile b/test/Makefile
index a0542dcb..e4309edc 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -245,6 +245,7 @@ test_srcs := \
 	xattr.c \
 	zcrx.c \
 	vec-regbuf.c \
+	mock_tests.c \
 	# EOL
 
 # Please keep this list sorted alphabetically.
diff --git a/test/mock.h b/test/mock.h
new file mode 100644
index 00000000..7fa71145
--- /dev/null
+++ b/test/mock.h
@@ -0,0 +1,47 @@
+#ifndef IOU_MOCK_H
+#define IOU_MOCK_H
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
\ No newline at end of file
diff --git a/test/mock_tests.c b/test/mock_tests.c
new file mode 100644
index 00000000..5f3063ff
--- /dev/null
+++ b/test/mock_tests.c
@@ -0,0 +1,260 @@
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
+#include "mock.h"
+
+static struct io_uring mgr_ring;
+static __u64 mock_features;
+static int mgr_fd;
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
+	if (IORING_MOCK_FEAT_CMD_COPY < mock_features) {
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
+	io_uring_queue_exit(&mgr_ring);
+	close(mgr_fd);
+	return 0;
+}
-- 
2.49.0


