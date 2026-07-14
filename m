Return-Path: <io-uring+bounces-14007-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id B2fhIpdqVmqv5AAAu9opvQ
	(envelope-from <io-uring+bounces-14007-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 18:57:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 85F2C75728C
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 18:57:58 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OM/sCiJz";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-14007-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-14007-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E01B73006912
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 16:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 699B74DD6DB;
	Tue, 14 Jul 2026 16:57:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145A14DD6D1
	for <io-uring@vger.kernel.org>; Tue, 14 Jul 2026 16:57:25 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784048247; cv=none; b=ZuUo6I/uWPaYMZbz/5INTEGmXyWig+/+aVpwz9KlMcqhX+9/YtBZH9TCyJZjsRhK2+f/UIA0DEN31Zqbahj60FrMCRMacAaW9hxQJgL8rmXQAaREXz0OnHWLnlF4vd/SHJcv2vNAl1igdrXjfUJ/0QAboBS9oWuU/ykmk/E7JM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784048247; c=relaxed/simple;
	bh=mCQQopz1rpnPRxSmDQXgDSyBfIB0fEBYPnOjEYLdbOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y024jc/5NHInQjDQzusmnmlYd9SP+oCtKLv/IfBxC8sG74q5y05Ja7lmYnRAYo8iGofrISG0XL4v2wxycrcZ5MXZ4MFQFI65UpKvvABwqhemm/h7zE/TDST0AFhyTO6UQXLiptoIvqVs56Yg0VzwxDaKN0B9iFKYt9M+G+WdCps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OM/sCiJz; arc=none smtp.client-ip=209.85.216.48
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38511175ad3so3692596a91.2
        for <io-uring@vger.kernel.org>; Tue, 14 Jul 2026 09:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784048245; x=1784653045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4TbwrSqwI+gjW+6EHVvdE2b1XHwiMCMJ+OBUijAyljQ=;
        b=OM/sCiJz9G0NS83T6c/Yi2CkNuheYuR6QayV3K/yj1ac1lJpDmQOtis5WnVNZcLkTK
         UOv8xBChHqBvyPohjhPds6uVw6/O2LET2sZPATIOXT+1aU9gx4IajLSo2+33nw6j6DOx
         Y+4O8MNYx0blKFVFPvfF9BPks1cRAcc58nOx90ZHBsquy7ss9skD5+JhtdCtXQdmhVOH
         QobuW0seOBpQBl58AkaOocDtWj2RMFSqTqP67yeS5s6fTKVB6xdAzVZF5Zp0MIoA11n1
         F9PDfrS1N8Owx1Mxp9FgMnjCtHwHF6ZdlLEOxKZPdr8Mwdb87AEeBq1Lu9LjpsJp09Zq
         EEPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784048245; x=1784653045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4TbwrSqwI+gjW+6EHVvdE2b1XHwiMCMJ+OBUijAyljQ=;
        b=H18AmYZns2iZWEIcZ+86dQ/m2ahWBrIhUYP4Wx/Ro5ZE6ozyEHKNooAuzI9JsHOQJR
         1F0cFFitV5itwDrKc8WPvayYK94Zb+SMs7V+QvyrvnYlKwS2zBUToSQo9uX9eO8XM8u6
         WE4FsDJlB5+d68UAwlV6Cg8SWKjSuvFDeAsxjul17uEbf2a/j8cqsdc/VS+L6xYUqZBR
         gDxDTt9XaB7mXgwNVDj6bAzVtU5P8sO7+qDC0cxChbJ9z1cbitgVZNVhRn+EHHa/b1hV
         18GLJ6wtguHsaEe3+4nQiFYJO3UFt2FGZwfosnjCJSf2q5XY7Nw9MFvuGIjADm3P/d16
         1Vpg==
X-Gm-Message-State: AOJu0YwpnghX0yVbgZrh4HhXTn8Ju54Xjy1bzFlvFCkhFGZAQgxfonz/
	9HaySY3xczo8M85+zHJISoSClH4m32R5kipea2CuPdsSYu+T09rWM4/qGBXUWohz4Ac=
X-Gm-Gg: AfdE7cmAddg6wN7pl/LVOuqX0L+2XWqr6eBAWoE4UzKP3mEvSJ9sW8eZph9zKINUn5q
	QEp9krlzrFJQGxjjUHLFguejFWgG63VDPcr/WRotUPBmNGeNIBZFQzp6Bto5F3O0LQ57j9KJvta
	cjH3eHxlmFRq/9vgChas5wJjxCuGL0hnPCayKFLgXLpdkSBgQBxNJeugBUz5sGk+uxRil6pS2UY
	0hyhN9q5A46rcu56YWS6iFtpEmmIzR23+q5d7HQxIey5Wc4kTTRP1oqubPX3uUEB+SlPi2TbPZe
	zd1ppoj+sSZbUTHbOWIh4W7igDlJvGkQBi6FjRiYs9lVMk9aQkimqurvAc9Odr2Y8db++IQZOmV
	XkbeHEfRM5/D8d3t+3lY1IjGr24w2H2edwd7C9dK70dK55MqRosg3HOa3O49gKKDEoPBJV+oy0A
	As0BTkTkf3dVX5uP4Z3CFT6jAgIsaTE9t7L/eEqFIr/KORoNVQXebR2Ru3IqSiAcKyrRUxTicCf
	bdATMunXbfkJ0TeBU1gZtk0QqK538vlW4JRHTy7nAPKTu2CwPIHccNNz2SgcfJ5+fBhzEzMTXWO
X-Received: by 2002:a17:90b:5610:b0:381:fa5:521f with SMTP id 98e67ed59e1d1-38e1ae5f652mr2726920a91.3.1784048245138;
        Tue, 14 Jul 2026 09:57:25 -0700 (PDT)
Received: from prateek-Aspire-A515-57G.. ([182.77.77.253])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-311a6115e61sm67241222eec.22.2026.07.14.09.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 09:57:24 -0700 (PDT)
From: Prateek <kprateek283@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	krisman@suse.de,
	Prateek <kprateek283@gmail.com>
Subject: [PATCH v2 2/2] test/timeout-swallow: verify -ETIME is not swallowed
Date: Tue, 14 Jul 2026 22:27:02 +0530
Message-ID: <20260714165702.237136-2-kprateek283@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260714165702.237136-1-kprateek283@gmail.com>
References: <20260714165702.237136-1-kprateek283@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,suse.de,gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-14007-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[kprateek283@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:krisman@suse.de,m:kprateek283@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kprateek283@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 85F2C75728C

Regression test for the previous commit. Submits an SQE and waits with a
zero timeout for more completions than can arrive; the result must be
-ETIME, not the positive submit count. Covers the normal EXT_ARG wait
path and the registered-wait path, each skipped gracefully where
unsupported.

Signed-off-by: Prateek <kprateek283@gmail.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
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
index 00000000..d08365da
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
+ * Test the normal -ETIME swallow path.
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
+ * Test the registered-wait -ETIME swallow path.
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


