Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE1E29091F
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410536AbgJPQCp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395555AbgJPQCp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:45 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB629C061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:45 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id j8so1759222pjy.5
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o0tESetaNp0Vuv9pNA8m29tL7b0DZuA0Ei0Ig93can8=;
        b=ClG65eLv4GEuT5cwHkU3VMXa2Q7ATpzWPTG5DKtNA4a4lVgqGSPLw/dqPeQ8MjjlLd
         Za8nJJkJziCAPtDxHVQHEerEmOnIpIlaJJO2I/QwF5r9PNMJIdcqq77Xb4eh63ugyEfx
         87N08Iz4StPwE00sAth45jb61z+6Lkq2dKAVP/RzFB39/bZq6b1iK/hZXGq1xdy/0sD7
         KbBGcF+t0QRFlruNGVKsv8lBGKHJhHcQFhIB+Gpv7oy7QfdW+SYIkW8xgrAjKKhyqVlt
         Dk5EvCm9drKNbRumdoS8hs0182IFamqZPUAyTEyfy1w32xA5frtH69EdLDQku2rUqGTN
         8K4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o0tESetaNp0Vuv9pNA8m29tL7b0DZuA0Ei0Ig93can8=;
        b=jBR8l3BmumPsYgbtFHCg8R8fkuFrI8/7cVIQhbnjmjyZUDBcajZGCuDDQghA95Fche
         n5XFAs6VdHMcm+4sXJYQgF4iln4lf0BOVOpnj/uMywqGr5a2JxSN1OhMvqLQH/vDDR/h
         l0OaZivQSjLf22267r6NiOjH8uXgfxOXbhuPcFZliTBO2769TJ+pHua9VK2h9eTkkP63
         xNQsp8V1OLAFk1lCz3v3zqeSjRKx3uecRJ3UfyTUGOUx/Itr1J3cE3d8W906EHfLecZS
         NTMD+Fwt7sO7bRofCXn6nASvSJxPamkczuPdvnn5zTjnaNoG8UWawDGXo7P+ZwxwbV/0
         Cfdw==
X-Gm-Message-State: AOAM532RuqwOTMpPbfElJgG8/6AF1Vsmm3dKIc+OkbcQLwVQ1xXerGKx
        OKcQaEARNz4DerL428KodWh0PVWD2hHwcYYI
X-Google-Smtp-Source: ABdhPJyxWuatLnVQ/+gl1fnkM/NjviLoS92kl8DJh7XO1dpbx2v80sHQyMvv1/0CxZhbN3WQWbizKw==
X-Received: by 2002:a17:902:9f8b:b029:d2:8cba:9011 with SMTP id g11-20020a1709029f8bb02900d28cba9011mr4693550plq.73.1602864164073;
        Fri, 16 Oct 2020 09:02:44 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:43 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/18] io_uring: pass required context in as flags
Date:   Fri, 16 Oct 2020 10:02:18 -0600
Message-Id: <20201016160224.1575329-13-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have a number of bits that decide what context to inherit. Set up
io-wq flags for these instead. This is in preparation for always having
the various members set, but not always needing them for all requests.

No intended functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    |  10 +++--
 fs/io-wq.h    |   6 +++
 fs/io_uring.c | 100 ++++++++++++++++++++------------------------------
 3 files changed, 52 insertions(+), 64 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 149fd2f0927e..e636898f8a1f 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -448,6 +448,8 @@ static inline void io_wq_switch_blkcg(struct io_worker *worker,
 				      struct io_wq_work *work)
 {
 #ifdef CONFIG_BLK_CGROUP
+	if (!(work->flags & IO_WQ_WORK_BLKCG))
+		return;
 	if (work->blkcg_css != worker->blkcg_css) {
 		kthread_associate_blkcg(work->blkcg_css);
 		worker->blkcg_css = work->blkcg_css;
@@ -470,17 +472,17 @@ static void io_wq_switch_creds(struct io_worker *worker,
 static void io_impersonate_work(struct io_worker *worker,
 				struct io_wq_work *work)
 {
-	if (work->files && current->files != work->files) {
+	if ((work->flags & IO_WQ_WORK_FILES) && current->files != work->files) {
 		task_lock(current);
 		current->files = work->files;
 		current->nsproxy = work->nsproxy;
 		task_unlock(current);
 	}
-	if (work->fs && current->fs != work->fs)
+	if ((work->flags & IO_WQ_WORK_FS) && current->fs != work->fs)
 		current->fs = work->fs;
-	if (work->mm != worker->mm)
+	if ((work->flags & IO_WQ_WORK_MM) && work->mm != worker->mm)
 		io_wq_switch_mm(worker, work);
-	if (worker->cur_creds != work->creds)
+	if ((work->flags & IO_WQ_WORK_CREDS) && worker->cur_creds != work->creds)
 		io_wq_switch_creds(worker, work);
 	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = work->fsize;
 	io_wq_switch_blkcg(worker, work);
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 84bcf6a85523..31a29023605a 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -10,6 +10,12 @@ enum {
 	IO_WQ_WORK_NO_CANCEL	= 8,
 	IO_WQ_WORK_CONCURRENT	= 16,
 
+	IO_WQ_WORK_FILES	= 32,
+	IO_WQ_WORK_FS		= 64,
+	IO_WQ_WORK_MM		= 128,
+	IO_WQ_WORK_CREDS	= 256,
+	IO_WQ_WORK_BLKCG	= 512,
+
 	IO_WQ_HASH_SHIFT	= 24,	/* upper 8 bits are used for hash key */
 };
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2c83c2688ec5..6f6f6bcef82d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -729,8 +729,6 @@ struct io_submit_state {
 };
 
 struct io_op_def {
-	/* needs current->mm setup, does mm access */
-	unsigned		needs_mm : 1;
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
 	/* don't fail if file grab fails */
@@ -741,10 +739,6 @@ struct io_op_def {
 	unsigned		unbound_nonreg_file : 1;
 	/* opcode is not supported by this kernel */
 	unsigned		not_supported : 1;
-	/* needs file table */
-	unsigned		file_table : 1;
-	/* needs ->fs */
-	unsigned		needs_fs : 1;
 	/* set if opcode supports polled "wait" */
 	unsigned		pollin : 1;
 	unsigned		pollout : 1;
@@ -754,45 +748,42 @@ struct io_op_def {
 	unsigned		needs_fsize : 1;
 	/* must always have async data allocated */
 	unsigned		needs_async_data : 1;
-	/* needs blkcg context, issues async io potentially */
-	unsigned		needs_blkcg : 1;
 	/* size of async data needed, if any */
 	unsigned short		async_size;
+	unsigned		work_flags;
 };
 
 static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_NOP] = {},
 	[IORING_OP_READV] = {
-		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
 		.needs_async_data	= 1,
-		.needs_blkcg		= 1,
 		.async_size		= sizeof(struct io_async_rw),
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_WRITEV] = {
-		.needs_mm		= 1,
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.needs_fsize		= 1,
 		.needs_async_data	= 1,
-		.needs_blkcg		= 1,
 		.async_size		= sizeof(struct io_async_rw),
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
-		.needs_blkcg		= 1,
+		.work_flags		= IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_READ_FIXED] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
-		.needs_blkcg		= 1,
 		.async_size		= sizeof(struct io_async_rw),
+		.work_flags		= IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_WRITE_FIXED] = {
 		.needs_file		= 1,
@@ -800,8 +791,8 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.needs_fsize		= 1,
-		.needs_blkcg		= 1,
 		.async_size		= sizeof(struct io_async_rw),
+		.work_flags		= IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_POLL_ADD] = {
 		.needs_file		= 1,
@@ -810,137 +801,123 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_POLL_REMOVE] = {},
 	[IORING_OP_SYNC_FILE_RANGE] = {
 		.needs_file		= 1,
-		.needs_blkcg		= 1,
+		.work_flags		= IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_SENDMSG] = {
-		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
-		.needs_fs		= 1,
 		.pollout		= 1,
 		.needs_async_data	= 1,
-		.needs_blkcg		= 1,
 		.async_size		= sizeof(struct io_async_msghdr),
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG |
+						IO_WQ_WORK_FS,
 	},
 	[IORING_OP_RECVMSG] = {
-		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
-		.needs_fs		= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
 		.needs_async_data	= 1,
-		.needs_blkcg		= 1,
 		.async_size		= sizeof(struct io_async_msghdr),
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG |
+						IO_WQ_WORK_FS,
 	},
 	[IORING_OP_TIMEOUT] = {
-		.needs_mm		= 1,
 		.needs_async_data	= 1,
 		.async_size		= sizeof(struct io_timeout_data),
+		.work_flags		= IO_WQ_WORK_MM,
 	},
 	[IORING_OP_TIMEOUT_REMOVE] = {},
 	[IORING_OP_ACCEPT] = {
-		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
-		.file_table		= 1,
 		.pollin			= 1,
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES,
 	},
 	[IORING_OP_ASYNC_CANCEL] = {},
 	[IORING_OP_LINK_TIMEOUT] = {
-		.needs_mm		= 1,
 		.needs_async_data	= 1,
 		.async_size		= sizeof(struct io_timeout_data),
+		.work_flags		= IO_WQ_WORK_MM,
 	},
 	[IORING_OP_CONNECT] = {
-		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.needs_async_data	= 1,
 		.async_size		= sizeof(struct io_async_connect),
+		.work_flags		= IO_WQ_WORK_MM,
 	},
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
 		.needs_fsize		= 1,
-		.needs_blkcg		= 1,
+		.work_flags		= IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_OPENAT] = {
-		.file_table		= 1,
-		.needs_fs		= 1,
-		.needs_blkcg		= 1,
+		.work_flags		= IO_WQ_WORK_FILES | IO_WQ_WORK_BLKCG |
+						IO_WQ_WORK_FS,
 	},
 	[IORING_OP_CLOSE] = {
 		.needs_file		= 1,
 		.needs_file_no_error	= 1,
-		.file_table		= 1,
-		.needs_blkcg		= 1,
+		.work_flags		= IO_WQ_WORK_FILES | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_FILES_UPDATE] = {
-		.needs_mm		= 1,
-		.file_table		= 1,
+		.work_flags		= IO_WQ_WORK_FILES | IO_WQ_WORK_MM,
 	},
 	[IORING_OP_STATX] = {
-		.needs_mm		= 1,
-		.needs_fs		= 1,
-		.file_table		= 1,
-		.needs_blkcg		= 1,
+		.work_flags		= IO_WQ_WORK_FILES | IO_WQ_WORK_MM |
+						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_READ] = {
-		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
-		.needs_blkcg		= 1,
 		.async_size		= sizeof(struct io_async_rw),
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_WRITE] = {
-		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.needs_fsize		= 1,
-		.needs_blkcg		= 1,
 		.async_size		= sizeof(struct io_async_rw),
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
-		.needs_blkcg		= 1,
+		.work_flags		= IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_MADVISE] = {
-		.needs_mm		= 1,
-		.needs_blkcg		= 1,
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_SEND] = {
-		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
-		.needs_blkcg		= 1,
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_RECV] = {
-		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
-		.needs_blkcg		= 1,
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_OPENAT2] = {
-		.file_table		= 1,
-		.needs_fs		= 1,
-		.needs_blkcg		= 1,
+		.work_flags		= IO_WQ_WORK_FILES | IO_WQ_WORK_FS |
+						IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_EPOLL_CTL] = {
 		.unbound_nonreg_file	= 1,
-		.file_table		= 1,
+		.work_flags		= IO_WQ_WORK_FILES,
 	},
 	[IORING_OP_SPLICE] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
-		.needs_blkcg		= 1,
+		.work_flags		= IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_PROVIDE_BUFFERS] = {},
 	[IORING_OP_REMOVE_BUFFERS] = {},
@@ -1031,7 +1008,7 @@ static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
 static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
 				   struct io_kiocb *req)
 {
-	if (!io_op_defs[req->opcode].needs_mm)
+	if (!(io_op_defs[req->opcode].work_flags & IO_WQ_WORK_MM))
 		return 0;
 	return __io_sq_thread_acquire_mm(ctx);
 }
@@ -1224,7 +1201,8 @@ static void io_prep_async_work(struct io_kiocb *req)
 		if (def->unbound_nonreg_file)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
-	if (!req->work.files && io_op_defs[req->opcode].file_table &&
+	if (!req->work.files &&
+	    (io_op_defs[req->opcode].work_flags & IO_WQ_WORK_FILES) &&
 	    !(req->flags & REQ_F_NO_FILE_TABLE)) {
 		req->work.files = get_files_struct(current);
 		get_nsproxy(current->nsproxy);
@@ -1235,12 +1213,12 @@ static void io_prep_async_work(struct io_kiocb *req)
 		list_add(&req->inflight_entry, &ctx->inflight_list);
 		spin_unlock_irq(&ctx->inflight_lock);
 	}
-	if (!req->work.mm && def->needs_mm) {
+	if (!req->work.mm && (def->work_flags & IO_WQ_WORK_MM)) {
 		mmgrab(current->mm);
 		req->work.mm = current->mm;
 	}
 #ifdef CONFIG_BLK_CGROUP
-	if (!req->work.blkcg_css && def->needs_blkcg) {
+	if (!req->work.blkcg_css && (def->work_flags & IO_WQ_WORK_BLKCG)) {
 		rcu_read_lock();
 		req->work.blkcg_css = blkcg_css();
 		/*
@@ -1254,7 +1232,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 #endif
 	if (!req->work.creds)
 		req->work.creds = get_current_cred();
-	if (!req->work.fs && def->needs_fs) {
+	if (!req->work.fs && (def->work_flags & IO_WQ_WORK_FS)) {
 		spin_lock(&current->fs->lock);
 		if (!current->fs->in_exec) {
 			req->work.fs = current->fs;
@@ -1268,6 +1246,8 @@ static void io_prep_async_work(struct io_kiocb *req)
 		req->work.fsize = rlimit(RLIMIT_FSIZE);
 	else
 		req->work.fsize = RLIM_INFINITY;
+
+	req->work.flags |= def->work_flags;
 }
 
 static void io_prep_async_link(struct io_kiocb *req)
-- 
2.28.0

