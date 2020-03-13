Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14D90185139
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2020 22:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgCMVcS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Mar 2020 17:32:18 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:32897 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbgCMVcR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Mar 2020 17:32:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id r7so8718009wmg.0;
        Fri, 13 Mar 2020 14:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=U/1dwfXRZxOZmfAbuLaJO9UvqCG6+pO4hGbZ7rXWG9I=;
        b=skh+ARKEM8clMqPduz8cGUxZEY+RNrwalleMgB8L+QmbOV0YklBPo8MULj9SBlRC0x
         ejxonlZmwcXtN9duEXQKxObWCKpNhUd1L4aqeLgnXFzSs1FVOQFffg4nneH3Utb60SfD
         5nIcErX3wGtB6V7SjtQDCqoJ0Om7aAoJysfzhc5bdDn7CrSR3pODv9igGj8+RojqKd91
         UDpB9DLboN7SjT5KvHZnzidj1lqhVvFuBIrM1nbYrB7RgMttCHhYnnQPt36AVmwgVPkM
         tNPYr7JPWcvtQcKqHmiGUkc4suws0K/3oCO5hYPCMV6L//DjhcSa+m7zdPauLJOsDoZy
         a8cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U/1dwfXRZxOZmfAbuLaJO9UvqCG6+pO4hGbZ7rXWG9I=;
        b=dO7zGPqyKUrGEf9ZWRt0RnRRuJQcYDmdR71j2CYMC1S6TMWQS6iQrsNXGe/+3lFTj1
         j7k765ELTQlTFwxjh+Ynoe79ihCLcuiSat4j08YREIB/wti4lyUB0ZgjZ0JtrUtxERS0
         qgt2jRjRbe8clteVseGrx1WmMRDpddVyNBi/eLv0rgNHlytrwbFmkG6E49XApFFYuSFN
         9pzmPFlxzepTX81lPqYu6WL/DmsPo609Sh4y8/fLAT9Wp/JzFMd+kFtCq7JG8dvZm6Xp
         i2N2pmaApVajtpKgD0wZazReCcNIZCqyPM6m3FN+0a/D1vF6Do8lIiwUM5Xv9fJ7IzeY
         v7Vw==
X-Gm-Message-State: ANhLgQ1OgUhJX6kctqqNtcOIUYFbtE4TPsKRm4C1eJPcxxQ8k8ASSH79
        zo9FaDdJXkTODhY/cwCGgUo=
X-Google-Smtp-Source: ADFU+vtAjn4TLXdDt9j8aG0WXDse7MRvR/tNuZ5pw3jQyMdeD05FiMKibc7sWcavJ8MPW+VN2hSmfg==
X-Received: by 2002:a1c:418b:: with SMTP id o133mr13113475wma.165.1584135133991;
        Fri, 13 Mar 2020 14:32:13 -0700 (PDT)
Received: from localhost.localdomain ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id v8sm78676011wrw.2.2020.03.13.14.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 14:32:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] io-wq: split hashing and enqueueing
Date:   Sat, 14 Mar 2020 00:31:04 +0300
Message-Id: <50dfb83df546f2bb72126bd99bde864909e4f0a2.1584130466.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1584130466.git.asml.silence@gmail.com>
References: <cover.1584130466.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's a preparation patch removing io_wq_enqueue_hashed(), which
now should be done by io_wq_hash_work() + io_wq_enqueue().

Also, set hash value for dependant works, and do it as late as possible,
because req->file can be unavailable before. This hash will be ignored
by io-wq.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    | 14 +++++---------
 fs/io-wq.h    |  7 ++++++-
 fs/io_uring.c | 24 ++++++++++--------------
 3 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 8afe5565f57a..e26ceef53cbd 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -385,7 +385,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe, unsigned *hash)
 		work = container_of(node, struct io_wq_work, list);
 
 		/* not hashed, can run anytime */
-		if (!(work->flags & IO_WQ_WORK_HASHED)) {
+		if (!io_wq_is_hashed(work)) {
 			wq_node_del(&wqe->work_list, node, prev);
 			return work;
 		}
@@ -795,19 +795,15 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 }
 
 /*
- * Enqueue work, hashed by some key. Work items that hash to the same value
- * will not be done in parallel. Used to limit concurrent writes, generally
- * hashed by inode.
+ * Work items that hash to the same value will not be done in parallel.
+ * Used to limit concurrent writes, generally hashed by inode.
  */
-void io_wq_enqueue_hashed(struct io_wq *wq, struct io_wq_work *work, void *val)
+void io_wq_hash_work(struct io_wq_work *work, void *val)
 {
-	struct io_wqe *wqe = wq->wqes[numa_node_id()];
-	unsigned bit;
-
+	unsigned int bit;
 
 	bit = hash_ptr(val, IO_WQ_HASH_ORDER);
 	work->flags |= (IO_WQ_WORK_HASHED | (bit << IO_WQ_HASH_SHIFT));
-	io_wqe_enqueue(wqe, work);
 }
 
 static bool io_wqe_worker_send_sig(struct io_worker *worker, void *data)
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 2117b9a4f161..298b21f4a4d2 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -94,7 +94,12 @@ bool io_wq_get(struct io_wq *wq, struct io_wq_data *data);
 void io_wq_destroy(struct io_wq *wq);
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
-void io_wq_enqueue_hashed(struct io_wq *wq, struct io_wq_work *work, void *val);
+void io_wq_hash_work(struct io_wq_work *work, void *val);
+
+static inline bool io_wq_is_hashed(struct io_wq_work *work)
+{
+	return work->flags & IO_WQ_WORK_HASHED;
+}
 
 void io_wq_cancel_all(struct io_wq *wq);
 enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9d43efbec960..f1b42690456a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1040,15 +1040,14 @@ static inline void io_req_work_drop_env(struct io_kiocb *req)
 	}
 }
 
-static inline bool io_prep_async_work(struct io_kiocb *req,
+static inline void io_prep_async_work(struct io_kiocb *req,
 				      struct io_kiocb **link)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
-	bool do_hashed = false;
 
 	if (req->flags & REQ_F_ISREG) {
 		if (def->hash_reg_file)
-			do_hashed = true;
+			io_wq_hash_work(&req->work, file_inode(req->file));
 	} else {
 		if (def->unbound_nonreg_file)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
@@ -1057,25 +1056,18 @@ static inline bool io_prep_async_work(struct io_kiocb *req,
 	io_req_work_grab_env(req, def);
 
 	*link = io_prep_linked_timeout(req);
-	return do_hashed;
 }
 
 static inline void io_queue_async_work(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *link;
-	bool do_hashed;
 
-	do_hashed = io_prep_async_work(req, &link);
+	io_prep_async_work(req, &link);
 
-	trace_io_uring_queue_async_work(ctx, do_hashed, req, &req->work,
-					req->flags);
-	if (!do_hashed) {
-		io_wq_enqueue(ctx->io_wq, &req->work);
-	} else {
-		io_wq_enqueue_hashed(ctx->io_wq, &req->work,
-					file_inode(req->file));
-	}
+	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(&req->work), req,
+					&req->work, req->flags);
+	io_wq_enqueue(ctx->io_wq, &req->work);
 
 	if (link)
 		io_queue_linked_timeout(link);
@@ -1582,6 +1574,10 @@ static void io_link_work_cb(struct io_wq_work **workptr)
 static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 {
 	struct io_kiocb *link;
+	const struct io_op_def *def = &io_op_defs[nxt->opcode];
+
+	if ((nxt->flags & REQ_F_ISREG) && def->hash_reg_file)
+		io_wq_hash_work(&nxt->work, file_inode(nxt->file));
 
 	*workptr = &nxt->work;
 	link = io_prep_linked_timeout(nxt);
-- 
2.24.0

