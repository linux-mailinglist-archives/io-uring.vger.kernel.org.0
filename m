Return-Path: <io-uring+bounces-13993-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id IFFUG1IRVGqRhgMAu9opvQ
	(envelope-from <io-uring+bounces-13993-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2026 00:12:34 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BA7FC7461D3
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2026 00:12:33 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dgKUheIv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13993-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13993-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8CC943006783
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 22:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E1737C903;
	Sun, 12 Jul 2026 22:12:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A76437CD52
	for <io-uring@vger.kernel.org>; Sun, 12 Jul 2026 22:12:28 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783894350; cv=none; b=ECKSyAKh9WyXdlBlcPHIv+960u6Kj9jXjwbdz2iZ+fY8wiAno4QJ8NFuNan42UOnRwkEbe9nweKvQ4WXzNDnSKOVfsJmB4c7ej/32N9okUlnH3VTty/6oaNfX5vQ6X0CVv55mwUKmuXXhYtAHxreBn+PxaJcTlvwHf4cidmRdls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783894350; c=relaxed/simple;
	bh=W6gE3a3WnrJnvHMJFVNwiRRWVuTO6j8qHOFuE1naOrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPqqrPMd6jGtMrYYjiM+5TeIXVYey1j5dnzHUBusa99epjRR165pAUCJJu/GvD8mdLAS/DK3pNR7XjOThecc5nXZIYxE3XNL48E6ZzuLuRxcTgGkjIbFpS/qzZsZlccyu2y01HiIO1SzqNU4e4ZahCLIu8+mjXb+ijTaSh2CeKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dgKUheIv; arc=none smtp.client-ip=209.85.216.43
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-381216921aaso2813387a91.1
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2026 15:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783894347; x=1784499147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UltHCoHoX6DssGZu/TF1UDOWr4xicZVnue7q1BAN7xs=;
        b=dgKUheIvIiua5pMdY965ocF5RrZl+XtU88BIbcXfTboR+iBLux9gvu75MucaEHOWrM
         wmIFH2Egevueo/G/JxB/r5+pP0NVU6H+lmh6xJYBgY6iwd/46pTiUBSSMzSJ4JBs6gz6
         hjBtGdi5b5wttruQffBSvMcwYykxGx/c+W/RJYIoup6Bv1hOpAR3UXByfYpakzEsHSuL
         RURU/yQhlc+YYmrSCgs6MPnKKaAGp9ZapHdgHsHzmmWiezrjOjL1R0AUnxx6Tc7QuoDg
         dk4aZ2ni7T9e0q4vwQtFg3DPGXlcD0HZky4wN3D1AVc6EX/C2FFHtfsXJ3MHnP4Lyo4v
         HUxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783894347; x=1784499147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UltHCoHoX6DssGZu/TF1UDOWr4xicZVnue7q1BAN7xs=;
        b=QXS5kAoB5syXD4d+jnpc9BcHH+E5Yt6A+nfizzSdHK5MEZlW0GamNcizTYCLL9ABYT
         kpQnTOGzG22TEhKY3AInqxzJQohVmaqCb+EV2/IwlQRcFAZ3PTfo2SjkJelNymJ09pRX
         UhuHlC8ZSRVEewjRZjGtYIxt4JcCI+XAXz4vW2CaT9jBKqDFxt7IE9gHnV1C207CL95g
         +vcB6RL74fnJQvPdRCa1HDRzqr10k3SVpGaXgh6md+LThqT91tvvTwvnBxQJYfxryM+E
         sdzbS0DMw12Ta++/WCnsDic+RY6s6XPAliSpSn36m0Ck8jufeOv8mMVo9LWhdklPhZsQ
         RcJA==
X-Gm-Message-State: AOJu0YwmCPyduOTrv0a/2wSU7TJLlEVvKYUlqt4jDrjEWJvtnD2238Sj
	KuvW45Rdu6l3QvWayz+mz51y4hyPgQtQxdn3t2UG05ti33j5jQqHOzAWIfZXvTQtbu8=
X-Gm-Gg: AfdE7cmezyQ9oe0Cht6HBxiRMEbo0WOwLcqkIosKhSE2ULQZyd2yjcph3ZPkYptS96M
	7nR1cEwqBrDA7i3OJz3lGK5JWXF3511X8KSKfXGfWtud+eqxo+CDUdV25JYYBGPIC88QWjDUW2e
	uYI9xiKbECYoOQig2L+l4S++q8jZr+NSBhnyDXzSTegSkaE6hFmjBsBj8l1Vw2QJx45igy33d52
	YF2h5F+O9c0HeAbOuEyPNb+bwyLeRKHZF0G7W6bGuvoPwgjzW7IwyAwrts6PkrfUN23F3S+qyfu
	fr54LQmrNuJEXK6Mn9RHLe1wJxZoK5jp/H8ey5x2vJbp4a2fQOC1GMY+gfnEuDvCd14tLHfSTEP
	Yt/KZhl9vtYS78lf+iNZxRJG3gs2itSA5M6yvm8xJa04XAoVRjSlyKXIUsdtaEWzxMwblgl+D6V
	WktjrxJgmY+P8GXXoc+kKeGfc1fgHLzdBRRScw2VmAOmRjNz6wSPSqIf+6CKpu4xMyuX6iPlSbq
	kB2VX9GO2A+mNEoggMEjN31gNdqV9T4iDfBSEXfTZqXmrrYTUfh29tkaPYvvStB87Eooztnlvc=
X-Received: by 2002:a17:90b:314c:b0:380:94de:155e with SMTP id 98e67ed59e1d1-38dc73c1d67mr6317443a91.5.1783894347218;
        Sun, 12 Jul 2026 15:12:27 -0700 (PDT)
Received: from prateek-Aspire-A515-57G.. ([182.77.75.84])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174accb0esm65968556eec.30.2026.07.12.15.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 15:12:26 -0700 (PDT)
From: Prateek <kprateek283@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	Prateek <kprateek283@gmail.com>
Subject: [PATCH 2/2] test/timeout-swallow: verify -ETIME is not swallowed
Date: Mon, 13 Jul 2026 03:42:22 +0530
Message-ID: <20260712221222.535794-1-kprateek283@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260712221049.534729-1-kprateek283@gmail.com>
References: <20260712221049.534729-1-kprateek283@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13993-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[kprateek283@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:kprateek283@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kprateek283@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: BA7FC7461D3

Regression test for the previous commit. Submits an SQE and waits with a
zero timeout for more completions than can arrive; the result must be
-ETIME, not the positive submit count. Covers the normal EXT_ARG wait
path and the registered-wait path, each skipped gracefully where
unsupported.

Signed-off-by: Prateek <kprateek283@gmail.com>
---
 test/Makefile          |   1 +
 test/timeout-swallow.c | 117 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 118 insertions(+)
 create mode 100644 test/timeout-swallow.c

diff --git a/test/Makefile b/test/Makefile
index d6358a93..ae23ef6d 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -293,6 +293,7 @@ test_srcs := \
 	timerfd-short-read.c \
 	timeout.c \
 	timeout-new.c \
+	timeout-swallow.c \
 	timestamp.c \
 	timestamp-bug.c \
 	truncate.c \
diff --git a/test/timeout-swallow.c b/test/timeout-swallow.c
new file mode 100644
index 00000000..9fb4ab01
--- /dev/null
+++ b/test/timeout-swallow.c
@@ -0,0 +1,117 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: tests that io_uring_wait_cqes() and variants do not swallow 
+ *              -ETIME when loop-fetching CQEs if some SQEs were submitted.
+ */
+#include <stdio.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/time.h>
+#include "liburing.h"
+#include "helpers.h"
+
+/*
+ * Test the normal -ETIME swallow path. (line 118 in queue.c)
+ */
+static int test_timeout(struct io_uring *ring)
+{
+    struct io_uring_sqe *sqe;
+    struct io_uring_cqe *cqe;
+    struct __kernel_timespec long_ts = { .tv_sec = 10, .tv_nsec = 0 };
+    struct __kernel_timespec zero_ts = { .tv_sec = 0, .tv_nsec = 0 };
+    int ret;
+
+    if (!(ring->features & IORING_FEAT_EXT_ARG))
+        return T_EXIT_SKIP;
+
+    sqe = io_uring_get_sqe(ring);
+    if (!sqe) {
+        fprintf(stderr, "get_sqe failed\n");
+        return T_EXIT_FAIL;
+    }
+    /* Long timeout, won't complete immediately */
+    io_uring_prep_timeout(sqe, &long_ts, 1, 0);
+    
+    /* Zero timeout forces immediate expiry inside the syscall on first/second pass */
+    ret = io_uring_submit_and_wait_timeout(ring, &cqe, 2, &zero_ts, NULL);
+    
+    if (ret == -ETIME) {
+        return T_EXIT_PASS;
+    }
+
+    fprintf(stderr, "test_timeout failed: expected -ETIME, got %d\n", ret);
+    return T_EXIT_FAIL;
+}
+
+/*
+ * Test the registered-wait -ETIME swallow path. (line 113 in queue.c)
+ */
+static int test_timeout_reg(struct io_uring *ring)
+{
+    struct io_uring_sqe *sqe;
+    struct io_uring_cqe *cqe;
+    struct __kernel_timespec long_ts = { .tv_sec = 10, .tv_nsec = 0 };
+    struct io_uring_reg_wait reg = { .ts = { .tv_sec = 0, .tv_nsec = 0 } };
+    int ret;
+
+    if (!(ring->features & IORING_FEAT_EXT_ARG))
+        return T_EXIT_SKIP;
+
+    ret = io_uring_register_wait_reg(ring, &reg, 1);
+    if (ret) {
+        /* Not supported on this kernel */
+        return T_EXIT_SKIP;
+    }
+
+    sqe = io_uring_get_sqe(ring);
+    if (!sqe) {
+        fprintf(stderr, "get_sqe failed\n");
+        return T_EXIT_FAIL;
+    }
+    io_uring_prep_timeout(sqe, &long_ts, 1, 0);
+    
+    ret = io_uring_submit_and_wait_reg(ring, &cqe, 2, 0);
+    if (ret == -ETIME) {
+        return T_EXIT_PASS;
+    }
+
+    fprintf(stderr, "test_timeout_reg failed: expected -ETIME, got %d\n", ret);
+    return T_EXIT_FAIL;
+}
+
+int main(int argc, char *argv[])
+{
+    struct io_uring ring;
+    int ret, ret2, final_ret = T_EXIT_PASS;
+
+    if (argc > 1)
+        return T_EXIT_SKIP;
+
+    ret = io_uring_queue_init(8, &ring, 0);
+    if (ret) {
+        if (ret == -ENOSYS)
+            return T_EXIT_SKIP;
+        fprintf(stderr, "queue_init failed: %d\n", ret);
+        return T_EXIT_FAIL;
+    }
+
+    ret = test_timeout(&ring);
+    if (ret == T_EXIT_FAIL) {
+        fprintf(stderr, "test_timeout failed\n");
+        final_ret = T_EXIT_FAIL;
+    }
+
+    ret2 = test_timeout_reg(&ring);
+    if (ret2 == T_EXIT_FAIL) {
+        fprintf(stderr, "test_timeout_reg failed\n");
+        final_ret = T_EXIT_FAIL;
+    }
+
+    io_uring_queue_exit(&ring);
+
+    if (final_ret == T_EXIT_FAIL)
+        return T_EXIT_FAIL;
+    if (ret == T_EXIT_SKIP && ret2 == T_EXIT_SKIP)
+        return T_EXIT_SKIP;
+    return T_EXIT_PASS;
+}
-- 
2.43.0


