Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F243EC86F
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 11:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhHOJpB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 05:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236717AbhHOJpB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 05:45:01 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2370CC061764
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:44:31 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id f9-20020a05600c1549b029025b0f5d8c6cso12744212wmg.4
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UwUv3N1xKdDWmR4oeTkhFDrl1Lp88Sz7VVPCDWCurB4=;
        b=IAdSZxBVzRxD7fIGN1ez+VrJFBPES9EkMZZGtHBZ8yi5jKTCPQk0QrsCfSRqd2tYfZ
         Av+78CUPfFugZYa/QLd1oxlmhRYbV+SEtb3bfOaKwrVbPS7qAswTBWRUeBSa102gwjLA
         HHwGiiCQkTpAeWGU9aNKVauBV8RIMs6mojqaB8ErNvNNM24leRHyVsvhUTFQ9XOSXjeI
         3GWSJSSE56PuAT7Hsn8UnlyMnHHNj8Q9/YiQ0pztoarY+KuCe3g69531mCW2U+hI+4AO
         W9Q5Xz9BJ1zsRkFLDrxZrD3ARBwRzfNNsTCXAdVQtElCqvUi4JdFHleEnt+IrWMXSiBk
         1FIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UwUv3N1xKdDWmR4oeTkhFDrl1Lp88Sz7VVPCDWCurB4=;
        b=cNx91Y4K4LcYt7bqkZ1u2SJ/KVeM0o7Ef1isf0n+VX+WsnxCNIPey6zEeS5mCHsr/L
         Cn/uBnIgEcC7SZaoFAgZnRpeRKcBO9xH6zgGvm91cVHP4ZagWe8hBsMMzl3IENaSeOFE
         VUwebUYEss+k6jn4ksPvCYbS+vvTEah/KF6HdCVhsLDrgi7eMrrxP8dHyI11erseFxtO
         hSDXzuUPharHx4LPElq/CH0UHLQbk6UhjmtH4rnVCSGV89y2un3hDE/w295a8Jwx/jT7
         gkez+Eib9VnDBL7L5yUHvh2nFtzvkWdLyMpwUoGwTqP2OAR+7j54oyWXKvMdO4JjiaNc
         ffcA==
X-Gm-Message-State: AOAM530pmwvXkJg62k95O2VoRN7Vn9uO1MYH7tZX5iSyyBwJcGLVdJ9p
        w6vJ5Bo0q9ENlXNa2NCNn2k=
X-Google-Smtp-Source: ABdhPJyaeFyttQLv9X892kQIsijML3OmQ9KfdtkFKRizSJVsjuoil4usI1NjHcyjl3arijaF0/zEMA==
X-Received: by 2002:a05:600c:4e87:: with SMTP id f7mr9422699wmq.42.1629020669799;
        Sun, 15 Aug 2021 02:44:29 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id i21sm7784240wrb.62.2021.08.15.02.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 02:44:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 2/2] tests: fail early invalid linked setups
Date:   Sun, 15 Aug 2021 10:43:52 +0100
Message-Id: <d2576c13100bacc00467c9ccfaedca1e71117e97.1629020550.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629020550.git.asml.silence@gmail.com>
References: <cover.1629020550.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We're going to fail links with invalid timeout combinations early. E.g.
op1 -> link timeout -> link timeout

Update tests to handle it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/link-timeout.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/test/link-timeout.c b/test/link-timeout.c
index 8c3e203..c8c289c 100644
--- a/test/link-timeout.c
+++ b/test/link-timeout.c
@@ -63,7 +63,7 @@ static int test_fail_two_link_timeouts(struct io_uring *ring)
 	struct __kernel_timespec ts;
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
-	int ret, i;
+	int ret, i, nr_wait;
 
 	ts.tv_sec = 1;
 	ts.tv_nsec = 0;
@@ -114,12 +114,13 @@ static int test_fail_two_link_timeouts(struct io_uring *ring)
 	sqe->user_data = 4;
 
 	ret = io_uring_submit(ring);
-	if (ret != 4) {
+	if (ret < 3) {
 		printf("sqe submit failed: %d\n", ret);
 		goto err;
 	}
+	nr_wait = ret;
 
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < nr_wait; i++) {
 		ret = io_uring_wait_cqe(ring, &cqe);
 		if (ret < 0) {
 			printf("wait completion %d\n", ret);
@@ -981,14 +982,16 @@ static int test_timeout_link_chain5(struct io_uring *ring)
 		}
 		switch (cqe->user_data) {
 		case 1:
-			if (cqe->res) {
-				fprintf(stderr, "Timeout got %d, wanted -EINVAL\n",
+		case 2:
+			if (cqe->res && cqe->res != -ECANCELED) {
+				fprintf(stderr, "Request got %d, wanted -EINVAL "
+						"or -ECANCELED\n",
 						cqe->res);
 				goto err;
 			}
 			break;
-		case 2:
-			if (cqe->res != -ECANCELED) {
+		case 3:
+			if (cqe->res != -ECANCELED && cqe->res != -EINVAL) {
 				fprintf(stderr, "Link timeout got %d, wanted -ECANCELED\n", cqe->res);
 				goto err;
 			}
-- 
2.32.0

