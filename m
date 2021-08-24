Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F6F3F5D36
	for <lists+io-uring@lfdr.de>; Tue, 24 Aug 2021 13:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbhHXLkw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 07:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbhHXLkv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 07:40:51 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADED8C061764
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 04:40:07 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id f10so12593737wml.2
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 04:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=I0LORU5MKH2a2+YFi2P2lYOESR9wD6I79Xyn5MXB2tQ=;
        b=Ho43iXtLW5bvreL0XSImiV8s2y1W7HFpZno0iFA/1Gwp4yUyuxESh9qPaT/TvkJNpF
         U5BGUlH4/Xu52ToTAcVqZ9YtaZeQ7zrLdPX9WGCjDcHni8CtAcJNb+fot2IFwupK8thD
         TN7ld/UOLCV/7s+1z0TvD/lVUI/t0A5vN8aLt3VbtjyVNXK0vFfdNg3dMkOx351wVvZN
         9j2SCzx+cEuIiM2IlRaUvLKMBwcOGRxFPN01nDhvbXtMlS8nbq7BQPCCKXHIFoBJsyBv
         CZWhuPLPzPsZG5W45M0Us36Epchb+QcDO1Ke9GgVg86t6R5DKXwIc1aT2F2GdQ4EQMzk
         9tAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I0LORU5MKH2a2+YFi2P2lYOESR9wD6I79Xyn5MXB2tQ=;
        b=FsVXumlWkrWIPlSu97+74qHzlWV5qrK7+3CDaPMpP2JakSa/zTfZlpaKhfxjsGICrn
         BhysRnQSLvETEhaTOKvHgDIBISsD9AX1R7iRN7ykBXcWvxShFIFcs4DRWv2p5UryX6Vr
         RcOhfPZLWj2KVHuB/3F4SwRqntGNGzhEJFLN9d33JoF+aw8K03ODR4a8WpAjAvZo0Squ
         9MQkDExMbwEn9AKiU3AZyntEGNPJnNmKgGwN8vVD3ymHah+uug4FJmXBcBJw76z/NbW6
         OF+lkl1CNekTNSga7JQCzPzGANrkFMixYQYwOPpKQWsMF5wogNNfKlovCrD78MNwGRQb
         xjfA==
X-Gm-Message-State: AOAM533mkkihRAAlEyuLfdDGdrBzYw1OvO53szXEkNyhE6Hjo8BlcEzN
        OFoJIMI/7MBKF7jOksllEVsrd/KzYAY=
X-Google-Smtp-Source: ABdhPJxU+H4U4beRu4Ix8dUaJ40IXywa4upTrPiGQp5Q/h+bk+dJvgWxbBekn2tU7OuMPYCjMGvEHw==
X-Received: by 2002:a1c:a903:: with SMTP id s3mr3582829wme.171.1629805206285;
        Tue, 24 Aug 2021 04:40:06 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.113])
        by smtp.gmail.com with ESMTPSA id m4sm2126869wml.28.2021.08.24.04.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 04:40:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/2] tests: non-privileged defer test
Date:   Tue, 24 Aug 2021 12:39:27 +0100
Message-Id: <726e3cd30a1e5689e6b87c252ddd2770aa431b41.1629805109.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629805109.git.asml.silence@gmail.com>
References: <cover.1629805109.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Reduce ring sizes because non-privileged users can't create them, clean
up dead code, and SQPOLL testing to the end, so it doesn't stop all
other tests if not supported.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/defer.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/test/defer.c b/test/defer.c
index 885cf5c..825b69f 100644
--- a/test/defer.c
+++ b/test/defer.c
@@ -11,6 +11,8 @@
 #include "helpers.h"
 #include "liburing.h"
 
+#define RING_SIZE 128
+
 struct test_context {
 	struct io_uring *ring;
 	struct io_uring_sqe **sqes;
@@ -243,30 +245,24 @@ int main(int argc, char *argv[])
 {
 	struct io_uring ring, poll_ring, sqthread_ring;
 	struct io_uring_params p;
-	int ret, no_sqthread = 0;
+	int ret;
 
 	if (argc > 1)
 		return 0;
 
 	memset(&p, 0, sizeof(p));
-	ret = io_uring_queue_init_params(1000, &ring, &p);
+	ret = io_uring_queue_init_params(RING_SIZE, &ring, &p);
 	if (ret) {
-		printf("ring setup failed\n");
+		printf("ring setup failed %i\n", ret);
 		return 1;
 	}
 
-	ret = io_uring_queue_init(1000, &poll_ring, IORING_SETUP_IOPOLL);
+	ret = io_uring_queue_init(RING_SIZE, &poll_ring, IORING_SETUP_IOPOLL);
 	if (ret) {
 		printf("poll_ring setup failed\n");
 		return 1;
 	}
 
-	ret = t_create_ring(1000, &sqthread_ring,
-				IORING_SETUP_SQPOLL | IORING_SETUP_IOPOLL);
-	if (ret == T_SETUP_SKIP)
-		return 0;
-	else if (ret < 0)
-		return 1;
 
 	ret = test_cancelled_userdata(&poll_ring);
 	if (ret) {
@@ -274,16 +270,6 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
-	if (no_sqthread) {
-		printf("test_thread_link_cancel: skipped, not root\n");
-	} else {
-		ret = test_thread_link_cancel(&sqthread_ring);
-		if (ret) {
-			printf("test_thread_link_cancel failed\n");
-			return ret;
-		}
-	}
-
 	if (!(p.features & IORING_FEAT_NODROP)) {
 		ret = test_overflow_hung(&ring);
 		if (ret) {
@@ -304,5 +290,18 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	ret = t_create_ring(RING_SIZE, &sqthread_ring,
+				IORING_SETUP_SQPOLL | IORING_SETUP_IOPOLL);
+	if (ret == T_SETUP_SKIP)
+		return 0;
+	else if (ret < 0)
+		return 1;
+
+	ret = test_thread_link_cancel(&sqthread_ring);
+	if (ret) {
+		printf("test_thread_link_cancel failed\n");
+		return ret;
+	}
+
 	return 0;
 }
-- 
2.32.0

