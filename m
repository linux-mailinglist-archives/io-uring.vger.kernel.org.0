Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4AE47AB3A6
	for <lists+io-uring@lfdr.de>; Fri, 22 Sep 2023 16:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjIVO3U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Sep 2023 10:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjIVO3R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Sep 2023 10:29:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4980C6
        for <io-uring@vger.kernel.org>; Fri, 22 Sep 2023 07:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695392905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IzjFuc+Ps+XMfA++aToWsKP6POSQuCfjxQ0wjUUzyYM=;
        b=JDVC2f5/qwrg+4JhOO//id6lS11MOHxDPvOYVOi/s1ERSMYEse3M7r6cDLI5s5YPBHz+x4
        ueMFASpjS7BYtv/vyv8eEvxVHS27HcARVZq7FfrASAna8cSN0pNRjIwchAeY6f19pBD9FF
        kYnOG0X5QXywFuenO8ZY8q9SlxYvlJc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-SYeH_5UKORec_SZd2zyi2g-1; Fri, 22 Sep 2023 10:28:24 -0400
X-MC-Unique: SYeH_5UKORec_SZd2zyi2g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D89D68039C1;
        Fri, 22 Sep 2023 14:28:23 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AB9240C2064;
        Fri, 22 Sep 2023 14:28:22 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH V2] io_uring: cancelable uring_cmd
Date:   Fri, 22 Sep 2023 22:28:16 +0800
Message-ID: <20230922142816.2784777-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

uring_cmd may never complete, such as ublk, in which uring cmd isn't
completed until one new block request is coming from ublk block device.

Add cancelable uring_cmd to provide mechanism to driver for cancelling
pending commands in its own way.

Add API of io_uring_cmd_mark_cancelable() for driver to mark one command as
cancelable, then io_uring will cancel this command in
io_uring_cancel_generic(). ->uring_cmd() callback is reused for canceling
command in driver's way, then driver gets notified with the cancelling
from io_uring.

Add API of io_uring_cmd_get_task() to help driver cancel handler
deal with the canceling.

Cc: Gabriel Krisman Bertazi <krisman@suse.de>
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---

ublk patches:
	https://github.com/ming1/linux/commits/uring_exit_and_ublk

V2:
	- use ->uring_cmd() with IO_URING_F_CANCEL for canceling command

 include/linux/io_uring.h       | 15 +++++++++++
 include/linux/io_uring_types.h |  6 +++++
 include/uapi/linux/io_uring.h  |  7 +++--
 io_uring/io_uring.c            | 35 +++++++++++++++++++++++++
 io_uring/uring_cmd.c           | 48 ++++++++++++++++++++++++++++++++++
 5 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 106cdc55ff3b..205179a1c191 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -20,6 +20,9 @@ enum io_uring_cmd_flags {
 	IO_URING_F_SQE128		= (1 << 8),
 	IO_URING_F_CQE32		= (1 << 9),
 	IO_URING_F_IOPOLL		= (1 << 10),
+
+	/* set when uring wants to cancel one issued command */
+	IO_URING_F_CANCEL		= (1 << 11),
 };
 
 struct io_uring_cmd {
@@ -82,6 +85,9 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
+int io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
+		unsigned int issue_flags);
+struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd);
 #else
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
@@ -122,6 +128,15 @@ static inline int io_uring_cmd_sock(struct io_uring_cmd *cmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
+		unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
+static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
+{
+	return NULL;
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
index 783ed0fff71b..a3135fd47a4e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3256,6 +3256,40 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 	return ret;
 }
 
+static bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
+		struct task_struct *task, bool cancel_all)
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
+		struct file *file = req->file;
+
+		if (WARN_ON_ONCE(!file->f_op->uring_cmd))
+			continue;
+
+		if (!cancel_all && req->task != task)
+			continue;
+
+		if (cmd->flags & IORING_URING_CMD_CANCELABLE) {
+			/* ->sqe isn't available if no async data */
+			if (!req_has_async_data(req))
+				cmd->sqe = NULL;
+			file->f_op->uring_cmd(cmd, IO_URING_F_CANCEL);
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
@@ -3307,6 +3341,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	ret |= io_kill_timeouts(ctx, task, cancel_all);
 	if (task)
 		ret |= io_run_task_work() > 0;
+	ret |= io_uring_try_cancel_uring_cmd(ctx, task, cancel_all);
 	return ret;
 }
 
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 537795fddc87..d6b200a0be33 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -13,6 +13,52 @@
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
+ * Mark this command as concelable, then io_uring_try_cancel_uring_cmd()
+ * will try to cancel this issued command by sending ->uring_cmd() with
+ * issue_flags of IO_URING_F_CANCEL.
+ *
+ * The command is guaranteed to not be done when calling ->uring_cmd()
+ * with IO_URING_F_CANCEL, but it is driver's responsibility to deal
+ * with race between io_uring canceling and normal completion.
+ */
+int io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
+		unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE)) {
+		cmd->flags |= IORING_URING_CMD_CANCELABLE;
+		hlist_add_head(&req->hash_node, &ctx->cancelable_uring_cmd);
+	}
+	io_ring_submit_unlock(ctx, issue_flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
+
+struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
+{
+	return cmd_to_io_kiocb(cmd)->task;
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_get_task);
+
 static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
@@ -56,6 +102,8 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
+	io_uring_cmd_del_cancelable(ioucmd, issue_flags);
+
 	if (ret < 0)
 		req_set_fail(req);
 
-- 
2.41.0

