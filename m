Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E28217827B
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 20:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbgCCSeY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 13:34:24 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40682 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729772AbgCCSeY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 13:34:24 -0500
Received: by mail-wr1-f68.google.com with SMTP id r17so5705968wrj.7
        for <io-uring@vger.kernel.org>; Tue, 03 Mar 2020 10:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+u4z0iJrqj8uDmX1h+hftX7tm26kHKBzY39JGDn7Oik=;
        b=Gf5brpw4thH/Sirx2yUsF0cgJIaSoTAZZhDJQqmFB4IMuAJyVrf2ig4IEtuS1INA+V
         VmG4WeCTjG4gdLmEpmQnW+FbZMrStRUIbFmyEeb16pa2O96FQPF6WEVY0cdtQoZBHVAY
         iBQry3m+uVGAYHeByzRrNhnqP0Ki9P1KdXJg0nZxIK0oSpAScJdxlupKV0wiOat6jOGL
         +2cntWAr1fA6CG/nvqb9awy83+zVhnmTebdZ19+vplS0lUzrtpDuTD7gbcrF7rSsxSMZ
         Sg0ezU2qmKCj16dVUZa+AwJ4OlbDKdRl09CyvSe36Rn2jZIifJd5uTbqQalVoeDood1Y
         BSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+u4z0iJrqj8uDmX1h+hftX7tm26kHKBzY39JGDn7Oik=;
        b=W18fwmSqflKis/pCEOlavhngRvWl5Ixg2fyPzYkcsPTc7rRS9hQ65y+hASfl+J1B9A
         3nxNtslf09Q45/4DdAWRwRXSLfBxsPREXBmpz3BRAtPzonSwTA1SwseTJOgqAhiM5pIY
         lQZtTcGVK75/2zopmz2VAuuXmFEOZNmu6YwaXYr8dHHm49s7Ny200A9KTLTtz7//3VL1
         EnGyZ7LyRBXiv0jd6u8oTdxJ1fG4FLa8To+UBJFO1CTmpSfc3hOQwYkRvVtxzEJkFGCW
         foLC+iIP72fNCWGjIfeAujEnas3/D/vT3JRk+woOYUxj/eraNdE6Jpp1/EnsQmStHZ2P
         0hqw==
X-Gm-Message-State: ANhLgQ1AZ1DXiiOL3U1Yv6wmgpOsjcWyOPu/vlgIQadnNlJDWgPZXVf8
        0SGajwfxFCDLFTUudWVY8vI=
X-Google-Smtp-Source: ADFU+vvStIYgs1SlqkXv/+s5oRBma7uwlQfgiCvEymhi7u55+Ppi6uhosTP52Wnwl9n9mRBVrZ4uXA==
X-Received: by 2002:adf:90ee:: with SMTP id i101mr6527500wri.417.1583260461123;
        Tue, 03 Mar 2020 10:34:21 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id f3sm4548191wrs.26.2020.03.03.10.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 10:34:20 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 3/3] io_uring: get next work with submission ref drop
Date:   Tue,  3 Mar 2020 21:33:13 +0300
Message-Id: <39af77a7e9adab698d338f95799d034fce44cc94.1583258348.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583258348.git.asml.silence@gmail.com>
References: <cover.1583258348.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If after dropping the submission reference req->refs == 1, the request
is done, because this one is for io_put_work() and will be dropped
synchronously shortly after. In this case it's safe to steal a next
work from the request.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 89 +++++++++++++++++++++++++++------------------------
 1 file changed, 48 insertions(+), 41 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index daf7c2095523..5c6169abcc61 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1518,6 +1518,27 @@ static void io_free_req(struct io_kiocb *req)
 		io_queue_async_work(nxt);
 }
 
+static void io_link_work_cb(struct io_wq_work **workptr)
+{
+	struct io_wq_work *work = *workptr;
+	struct io_kiocb *link = work->data;
+
+	io_queue_linked_timeout(link);
+	io_wq_submit_work(workptr);
+}
+
+static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
+{
+	struct io_kiocb *link;
+
+	*workptr = &nxt->work;
+	link = io_prep_linked_timeout(nxt);
+	if (link) {
+		nxt->work.func = io_link_work_cb;
+		nxt->work.data = link;
+	}
+}
+
 /*
  * Drop reference to request, return next in chain (if there is one) if this
  * was the last reference to this request.
@@ -1537,6 +1558,27 @@ static void io_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
+static void io_put_req_async_completion(struct io_kiocb *req,
+					struct io_wq_work **workptr)
+{
+	/*
+	 * It's in an io-wq worker, so there always should be at least
+	 * one reference, which will be dropped in io_put_work() just
+	 * after the current handler returns.
+	 *
+	 * It also means, that if the counter dropped to 1, then there is
+	 * no asynchronous users left, so it's safe to steal the next work.
+	 */
+	refcount_dec(&req->refs);
+	if (refcount_read(&req->refs) == 1) {
+		struct io_kiocb *nxt = NULL;
+
+		io_req_find_next(req, &nxt);
+		if (nxt)
+			io_wq_assign_next(workptr, nxt);
+	}
+}
+
 /*
  * Must only be used if we don't need to care about links, usually from
  * within the completion handling itself.
@@ -2543,27 +2585,6 @@ static bool io_req_cancelled(struct io_kiocb *req)
 	return false;
 }
 
-static void io_link_work_cb(struct io_wq_work **workptr)
-{
-	struct io_wq_work *work = *workptr;
-	struct io_kiocb *link = work->data;
-
-	io_queue_linked_timeout(link);
-	io_wq_submit_work(workptr);
-}
-
-static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
-{
-	struct io_kiocb *link;
-
-	*workptr = &nxt->work;
-	link = io_prep_linked_timeout(nxt);
-	if (link) {
-		nxt->work.func = io_link_work_cb;
-		nxt->work.data = link;
-	}
-}
-
 static void __io_fsync(struct io_kiocb *req)
 {
 	loff_t end = req->sync.off + req->sync.len;
@@ -2581,14 +2602,11 @@ static void __io_fsync(struct io_kiocb *req)
 static void io_fsync_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	if (io_req_cancelled(req))
 		return;
 	__io_fsync(req);
-	io_put_req(req); /* drop submission reference */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_completion(req, workptr);
 }
 
 static int io_fsync(struct io_kiocb *req, bool force_nonblock)
@@ -2617,14 +2635,11 @@ static void __io_fallocate(struct io_kiocb *req)
 static void io_fallocate_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	if (io_req_cancelled(req))
 		return;
 	__io_fallocate(req);
-	io_put_req(req); /* drop submission reference */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_completion(req, workptr);
 }
 
 static int io_fallocate_prep(struct io_kiocb *req,
@@ -2988,13 +3003,10 @@ static void __io_close_finish(struct io_kiocb *req)
 static void io_close_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	/* not cancellable, don't do io_req_cancelled() */
 	__io_close_finish(req);
-	io_put_req(req); /* drop submission reference */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_completion(req, workptr);
 }
 
 static int io_close(struct io_kiocb *req, bool force_nonblock)
@@ -3435,14 +3447,11 @@ static int __io_accept(struct io_kiocb *req, bool force_nonblock)
 static void io_accept_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	if (io_req_cancelled(req))
 		return;
 	__io_accept(req, false);
-	io_put_req(req); /* drop submission reference */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_completion(req, workptr);
 }
 #endif
 
@@ -4680,7 +4689,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 {
 	struct io_wq_work *work = *workptr;
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 	int ret = 0;
 
 	/* if NO_CANCEL is set, we must still run the work */
@@ -4709,9 +4717,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 		io_put_req(req);
 	}
 
-	io_put_req(req); /* drop submission reference */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_completion(req, workptr);
 }
 
 static int io_req_needs_file(struct io_kiocb *req, int fd)
@@ -6101,6 +6107,7 @@ static void io_put_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
+	/* Consider that io_put_req_async_completion() relies on this ref */
 	io_put_req(req);
 }
 
-- 
2.24.0

