Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F20A43E102
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 14:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhJ1MbU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 08:31:20 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:42311 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230285AbhJ1MbT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 08:31:19 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Uu.zzU6_1635424130;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Uu.zzU6_1635424130)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Oct 2021 20:28:50 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
Subject: [RFC v2 2/3] io_uring: add fixed poll support
Date:   Thu, 28 Oct 2021 20:28:49 +0800
Message-Id: <20211028122850.13025-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20211028122850.13025-1-xiaoguang.wang@linux.alibaba.com>
References: <20211028122850.13025-1-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Recently I spend time to research io_uring's fast-poll and multi-shot's
performance using network echo-server model. Previously I always thought
fast-poll is better than multi-shot and will give better performance,
but indeed multi-shot is almost always better than fast-poll in real
test, which is very interesting. I use ebpf to have some measurements,
it shows that whether fast-poll is excellent or not depends entirely on
that the first nowait try in io_issue_sqe() succeeds or fails. Take
io_recv operation as example(recv buffer is 16 bytes):
  1) the first nowait succeeds, a simple io_recv() is enough.
In my test machine, successful io_recv() consumes 1110ns averagely.

  2) the first nowait fails, then we'll have some expensive work, which
contains failed io_revc(), apoll allocations, vfs_poll(), miscellaneous
initializations anc check in __io_arm_poll_handler() and a final
successful io_recv(). Among then:
    failed io_revc() consumes 620ns averagely.
    vfs_poll() consumes 550ns averagely.
I don't measure other overhead yet, but we can see if the first nowait
try fails, we'll need at least 2290ns(620 + 550 + 1110) to complete it.
In my echo server tests, 40% of first nowait io_recv() operations fails.

From above measurements, it can explain why mulit-shot is better than
multi-shot, mulit-shot can ensure the first nowait try succeed.

Based on above measurements, I try to improve fast-poll a bit:
Introduce fix poll support, currently it only works in file registered
mode. With this feature, we can get rid of various repeated operations
in io_arm_poll_handler(), contains apoll allocations, and miscellaneous
initializations anc check.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 325 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 300 insertions(+), 25 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7361ae53cad3..6f63aea3e0c0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -219,9 +219,19 @@ struct io_overflow_cqe {
 	struct list_head list;
 };
 
+struct io_fixed_poll {
+	struct wait_queue_head		*head;
+	struct list_head		list;
+	struct wait_queue_entry		wait;
+	__poll_t			events;
+};
+
+
 struct io_fixed_file {
 	/* file * with additional FFS_* flags */
 	unsigned long file_ptr;
+	struct io_fixed_poll *rpoll;
+	struct io_fixed_poll *wpoll;
 };
 
 struct io_rsrc_put {
@@ -229,7 +239,7 @@ struct io_rsrc_put {
 	u64 tag;
 	union {
 		void *rsrc;
-		struct file *file;
+		struct io_fixed_file *file_slot;
 		struct io_mapped_ubuf *buf;
 	};
 };
@@ -736,6 +746,7 @@ enum {
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
+	REQ_F_FIXED_POLL_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -787,6 +798,8 @@ enum {
 	REQ_F_ARM_LTIMEOUT	= BIT(REQ_F_ARM_LTIMEOUT_BIT),
 	/* ->async_data allocated */
 	REQ_F_ASYNC_DATA	= BIT(REQ_F_ASYNC_DATA_BIT),
+	/* already went through fixed poll handler */
+	REQ_F_FIXED_POLL	= BIT(REQ_F_FIXED_POLL_BIT),
 };
 
 struct async_poll {
@@ -873,6 +886,9 @@ struct io_kiocb {
 	struct async_poll		*apoll;
 	/* opcode allocated if it needs to store data for async defer */
 	void				*async_data;
+	struct io_fixed_poll		*fixed_poll;
+	struct list_head		fixed_poll_node;
+
 	struct io_wq_work		work;
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	const struct cred		*creds;
@@ -5281,7 +5297,10 @@ static struct io_poll_iocb *io_poll_get_double(struct io_kiocb *req)
 	/* pure poll stashes this in ->async_data, poll driven retry elsewhere */
 	if (req->opcode == IORING_OP_POLL_ADD)
 		return req->async_data;
-	return req->apoll->double_poll;
+	else if (req->flags & REQ_F_FIXED_POLL)
+		return NULL;
+	else
+		return req->apoll->double_poll;
 }
 
 static struct io_poll_iocb *io_poll_get_single(struct io_kiocb *req)
@@ -5642,13 +5661,32 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 	return do_complete;
 }
 
+static bool io_fixed_poll_remove_one(struct io_kiocb *req)
+	__must_hold(&req->ctx->completion_lock)
+{
+	struct io_fixed_poll *fixed_poll = req->fixed_poll;
+	bool do_complete = false;
+
+	spin_lock_irq(&fixed_poll->head->lock);
+	if (!list_empty(&req->fixed_poll_node)) {
+		list_del_init(&req->fixed_poll_node);
+		do_complete = true;
+	}
+	spin_unlock_irq(&fixed_poll->head->lock);
+	hash_del(&req->hash_node);
+	return do_complete;
+}
+
 static bool io_poll_remove_one(struct io_kiocb *req)
 	__must_hold(&req->ctx->completion_lock)
 {
 	bool do_complete;
 
 	io_poll_remove_double(req);
-	do_complete = __io_poll_remove_one(req, io_poll_get_single(req), true);
+	if (req->flags & REQ_F_FIXED_POLL)
+		do_complete = io_fixed_poll_remove_one(req);
+	else
+		do_complete = __io_poll_remove_one(req, io_poll_get_single(req), true);
 
 	if (do_complete) {
 		io_cqring_fill_event(req->ctx, req->user_data, -ECANCELED, 0);
@@ -6816,18 +6854,29 @@ static void io_fixed_file_set(struct io_fixed_file *file_slot, struct file *file
 static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
 					     struct io_kiocb *req, int fd)
 {
+	struct io_fixed_file *file_slot;
 	struct file *file;
 	unsigned long file_ptr;
+	const struct io_op_def *def = &io_op_defs[req->opcode];
 
 	if (unlikely((unsigned int)fd >= ctx->nr_user_files))
 		return NULL;
 	fd = array_index_nospec(fd, ctx->nr_user_files);
-	file_ptr = io_fixed_file_slot(&ctx->file_table, fd)->file_ptr;
+	file_slot = io_fixed_file_slot(&ctx->file_table, fd);
+	file_ptr = file_slot->file_ptr;
 	file = (struct file *) (file_ptr & FFS_MASK);
 	file_ptr &= ~FFS_MASK;
 	/* mask in overlapping REQ_F and FFS bits */
 	req->flags |= (file_ptr << REQ_F_SUPPORT_NOWAIT_BIT);
 	io_req_set_rsrc_node(req, ctx);
+
+	if (def->pollin)
+		req->fixed_poll = file_slot->rpoll;
+	else if (def->pollout)
+		req->fixed_poll = file_slot->wpoll;
+	else
+		req->fixed_poll = NULL;
+
 	return file;
 }
 
@@ -6919,12 +6968,47 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
 	io_put_req(req);
 }
 
+static inline int io_arm_fixed_poll_handler(struct io_kiocb *req,
+					    struct io_fixed_poll *fixed_poll)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct poll_table_struct pt = { ._key = fixed_poll->events };
+	__poll_t result;
+
+	if (req->flags & REQ_F_FIXED_POLL)
+		return IO_APOLL_ABORTED;
+
+	req->flags |= REQ_F_FIXED_POLL;
+	result = vfs_poll(req->file, &pt) & fixed_poll->events;
+	if (result)
+		return IO_APOLL_READY;
+
+	spin_lock(&ctx->completion_lock);
+	spin_lock_irq(&fixed_poll->head->lock);
+	INIT_LIST_HEAD(&req->fixed_poll_node);
+	list_add_tail(&req->fixed_poll_node, &fixed_poll->list);
+	io_poll_req_insert(req);
+	spin_unlock_irq(&fixed_poll->head->lock);
+	spin_unlock(&ctx->completion_lock);
+	return IO_APOLL_OK;
+}
+
 static void io_queue_sqe_arm_apoll(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
+	struct io_fixed_poll *fixed_poll = NULL;
+	int ret;
 
-	switch (io_arm_poll_handler(req)) {
+	if (req->flags & REQ_F_FIXED_FILE)
+		fixed_poll = req->fixed_poll;
+
+	if (fixed_poll)
+		ret = io_arm_fixed_poll_handler(req, fixed_poll);
+	else
+		ret = io_arm_poll_handler(req);
+
+	switch (ret) {
 	case IO_APOLL_READY:
 		if (linked_timeout) {
 			io_unprep_linked_timeout(req);
@@ -7846,8 +7930,22 @@ static void io_free_file_tables(struct io_file_table *table)
 	table->files = NULL;
 }
 
+static inline void io_remove_fixed_poll(struct io_fixed_poll *poll)
+{
+	if (!poll)
+		return;
+
+	spin_lock_irq(&poll->head->lock);
+	if (!list_empty(&poll->wait.entry))
+		list_del_init(&poll->wait.entry);
+	spin_unlock_irq(&poll->head->lock);
+	kfree(poll);
+}
+
 static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
+	int i;
+
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock) {
 		struct sock *sock = ctx->ring_sock->sk;
@@ -7856,17 +7954,24 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 		while ((skb = skb_dequeue(&sock->sk_receive_queue)) != NULL)
 			kfree_skb(skb);
 	}
-#else
-	int i;
+
+#endif
 
 	for (i = 0; i < ctx->nr_user_files; i++) {
-		struct file *file;
+		struct io_fixed_file *file_slot = io_fixed_file_slot(&ctx->file_table, i);
+		struct file *file = (struct file *)(file_slot->file_ptr & FFS_MASK);
+		struct io_fixed_poll *rpoll = file_slot->rpoll;
+		struct io_fixed_poll *wpoll = file_slot->wpoll;
 
 		file = io_file_from_index(ctx, i);
-		if (file)
+		if (file) {
+			io_remove_fixed_poll(rpoll);
+			io_remove_fixed_poll(wpoll);
+#if !defined(CONFIG_UNIX)
 			fput(file);
-	}
 #endif
+		}
+	}
 	io_free_file_tables(&ctx->file_table);
 	io_rsrc_data_free(ctx->file_data);
 	ctx->file_data = NULL;
@@ -8109,7 +8214,12 @@ static int io_sqe_files_scm(struct io_ring_ctx *ctx)
 
 static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
-	struct file *file = prsrc->file;
+	struct io_fixed_file *file_slot = prsrc->file_slot;
+	struct file *file = (struct file *)(file_slot->file_ptr & FFS_MASK);
+	struct io_fixed_poll *rpoll = file_slot->rpoll;
+	struct io_fixed_poll *wpoll = file_slot->wpoll;
+
+
 #if defined(CONFIG_UNIX)
 	struct sock *sock = ctx->ring_sock->sk;
 	struct sk_buff_head list, *head = &sock->sk_receive_queue;
@@ -8146,6 +8256,8 @@ static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 			} else {
 				__skb_queue_tail(&list, skb);
 			}
+			io_remove_fixed_poll(rpoll);
+			io_remove_fixed_poll(wpoll);
 			fput(file);
 			file = NULL;
 			break;
@@ -8166,8 +8278,13 @@ static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 		spin_unlock_irq(&head->lock);
 	}
 #else
+	io_remove_fixed_poll(rpoll);
+	io_remove_fixed_poll(wpoll);
 	fput(file);
 #endif
+
+	/* free_slot is allocated in io_queue_remove_fixed_file(), free it here. */
+	kfree(file_slot);
 }
 
 static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
@@ -8219,10 +8336,140 @@ static void io_rsrc_put_work(struct work_struct *work)
 	}
 }
 
+struct io_fixed_poll_table {
+	struct poll_table_struct pt;
+	struct io_fixed_poll *poll;
+	int  nr_entries;
+	int error;
+};
+
+static void io_fixed_poll_task_func(struct io_kiocb *req, bool *locked)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_fixed_poll *poll = req->fixed_poll;
+	bool canceled = false;
+
+	trace_io_uring_task_run(req->ctx, req, req->opcode, req->user_data);
+
+	/* req->task == current here, checking PF_EXITING is safe */
+	if (unlikely(req->task->flags & PF_EXITING))
+		canceled = true;
+
+	if (!req->result && !canceled) {
+		struct poll_table_struct pt = { ._key = poll->events };
+
+		req->result = vfs_poll(req->file, &pt) & poll->events;
+	}
+	if (!req->result)
+		return;
+
+	spin_lock(&ctx->completion_lock);
+	hash_del(&req->hash_node);
+	spin_unlock(&ctx->completion_lock);
+
+	if (!canceled)
+		io_req_task_submit(req, locked);
+	else
+		io_req_complete_failed(req, -ECANCELED);
+}
+
+static int io_fixed_poll_wake(struct wait_queue_entry *wait,
+			unsigned int mode, int sync, void *key)
+{
+	struct io_fixed_poll *poll = wait->private;
+	struct io_kiocb *req, *nxt;
+	__poll_t mask = key_to_poll(key);
+
+	/* for instances that support it check for an event match first: */
+	if (mask && !(mask & poll->events))
+		return 0;
+
+	list_for_each_entry_safe(req, nxt, &poll->list, fixed_poll_node) {
+		req->result = mask;
+		req->io_task_work.func = io_fixed_poll_task_func;
+		io_req_task_work_add(req);
+		list_del_init(&req->fixed_poll_node);
+	}
+
+	return 1;
+}
+
+static void io_fixed_poll_queue_proc(struct file *file, struct wait_queue_head *head,
+				     struct poll_table_struct *p)
+{
+	struct io_fixed_poll_table *ipt;
+
+	ipt = container_of(p, struct io_fixed_poll_table, pt);
+	if (unlikely(ipt->nr_entries)) {
+		ipt->error = -EOPNOTSUPP;
+		return;
+	}
+	ipt->poll->head = head;
+	ipt->nr_entries++;
+	if (ipt->poll->events & EPOLLEXCLUSIVE)
+		add_wait_queue_exclusive(head, &ipt->poll->wait);
+	else
+		add_wait_queue(head, &ipt->poll->wait);
+}
+
+static inline struct io_fixed_poll *io_init_fixed_poll(struct file *file, bool pollin)
+{
+	struct io_fixed_poll *poll;
+	struct io_fixed_poll_table ipt;
+	umode_t mode = file_inode(file)->i_mode;
+	__poll_t mask;
+
+	if (!file_can_poll(file) || !__io_file_supports_nowait(file, mode))
+		return NULL;
+
+	poll = kzalloc(sizeof(struct io_fixed_poll), GFP_KERNEL);
+	if (!poll)
+		return ERR_PTR(-ENOMEM);
+
+	ipt.pt._qproc = io_fixed_poll_queue_proc;
+	ipt.poll = poll;
+	ipt.error = 0;
+	ipt.nr_entries = 0;
+	if (pollin)
+		ipt.pt._key = POLLERR | POLLPRI | POLLIN | POLLRDNORM;
+	else
+		ipt.pt._key = POLLERR | POLLPRI | POLLOUT | POLLWRNORM;
+	INIT_LIST_HEAD(&poll->wait.entry);
+	INIT_LIST_HEAD(&poll->list);
+	init_waitqueue_func_entry(&poll->wait, io_fixed_poll_wake);
+	poll->wait.private = poll;
+	poll->events = ipt.pt._key;
+	mask = vfs_poll(file, &ipt.pt);
+	if (ipt.error && poll->head) {
+		io_remove_fixed_poll(poll);
+		return NULL;
+	}
+	return poll;
+}
+
+static void io_register_fixed_poll(struct io_fixed_file *file_slot, struct file *file)
+{
+	struct io_fixed_poll *rpoll, *wpoll;
+
+	rpoll = io_init_fixed_poll(file, true);
+	if (IS_ERR(rpoll))
+		return;
+
+	wpoll = io_init_fixed_poll(file, false);
+	if (IS_ERR(wpoll)) {
+		io_remove_fixed_poll(rpoll);
+		return;
+	}
+
+	file_slot->rpoll = rpoll;
+	file_slot->wpoll = wpoll;
+}
+
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				 unsigned nr_args, u64 __user *tags)
 {
 	__s32 __user *fds = (__s32 __user *) arg;
+	struct io_fixed_file *file_slot;
 	struct file *file;
 	int fd, ret;
 	unsigned i;
@@ -8276,7 +8523,10 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			fput(file);
 			goto out_fput;
 		}
-		io_fixed_file_set(io_fixed_file_slot(&ctx->file_table, i), file);
+
+		file_slot = io_fixed_file_slot(&ctx->file_table, i);
+		io_fixed_file_set(file_slot, file);
+		io_register_fixed_poll(file_slot, file);
 	}
 
 	ret = io_sqe_files_scm(ctx);
@@ -8289,9 +8539,17 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
-		file = io_file_from_index(ctx, i);
-		if (file)
+		file_slot = io_fixed_file_slot(&ctx->file_table, i);
+		file = (struct file *)(file_slot->file_ptr & FFS_MASK);
+
+		if (file) {
+			struct io_fixed_poll *rpoll = file_slot->rpoll;
+			struct io_fixed_poll *wpoll = file_slot->wpoll;
+
+			io_remove_fixed_poll(rpoll);
+			io_remove_fixed_poll(wpoll);
 			fput(file);
+		}
 	}
 	io_free_file_tables(&ctx->file_table);
 	ctx->nr_user_files = 0;
@@ -8359,6 +8617,25 @@ static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 	return 0;
 }
 
+static inline int io_queue_remove_fixed_file(struct io_rsrc_data *data, unsigned idx,
+				struct io_rsrc_node *node, struct io_fixed_file *file_slot)
+{
+	struct io_fixed_file *slot;
+	int ret;
+
+	slot = kzalloc(sizeof(struct io_fixed_file), GFP_KERNEL);
+	if (!slot)
+		return -ENOMEM;
+
+	slot->file_ptr = file_slot->file_ptr;
+	slot->rpoll = file_slot->rpoll;
+	slot->wpoll = file_slot->wpoll;
+	ret = io_queue_rsrc_removal(data, idx, node, slot);
+	if (ret < 0)
+		kfree(slot);
+	return ret;
+}
+
 static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 				 unsigned int issue_flags, u32 slot_index)
 {
@@ -8382,15 +8659,12 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 	file_slot = io_fixed_file_slot(&ctx->file_table, slot_index);
 
 	if (file_slot->file_ptr) {
-		struct file *old_file;
-
 		ret = io_rsrc_node_switch_start(ctx);
 		if (ret)
 			goto err;
 
-		old_file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-		ret = io_queue_rsrc_removal(ctx->file_data, slot_index,
-					    ctx->rsrc_node, old_file);
+		ret = io_queue_remove_fixed_file(ctx->file_data, slot_index,
+						 ctx->rsrc_node, file_slot);
 		if (ret)
 			goto err;
 		file_slot->file_ptr = 0;
@@ -8399,6 +8673,7 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 
 	*io_get_tag_slot(ctx->file_data, slot_index) = 0;
 	io_fixed_file_set(file_slot, file);
+	io_register_fixed_poll(file_slot, file);
 	ret = io_sqe_file_register(ctx, file, slot_index);
 	if (ret) {
 		file_slot->file_ptr = 0;
@@ -8421,7 +8696,6 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 	struct io_fixed_file *file_slot;
-	struct file *file;
 	int ret, i;
 
 	io_ring_submit_lock(ctx, needs_lock);
@@ -8441,8 +8715,7 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 	if (!file_slot->file_ptr)
 		goto out;
 
-	file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-	ret = io_queue_rsrc_removal(ctx->file_data, offset, ctx->rsrc_node, file);
+	ret = io_queue_remove_fixed_file(ctx->file_data, offset, ctx->rsrc_node, file_slot);
 	if (ret)
 		goto out;
 
@@ -8491,12 +8764,13 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		file_slot = io_fixed_file_slot(&ctx->file_table, i);
 
 		if (file_slot->file_ptr) {
-			file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-			err = io_queue_rsrc_removal(data, up->offset + done,
-						    ctx->rsrc_node, file);
+			err = io_queue_remove_fixed_file(data, up->offset + done,
+							 ctx->rsrc_node, file_slot);
 			if (err)
 				break;
 			file_slot->file_ptr = 0;
+			file_slot->rpoll = NULL;
+			file_slot->wpoll = NULL;
 			needs_switch = true;
 		}
 		if (fd != -1) {
@@ -8526,6 +8800,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				fput(file);
 				break;
 			}
+			io_register_fixed_poll(file_slot, file);
 		}
 	}
 
-- 
2.14.4.44.g2045bb6

