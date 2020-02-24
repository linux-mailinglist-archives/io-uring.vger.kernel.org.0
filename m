Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC2316A007
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 09:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgBXIbU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 03:31:20 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46907 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgBXIbU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 03:31:20 -0500
Received: by mail-wr1-f68.google.com with SMTP id g4so2907185wro.13
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 00:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=kzx/3yJB9NBkgwCn3RpqT+8ATl78a2V/jEcEyQz4lMo=;
        b=aHvsBQ6W6/cjtiGA9WsjjgfPrpx3aS7SI7qLp9EtD5YprxZrR+yJCHXtPYZPVjmu0T
         vf6xqkQbSsiefYLDY14fZEoXXSYjTRhAZNeFZmMA9/0jkd2uQvHQ5bBAsPuc4BFBmYJT
         6+DET2Q2V1bqGsbjH+nT3KPa4paOjPdIzXer5NFmARJbGMfuMjDJQSCA6wZyrNoA/nwu
         O7joJrfyZakNwllmeqhpGq56pebeoVtgCllACUYP9TaaMF8CAjqGp4NW9sXMc27mdvkN
         bsz5V0fi8qioVeeF546xzD+EnGnKemM/fAaCj13lXotx1fGDJVV0hQoD2hU9/7XIWr4L
         O6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kzx/3yJB9NBkgwCn3RpqT+8ATl78a2V/jEcEyQz4lMo=;
        b=N08zC+yhjcJGpCDknCi9yzSv6kY97B1NflU2/XNOsKFFvkSVu7BLKpcOWs1gmhT3Cp
         N4AieOBILZDKU3oYbXmtbZBaZujfuU/OghbcVDTubatV3oBoQ9cSllJThytvt8F0/N7P
         YsZ5C78zHB4rKh+CRrFV+KbC4OjXOns/S5UfrmHbLkcIneI2mrO9eR6ayFZAZAsobXGU
         EoQZV4Cazb32xrUujxx0qKQ7tuupr7zLMGntPFsIr5JQ0p5FNsTBPvrK49ev6G7VXRQA
         kmvQYnLinDImfslPH3Zmya5kMc2QlezWCKDo87jWhIawjVmCy4CtvSqnEiQf6SN4vNaf
         ZuWQ==
X-Gm-Message-State: APjAAAUVvdwkx34BPiIpmBaTWTJrw/50+SF2yPe67ExKsUs7wPxg4EE4
        sZ3ND8SUQxgS9pMKLlofWsc=
X-Google-Smtp-Source: APXvYqygth8ci/GVMsUxL1rj8jt3/ywa4bT3r+el9PCBrIFC3s5TiLU6PLTOiKvUNV77NObghuRUPw==
X-Received: by 2002:adf:b198:: with SMTP id q24mr67309883wra.188.1582533077455;
        Mon, 24 Feb 2020 00:31:17 -0800 (PST)
Received: from localhost.localdomain ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id a16sm17946265wrx.87.2020.02.24.00.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 00:31:17 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 1/3] io_uring: don't call work.func from sync ctx
Date:   Mon, 24 Feb 2020 11:30:16 +0300
Message-Id: <e3ad1962f3d9d12e6ce30407c5858a2b9a809c1b.1582530396.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582530396.git.asml.silence@gmail.com>
References: <cover.1582530396.git.asml.silence@gmail.com>
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
index 7d0be264527d..819661f49023 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2462,23 +2462,28 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
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
@@ -2486,26 +2491,18 @@ static void io_fsync_finish(struct io_wq_work **workptr)
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
@@ -2516,7 +2513,15 @@ static void io_fallocate_finish(struct io_wq_work **workptr)
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
@@ -2536,8 +2541,6 @@ static int io_fallocate_prep(struct io_kiocb *req,
 static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
 			bool force_nonblock)
 {
-	struct io_wq_work *work, *old_work;
-
 	/* fallocate always requiring blocking context */
 	if (force_nonblock) {
 		io_put_req(req);
@@ -2545,11 +2548,7 @@ static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
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
 
@@ -2953,21 +2952,27 @@ static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -2975,8 +2980,6 @@ static void io_sync_file_range_finish(struct io_wq_work **workptr)
 static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 			      bool force_nonblock)
 {
-	struct io_wq_work *work, *old_work;
-
 	/* sync_file_range always requires a blocking context */
 	if (force_nonblock) {
 		io_put_req(req);
@@ -2984,10 +2987,7 @@ static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
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

