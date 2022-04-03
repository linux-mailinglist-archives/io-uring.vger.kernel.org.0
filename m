Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3314F0923
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 13:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347994AbiDCLrj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 07:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238387AbiDCLri (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 07:47:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B0D9240AF
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 04:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648986343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bZsjD689KmDflISKNsEEME2oVCsfAXBsTTv2eriqQVM=;
        b=Ey2ioVkmLrr+QPYXDSlferoBG654enR00BICvdWFrnBaixcIBtnLKSOp24aFmVxWvnhafS
        5hCEhuhR3vsv8LWQoQiGxD580FyGMi8IiBOov3EmTUg/mGZHr1ggbmqJY/JY8IqN3/A/tK
        K0MDYSy26Psz8YYg33q0qreCTxndNXU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-5B5_eGBROL6S3ZXUDVZgOg-1; Sun, 03 Apr 2022 07:45:41 -0400
X-MC-Unique: 5B5_eGBROL6S3ZXUDVZgOg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 896AF38041D5;
        Sun,  3 Apr 2022 11:45:41 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF19140D0300;
        Sun,  3 Apr 2022 11:45:40 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Subject: [RFC PATCH] io_uring: reissue in case -EAGAIN is returned after io issue returns
Date:   Sun,  3 Apr 2022 19:45:32 +0800
Message-Id: <20220403114532.180945-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

-EAGAIN still may return after io issue returns, and REQ_F_REISSUE is
set in io_complete_rw_iopoll(), but the req never gets chance to be handled.
io_iopoll_check doesn't handle this situation, and io hang can be caused.

Current dm io polling may return -EAGAIN after bio submission is
returned, also blk-throttle might trigger this situation too.

Cc: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/io-wq.h    |  13 +++++
 fs/io_uring.c | 128 ++++++++++++++++++++++++++++----------------------
 2 files changed, 86 insertions(+), 55 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index dbecd27656c7..4ca4863664fb 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -96,6 +96,19 @@ static inline void wq_list_add_head(struct io_wq_work_node *node,
 	WRITE_ONCE(list->first, node);
 }
 
+static inline void wq_list_remove(struct io_wq_work_list *list,
+				  struct io_wq_work_node *prev,
+				  struct io_wq_work_node *node)
+{
+	if (!prev)
+		WRITE_ONCE(list->first, node->next);
+	else
+		prev->next = node->next;
+
+	if (node == list->last)
+		list->last = prev;
+}
+
 static inline void wq_list_cut(struct io_wq_work_list *list,
 			       struct io_wq_work_node *last,
 			       struct io_wq_work_node *prev)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 59e54a6854b7..6db5514e10ca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2759,6 +2759,65 @@ static inline bool io_run_task_work(void)
 	return false;
 }
 
+#ifdef CONFIG_BLOCK
+static bool io_resubmit_prep(struct io_kiocb *req)
+{
+	struct io_async_rw *rw = req->async_data;
+
+	if (!req_has_async_data(req))
+		return !io_req_prep_async(req);
+	iov_iter_restore(&rw->s.iter, &rw->s.iter_state);
+	return true;
+}
+
+static bool io_rw_should_reissue(struct io_kiocb *req)
+{
+	umode_t mode = file_inode(req->file)->i_mode;
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!S_ISBLK(mode) && !S_ISREG(mode))
+		return false;
+	if ((req->flags & REQ_F_NOWAIT) || (io_wq_current_is_worker() &&
+	    !(ctx->flags & IORING_SETUP_IOPOLL)))
+		return false;
+	/*
+	 * If ref is dying, we might be running poll reap from the exit work.
+	 * Don't attempt to reissue from that path, just let it fail with
+	 * -EAGAIN.
+	 */
+	if (percpu_ref_is_dying(&ctx->refs))
+		return false;
+	/*
+	 * Play it safe and assume not safe to re-import and reissue if we're
+	 * not in the original thread group (or in task context).
+	 */
+	if (!same_thread_group(req->task, current) || !in_task())
+		return false;
+	return true;
+}
+#else
+static bool io_resubmit_prep(struct io_kiocb *req)
+{
+	return false;
+}
+static bool io_rw_should_reissue(struct io_kiocb *req)
+{
+	return false;
+}
+#endif
+
+static void do_io_reissue(struct io_kiocb *req, int ret)
+{
+	if (req->flags & REQ_F_REISSUE) {
+		req->flags &= ~REQ_F_REISSUE;
+		if (io_resubmit_prep(req))
+			io_req_task_queue_reissue(req);
+		else
+			io_req_task_queue_fail(req, ret);
+	}
+}
+
+
 static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_wq_work_node *pos, *start, *prev;
@@ -2786,6 +2845,13 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (READ_ONCE(req->iopoll_completed))
 			break;
 
+		/*
+		 * Once REISSUE flag is set, the req has been done, and we
+		 * have to retry
+		 */
+		if (req->flags & REQ_F_REISSUE)
+			break;
+
 		ret = kiocb->ki_filp->f_op->iopoll(kiocb, &iob, poll_flags);
 		if (unlikely(ret < 0))
 			return ret;
@@ -2807,6 +2873,12 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	wq_list_for_each_resume(pos, prev) {
 		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
 
+		if (req->flags & REQ_F_REISSUE) {
+			wq_list_remove(&ctx->iopoll_list, prev, pos);
+			do_io_reissue(req, -EIO);
+			break;
+		}
+
 		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
@@ -2924,53 +2996,6 @@ static void kiocb_end_write(struct io_kiocb *req)
 	}
 }
 
-#ifdef CONFIG_BLOCK
-static bool io_resubmit_prep(struct io_kiocb *req)
-{
-	struct io_async_rw *rw = req->async_data;
-
-	if (!req_has_async_data(req))
-		return !io_req_prep_async(req);
-	iov_iter_restore(&rw->s.iter, &rw->s.iter_state);
-	return true;
-}
-
-static bool io_rw_should_reissue(struct io_kiocb *req)
-{
-	umode_t mode = file_inode(req->file)->i_mode;
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (!S_ISBLK(mode) && !S_ISREG(mode))
-		return false;
-	if ((req->flags & REQ_F_NOWAIT) || (io_wq_current_is_worker() &&
-	    !(ctx->flags & IORING_SETUP_IOPOLL)))
-		return false;
-	/*
-	 * If ref is dying, we might be running poll reap from the exit work.
-	 * Don't attempt to reissue from that path, just let it fail with
-	 * -EAGAIN.
-	 */
-	if (percpu_ref_is_dying(&ctx->refs))
-		return false;
-	/*
-	 * Play it safe and assume not safe to re-import and reissue if we're
-	 * not in the original thread group (or in task context).
-	 */
-	if (!same_thread_group(req->task, current) || !in_task())
-		return false;
-	return true;
-}
-#else
-static bool io_resubmit_prep(struct io_kiocb *req)
-{
-	return false;
-}
-static bool io_rw_should_reissue(struct io_kiocb *req)
-{
-	return false;
-}
-#endif
-
 static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
 	if (req->rw.kiocb.ki_flags & IOCB_WRITE)
@@ -3264,14 +3289,7 @@ static void kiocb_done(struct io_kiocb *req, ssize_t ret,
 		__io_complete_rw(req, ret, issue_flags);
 	else
 		io_rw_done(&req->rw.kiocb, ret);
-
-	if (req->flags & REQ_F_REISSUE) {
-		req->flags &= ~REQ_F_REISSUE;
-		if (io_resubmit_prep(req))
-			io_req_task_queue_reissue(req);
-		else
-			io_req_task_queue_fail(req, ret);
-	}
+	do_io_reissue(req, ret);
 }
 
 static int __io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter,
-- 
2.31.1

