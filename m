Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7574277FA
	for <lists+io-uring@lfdr.de>; Sat,  9 Oct 2021 09:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhJIH6u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Oct 2021 03:58:50 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:57039 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229722AbhJIH6u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Oct 2021 03:58:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Ur55Eab_1633766211;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Ur55Eab_1633766211)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 09 Oct 2021 15:56:52 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
Subject: [RFC] io_uring: add fixed poll support
Date:   Sat,  9 Oct 2021 15:56:51 +0800
Message-Id: <20211009075651.20316-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
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
  1. introduce fix poll support, currently it only works in file
registered mode. With this feature, we can get rid of various repeated
operations in io_arm_poll_handler(), contains apoll allocations,
and miscellaneous initializations anc check.
  2. introduce an event generation, which will increase monotonically.
If there is no new event happen, we don't need to call vfs_poll(), just
put req in a waitting list.

With this patch, echo server tests(1000 connection, packet is 16 bytes)
shows 1%~2% tps improvement.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 258 +++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 245 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8317c360f7a4..71df37c1eea6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -216,9 +216,20 @@ struct io_overflow_cqe {
 	struct list_head list;
 };
 
+struct io_fixed_poll {
+	struct wait_queue_head		*head;
+	struct list_head		list;
+	struct wait_queue_entry		wait;
+	unsigned long			generation;
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
@@ -226,7 +237,7 @@ struct io_rsrc_put {
 	u64 tag;
 	union {
 		void *rsrc;
-		struct file *file;
+		struct io_fixed_file *file_slot;
 		struct io_mapped_ubuf *buf;
 	};
 };
@@ -744,6 +755,7 @@ enum {
 	REQ_F_NOWAIT_READ_BIT,
 	REQ_F_NOWAIT_WRITE_BIT,
 	REQ_F_ISREG_BIT,
+	REQ_F_FIXED_POLL_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -795,6 +807,8 @@ enum {
 	REQ_F_REFCOUNT		= BIT(REQ_F_REFCOUNT_BIT),
 	/* there is a linked timeout that has to be armed */
 	REQ_F_ARM_LTIMEOUT	= BIT(REQ_F_ARM_LTIMEOUT_BIT),
+	/* already went through fixed poll handler */
+	REQ_F_FIXED_POLL	= BIT(REQ_F_FIXED_POLL_BIT),
 };
 
 struct async_poll {
@@ -878,7 +892,12 @@ struct io_kiocb {
 	struct io_task_work		io_task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	struct hlist_node		hash_node;
-	struct async_poll		*apoll;
+	union {
+		struct async_poll	*apoll;
+		struct io_fixed_poll	*fixed_poll;
+	};
+	struct list_head		fixed_poll_node;
+
 	struct io_wq_work		work;
 	const struct cred		*creds;
 
@@ -6611,7 +6630,7 @@ static void io_clean_op(struct io_kiocb *req)
 			break;
 		}
 	}
-	if ((req->flags & REQ_F_POLLED) && req->apoll) {
+	if (((req->flags & (REQ_F_POLLED | REQ_F_FIXED_POLL)) == REQ_F_POLLED) && req->apoll) {
 		kfree(req->apoll->double_poll);
 		kfree(req->apoll);
 		req->apoll = NULL;
@@ -6836,21 +6855,42 @@ static void io_fixed_file_set(struct io_fixed_file *file_slot, struct file *file
 	file_slot->file_ptr = file_ptr;
 }
 
+static inline void io_fixed_rpoll_set(struct io_fixed_file *file_slot, struct io_fixed_poll *rpoll)
+{
+	file_slot->rpoll = rpoll;
+}
+
+static inline void io_fixed_wpoll_set(struct io_fixed_file *file_slot, struct io_fixed_poll *wpoll)
+{
+	file_slot->wpoll = wpoll;
+}
+
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
 	req->flags |= (file_ptr << REQ_F_NOWAIT_READ_BIT);
 	io_req_set_rsrc_node(req);
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
 
@@ -6947,8 +6987,13 @@ static void __io_queue_sqe(struct io_kiocb *req)
 {
 	struct io_kiocb *linked_timeout;
 	int ret;
+	struct io_fixed_poll *fixed_poll = req->flags & REQ_F_FIXED_FILE ? req->fixed_poll : NULL;
+	unsigned long generation;
 
 issue_sqe:
+	if (fixed_poll)
+		generation = READ_ONCE(fixed_poll->generation);
+
 	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
 
 	/*
@@ -6972,7 +7017,27 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
 		linked_timeout = io_prep_linked_timeout(req);
 
-		switch (io_arm_poll_handler(req)) {
+		if (fixed_poll) {
+			if (req->flags & REQ_F_POLLED) {
+				ret = IO_APOLL_ABORTED;
+			} else {
+				spin_lock_irq(&fixed_poll->head->lock);
+				req->flags |= REQ_F_POLLED | REQ_F_FIXED_POLL;
+				/* new events happen */
+				if (generation != fixed_poll->generation) {
+					spin_unlock_irq(&fixed_poll->head->lock);
+					goto issue_sqe;
+				}
+				INIT_LIST_HEAD(&req->fixed_poll_node);
+				list_add_tail(&req->fixed_poll_node, &fixed_poll->list);
+				spin_unlock_irq(&fixed_poll->head->lock);
+				return;
+			}
+		} else {
+			ret = io_arm_poll_handler(req);
+		}
+
+		switch (ret) {
 		case IO_APOLL_READY:
 			if (linked_timeout)
 				io_unprep_linked_timeout(req);
@@ -7831,6 +7896,18 @@ static void io_free_file_tables(struct io_file_table *table)
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
 #if defined(CONFIG_UNIX)
@@ -7845,11 +7922,17 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	int i;
 
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
 			fput(file);
+		}
 	}
 #endif
 	io_free_file_tables(&ctx->file_table);
@@ -8094,7 +8177,12 @@ static int io_sqe_files_scm(struct io_ring_ctx *ctx)
 
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
@@ -8131,6 +8219,8 @@ static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 			} else {
 				__skb_queue_tail(&list, skb);
 			}
+			io_remove_fixed_poll(rpoll);
+			io_remove_fixed_poll(wpoll);
 			fput(file);
 			file = NULL;
 			break;
@@ -8151,6 +8241,8 @@ static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 		spin_unlock_irq(&head->lock);
 	}
 #else
+	io_remove_fixed_poll(rpoll);
+	io_remove_fixed_poll(wpoll);
 	fput(file);
 #endif
 }
@@ -8204,10 +8296,118 @@ static void io_rsrc_put_work(struct work_struct *work)
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
+	poll->generation++;
+	list_for_each_entry_safe(req, nxt, &poll->list, fixed_poll_node) {
+		req->result = key_to_poll(key);
+		req->io_task_work.func = io_fixed_poll_task_func;
+		io_req_task_work_add(req);
+		list_del(&req->fixed_poll_node);
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
+	__poll_t mask;
+	int rw = pollin ? READ : WRITE;
+
+	if (!file_can_poll(file) || !__io_file_supports_nowait(file, rw))
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
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				 unsigned nr_args, u64 __user *tags)
 {
 	__s32 __user *fds = (__s32 __user *) arg;
+	struct io_fixed_file *file_slot;
 	struct file *file;
 	int fd, ret;
 	unsigned i;
@@ -8233,6 +8433,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		goto out_free;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
+		struct io_fixed_poll *poll;
+
 		if (copy_from_user(&fd, &fds[i], sizeof(fd))) {
 			ret = -EFAULT;
 			goto out_fput;
@@ -8261,7 +8463,19 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			fput(file);
 			goto out_fput;
 		}
-		io_fixed_file_set(io_fixed_file_slot(&ctx->file_table, i), file);
+
+		file_slot = io_fixed_file_slot(&ctx->file_table, i);
+		io_fixed_file_set(file_slot, file);
+
+		poll = io_init_fixed_poll(file, true);
+		if (IS_ERR(poll))
+			goto out_fput;
+		io_fixed_rpoll_set(file_slot, poll);
+
+		poll = io_init_fixed_poll(file, false);
+		if (IS_ERR(poll))
+			goto out_fput;
+		io_fixed_wpoll_set(file_slot, poll);
 	}
 
 	ret = io_sqe_files_scm(ctx);
@@ -8274,9 +8488,17 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -8412,6 +8634,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	int fd, i, err = 0;
 	unsigned int done;
 	bool needs_switch = false;
+	struct io_fixed_poll *rpoll, *wpoll;
 
 	if (!ctx->file_data)
 		return -ENXIO;
@@ -8437,9 +8660,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		file_slot = io_fixed_file_slot(&ctx->file_table, i);
 
 		if (file_slot->file_ptr) {
-			file = (struct file *)(file_slot->file_ptr & FFS_MASK);
 			err = io_queue_rsrc_removal(data, up->offset + done,
-						    ctx->rsrc_node, file);
+						    ctx->rsrc_node, file_slot);
 			if (err)
 				break;
 			file_slot->file_ptr = 0;
@@ -8472,6 +8694,16 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				fput(file);
 				break;
 			}
+
+			rpoll = io_init_fixed_poll(file, true);
+			wpoll = io_init_fixed_poll(file, false);
+			if (IS_ERR(rpoll) || IS_ERR(wpoll)) {
+				file_slot->file_ptr = 0;
+				fput(file);
+				break;
+			}
+			io_fixed_rpoll_set(file_slot, rpoll);
+			io_fixed_wpoll_set(file_slot, wpoll);
 		}
 	}
 
-- 
2.14.4.44.g2045bb6

