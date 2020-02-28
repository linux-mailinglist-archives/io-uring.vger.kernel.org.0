Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8196917428C
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 23:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgB1WyN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 17:54:13 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:52504 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgB1WyN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 17:54:13 -0500
Received: by mail-wm1-f53.google.com with SMTP id p9so5096332wmc.2;
        Fri, 28 Feb 2020 14:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=o+c1ozMKBd7fJw7s+S2b88TQraFNCaeo2g5WnRsFIt0=;
        b=kKo9XsoP2XLjC7A0ZCPaxUTMeAoJ49adSNXJd3Yn/Hiz8w36jX31wfFlsweiFLrvmf
         AEr/RBqXjx8lxM7FZnCEHfOXXxIbVpO0BiuSo3ahbc9fb74H9+76zPI4nefIhudAUDK1
         SIOKMOcex+Noe7H1V+Rn+PQQyuUBxmpy/X8pEhuJTvLhb8ikMC0fGn1XDN5iuLm63M+Y
         Gfa7fp9ws8c27mex4Vt2nL1TQwaqQHWP21DwTOuXfKwezUYhzYnqpYOmnRUr0fyGe+0D
         hmcuTyku0eMV9Py9EnWH9CkhaK3EuDTi/tDuCfaq6hZ81ON1YERAuIXVKrsjEAJauPyt
         3Z2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o+c1ozMKBd7fJw7s+S2b88TQraFNCaeo2g5WnRsFIt0=;
        b=MhCErTlOobEfzkJ3Rh8t6WavEN3RgQez1AmAXnkeug+x/gryhAl8FvPeyxUodYxCw4
         8lClSLrdFhDwc26I+gMVj4ht5mihttugufAH0VZHbN46mcSlWb+6mC43FeVFWbsZOq4k
         GZz0zzKDMHGDBVlP0KuOgY/ejysE+TyNIJcf2tYu2UTLrbclD+Qi34I1+H5jUoqPhxGD
         p2/a4t2BRogmZTVACN602PDbdakK3TLzi8nFxnV8KPaqM/faPhHnI/ICHDNkJyLaDXsE
         R3uey7r30DuEldh7G0lITuxgBpD5Jds/E+oGpamwSyGDKexDBDctAud9AQkLSfCuBsnJ
         cZBg==
X-Gm-Message-State: APjAAAXehirMyr2wGqTSBT7DIg3M+LXKiOPN/BSeOlFn4Sq+F6qBr/U1
        v3bvR5WJuBWtFDAtmWDffBY=
X-Google-Smtp-Source: APXvYqx9OnWe36JLQOrE8Ra/ihnKv/hsJQDZqUSFYuQbxvhSQQIOvDNm9WIbLkw9UdPxCgoVTofGDg==
X-Received: by 2002:a05:600c:2056:: with SMTP id p22mr6475569wmg.136.1582930449912;
        Fri, 28 Feb 2020 14:54:09 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id f1sm14603773wro.85.2020.02.28.14.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 14:54:09 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] io_uring/io-wq: pass *work instead of **workptr
Date:   Sat, 29 Feb 2020 01:53:08 +0300
Message-Id: <9aab04f6344439255d969a89986fdc043957d431.1582929017.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582929017.git.asml.silence@gmail.com>
References: <cover.1582929017.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now work->func() never modifies passed workptr.
Remove extra indirection by passing struct work*
instead of a pointer to that.

Also, it leaves (work != old_work) dancing in io_worker_handle_work(),
as it'll be reused shortly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    | 11 +++++------
 fs/io-wq.h    |  2 +-
 fs/io_uring.c | 36 +++++++++++++++++-------------------
 3 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index a05c32df2046..a830eddaffbe 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -503,7 +503,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		}
 
 		old_work = work;
-		work->func(&work);
+		work->func(work);
 
 		spin_lock_irq(&worker->lock);
 		worker->cur_work = NULL;
@@ -756,7 +756,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	 */
 	if (unlikely(!io_wq_can_queue(wqe, acct, work))) {
 		work->flags |= IO_WQ_WORK_CANCEL;
-		work->func(&work);
+		work->func(work);
 		return;
 	}
 
@@ -896,7 +896,7 @@ static enum io_wq_cancel io_wqe_cancel_cb_work(struct io_wqe *wqe,
 
 	if (found) {
 		work->flags |= IO_WQ_WORK_CANCEL;
-		work->func(&work);
+		work->func(work);
 		return IO_WQ_CANCEL_OK;
 	}
 
@@ -972,7 +972,7 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
 
 	if (found) {
 		work->flags |= IO_WQ_WORK_CANCEL;
-		work->func(&work);
+		work->func(work);
 		return IO_WQ_CANCEL_OK;
 	}
 
@@ -1049,9 +1049,8 @@ struct io_wq_flush_data {
 	struct completion done;
 };
 
-static void io_wq_flush_func(struct io_wq_work **workptr)
+static void io_wq_flush_func(struct io_wq_work *work)
 {
-	struct io_wq_work *work = *workptr;
 	struct io_wq_flush_data *data;
 
 	data = container_of(work, struct io_wq_flush_data, work);
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 001194aef6ae..508615af4552 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -68,7 +68,7 @@ struct io_wq_work {
 		struct io_wq_work_node list;
 		void *data;
 	};
-	void (*func)(struct io_wq_work **);
+	void (*func)(struct io_wq_work *);
 	struct files_struct *files;
 	struct mm_struct *mm;
 	const struct cred *creds;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index c92bd6d8d630..c49ed2846f85 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -767,7 +767,7 @@ static const struct io_op_def io_op_defs[] = {
 	}
 };
 
-static void io_wq_submit_work(struct io_wq_work **workptr);
+static void io_wq_submit_work(struct io_wq_work *work);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
 static void __io_double_put_req(struct io_kiocb *req);
@@ -2548,9 +2548,9 @@ static void __io_fsync(struct io_kiocb *req)
 	io_put_req(req);
 }
 
-static void io_fsync_finish(struct io_wq_work **workptr)
+static void io_fsync_finish(struct io_wq_work *work)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
 	if (io_req_cancelled(req))
 		return;
@@ -2584,9 +2584,9 @@ static void __io_fallocate(struct io_kiocb *req)
 	io_put_req(req);
 }
 
-static void io_fallocate_finish(struct io_wq_work **workptr)
+static void io_fallocate_finish(struct io_wq_work *work)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
 	__io_fallocate(req);
 }
@@ -2950,9 +2950,9 @@ static void __io_close_finish(struct io_kiocb *req)
 	io_put_req(req);
 }
 
-static void io_close_finish(struct io_wq_work **workptr)
+static void io_close_finish(struct io_wq_work *work)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
 	/* not cancellable, don't do io_req_cancelled() */
 	__io_close_finish(req);
@@ -3019,9 +3019,9 @@ static void __io_sync_file_range(struct io_kiocb *req)
 }
 
 
-static void io_sync_file_range_finish(struct io_wq_work **workptr)
+static void io_sync_file_range_finish(struct io_wq_work *work)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
 	if (io_req_cancelled(req))
 		return;
@@ -3379,9 +3379,9 @@ static int __io_accept(struct io_kiocb *req, bool force_nonblock)
 	return 0;
 }
 
-static void io_accept_finish(struct io_wq_work **workptr)
+static void io_accept_finish(struct io_wq_work *work)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
 	io_put_req(req);
 
@@ -3567,9 +3567,8 @@ static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 	io_commit_cqring(ctx);
 }
 
-static void io_poll_complete_work(struct io_wq_work **workptr)
+static void io_poll_complete_work(struct io_wq_work *work)
 {
-	struct io_wq_work *work = *workptr;
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_poll_iocb *poll = &req->poll;
 	struct poll_table_struct pt = { ._key = poll->events };
@@ -3634,9 +3633,9 @@ static void __io_poll_flush(struct io_ring_ctx *ctx, struct llist_node *nodes)
 	io_free_req_many(ctx, &rb);
 }
 
-static void io_poll_flush(struct io_wq_work **workptr)
+static void io_poll_flush(struct io_wq_work *work)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct llist_node *nodes;
 
 	nodes = llist_del_all(&req->ctx->poll_llist);
@@ -3644,9 +3643,9 @@ static void io_poll_flush(struct io_wq_work **workptr)
 		__io_poll_flush(req->ctx, nodes);
 }
 
-static void io_poll_trigger_evfd(struct io_wq_work **workptr)
+static void io_poll_trigger_evfd(struct io_wq_work *work)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
 	eventfd_signal(req->ctx->cq_ev_fd, 1);
 	io_put_req(req);
@@ -4544,9 +4543,8 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static void io_wq_submit_work(struct io_wq_work **workptr)
+static void io_wq_submit_work(struct io_wq_work *work)
 {
-	struct io_wq_work *work = *workptr;
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	int ret = 0;
 
-- 
2.24.0

