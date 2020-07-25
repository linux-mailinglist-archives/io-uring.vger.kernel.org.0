Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DF222D61C
	for <lists+io-uring@lfdr.de>; Sat, 25 Jul 2020 10:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgGYIdZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jul 2020 04:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgGYIdY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jul 2020 04:33:24 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42267C0619E4
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 01:33:24 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id lx13so12233709ejb.4
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 01:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=lPLVpNlS1TodavD00vMIDVU2PfnD/FbvL/ckbY3c8tA=;
        b=mx8Lk1IVPGr6x/AvND3/dTIO0a+pm6BV6TUJIYNQ9fbjZq3f6M6CiBsJR9TA7enXWU
         CNHkvQ5cyU/ms2Cw3AC4TD+7scK1Hc/oUeXrSpDWBgT7HAjCeZVHGrxo9HH0Aqt7DUWe
         BGXpLxRuCr/HCtwZ+iZG9TqRHso7CTji8pkipQ8B4OQ52QMfLM3jnwN3Q5XG+036WdTC
         4bmm0vHrcihF5itxsIfio8NB8peBtnsbE8wugzL/g3NRTbeBdvvpZ6M69vvfOrlwBo5m
         bkeiWkuCyxe5USbFixvO1h5afVHIhOZw52yPkYD2CortMIrz52SXbxL+cErI1In3JZ/D
         RYeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lPLVpNlS1TodavD00vMIDVU2PfnD/FbvL/ckbY3c8tA=;
        b=FwXr5YbhU426YNN45O7VyHHKz1OVhncv93ClXLSfsfz4zbA+hfkh3OxRpLR/x1CPJc
         9xAdCDpLUdoi252DpjAZI6bk4ftjxcdEj7Tc/dOA7Va6iT6cZlgyGyxrtWVqecwwzi3d
         WEj0upUNEao6GWkmA3QucNlaZbvNcWOTuLI/pYpYQDsnh+p+6vcmX5GMidEtDS6JPlfO
         d1zSN/RHojTk51/7UHMJLjgHhCM4IfGzN9dlX4M6Dw5U3vJG/5q3C10B48ePii+Ntnmc
         dO62X26+nJb/kT+cthtAxgyMGhRL7+L1J99FRR5m0H0kFGEbbFRuIP0bEaF8nyDET2Rs
         0EzQ==
X-Gm-Message-State: AOAM533TlcW1UnxeHLP8YzmgwDFF5GmoaO+NhVXGxAtVNeNPBLmRsztV
        PALOJgGllf6kXoe/Y1DYRkk4na23
X-Google-Smtp-Source: ABdhPJyZ+80wl1FIP/IWNaxWrsJCUDS+vr2Gjmic5ST4+VO/hflD6XFUcVO9bXAlLyzHGNDTU2tpMQ==
X-Received: by 2002:a17:907:376:: with SMTP id rs22mr13259060ejb.47.1595666002741;
        Sat, 25 Jul 2020 01:33:22 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id r17sm2403597edw.68.2020.07.25.01.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 01:33:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: allocate req->work dynamically
Date:   Sat, 25 Jul 2020 11:31:22 +0300
Message-Id: <e42b99fa6acc36ea5880f611182768fee9eb583b.1595664743.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1595664743.git.asml.silence@gmail.com>
References: <cover.1595664743.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->work takes a lot of space and is not needed in hot path, don't
embed it into struct io_kiocb and allocate dynamically. The changes are
pretty straightforward, the only noticible thing is a ->private field
in io_wq_work growing it to 64B, and used to store a reference to the
request.

That shrinks io_kiocb to 200 bytes

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.h    |   1 +
 fs/io_uring.c | 203 +++++++++++++++++++++++++-------------------------
 2 files changed, 104 insertions(+), 100 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index ddaf9614cf9b..1358e022ed4b 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -85,6 +85,7 @@ static inline void wq_list_del(struct io_wq_work_list *list,
 
 struct io_wq_work {
 	struct io_wq_work_node list;
+	void *private;
 	struct files_struct *files;
 	struct mm_struct *mm;
 	const struct cred *creds;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index c7e8e9a1b27b..ef4c6e50aa4f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -544,7 +544,6 @@ enum {
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_NO_FILE_TABLE_BIT,
-	REQ_F_WORK_INITIALIZED_BIT,
 	REQ_F_TASK_PINNED_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
@@ -591,8 +590,6 @@ enum {
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
 	/* doesn't need file table for this request */
 	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
-	/* io_wq_work is initialized */
-	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
 	/* req->task is refcounted */
 	REQ_F_TASK_PINNED	= BIT(REQ_F_TASK_PINNED_BIT),
 };
@@ -600,7 +597,6 @@ enum {
 struct async_poll {
 	struct io_poll_iocb	poll;
 	struct io_poll_iocb	*double_poll;
-	struct io_wq_work	work;
 };
 
 /*
@@ -657,19 +653,13 @@ struct io_kiocb {
 
 	struct percpu_ref	*fixed_file_refs;
 
-	union {
-		/*
-		 * Only commands that never go async can use the below fields,
-		 * obviously. Right now only IORING_OP_POLL_ADD uses them, and
-		 * async armed poll handlers for regular commands. The latter
-		 * restore the work, if needed.
-		 */
-		struct {
-			struct hlist_node	hash_node;
-			struct async_poll	*apoll;
-		};
-		struct io_wq_work	work;
-	};
+	/*
+	 * Right now only IORING_OP_POLL_ADD uses it, and
+	 * async armed poll handlers for regular commands.
+	 */
+	struct hlist_node	hash_node;
+	struct async_poll	*apoll;
+	struct io_wq_work	*work;
 	struct callback_head	task_work;
 };
 
@@ -902,6 +892,7 @@ enum io_mem_account {
 	ACCT_PINNED,
 };
 
+static void io_req_complete(struct io_kiocb *req, long res);
 static bool io_rw_reissue(struct io_kiocb *req, long res);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
@@ -1008,13 +999,12 @@ static inline void req_set_fail_links(struct io_kiocb *req)
  * Note: must call io_req_init_async() for the first time you
  * touch any members of io_wq_work.
  */
-static inline void io_req_init_async(struct io_kiocb *req)
+static inline bool io_req_init_async(struct io_kiocb *req)
 {
-	if (req->flags & REQ_F_WORK_INITIALIZED)
-		return;
-
-	memset(&req->work, 0, sizeof(req->work));
-	req->flags |= REQ_F_WORK_INITIALIZED;
+	if (req->work)
+		return true;
+	req->work = kzalloc(sizeof(*req->work), GFP_KERNEL);
+	return req->work != NULL;
 }
 
 static inline bool io_async_submit(struct io_ring_ctx *ctx)
@@ -1121,72 +1111,85 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 
 static void io_req_clean_work(struct io_kiocb *req)
 {
-	if (!(req->flags & REQ_F_WORK_INITIALIZED))
+	struct io_wq_work *work = req->work;
+
+	if (!work)
 		return;
 
-	if (req->work.mm) {
-		mmdrop(req->work.mm);
-		req->work.mm = NULL;
+	if (work->mm) {
+		mmdrop(work->mm);
+		work->mm = NULL;
 	}
-	if (req->work.creds) {
-		put_cred(req->work.creds);
-		req->work.creds = NULL;
+	if (work->creds) {
+		put_cred(work->creds);
+		work->creds = NULL;
 	}
-	if (req->work.fs) {
-		struct fs_struct *fs = req->work.fs;
+	if (work->fs) {
+		struct fs_struct *fs = work->fs;
 
-		spin_lock(&req->work.fs->lock);
+		spin_lock(&work->fs->lock);
 		if (--fs->users)
 			fs = NULL;
-		spin_unlock(&req->work.fs->lock);
+		spin_unlock(&work->fs->lock);
 		if (fs)
 			free_fs_struct(fs);
 	}
+	kfree(work);
 }
 
-static void io_prep_async_work(struct io_kiocb *req)
+static bool io_prep_async_work(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
+	struct io_wq_work *work;
 
-	io_req_init_async(req);
+	if (!io_req_init_async(req))
+		return false;
+	work = req->work;
+	work->private = req;
 
 	if (req->flags & REQ_F_ISREG) {
 		if (def->hash_reg_file)
-			io_wq_hash_work(&req->work, file_inode(req->file));
+			io_wq_hash_work(work, file_inode(req->file));
 	} else {
 		if (def->unbound_nonreg_file)
-			req->work.flags |= IO_WQ_WORK_UNBOUND;
+			work->flags |= IO_WQ_WORK_UNBOUND;
 	}
-	if (!req->work.mm && def->needs_mm) {
+	if (!work->mm && def->needs_mm) {
 		mmgrab(current->mm);
-		req->work.mm = current->mm;
+		work->mm = current->mm;
 	}
-	if (!req->work.creds)
-		req->work.creds = get_current_cred();
-	if (!req->work.fs && def->needs_fs) {
+	if (!work->creds)
+		work->creds = get_current_cred();
+	if (!work->fs && def->needs_fs) {
 		spin_lock(&current->fs->lock);
 		if (!current->fs->in_exec) {
-			req->work.fs = current->fs;
-			req->work.fs->users++;
+			work->fs = current->fs;
+			work->fs->users++;
 		} else {
-			req->work.flags |= IO_WQ_WORK_CANCEL;
+			work->flags |= IO_WQ_WORK_CANCEL;
 		}
 		spin_unlock(&current->fs->lock);
 	}
 	if (def->needs_fsize)
-		req->work.fsize = rlimit(RLIMIT_FSIZE);
+		work->fsize = rlimit(RLIMIT_FSIZE);
 	else
-		req->work.fsize = RLIM_INFINITY;
+		work->fsize = RLIM_INFINITY;
+	return true;
 }
 
-static void io_prep_async_link(struct io_kiocb *req)
+static bool io_prep_async_link(struct io_kiocb *req)
 {
 	struct io_kiocb *cur;
 
-	io_prep_async_work(req);
-	if (req->flags & REQ_F_LINK_HEAD)
-		list_for_each_entry(cur, &req->link_list, link_list)
-			io_prep_async_work(cur);
+	if (!io_prep_async_work(req))
+		return false;
+	if (!(req->flags & REQ_F_LINK_HEAD))
+		return true;
+
+	list_for_each_entry(cur, &req->link_list, link_list)
+		if (!io_prep_async_work(cur))
+			return false;
+	return true;
 }
 
 static void __io_queue_async_work(struct io_kiocb *req)
@@ -1194,9 +1197,9 @@ static void __io_queue_async_work(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *link = io_prep_linked_timeout(req);
 
-	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(&req->work), req,
-					&req->work, req->flags);
-	io_wq_enqueue(ctx->io_wq, &req->work);
+	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(req->work), req,
+					req->work, req->flags);
+	io_wq_enqueue(ctx->io_wq, req->work);
 
 	if (link)
 		io_queue_linked_timeout(link);
@@ -1205,7 +1208,12 @@ static void __io_queue_async_work(struct io_kiocb *req)
 static void io_queue_async_work(struct io_kiocb *req)
 {
 	/* init ->work of the whole link before punting */
-	io_prep_async_link(req);
+	if (!io_prep_async_link(req)) {
+		req_set_fail_links(req);
+		io_put_req(req);
+		io_req_complete(req, -ENOMEM);
+		return;
+	}
 	__io_queue_async_work(req);
 }
 
@@ -1898,7 +1906,7 @@ static struct io_wq_work *io_steal_work(struct io_kiocb *req)
 		return NULL;
 
 	nxt = io_req_find_next(req);
-	return nxt ? &nxt->work : NULL;
+	return nxt ? nxt->work : NULL;
 }
 
 /*
@@ -3226,8 +3234,9 @@ static int __io_splice_prep(struct io_kiocb *req,
 		 * Splice operation will be punted aync, and here need to
 		 * modify io_wq_work.flags, so initialize io_wq_work firstly.
 		 */
-		io_req_init_async(req);
-		req->work.flags |= IO_WQ_WORK_UNBOUND;
+		if (!io_req_init_async(req))
+			return -ENOMEM;
+		req->work->flags |= IO_WQ_WORK_UNBOUND;
 	}
 
 	return 0;
@@ -3804,8 +3813,9 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	 * leave the 'file' in an undeterminate state, and here need to modify
 	 * io_wq_work.flags, so initialize io_wq_work firstly.
 	 */
-	io_req_init_async(req);
-	req->work.flags |= IO_WQ_WORK_NO_CANCEL;
+	if (!io_req_init_async(req))
+		return -ENOMEM;
+	req->work->flags |= IO_WQ_WORK_NO_CANCEL;
 
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
 		return -EINVAL;
@@ -3847,7 +3857,7 @@ static int io_close(struct io_kiocb *req, bool force_nonblock,
 	}
 
 	/* No ->flush() or already async, safely close from here */
-	ret = filp_close(close->put_file, req->work.files);
+	ret = filp_close(close->put_file, req->work->files);
 	if (ret < 0)
 		req_set_fail_links(req);
 	fput(close->put_file);
@@ -4666,10 +4676,6 @@ static void io_async_task_func(struct callback_head *cb)
 	io_poll_remove_double(req, apoll->double_poll);
 	spin_unlock_irq(&ctx->completion_lock);
 
-	/* restore ->work in case we need to retry again */
-	if (req->flags & REQ_F_WORK_INITIALIZED)
-		memcpy(&req->work, &apoll->work, sizeof(req->work));
-
 	if (!READ_ONCE(apoll->poll.canceled))
 		__io_req_task_submit(req);
 	else
@@ -4761,9 +4767,6 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	apoll->double_poll = NULL;
 
 	req->flags |= REQ_F_POLLED;
-	if (req->flags & REQ_F_WORK_INITIALIZED)
-		memcpy(&apoll->work, &req->work, sizeof(req->work));
-
 	io_get_req_task(req);
 	req->apoll = apoll;
 	INIT_HLIST_NODE(&req->hash_node);
@@ -4782,8 +4785,6 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	if (ret) {
 		io_poll_remove_double(req, apoll->double_poll);
 		spin_unlock_irq(&ctx->completion_lock);
-		if (req->flags & REQ_F_WORK_INITIALIZED)
-			memcpy(&req->work, &apoll->work, sizeof(req->work));
 		kfree(apoll->double_poll);
 		kfree(apoll);
 		return false;
@@ -4826,14 +4827,6 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 		do_complete = __io_poll_remove_one(req, &apoll->poll);
 		if (do_complete) {
 			io_put_req(req);
-			/*
-			 * restore ->work because we will call
-			 * io_req_clean_work below when dropping the
-			 * final reference.
-			 */
-			if (req->flags & REQ_F_WORK_INITIALIZED)
-				memcpy(&req->work, &apoll->work,
-				       sizeof(req->work));
 			kfree(apoll->double_poll);
 			kfree(apoll);
 		}
@@ -5166,7 +5159,7 @@ static int io_timeout(struct io_kiocb *req)
 
 static bool io_cancel_cb(struct io_wq_work *work, void *data)
 {
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_kiocb *req = work->private;
 
 	return req->user_data == (unsigned long) data;
 }
@@ -5434,7 +5427,9 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		if (ret)
 			return ret;
 	}
-	io_prep_async_link(req);
+	if (!io_prep_async_link(req))
+		return -ENOMEM;
+
 	de = kmalloc(sizeof(*de), GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
@@ -5757,7 +5752,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
 {
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_kiocb *req = work->private;
 	struct io_kiocb *timeout;
 	int ret = 0;
 
@@ -5847,9 +5842,10 @@ static int io_grab_files(struct io_kiocb *req)
 	int ret = -EBADF;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_req_init_async(req);
+	if (!io_req_init_async(req))
+		return -ENOMEM;
 
-	if (req->work.files || (req->flags & REQ_F_NO_FILE_TABLE))
+	if (req->work->files || (req->flags & REQ_F_NO_FILE_TABLE))
 		return 0;
 	if (!ctx->ring_file)
 		return -EBADF;
@@ -5865,7 +5861,7 @@ static int io_grab_files(struct io_kiocb *req)
 	if (fcheck(ctx->ring_fd) == ctx->ring_file) {
 		list_add(&req->inflight_entry, &ctx->inflight_list);
 		req->flags |= REQ_F_INFLIGHT;
-		req->work.files = current->files;
+		req->work->files = current->files;
 		ret = 0;
 	}
 	spin_unlock_irq(&ctx->inflight_lock);
@@ -5964,19 +5960,20 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	struct io_kiocb *linked_timeout;
 	struct io_kiocb *nxt;
 	const struct cred *old_creds = NULL;
+	struct io_wq_work *work;
 	int ret;
 
 again:
 	linked_timeout = io_prep_linked_timeout(req);
 
-	if ((req->flags & REQ_F_WORK_INITIALIZED) && req->work.creds &&
-	    req->work.creds != current_cred()) {
+	work = req->work;
+	if (work && work->creds && work->creds != current_cred()) {
 		if (old_creds)
 			revert_creds(old_creds);
-		if (old_creds == req->work.creds)
+		if (old_creds == work->creds)
 			old_creds = NULL; /* restored original creds */
 		else
-			old_creds = override_creds(req->work.creds);
+			old_creds = override_creds(work->creds);
 	}
 
 	ret = io_issue_sqe(req, sqe, true, cs);
@@ -6050,12 +6047,16 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 				goto fail_req;
 		}
 
+		if (!io_req_init_async(req)) {
+			ret = -ENOMEM;
+			goto fail_req;
+		}
+
 		/*
 		 * Never try inline submit of IOSQE_ASYNC is set, go straight
 		 * to async execution.
 		 */
-		io_req_init_async(req);
-		req->work.flags |= IO_WQ_WORK_CONCURRENT;
+		req->work->flags |= IO_WQ_WORK_CONCURRENT;
 		io_queue_async_work(req);
 	} else {
 		__io_queue_sqe(req, sqe, cs);
@@ -6231,6 +6232,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->file = NULL;
 	req->ctx = ctx;
 	req->flags = 0;
+	req->work = NULL;
 	/* one is dropped after submission, the other at completion */
 	refcount_set(&req->refs, 2);
 	req->task = current;
@@ -6253,11 +6255,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	id = READ_ONCE(sqe->personality);
 	if (id) {
-		io_req_init_async(req);
-		req->work.creds = idr_find(&ctx->personality_idr, id);
-		if (unlikely(!req->work.creds))
+		if (!io_req_init_async(req))
+			return -ENOMEM;
+		req->work->creds = idr_find(&ctx->personality_idr, id);
+		if (unlikely(!req->work->creds))
 			return -EINVAL;
-		get_cred(req->work.creds);
+		get_cred(req->work->creds);
 	}
 
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
@@ -7237,7 +7240,7 @@ static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 
 static void io_free_work(struct io_wq_work *work)
 {
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_kiocb *req = work->private;
 
 	/* Consider that io_steal_work() relies on this ref */
 	io_put_req(req);
@@ -7853,7 +7856,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (req->work.files != files)
+			if (req->work->files != files)
 				continue;
 			/* req is being completed, ignore */
 			if (!refcount_inc_not_zero(&req->refs))
@@ -7894,7 +7897,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				continue;
 			}
 		} else {
-			io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
+			io_wq_cancel_work(ctx->io_wq, cancel_req->work);
 			io_put_req(cancel_req);
 		}
 
@@ -7905,7 +7908,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 
 static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 {
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_kiocb *req = work->private;
 	struct task_struct *task = data;
 
 	return req->task == task;
-- 
2.24.0

