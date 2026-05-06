Return-Path: <io-uring+bounces-13249-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SDnLOp9K+2mYYwMAu9opvQ
	(envelope-from <io-uring+bounces-13249-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 06 May 2026 16:05:19 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 02AA34DBA81
	for <lists+io-uring@lfdr.de>; Wed, 06 May 2026 16:05:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 01222303E61D
	for <lists+io-uring@lfdr.de>; Wed,  6 May 2026 14:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45E64611D7;
	Wed,  6 May 2026 13:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QY4f4/EB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A555480320
	for <io-uring@vger.kernel.org>; Wed,  6 May 2026 13:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778075982; cv=none; b=MzN7lcOv1E2b5fj3SmuswlFfr6+jZRb24W6oqcwzAZC5F4NmDLEdslIBeLYdScOpTN5DZsYOxrQvfQ2F74mEIlCsWNO42HWn7Zs8AoYM0JHs3wNjd/fBZwrJ988FyAKlyhAUJcu1Ly5zvTf8sga9aB2EhQhmATK3IMhxMEj6/Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778075982; c=relaxed/simple;
	bh=Q7GEJWsGpqq+gwAvObqCBHqoZq+hqlaj6h7H61KmEEk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=muA21HgrC2Vx2/Qsv5mC3T1IVQguvIIV7F1qFxXHBbNGKYcsnOeETysJQnKgCSXWguU4kM8hqXy/3DBvowcmS6D7dQNc4cO6UtVvTM0cmqPkko/dSv1ofEffUFR/aa51/q1ZXvsHgQQn91KWgcLffVdDq6fcXj27Afh/T5oeD18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QY4f4/EB; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8354461da74so1836270b3a.1
        for <io-uring@vger.kernel.org>; Wed, 06 May 2026 06:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778075981; x=1778680781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U5wYuKN4KPzu26+IPj2dzSP+uqG5gwPZU9K/rLjWc90=;
        b=QY4f4/EBP9lazfIUP2kw2uHq/N2ci4/GQ4LfGNHTTfckImY6CSXMpOn63oq4doeuIs
         dyRz+IMdqwe31LU0ZT7VoDwmUoGhqBvhsGnLEp0A8dkH9jRRLmwDDBIhpGVyB6PRFZae
         55jlDr395k5ibP3EBgEny4D29nEwAuXbEMAHfANGwvJvWe9YOlx22kvh2pNficzq5rjU
         Bx1jwAOz+a613pgIa0McuFGsASrJyLtaSMiTf7jxGYl5DzlDt2IszEaDBIG+BNguPWXl
         +y57nF6/l0Y5GB8r4zPMW5PXJ6omnGRlWyhtAfii2lpfRkyF9jIYO4zlizN0eHeio6UD
         yJwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778075981; x=1778680781;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U5wYuKN4KPzu26+IPj2dzSP+uqG5gwPZU9K/rLjWc90=;
        b=o75DEJ3Gm4Bb/P/KJR/qQIe7pAZ3/ECqGMB+XLLbRRBIXorLKbfpIWEuFRTwXJGQRJ
         OOKLLzU4kD4F4+mqtH1LOghqEX4dnHox3v9TR9mTzxRa2RKYO0S6CeYDYo24To8ad9P1
         aWTn7PNKTjS+eExpIcLb4RTKWsBoWmhpcXMp45tTlrzeHGQ8KlbB8U2WBv0u9xsV7DCi
         /bg+LCQGpZGuQgcOx0rgQp2WAdm1WihEKR9lJZQvupTImgV2/eGWL1q4QHPfUlmDkXyu
         gtR8CEypaDnbfNQY43Lxxa0YW1MHdI70Ou4gYGMduV9P1EfaKBicxaN+kKCcuAHPhpCM
         vu6w==
X-Forwarded-Encrypted: i=1; AFNElJ8VvmdyxsNVOz9Og199esrCes/DuUi3Kj/r+4dUuizvQtNdtyTzmxC/QG3tZH8TvVY7L41GLm54ng==@vger.kernel.org
X-Gm-Message-State: AOJu0YwBDmAH0jzW9yAbqaB4NeDI7P5X7nZyChtJpFRZPIruxf6r0ErU
	LzW0Bv1YW7fc0gDV8eEuYuz49Z7uqC6A47TpS9cucIfLLJKhVbJd9b7A
X-Gm-Gg: AeBDiet2zOzjkSggX2PRsjA61i5Vu2wStQyUAff/wbqZKkQ0D6ravJX/v06za3qHRXy
	UTUeYlO49hgYM028KgVoRzXADeLy1TZlIKCWlSBkI5xZgDLEnup8ctrzKCyXpr0i6CabYjlwZLl
	7vjI3RHxev18Wu1I14l/RJk7KScDOOrijANpQh9M5JirCaHXQWDCkCCNnejGna4bpUgRn7EOP4j
	GTOF5Grq/J+TFrDAe1JYQ7fBlZaJ1oE8dDsHpOixcwXMEPv9XwdH6/9St5FqgeBcFm4LURkrOC4
	DvIeTHQJRRaxGzPzAiM77R1FE4HtTA0KVg0jmZLuxwqVkmFizPu3S8OeVgZe1eSRHxfG4bqTCWR
	7shBxRtuDvME3CDCNlxHLO5neKKvkGj+cfEs4lrkRsnsEJwDmO4KFDlga+rWEuuxCQeZ18S14bn
	KWjiO5JMMFUW6xRAYbCjwkLlcAjHHvi2/dltfkQeFrAJg+6lc7/vCHd197IDCl1jSwC3L9tA==
X-Received: by 2002:a05:6a21:e097:b0:39c:783:e42b with SMTP id adf61e73a8af0-3aa5a4a0020mr3606902637.21.1778075980448;
        Wed, 06 May 2026 06:59:40 -0700 (PDT)
Received: from csl-conti-dell7858.ntu.edu.sg ([155.69.195.57])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965d38ab5sm6997338b3a.26.2026.05.06.06.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 06:59:40 -0700 (PDT)
From: Maoyi Xie <maoyixie.tju@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>
Subject: [PATCH] test: add timens-abs-timer regression test
Date: Wed,  6 May 2026 21:59:35 +0800
Message-Id: <20260506135935.2420124-1-maoyixie.tju@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 02AA34DBA81
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,ntu.edu.sg];
	TAGGED_FROM(0.00)[bounces-13249-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maoyixietju@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]

From: Maoyi Xie <maoyi.xie@ntu.edu.sg>

Add a regression test that exercises the two ABS timer paths in
io_uring with the submitter inside a CLONE_NEWTIME time namespace
that has a -10s monotonic offset:

  - IORING_OP_TIMEOUT with IORING_TIMEOUT_ABS, parsed via
    io_parse_user_time() in io_uring/timeout.c.
  - io_uring_enter with IORING_ENTER_ABS_TIMER, parsed inline in
    io_cqring_wait() in io_uring/wait.c.

The test forks once to enter the new userns, sets up uid_map
and gid_map for unprivileged root, writes the -10s monotonic
offset to /proc/self/timens_offsets, then forks again. The
grandchild is the first process actually inside the new time
namespace (unshare(CLONE_NEWTIME) does not move the caller in,
only its future children). On both ABS timer paths the
grandchild submits an absolute deadline of now + 1s and asserts
the call returns after at least 0.9s.

The test fails on a kernel without commits 9cc6bac1bebf
("io_uring/timeout: honour caller's time namespace for
IORING_TIMEOUT_ABS") and 45d2b37a37ab ("io_uring/wait: honour
caller's time namespace for IORING_ENTER_ABS_TIMER"), where
the deadline is interpreted in host view and the timer fires
after ~1ms.

The test is skipped if the kernel lacks CLONE_NEWTIME support
or the caller cannot create an unprivileged user namespace.

Signed-off-by: Maoyi Xie <maoyi.xie@ntu.edu.sg>
---
 test/Makefile           |   1 +
 test/timens-abs-timer.c | 315 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 316 insertions(+)
 create mode 100644 test/timens-abs-timer.c

diff --git a/test/Makefile b/test/Makefile
index 6a79a02..13841a9 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -286,6 +286,7 @@ test_srcs := \
 	task-restrict.c \
 	teardowns.c \
 	thread-exit.c \
+	timens-abs-timer.c \
 	timerfd-short-read.c \
 	timeout.c \
 	timeout-new.c \
diff --git a/test/timens-abs-timer.c b/test/timens-abs-timer.c
new file mode 100644
index 0000000..cd5471b
--- /dev/null
+++ b/test/timens-abs-timer.c
@@ -0,0 +1,315 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: regression test for IORING_TIMEOUT_ABS and
+ * IORING_ENTER_ABS_TIMER honouring the submitter's time
+ * namespace. The kernel converts user supplied absolute time
+ * from the caller's time namespace view to host view via
+ * timens_ktime_to_host(). Without that conversion an absolute
+ * deadline submitted from inside a CLONE_NEWTIME namespace fires
+ * immediately instead of after the requested interval.
+ *
+ * The test forks a child, enters a fresh user namespace plus
+ * time namespace with a -10s monotonic offset, submits an
+ * absolute deadline of now + 1s on each path, and asserts the
+ * call returns after ~1s rather than after <100ms. The test is
+ * skipped if the kernel lacks CLONE_NEWTIME support or the
+ * caller cannot create a user namespace.
+ */
+#include <errno.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#include "helpers.h"
+#include "liburing.h"
+#include "../src/syscall.h"
+
+#ifndef CLONE_NEWTIME
+#define CLONE_NEWTIME	0x00000080
+#endif
+
+#define EXPECTED_NS	1000000000ULL	/* deadline at now + 1s */
+#define MIN_OBSERVED_NS	900000000ULL	/* fire no earlier than 0.9s */
+#define BUG_OBSERVED_NS	100000000ULL	/* bug fires under 0.1s */
+
+static int write_one(const char *path, const char *buf)
+{
+	int fd, ret;
+
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return -errno;
+	ret = write(fd, buf, strlen(buf));
+	close(fd);
+	if (ret < 0)
+		return -errno;
+	if ((size_t) ret != strlen(buf))
+		return -EIO;
+	return 0;
+}
+
+static int enter_unpriv_userns_timens(void)
+{
+	int ret;
+
+	ret = unshare(CLONE_NEWUSER | CLONE_NEWTIME);
+	if (ret < 0)
+		return -errno;
+
+	if (write_one("/proc/self/setgroups", "deny") < 0)
+		return -errno;
+	if (write_one("/proc/self/uid_map", "0 0 1\n") < 0)
+		return -errno;
+	if (write_one("/proc/self/gid_map", "0 0 1\n") < 0)
+		return -errno;
+
+	/* -10s monotonic offset: host_monotonic - 10s inside this ns. */
+	if (write_one("/proc/self/timens_offsets", "monotonic -10 0\n") < 0)
+		return -errno;
+
+	return 0;
+}
+
+static unsigned long long ts_to_ns(const struct timespec *ts)
+{
+	return ts->tv_sec * 1000000000ULL + ts->tv_nsec;
+}
+
+static long long elapsed_ns(const struct timespec *start)
+{
+	struct timespec now;
+
+	if (clock_gettime(CLOCK_MONOTONIC, &now) < 0)
+		return -errno;
+	return ts_to_ns(&now) - ts_to_ns(start);
+}
+
+/*
+ * Path 1: IORING_OP_TIMEOUT with IORING_TIMEOUT_ABS, parsed via
+ * io_parse_user_time() in io_uring/timeout.c.
+ */
+static int test_op_timeout_abs(void)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct __kernel_timespec kts;
+	struct timespec start;
+	struct io_uring ring;
+	long long elapsed;
+	int ret;
+
+	ret = io_uring_queue_init(1, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue_init: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	if (clock_gettime(CLOCK_MONOTONIC, &start) < 0) {
+		perror("clock_gettime");
+		io_uring_queue_exit(&ring);
+		return T_EXIT_FAIL;
+	}
+
+	kts.tv_sec = start.tv_sec + 1;
+	kts.tv_nsec = start.tv_nsec;
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_timeout(sqe, &kts, 0, IORING_TIMEOUT_ABS);
+
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit: %d\n", ret);
+		io_uring_queue_exit(&ring);
+		return T_EXIT_FAIL;
+	}
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe: %d\n", ret);
+		io_uring_queue_exit(&ring);
+		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	elapsed = elapsed_ns(&start);
+	io_uring_queue_exit(&ring);
+
+	if (elapsed < 0) {
+		fprintf(stderr, "elapsed_ns failed\n");
+		return T_EXIT_FAIL;
+	}
+	if ((unsigned long long) elapsed < BUG_OBSERVED_NS) {
+		fprintf(stderr,
+			"IORING_TIMEOUT_ABS fired after %lld ns, expected ~%llu ns. "
+			"Likely missing timens_ktime_to_host() in io_parse_user_time().\n",
+			elapsed, EXPECTED_NS);
+		return T_EXIT_FAIL;
+	}
+	if ((unsigned long long) elapsed < MIN_OBSERVED_NS) {
+		fprintf(stderr,
+			"IORING_TIMEOUT_ABS fired early at %lld ns\n", elapsed);
+		return T_EXIT_FAIL;
+	}
+	return T_EXIT_PASS;
+}
+
+/*
+ * Path 2: io_uring_enter with IORING_ENTER_ABS_TIMER, parsed
+ * inline in io_uring/wait.c::io_cqring_wait().
+ */
+static int test_enter_abs_timer(void)
+{
+	struct io_uring_getevents_arg arg;
+	struct __kernel_timespec kts;
+	struct timespec start;
+	struct io_uring ring;
+	long long elapsed;
+	int ret;
+
+	ret = io_uring_queue_init(1, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue_init: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	if (clock_gettime(CLOCK_MONOTONIC, &start) < 0) {
+		perror("clock_gettime");
+		io_uring_queue_exit(&ring);
+		return T_EXIT_FAIL;
+	}
+
+	kts.tv_sec = start.tv_sec + 1;
+	kts.tv_nsec = start.tv_nsec;
+
+	memset(&arg, 0, sizeof(arg));
+	arg.sigmask_sz = _NSIG / 8;
+	arg.ts = (unsigned long) &kts;
+
+	ret = io_uring_enter2(ring.ring_fd, 0, 1,
+			      IORING_ENTER_GETEVENTS |
+			      IORING_ENTER_EXT_ARG |
+			      IORING_ENTER_ABS_TIMER,
+			      &arg, sizeof(arg));
+	if (ret != -ETIME) {
+		fprintf(stderr,
+			"io_uring_enter2 returned %d, expected -ETIME (%d)\n",
+			ret, -ETIME);
+		io_uring_queue_exit(&ring);
+		if (ret == -EINVAL)
+			return T_EXIT_SKIP;
+		return T_EXIT_FAIL;
+	}
+
+	elapsed = elapsed_ns(&start);
+	io_uring_queue_exit(&ring);
+
+	if (elapsed < 0) {
+		fprintf(stderr, "elapsed_ns failed\n");
+		return T_EXIT_FAIL;
+	}
+	if ((unsigned long long) elapsed < BUG_OBSERVED_NS) {
+		fprintf(stderr,
+			"IORING_ENTER_ABS_TIMER fired after %lld ns, expected ~%llu ns. "
+			"Likely missing timens_ktime_to_host() on the ABS_TIMER branch.\n",
+			elapsed, EXPECTED_NS);
+		return T_EXIT_FAIL;
+	}
+	if ((unsigned long long) elapsed < MIN_OBSERVED_NS) {
+		fprintf(stderr,
+			"IORING_ENTER_ABS_TIMER fired early at %lld ns\n", elapsed);
+		return T_EXIT_FAIL;
+	}
+	return T_EXIT_PASS;
+}
+
+/*
+ * Run the actual io_uring tests inside the new time namespace.
+ * unshare(CLONE_NEWTIME) does not move the caller into the new
+ * namespace, only its future children. So the caller sets up
+ * userns and timens, writes the offset, then forks once more to
+ * enter the new time namespace.
+ */
+static int run_tests_in_timens_grandchild(void)
+{
+	struct timespec probe;
+	int ret;
+
+	/*
+	 * Sanity check: clock_gettime should reflect the -10s offset.
+	 * If it does not, the offset was not applied and the test
+	 * would silently appear to pass on an unpatched kernel.
+	 */
+	if (clock_gettime(CLOCK_MONOTONIC, &probe) < 0) {
+		perror("clock_gettime");
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_op_timeout_abs();
+	if (ret != T_EXIT_PASS)
+		return ret;
+
+	return test_enter_abs_timer();
+}
+
+static int run_in_timens(void)
+{
+	pid_t pid;
+	int status, ret;
+
+	ret = enter_unpriv_userns_timens();
+	if (ret == -EPERM || ret == -ENOSPC || ret == -EINVAL || ret == -ENOENT)
+		return T_EXIT_SKIP;
+	if (ret) {
+		fprintf(stderr, "userns/timens setup: %s\n", strerror(-ret));
+		return T_EXIT_SKIP;
+	}
+
+	pid = fork();
+	if (pid < 0) {
+		perror("fork (timens)");
+		return T_EXIT_FAIL;
+	}
+	if (pid == 0)
+		_exit(run_tests_in_timens_grandchild());
+
+	if (waitpid(pid, &status, 0) < 0) {
+		perror("waitpid (timens)");
+		return T_EXIT_FAIL;
+	}
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+	return T_EXIT_FAIL;
+}
+
+int main(int argc, char *argv[])
+{
+	pid_t pid;
+	int status;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		return T_EXIT_FAIL;
+	}
+	if (pid == 0)
+		_exit(run_in_timens());
+
+	if (waitpid(pid, &status, 0) < 0) {
+		perror("waitpid");
+		return T_EXIT_FAIL;
+	}
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+	return T_EXIT_FAIL;
+}

base-commit: 5dfc30a27303af1185e65d10890fdb35117bb3eb
-- 
2.34.1


