Return-Path: <io-uring+bounces-14011-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Bwi+F/mBVmrv7gAAu9opvQ
	(envelope-from <io-uring+bounces-14011-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 20:37:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE9B757E35
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 20:37:44 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i4zlqBeV;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-14011-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-14011-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC01C3055563
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 18:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 681A6417BF8;
	Tue, 14 Jul 2026 18:35:41 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D63F2DEA8C
	for <io-uring@vger.kernel.org>; Tue, 14 Jul 2026 18:35:39 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784054141; cv=none; b=X9D18KZ1Yf4/auxObbMftcTPTPtT8JPZw+U79jry+twinBof3NrHTw+zBIxApKrKL+T/i6x67AInbCpMLoj0zGMAwyliLELaIjW/Z0jSrwxytoFAbxLd9L3pAvwbwGUhizQaEB9L7tkyDg0IvGU/fEe1WXb7T6cwRtkycRuVzHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784054141; c=relaxed/simple;
	bh=qX8k3+cKww3nWHyMDj+5/Al1prHUu1YboDksaPSqod4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7iqUaiK74NzNTCvM032hG1mdjg/LAPzwXxXOI7Fj/OO+n2shfVqXCY6R9qG+5Q9Ua9YWWQYYd/ZZ1macOtVpktpIcayxVsmlYyv4jZi9hE754kDdn2OfLO3cJNaSsrwMFeMlHWwIyi/NKX0VyGj9X0YfAN7T5nXd1iTZs/GcFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i4zlqBeV; arc=none smtp.client-ip=209.85.215.171
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c88a4d79ba5so3008422a12.2
        for <io-uring@vger.kernel.org>; Tue, 14 Jul 2026 11:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784054139; x=1784658939; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5z0mSwlKlnsorYMgOxOie4qM/ENy5OVX2EJNIf4M4wo=;
        b=i4zlqBeVSSTF+4+k8pxlZp0rVp+EPoWKKzFw7sjfq6S64LqkBDOiVsOP91gPHE0c55
         XvMUZ7M1OLXsBqHgWAFZ2Dc4DUnZKwWOsearfpSW/JY9FLW7d42p5AVu4x1jGWDOI7my
         djQhV2dxEo/UVQwvEoQkdn7Hm1e6MuBp2VcNyWk8OYGjgWhEfUhW5cKj9NMv5WSZTCOv
         VmsAEB/r7AauwHnVi09i/LsB4ZL37/qxwx8BWrWW4FYRIpX3UaCwBBGNONBSRb/kfnsy
         uvU3LJMffOokfcnNYcVK+3RSFotUvGTamvLBAYpgVyw1uQkMEOYKFQ3KoMtVXn1Xa0J1
         ou3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784054139; x=1784658939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5z0mSwlKlnsorYMgOxOie4qM/ENy5OVX2EJNIf4M4wo=;
        b=MlwwRNfRqJ31VzQnlQob3VzjDxyr57rktFz4p++Aqiupi2ouE8RFQp149oA9hM2e4d
         YQogBFWeRY2qejOhU/fsb35SLoajHQ1KSKuBHVl7SefnsfHYD+WEWmUfJnHMbghl1Doq
         AsoLHLjK3vsyfQgOQbuuXHdB7M/A3cjawXJqHxYR+2H6L7jHT8w4dZSYkvdCkAqcMgE1
         4/wv/6+l/k+XhpWsR5EywMym92UIMFqHynaUHoWRBH94uWmEXHEXZtttHLiwj544wXPh
         G9Otu4PwZmS1tN7bbgbJnS/UhCbaMTAdT4gVAPq6oQoZwHQBiLfJFIhOmc/yTB8xarXT
         /1kA==
X-Gm-Message-State: AOJu0YxsPjzfJ6fsvxY+zTGDgA0cofjkXwwZd7RLiQQGeC6cGT2FPlnO
	lUObQbrQ1W+9SMrGrWZplbN39OmbPZswBW1YESfrw+wy+mhVvkEdiuwc28MQALUQjtI=
X-Gm-Gg: AfdE7cmH1NoAOUOA80rcJJUhCNoxp9xy10hRJephYlDbdBUFDQCmR0W3zX8V31TthPP
	/TAJFi33JR4Y6YX9VVawqkhXMtqz7LCf0/ogxWwKLVsyQadk82FoXVhy6HbHQj0OLuOoHSWnHrn
	OEo9Te2HzyrhMlr2ydymUWaX5xSenP9PY1dH8Y7tcsKS7eZ5txYy+/Y6Sa8v0Do+IbSS+p+Tcmp
	PTMbS+nTCPkgB161Vfr6l9OPt+pBDpWeq0dzSzNIZDgBXfbE8fksmqIihvpMIoDzKC0IL7UyQ1c
	YnCSdm1cRP0lcnRDDuj4XIpQX+9rejKnvuB0ZyqPQBh46x6OMm+Jr+Znc2XVJtdcaN1KXlZKA3Y
	b5NC6thSClri6SWDpDzQIyKPcu3RoFMtcFoEWKbcRE3Z0bDfpIhHrX5E60Cbyr+Q8lurKPC+Z/g
	PrdX2yKh2Q/BCrNHjYaOmC9jOHz9tWkBqnw8h9J59eeC4itf94C8naOAPXc5hUpLdpEqJ0aMd+D
	xRkiO2XaipmXahs6SpR0AZ19HKV127E1g//G8NiHnAkhMC9WyZcTP+N0SM3o89J9W09suIDwWjo
X-Received: by 2002:a05:6a21:394a:b0:3bd:3a53:c147 with SMTP id adf61e73a8af0-3c35754ee33mr4259840637.45.1784054139053;
        Tue, 14 Jul 2026 11:35:39 -0700 (PDT)
Received: from prateek-Aspire-A515-57G.. ([182.77.77.253])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3119c2a7bb5sm56450280eec.25.2026.07.14.11.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 11:35:38 -0700 (PDT)
From: Prateek <kprateek283@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	krisman@suse.de,
	Prateek <kprateek283@gmail.com>
Subject: [PATCH v3 2/2] test/timeout-swallow: verify -ETIME is not swallowed
Date: Wed, 15 Jul 2026 00:05:29 +0530
Message-ID: <20260714183529.321703-2-kprateek283@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260714183529.321703-1-kprateek283@gmail.com>
References: <20260714183529.321703-1-kprateek283@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,suse.de,gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-14011-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,suse.de:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: CBE9B757E35

Regression test for the previous commit. Submits an SQE and waits with a
zero timeout for more completions than can arrive; the result must be
-ETIME, not the positive submit count. Covers the normal EXT_ARG wait
path and the registered-wait path, each skipped gracefully where
unsupported.

Signed-off-by: Prateek <kprateek283@gmail.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 test/Makefile          |   1 +
 test/timeout-swallow.c | 114 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 115 insertions(+)
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
index 00000000..e65e669e
--- /dev/null
+++ b/test/timeout-swallow.c
@@ -0,0 +1,114 @@
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
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct __kernel_timespec long_ts = { .tv_sec = 10, .tv_nsec = 0 };
+	struct __kernel_timespec zero_ts = { .tv_sec = 0, .tv_nsec = 0 };
+	int ret;
+
+	if (!(ring->features & IORING_FEAT_EXT_ARG))
+		return T_EXIT_SKIP;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "get_sqe failed\n");
+		return T_EXIT_FAIL;
+	}
+	/* Long timeout, won't complete immediately */
+	io_uring_prep_timeout(sqe, &long_ts, 1, 0);
+
+	/* Zero timeout forces immediate expiry inside the syscall on the first pass */
+	ret = io_uring_submit_and_wait_timeout(ring, &cqe, 2, &zero_ts, NULL);
+
+	if (ret == -ETIME)
+		return T_EXIT_PASS;
+
+	fprintf(stderr, "test_timeout failed: expected -ETIME, got %d\n", ret);
+	return T_EXIT_FAIL;
+}
+
+/*
+ * Test the registered-wait -ETIME swallow path.
+ */
+static int test_timeout_reg(struct io_uring *ring)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct __kernel_timespec long_ts = { .tv_sec = 10, .tv_nsec = 0 };
+	struct io_uring_reg_wait reg = { .ts = { .tv_sec = 0, .tv_nsec = 0 } };
+	int ret;
+
+	if (!(ring->features & IORING_FEAT_EXT_ARG))
+		return T_EXIT_SKIP;
+
+	/* Not supported on this kernel */
+	ret = io_uring_register_wait_reg(ring, &reg, 1);
+	if (ret)
+		return T_EXIT_SKIP;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "get_sqe failed\n");
+		return T_EXIT_FAIL;
+	}
+	io_uring_prep_timeout(sqe, &long_ts, 1, 0);
+
+	ret = io_uring_submit_and_wait_reg(ring, &cqe, 2, 0);
+	if (ret == -ETIME)
+		return T_EXIT_PASS;
+
+	fprintf(stderr, "test_timeout_reg failed: expected -ETIME, got %d\n", ret);
+	return T_EXIT_FAIL;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int ret, ret2, final_ret = T_EXIT_PASS;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		if (ret == -ENOSYS)
+			return T_EXIT_SKIP;
+		fprintf(stderr, "queue_init failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_timeout(&ring);
+	if (ret == T_EXIT_FAIL) {
+		fprintf(stderr, "test_timeout failed\n");
+		final_ret = T_EXIT_FAIL;
+	}
+
+	ret2 = test_timeout_reg(&ring);
+	if (ret2 == T_EXIT_FAIL) {
+		fprintf(stderr, "test_timeout_reg failed\n");
+		final_ret = T_EXIT_FAIL;
+	}
+
+	io_uring_queue_exit(&ring);
+
+	if (final_ret == T_EXIT_FAIL)
+		return T_EXIT_FAIL;
+	if (ret == T_EXIT_SKIP && ret2 == T_EXIT_SKIP)
+		return T_EXIT_SKIP;
+	return T_EXIT_PASS;
+}
-- 
2.43.0


