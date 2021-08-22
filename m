Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970353F3F34
	for <lists+io-uring@lfdr.de>; Sun, 22 Aug 2021 14:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhHVMJS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Aug 2021 08:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhHVMJR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Aug 2021 08:09:17 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA83C061575
        for <io-uring@vger.kernel.org>; Sun, 22 Aug 2021 05:08:36 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id f13-20020a1c6a0d000000b002e6fd0b0b3fso10470886wmc.3
        for <io-uring@vger.kernel.org>; Sun, 22 Aug 2021 05:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hwo5kbdBKkMNDAO5u0K8nkJo3oZl/m6AP7C291dp50A=;
        b=bO1r2OmZUqYtoTDlVHiYZSu305A5TyIdm0qA+MuBKpskLWqZ/PiW94TiEN8l8TERUw
         5nmL/9t1mZZqgTdDxLzHxNREsTpSBZcLzKJgymfitNHUSibS9aae8TGMmEMPJxBtwWFy
         jzinR5qHprsLZBaF2x/asjbOlz0L+wZkRFkW6DLF2QkMe+bZauUU8fWvdQXE2BaEyUOA
         mjaxAFgntsBVk9VsL9odEBJmCe6xQtjO97mwHO5fmzB650Zio0E2JwdfqS6BL+ytG3AV
         jNOZjgYd4KUCthSLHikNM7DBNQplt13nfELD3tEJ6MbR259J5164eidUHBu88+JF+TZf
         usEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hwo5kbdBKkMNDAO5u0K8nkJo3oZl/m6AP7C291dp50A=;
        b=WpTjLQaZDyRgtjQ5y9YyCIdtIHFx8iGrUKSdFfWUBu/Zg5WspNiyYxLOwQzzSTdFRi
         5t39rbtONqpKwAbH6yYdV6/8PIOjDgpCRXIsgUYWmM6O/HX4FNd2bVLiev7bIEXJ1FKg
         lShDAkgwSpN4uc8eAHJUPp+dUDy8xIo8rJco7WrtyaSK2ZpexC42I2wzYKM9ITNsxWIu
         oHzOTysXWjyicnjMaKycjYXsHWfx7TA0Zy0uZgA4qu1Zq0p9NNqUNRxHZmIw3uTG5NFG
         kYZhA4RH+AFx9Eq4LH+WWjNUJMnsj4jCp7yf56m6MxQhL4SzmWsSt6U2Ke0DOn8bZ2k8
         JOKA==
X-Gm-Message-State: AOAM532Asd8KEo0wd/mFvP8P4UN4bYqRTTdFsJRKP9rGvoZk9vkf7v+D
        uIatVbbi/j6Jzx32CJR8vtewz4S64+8=
X-Google-Smtp-Source: ABdhPJzYOWCjQssRSqnQRo10QN94B2U3PkFzePV4WvhvwaJsKAuJyjFRYT2JyDBh4N4qT6IibydIeQ==
X-Received: by 2002:a1c:6a04:: with SMTP id f4mr11952045wmc.54.1629634115228;
        Sun, 22 Aug 2021 05:08:35 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id y11sm14189988wru.0.2021.08.22.05.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 05:08:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/1] tests: migrate rw tests to t_create_ring()
Date:   Sun, 22 Aug 2021 13:07:58 +0100
Message-Id: <ecb8603a6ffc2e296cf9ed7e6c0f5913c60e6032.1629633967.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use t_create_ring() in read-write.c and iopoll.c, the function will do
all the privilege checks.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/iopoll.c     | 23 ++++++-----------------
 test/read-write.c | 21 +++++++--------------
 2 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/test/iopoll.c b/test/iopoll.c
index b450618..5273279 100644
--- a/test/iopoll.c
+++ b/test/iopoll.c
@@ -271,31 +271,20 @@ static int test_io(const char *file, int write, int sqthread, int fixed,
 		   int buf_select)
 {
 	struct io_uring ring;
-	int ret, ring_flags;
+	int ret, ring_flags = IORING_SETUP_IOPOLL;
 
 	if (no_iopoll)
 		return 0;
 
-	ring_flags = IORING_SETUP_IOPOLL;
-	if (sqthread) {
-		static int warned;
-
-		if (geteuid()) {
-			if (!warned)
-				fprintf(stdout, "SQPOLL requires root, skipping\n");
-			warned = 1;
-			return 0;
-		}
-	}
-
-	ret = io_uring_queue_init(64, &ring, ring_flags);
-	if (ret) {
+	ret = t_create_ring(64, &ring, ring_flags);
+	if (ret == T_SETUP_SKIP)
+		goto done;
+	if (ret != T_SETUP_OK) {
 		fprintf(stderr, "ring create failed: %d\n", ret);
 		return 1;
 	}
-
 	ret = __test_io(file, &ring, write, sqthread, fixed, buf_select);
-
+done:
 	io_uring_queue_exit(&ring);
 	return ret;
 }
diff --git a/test/read-write.c b/test/read-write.c
index b0a2bde..93f6803 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -235,23 +235,15 @@ static int test_io(const char *file, int write, int buffered, int sqthread,
 		   int fixed, int nonvec, int exp_len)
 {
 	struct io_uring ring;
-	int ret, ring_flags;
+	int ret, ring_flags = 0;
 
-	if (sqthread) {
-		if (geteuid()) {
-			if (!warned) {
-				fprintf(stderr, "SQPOLL requires root, skipping\n");
-				warned = 1;
-			}
-			return 0;
-		}
+	if (sqthread)
 		ring_flags = IORING_SETUP_SQPOLL;
-	} else {
-		ring_flags = 0;
-	}
 
-	ret = io_uring_queue_init(64, &ring, ring_flags);
-	if (ret) {
+	ret = t_create_ring(64, &ring, ring_flags);
+	if (ret == T_SETUP_SKIP)
+		goto done;
+	if (ret != T_SETUP_OK) {
 		fprintf(stderr, "ring create failed: %d\n", ret);
 		return 1;
 	}
@@ -259,6 +251,7 @@ static int test_io(const char *file, int write, int buffered, int sqthread,
 	ret = __test_io(file, &ring, write, buffered, sqthread, fixed, nonvec,
 			0, 0, exp_len);
 
+done:
 	io_uring_queue_exit(&ring);
 	return ret;
 }
-- 
2.32.0

