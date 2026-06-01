Return-Path: <io-uring+bounces-13579-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gDGIAthZHWq/ZgkAu9opvQ
	(envelope-from <io-uring+bounces-13579-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 12:07:20 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E8E261D0B9
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 12:07:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 325023004F01
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2026 10:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0283B38C429;
	Mon,  1 Jun 2026 09:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ShikGvp2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA383ADB89
	for <io-uring@vger.kernel.org>; Mon,  1 Jun 2026 09:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780307962; cv=none; b=WLocUoCU/K7xmZ7DTjuX3OdExcWN/YyyKFDnTbf9inFx39bt4Ze3dhUu7t/0P2kSSO895nNcNGt87P8AlXByhZ4VgPdFb6LKdhk6muxG/WMSZ0b4cqi6tO8RlJPMdOPfr11+qF24aclHQm+SpzcG5gWsWGt4jvByidfIo3q98So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780307962; c=relaxed/simple;
	bh=zUHCt+3lzFgRWJ7Mh/VePeXYK8A3FRlspYLdW1ynixk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CruLtRyFPRIvSkokAKZ/sPeG2mU8qpE99iwTsqjBAc3y1yQYzy3qqpcz2CIqrfCi1Qui7pCp67D6ZU6DrQsiO252997G20ySBaQfXm/aALIjLScN0ps6X9Jd1uYdcvor4f8WsN73pWK992kSaHHCvlJghlhtyvTdb/CUQc/fCto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ShikGvp2; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-91550eceb4cso114728585a.1
        for <io-uring@vger.kernel.org>; Mon, 01 Jun 2026 02:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780307951; x=1780912751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2J8UxEeE3VkihSgc7mbsM9SoyNvUai/YRJpH21URguM=;
        b=ShikGvp2+K8easgLMhPBsWofZWtH1Ahcel7L4DeNrXpeL212SHbzlxpTq/8S9NIQks
         ovVxUi0a0E/bVaQfvLLmSZS2iYg4fnfJzO+AuQnk1urQX8aZ7x+uYqpT19e7WxIUYzAj
         ERfT15hAoRlCzINfref6L7L4OHm5biV9iTgrC0Q3yyZv+kuJsieUEah51LEC2Bx/jijY
         46svX7HyowLYHNEVR03sGvVqZZfct2h2ID1Xx/Mikxbe1EI0Youi7YkWuVjAhGGpNLaY
         4kzQXc+zzYVWzGmWp1hxoN1TqZHdZ5MPHVYODwaE/6lYlWgsS7cycxuNZ8crxQkg5jq9
         ISzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780307951; x=1780912751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2J8UxEeE3VkihSgc7mbsM9SoyNvUai/YRJpH21URguM=;
        b=Cb2ztxCVuKZSeiPo1B1mhIDFpjsCpVHAL8brQaCOvMXj3eRcQNQEzsvBWydjV6+JoP
         Btiq9clcZCwQbESFbP2baedV9n+RGPib34u2m0YvPVoxGWyAwWYRm7+jcE9SgFVqWHqW
         v9BxXJxkFXSSKtJst0Y4lqw18vBe+bw8GT6/XEYBVIic0REMIOpcRVClRhzjnMIMivx0
         otWqifJZ5uqXx2TfaixENxgYOih6uhWB9EAB7dyUni3MsWfur6O7VLCnNrrtqm2mIGPC
         J0aSLsCVeuIawCFCNs83ftUquNoNLDtx+f4pOYbDJgNdTDFJhsp7YwsB+AbGhlDn46pU
         M9ig==
X-Forwarded-Encrypted: i=1; AFNElJ/81JrLY0CkOO9tlj5gjLvzdE4JFMZ0V6lcNTSl3ZFzCZZbQWDnpZw57JuG61zrp8nRvMYkX0jzqg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzaPcmG/4nUnXSsg8+/j5UYNBF26Qr2VbZ6XK/zaBgk/L5m2gUM
	u6Z22+gv2J8qpABcgro/xssYkcdbxsec1mtEfc6U8GvBZw20KaPCZmAG
X-Gm-Gg: Acq92OEdcVzLu3BiQtIK3/3ws5qNU18dLESZR2aR4vPz7X3tNGyYNFitm9faKF3fqr+
	C7+dhgKOrOXv+4boRUuS2dv+XFYQ4iRYYUti6BgdmgnGtkHbJso5bcm5i1Iwj4QQAMmQ9OA16CP
	WCRWAWNP17cZphQhMVU2SvTl+LekvUqS3qtv99kc6hN7VgaIW59nlVP7FLWtiRnoJBWhXL+nRi/
	fQI67CEdkXXVqoS9erBLLJF/df1a5GwfU0Xo1mouHxkn9rJtppwyq+fz23Eo3ZgLweIgI81CCOE
	GB7l2QyRul3tk3g5Cv6LoJPfULG/XluUifOWWF7WzJM3Wedf2I5Hct9AMsidRUmfbgzXqFFny1W
	MmxsZ5lKRyQ1NiCj5PPM0LU1UfO8uxRNknJur2KysuivGNjpHGjC99Yh0q7ixzgnt0qyG2Mtw+B
	yJ7DiQa2gcrtGw8pOx79K9bZDdxWtNfwGEi8kMUDSjxdmqJrerMzU6OFEUicGuPCBCX1awYUYYa
	YZJdtwPpQFE3bFUpuoLRvHgSWMan3Bizwo2hRCPF12j5llO0dR65w==
X-Received: by 2002:a05:620a:2614:b0:915:6c4e:5116 with SMTP id af79cd13be357-9156c4e53d8mr158510785a.6.1780307951049;
        Mon, 01 Jun 2026 02:59:11 -0700 (PDT)
Received: from fedora.tail348456.ts.net ([172.245.82.59])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915721f7d75sm32658285a.18.2026.06.01.02.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 02:59:10 -0700 (PDT)
From: Ming Lei <tom.leiming@gmail.com>
X-Google-Original-From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/2] liburing test: add fixed-buf-send-recv for registered buffer send/recv
Date: Mon,  1 Jun 2026 04:58:46 -0500
Message-ID: <20260601095853.3670199-3-ming.lei@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601095853.3670199-1-ming.lei@redhat.com>
References: <20260601095853.3670199-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13579-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tomleiming@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 8E8E261D0B9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Ming Lei <tom.leiming@gmail.com>

Exercise IORING_RECVSEND_FIXED_BUF on plain IORING_OP_SEND and
IORING_OP_RECV: send-fixed, recv-fixed and both-fixed roundtrips with
non-zero offsets into distinct registered buffers, a large MSG_WAITALL
transfer to cover the persisted bvec iter across partial retries, plus
negative cases (sendmsg/bundle/recv-multishot rejected with -EINVAL and
a bad buf_index returning -EFAULT).

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 test/Makefile              |   1 +
 test/fixed-buf-send-recv.c | 300 +++++++++++++++++++++++++++++++++++++
 2 files changed, 301 insertions(+)
 create mode 100644 test/fixed-buf-send-recv.c

diff --git a/test/Makefile b/test/Makefile
index d1cd2470..effb3bae 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -132,6 +132,7 @@ test_srcs := \
 	file-verify.c \
 	fixed-buf-iter.c \
 	fixed-buf-merge.c \
+	fixed-buf-send-recv.c \
 	fixed-hugepage.c \
 	fixed-link.c \
 	fixed-reuse.c \
diff --git a/test/fixed-buf-send-recv.c b/test/fixed-buf-send-recv.c
new file mode 100644
index 00000000..5e84935b
--- /dev/null
+++ b/test/fixed-buf-send-recv.c
@@ -0,0 +1,300 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Test IORING_RECVSEND_FIXED_BUF on plain IORING_OP_SEND / IORING_OP_RECV.
+ *
+ * A registered (fixed) buffer can be used as the send source and/or the recv
+ * destination over a TCP socket via IORING_RECVSEND_FIXED_BUF. Covers:
+ *  - send fixed  -> recv normal
+ *  - send normal -> recv fixed
+ *  - send fixed  -> recv fixed   (both ends registered, non-zero offsets)
+ *  - large MSG_WAITALL transfer (exercises the persisted bvec iter across
+ *    partial send/recv retries)
+ *  - negative cases: FIXED_BUF rejected on sendmsg, on bundle, on recv
+ *    multishot, and a bad buf_index -> -EFAULT.
+ */
+#include <errno.h>
+#include <limits.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/socket.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+#define BUF_SIZE	(128 * 1024)
+#define OFF		4096
+
+/* registered buffer indices */
+#define SBUF_IDX	0
+#define RBUF_IDX	1
+
+static int no_fixed_buf;
+
+static void fill_pattern(unsigned char *buf, size_t len, unsigned seed)
+{
+	size_t i;
+
+	for (i = 0; i < len; i++)
+		buf[i] = (unsigned char)((i + seed) & 0xff);
+}
+
+/*
+ * Submit a paired send (user_data 1) + recv (user_data 2) and wait for both.
+ * Either side may use a registered buffer. Returns 0 on success with the
+ * received data verified against the sent pattern, -EINVAL if the kernel
+ * doesn't support the flag, or 1 on hard failure.
+ */
+static int do_roundtrip(struct io_uring *ring, int sfd, int rfd,
+			unsigned char *sptr, unsigned char *rptr, size_t len,
+			int s_fixed, int r_fixed, int waitall)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret, i, sflags = 0, rflags = 0;
+	int s_res = INT_MIN, r_res = INT_MIN;
+	static unsigned seed;
+
+	seed++;
+	if (waitall) {
+		sflags |= MSG_WAITALL;
+		rflags |= MSG_WAITALL;
+	}
+
+	fill_pattern(sptr, len, seed);
+	memset(rptr, 0, len);
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_send(sqe, sfd, sptr, len, sflags);
+	if (s_fixed) {
+		sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
+		sqe->buf_index = SBUF_IDX;
+	}
+	sqe->user_data = 1;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_recv(sqe, rfd, rptr, len, rflags);
+	if (r_fixed) {
+		sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
+		sqe->buf_index = RBUF_IDX;
+	}
+	sqe->user_data = 2;
+
+	ret = io_uring_submit_and_wait(ring, 2);
+	if (ret != 2) {
+		fprintf(stderr, "submit_and_wait: %d\n", ret);
+		return 1;
+	}
+
+	for (i = 0; i < 2; i++) {
+		ret = io_uring_peek_cqe(ring, &cqe);
+		if (ret) {
+			fprintf(stderr, "peek_cqe: %d\n", ret);
+			return 1;
+		}
+		if (cqe->user_data == 1)
+			s_res = cqe->res;
+		else
+			r_res = cqe->res;
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	if (s_res == -EINVAL || r_res == -EINVAL) {
+		no_fixed_buf = 1;
+		return -EINVAL;
+	}
+	if (s_res != (int)len) {
+		fprintf(stderr, "send res %d, want %zu (s_fixed=%d)\n",
+			s_res, len, s_fixed);
+		return 1;
+	}
+	if (r_res != (int)len) {
+		fprintf(stderr, "recv res %d, want %zu (r_fixed=%d)\n",
+			r_res, len, r_fixed);
+		return 1;
+	}
+	if (memcmp(sptr, rptr, len)) {
+		fprintf(stderr, "data mismatch (s_fixed=%d r_fixed=%d len=%zu)\n",
+			s_fixed, r_fixed, len);
+		return 1;
+	}
+	return 0;
+}
+
+/* Submit one sqe (already prepared by caller) and expect a specific res. */
+static int expect_res(struct io_uring *ring, int expect)
+{
+	struct io_uring_cqe *cqe;
+	int ret, res;
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit: %d\n", ret);
+		return 1;
+	}
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe: %d\n", ret);
+		return 1;
+	}
+	res = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	if (res != expect) {
+		fprintf(stderr, "got res %d, expected %d\n", res, expect);
+		return 1;
+	}
+	return 0;
+}
+
+static int test_negative(struct io_uring *ring, int sfd)
+{
+	struct io_uring_sqe *sqe;
+	struct msghdr msg = { };
+	struct iovec iov;
+	static char nbuf[64];
+
+	/* sendmsg + FIXED_BUF is only allowed for plain send -> -EINVAL */
+	iov.iov_base = nbuf;
+	iov.iov_len = sizeof(nbuf);
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_sendmsg(sqe, sfd, &msg, 0);
+	sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
+	sqe->buf_index = SBUF_IDX;
+	sqe->user_data = 10;
+	if (expect_res(ring, -EINVAL)) {
+		fprintf(stderr, "sendmsg+fixed_buf not rejected\n");
+		return 1;
+	}
+
+	/* send + bundle + FIXED_BUF -> -EINVAL */
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_send(sqe, sfd, nbuf, sizeof(nbuf), 0);
+	sqe->ioprio |= IORING_RECVSEND_FIXED_BUF | IORING_RECVSEND_BUNDLE;
+	sqe->buf_index = SBUF_IDX;
+	sqe->user_data = 11;
+	if (expect_res(ring, -EINVAL)) {
+		fprintf(stderr, "send bundle+fixed_buf not rejected\n");
+		return 1;
+	}
+
+	/* recv multishot + FIXED_BUF -> -EINVAL */
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_recv_multishot(sqe, sfd, nbuf, sizeof(nbuf), 0);
+	sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
+	sqe->buf_index = RBUF_IDX;
+	sqe->user_data = 12;
+	if (expect_res(ring, -EINVAL)) {
+		fprintf(stderr, "recv multishot+fixed_buf not rejected\n");
+		return 1;
+	}
+
+	/* send fixed with an unregistered buf_index -> -EFAULT at issue */
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_send(sqe, sfd, nbuf, sizeof(nbuf), 0);
+	sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
+	sqe->buf_index = 42;
+	sqe->user_data = 13;
+	if (expect_res(ring, -EFAULT)) {
+		fprintf(stderr, "send fixed bad index not -EFAULT\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	struct iovec regvec[2];
+	unsigned char *sbuf, *rbuf, *hbuf;
+	int ret, fds[2];
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	if (posix_memalign((void **)&sbuf, 4096, BUF_SIZE) ||
+	    posix_memalign((void **)&rbuf, 4096, BUF_SIZE)) {
+		fprintf(stderr, "posix_memalign failed\n");
+		return T_EXIT_FAIL;
+	}
+	hbuf = malloc(BUF_SIZE);
+	if (!hbuf)
+		return T_EXIT_FAIL;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue_init: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	regvec[SBUF_IDX].iov_base = sbuf;
+	regvec[SBUF_IDX].iov_len = BUF_SIZE;
+	regvec[RBUF_IDX].iov_base = rbuf;
+	regvec[RBUF_IDX].iov_len = BUF_SIZE;
+	ret = io_uring_register_buffers(&ring, regvec, 2);
+	if (ret) {
+		fprintf(stderr, "register_buffers: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = t_create_socket_pair(fds, true);
+	if (ret) {
+		fprintf(stderr, "socket pair: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	/* send fixed -> recv normal (also doubles as feature detection) */
+	ret = do_roundtrip(&ring, fds[1], fds[0], sbuf + OFF, hbuf, 4096,
+			   1, 0, 0);
+	if (ret == -EINVAL) {
+		fprintf(stderr, "IORING_RECVSEND_FIXED_BUF send unsupported, skip\n");
+		return T_EXIT_SKIP;
+	}
+	if (ret)
+		goto fail;
+
+	/* send normal -> recv fixed */
+	ret = do_roundtrip(&ring, fds[1], fds[0], hbuf, rbuf + OFF, 4096,
+			   0, 1, 0);
+	if (ret == -EINVAL) {
+		fprintf(stderr, "IORING_RECVSEND_FIXED_BUF recv unsupported, skip\n");
+		return T_EXIT_SKIP;
+	}
+	if (ret)
+		goto fail;
+
+	/* send fixed -> recv fixed, non-zero offsets on both ends */
+	ret = do_roundtrip(&ring, fds[1], fds[0], sbuf + OFF, rbuf + 2 * OFF,
+			   8192, 1, 1, 0);
+	if (ret)
+		goto fail;
+
+	/* large transfer with MSG_WAITALL: persisted bvec iter across retries */
+	ret = do_roundtrip(&ring, fds[1], fds[0], sbuf, rbuf, BUF_SIZE,
+			   1, 1, 1);
+	if (ret)
+		goto fail;
+
+	/* and the other direction */
+	ret = do_roundtrip(&ring, fds[0], fds[1], sbuf, rbuf, BUF_SIZE,
+			   1, 1, 1);
+	if (ret)
+		goto fail;
+
+	if (test_negative(&ring, fds[1]))
+		goto fail;
+
+	io_uring_queue_exit(&ring);
+	close(fds[0]);
+	close(fds[1]);
+	free(hbuf);
+	free(sbuf);
+	free(rbuf);
+	return T_EXIT_PASS;
+fail:
+	fprintf(stderr, "test failed\n");
+	return T_EXIT_FAIL;
+}
-- 
2.54.0


