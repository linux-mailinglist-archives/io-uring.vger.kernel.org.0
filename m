Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D94F2D35BB
	for <lists+io-uring@lfdr.de>; Tue,  8 Dec 2020 23:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgLHWBd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Dec 2020 17:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgLHWBd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Dec 2020 17:01:33 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CA0C061794
        for <io-uring@vger.kernel.org>; Tue,  8 Dec 2020 14:00:53 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id g185so3686862wmf.3
        for <io-uring@vger.kernel.org>; Tue, 08 Dec 2020 14:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p5XKfZCNrH/MnfJMtf/ExT9itSmHIG+mloI7j+0fZu8=;
        b=W+4VTTOPB0RO28pj39YMQqCiBJIUPeyRgOclcl4eWZG73RYEAvTdSjMVTTbkVQ1CrS
         rnWAOnWZzgH3/1kiwDafPyn55p1oTwc0TN12J5gP270Zl0YBD03hk9YxPHElK84wFgXw
         FzXqSrfS0yUhuA3pkL+Lggr7NcfGA9oy/on+BvZcf0QtpSAczXBOh12mtaZXYVEwnNd+
         S/yvOEcnJ0qEvkqqX4MhpT16ngffkcViC31XTZtB6RgCQ75PZkZiL2iScfrBpWvdBtbC
         RZAFkycywMchni/GPZmy3ap6BwB3zEmh4An8Hkf2ufWbB4iZmB68YgVhXe96yxjh0XVP
         cONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p5XKfZCNrH/MnfJMtf/ExT9itSmHIG+mloI7j+0fZu8=;
        b=r+us8nZs1PM2wZMSfQJBGDIPJRXAc3ZUEMa7rUuZTSACRUsNWacOrn+pJN4JHNYUaX
         QYj9T4PwrPO4q0DLFiPjineHs17hYCcA8apE91gQ6ow2+E3dxMFe6oeiGScFHkBJwdQo
         YaMt4feQiJcF/VPQRNMux2/qnicgiUDmJ0VWT95RKiXaI5V/rKQ/0zeDjoZOYUjOkoS6
         q96BS/w7IYH3JhXyOmii72ijtmky9FU/bFnXoQJ+gH0FENe0rNXeGDgKswIq2vLTeuin
         s8zlwU8Var/9CuIp84TO/RVLBgOMZ3f92SVZlUsunCgeGTIA4xYGORwbaVr+5KEuauvL
         +5TQ==
X-Gm-Message-State: AOAM531zesnxYAc1UMSheT+ivAgio2vPMPpL6dUxjtC8FJO7czCm+Jjj
        q0vdHCJqWpe89/aJBdg5fzs=
X-Google-Smtp-Source: ABdhPJyjJj3LjLSrrWppImuWWVusLodFl+7bYI+13g+xBRj9aLa9EUqsDgpLNafhPTfNa3aFzx8ZGg==
X-Received: by 2002:a7b:c055:: with SMTP id u21mr5695037wmc.130.1607464851787;
        Tue, 08 Dec 2020 14:00:51 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.156])
        by smtp.gmail.com with ESMTPSA id h5sm344192wrp.56.2020.12.08.14.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 14:00:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] rem_buf/test: inital testing for OP_REMOVE_BUFFERS
Date:   Tue,  8 Dec 2020 21:57:29 +0000
Message-Id: <0de486be33eba2da333ac83efb33a7349344551e.1607464425.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Basic testing for IORING_OP_REMOVE_BUFFERS. test_rem_buf(IOSQE_ASYNC)
should check that it's doing locking right when punted async.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

NOTICE:
test_rem_buf(IOSQE_ASYNC) hangs with 5.10
because of double io_ring_submit_lock(). One of the iopoll patches
for 5.11 fixes that.

 test/read-write.c | 112 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 103 insertions(+), 9 deletions(-)

diff --git a/test/read-write.c b/test/read-write.c
index 84ea3a2..7f33ad4 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -472,10 +472,42 @@ static int test_buf_select_short(const char *filename, int nonvec)
 	return ret;
 }
 
-static int test_buf_select(const char *filename, int nonvec)
+static int provide_buffers_iovec(struct io_uring *ring, int bgid)
 {
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
+	int i, ret;
+
+	for (i = 0; i < BUFFERS; i++) {
+		sqe = io_uring_get_sqe(ring);
+		io_uring_prep_provide_buffers(sqe, vecs[i].iov_base,
+						vecs[i].iov_len, 1, bgid, i);
+	}
+
+	ret = io_uring_submit(ring);
+	if (ret != BUFFERS) {
+		fprintf(stderr, "submit: %d\n", ret);
+		return -1;
+	}
+
+	for (i = 0; i < BUFFERS; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret) {
+			fprintf(stderr, "wait_cqe=%d\n", ret);
+			return 1;
+		}
+		if (cqe->res < 0) {
+			fprintf(stderr, "cqe->res=%d\n", cqe->res);
+			return 1;
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	return 0;
+}
+
+static int test_buf_select(const char *filename, int nonvec)
+{
 	struct io_uring_probe *p;
 	struct io_uring ring;
 	int ret, i;
@@ -509,29 +541,67 @@ static int test_buf_select(const char *filename, int nonvec)
 	for (i = 0; i < BUFFERS; i++)
 		memset(vecs[i].iov_base, 0x55, vecs[i].iov_len);
 
-	for (i = 0; i < BUFFERS; i++) {
+	ret = provide_buffers_iovec(&ring, 1);
+	if (ret)
+		return ret;
+
+	ret = __test_io(filename, &ring, 0, 0, 0, 0, nonvec, 1, 1, BS);
+	io_uring_queue_exit(&ring);
+	return ret;
+}
+
+static int test_rem_buf(int batch, int sqe_flags)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	int left, ret, nr = 0;
+	int bgid = 1;
+
+	if (no_buf_select)
+		return 0;
+
+	ret = io_uring_queue_init(64, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return 1;
+	}
+
+	ret = provide_buffers_iovec(&ring, bgid);
+	if (ret)
+		return ret;
+
+	left = BUFFERS;
+	while (left) {
+		int to_rem = (left < batch) ? left : batch;
+
+		left -= to_rem;
 		sqe = io_uring_get_sqe(&ring);
-		io_uring_prep_provide_buffers(sqe, vecs[i].iov_base,
-						vecs[i].iov_len, 1, 1, i);
+		io_uring_prep_remove_buffers(sqe, to_rem, bgid);
+		sqe->user_data = to_rem;
+		sqe->flags |= sqe_flags;
+		++nr;
 	}
 
 	ret = io_uring_submit(&ring);
-	if (ret != BUFFERS) {
+	if (ret != nr) {
 		fprintf(stderr, "submit: %d\n", ret);
 		return -1;
 	}
 
-	for (i = 0; i < BUFFERS; i++) {
+	for (; nr > 0; nr--) {
 		ret = io_uring_wait_cqe(&ring, &cqe);
-		if (cqe->res < 0) {
+		if (ret) {
+			fprintf(stderr, "wait_cqe=%d\n", ret);
+			return 1;
+		}
+		if (cqe->res != cqe->user_data) {
 			fprintf(stderr, "cqe->res=%d\n", cqe->res);
 			return 1;
 		}
 		io_uring_cqe_seen(&ring, cqe);
 	}
 
-	ret = __test_io(filename, &ring, 0, 0, 0, 0, nonvec, 1, 1, BS);
-
 	io_uring_queue_exit(&ring);
 	return ret;
 }
@@ -786,6 +856,30 @@ int main(int argc, char *argv[])
 		goto err;
 	}
 
+	ret = test_rem_buf(1, 0);
+	if (ret) {
+		fprintf(stderr, "test_rem_buf by 1 failed\n");
+		goto err;
+	}
+
+	ret = test_rem_buf(10, 0);
+	if (ret) {
+		fprintf(stderr, "test_rem_buf by 10 failed\n");
+		goto err;
+	}
+
+	ret = test_rem_buf(2, IOSQE_IO_LINK);
+	if (ret) {
+		fprintf(stderr, "test_rem_buf link failed\n");
+		goto err;
+	}
+
+	ret = test_rem_buf(2, IOSQE_ASYNC);
+	if (ret) {
+		fprintf(stderr, "test_rem_buf async failed\n");
+		goto err;
+	}
+
 	srand((unsigned)time(NULL));
 	if (create_nonaligned_buffers()) {
 		fprintf(stderr, "file creation failed\n");
-- 
2.24.0

