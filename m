Return-Path: <io-uring+bounces-13641-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id AWUOAa/TJmrclAIAu9opvQ
	(envelope-from <io-uring+bounces-13641-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 16:37:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 87B986574B1
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 16:37:34 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cvYXaqxn;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13641-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13641-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 50F7E30AA433
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2026 14:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2825E3D4103;
	Mon,  8 Jun 2026 14:25:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887963CB8F4
	for <io-uring@vger.kernel.org>; Mon,  8 Jun 2026 14:25:28 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780928730; cv=none; b=t7KtUfM08Kaut9+Lrvo4Jlb3sZ5pAHgbJLacunYlKDMfsYsJnAy4C4tcE9Oxxm+aEYuZzvOGAgFx5Ww6tVus5Ng7Yw31Za9URJX+rcVj25YiZBv8KdWwcg731B74q91hCVmwrnovLkoJ9hjXMJa//zJn2M0QRsDiAJLvTN6f3S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780928730; c=relaxed/simple;
	bh=gntQQ0MttVZBb6eByMrrxPx9FcqtEae3/MjSnV462IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apSS1MRrUOjsxCTc0WL16pxsVCObc9jCItIwqPBpqGWSS2EROGMH8vkHiAjuUKqKo2PloBPeLnGirmh8k6Fb4fJ4uAlJXgIcDrZt+gVhfQmzuoHOMcFbc1AFYIDQjpRwFGjeom+8S0s/ZGeN6qB0JyVsjA8Z5FxXCUOhGidVyrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cvYXaqxn; arc=none smtp.client-ip=74.125.224.54
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-66067da0638so2081013d50.0
        for <io-uring@vger.kernel.org>; Mon, 08 Jun 2026 07:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780928728; x=1781533528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6IBUN9g3UpeaN7UBpYXd5evjevnbt17VcQr5ryjzFoE=;
        b=cvYXaqxn+kb0q+XqEqJgkPaG4J6l+9E5vN9ccTrego154rx23x2jJwgioM57Wf513q
         5zngMvfuaLxU2deHb/vXcPq5jT2h3IoJTzv/TPGuA1D1HXLckRpDAkjQlzdKmPy40Ojv
         cgZ1xG6W+DcrUPlO3+JXFjVrn35zdkfEvqRdkHTtaKonqnW+YTGOGxjINfxsuwIYvrWM
         V1KHPWwaps3xkukaqtmfMqox6pwYpZMzKYodmhXD8u75saBMz4ZOsPbBRt3FsLVPjfAu
         /Kp4ExVCLkZkcFkQwB04bcUo/sSziOwKBIRxd1szTSJURU7F80YWw4tRMpMYr4DXxIjC
         BT+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780928728; x=1781533528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6IBUN9g3UpeaN7UBpYXd5evjevnbt17VcQr5ryjzFoE=;
        b=Xw07qbcFLjgOl5QDYP3bUNdYSVyT0DhVJMAYL/c5KDFeJ00Tt5yZfrwfrKajAd9m1C
         sY9bPwWSRQ6JILrUKmGNhgoUrY6N3NnTAgg8NxDF+kIYiwak7Sb7MNBovULZZ2V1LJ7M
         pZIah+whnpkFr6TAvobfjma3aJ5Jy21JfwNfZNTAz0t70/ERgr/5H3gNtZwxtw4WzvrM
         Lnx6xIeXxhHOo6XdVMoJktP/BzntLfgRUKsd/DeHSOqFKj1HnflcFVklj8PzOrUtLNxQ
         HyADSuYn5TkOLp+KIWDXc546i0dwvCbHT8EkbZ1DSqKnPpK8Udep5ZZ+TcZsqXIJi7oA
         o51A==
X-Forwarded-Encrypted: i=1; AFNElJ/h3chHxM9EBiKENvtu/uHj15VcDG78fOPX0OwQS+QngpPY1Xtu3OKknoe4COk53JuLJpcLPR4XRg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxCb5UauZVLXTQjowm5i2Q1MWFirXig8RDXnWMVCXCxCkQg+BEz
	NWScgrrzYePb1U0g/YaNyyf7FuySs2SB7DzkJxAFeaiBh4T9+Z4sVRxy
X-Gm-Gg: Acq92OGzY5pjuKq7ttuzDTPAAWYSTzQcFfQO3BPbHBCIZLHrbTRGnxKJXs8Rp03Y7N9
	M/iRf3lbSGppQuavZD81qFxwnG/b1n4SACkrPIOQBcjJMqzKnedfh2FR3ZtoLsdGz/p+r+0/MXW
	Bj1/XfuLUFhf4VXEVItplrIF6Pubufl/yN68tWDC4n5Eex2Odm1iIWnWGNfzqyhsbizJOlRtMwD
	wgFFkiXzO/KDQF+svkYYuBVv/lsm7gvTJyuoKr2C1dzrPCt//KHK18VmfVjtxVVDjvSYY/OUrHT
	gOrUxKqkUG4vVCEFBvoyPnYXvjse/JpxE2vxpvKEqEg3poQbutK0ezTKLO3HHQPYjjRc8ONHoyH
	DZh+JA6Voj6TuLUMGMsSIU8kjRuKAUG9nS0GiSQ+BtGl7Zx2Tt4WVUt6rvs7+y5DKZlYfomD7Sc
	Rnl7HinkK3F9rvh5zXcCQYHRssAZr00DSkc3Z+D8Pt+dCN3a/JXRcxqrlh1L0V5gCSoVENPs0SF
	FgszzIn8Shb47mnju79/RJnrxZGe4peqsbUKJG5kclLdVqeReJVDQ==
X-Received: by 2002:a05:690e:4185:b0:65e:37bc:c759 with SMTP id 956f58d0204a3-661070ccc17mr13301646d50.62.1780928727418;
        Mon, 08 Jun 2026 07:25:27 -0700 (PDT)
Received: from fedora.tail348456.ts.net ([172.245.82.59])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-661473db74asm239368d50.7.2026.06.08.07.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 07:25:26 -0700 (PDT)
From: Ming Lei <tom.leiming@gmail.com>
X-Google-Original-From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v2 2/2] test: add fixed-buf-send-recv for registered buffer send/recv
Date: Mon,  8 Jun 2026 09:25:11 -0500
Message-ID: <20260608142511.659240-3-ming.lei@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260608142511.659240-1-ming.lei@redhat.com>
References: <20260608142511.659240-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13641-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[tomleiming@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:tom.leiming@gmail.com,m:tomleiming@gmail.com,s:lists@lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tomleiming@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 87B986574B1

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
 test/fixed-buf-send-recv.c | 311 +++++++++++++++++++++++++++++++++++++
 2 files changed, 312 insertions(+)
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
index 00000000..d51bcf3f
--- /dev/null
+++ b/test/fixed-buf-send-recv.c
@@ -0,0 +1,311 @@
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
+ *  - negative cases: FIXED_BUF rejected on sendmsg, on bundle, on send
+ *    vectorized, on recv multishot, and a bad buf_index -> -EFAULT.
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
+	/* send + vectorized + FIXED_BUF -> -EINVAL */
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_send(sqe, sfd, nbuf, sizeof(nbuf), 0);
+	sqe->ioprio |= IORING_RECVSEND_FIXED_BUF | IORING_SEND_VECTORIZED;
+	sqe->buf_index = SBUF_IDX;
+	sqe->user_data = 14;
+	if (expect_res(ring, -EINVAL)) {
+		fprintf(stderr, "send vectorized+fixed_buf not rejected\n");
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


