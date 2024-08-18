Return-Path: <io-uring+bounces-2826-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55417955E9B
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 20:55:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C923B1F2134C
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 18:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B15B145B26;
	Sun, 18 Aug 2024 18:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k6TLI/RB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE7C149E0E
	for <io-uring@vger.kernel.org>; Sun, 18 Aug 2024 18:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724007331; cv=none; b=knzp9AYdKqH3m0F/u9CO3lAzb6T0ZIJ7hLRYmt6pQgPO6OixXivnVSpYro4cWt5EiWbydB8VvKH7f/L+IKwut2XNxMm6dXECUhjHseLYxkzd2ty4Htt1a0uQZPX/wk5TgNxqjNQ0hIN4EFhaIzrF0j6J2GTN5Q538d8AfIgsz6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724007331; c=relaxed/simple;
	bh=d+z5SZ1ad6FhR/lLYbiMXXdlt72Kyy2Ry6VChQOKQ5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmte4GClyLkIeGSGOiXYBtO22jNS2DwDA835Vzaiy18qX6ty1BPHAvxCQfkI9yLtPy0j6wrVB68mfzjC7ihvM7NVZ0Wz5biwFXIPRr5sESq/5iM7DxsWFrKx91j+kPPKG6HVwwypaKrpn2qaZcoYk1Ixwy66O+1nbonBCprVCSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k6TLI/RB; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5becfd14353so2230568a12.1
        for <io-uring@vger.kernel.org>; Sun, 18 Aug 2024 11:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724007327; x=1724612127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8bDDMZa4VbATfcTZDsTX6UoY3yLV2EktRii/eFuFOvo=;
        b=k6TLI/RBYiVKDjfjIiuVN1+tkzvDDIPuEYDWV6eA9m+NaSuzCKRf0A4pe2KEzKnNOg
         zw90oK2uF919NGccZkTu4gw8e8/6UCr4pi2ixydpyMck9p4iXOfQGzLNGKh6SFGH4WZ3
         iqf6KFZc3/5/u0O15LTA1Nu7CzHaEoLOmHCqbrWU4CKdtDvvkn6dmQy/DBMhntHlemDz
         YCV8nTBaYgR4g7O6nV9mltI4PJB5GxoChQNKxphWa5oI2ujzEUNEkfJs8i1gzOqpF1f4
         QCftBEJw2OJdDam/Sr8ExavDLJIiaJzhReK5h/1zXB2nW4jqxug072ZgjmTxpW2mx4M0
         pT5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724007327; x=1724612127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8bDDMZa4VbATfcTZDsTX6UoY3yLV2EktRii/eFuFOvo=;
        b=j1OwOyhEwlKL+HR1uEf4Py2RHBaFyt+HpZanQhZJUAUmkcTBNIb5Uyf9+ykUiDK52F
         YlEJJtsdejDrtcsejOm5q11KIvrylMD8XMAzBVxxnuk0pj7/V8V6n4uTepqZ8FXLVkmZ
         B5GYKDglqzAQCDTStDNxFbVcf20clGwpQbOe3EzGzhG7rAvYf/nPeWrRzWQ53DMcGQ8C
         JzPj6rrbA3cvnTbX29/yTd8j3E/HRkOYTMupzdYCcm4f72Bfb1CUATaK2lmKMni6tfWT
         Y/6/t9/eJEFag/g2NgPtDJhhvDyT1YM1UJDqBk276bSJ5jCkG1APl+zVvrfygS+rRiO3
         ICdQ==
X-Gm-Message-State: AOJu0Yx7WKkTUcGR1R2PPh+5BMWaH+N4PBo3x8Q8O/+1HYU6/yhtRO2C
	Tsgt/Irzo8szKe0lydekEohf10v8brJVT753O0w2vMJ1bwB2cbW/jk2nFA==
X-Google-Smtp-Source: AGHT+IEs7ECGutv1dI2WpPoA/ugE9t8J+KRXAInQQtiKBaGncW2sA9N95SuSNzBG8y+t0MgfwoYDPw==
X-Received: by 2002:a05:6402:518e:b0:5be:f3f7:a8ff with SMTP id 4fb4d7f45d1cf-5bef3f7ab42mr1303032a12.21.1724007327345;
        Sun, 18 Aug 2024 11:55:27 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.74])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bebbbe274asm4867959a12.8.2024.08.18.11.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2024 11:55:26 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 3/4] test: test clockids and abs timeouts
Date: Sun, 18 Aug 2024 19:55:43 +0100
Message-ID: <e5797a5e89c253045ae8f447275eec54dc6af722.1724007045.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1724007045.git.asml.silence@gmail.com>
References: <cover.1724007045.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/Makefile       |   1 +
 test/wait-timeout.c | 283 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 284 insertions(+)
 create mode 100644 test/wait-timeout.c

diff --git a/test/Makefile b/test/Makefile
index 0538a75..f4fccd7 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -213,6 +213,7 @@ test_srcs := \
 	unlink.c \
 	version.c \
 	waitid.c \
+	wait-timeout.c \
 	wakeup-hang.c \
 	wq-aff.c \
 	xattr.c \
diff --git a/test/wait-timeout.c b/test/wait-timeout.c
new file mode 100644
index 0000000..1fc8e28
--- /dev/null
+++ b/test/wait-timeout.c
@@ -0,0 +1,283 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: run various timeout tests
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
+#include <assert.h>
+
+#include "helpers.h"
+#include "liburing.h"
+#include "../src/syscall.h"
+
+#define IO_NSEC_PER_SEC			1000000000LU
+
+static bool support_abs = false;
+static bool support_clock = false;
+
+static unsigned long long timespec_to_ns(struct timespec *ts)
+{
+	return ts->tv_nsec + ts->tv_sec * IO_NSEC_PER_SEC;
+}
+static struct timespec ns_to_timespec(unsigned long long t)
+{
+	struct timespec ts;
+
+	ts.tv_sec = t / IO_NSEC_PER_SEC;
+	ts.tv_nsec = t - ts.tv_sec * IO_NSEC_PER_SEC;
+	return ts;
+}
+
+static long long ns_since(struct timespec *ts)
+{
+	struct timespec now;
+	int ret;
+
+	ret = clock_gettime(CLOCK_MONOTONIC, &now);
+	if (ret) {
+		fprintf(stderr, "clock_gettime failed\n");
+		exit(T_EXIT_FAIL);
+	}
+
+	return timespec_to_ns(&now) - timespec_to_ns(ts);
+
+}
+
+static int t_io_uring_wait(struct io_uring *ring, int nr, unsigned enter_flags,
+			   struct timespec *ts)
+{
+	struct io_uring_getevents_arg arg = {
+		.sigmask	= 0,
+		.sigmask_sz	= _NSIG / 8,
+		.ts		= (unsigned long)ts
+	};
+	int ret;
+
+	enter_flags |= IORING_ENTER_GETEVENTS | IORING_ENTER_EXT_ARG;
+	ret = io_uring_enter2(ring->ring_fd, 0, nr, enter_flags,
+			      (void *)&arg, sizeof(arg));
+	return ret;
+}
+
+static int probe_timers(void)
+{
+	struct io_uring_clock_register cr = { .clockid = CLOCK_MONOTONIC, };
+	struct io_uring ring;
+	struct timespec ts;
+	int ret;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "probe ring setup failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = clock_gettime(CLOCK_MONOTONIC, &ts);
+	if (ret) {
+		fprintf(stderr, "clock_gettime failed\n");
+		return ret;
+	}
+
+	ret = t_io_uring_wait(&ring, 0, IORING_ENTER_ABS_TIMER, &ts);
+	if (!ret) {
+		support_abs = true;
+	} else if (ret != -EINVAL) {
+		fprintf(stderr, "wait failed %i\n", ret);
+		return ret;
+	}
+
+	ret = io_uring_register_clock(&ring, &cr);
+	if (!ret) {
+		support_clock = true;
+	} else if (ret != -EINVAL) {
+		fprintf(stderr, "io_uring_register_clock %i\n", ret);
+		return ret;
+	}
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+static int test_timeout(bool abs, bool set_clock)
+{
+	unsigned enter_flags = abs ? IORING_ENTER_ABS_TIMER : 0;
+	struct io_uring ring;
+	struct timespec start, end, ts;
+	long long dt;
+	int ret;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return 1;
+	}
+
+	if (set_clock) {
+		struct io_uring_clock_register cr = {};
+
+		cr.clockid = CLOCK_BOOTTIME;
+		ret = io_uring_register_clock(&ring, &cr);
+		if (ret) {
+			fprintf(stderr, "io_uring_register_clock failed\n");
+			return 1;
+		}
+	}
+
+	/* pass current time */
+	ret = clock_gettime(CLOCK_MONOTONIC, &start);
+	assert(ret == 0);
+
+	ts = abs ? start : ns_to_timespec(0);
+	ret = t_io_uring_wait(&ring, 1, enter_flags, &ts);
+	if (ret != -ETIME) {
+		fprintf(stderr, "wait current time failed, %i\n", ret);
+		return 1;
+	}
+
+	if (ns_since(&start) >= IO_NSEC_PER_SEC) {
+		fprintf(stderr, "current time test failed\n");
+		return 1;
+	}
+
+	if (abs) {
+		/* expired time */
+		ret = clock_gettime(CLOCK_MONOTONIC, &start);
+		assert(ret == 0);
+		ts = ns_to_timespec(timespec_to_ns(&start) - IO_NSEC_PER_SEC);
+
+		ret = t_io_uring_wait(&ring, 1, enter_flags, &ts);
+		if (ret != -ETIME) {
+			fprintf(stderr, "expired timeout wait failed, %i\n", ret);
+			return 1;
+		}
+
+		ret = clock_gettime(CLOCK_MONOTONIC, &end);
+		assert(ret == 0);
+
+		if (ns_since(&start) >= IO_NSEC_PER_SEC) {
+			fprintf(stderr, "expired timer test failed\n");
+			return 1;
+		}
+	}
+
+	/* 1s wait */
+	ret = clock_gettime(CLOCK_MONOTONIC, &start);
+	assert(ret == 0);
+
+	dt = 2 * IO_NSEC_PER_SEC + (abs ? timespec_to_ns(&start) : 0);
+	ts = ns_to_timespec(dt);
+	ret = t_io_uring_wait(&ring, 1, enter_flags, &ts);
+	if (ret != -ETIME) {
+		fprintf(stderr, "wait timeout failed, %i\n", ret);
+		return 1;
+	}
+
+	dt = ns_since(&start);
+	if (dt < IO_NSEC_PER_SEC || dt > 3 * IO_NSEC_PER_SEC) {
+		fprintf(stderr, "early wake up, %lld\n", dt);
+		return 1;
+	}
+	return 0;
+}
+
+static int test_clock_setup(void)
+{
+	struct io_uring ring;
+	struct io_uring_clock_register cr = {};
+	int ret;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = __sys_io_uring_register(ring.ring_fd, IORING_REGISTER_CLOCK, NULL, 0);
+	if (!ret) {
+		fprintf(stderr, "invalid null clock registration %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	cr.clockid = -1;
+	ret = __sys_io_uring_register(ring.ring_fd, IORING_REGISTER_CLOCK, &cr, 0);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "invalid clockid registration %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	cr.clockid = CLOCK_MONOTONIC;
+	ret = __sys_io_uring_register(ring.ring_fd, IORING_REGISTER_CLOCK, &cr, 0);
+	if (ret) {
+		fprintf(stderr, "clock monotonic registration failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	cr.clockid = CLOCK_BOOTTIME;
+	ret = __sys_io_uring_register(ring.ring_fd, IORING_REGISTER_CLOCK, &cr, 0);
+	if (ret) {
+		fprintf(stderr, "clock boottime registration failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	cr.clockid = CLOCK_MONOTONIC;
+	ret = __sys_io_uring_register(ring.ring_fd, IORING_REGISTER_CLOCK, &cr, 0);
+	if (ret) {
+		fprintf(stderr, "2nd clock monotonic registration failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret, i;
+
+	if (argc > 1)
+		return 0;
+
+	ret = probe_timers();
+	if (ret) {
+		fprintf(stderr, "probe failed\n");
+		return T_EXIT_FAIL;
+	}
+	if (!support_abs && !support_clock)
+		return T_EXIT_SKIP;
+
+	if (support_clock) {
+		ret = test_clock_setup();
+		if (ret) {
+			fprintf(stderr, "test_clock_setup failed\n");
+			return T_EXIT_FAIL;
+		}
+	}
+
+	for (i = 0; i < 4; i++) {
+		bool abs = i & 1;
+		bool clock = i & 2;
+
+		if (abs && !support_abs)
+			continue;
+		if (clock && !support_clock)
+			continue;
+
+		ret = test_timeout(abs, clock);
+		if (ret) {
+			fprintf(stderr, "test_timeout failed %i %i\n",
+					abs, clock);
+			return ret;
+		}
+	}
+
+	return 0;
+}
-- 
2.45.2


