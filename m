Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A6B3F7BC9
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 19:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhHYRzF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 13:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbhHYRzD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 13:55:03 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FF0C0613CF
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 10:54:17 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id m25-20020a7bcb99000000b002e751bcb5dbso307184wmi.5
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 10:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PryS7beHXlmVYhzNF8W8WB5zhapHxnQdqG6FSNyj7kg=;
        b=f50PMescgFm/sYTQ9loGRJVIgK7b1VuQ1CHcswGZyhPP1+gsysbTpanW2HcopMPO9X
         qSqrT3LWm6F4dbqqqfTwI7CqqJwaY4n6yE7z6AcRQdhIQGQZOU/gTI+Ev27Rp2h/sPsV
         pWa0+w0k9TZ1VOSayR5YZxve9cs6vNNm/99A4V1+ywnCDHOCbVzcBIN7+Q2t1aboGsWi
         sgLVAFSjdf8Q2jMjsp9mvY8flrSxKgAh2+nC+LF7tnsStBfXmBxxkGKvzfwg7gWkGaAb
         mwNHwFIBNjP9VrzF+cB8M+rE+Ytz/UrfvQj+R0qpCPKoUOA+CtuApRxFadSrHiZfC5E2
         RqNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PryS7beHXlmVYhzNF8W8WB5zhapHxnQdqG6FSNyj7kg=;
        b=EDrmkJMQ2aJeVXoUO1dV0HwGi1/d5uq5MnSD4XuzLmN+NZ87nOxqcjoW0/atzOUbfJ
         3ya3+G3QDIOwmongGud5aTx//eFPGkWW8e2eWXWJxKYzMhbtj8W9nt2vO6E4GOZBfsKH
         13G9xsqaaM5bPF2zuNwMPnsDHEwwlRhp0ejONDiJ5JqxqRZe7T+fP5kxB+JiuT5HjFDS
         XfzqGy/hHziIzpa8DTtSUYEsK2XOfpyTARZggfm3yIw8Ame2880WvXMR6rjdmXiezcJZ
         9CYBqXFx5idDOywzXl8IqNga1nLl0fEX3CNw/4fG4Vw35OZPXCs1NJVBQhcvE6UBXGtU
         7ywg==
X-Gm-Message-State: AOAM53352sQgu5jUpzfqhxsYAO2MYG9L5eXQK48aNVsCt9ZiLhu9CyV8
        tfphn3oImAjzCdzyBk/nlSo=
X-Google-Smtp-Source: ABdhPJynzM4x01eqYJILZFzkSEaQiVjNN/DciJb/FiTaaS8OImmu4l+hwn5NdbwiTYHQ2MO9VpBeNA==
X-Received: by 2002:a7b:c148:: with SMTP id z8mr10733381wmi.147.1629914055820;
        Wed, 25 Aug 2021 10:54:15 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id q9sm590459wrs.3.2021.08.25.10.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 10:54:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 2/2] tests: skip when large buf register fails
Date:   Wed, 25 Aug 2021 18:53:36 +0100
Message-Id: <682c09c1d153cd4dfe505ded6069b294e98078e3.1629913874.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629913874.git.asml.silence@gmail.com>
References: <cover.1629913874.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Registering lots of memory will fail for non-privileged users, so skip
tests if that happens.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/helpers.c    | 19 +++++++++++++++++++
 test/helpers.h    |  4 ++++
 test/iopoll.c     | 24 ++++++++++++------------
 test/read-write.c | 26 +++++++++++---------------
 4 files changed, 46 insertions(+), 27 deletions(-)

diff --git a/test/helpers.c b/test/helpers.c
index 930d82a..975e7cb 100644
--- a/test/helpers.c
+++ b/test/helpers.c
@@ -114,3 +114,22 @@ enum t_setup_ret t_create_ring(int depth, struct io_uring *ring,
 	p.flags = flags;
 	return t_create_ring_params(depth, ring, &p);
 }
+
+enum t_setup_ret t_register_buffers(struct io_uring *ring,
+				    const struct iovec *iovecs,
+				    unsigned nr_iovecs)
+{
+	int ret;
+
+	ret = io_uring_register_buffers(ring, iovecs, nr_iovecs);
+	if (!ret)
+		return T_SETUP_OK;
+
+	if ((ret == -EPERM || ret == -ENOMEM) && geteuid()) {
+		fprintf(stdout, "too large non-root buffer registration, skip\n");
+		return T_SETUP_SKIP;
+	}
+
+	fprintf(stderr, "buffer register failed: %s\n", strerror(-ret));
+	return ret;
+}
diff --git a/test/helpers.h b/test/helpers.h
index 18de463..7526d46 100644
--- a/test/helpers.h
+++ b/test/helpers.h
@@ -54,6 +54,10 @@ enum t_setup_ret t_create_ring_params(int depth, struct io_uring *ring,
 enum t_setup_ret t_create_ring(int depth, struct io_uring *ring,
 			       unsigned int flags);
 
+enum t_setup_ret t_register_buffers(struct io_uring *ring,
+				    const struct iovec *iovecs,
+				    unsigned nr_iovecs);
+
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
 #ifdef __cplusplus
diff --git a/test/iopoll.c b/test/iopoll.c
index 7037c31..de36473 100644
--- a/test/iopoll.c
+++ b/test/iopoll.c
@@ -60,14 +60,13 @@ static int __test_io(const char *file, struct io_uring *ring, int write, int sqt
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
 	int open_flags;
-	int i, fd, ret;
+	int i, fd = -1, ret;
 	off_t offset;
 
-	if (buf_select && write)
+	if (buf_select) {
 		write = 0;
-	if (buf_select && fixed)
 		fixed = 0;
-
+	}
 	if (buf_select && provide_buffers(ring))
 		return 1;
 
@@ -77,19 +76,20 @@ static int __test_io(const char *file, struct io_uring *ring, int write, int sqt
 		open_flags = O_RDONLY;
 	open_flags |= O_DIRECT;
 
-	fd = open(file, open_flags);
-	if (fd < 0) {
-		perror("file open");
-		goto err;
-	}
-
 	if (fixed) {
-		ret = io_uring_register_buffers(ring, vecs, BUFFERS);
-		if (ret) {
+		ret = t_register_buffers(ring, vecs, BUFFERS);
+		if (ret == T_SETUP_SKIP)
+			return 0;
+		if (ret != T_SETUP_OK) {
 			fprintf(stderr, "buffer reg failed: %d\n", ret);
 			goto err;
 		}
 	}
+	fd = open(file, open_flags);
+	if (fd < 0) {
+		perror("file open");
+		goto err;
+	}
 	if (sqthread) {
 		ret = io_uring_register_files(ring, &fd, 1);
 		if (ret) {
diff --git a/test/read-write.c b/test/read-write.c
index 1cfa2d5..0c55159 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -49,7 +49,7 @@ static int __test_io(const char *file, struct io_uring *ring, int write,
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
 	int open_flags;
-	int i, fd, ret;
+	int i, fd = -1, ret;
 	off_t offset;
 
 #ifdef VERBOSE
@@ -57,13 +57,6 @@ static int __test_io(const char *file, struct io_uring *ring, int write,
 							buffered, sqthread,
 							fixed, nonvec);
 #endif
-	if (sqthread && geteuid()) {
-#ifdef VERBOSE
-		fprintf(stdout, "SKIPPED (not root)\n");
-#endif
-		return 0;
-	}
-
 	if (write)
 		open_flags = O_WRONLY;
 	else
@@ -71,19 +64,22 @@ static int __test_io(const char *file, struct io_uring *ring, int write,
 	if (!buffered)
 		open_flags |= O_DIRECT;
 
+	if (fixed) {
+		ret = t_register_buffers(ring, vecs, BUFFERS);
+		if (ret == T_SETUP_SKIP)
+			return 0;
+		if (ret != T_SETUP_OK) {
+			fprintf(stderr, "buffer reg failed: %d\n", ret);
+			goto err;
+		}
+	}
+
 	fd = open(file, open_flags);
 	if (fd < 0) {
 		perror("file open");
 		goto err;
 	}
 
-	if (fixed) {
-		ret = io_uring_register_buffers(ring, vecs, BUFFERS);
-		if (ret) {
-			fprintf(stderr, "buffer reg failed: %d\n", ret);
-			goto err;
-		}
-	}
 	if (sqthread) {
 		ret = io_uring_register_files(ring, &fd, 1);
 		if (ret) {
-- 
2.32.0

