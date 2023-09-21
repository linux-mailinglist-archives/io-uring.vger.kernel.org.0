Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEBE7A97ED
	for <lists+io-uring@lfdr.de>; Thu, 21 Sep 2023 19:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjIUR2r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Sep 2023 13:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjIUR2K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Sep 2023 13:28:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6853A88
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 10:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695315654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=B44/DY4idhV9YozUHFVRS7PC4VcGBJd3WAwJfKfRDLA=;
        b=fCbGolZGXp8BUeSGhmPy30vQAZj9IgIT7RXhuDlR5TzLxFUhSN4aa/tlJ7cPYtW65NUznV
        U+dr/C17j00aKLwWEcg+7eRC8LivJrYHKhT/6hrAASRS5Ce0iZGakLIAwQTPVhKYweKreR
        jbfcuftfOKxNOyDoDS97MrycA8T8yjU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-D5EHVdbAOCKvWiliZLY0wg-1; Thu, 21 Sep 2023 00:24:43 -0400
X-MC-Unique: D5EHVdbAOCKvWiliZLY0wg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B090D811E7B;
        Thu, 21 Sep 2023 04:24:42 +0000 (UTC)
Received: from localhost (unknown [10.72.120.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B873F40C6EBF;
        Thu, 21 Sep 2023 04:24:41 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] io_uring: cancelable uring_cmd
Date:   Thu, 21 Sep 2023 12:24:34 +0800
Message-Id: <20230921042434.2500190-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

uring_cmd may never complete, such as ublk, in which uring cmd isn't
completed until one new block request is coming from ublk block device.

Add cancelable uring_cmd to provide mechanism to driver to cancel
pending commands in its own way.

Add API of io_uring_cmd_mark_cancelable() for driver to mark one
command as cancelable, then io_uring will cancel this command in
io_uring_cancel_generic(). Driver callback is provided for canceling
command in driver's way, meantime driver gets notified with exiting of
io_uring task or context.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---

ublk patches:

	https://github.com/ming1/linux/commits/uring_exit_and_ublk

 include/linux/io_uring.h       | 22 +++++++++++++++++-
 include/linux/io_uring_types.h |  6 +++++
 include/uapi/linux/io_uring.h  |  7 ++++--
 io_uring/io_uring.c            | 30 ++++++++++++++++++++++++
 io_uring/uring_cmd.c           | 42 ++++++++++++++++++++++++++++++++++
 5 files changed, 104 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 106cdc55ff3b..5b98308a154f 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -22,6 +22,9 @@ enum io_uring_cmd_flags {
 	IO_URING_F_IOPOLL		= (1 << 10),
 };
 
+typedef void (uring_cmd_cancel_fn)(struct io_uring_cmd *,
+		unsigned int issue_flags, struct task_struct *task);
+
 struct io_uring_cmd {
 	struct file	*file;
 	const struct io_uring_sqe *sqe;
@@ -33,7 +36,17 @@ struct io_uring_cmd {
 	};
 	u32		cmd_op;
 	u32		flags;
-	u8		pdu[32]; /* available inline for free use */
+
+	/* less than 32 is available for cancelable cmd */
+	union {
+		u8		pdu[32]; /* available inline for free use */
+
+		struct {
+			/* available inline for free use */
+			u8	__pdu[32 - sizeof(uring_cmd_cancel_fn  *)];
+			uring_cmd_cancel_fn  *cancel_fn;
+		};
+	};
 };
 
 static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
@@ -82,6 +95,8 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
+int io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
+		unsigned int issue_flags, uring_cmd_cancel_fn *fn);
 #else
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
@@ -122,6 +137,11 @@ static inline int io_uring_cmd_sock(struct io_uring_cmd *cmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
+		unsigned int issue_flags, uring_cmd_cancel_fn *fn)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #endif
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 13d19b9be9f4..1571db76bec1 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -265,6 +265,12 @@ struct io_ring_ctx {
 		 */
 		struct io_wq_work_list	iopoll_list;
 		bool			poll_multi_queue;
+
+		/*
+		 * Any cancelable uring_cmd is added to this list in
+		 * ->uring_cmd() by io_uring_cmd_insert_cancelable()
+		 */
+		struct hlist_head	cancelable_uring_cmd;
 	} ____cacheline_aligned_in_smp;
 
 	struct {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8e61f8b7c2ce..29a7a7e71f57 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -249,10 +249,13 @@ enum io_uring_op {
  * sqe->uring_cmd_flags
  * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
  *				along with setting sqe->buf_index.
+ * IORING_URING_CANCELABLE	not for userspace
  * IORING_URING_CMD_POLLED	driver use only
  */
-#define IORING_URING_CMD_FIXED	(1U << 0)
-#define IORING_URING_CMD_POLLED	(1U << 31)
+#define IORING_URING_CMD_FIXED		(1U << 0)
+/* set by driver, and handled by io_uring to cancel this cmd */
+#define IORING_URING_CMD_CANCELABLE	(1U << 30)
+#define IORING_URING_CMD_POLLED		(1U << 31)
 
 
 /*
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 783ed0fff71b..428cffb1a7e1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3256,6 +3256,35 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 	return ret;
 }
 
+static bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
+					  struct task_struct *task,
+					  bool cancel_all)
+{
+	struct hlist_node *tmp;
+	struct io_kiocb *req;
+	bool ret = false;
+
+	mutex_lock(&ctx->uring_lock);
+	hlist_for_each_entry_safe(req, tmp, &ctx->cancelable_uring_cmd,
+			hash_node) {
+		struct io_uring_cmd *cmd = io_kiocb_to_cmd(req,
+				struct io_uring_cmd);
+
+		if (!cancel_all && req->task != task)
+			continue;
+
+		/* safe to call ->cancel_fn() since cmd isn't done yet */
+		if (cmd->flags & IORING_URING_CMD_CANCELABLE) {
+			cmd->cancel_fn(cmd, 0, task);
+			ret = true;
+		}
+	}
+	io_submit_flush_completions(ctx);
+	mutex_unlock(&ctx->uring_lock);
+
+	return ret;
+}
+
 static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 						struct task_struct *task,
 						bool cancel_all)
@@ -3307,6 +3336,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	ret |= io_kill_timeouts(ctx, task, cancel_all);
 	if (task)
 		ret |= io_run_task_work() > 0;
+	ret |= io_uring_try_cancel_uring_cmd(ctx, task, cancel_all);
 	return ret;
 }
 
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 537795fddc87..47a6c84fd7f9 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -13,6 +13,46 @@
 #include "rsrc.h"
 #include "uring_cmd.h"
 
+static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
+		unsigned int issue_flags)
+{
+	if (cmd->flags & IORING_URING_CMD_CANCELABLE) {
+		struct io_kiocb *req = cmd_to_io_kiocb(cmd);
+		struct io_ring_ctx *ctx = req->ctx;
+
+		io_ring_submit_lock(ctx, issue_flags);
+		cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
+		hlist_del(&req->hash_node);
+		io_ring_submit_unlock(ctx, issue_flags);
+	}
+}
+
+/*
+ * cancel callback is called in io_uring_cancel_generic() for canceling
+ * this uring_cmd, and it is driver's responsibility to cover race between
+ * race between normal completion and canceling.
+ */
+int io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
+		unsigned int issue_flags, uring_cmd_cancel_fn *fn)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!fn)
+		return -EINVAL;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE)) {
+		cmd->cancel_fn = fn;
+		cmd->flags |= IORING_URING_CMD_CANCELABLE;
+		hlist_add_head(&req->hash_node, &ctx->cancelable_uring_cmd);
+	}
+	io_ring_submit_unlock(ctx, issue_flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
+
 static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
@@ -56,6 +96,8 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
+	io_uring_cmd_del_cancelable(ioucmd, issue_flags);
+
 	if (ret < 0)
 		req_set_fail(req);
 
-- 
2.40.1

