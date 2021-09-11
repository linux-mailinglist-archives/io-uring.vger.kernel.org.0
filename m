Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13131407884
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 15:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbhIKOAh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 10:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236115AbhIKOA2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 10:00:28 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7C8C061574
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 06:59:13 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id u16so6965218wrn.5
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 06:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fgnFoyN1K5GqDCM1HR1l6a+X0BIFnPXVVm4hjuYI0D0=;
        b=gFaPmzt/4+oAeyHddV9G0RPRMpzwzL2FhAyt59TDjQdiwM+s3obD2CsSG+5t+B8ZXs
         gplC9fR9jdVI+qUFNnXQBXWJB/lx+zHQuZwt354/fYokCrhHzxoTY63lYsJ1+CA1aRvS
         cu+BIif8qLsM+E0kiss4pp7TQcR2UkkQktfiAob6uFKUblhzfjuV5OmA4B/5GazFAmsr
         E2z7hl54QiL80DQgVmmUqUJ0jQhJ0SlDiL8BMJNBrmRPiwMeHyABqxehd1iEN2slGUO4
         QljfclaDcea8N+RbHsvzv70KZ59c6kf2DhXXavK0azvQDrTlfg3t8+a9uF8WBD5q4Dlx
         Ktng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fgnFoyN1K5GqDCM1HR1l6a+X0BIFnPXVVm4hjuYI0D0=;
        b=3XI8TRiD47k4CR6Q1rhQ7/ApWLfiY7rv4Xzuedu9K/jxbnfNkKwoISYvl6+a+puiWK
         juWj7tzaCXW/LDU15fYlBnEGD2QQycMpTLDlEwn/nIh0ZFLeTHnHURK4jnZkHrwAcn+F
         WhKZdR0o57Ceq1vBBK3rjUKKryCfAXc9nEEw8ReKog0TiKRTQ0RT0hg//pP37N3LYhJf
         jgo1BEVv3CIAiHD+JNNnWcpi5i4nErXl+Z/85V7gCj/hIifU42s0u8pwtQ7z4Hjq1C8y
         ZHR1yYjOcTkdCFpPqVmDiwb/lTr1CALPcDn1ihVCNzkH3d6pzZIH6JVYEniq9RcpFid3
         Iqtw==
X-Gm-Message-State: AOAM532mDaNCeb53k1MSwd0fN35J80yVPcWi8d3WE9xlke7BSlFUAtMU
        QnlIVlpku4hZgPAoOe3qF1YpeT/ItM8=
X-Google-Smtp-Source: ABdhPJzimyng6bSVX+XZuwmzy5ega82IexsYtCfOSSXlKD6cU3jy25HO8DKUTBp/6xjTsscf5WNEpA==
X-Received: by 2002:adf:f188:: with SMTP id h8mr3164295wro.269.1631368751868;
        Sat, 11 Sep 2021 06:59:11 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.175])
        by smtp.gmail.com with ESMTPSA id f3sm1622214wmj.28.2021.09.11.06.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 06:59:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC][PATCH liburing] tests: test CQE skipping
Date:   Sat, 11 Sep 2021 14:58:32 +0100
Message-Id: <0f38b9544e4894f773b09959e023bb92b7f31273.1631368655.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Test IOSQE_CQE_SKIP_SUCCESS allowing to ingore CQE posting.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 .gitignore      |   1 +
 test/Makefile   |   2 +
 test/skip-cqe.c | 336 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 339 insertions(+)
 create mode 100644 test/skip-cqe.c

diff --git a/.gitignore b/.gitignore
index 0213bfa..5fa71bc 100644
--- a/.gitignore
+++ b/.gitignore
@@ -130,6 +130,7 @@
 /test/testfile
 /test/submit-link-fail
 /test/exec-target
+/test/skip-cqe
 /test/*.dmesg
 
 config-host.h
diff --git a/test/Makefile b/test/Makefile
index 54ee730..1f78ad6 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -136,6 +136,7 @@ test_targets += \
 	sendmsg_fs_cve \
 	rsrc_tags \
 	exec-target \
+	skip-cqe \
 	# EOL
 
 all_targets += $(test_targets)
@@ -278,6 +279,7 @@ test_srcs := \
 	sendmsg_fs_cve.c \
 	rsrc_tags.c \
 	exec-target.c \
+	skip-cqe.c \
 	# EOL
 
 test_objs := $(patsubst %.c,%.ol,$(patsubst %.cc,%.ol,$(test_srcs)))
diff --git a/test/skip-cqe.c b/test/skip-cqe.c
new file mode 100644
index 0000000..3be55ca
--- /dev/null
+++ b/test/skip-cqe.c
@@ -0,0 +1,336 @@
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+
+#include "liburing.h"
+
+#ifndef IOSQE_CQE_SKIP_SUCCESS
+#define IOSQE_CQE_SKIP_SUCCESS	(1U << 6)
+#endif
+#define LINK_SIZE 		6
+#define TIMEOUT_USER_DATA	(-1)
+
+static int fds[2];
+
+/* should be successfully submitted but fails during execution */
+static void prep_exec_fail_req(struct io_uring_sqe *sqe)
+{
+	io_uring_prep_write(sqe, fds[2], NULL, 100, 0);
+}
+
+static int test_link_success(struct io_uring *ring, int nr, bool skip_last)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret, i;
+
+	for (i = 0; i < nr; ++i) {
+		sqe = io_uring_get_sqe(ring);
+		io_uring_prep_nop(sqe);
+		if (i != nr - 1 || skip_last)
+			sqe->flags |= IOSQE_IO_LINK | IOSQE_CQE_SKIP_SUCCESS;
+		sqe->user_data = i;
+	}
+
+	ret = io_uring_submit(ring);
+	if (ret != nr) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		goto err;
+	}
+
+	if (!skip_last) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret != 0) {
+			fprintf(stderr, "wait completion %d\n", ret);
+			goto err;
+		}
+		if (cqe->res != 0) {
+			fprintf(stderr, "nop failed: res %d\n", cqe->res);
+			goto err;
+		}
+		if (cqe->user_data != nr - 1) {
+			fprintf(stderr, "invalid user_data %i\n", (int)cqe->user_data);
+			goto err;
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	if (io_uring_peek_cqe(ring, &cqe) >= 0) {
+		fprintf(stderr, "single CQE expected %i\n", (int)cqe->user_data);
+		goto err;
+	}
+	return 0;
+err:
+	return 1;
+}
+
+static int test_link_fail(struct io_uring *ring, int nr, int fail_idx)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret, i;
+
+	for (i = 0; i < nr; ++i) {
+		sqe = io_uring_get_sqe(ring);
+		if (i == fail_idx)
+			prep_exec_fail_req(sqe);
+		else
+			io_uring_prep_nop(sqe);
+
+		if (i != nr - 1)
+			sqe->flags |= IOSQE_IO_LINK | IOSQE_CQE_SKIP_SUCCESS;
+		sqe->user_data = i;
+	}
+
+	ret = io_uring_submit(ring);
+	if (ret != nr) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		goto err;
+	}
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret != 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+		goto err;
+	}
+	if (!cqe->res || cqe->user_data != fail_idx) {
+		fprintf(stderr, "got: user_data %d res %d, expected data: %d\n",
+				(int)cqe->user_data, cqe->res, fail_idx);
+		goto err;
+	}
+	io_uring_cqe_seen(ring, cqe);
+
+	if (io_uring_peek_cqe(ring, &cqe) >= 0) {
+		fprintf(stderr, "single CQE expected %i\n", (int)cqe->user_data);
+		goto err;
+	}
+	return 0;
+err:
+	return 1;
+}
+
+static int test_ltimeout_cancel(struct io_uring *ring, int nr, int tout_idx,
+				bool async, int fail_idx)
+{
+	struct __kernel_timespec ts = {.tv_sec = 1, .tv_nsec = 0};
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret, i;
+	int e_res = 0, e_idx = nr - 1;
+
+	if (fail_idx >= 0) {
+		e_res = -EFAULT;
+		e_idx = fail_idx;
+	}
+
+	for (i = 0; i < nr; ++i) {
+		sqe = io_uring_get_sqe(ring);
+		if (i == fail_idx)
+			prep_exec_fail_req(sqe);
+		else
+			io_uring_prep_nop(sqe);
+		sqe->user_data = i;
+		sqe->flags |= IOSQE_IO_LINK;
+		if (async)
+			sqe->flags |= IOSQE_ASYNC;
+		if (i != nr - 1)
+			sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
+
+		if (i == tout_idx) {
+			sqe = io_uring_get_sqe(ring);
+			io_uring_prep_link_timeout(sqe, &ts, 0);
+			sqe->flags |= IOSQE_IO_LINK | IOSQE_CQE_SKIP_SUCCESS;
+			sqe->user_data = TIMEOUT_USER_DATA;
+		}
+	}
+
+	ret = io_uring_submit(ring);
+	if (ret != nr + 1) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		goto err;
+	}
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret != 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+		goto err;
+	}
+	if (cqe->user_data != e_idx) {
+		fprintf(stderr, "invalid user_data %i\n", (int)cqe->user_data);
+		goto err;
+	}
+	if (cqe->res != e_res) {
+		fprintf(stderr, "unexpected res: %d\n", cqe->res);
+		goto err;
+	}
+	io_uring_cqe_seen(ring, cqe);
+
+	if (io_uring_peek_cqe(ring, &cqe) >= 0) {
+		fprintf(stderr, "single CQE expected %i\n", (int)cqe->user_data);
+		goto err;
+	}
+	return 0;
+err:
+	return 1;
+}
+
+static int test_ltimeout_fire(struct io_uring *ring, bool async,
+			      bool skip_main, bool skip_tout)
+{
+	char buf[1];
+	struct __kernel_timespec ts = {.tv_sec = 0, .tv_nsec = 1000000};
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret, i;
+	int nr = 1 + !skip_tout;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_read(sqe, fds[0], buf, sizeof(buf), 0);
+	sqe->flags |= IOSQE_IO_LINK;
+	sqe->flags |= async ? IOSQE_ASYNC : 0;
+	sqe->flags |= skip_main ? IOSQE_CQE_SKIP_SUCCESS : 0;
+	sqe->user_data = 0;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_link_timeout(sqe, &ts, 0);
+	sqe->flags |= skip_tout ? IOSQE_CQE_SKIP_SUCCESS : 0;
+	sqe->user_data = 1;
+
+	ret = io_uring_submit(ring);
+	if (ret != 2) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		return 1;
+	}
+
+	for (i = 0; i < nr; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret != 0) {
+			fprintf(stderr, "wait completion %d\n", ret);
+			return 1;
+		}
+		switch (cqe->user_data) {
+		case 0:
+			if (cqe->res != -ECANCELED && cqe->res != -EINTR) {
+				fprintf(stderr, "unexpected read return: %d\n", cqe->res);
+				return 1;
+			}
+			break;
+		case 1:
+			if (skip_tout) {
+				fprintf(stderr, "extra timeout cqe, %d\n", cqe->res);
+				return 1;
+			}
+			break;
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+
+	if (io_uring_peek_cqe(ring, &cqe) >= 0) {
+		fprintf(stderr, "single CQE expected: got data: %i res: %i\n",
+				(int)cqe->user_data, cqe->res);
+		return 1;
+	}
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int ret, i;
+	int mid_idx = LINK_SIZE / 2;
+	int last_idx = LINK_SIZE - 1;
+
+	if (pipe(fds)) {
+		fprintf(stderr, "pipe() failed\n");
+		return 1;
+	}
+	ret = io_uring_queue_init(16, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return 1;
+	}
+
+	for (i = 0; i < 4; i++) {
+		bool skip_last = i & 1;
+		int sz = (i & 2) ? LINK_SIZE : 1;
+
+		ret = test_link_success(&ring, sz, skip_last);
+		if (ret) {
+			fprintf(stderr, "test_link_success sz %d, %d last\n",
+					skip_last, sz);
+			return ret;
+		}
+	}
+
+	ret = test_link_fail(&ring, LINK_SIZE, mid_idx);
+	if (ret) {
+		fprintf(stderr, "test_link_fail mid failed\n");
+		return ret;
+	}
+
+	ret = test_link_fail(&ring, LINK_SIZE, last_idx);
+	if (ret) {
+		fprintf(stderr, "test_link_fail last failed\n");
+		return ret;
+	}
+
+	for (i = 0; i < 2; i++) {
+		bool async = i & 1;
+
+		ret = test_ltimeout_cancel(&ring, 1, 0, async, -1);
+		if (ret) {
+			fprintf(stderr, "test_ltimeout_cancel 1 failed, %i\n",
+					async);
+			return ret;
+		}
+		ret = test_ltimeout_cancel(&ring, LINK_SIZE, mid_idx, async, -1);
+		if (ret) {
+			fprintf(stderr, "test_ltimeout_cancel mid failed, %i\n",
+					async);
+			return ret;
+		}
+		ret = test_ltimeout_cancel(&ring, LINK_SIZE, last_idx, async, -1);
+		if (ret) {
+			fprintf(stderr, "test_ltimeout_cancel last failed, %i\n",
+					async);
+			return ret;
+		}
+		ret = test_ltimeout_cancel(&ring, LINK_SIZE, mid_idx, async, mid_idx);
+		if (ret) {
+			fprintf(stderr, "test_ltimeout_cancel fail mid failed, %i\n",
+					async);
+			return ret;
+		}
+		ret = test_ltimeout_cancel(&ring, LINK_SIZE, mid_idx, async, mid_idx - 1);
+		if (ret) {
+			fprintf(stderr, "test_ltimeout_cancel fail2 mid failed, %i\n",
+					async);
+			return ret;
+		}
+		ret = test_ltimeout_cancel(&ring, LINK_SIZE, mid_idx, async, mid_idx + 1);
+		if (ret) {
+			fprintf(stderr, "test_ltimeout_cancel fail3 mid failed, %i\n",
+					async);
+			return ret;
+		}
+	}
+
+	for (i = 0; i < 8; i++) {
+		bool async = i & 1;
+		bool skip1 = i & 2;
+		bool skip2 = i & 4;
+
+		ret = test_ltimeout_fire(&ring, async, skip1, skip2);
+		if (ret) {
+			fprintf(stderr, "test_ltimeout_fire failed\n");
+			return ret;
+		}
+	}
+
+	close(fds[0]);
+	close(fds[1]);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
-- 
2.33.0

