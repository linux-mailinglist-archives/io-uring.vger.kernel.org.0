Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9C320436D
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 00:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgFVWSX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Jun 2020 18:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731007AbgFVWSV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Jun 2020 18:18:21 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764B8C061795;
        Mon, 22 Jun 2020 15:18:21 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id cy7so8381520edb.5;
        Mon, 22 Jun 2020 15:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hj/ZWwebgZ0sMqnXUxboE0Dr7x3sLqM/VkXD+bUE5oo=;
        b=bWmcpKX3Hog+1IIxJGtaD7Rw5hEMyL0nVDlnzVATPE6QVHwa6U+819XWYVo1m1R3FI
         8xxKVI6btaFakUM/rvKLG1+GQJ6uwD7OJY/Iu+TdGqK1/oeM9Gp8C5Iok+S2vEc0jj5j
         bHgWQabvK/4nrbQgz/XGXlaAIRi8BzIQ5Dg0ewBdACrRq2EumAiXn29R1vzNHj5Hk5PC
         XvRjr6L3yCKPiBQPj7f0V7cmghfY70tFva53vdcSh6S8McJyPj1syTpapUhG8gDcRynb
         Xd5CMzQobzoCFj6rlVTk3H50iAwC87Reg7tBoeKhUJeDJi6ujdB96NV7FxDcUd6Fx2yE
         /2Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hj/ZWwebgZ0sMqnXUxboE0Dr7x3sLqM/VkXD+bUE5oo=;
        b=j7W6LmUwyIpurIqCaLx6SotTHNZYpr6e4wUNSRTBmjeNh2gVdCxdHqtf1+ZlB9QDXf
         LvwPmHq1hpM848pJQ+8WN4rMrQwrlr4ggsNkm+qfZb7uWdvSD330JMian+mOOvIwuq7/
         xiHFB0jksXIBcTmmq+vcLvSw+Gcfglpqk57YY29ar755mEDF2eUHHi6eL57CO4Ybm85h
         CGEj9WsWgYfnkgFdNvj2GA6uY/QcuXKraz/nG89dL/Dd9lcWvlmjgfcYTtwaWOUIlSS4
         YPHLAHqAHssgsCBFKwFaR4SIROG6k08EiAmWGwxY+pITyabMuQoM2utTxcOdf3RpldPX
         /Uvg==
X-Gm-Message-State: AOAM530zCfJQ20f0GP5bACdovWgxOFrJuLs+4hm+fc/bFbA3zTAoLkeg
        DB0GxoEduJPWjFZCrSIO+7E=
X-Google-Smtp-Source: ABdhPJxXbdW2IXu5QI8TrMaHze3PJWIu6xI7EgfEWAazsW6c7moopkJfmerQyEHxQXnCkK9QlYc3qQ==
X-Received: by 2002:aa7:c68b:: with SMTP id n11mr19217260edq.278.1592864300134;
        Mon, 22 Jun 2020 15:18:20 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id dm1sm13314421ejc.99.2020.06.22.15.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 15:18:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] io-wq: return next work from ->do_work() directly
Date:   Tue, 23 Jun 2020 01:16:35 +0300
Message-Id: <915321064eaf58b3b6fc2c6fed015879c769f3a1.1592863245.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1592863245.git.asml.silence@gmail.com>
References: <cover.1592863245.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's easier to return next work from ->do_work() than
having an in-out argument. Looks nicer and easier to compile.
Also, merge io_wq_assign_next() into its only user.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    |  8 +++-----
 fs/io-wq.h    |  2 +-
 fs/io_uring.c | 53 ++++++++++++++++++++-------------------------------
 3 files changed, 25 insertions(+), 38 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 47c5f3aeb460..72f759e1d6eb 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -523,9 +523,8 @@ static void io_worker_handle_work(struct io_worker *worker)
 				work->flags |= IO_WQ_WORK_CANCEL;
 
 			hash = io_get_work_hash(work);
-			linked = old_work = work;
-			wq->do_work(&linked);
-			linked = (old_work == linked) ? NULL : linked;
+			old_work = work;
+			linked = wq->do_work(work);
 
 			work = next_hashed;
 			if (!work && linked && !io_wq_is_hashed(linked)) {
@@ -781,8 +780,7 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 		struct io_wq_work *old_work = work;
 
 		work->flags |= IO_WQ_WORK_CANCEL;
-		wq->do_work(&work);
-		work = (work == old_work) ? NULL : work;
+		work = wq->do_work(work);
 		wq->free_work(old_work);
 	} while (work);
 }
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 04239dfb12b0..114f12ec2d65 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -101,7 +101,7 @@ static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
 }
 
 typedef void (free_work_fn)(struct io_wq_work *);
-typedef void (io_wq_work_fn)(struct io_wq_work **);
+typedef struct io_wq_work *(io_wq_work_fn)(struct io_wq_work *);
 
 struct io_wq_data {
 	struct user_struct *user;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 595d2bbb31b1..5282711eeeaf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -886,7 +886,6 @@ enum io_mem_account {
 
 static void io_complete_rw_common(struct kiocb *kiocb, long res);
 static bool io_rw_reissue(struct io_kiocb *req, long res);
-static void io_wq_submit_work(struct io_wq_work **workptr);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
 static void __io_double_put_req(struct io_kiocb *req);
@@ -1624,20 +1623,6 @@ static void io_free_req(struct io_kiocb *req)
 		io_queue_async_work(nxt);
 }
 
-static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
-{
-	struct io_kiocb *link;
-	const struct io_op_def *def = &io_op_defs[nxt->opcode];
-
-	if ((nxt->flags & REQ_F_ISREG) && def->hash_reg_file)
-		io_wq_hash_work(&nxt->work, file_inode(nxt->file));
-
-	*workptr = &nxt->work;
-	link = io_prep_linked_timeout(nxt);
-	if (link)
-		nxt->flags |= REQ_F_QUEUE_TIMEOUT;
-}
-
 /*
  * Drop reference to request, return next in chain (if there is one) if this
  * was the last reference to this request.
@@ -1657,24 +1642,29 @@ static void io_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
-static void io_steal_work(struct io_kiocb *req,
-			  struct io_wq_work **workptr)
+static struct io_wq_work *io_steal_work(struct io_kiocb *req)
 {
+	struct io_kiocb *link, *nxt = NULL;
+
 	/*
-	 * It's in an io-wq worker, so there always should be at least
-	 * one reference, which will be dropped in io_put_work() just
-	 * after the current handler returns.
-	 *
-	 * It also means, that if the counter dropped to 1, then there is
-	 * no asynchronous users left, so it's safe to steal the next work.
+	 * A ref is owned by io-wq in which context we're. So, if that's the
+	 * last one, it's safe to steal next work. False negatives are Ok,
+	 * it just will be re-punted async in io_put_work()
 	 */
-	if (refcount_read(&req->refs) == 1) {
-		struct io_kiocb *nxt = NULL;
+	if (refcount_read(&req->refs) != 1)
+		return NULL;
 
-		io_req_find_next(req, &nxt);
-		if (nxt)
-			io_wq_assign_next(workptr, nxt);
-	}
+	io_req_find_next(req, &nxt);
+	if (!nxt)
+		return NULL;
+
+	if ((nxt->flags & REQ_F_ISREG) && io_op_defs[nxt->opcode].hash_reg_file)
+		io_wq_hash_work(&nxt->work, file_inode(nxt->file));
+
+	link = io_prep_linked_timeout(nxt);
+	if (link)
+		nxt->flags |= REQ_F_QUEUE_TIMEOUT;
+	return &nxt->work;
 }
 
 /*
@@ -5626,9 +5616,8 @@ static void io_arm_async_linked_timeout(struct io_kiocb *req)
 	io_queue_linked_timeout(link);
 }
 
-static void io_wq_submit_work(struct io_wq_work **workptr)
+static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
 {
-	struct io_wq_work *work = *workptr;
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	int ret = 0;
 
@@ -5660,7 +5649,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 		io_put_req(req);
 	}
 
-	io_steal_work(req, workptr);
+	return io_steal_work(req);
 }
 
 static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
-- 
2.24.0

