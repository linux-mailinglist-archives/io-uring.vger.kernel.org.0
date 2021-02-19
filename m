Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54D131FDA9
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhBSRLR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhBSRLH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:11:07 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73869C061356
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:27 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id q9so5093906ilo.1
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2qFV4bOZadw8fjv6Hbm0w1BAyg72mMv6lEgh1wTRHvA=;
        b=ouKlrW4Lxl0OIAaKEmjqtUpvNxGp46tt2dE+gsia+N1IIxe0s4Of4xTnpwlONPysAT
         5nuoHepBMDRRPz+YWejMCwAPS2ENjRxkSnhHBMpvFL8La9bJWC8HgC6lhRT1+2emgexU
         m3xE62QuclQggzUC3Rrl4plK0dB9JaOv29W4l5vyVMVZPHrdx3WQBimAnxY2gGYaqklC
         QwrH6hLY5XGtOj18FeU4rRnuCWdtsKZLyplSYW/Fk5a0yZgK8Sx0+hGKl8/+pEmERTKS
         jNI4L1BpoGuZDTPuAyY9P0HFI7u6kSNctgoookdvyytaNG//XFEsP7mPpxOkGG3LPhVX
         NvuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2qFV4bOZadw8fjv6Hbm0w1BAyg72mMv6lEgh1wTRHvA=;
        b=NjkE5sA2wSDQSB1RKH9Orwa221NXdv0jXZRDyUdFAhDcVmfk+RjjtR6lN+JRZfPLif
         01Nmq8jjfmIICfMXTuBLnQjK0m2RzOsNmGR6B0uQblAxYR0O7+N8KXdj9nwdVezGajiG
         jLzFrD6Gv5RbrPfSU03jla5748lKaV15NentIC0TyY5cdWiADox8sPh6HCJv/64CpZ9L
         mSXqQPPg6s4z7+AmBlk00+w7SEmKS0D9e8TrJ3hBK7TuTU/N0mUHf9rYA5nYlwy9WE9X
         85AdIRnZAjRtTfOIz6t8JCkOpKaYjwKNMwLl/lKJhDKXoVJAoBnkkO+wghkk2OxELSlY
         E1jw==
X-Gm-Message-State: AOAM5318dpMZjgPz+CjRXxCu82OcprmvDd0Oh+Lki7/zQvobbO6Xq2XB
        cszfDZnhX97pF3civKYiUzE4owqsWQoFtC4X
X-Google-Smtp-Source: ABdhPJx+TfDgGOQrCwwJ67znRXnpTPiNSZ8Zm+BYyPYH+ifj0zN+flIkyaNVtrZ58hLBNRZfvC3+zA==
X-Received: by 2002:a05:6e02:1bec:: with SMTP id y12mr4593167ilv.214.1613754626571;
        Fri, 19 Feb 2021 09:10:26 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:26 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/18] io_uring: remove any grabbing of context
Date:   Fri, 19 Feb 2021 10:10:03 -0700
Message-Id: <20210219171010.281878-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The async workers are siblings of the task itself, so by definition we
have all the state that we need. Remove any of the state grabbing that
we have, and requests flagging what they need.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.h    |   7 --
 fs/io_uring.c | 215 ++------------------------------------------------
 2 files changed, 7 insertions(+), 215 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index d2cf284b4641..ab8029bf77b8 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -11,13 +11,6 @@ enum {
 	IO_WQ_WORK_UNBOUND	= 4,
 	IO_WQ_WORK_CONCURRENT	= 16,
 
-	IO_WQ_WORK_FILES	= 32,
-	IO_WQ_WORK_FS		= 64,
-	IO_WQ_WORK_MM		= 128,
-	IO_WQ_WORK_CREDS	= 256,
-	IO_WQ_WORK_BLKCG	= 512,
-	IO_WQ_WORK_FSIZE	= 1024,
-
 	IO_WQ_HASH_SHIFT	= 24,	/* upper 8 bits are used for hash key */
 };
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index b0a7a2d3ab4f..872d2f1c6ea5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -837,7 +837,6 @@ struct io_op_def {
 	unsigned		plug : 1;
 	/* size of async data needed, if any */
 	unsigned short		async_size;
-	unsigned		work_flags;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -850,7 +849,6 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_async_data	= 1,
 		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
-		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_WRITEV] = {
 		.needs_file		= 1,
@@ -860,12 +858,9 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_async_data	= 1,
 		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
-		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG |
-						IO_WQ_WORK_FSIZE,
 	},
 	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
-		.work_flags		= IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_READ_FIXED] = {
 		.needs_file		= 1,
@@ -873,7 +868,6 @@ static const struct io_op_def io_op_defs[] = {
 		.pollin			= 1,
 		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
-		.work_flags		= IO_WQ_WORK_BLKCG | IO_WQ_WORK_MM,
 	},
 	[IORING_OP_WRITE_FIXED] = {
 		.needs_file		= 1,
@@ -882,8 +876,6 @@ static const struct io_op_def io_op_defs[] = {
 		.pollout		= 1,
 		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
-		.work_flags		= IO_WQ_WORK_BLKCG | IO_WQ_WORK_FSIZE |
-						IO_WQ_WORK_MM,
 	},
 	[IORING_OP_POLL_ADD] = {
 		.needs_file		= 1,
@@ -892,7 +884,6 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_POLL_REMOVE] = {},
 	[IORING_OP_SYNC_FILE_RANGE] = {
 		.needs_file		= 1,
-		.work_flags		= IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_SENDMSG] = {
 		.needs_file		= 1,
@@ -900,8 +891,6 @@ static const struct io_op_def io_op_defs[] = {
 		.pollout		= 1,
 		.needs_async_data	= 1,
 		.async_size		= sizeof(struct io_async_msghdr),
-		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG |
-						IO_WQ_WORK_FS,
 	},
 	[IORING_OP_RECVMSG] = {
 		.needs_file		= 1,
@@ -910,29 +899,23 @@ static const struct io_op_def io_op_defs[] = {
 		.buffer_select		= 1,
 		.needs_async_data	= 1,
 		.async_size		= sizeof(struct io_async_msghdr),
-		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG |
-						IO_WQ_WORK_FS,
 	},
 	[IORING_OP_TIMEOUT] = {
 		.needs_async_data	= 1,
 		.async_size		= sizeof(struct io_timeout_data),
-		.work_flags		= IO_WQ_WORK_MM,
 	},
 	[IORING_OP_TIMEOUT_REMOVE] = {
 		/* used by timeout updates' prep() */
-		.work_flags		= IO_WQ_WORK_MM,
 	},
 	[IORING_OP_ACCEPT] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
-		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES,
 	},
 	[IORING_OP_ASYNC_CANCEL] = {},
 	[IORING_OP_LINK_TIMEOUT] = {
 		.needs_async_data	= 1,
 		.async_size		= sizeof(struct io_timeout_data),
-		.work_flags		= IO_WQ_WORK_MM,
 	},
 	[IORING_OP_CONNECT] = {
 		.needs_file		= 1,
@@ -940,25 +923,17 @@ static const struct io_op_def io_op_defs[] = {
 		.pollout		= 1,
 		.needs_async_data	= 1,
 		.async_size		= sizeof(struct io_async_connect),
-		.work_flags		= IO_WQ_WORK_MM,
 	},
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
-		.work_flags		= IO_WQ_WORK_BLKCG | IO_WQ_WORK_FSIZE,
 	},
 	[IORING_OP_OPENAT] = {
-		.work_flags		= IO_WQ_WORK_FILES | IO_WQ_WORK_BLKCG |
-						IO_WQ_WORK_FS | IO_WQ_WORK_MM,
 	},
 	[IORING_OP_CLOSE] = {
-		.work_flags		= IO_WQ_WORK_FILES | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_FILES_UPDATE] = {
-		.work_flags		= IO_WQ_WORK_FILES | IO_WQ_WORK_MM,
 	},
 	[IORING_OP_STATX] = {
-		.work_flags		= IO_WQ_WORK_FILES | IO_WQ_WORK_MM |
-						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_READ] = {
 		.needs_file		= 1,
@@ -967,7 +942,6 @@ static const struct io_op_def io_op_defs[] = {
 		.buffer_select		= 1,
 		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
-		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_WRITE] = {
 		.needs_file		= 1,
@@ -975,42 +949,32 @@ static const struct io_op_def io_op_defs[] = {
 		.pollout		= 1,
 		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
-		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG |
-						IO_WQ_WORK_FSIZE,
 	},
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
-		.work_flags		= IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_MADVISE] = {
-		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_SEND] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
-		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_RECV] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
-		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_OPENAT2] = {
-		.work_flags		= IO_WQ_WORK_FILES | IO_WQ_WORK_FS |
-						IO_WQ_WORK_BLKCG | IO_WQ_WORK_MM,
 	},
 	[IORING_OP_EPOLL_CTL] = {
 		.unbound_nonreg_file	= 1,
-		.work_flags		= IO_WQ_WORK_FILES,
 	},
 	[IORING_OP_SPLICE] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
-		.work_flags		= IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_PROVIDE_BUFFERS] = {},
 	[IORING_OP_REMOVE_BUFFERS] = {},
@@ -1023,12 +987,8 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 	},
 	[IORING_OP_RENAMEAT] = {
-		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
-						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_UNLINKAT] = {
-		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
-						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
 	},
 };
 
@@ -1126,8 +1086,7 @@ static bool io_match_task(struct io_kiocb *head,
 			continue;
 		if (req->file && req->file->f_op == &io_uring_fops)
 			return true;
-		if ((req->work.flags & IO_WQ_WORK_FILES) &&
-		    req->work.identity->files == files)
+		if (req->work.identity->files == files)
 			return true;
 	}
 	return false;
@@ -1204,20 +1163,15 @@ static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
 static int __io_sq_thread_acquire_mm_files(struct io_ring_ctx *ctx,
 					   struct io_kiocb *req)
 {
-	const struct io_op_def *def = &io_op_defs[req->opcode];
 	int ret;
 
-	if (def->work_flags & IO_WQ_WORK_MM) {
-		ret = __io_sq_thread_acquire_mm(ctx);
-		if (unlikely(ret))
-			return ret;
-	}
+	ret = __io_sq_thread_acquire_mm(ctx);
+	if (unlikely(ret))
+		return ret;
 
-	if (def->needs_file || (def->work_flags & IO_WQ_WORK_FILES)) {
-		ret = __io_sq_thread_acquire_files(ctx);
-		if (unlikely(ret))
-			return ret;
-	}
+	ret = __io_sq_thread_acquire_files(ctx);
+	if (unlikely(ret))
+		return ret;
 
 	return 0;
 }
@@ -1401,28 +1355,6 @@ static void io_req_clean_work(struct io_kiocb *req)
 	if (!(req->flags & REQ_F_WORK_INITIALIZED))
 		return;
 
-	if (req->work.flags & IO_WQ_WORK_MM)
-		mmdrop(req->work.identity->mm);
-#ifdef CONFIG_BLK_CGROUP
-	if (req->work.flags & IO_WQ_WORK_BLKCG)
-		css_put(req->work.identity->blkcg_css);
-#endif
-	if (req->work.flags & IO_WQ_WORK_CREDS)
-		put_cred(req->work.identity->creds);
-	if (req->work.flags & IO_WQ_WORK_FS) {
-		struct fs_struct *fs = req->work.identity->fs;
-
-		spin_lock(&req->work.identity->fs->lock);
-		if (--fs->users)
-			fs = NULL;
-		spin_unlock(&req->work.identity->fs->lock);
-		if (fs)
-			free_fs_struct(fs);
-	}
-	if (req->work.flags & IO_WQ_WORK_FILES) {
-		put_files_struct(req->work.identity->files);
-		put_nsproxy(req->work.identity->nsproxy);
-	}
 	if (req->flags & REQ_F_INFLIGHT) {
 		struct io_ring_ctx *ctx = req->ctx;
 		struct io_uring_task *tctx = req->task->io_uring;
@@ -1437,56 +1369,9 @@ static void io_req_clean_work(struct io_kiocb *req)
 	}
 
 	req->flags &= ~REQ_F_WORK_INITIALIZED;
-	req->work.flags &= ~(IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG | IO_WQ_WORK_FS |
-			     IO_WQ_WORK_CREDS | IO_WQ_WORK_FILES);
 	io_put_identity(req->task->io_uring, req);
 }
 
-/*
- * Create a private copy of io_identity, since some fields don't match
- * the current context.
- */
-static bool io_identity_cow(struct io_kiocb *req)
-{
-	struct io_uring_task *tctx = current->io_uring;
-	const struct cred *creds = NULL;
-	struct io_identity *id;
-
-	if (req->work.flags & IO_WQ_WORK_CREDS)
-		creds = req->work.identity->creds;
-
-	id = kmemdup(req->work.identity, sizeof(*id), GFP_KERNEL);
-	if (unlikely(!id)) {
-		req->work.flags |= IO_WQ_WORK_CANCEL;
-		return false;
-	}
-
-	/*
-	 * We can safely just re-init the creds we copied  Either the field
-	 * matches the current one, or we haven't grabbed it yet. The only
-	 * exception is ->creds, through registered personalities, so handle
-	 * that one separately.
-	 */
-	io_init_identity(id);
-	if (creds)
-		id->creds = creds;
-
-	/* add one for this request */
-	refcount_inc(&id->count);
-
-	/* drop tctx and req identity references, if needed */
-	if (tctx->identity != &tctx->__identity &&
-	    refcount_dec_and_test(&tctx->identity->count))
-		kfree(tctx->identity);
-	if (req->work.identity != &tctx->__identity &&
-	    refcount_dec_and_test(&req->work.identity->count))
-		kfree(req->work.identity);
-
-	req->work.identity = id;
-	tctx->identity = id;
-	return true;
-}
-
 static void io_req_track_inflight(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1501,79 +1386,6 @@ static void io_req_track_inflight(struct io_kiocb *req)
 	}
 }
 
-static bool io_grab_identity(struct io_kiocb *req)
-{
-	const struct io_op_def *def = &io_op_defs[req->opcode];
-	struct io_identity *id = req->work.identity;
-
-	if (def->work_flags & IO_WQ_WORK_FSIZE) {
-		if (id->fsize != rlimit(RLIMIT_FSIZE))
-			return false;
-		req->work.flags |= IO_WQ_WORK_FSIZE;
-	}
-#ifdef CONFIG_BLK_CGROUP
-	if (!(req->work.flags & IO_WQ_WORK_BLKCG) &&
-	    (def->work_flags & IO_WQ_WORK_BLKCG)) {
-		rcu_read_lock();
-		if (id->blkcg_css != blkcg_css()) {
-			rcu_read_unlock();
-			return false;
-		}
-		/*
-		 * This should be rare, either the cgroup is dying or the task
-		 * is moving cgroups. Just punt to root for the handful of ios.
-		 */
-		if (css_tryget_online(id->blkcg_css))
-			req->work.flags |= IO_WQ_WORK_BLKCG;
-		rcu_read_unlock();
-	}
-#endif
-	if (!(req->work.flags & IO_WQ_WORK_CREDS)) {
-		if (id->creds != current_cred())
-			return false;
-		get_cred(id->creds);
-		req->work.flags |= IO_WQ_WORK_CREDS;
-	}
-#ifdef CONFIG_AUDIT
-	if (!uid_eq(current->loginuid, id->loginuid) ||
-	    current->sessionid != id->sessionid)
-		return false;
-#endif
-	if (!(req->work.flags & IO_WQ_WORK_FS) &&
-	    (def->work_flags & IO_WQ_WORK_FS)) {
-		if (current->fs != id->fs)
-			return false;
-		spin_lock(&id->fs->lock);
-		if (!id->fs->in_exec) {
-			id->fs->users++;
-			req->work.flags |= IO_WQ_WORK_FS;
-		} else {
-			req->work.flags |= IO_WQ_WORK_CANCEL;
-		}
-		spin_unlock(&current->fs->lock);
-	}
-	if (!(req->work.flags & IO_WQ_WORK_FILES) &&
-	    (def->work_flags & IO_WQ_WORK_FILES) &&
-	    !(req->flags & REQ_F_NO_FILE_TABLE)) {
-		if (id->files != current->files ||
-		    id->nsproxy != current->nsproxy)
-			return false;
-		atomic_inc(&id->files->count);
-		get_nsproxy(id->nsproxy);
-		req->work.flags |= IO_WQ_WORK_FILES;
-		io_req_track_inflight(req);
-	}
-	if (!(req->work.flags & IO_WQ_WORK_MM) &&
-	    (def->work_flags & IO_WQ_WORK_MM)) {
-		if (id->mm != current->mm)
-			return false;
-		mmgrab(id->mm);
-		req->work.flags |= IO_WQ_WORK_MM;
-	}
-
-	return true;
-}
-
 static void io_prep_async_work(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
@@ -1591,17 +1403,6 @@ static void io_prep_async_work(struct io_kiocb *req)
 		if (def->unbound_nonreg_file)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
-
-	/* if we fail grabbing identity, we must COW, regrab, and retry */
-	if (io_grab_identity(req))
-		return;
-
-	if (!io_identity_cow(req))
-		return;
-
-	/* can't fail at this point */
-	if (!io_grab_identity(req))
-		WARN_ON(1);
 }
 
 static void io_prep_async_link(struct io_kiocb *req)
@@ -6592,7 +6393,6 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	int ret;
 
 	if ((req->flags & REQ_F_WORK_INITIALIZED) &&
-	    (req->work.flags & IO_WQ_WORK_CREDS) &&
 	    req->work.identity->creds != current_cred())
 		old_creds = override_creds(req->work.identity->creds);
 
@@ -6732,7 +6532,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		__io_req_init_async(req);
 		get_cred(iod->creds);
 		req->work.identity = iod;
-		req->work.flags |= IO_WQ_WORK_CREDS;
 	}
 
 	state = &ctx->submit_state;
-- 
2.30.0

