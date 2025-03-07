Return-Path: <io-uring+bounces-7026-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF65BA57086
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 19:28:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5C993A499B
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 18:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BAAA21ADCC;
	Fri,  7 Mar 2025 18:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eCg+GtMm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C368323BCFA
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 18:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741372117; cv=none; b=SgpebakbbwAuEhGASfs/i0p4KnFM18ExlQE6/DoSYZ68QCwO7I3oGSEqPEaZpN7rrpzNdHI6bJliejOs5yX5eVpFVM/GFQnggGa1vC+yTsTcQyLmOBCRtI9tFm3yAq5MLxK8HcZTqjG1x65tBC+ebDODBN2JvV9ko/Rhf5azNuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741372117; c=relaxed/simple;
	bh=k2qdaVJX1Oy1PPU7TLsGOIK/h24OVnA/pBE/aQlKXBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXiIX5WA2IMn/ocEDsFW6VMZedOLp1s8JRz+urx8SZdHcYOb9hNuaD4pspTojjEdIzNnpTHnD4UOIpMsVnT5VoyzG+u2Dtxc7gxkLNuRqDOZmO/5ARbfLFy6rlppHiccKMNvyUZpjLqpeLwjF89YmLpqIJwJJopcMofphA92utI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eCg+GtMm; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5e614da8615so375168a12.1
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 10:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741372112; x=1741976912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q4DhHv8/7P8vMGPOcDW4/bTrCzDmmW4urYlMU97ASdI=;
        b=eCg+GtMmL+WV+Vqwwi6XpXxl25dWo/JzN+K+9ctw7gJXSHqNfau5mgCJ1TcIhdsZJh
         99E9vSE7jG4Rn4UUxPcJ6Psg4ubCRbvyQ8+aTZI5jDwxk9aeZAu3gNSHl8fbqamKHu2T
         RVVXaoWNs25amqeZSXaUkd+1tc/k7GdYp1P626Sbq8+hIQHKttCvWweSEXq6XfmJYdsp
         60ewX/7t6VnDQ4NS4HmALYkaOx2+2klyidjSUCOa9nTQPZQlngi27ZUF8ScCvtCKq/5j
         ueTXBOGYa05V/Cp5OAzztUupgVSZI36dCEkMuiNwaPpSH8nLSSQ8XeCEL+Y7Yq/0DNha
         0TGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741372112; x=1741976912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q4DhHv8/7P8vMGPOcDW4/bTrCzDmmW4urYlMU97ASdI=;
        b=IH2C0QS8f4cbdt7RDmyUriuWscnO0V5v9DU6EjFBmeWY2gDiRw7cvteKJdQKC2DBXs
         YgAShYjCaqxfJJdWoDwyWx6bIF7x5fZZSGTBGl2TQIj8qKr40PejyIv7RpSpTfL2FLiW
         rI/9WujuID17VxCl7SioLdBT811a4QQko/iZISrHFpXUR+zvuWnf4zhOUI88jffDcg7c
         n4cp3G4aeZIgn6Z93KIaJEYkh7iRKAwHkGOyDnVkHs3Vbac6faD1D1RvqIIzQB9G/vJf
         b7i0o/GM+1sm7cCzLlYGXUCZOp3L3GZIeCZAYiqw7wK6wiBmkA8D72rdp2tfG7u+boTM
         Rwqw==
X-Gm-Message-State: AOJu0YxeopDx66WXg01dhk1FJ8SVy4w2jxIbvZFBiGj8kDCbpLscwUSN
	h1JrCTo9LtiKvOEdB0dGdqF0euDiv6E444PBCbsPctBPbA1xCx0/Vtyx4Q==
X-Gm-Gg: ASbGncu+bGdT/u4PI9aTu6xEcByyQ8b/udJCoZkMk/L+yyyWxoMzQyVPiGdUirgix73
	jkwOiV3rqGN+7Oi2TcYjQnthGj8L+wxF590Ki8xE2QkmEq1LH4hE6pfClXnpyuAD5qIAlVtlxLz
	WLZ6R+jEhPPhjLDKR03BzNdN5098mKzTf/EwmIaWPThyio0dEkoabv3YS5nSZXREuoMH0LeFi1p
	/KlwiErIZ2YhYXD48mySMI+uBBFtIkjylYb6wAj5sVBus9oMRb1yrj1fUe1XS2zVB3pnYEYKUYx
	C2xbP/HY0WmiNVk8cvJmi7jE1VsouMGRheqctHmxD0JRm0yGBYMrXIFAwg==
X-Google-Smtp-Source: AGHT+IFdS0G7ZRu29/BUYmqM2a90XDi0ogg7fWUuJMGtVz9eBAiDJY2jPmg4N3b+yKPKvKp8fSgDrQ==
X-Received: by 2002:a05:6402:210f:b0:5de:d932:a54c with SMTP id 4fb4d7f45d1cf-5e614ec158amr929297a12.2.1741372112271;
        Fri, 07 Mar 2025 10:28:32 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.206])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c74a9315sm2883230a12.46.2025.03.07.10.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 10:28:31 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v2 4/4] tests: targeted registered vector tests
Date: Fri,  7 Mar 2025 18:28:56 +0000
Message-ID: <afbc85716fcdf3120bb4c05712420c48da4d7933.1741372065.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741372065.git.asml.silence@gmail.com>
References: <cover.1741372065.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The main part here is to exercise various iovec->bvec reallocation
scenarios, but it also checks edge cases and validates final data.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/Makefile     |   1 +
 test/vec-regbuf.c | 605 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 606 insertions(+)
 create mode 100644 test/vec-regbuf.c

diff --git a/test/Makefile b/test/Makefile
index 0367ef72..fb11d16a 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -241,6 +241,7 @@ test_srcs := \
 	wq-aff.c \
 	xattr.c \
 	zcrx.c \
+	vec-regbuf.c \
 	# EOL
 
 # Please keep this list sorted alphabetically.
diff --git a/test/vec-regbuf.c b/test/vec-regbuf.c
new file mode 100644
index 00000000..1891e315
--- /dev/null
+++ b/test/vec-regbuf.c
@@ -0,0 +1,605 @@
+/* SPDX-License-Identifier: MIT */
+#include <sys/mman.h>
+#include <linux/mman.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <sys/types.h>
+#include <poll.h>
+#include <pthread.h>
+#include <errno.h>
+
+#include "helpers.h"
+#include "liburing.h"
+
+static bool has_regvec;
+
+struct buf_desc {
+	char			*buf_wr;
+	char			*buf_rd;
+	size_t			size;
+
+	struct io_uring 	ring;
+	bool			ring_init;
+	bool			fixed;
+	int			buf_idx;
+	bool			rw;
+};
+
+#define BUF_BASE_IDX	1
+static int page_sz;
+
+static void probe_support(void)
+{
+	struct io_uring_probe *p;
+	struct io_uring ring;
+	int ret = 0;
+
+	ret = io_uring_queue_init(1, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue init failed: %d\n", ret);
+		exit(ret);
+	}
+
+	p = t_calloc(1, sizeof(*p) + 256 * sizeof(struct io_uring_probe_op));
+	ret = io_uring_register_probe(&ring, p, 256);
+
+	/* if we don't have PROBE_REGISTER, we don't have OP_READ/WRITE */
+	if (ret == -EINVAL)
+		goto out;
+	if (ret) {
+		fprintf(stderr, "register_probe: %d\n", ret);
+		goto out;
+	}
+
+	has_regvec = p->ops_len > IORING_OP_READV_FIXED &&
+		     (p->ops[IORING_OP_READV_FIXED].flags & IO_URING_OP_SUPPORTED);
+out:
+	io_uring_queue_exit(&ring);
+	if (p)
+		free(p);
+}
+
+static void bind_ring(struct buf_desc *bd, struct io_uring *ring, unsigned buf_idx)
+{
+	size_t size = bd->size;
+	struct iovec iov;
+	int ret;
+
+	iov.iov_len = size;
+	iov.iov_base = bd->buf_wr;
+
+	ret = io_uring_register_buffers_update_tag(ring, buf_idx, &iov, NULL, 1);
+	if (ret != 1) {
+		if (geteuid()) {
+			fprintf(stderr, "Not root, skipping\n");
+			exit(0);
+		}
+		fprintf(stderr, "buf reg failed %i\n", ret);
+		exit(1);
+	}
+	bd->buf_idx = buf_idx;
+}
+
+static void reinit_ring(struct buf_desc *bd)
+{
+	struct io_uring *ring = &bd->ring;
+	int ret;
+
+	if (bd->ring_init) {
+		io_uring_queue_exit(ring);
+		bd->ring_init = false;
+	}
+
+	ret = io_uring_queue_init(32, ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring init error %i\n", ret);
+		exit(1);
+	}
+
+	ret = io_uring_register_buffers_sparse(ring, 128);
+	if (ret) {
+		fprintf(stderr, "table reg error %i\n", ret);
+		exit(1);
+	}
+
+	bind_ring(bd, &bd->ring, BUF_BASE_IDX);
+	bd->ring_init = true;
+}
+
+static void init_buffers(struct buf_desc *bd, size_t size)
+{
+	void *start;
+	void *mem;
+
+	start = mmap(NULL, size + page_sz * 2, PROT_NONE,
+			MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
+	if (start == MAP_FAILED) {
+		fprintf(stderr, "Unable to preserve the page mixture memory.\n");
+		exit(1);
+	}
+
+	mem = mmap(start + page_sz, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
+	if (mem == MAP_FAILED) {
+		fprintf(stderr, "mmap fail\n");
+		exit(1);
+	}
+
+	memset(bd, 0, sizeof(*bd));
+	bd->size = size;
+	bd->buf_wr = mem;
+	bd->buf_rd = malloc(size);
+	if (!bd->buf_rd) {
+		fprintf(stderr, "malloc fail\n");
+		exit(1);
+	}
+}
+
+static int verify_data(struct buf_desc *bd, struct iovec *wr_vecs, int nr_iovec,
+			int fd)
+{
+	int iov_idx, ret;
+
+	for (iov_idx = 0; iov_idx < nr_iovec; iov_idx++) {
+		struct iovec *vec = &wr_vecs[iov_idx];
+		size_t seg_size = vec->iov_len;
+		size_t read_bytes = 0;
+
+		while (1) {
+			ret = read(fd, bd->buf_rd + read_bytes, seg_size - read_bytes);
+			if (ret < 0) {
+				fprintf(stderr, "read error %i", ret);
+				return 1;
+			}
+			read_bytes += ret;
+			if (read_bytes == seg_size)
+				break;
+			if (ret == 0) {
+				fprintf(stderr, "can't read %i", ret);
+				return 2;
+			}
+		}
+
+		ret = memcmp(bd->buf_rd, vec->iov_base, seg_size);
+		if (ret != 0) {
+			fprintf(stderr, "data mismatch %i\n", ret);
+			return 3;
+		}
+	}
+	return 0;
+}
+
+struct verify_data {
+	struct buf_desc *bd;
+	struct iovec *vecs;
+	int nr_vec;
+	int fd;
+};
+
+static void *verify_thread_cb(void *data)
+{
+	struct verify_data *vd = data;
+	int ret;
+
+	ret = verify_data(vd->bd, vd->vecs, vd->nr_vec, vd->fd);
+	return (void *)(unsigned long)ret;
+}
+
+static int test_rw(struct buf_desc *bd, struct iovec *vecs, int nr_vec, int fd_wr)
+{
+	unsigned buf_idx = bd->buf_idx;
+	struct io_uring *ring = &bd->ring;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret;
+
+	sqe = io_uring_get_sqe(ring);
+	if (bd->fixed)
+		io_uring_prep_writev_fixed(sqe, fd_wr, vecs, nr_vec, 0, 0, buf_idx);
+	else
+		io_uring_prep_writev(sqe, fd_wr, vecs, nr_vec, 0);
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit failed %i\n", ret);
+		exit(1);
+	}
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe=%d\n", ret);
+		exit(1);
+	}
+
+	ret = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	return ret;
+}
+
+static int test_sendzc(struct buf_desc *bd, struct iovec *vecs, int nr_vec, int fd_wr)
+{
+	unsigned buf_idx = bd->buf_idx;
+	struct io_uring *ring = &bd->ring;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret, cqe_ret, more;
+	struct msghdr msghdr;
+
+	memset(&msghdr, 0, sizeof(msghdr));
+	msghdr.msg_iov = vecs;
+	msghdr.msg_iovlen = nr_vec;
+
+	sqe = io_uring_get_sqe(ring);
+	if (bd->fixed)
+		io_uring_prep_sendmsg_zc_fixed(sqe, fd_wr, &msghdr, 0, buf_idx);
+	else
+		io_uring_prep_sendmsg_zc(sqe, fd_wr, &msghdr, 0);
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit failed %i\n", ret);
+		exit(1);
+	}
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe=%d\n", ret);
+		exit(1);
+	}
+
+	cqe_ret = cqe->res;
+	more = cqe->flags & IORING_CQE_F_MORE;
+	io_uring_cqe_seen(ring, cqe);
+
+	if (more) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret) {
+			fprintf(stderr, "wait_cqe=%d\n", ret);
+			exit(1);
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+	return cqe_ret;
+}
+
+static int test_vec(struct buf_desc *bd, struct iovec *vecs, int nr_vec,
+		    bool expect_fail, int *cqe_ret)
+{
+	struct sockaddr_storage addr;
+	int sock_server, sock_client;
+	struct verify_data vd;
+	size_t total_len = 0;
+	int i, ret;
+	void *verify_res;
+	pthread_t th;
+
+	ret = t_create_socketpair_ip(&addr, &sock_client, &sock_server,
+					true, true, false, true, "::1");
+	if (ret) {
+		fprintf(stderr, "sock prep failed %d\n", ret);
+		return 1;
+	}
+
+	for (i = 0; i < bd->size; i++)
+		bd->buf_wr[i] = i;
+	memset(bd->buf_rd, 0, bd->size);
+
+	for (i = 0; i < nr_vec; i++)
+		total_len += vecs[i].iov_len;
+
+	vd.bd = bd;
+	vd.vecs = vecs;
+	vd.nr_vec = nr_vec;
+	vd.fd = sock_server;
+
+	if (!expect_fail) {
+		ret = pthread_create(&th, NULL, verify_thread_cb, &vd);
+		if (ret) {
+			fprintf(stderr, "pthread_create failed %i\n", ret);
+			return ret;
+		}
+	}
+
+	if (bd->rw)
+		ret = test_rw(bd, vecs, nr_vec, sock_client);
+	else
+		ret = test_sendzc(bd, vecs, nr_vec, sock_client);
+
+	*cqe_ret = ret;
+
+	if (!expect_fail && ret != total_len) {
+		fprintf(stderr, "invalid cqe %i, expected %lu\n",
+				 ret, (unsigned long)total_len);
+		return 1;
+	}
+
+	if (!expect_fail) {
+		pthread_join(th, &verify_res);
+		ret = (int)(unsigned long)verify_res;
+		if (ret) {
+			fprintf(stderr, "verify failed  %i\n", ret);
+			return 1;
+		}
+	}
+	close(sock_client);
+	close(sock_server);
+	return 0;
+}
+
+struct work {
+	struct iovec	*vecs;
+	unsigned	nr_vecs;
+};
+
+static int test_sequence(struct buf_desc *bd, unsigned nr, struct work *ws)
+{
+	int i, ret;
+	int cqe_ret;
+
+	reinit_ring(bd);
+
+	for (i = 0; i < nr; i++) {
+		ret = test_vec(bd, ws[i].vecs, ws[i].nr_vecs, false, &cqe_ret);
+		if (ret) {
+			fprintf(stderr, "sequence failed, idx %i/%i\n", i, nr);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static void test_basic(struct buf_desc *bd)
+{
+	void *p = bd->buf_wr;
+	int ret;
+	struct iovec iov_page =		{ .iov_base = p,
+					  .iov_len = page_sz, };
+	struct iovec iov_inner =	{ .iov_base = p + 1,
+					  .iov_len = 3, };
+	struct iovec iov_maxbvec =	{ .iov_base = p + page_sz - 1,
+					  .iov_len = page_sz + 2, };
+	struct iovec iov_big =		{ .iov_base = p,
+					  .iov_len = page_sz * 12 + 33, };
+	struct iovec iov_big_unalign =	{ .iov_base = p + 10,
+					  .iov_len = page_sz * 7 + 41, };
+	struct iovec iov_full =		{ .iov_base = p,
+					  .iov_len = bd->size, };
+	struct iovec iov_right1 =	{ .iov_base = p + bd->size - page_sz + 5,
+					  .iov_len = page_sz - 5 };
+	struct iovec iov_right2 =	{ .iov_base = p + bd->size - page_sz - 5,
+					  .iov_len = page_sz + 5 };
+	struct iovec iov_full_unalign = { .iov_base = p + 1,
+					  .iov_len = bd->size - 1, };
+	struct iovec vecs[] = {
+		iov_page,
+		iov_big,
+		iov_inner,
+		iov_big_unalign,
+		iov_big_unalign,
+	};
+	struct iovec vecs_basic[] = { iov_page, iov_page, iov_page };
+	struct iovec vecs_full[] = { iov_full, iov_full, iov_full };
+	struct iovec vecs_full_unalign[] = { iov_full_unalign, iov_full_unalign,
+					     iov_full_unalign };
+	struct iovec vecs_maxsegs[] = { iov_maxbvec, iov_maxbvec, iov_maxbvec,
+				      iov_maxbvec, iov_maxbvec, iov_maxbvec};
+
+	ret = test_sequence(bd, 1, (struct work[]) {
+			{ &iov_page, 1 },
+			{ vecs, 1 }});
+	if (ret) {
+		fprintf(stderr, "seq failure: basic aligned, %i\n", ret);
+		exit(1);
+	}
+
+	ret = test_sequence(bd, 2, (struct work[]) {
+			{ vecs, 1 },
+			{ vecs, 1 }});
+	if (ret) {
+		fprintf(stderr, "seq failure: basic aligned, %i\n", ret);
+		exit(1);
+	}
+
+	ret = test_sequence(bd, 2, (struct work[]) {
+			{ vecs + 1, 1 },
+			{ vecs + 1, 1 }});
+	if (ret) {
+		fprintf(stderr, "seq failure: multi page buffer, %i\n", ret);
+		exit(1);
+	}
+
+	ret = test_sequence(bd, 2, (struct work[]) {
+			{ vecs + 2, 1 },
+			{ vecs + 2, 1 }});
+	if (ret) {
+		fprintf(stderr, "seq failure: misaligned buffer, %i\n", ret);
+		exit(1);
+	}
+
+	ret = test_sequence(bd, 2, (struct work[]) {
+			{ vecs + 3, 1 },
+			{ vecs + 3, 1 }});
+	if (ret) {
+		fprintf(stderr, "seq failure: misaligned multipage buffer, %i\n", ret);
+		exit(1);
+	}
+
+	ret = test_sequence(bd, 2, (struct work[]) {
+			{ vecs, 1 },
+			{ vecs + 3, 1 }});
+	if (ret) {
+		fprintf(stderr, "seq failure: realloc + increase bvec, %i\n", ret);
+		exit(1);
+	}
+
+	ret = test_sequence(bd, 2, (struct work[]) {
+			{ vecs + 3, 1 },
+			{ vecs + 0, 1 }});
+	if (ret) {
+		fprintf(stderr, "seq failure: realloc + decrease bvec, %i\n", ret);
+		exit(1);
+	}
+
+	ret = test_sequence(bd, 2, (struct work[]) {
+			{ vecs, 4 },
+			{ vecs, 4 }});
+	if (ret) {
+		fprintf(stderr, "seq failure: multisegment, %i\n", ret);
+		exit(1);
+	}
+
+	ret = test_sequence(bd, 3, (struct work[]) {
+			{ vecs, 2 },
+			{ vecs, 3 },
+			{ vecs, 4 }});
+	if (ret) {
+		fprintf(stderr, "seq failure: multisegment 2, %i\n", ret);
+		exit(1);
+	}
+
+	ret = test_sequence(bd, 3, (struct work[]) {
+			{ vecs_basic, 1 },
+			{ vecs_basic, 2 },
+			{ vecs_basic, 3 }});
+	if (ret) {
+		fprintf(stderr, "seq failure: increase iovec, %i\n", ret);
+		exit(1);
+	}
+
+	ret = test_sequence(bd, 3, (struct work[]) {
+			{ vecs_basic, 3 },
+			{ vecs_basic, 2 },
+			{ vecs_basic, 1 }});
+	if (ret) {
+		fprintf(stderr, "seq failure: decrease iovec, %i\n", ret);
+		exit(1);
+	}
+
+	ret = test_sequence(bd, 3, (struct work[]) {
+			{ &iov_right1, 1 },
+			{ &iov_right2, 1 },
+			{ &iov_right1, 1 }});
+	if (ret) {
+		fprintf(stderr, "seq failure: right aligned, %i\n", ret);
+		exit(1);
+	}
+
+	ret = test_sequence(bd, 3, (struct work[]) {
+			{ vecs_full, 1 },
+			{ vecs_full, 1 },
+			{ vecs_full, 3 }});
+	if (ret) {
+		fprintf(stderr, "seq failure: full size, %i\n", ret);
+		exit(1);
+	}
+
+	ret = test_sequence(bd, 3, (struct work[]) {
+			{ vecs_full_unalign, 1 },
+			{ vecs_full_unalign, 1 },
+			{ vecs_full_unalign, 3 }});
+	if (ret) {
+		fprintf(stderr, "seq failure: full size unsigned, %i\n", ret);
+		exit(1);
+	}
+
+	ret = test_sequence(bd, 3, (struct work[]) {
+			{ vecs_maxsegs, 1 },
+			{ vecs_maxsegs, 2 },
+			{ vecs_maxsegs, 3 }});
+	if (ret) {
+		fprintf(stderr, "seq failure: overestimated segments, %i\n", ret);
+		exit(1);
+	}
+
+	ret = test_sequence(bd, 3, (struct work[]) {
+			{ vecs_maxsegs, 6 },
+			{ vecs_maxsegs, 6 },
+			{ vecs_maxsegs, 6 }});
+	if (ret) {
+		fprintf(stderr, "seq failure: overestimated segments 2, %i\n", ret);
+		exit(1);
+	}
+}
+
+static void test_fail(struct buf_desc *bd)
+{
+	int ret, cqe_ret;
+	void *p = bd->buf_wr;
+	struct iovec iov_0len = { .iov_base = p, .iov_len = 0 };
+	struct iovec iov_0buf = { .iov_base = 0, .iov_len = 1 };
+	struct iovec iov_inv = { .iov_base = (void *)-1U, .iov_len = 1 };
+	struct iovec iov_under = { .iov_base = p - 1, .iov_len = 1 };
+	struct iovec iov_over = { .iov_base = p + bd->size, .iov_len = 1 };
+	struct iovec vecs_0[] = { iov_0len, iov_0len, iov_0len, iov_0len,
+				   iov_0len, iov_0len, iov_0len, iov_0len };
+
+	reinit_ring(bd);
+	ret = test_vec(bd, vecs_0, 8, true, &cqe_ret);
+	if (ret || cqe_ret > 0) {
+		fprintf(stderr, "0 length test failed %i, cqe %i\n",
+				ret, cqe_ret);
+		exit(1);
+	}
+
+	reinit_ring(bd);
+	ret = test_vec(bd, &iov_0buf, 1, true, &cqe_ret);
+	if (ret || cqe_ret >= 0) {
+		fprintf(stderr, "0 buf test failed %i, cqe %i\n",
+				ret, cqe_ret);
+		exit(1);
+	}
+
+	reinit_ring(bd);
+	ret = test_vec(bd, &iov_inv, 1, true, &cqe_ret);
+	if (ret || cqe_ret >= 0) {
+		fprintf(stderr, "inv buf test failed %i, cqe %i\n",
+				ret, cqe_ret);
+		exit(1);
+	}
+
+	reinit_ring(bd);
+	ret = test_vec(bd, &iov_under, 1, true, &cqe_ret);
+	if (ret || cqe_ret >= 0) {
+		fprintf(stderr, "inv buf underflow failed %i, cqe %i\n",
+				ret, cqe_ret);
+		exit(1);
+	}
+
+	reinit_ring(bd);
+	ret = test_vec(bd, &iov_over, 1, true, &cqe_ret);
+	if (ret || cqe_ret >= 0) {
+		fprintf(stderr, "inv buf overflow failed %i, cqe %i\n",
+				ret, cqe_ret);
+		exit(1);
+	}
+}
+
+int main(void)
+{
+	struct buf_desc bd = {};
+	int i = 0;
+
+	page_sz = sysconf(_SC_PAGESIZE);
+
+	probe_support();
+	if (!has_regvec) {
+		printf("doesn't support registered vector ops, skip\n");
+		return 0;
+	}
+
+	init_buffers(&bd, page_sz * 32);
+	bd.fixed = true;
+
+	for (i = 0; i < 2; i++) {
+		bool rw = i & 1;
+
+		bd.rw = rw;
+
+		test_basic(&bd);
+		test_fail(&bd);
+	}
+
+	io_uring_queue_exit(&bd.ring);
+	return 0;
+}
-- 
2.48.1


