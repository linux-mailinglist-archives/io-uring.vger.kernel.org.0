Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DAA45CE8A
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 21:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245402AbhKXVBd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 16:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244393AbhKXVBc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 16:01:32 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A348BC061574
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 12:58:22 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id o20so15907998eds.10
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 12:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uavHhsl+vSCAnIOhbAkhzVQV1qwgRQDKe/GiE4OSA84=;
        b=juXrDgPlS0goLakqaEckhC1gQtr9+mAEjreOrKK1Lov4pATCZygx4YvCCdbzP1JGkn
         d0sC953kkEh4Zc8C6uCpO28iDCdEB0VC0picx1S4KNJbczK17kLoBNamaHd0hGp4anhY
         CNokZx/Uig5P4xCqgJbC/Shvu0soH4bjLL9LcGi6UioT0sGVeiv5RG/Je2Lwo6+RonsF
         kv1zYHbaH4280I6HDJoeSv67MGNFWwyUGTUdtdylZf3lCtd0mSHyQjiY2Q0iOlTrkpzp
         djHy43ZBH0Kivc4RdXoXmSc44K1HnL7t5FZqzA6fiT0C/+TVuaBtPpKSFXx1oCu3EAxg
         63zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uavHhsl+vSCAnIOhbAkhzVQV1qwgRQDKe/GiE4OSA84=;
        b=r6ff/zd0ysZLFQUYiAC8AXeu34hiTbwDV3i+0dlHngssNFECR08TbK4IaH7FQ6465R
         i0nKq4O+JkF74vFyNMrAAlU38uIJBZeJ3q9eRFMRiS/6GJNN0HaxOeTiDeEGDihrOOM/
         4xCocBCSV2aYs4EOXhVYHs0VQr5RmZ4ZTxNbiV9ot3dTcx/pSTXhBvRcBepWkyhmcdRr
         xD6kOnsDKpwa1Op1dKTIKjKB9pRmMZhBlnOavVO2eBpoYoL04oKseOzKGag8KwVVRYrD
         Fz1aRvSRjD7o3prBIQQVLqiskqVAblvKBL1oV/fgRDY1KHzJ+Bt3QNww/yj9mGUw53U9
         5wzQ==
X-Gm-Message-State: AOAM533D9PYDpKoxWF16LQOfJAVCF0Cbt22fKzB67yZN2y07lILCDCdC
        k/0nV72p0kx8PzPtYnDumGqvrk70l4s=
X-Google-Smtp-Source: ABdhPJxs1LdR8uDgJab1C7DtJjF5lLfdubrZROhm8nBgsGDny82VY0Z6yhTp2qR0hi3IbEsPYiYMIQ==
X-Received: by 2002:a17:906:e115:: with SMTP id gj21mr23484745ejb.348.1637787501015;
        Wed, 24 Nov 2021 12:58:21 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.168])
        by smtp.gmail.com with ESMTPSA id h7sm745843edb.89.2021.11.24.12.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:58:20 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 2/2] tests: add tests for IOSQE_CQE_SKIP_SUCCESS
Date:   Wed, 24 Nov 2021 20:58:12 +0000
Message-Id: <64a28950287c97b4d5bd11bf288ab6fab5d45b79.1637786880.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1637786880.git.asml.silence@gmail.com>
References: <cover.1637786880.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 .gitignore      |   1 +
 test/Makefile   |   1 +
 test/skip-cqe.c | 338 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 340 insertions(+)
 create mode 100644 test/skip-cqe.c

diff --git a/.gitignore b/.gitignore
index fb3a859..cb08ca0 100644
--- a/.gitignore
+++ b/.gitignore
@@ -131,6 +131,7 @@
 /test/testfile
 /test/submit-link-fail
 /test/exec-target
+/test/skip-cqe
 /test/*.dmesg
 /test/output/
 
diff --git a/test/Makefile b/test/Makefile
index d6e7227..c09078a 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -147,6 +147,7 @@ test_srcs := \
 	timeout-overflow.c \
 	unlink.c \
 	wakeup-hang.c \
+	skip-cqe.c \
 	# EOL
 
 
diff --git a/test/skip-cqe.c b/test/skip-cqe.c
new file mode 100644
index 0000000..184932f
--- /dev/null
+++ b/test/skip-cqe.c
@@ -0,0 +1,338 @@
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+
+#include "liburing.h"
+
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
+	if (!(ring.features & IORING_FEAT_CQE_SKIP)) {
+		printf("IOSQE_CQE_SKIP_SUCCESS is not supported, skip\n");
+		return 0;
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
2.34.0

