Return-Path: <io-uring+bounces-2812-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD7939553C1
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 01:21:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48FBB1F22513
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 23:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EE0D1369BC;
	Fri, 16 Aug 2024 23:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Q1ruPEOn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F5F12F38B
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 23:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723850482; cv=none; b=RByeCW2P7eJgFD+sztjgJtB5CKB1sbSB1qe9Fb2oUXz9VauZ2gGAzLhm7Q0xL6QZkVzvul10gCqtvNXdcwRiaoAl5F4insNLUKBhTCh1WTqOqcnoy6Xtnk7UUFIiNlI/H4lHp4OKCMnSXVV/QTt7ad0/++tWYdAOQJH7x62dgek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723850482; c=relaxed/simple;
	bh=yqEvFWUeVTbIqaVTBbW8yhmMZhwmjYKplMaKLTNLTW4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PdHFBnp5ZE6J9df1k3g168LZxqHBhFK9mfmmRmQwWuDcscK0t+rV9tUhzR0oOnvtcHemt7OFPA3ibnjvZ7P5xXQ9xrUq7NRtZP7oGRHam0+8pDuYGbsP6ejd2+RoFP3QfTcXtX0nqy8t0lvw4Y868g2/ShJNU4xhtqcrqiyN7mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Q1ruPEOn; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20219a0fe4dso2781725ad.2
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 16:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1723850479; x=1724455279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Diar6F9Syw+XSg+o4vhMOjxO22pFnJdcwPup79XVUa4=;
        b=Q1ruPEOnRLpVbA/ov13nf4AFqBA8I0jozEXlB3AY6DjVkLaZxAc60kBuMTVxc6JxcB
         9nR1zR63gVerUvhHW3bhVfjbi1CTmHjN7NiH6TqYbWeR5m+pOYjlw0ustQOjMEBv7rBm
         pv3ss7DapIqiTuqbeBSUNhd3J4D6k/qCF/QohAZ86FQgSN6bwG90p+6CSWbIspAsmt/5
         iUK5Ysd3XNCypNmqMy7cBC/QD6wZ3XZGF4olKNy7p4jVOXEx4EhLjXay0rQ98wnAwBcm
         r15p0C25wyLU609xb9uWjlg/FC1m9yL0Adc/hm5gC6mL3oxkEMFbef/noptBYiG6oV40
         1XZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723850479; x=1724455279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Diar6F9Syw+XSg+o4vhMOjxO22pFnJdcwPup79XVUa4=;
        b=fcU0UvVRmWlimTe25ZjIFcc4vv/HEJIr5J10dvK9pqkQctQND3+LSOTExGrjUJG/F7
         3IecorFnhFy+o+Vbkt2gG0iwH4RA6zipQt6kzbRoLW/7KE5Z9hpBM6Hc0x1RduwGk3Is
         EE+FeKto96uflmbu9O2RbkbSEVo8iAxwx1QAc+UI1k8UExkj8nk57R/9Cg0+1Ig3E3iu
         QxC3Mj9dB/E/XqpGhzXwG8rlWved3xwdAELgycAYhXy7QOmhMYBM1CeGrsf7L9zkN0oj
         rtQxb90LwgY91pZR4YKsLzhgmDXgIcBOsVLwKkEl+5x5BnC0HAJhtYE47bMUCVqAGyWK
         2afA==
X-Gm-Message-State: AOJu0YzyPlRG+OU5adO/rcTVJ1sD+9TxU/tEv/uyOGZhF3uVUGcrlG0+
	RohpMN5g/MAwGbBKXCtQ699d0R1fJb9zmALvaUtiz7UfC/EPp/kFomsYiMr3gKcKPMu0zLSudce
	J
X-Google-Smtp-Source: AGHT+IHpBugk5YEQNc2CYvVL9gawqFawowk8qOWxgqskQdbMOaI1s5cINY7p4LYJMMQ6Wda26RLc7A==
X-Received: by 2002:a17:90a:be06:b0:2cc:f2c1:88fb with SMTP id 98e67ed59e1d1-2d405571f8bmr1172579a91.16.1723850479362;
        Fri, 16 Aug 2024 16:21:19 -0700 (PDT)
Received: from localhost (fwdproxy-prn-045.fbsv.net. [2a03:2880:ff:2d::face:b00c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d3e2b65a9csm2492446a91.3.2024.08.16.16.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 16:21:19 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing v2] Add io_uring_iowait_toggle()
Date: Fri, 16 Aug 2024 16:20:48 -0700
Message-ID: <20240816232048.1307255-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add io_uring_iowait_toggle() helper function for the userspace liburing
side of IORING_ENTER_NO_IOWAIT flag added in io_uring for 6.12.

This function toggles whether a ring sets in_iowait when waiting for
completions. This is useful when waiting for multiple batched
completions using e.g. io_uring_submit_and_wait_timeout() and userspace
treats iowait time as CPU utilization.

It works by keeping an internal flag INT_FLAG_NO_IOWAIT, which if set
will set IORING_ENTER_NO_IOWAIT on every io_uring_enter().

Manpages are added/modified, a unit test is included, and io_uring.h is
synced with the kernel side.

Signed-off-by: David Wei <dw@davidwei.uk>
---
v2:
 - edit manpages

---
 man/io_uring_enter.2            |   6 ++
 man/io_uring_iowait_toggle.3    |  52 ++++++++++
 src/include/liburing.h          |   1 +
 src/include/liburing/io_uring.h |   2 +
 src/int_flags.h                 |   1 +
 src/liburing.map                |   2 +
 src/queue.c                     |   2 +
 src/setup.c                     |  12 +++
 test/Makefile                   |   1 +
 test/no-iowait.c                | 162 ++++++++++++++++++++++++++++++++
 10 files changed, 241 insertions(+)
 create mode 100644 man/io_uring_iowait_toggle.3
 create mode 100644 test/no-iowait.c

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 5e4121b..da9b870 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -104,6 +104,12 @@ If the ring file descriptor has been registered through use of
 then setting this flag will tell the kernel that the
 .I ring_fd
 passed in is the registered ring offset rather than a normal file descriptor.
+.TP
+.B IORING_ENTER_NO_IOWAIT
+If this flag is set, then waiting on events will not be accounted as iowait for
+the task if
+.BR io_uring_enter (2)
+results in waiting.
 
 .PP
 .PP
diff --git a/man/io_uring_iowait_toggle.3 b/man/io_uring_iowait_toggle.3
new file mode 100644
index 0000000..41a6367
--- /dev/null
+++ b/man/io_uring_iowait_toggle.3
@@ -0,0 +1,52 @@
+.\" Copyright (C) 2024 David Wei <dw@davidwei.uk>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_iowait_toggle 3 "Aug 16, 2024" "liburing-2.8" "liburing Manual"
+.SH NAME
+io_uring_iowait_toggle \- toggle whether waiting for events is accounted as iowait
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_iowait_toggle(struct io_uring *" ring ",
+.BI "                           bool " enabled ");"
+.BI "
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_iowait_toggle (3)
+function toggles for a given
+.I ring
+whether waiting for events is accounted as iowait time for the task.  When set
+to true, time spent waiting is accounted as iowait time; otherwise, it is
+accounted as idle time.  The default behavior is to always account time waiting
+for events as iowait time.
+
+Setting in_iowait achieves two things:
+.TP
+.B 1. Account time spent waiting as iowait time
+.TP
+.B 2. Enable cpufreq optimizations, setting SCHED_CPUFREQ_IOWAIT on the rq
+.PP
+
+The accounting aspect is a relic from the days of uniprocessor systems, where
+iowait indicates that a task is blocked uninterruptibly waiting for IO and
+cannot perform other work.  iowait with SMP systems is mostly a bogus
+accounting value, but is set to enable cpufreq boosts for high frequency waits.
+
+Some user tooling attributes iowait time as CPU utilization time, so high
+iowait time can look like apparent high CPU utilization, even though the task
+is not scheduled and the CPU is free to run other tasks.
+.BR io_uring_iowait_toggle (3)
+provides a way to disable this behavior where it makes sense to do so.
+
+Available since 6.12.
+
+.SH RETURN VALUE
+On success
+.BR io_uring_iowait_toggle (3)
+0. If the kernel does not support this feature, it returns
+.BR -EOPNOTSUPP
+.
diff --git a/src/include/liburing.h b/src/include/liburing.h
index 1092f3b..ddc154c 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -243,6 +243,7 @@ int io_uring_unregister_napi(struct io_uring *ring, struct io_uring_napi *napi);
 
 int io_uring_get_events(struct io_uring *ring);
 int io_uring_submit_and_get_events(struct io_uring *ring);
+int io_uring_iowait_toggle(struct io_uring *ring, bool enabled);
 
 /*
  * io_uring syscalls.
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 01c36a8..36cabc5 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -504,6 +504,7 @@ struct io_cqring_offsets {
 #define IORING_ENTER_SQ_WAIT		(1U << 2)
 #define IORING_ENTER_EXT_ARG		(1U << 3)
 #define IORING_ENTER_REGISTERED_RING	(1U << 4)
+#define IORING_ENTER_NO_IOWAIT		(1U << 6)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -539,6 +540,7 @@ struct io_uring_params {
 #define IORING_FEAT_LINKED_FILE		(1U << 12)
 #define IORING_FEAT_REG_REG_RING	(1U << 13)
 #define IORING_FEAT_RECVSEND_BUNDLE	(1U << 14)
+#define IORING_FEAT_IOWAIT_TOGGLE	(1U << 15)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/src/int_flags.h b/src/int_flags.h
index 548dd10..80ad7cb 100644
--- a/src/int_flags.h
+++ b/src/int_flags.h
@@ -6,6 +6,7 @@ enum {
 	INT_FLAG_REG_RING	= 1,
 	INT_FLAG_REG_REG_RING	= 2,
 	INT_FLAG_APP_MEM	= 4,
+	INT_FLAG_NO_IOWAIT	= 8,
 };
 
 #endif
diff --git a/src/liburing.map b/src/liburing.map
index fa096bb..e64fe2d 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -97,4 +97,6 @@ LIBURING_2.7 {
 } LIBURING_2.6;
 
 LIBURING_2.8 {
+  global:
+    io_uring_iowait_toggle;
 } LIBURING_2.7;
diff --git a/src/queue.c b/src/queue.c
index c436061..bd2e6af 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -110,6 +110,8 @@ static int _io_uring_get_cqe(struct io_uring *ring,
 
 		if (ring->int_flags & INT_FLAG_REG_RING)
 			flags |= IORING_ENTER_REGISTERED_RING;
+		if (ring->int_flags & INT_FLAG_NO_IOWAIT)
+			flags |= IORING_ENTER_NO_IOWAIT;
 		ret = __sys_io_uring_enter2(ring->enter_ring_fd, data->submit,
 					    data->wait_nr, flags, data->arg,
 					    data->sz);
diff --git a/src/setup.c b/src/setup.c
index 1997d25..2647363 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -687,3 +687,15 @@ int io_uring_free_buf_ring(struct io_uring *ring, struct io_uring_buf_ring *br,
 	__sys_munmap(br, nentries * sizeof(struct io_uring_buf));
 	return 0;
 }
+
+int io_uring_iowait_toggle(struct io_uring *ring, bool enabled)
+{
+	if (!(ring->features & IORING_FEAT_IOWAIT_TOGGLE))
+		return -EOPNOTSUPP;
+
+	if (enabled)
+		ring->int_flags &= ~INT_FLAG_NO_IOWAIT;
+	else
+		ring->int_flags |= INT_FLAG_NO_IOWAIT;
+	return 0;
+}
diff --git a/test/Makefile b/test/Makefile
index 0538a75..d9a049c 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -125,6 +125,7 @@ test_srcs := \
 	msg-ring-flags.c \
 	msg-ring-overflow.c \
 	multicqes_drain.c \
+	no-iowait.c \
 	no-mmap-inval.c \
 	nolibc.c \
 	nop-all-sizes.c \
diff --git a/test/no-iowait.c b/test/no-iowait.c
new file mode 100644
index 0000000..8e7cb6a
--- /dev/null
+++ b/test/no-iowait.c
@@ -0,0 +1,162 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test no iowait toggle
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <sys/time.h>
+#include <sys/wait.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sched.h>
+
+#include "helpers.h"
+#include "liburing.h"
+#include "../src/syscall.h"
+
+#define TIMEOUT_SEC	1
+#define PINNED_CPU	0
+
+static int pin_to_cpu()
+{
+	cpu_set_t set;
+
+	CPU_ZERO(&set);
+	CPU_SET(PINNED_CPU, &set);
+	if (sched_setaffinity(0, sizeof(cpu_set_t), &set) == -1)
+		return 1;
+
+	return 0;
+}
+
+static int get_iowait()
+{
+	FILE *fp;
+	char line[1024];
+	char cpu[10];
+	int sz;
+	unsigned long long user, nice, system, idle, iowait;
+
+	sz = snprintf(cpu, 10, "cpu%d", PINNED_CPU);
+	fp = fopen("/proc/stat", "r");
+	if (fp == NULL)
+		return -1;
+
+	while (fgets(line, sizeof(line), fp) != NULL) {
+		if (strncmp(line, cpu, sz) == 0) {
+			sscanf(line, "%*s %llu %llu %llu %llu %llu", &user,
+					&nice, &system, &idle, &iowait);
+			break;
+		}
+	}
+
+	fclose(fp);
+	return iowait;
+}
+
+static int test_iowait(struct io_uring *ring, bool enabled)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct __kernel_timespec ts;
+	int ret, iowait, exp;
+
+	ret = io_uring_iowait_toggle(ring, enabled);
+	if (ret == -EOPNOTSUPP)
+		return T_EXIT_SKIP;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
+		return T_EXIT_FAIL;
+	}
+
+	ts.tv_sec = TIMEOUT_SEC;
+	ts.tv_nsec = 0;
+	io_uring_prep_timeout(sqe, &ts, 0, 0);
+
+	ret = io_uring_submit(ring);
+	if (ret <= 0) {
+		fprintf(stderr, "%s: sqe submit failed: %d\n", __FUNCTION__, ret);
+		return T_EXIT_FAIL;
+	}
+
+	iowait = get_iowait();
+	if (iowait < 0) {
+		fprintf(stderr, "%s: open /proc/stat failed\n", __FUNCTION__);
+		return T_EXIT_FAIL;
+	}
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "%s: wait completion %d\n", __FUNCTION__, ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	if (ret != -ETIME) {
+		fprintf(stderr, "%s: Timeout: %s\n", __FUNCTION__, strerror(-ret));
+		return T_EXIT_FAIL;
+	}
+
+	ret = get_iowait();
+	if (ret < 0) {
+		fprintf(stderr, "%s: open /proc/stat failed\n", __FUNCTION__);
+		return T_EXIT_FAIL;
+	}
+	exp = ret - iowait;
+	if (enabled) {
+		if (exp >= (TIMEOUT_SEC * sysconf(_SC_CLK_TCK) * 11) / 10 ||
+		    exp <= (TIMEOUT_SEC * sysconf(_SC_CLK_TCK) * 9) / 10)
+			return T_EXIT_FAIL;
+	} else {
+		if (exp >= sysconf(_SC_CLK_TCK) / 10)
+			return T_EXIT_FAIL;
+	}
+
+	return T_EXIT_PASS;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	struct io_uring_params p = { };
+	int ret;
+
+	if (argc > 1)
+		return 0;
+
+	ret = pin_to_cpu();
+	if (ret) {
+		fprintf(stderr, "pinning to cpu%d failed\n", PINNED_CPU);
+		return 1;
+	}
+
+	ret = io_uring_queue_init_params(8, &ring, &p);
+	if (ret) {
+		fprintf(stderr, "ring setup failed\n");
+		return 1;
+	}
+
+	ret = test_iowait(&ring, true);
+	if (ret == T_EXIT_SKIP)
+		return ret;
+	if (ret) {
+		fprintf(stderr, "test_iowait with iowait enabled failed\n");
+		return ret;
+	}
+
+	ret = test_iowait(&ring, false);
+	if (ret) {
+		fprintf(stderr, "test_iowait with iowait disabled failed\n");
+		return ret;
+	}
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
-- 
2.43.5


