Return-Path: <io-uring+bounces-690-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3E5F8622B0
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 06:07:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4108A2864F4
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 05:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6655513FE5;
	Sat, 24 Feb 2024 05:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="mrhtn8CD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E439B12E51
	for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 05:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708751271; cv=none; b=TCMXndaMbvzt7vjqZdRRlqs3Qtz2MYTh0KTwPGcBT6b5UXmrfSY+9K8sD29OpGsQ96ERaFWa2f3FUtmPzx2TovbfHxypd7YpYw4uJroSiZ9qo6WjcgcKkA5J97nipfVi49/G2fbOQpgikOMFMInyB1mNGP+bwczmbEBGftAGmBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708751271; c=relaxed/simple;
	bh=2o8hV7HXk8RnWZU0l/awuXlvNoVcC6EOX0n+qzkiK5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVfdb2M/I6Fkc9uEKhLPzGNm1P3OX3hgZq/nCzn1uj9gK0hT+mz3HcavEeaTkGW6uV3Folj/LLbwUr4O8NYK30uxTD7H+9zIoVzAjzcXc4DIA57DWcEpjLyHjwtrrotQKB518duRnCVlzmBd5BhSKsf95W4AfeJIuuP1sSJgqfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=mrhtn8CD; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5dbcfa0eb5dso1344309a12.3
        for <io-uring@vger.kernel.org>; Fri, 23 Feb 2024 21:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1708751269; x=1709356069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjBQFgNMe4f+4ZKhFs7JtH4JtEkCLrwOLfbsses+mMA=;
        b=mrhtn8CDLF4zY1WTIEtKc0GJE1to8tdhzLN92bLz0DqPYiXdoW47uH27xOyFf3MMc+
         Qwz4YXg7qG2EhTPsQSZ8MDahJNhe0U5XEz7Q4xobXvfSOdqzEI/B/R+RPOdKQmWF3W98
         sWUe/DU+wv2L34Lxdwi0t+t+2r+uIBDOQ93ZCbL0sDBavAcKqMy/DZpKUuDcuMrqPB8p
         yXT3vtuKrMzs4zlEDbrlXQoqxVCvrNjQcqj8MM2I9GUUTpT2xWwDiJeLNf3MF9rTwoGk
         qC8lUMhyEwY9PBjhw2so6i9ywlLNmB4E4uo3lsbGa2N4qU3ytzOfDg69xVqQimIJIy5h
         mZ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708751269; x=1709356069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wjBQFgNMe4f+4ZKhFs7JtH4JtEkCLrwOLfbsses+mMA=;
        b=hGTLzBEeP+uoRv49K5JrN21+KRnYehGs4aCigqMJzmxu3vkB2WDMqVD0fts6lVjPYM
         Dc8Oj1cr0UXK+mLRsOzLtHH19lU+vrSLaj2xpvXS3qpneR2YHwCj2skU/aQcKFo5jFJe
         TmuWGvRHb8SqPBeAxHw3DZRaeUCZFGIuZ5tSvFm2+V2Y1GEITymopNl1oVwFJJnlgXpj
         Vv9RkZVKuLbCenhLFvuJtZtLd0M5PmV0B/mwmopM6y92CYxSUiCyXkjWwgzT4ziAf0f9
         47Gogdwp7w3Ohzowv5ESFoOHMCb7yhc3n7vSltfQOqUu7jMlhhTC2+aFcJ59XFouXGBn
         zDiQ==
X-Gm-Message-State: AOJu0Yw538CfcDpL2VRHvTvCVzsLOOWrBMWvHZ+Tdxo9HvkslkNgP/IK
	6fxTQN+b+vej594YK+8RnBxsHsoLuc9bmK3Y40lSZltQiHviTZnJukY5M3gsY1pnSN+wsVtSSE0
	/
X-Google-Smtp-Source: AGHT+IFs3rw5IZzr0fNOKsez6d/HhQbKqAItyxSEAA2qhxhLqiBqI6Sq3e6RzRFVifRwUcIwH6rs7w==
X-Received: by 2002:a05:6a00:26ed:b0:6e3:759b:cdde with SMTP id p45-20020a056a0026ed00b006e3759bcddemr1670871pfw.33.1708751268976;
        Fri, 23 Feb 2024 21:07:48 -0800 (PST)
Received: from localhost (fwdproxy-prn-118.fbsv.net. [2a03:2880:ff:76::face:b00c])
        by smtp.gmail.com with ESMTPSA id s15-20020a62e70f000000b006e4701c0aedsm322267pfh.213.2024.02.23.21.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 21:07:48 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1 4/4] liburing: add unit test for io_uring_register_iowait()
Date: Fri, 23 Feb 2024 21:07:35 -0800
Message-ID: <20240224050735.1759733-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240224050735.1759733-1-dw@davidwei.uk>
References: <20240224050735.1759733-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Wei <davidhwei@meta.com>

Add a unit test for io_uring_register_iowait() by creating a thread that
writes into a pipe after a delay, checking iowait before and after.

Signed-off-by: David Wei <davidhwei@meta.com>
---
 test/Makefile |   1 +
 test/iowait.c | 157 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 158 insertions(+)
 create mode 100644 test/iowait.c

diff --git a/test/Makefile b/test/Makefile
index b09228f..779a7db 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -107,6 +107,7 @@ test_srcs := \
 	io_uring_passthrough.c \
 	io_uring_register.c \
 	io_uring_setup.c \
+	iowait.c \
 	lfs-openat.c \
 	lfs-openat-write.c \
 	link.c \
diff --git a/test/iowait.c b/test/iowait.c
new file mode 100644
index 0000000..fcd4004
--- /dev/null
+++ b/test/iowait.c
@@ -0,0 +1,157 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: Test that waiting for CQ is accounted as iowait if enabled via
+ * io_uring_register_iowait(), and vice versa.
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <sys/time.h>
+#include <pthread.h>
+#include <linux/kernel.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+struct data {
+	pthread_barrier_t startup;
+	int out_fd;
+};
+
+static unsigned long long get_iowait()
+{
+	FILE *fp;
+	char buf[256];
+	unsigned long long user, nice, system, idle, iowait;
+
+	fp = fopen("/proc/stat", "r");
+	if (!fp) {
+		perror("fopen");
+		exit(T_EXIT_FAIL);
+	}
+
+	if (fgets(buf, sizeof(buf), fp) == NULL) {
+		perror("fgets");
+		fclose(fp);
+		exit(T_EXIT_FAIL);
+	}
+	fclose(fp);
+
+	sscanf(buf, "cpu %llu %llu %llu %llu %llu", &user, &nice, &system,
+						    &idle, &iowait);
+
+	return iowait;
+}
+
+static void *pipe_write(void *data)
+{
+	struct data *d = data;
+	char buf[32];
+	int ret;
+
+	memset(buf, 0x55, sizeof(buf));
+	pthread_barrier_wait(&d->startup);
+	usleep(100000);
+
+	ret = write(d->out_fd, buf, sizeof(buf));
+	if (ret < 0) {
+		perror("write");
+		return NULL;
+	}
+
+	return NULL;
+}
+
+static int test_iowait(struct io_uring *ring, bool enabled)
+{
+	unsigned long long iowait_pre, iowait_post, iowait;
+	double iowait_ms_max_diff;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	pthread_t thread;
+	double iowait_ms;
+	int ret, fds[2];
+	struct data d;
+	char buf[32];
+	void *tret;
+
+	if (pipe(fds) < 0) {
+		perror("pipe");
+		return T_EXIT_FAIL;
+	}
+	d.out_fd = fds[1];
+
+	pthread_barrier_init(&d.startup, NULL, 2);
+	pthread_create(&thread, NULL, pipe_write, &d);
+	pthread_barrier_wait(&d.startup);
+
+	io_uring_register_iowait(ring, enabled);
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_read(sqe, fds[0], buf, sizeof(buf), 0);
+
+	io_uring_submit(ring);
+
+	iowait_pre = get_iowait();
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+	io_uring_cq_advance(ring, 1);
+
+	iowait_post = get_iowait();
+
+	/* 
+	 * writer sleeps for 100 ms, so max diff is 100 plus a tolerance of
+	 * 10 ms
+	 */
+	iowait_ms_max_diff = (enabled ? 100.0 : 0.0) + 10.0;
+
+	if (iowait_post > iowait_pre)
+		iowait = iowait_post - iowait_pre;
+	else
+		iowait = iowait_pre - iowait_post;
+	iowait_ms = ((double)iowait / sysconf(_SC_CLK_TCK)) * 1000;
+
+	if (iowait_ms > iowait_ms_max_diff)
+		ret = T_EXIT_FAIL;
+	else
+		ret = T_EXIT_PASS;
+
+	pthread_join(thread, &tret);
+	close(fds[0]);
+	close(fds[1]);
+	return ret;
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
+	ret = t_create_ring_params(8, &ring, &p);
+	if (ret == T_SETUP_SKIP)
+		return T_EXIT_SKIP;
+	else if (ret != T_SETUP_OK)
+		return ret;
+
+	ret = test_iowait(&ring, false);
+	if (ret == T_EXIT_FAIL || ret == T_EXIT_SKIP)
+		return ret;
+
+	ret = test_iowait(&ring, true);
+	if (ret == T_EXIT_FAIL || ret == T_EXIT_SKIP)
+		return ret;
+
+	io_uring_queue_exit(&ring);
+	return T_EXIT_PASS;
+}
-- 
2.43.0


