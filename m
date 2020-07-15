Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6189122092B
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 11:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730852AbgGOJtB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 05:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730612AbgGOJtA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 05:49:00 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C32C061755
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 02:49:00 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id b15so1126458edy.7
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 02:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=vnzfwtq5LMQnPpWDqPKLJsoNGiqJupUQaIbGIfDo8nc=;
        b=ficD/5VPfNiQgQdi2oFE9qXEEKx5zCG15mFgOsuOwBTxIGYFyiqqpMpGEFztCswS/3
         EFbvvWLQRm6LK6F6pBPR0wQVYiyqfjQJ6acGRpRICZToCjXfX/XFMVpl9/0uIHRFdvRS
         yWIQt7fzZ4x62JvfMMnVhZ2pbzAxVd23rQhgux5obs9UJ7R5vjSnYrMug6KrZ3xASnid
         niyO1aMc+cBamRfkykhFlDLBU7wQQeF4TLPq3uTaHYta8b1oOniRUWYj0fF2CWGh0b4d
         29aY+KrNoptZUm5toZQItLu5k9x5qs0CoKhNDh2ToSMn/rmTmvd0tkN+YUE3H+rDgyY0
         Ywmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vnzfwtq5LMQnPpWDqPKLJsoNGiqJupUQaIbGIfDo8nc=;
        b=VS6X8hkSRRUT5hxNGchwcPoZi75mWIOx3dfidgboX2ixfMp55YucyY6hrtZAr+kyI4
         aIcLm1/4OKUO3bH11zbLvMFv4gbF/ihaUYYU2kYEGZEpZYWTxOk4J1rrhHLcSQuXahQU
         rzqMWSdFW0JX54G3H1NCUiF7b25jNRc57FF2Dgp1exp6IcW/eKAx3PTxBn7i4kbsbXZL
         00E4fSaZEcrWGSgESqyNkK9q/B4YNPCAhYoIAWitSC8QCccl76GgpgssIt6rYUDjucek
         lMC24PkKzFt602KTyb+dr9FLpD4K3csRYnUSsJsWoack7Xa6loxiN7A9bWBOvRDluPxW
         7RPA==
X-Gm-Message-State: AOAM532GGUo0RtA8+IP/jyIriopzi9JEG1sqzSVAl4CCoKcsLMKn0DDs
        f6d2tDT+HFhmoyclDh6axoldIPxW
X-Google-Smtp-Source: ABdhPJw45goe6fIIAG2SpVggvt3uYeyX7+NqK4sev+a//V5Qvg739Cp8Ic13uhNpnfd/0255W3xmOQ==
X-Received: by 2002:a50:c044:: with SMTP id u4mr2334586edd.366.1594806539129;
        Wed, 15 Jul 2020 02:48:59 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id d13sm1635690edv.12.2020.07.15.02.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 02:48:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring/io-wq: move RLIMIT_FSIZE to io-wq
Date:   Wed, 15 Jul 2020 12:46:52 +0300
Message-Id: <99d19babe8efe05e3ec85c440705801b40ba40e6.1594806332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594806332.git.asml.silence@gmail.com>
References: <cover.1594806332.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

RLIMIT_SIZE in needed only for execution from an io-wq context, hence
move all preparations from hot path to io-wq work setup.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    |  1 +
 fs/io-wq.h    |  1 +
 fs/io_uring.c | 22 +++++++++-------------
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 72f759e1d6eb..8702d3c3b291 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -462,6 +462,7 @@ static void io_impersonate_work(struct io_worker *worker,
 		io_wq_switch_mm(worker, work);
 	if (worker->cur_creds != work->creds)
 		io_wq_switch_creds(worker, work);
+	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = work->fsize;
 }
 
 static void io_assign_current_work(struct io_worker *worker,
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 114f12ec2d65..ddaf9614cf9b 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -89,6 +89,7 @@ struct io_wq_work {
 	struct mm_struct *mm;
 	const struct cred *creds;
 	struct fs_struct *fs;
+	unsigned long fsize;
 	unsigned flags;
 };
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0e6bbf3367b9..ce63e1389568 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -644,7 +644,6 @@ struct io_kiocb {
 	unsigned int		flags;
 	refcount_t		refs;
 	struct task_struct	*task;
-	unsigned long		fsize;
 	u64			user_data;
 
 	struct list_head	link_list;
@@ -735,6 +734,7 @@ struct io_op_def {
 	unsigned		pollout : 1;
 	/* op supports buffer selection */
 	unsigned		buffer_select : 1;
+	unsigned		needs_fsize : 1;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -754,6 +754,7 @@ static const struct io_op_def io_op_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
+		.needs_fsize		= 1,
 	},
 	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
@@ -768,6 +769,7 @@ static const struct io_op_def io_op_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
+		.needs_fsize		= 1,
 	},
 	[IORING_OP_POLL_ADD] = {
 		.needs_file		= 1,
@@ -820,6 +822,7 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
+		.needs_fsize		= 1,
 	},
 	[IORING_OP_OPENAT] = {
 		.file_table		= 1,
@@ -851,6 +854,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
+		.needs_fsize		= 1,
 	},
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
@@ -1168,6 +1172,10 @@ static void io_prep_async_work(struct io_kiocb *req)
 		}
 		spin_unlock(&current->fs->lock);
 	}
+	if (def->needs_fsize)
+		req->work.fsize = rlimit(RLIMIT_FSIZE);
+	else
+		req->work.fsize = RLIM_INFINITY;
 }
 
 static void io_prep_async_link(struct io_kiocb *req)
@@ -3071,8 +3079,6 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
 		return -EBADF;
 
-	req->fsize = rlimit(RLIMIT_FSIZE);
-
 	/* either don't need iovec imported or already have it */
 	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
@@ -3129,17 +3135,11 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 		}
 		kiocb->ki_flags |= IOCB_WRITE;
 
-		if (!force_nonblock)
-			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
-
 		if (req->file->f_op->write_iter)
 			ret2 = call_write_iter(req->file, kiocb, &iter);
 		else
 			ret2 = loop_rw_iter(WRITE, req->file, kiocb, &iter);
 
-		if (!force_nonblock)
-			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
-
 		/*
 		 * Raw bdev writes will return -EOPNOTSUPP for IOCB_NOWAIT. Just
 		 * retry them without IOCB_NOWAIT.
@@ -3334,7 +3334,6 @@ static int io_fallocate_prep(struct io_kiocb *req,
 	req->sync.off = READ_ONCE(sqe->off);
 	req->sync.len = READ_ONCE(sqe->addr);
 	req->sync.mode = READ_ONCE(sqe->len);
-	req->fsize = rlimit(RLIMIT_FSIZE);
 	return 0;
 }
 
@@ -3345,11 +3344,8 @@ static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
 	/* fallocate always requiring blocking context */
 	if (force_nonblock)
 		return -EAGAIN;
-
-	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
 	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
 				req->sync.len);
-	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_req_complete(req, ret);
-- 
2.24.0

