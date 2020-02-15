Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B7B1600C8
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 23:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgBOWC2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 17:02:28 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34164 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727799AbgBOWC1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 17:02:27 -0500
Received: by mail-wm1-f68.google.com with SMTP id s144so4565092wme.1;
        Sat, 15 Feb 2020 14:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZtyBEtRM46yR9gJsWJ+ymmdAshH7nDc1v1/d7ItMGoA=;
        b=BT7OC1QmnxOvnIDo+iCTM2Oi6RPFB5czAj7fFgWiIJqrg/+P+/eSKRTbiEly4xntZp
         QWJq788/kTkE86HhbpdIp+WOs5QWwqxA33wcYzwyv4YpUMpbvNshEcrYEsftEkb834jO
         kUlX89gxRUc0iEBDHbLiTT9CieUkvO3TNfhbq2BUSFrTikhL7CC1+5BzpjQnw5mCZJOS
         fKpTezIxvteT1X6/l32HN8ZDabyEhQ5kyyHnvE9wKQGoLbI66OEmmYhtCA4tRAkcEbCw
         nt2cIvyOq7egbAmoqWq3zTs2XYbvXLGeMdubteb/2uJim/kvGO6LfAM51UnYBwosArP3
         53rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZtyBEtRM46yR9gJsWJ+ymmdAshH7nDc1v1/d7ItMGoA=;
        b=Ur9DJWSbMWN8vcKZWFvBjNkldcwfBiLS+KXaiO+XxXPkj9FHGrCnmggC5C7wtV3aXC
         X9ST7rwD19fl3J9lmCFNwrfgL2JaJMVLSMtU0AZtV61ZSS5VNV11HZFu6rcntTJ8c7Iz
         0Pgb4iIaSnU4NdH4TSFfhioplzDmsmOtu0msQaMBpvK7Z40aVIrO4KVkm9xTQDKiwLBJ
         i31iaxilXmuE3wOMgv39FoaF3ilITSB/K+qBMrLCiPb7f2upALK6DTHRIvHi2dHikxqN
         z/2D/vv7uYBStD0QhBd8xIhb+SJu7iOasHMw526p0RsB4LY2CHPWqsYdPPVIKemi5lyQ
         AflQ==
X-Gm-Message-State: APjAAAUa1BduXkq92kg0gulAa5/KWXD/6uLcAoLBVU5OfV1Zo0nS3Pk0
        eW0Vwlc1Xan323SIGiWI1Qvucl5i
X-Google-Smtp-Source: APXvYqwMYj0sLrZL420zldAMVbjYPIt90X7shF4D1dqMK4E0hvG9yUi8e6b1pOrx9jlga2DbFxrKcQ==
X-Received: by 2002:a1c:1b42:: with SMTP id b63mr12576943wmb.16.1581804145462;
        Sat, 15 Feb 2020 14:02:25 -0800 (PST)
Received: from localhost.localdomain ([109.126.146.5])
        by smtp.gmail.com with ESMTPSA id b18sm13377021wru.50.2020.02.15.14.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 14:02:25 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] io_uring: don't call work.func from sync ctx
Date:   Sun, 16 Feb 2020 01:01:20 +0300
Message-Id: <e84c16af73611955fc1ba2ab28a400b1464f9af8.1581785642.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581785642.git.asml.silence@gmail.com>
References: <cover.1581785642.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Many operations define custom work.func before getting into an io-wq.
There are several points against:
- it calls io_wq_assign_next() from outside io-wq, that may be confusing
- sync context would go unnecessary through io_req_cancelled()
- prototypes are quite different, so work!=old_work looks strange
- makes async/sync responsibilities fuzzy
- adds extra overhead

Don't call generic path and io-wq handlers from each other, but use
helpers instead

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 76 +++++++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1dc83d887183..0dd2f10d8ad8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2468,23 +2468,28 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 	}
 }
 
-static void io_fsync_finish(struct io_wq_work **workptr)
+static void __io_fsync(struct io_kiocb *req, struct io_kiocb **nxt)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
 	loff_t end = req->sync.off + req->sync.len;
-	struct io_kiocb *nxt = NULL;
 	int ret;
 
-	if (io_req_cancelled(req))
-		return;
-
 	ret = vfs_fsync_range(req->file, req->sync.off,
 				end > 0 ? end : LLONG_MAX,
 				req->sync.flags & IORING_FSYNC_DATASYNC);
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, &nxt);
+	io_put_req_find_next(req, nxt);
+}
+
+static void io_fsync_finish(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *nxt = NULL;
+
+	if (io_req_cancelled(req))
+		return;
+	__io_fsync(req, &nxt);
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -2492,26 +2497,18 @@ static void io_fsync_finish(struct io_wq_work **workptr)
 static int io_fsync(struct io_kiocb *req, struct io_kiocb **nxt,
 		    bool force_nonblock)
 {
-	struct io_wq_work *work, *old_work;
-
 	/* fsync always requires a blocking context */
 	if (force_nonblock) {
 		io_put_req(req);
 		req->work.func = io_fsync_finish;
 		return -EAGAIN;
 	}
-
-	work = old_work = &req->work;
-	io_fsync_finish(&work);
-	if (work && work != old_work)
-		*nxt = container_of(work, struct io_kiocb, work);
+	__io_fsync(req, nxt);
 	return 0;
 }
 
-static void io_fallocate_finish(struct io_wq_work **workptr)
+static void __io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 	int ret;
 
 	if (io_req_cancelled(req))
@@ -2522,7 +2519,15 @@ static void io_fallocate_finish(struct io_wq_work **workptr)
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, &nxt);
+	io_put_req_find_next(req, nxt);
+}
+
+static void io_fallocate_finish(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *nxt = NULL;
+
+	__io_fallocate(req, &nxt);
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -2542,8 +2547,6 @@ static int io_fallocate_prep(struct io_kiocb *req,
 static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
 			bool force_nonblock)
 {
-	struct io_wq_work *work, *old_work;
-
 	/* fallocate always requiring blocking context */
 	if (force_nonblock) {
 		io_put_req(req);
@@ -2551,11 +2554,7 @@ static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
 		return -EAGAIN;
 	}
 
-	work = old_work = &req->work;
-	io_fallocate_finish(&work);
-	if (work && work != old_work)
-		*nxt = container_of(work, struct io_kiocb, work);
-
+	__io_fallocate(req, nxt);
 	return 0;
 }
 
@@ -2959,21 +2958,27 @@ static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static void io_sync_file_range_finish(struct io_wq_work **workptr)
+static void __io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 	int ret;
 
-	if (io_req_cancelled(req))
-		return;
-
 	ret = sync_file_range(req->file, req->sync.off, req->sync.len,
 				req->sync.flags);
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, &nxt);
+	io_put_req_find_next(req, nxt);
+}
+
+
+static void io_sync_file_range_finish(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *nxt = NULL;
+
+	if (io_req_cancelled(req))
+		return;
+	__io_sync_file_range(req, &nxt);
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -2981,8 +2986,6 @@ static void io_sync_file_range_finish(struct io_wq_work **workptr)
 static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 			      bool force_nonblock)
 {
-	struct io_wq_work *work, *old_work;
-
 	/* sync_file_range always requires a blocking context */
 	if (force_nonblock) {
 		io_put_req(req);
@@ -2990,10 +2993,7 @@ static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 		return -EAGAIN;
 	}
 
-	work = old_work = &req->work;
-	io_sync_file_range_finish(&work);
-	if (work && work != old_work)
-		*nxt = container_of(work, struct io_kiocb, work);
+	__io_sync_file_range(req, nxt);
 	return 0;
 }
 
-- 
2.24.0

