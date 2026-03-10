Return-Path: <io-uring+bounces-12628-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YHjvBbp0sGnJjQIAu9opvQ
	(envelope-from <io-uring+bounces-12628-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 20:44:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 73C462571BA
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 20:44:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 34DD5303457B
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 19:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C8534C9AB;
	Tue, 10 Mar 2026 19:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SO8XnEVX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3143563C9
	for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 19:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773171895; cv=none; b=fX2vNgq41BmMW04G6n/SNTKvqP2vTG2o1gummx7bHOpI2jwJ8REusFM6XZHMBjeSO5SdQQH4AFkyLS1JlT/R6ZZcrOnuoqfJwTBVldq97x1TBJTkdWkf39nf96O3S6PGALGBQ5JKQ3V2yZRjNp4WUlvau+b3fMMSJUKq1VzWVdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773171895; c=relaxed/simple;
	bh=S10HuTf8JJvgJwuXje5gqp0BFxhj6Bbtmp5pWtyMuGo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TJrLef/WwQ0zYK8UnVEaX51+UiHLcCu5aNzpz4h8Tq+JJtOyOGFSAceFQ6FC8KZnA9UnL7A6S2VjHlcIAOLGd/asT1sMextzrxFb6x4cPthuSTuwbAlnXsxEykAh34+8AJ/32lN9amAaXHdwn8SQsNvsyxLgqKfl19I06ukteCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SO8XnEVX; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-128d2e3082eso1585223c88.0
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 12:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773171893; x=1773776693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=36EWxTTntbTH5Lk3IubOOLTR86dskPWeSrp6eTKLkAs=;
        b=SO8XnEVXtLYHM4hkB2Q7cJ4WhffKUDz9ndSO+xs9wwrMnbuia/5EpFaYj+HbkS+/jE
         xYjHybveHeI1YoJrqR8nKV7fZoDP2Ce5V0TS+gIJfqERzybHBzrjvFmjAdBVEtQ9+KTN
         O0tTpdLjZ93J1KlIxVRSSxzjx9+2xBSJ3utGAlTfOBUTGEiv1y61ohyVb8fUtJHcBYtT
         0U1p8eVLUx2/Ym9QE8lo1ZX3XnPC6blh9mtzulLUrGF9i2fPU/HDViYZRIJNgvKo6TQu
         wzE2pCC8zFTgx5de/48Y2lz96S/Qo/8dD43g5W7pXbl3Ggdag6gphGLqlzF/PhSIobX7
         nb8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773171893; x=1773776693;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=36EWxTTntbTH5Lk3IubOOLTR86dskPWeSrp6eTKLkAs=;
        b=AqYi6f7MFSlCKTojRgt+KqU6fD3f9VbUBPSGbjXA1Pk2UltZWXVsbXCuKCQtVa8JX8
         ZAS9JB1YIa04KAmC60mX07ImriPjWitg5Xdtv3HV3fbvA/vqhoyub4tx2TNl1IEuuGiz
         MzDDC8mjTA1np18zcHFgWloVnkgqBEhgPcOVbhRh6M1vx0mAYMSLN+fSu+0ZgbYQMBAu
         3GHMmYvrC+IokKy4uAalupGA8/ifY2Tg+jrOYWPuk6FJADgQkI17Ua/AeKYQkD9IaU57
         dDT30SGAKIXIuRrlfP62IZfgYRM7PPnONV8ZZhmOCmScTLyW0u2mkhaDtzrdFNJ+TxHH
         tu7g==
X-Gm-Message-State: AOJu0Yx+xJZQF2XF0pAMpNI6EsH/KDv0LGnd56Cg7rabYc9CgpiCcrjg
	tjpFpdAHeWRDq9boF2FJeQF66DsqOu6pRyU3eyqJLOFgSy8fTtyQ/wT9Dv899dKo
X-Gm-Gg: ATEYQzwP80Jxh4QzbkzTT+TsSVYn5q5rPflchG0zXT4pE2UCVuR58v8bKGU4ReoG7tI
	FALpVrYOJdlDmeyrMvj1XmYAMcYvA7AUa3eXlfB+7rakFn7AXHe/6hGJrf4aNEtGTLkjTxTj/Al
	9NmKobivkRUNfY/ZcP3B+09vU5ZpdUdEIJPnr8RMGKES9WKazV0L5OYZQUgE0p5h6wpV8e1XxEb
	qDr+gsEs0fEq91fzzlPqFUkvsCiGgP5rD/Dcx5WZvjSK2zu5ghhxGgEhsNSlY1hZBqLKFlYPfJe
	IJwPDnXyupSJudxfKoScC+Lv/EM1qs26uqtKrhLEUvgjsH6vA24v6uGUAqPGWKMsjmHuJhx4jYe
	1Itp6L9hnwCWkIfx3SX84tJgjMwEUmpLgmKRj4/eK8LrwM68n6+8v1mFbLbQba9IMoPh6YrG/Eq
	1W4BpC4+6Ew/YefAjflS8aWzJhAu9klzHiGgVVBJPyhOmQBamt9Uyv4i++iKLuBMixyGcOsSUER
	HqExuHtalAM
X-Received: by 2002:a05:7022:4594:b0:11b:9386:7ecd with SMTP id a92af1059eb24-128c2ed02c5mr7222531c88.42.1773171893199;
        Tue, 10 Mar 2026 12:44:53 -0700 (PDT)
Received: from localhost.localdomain ([185.187.168.186])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128d5aa8f5esm11832861c88.6.2026.03.10.12.44.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Mar 2026 12:44:52 -0700 (PDT)
From: Tom Ryan <ryan36005@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	gregkh@linuxfoundation.org,
	kbusch@meta.com,
	csander@purestorage.com,
	Tom Ryan <ryan36005@gmail.com>
Subject: [PATCH v2 liburing] test/sqe-mixed-boundary: validate physical SQE index for 128-byte ops
Date: Tue, 10 Mar 2026 12:44:49 -0700
Message-ID: <20260310194449.79258-1-ryan36005@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 73C462571BA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.dk,linuxfoundation.org,meta.com,purestorage.com,gmail.com];
	TAGGED_FROM(0.00)[bounces-12628-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ryan36005@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Add a test for the kernel fix that replaces the cached_sq_head alignment
check with physical SQE index validation in io_init_req() for SQE_MIXED
128-byte operations.

test_valid_position: verifies that a NOP128 at a valid physical slot
(identity-mapped via sq_array) succeeds.

test_oob_boundary: verifies that a NOP128 remapped via sq_array to the
last physical SQE slot is rejected with -EINVAL, preventing a 64-byte
OOB read past the SQE array.

Signed-off-by: Tom Ryan <ryan36005@gmail.com>
---
v1 -> v2:
 - Use t_io_uring_init_sqarray() to bypass NO_SQARRAY fallback,
   ensuring sq_array is available for physical index remapping
 - Fix CQE wait loop count (2 SQEs submitted, not 3)
 - Build-tested and run-tested on Linux 7.0.0-rc3 ARM64

 test/Makefile             |   1 +
 test/sqe-mixed-boundary.c | 184 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 185 insertions(+)
 create mode 100644 test/sqe-mixed-boundary.c

diff --git a/test/Makefile b/test/Makefile
index 7b94a1f..a10d44c 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -253,6 +253,7 @@ test_srcs := \
 	sq-poll-share.c \
 	sqpoll-sleep.c \
 	sq-space_left.c \
+	sqe-mixed-boundary.c \
 	sqe-mixed-nop.c \
 	sqe-mixed-bad-wrap.c \
 	sqe-mixed-uring_cmd.c \
diff --git a/test/sqe-mixed-boundary.c b/test/sqe-mixed-boundary.c
new file mode 100644
index 0000000..fe8ed09
--- /dev/null
+++ b/test/sqe-mixed-boundary.c
@@ -0,0 +1,184 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test SQE_MIXED physical SQE boundary validation with sq_array
+ *
+ * Verify that 128-byte operations are correctly rejected when sq_array
+ * remaps them to the last physical SQE slot, preventing a 64-byte OOB
+ * read past the SQE array.
+ */
+#include <stdio.h>
+#include <string.h>
+
+#include "liburing.h"
+#include "helpers.h"
+#include "test.h"
+
+#define NENTRIES	64
+
+/*
+ * Positive test: NOP128 at a valid physical position should succeed.
+ */
+static int test_valid_position(void)
+{
+	struct io_uring ring;
+	struct io_uring_params p = { .flags = IORING_SETUP_SQE_MIXED };
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret;
+
+	ret = t_io_uring_init_sqarray(NENTRIES, &ring, &p);
+	if (ret) {
+		if (ret == -EINVAL)
+			return T_EXIT_SKIP;
+		fprintf(stderr, "ring init: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_nop(sqe);
+	sqe->user_data = 1;
+
+	sqe = io_uring_get_sqe128(&ring);
+	if (!sqe) {
+		fprintf(stderr, "get_sqe128 failed\n");
+		goto fail;
+	}
+	io_uring_prep_nop128(sqe);
+	sqe->user_data = 2;
+
+	ret = io_uring_submit(&ring);
+	if (ret < 0) {
+		fprintf(stderr, "submit: %d\n", ret);
+		goto fail;
+	}
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe: %d\n", ret);
+		goto fail;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe: %d\n", ret);
+		goto fail;
+	}
+	if (cqe->user_data == 2 && cqe->res != 0) {
+		fprintf(stderr, "NOP128 at valid position failed: %d\n",
+			cqe->res);
+		io_uring_cqe_seen(&ring, cqe);
+		goto fail;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	io_uring_queue_exit(&ring);
+	return T_EXIT_PASS;
+fail:
+	io_uring_queue_exit(&ring);
+	return T_EXIT_FAIL;
+}
+
+/*
+ * Negative test: NOP128 at the last physical SQE slot via sq_array remap
+ * must be rejected. Without the kernel fix, this triggers a 64-byte OOB
+ * read in io_uring_cmd_sqe_copy().
+ */
+static int test_oob_boundary(void)
+{
+	struct io_uring ring;
+	struct io_uring_params p = { .flags = IORING_SETUP_SQE_MIXED };
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	unsigned mask;
+	int ret, i, found;
+
+	ret = t_io_uring_init_sqarray(NENTRIES, &ring, &p);
+	if (ret) {
+		if (ret == -EINVAL)
+			return T_EXIT_SKIP;
+		fprintf(stderr, "ring init: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	mask = *ring.sq.kring_entries - 1;
+
+	/* Advance internal tail: NOP (1) + NOP128 (2) = 3 slots */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_nop(sqe);
+	sqe->user_data = 1;
+
+	sqe = io_uring_get_sqe128(&ring);
+	if (!sqe) {
+		fprintf(stderr, "get_sqe128 failed\n");
+		goto fail;
+	}
+
+	/*
+	 * Override: remap logical position 1 to last physical slot.
+	 * Prep NOP128 there instead of the position get_sqe128 returned.
+	 */
+	ring.sq.array[1] = mask;
+	memset(&ring.sq.sqes[mask], 0, sizeof(struct io_uring_sqe));
+	io_uring_prep_nop128(&ring.sq.sqes[mask]);
+	ring.sq.sqes[mask].user_data = 2;
+
+	ret = io_uring_submit(&ring);
+	if (ret < 0) {
+		fprintf(stderr, "submit: %d\n", ret);
+		goto fail;
+	}
+
+	found = 0;
+	for (i = 0; i < 2; i++) {
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret)
+			break;
+		if (cqe->user_data == 2) {
+			if (cqe->res != -EINVAL) {
+				fprintf(stderr,
+					"NOP128 at last slot: expected -EINVAL, got %d\n",
+					cqe->res);
+				io_uring_cqe_seen(&ring, cqe);
+				goto fail;
+			}
+			found = 1;
+		}
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	if (!found) {
+		fprintf(stderr, "no CQE for NOP128 boundary test\n");
+		goto fail;
+	}
+
+	io_uring_queue_exit(&ring);
+	return T_EXIT_PASS;
+fail:
+	io_uring_queue_exit(&ring);
+	return T_EXIT_FAIL;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	ret = test_valid_position();
+	if (ret == T_EXIT_SKIP)
+		return T_EXIT_SKIP;
+	if (ret) {
+		fprintf(stderr, "test_valid_position failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_oob_boundary();
+	if (ret) {
+		fprintf(stderr, "test_oob_boundary failed\n");
+		return ret;
+	}
+
+	return T_EXIT_PASS;
+}
-- 
2.50.1 (Apple Git-155)


