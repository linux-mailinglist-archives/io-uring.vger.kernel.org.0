Return-Path: <io-uring+bounces-2808-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 65A2195536E
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 00:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8AF31F2125A
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 22:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3FA71459F7;
	Fri, 16 Aug 2024 22:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="C4LqY0VK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5021145B12
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 22:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723848020; cv=none; b=f0j61hRi75ouxeAgqckTonYvGzdK8pn+7otdwoipFfZsUo1qNbWxilyal4Diee79ixIkEX0bHTFnCrRdiXKAlQHkYqTrWNJaP7OPju+18bUw2UMF6MFiVnuameehco+Zay7h4KDmRx2E37ohwlCQgTgNb+8kxKNSLQXSz+0sQ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723848020; c=relaxed/simple;
	bh=FfmOlVl+ARGWKxDzkhzyCZKRvRh/ca4hIZA8lbA0IOk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J/ez+JLY6/Q6R5lfDrLilMUwEm5hEmSQMUm2yfnM/+xOFAOmMbbVYUGIOrnr8CAYAW0o3xqJc7nVyJQqlpmZ3o/WxZzeqxUEmZ83kkYxSvHTE/y471Zn+BG41tNJaiDEIIlBBpBasvI7ZFyfI3dvSZHa5kKnRSFNji7FT5X+KxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=C4LqY0VK; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2020ac89cabso9977875ad.1
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 15:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1723848018; x=1724452818; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FAgSnqG6LbBBsJer0ISipqB/Fpc+KZKhyI17FAQhGtw=;
        b=C4LqY0VKwZTKjzZnwOs/+9AIBz9vyR+NgVLhtHIJiab5BDOmY3++OErXys7DOnQc2I
         vsxIb3hEnupuc/ePhhrIg1k6XhRScGdhXi/4gJUPKmr1xmbtDBMSWO1VXPs9AMn/dHWv
         WwgALqkrg7KgASawEj0buJEcfQPVLLF2Kg3xEkLKSCrhhPjcam+c3uqPwXT1PFiFs/r2
         WaD0ODzJMjjTVeQLhPnZhR2VPV4nAZCpJD+cNQhF5uGp/fxuVpu/nO2l7wWzAGwFnukL
         U6SQ5DVwsLE/C5ksITUJEzXDguzWmy37Wu9b7JbwAwkQE79cfQqbOT+x+UU0XkC3GM57
         jZgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723848018; x=1724452818;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FAgSnqG6LbBBsJer0ISipqB/Fpc+KZKhyI17FAQhGtw=;
        b=V0OmOSWqyJFIGTLqpTsUna+slMBt3FxpBRTcNbgEXrg3F4QEjOPMxXhR8jAvkYjGtf
         KahoUJYgUhUB2YgM38MSA4SIFcKGwoZvMwOm/Ok6+maXmQdXL+upmok4v49dy5qTPdNG
         sQcDcID7xIuNFxQFLyLkzAV7iuue4+2x4+4s8qSKkxQntKJiFRCe/JaZuHnpGgE8m9yy
         P7IGDIjOntD0FQR23YTEZb7dwzL9adq6xa8i7cNS5Pr2TRaBfIF6ooPmziSl1moi0Lih
         4Td6ioY9/XMmWJ/VwVzmhNC1osRkb3ULgoJl0oIugBk5FJ0M8DYbQfD4fJ0NYf+UNXAi
         eHsQ==
X-Gm-Message-State: AOJu0Yz84a9DTv7BdsjPiZAJo/oVbIjSEA9sUaLL/IQjAWp/OIPDN2/t
	Q3i8IqUrL4BvUJEdIuRm6HwfRivhXSvauqJq1rBArzU5OejzuOht7z6lp8jMBRmKZm8wJmZJjdb
	t
X-Google-Smtp-Source: AGHT+IFoz8bS3U3dy/a7dV6XL7gXtSU5UKwYP0U42Y8tsd02nOJ3Oy0yit4rjrUoTwfUWjt+clC4eQ==
X-Received: by 2002:a17:902:db09:b0:1fd:d55b:df26 with SMTP id d9443c01a7336-2020404f5b8mr46025085ad.61.1723848017797;
        Fri, 16 Aug 2024 15:40:17 -0700 (PDT)
Received: from localhost (fwdproxy-prn-026.fbsv.net. [2a03:2880:ff:1a::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f03a1889sm29896815ad.278.2024.08.16.15.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 15:40:17 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing v1] Add io_uring_iowait_toggle()
Date: Fri, 16 Aug 2024 15:40:15 -0700
Message-ID: <20240816224015.1154816-1-dw@davidwei.uk>
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
 man/io_uring_enter.2            |   5 +
 man/io_uring_iowait_toggle.3    |  45 +++++++++
 src/include/liburing.h          |   1 +
 src/include/liburing/io_uring.h |   2 +
 src/int_flags.h                 |   1 +
 src/liburing.map                |   2 +
 src/queue.c                     |   2 +
 src/setup.c                     |  12 +++
 test/Makefile                   |   1 +
 test/no-iowait.c                | 162 ++++++++++++++++++++++++++++++++
 10 files changed, 233 insertions(+)
 create mode 100644 man/io_uring_iowait_toggle.3
 create mode 100644 test/no-iowait.c

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 5e4121b..c06050a 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -104,6 +104,11 @@ If the ring file descriptor has been registered through use of
 then setting this flag will tell the kernel that the
 .I ring_fd
 passed in is the registered ring offset rather than a normal file descriptor.
+.TP
+.B IORING_ENTER_NO_IOWAIT
+If this flag is set, then in_iowait will not be set for the current task if
+.BR io_uring_enter (2)
+results in waiting.
 
 .PP
 .PP
diff --git a/man/io_uring_iowait_toggle.3 b/man/io_uring_iowait_toggle.3
new file mode 100644
index 0000000..2bced30
--- /dev/null
+++ b/man/io_uring_iowait_toggle.3
@@ -0,0 +1,45 @@
+.\" Copyright (C) 2024 David Wei <dw@davidwei.uk>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_iowait_toggle 3 "Aug 16, 2024" "liburing-2.8" "liburing Manual"
+.SH NAME
+io_uring_iowait_toggle \- toggle whether in_iowait is set while waiting for completions
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_iowait_toggle(struct io_uring *" ring ",
+.BI "                            bool " enabled ");"
+.BI "
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_iowait_toggle (3)
+function toggles for a given
+.I ring
+whether in_iowait is set for the current task while waiting for completions.
+When in_iowait is set, time spent waiting is accounted as iowait time;
+otherwise, it is accounted as idle time. The default behavior is to always set
+in_iowait to true.
+
+Setting in_iowait achieves two things:
+
+1. Account time spent waiting as iowait time
+
+2. Enable cpufreq optimisations, setting SCHED_CPUFREQ_IOWAIT on the rq
+
+Some user tooling attributes iowait time as CPU utilization time, so high
+iowait time can look like apparent high CPU utilization, even though the task
+is not scheduled and the CPU is free to run other tasks.  This function
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


