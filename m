Return-Path: <io-uring+bounces-5795-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8AAFA07FAE
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 19:20:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BF4A3A670F
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 18:19:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4F819CD1E;
	Thu,  9 Jan 2025 18:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EJMKVHT2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBF82B9BF
	for <io-uring@vger.kernel.org>; Thu,  9 Jan 2025 18:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736446792; cv=none; b=p+mAVrE/eLXXV2YsCrmjksQZmf1dCVdH2wh+XSO9OtvjD8hxmJHHQ3h8MPBQ2OWGrhtSttY39hUni/yYvmoGaBa6fzTvHC5M0GcFFR/JqRpQP3jskVkE0HiqA5wg7C5OSnqqooa6hjtoV5pcLMsOrBSWzyVXd7MVbRBR1r1zXQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736446792; c=relaxed/simple;
	bh=uMJpdrS2xN0fMillCUVWceaIntFJuVDABcryoQ7kEHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYiehw5Jfla6eIfciPVPnv2KxNZTYF4dDhNFYADLNVzJMOVfrjagQXa/q1oIEsgosodfHfUDrDqevrwA9RjnDnu7pn7umu6otQUstWfPukSCe+7hoAe7d/a0IExXEUgepY3pdQ+lxNDoq3sndCLZLx11i6PfRJp3SCFACK37bS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EJMKVHT2; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-84a1ce51187so33986639f.1
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2025 10:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736446790; x=1737051590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dbBqwewNVxZNinbrbpwpjmiVBCsJQqokWMY4UY6+rFY=;
        b=EJMKVHT2NmFGQ5VsxFbrA2/keeMqAmIpCXllbD3lpHWF3KTURd0abFPCNwsorOb4T2
         fkotHgM7wXYE26W1Bg+XTt0OeElwTGyU3Qty+uXe0Gyby6mOyMegcpuYKBBcvNzJncSh
         jyN8iBOSVbuyP39Mo0GKFtz8stgdSHuPKm7bkCPUHcRxNBBYW1m0Ki0h2WHUaOgwt3Qz
         2azupOuuQaQyCc5XDNwsqc3wwcHbOoC97mJRVzc8K8qKBT7yfihmeD101ad5VduEi3fV
         6UrR23kbHIquRABHlKKOGY6EO1rLksGCaLN2HsZmucE8hwerN4XxdWwdQp8qjdBh+Vgz
         WHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736446790; x=1737051590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dbBqwewNVxZNinbrbpwpjmiVBCsJQqokWMY4UY6+rFY=;
        b=rBkhklysuamzL+P0gsy2T7KrJTQAq2Qf278Frj0eVAs/B/jgMIdLn1xLf1RwSAMLx+
         gxSrQR9Ojnz7U9+lRFxPIlqFXeXj9PtLcwUvBBFinLM/swA+2j3pcAq002UmtgrALBEf
         Srmzuk7/BFJYn8IFZab904+W94vOsthYdtXAkYcQ+iwBX0xrpaHwa2yxKVfM74FXEP7o
         VVjR/oPqWzDk31xECtRZdZzxS3kV5DwUpDXE+QgRGcMvz1ahURcNOWusYur94Z8P276K
         tR6HGHH41SgjBsKls4rZ05fR8Xl4obS+u6ksQPXooQUE5ANPzrJxQLj0shh3HnlkoVw1
         7aUg==
X-Gm-Message-State: AOJu0YzW2d8BCdfwiFYjcbBDVniH4haLzRulRf52BFJdVB4b5XNpi8XN
	U/+npSOMBpZQ5sLZYpNSE2gqoZcX9TI4XBtQYSYs3aJEu2N1HuRCKTAwRtd2o2LryA0a6lc51Fr
	J
X-Gm-Gg: ASbGncvgVUOy/5OXoER//MaYqIYAWT4xkGAaJbjtk5xdXkCCmOHlcurUfYhoMC/DJ6q
	tMlACvu89C7AjZF4R1zCz0F4yBSaXprmUw2UVX4MJN5BbT99WQlkEGXrvzBoDyX+hv/xE3TWRjM
	DnYlfvJ6bCu5xcsgAW7db08GRFAaJq4j6W8p1UsP+iUWzglZtBruRyiRXEYxalkkFyp6naZ7eKf
	YqrH1qBPIfSxwKOXngmIyvNUjRSRwGTm48I5376vqlgrZfT/RkiJZkbWVJhoA==
X-Google-Smtp-Source: AGHT+IGOmp61wEKjNCmr7sCY83Qmb7u6KJh4bVlaD5PKMbkMKiK1tgYQtHMlLtv2fBNpQXJqx5Djow==
X-Received: by 2002:a92:c24f:0:b0:3a7:e592:55ee with SMTP id e9e14a558f8ab-3ce3aa746d1mr66510295ab.20.1736446788314;
        Thu, 09 Jan 2025 10:19:48 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b71763asm440672173.103.2025.01.09.10.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 10:19:47 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/rw: handle -EAGAIN retry at IO completion time
Date: Thu,  9 Jan 2025 11:15:40 -0700
Message-ID: <20250109181940.552635-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250109181940.552635-1-axboe@kernel.dk>
References: <20250109181940.552635-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than try and have io_read/io_write turn REQ_F_REISSUE into
-EAGAIN, catch the REQ_F_REISSUE when the request is otherwise
considered as done. This is saner as we know this isn't happening
during an actual submission, and it removes the need to randomly
check REQ_F_REISSUE after read/write submission.

If REQ_F_REISSUE is set, __io_submit_flush_completions() will skip over
this request in terms of posting a CQE, and the regular request
cleaning will ensure that it gets reissued via io-wq.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 15 +++++++--
 io_uring/rw.c       | 80 ++++++++++++++-------------------------------
 2 files changed, 38 insertions(+), 57 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index db198bd435b5..92ba2fdcd087 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -115,7 +115,7 @@
 				REQ_F_ASYNC_DATA)
 
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
-				 IO_REQ_CLEAN_FLAGS)
+				 REQ_F_REISSUE | IO_REQ_CLEAN_FLAGS)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
@@ -1403,6 +1403,12 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 						    comp_list);
 
 		if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
+			if (req->flags & REQ_F_REISSUE) {
+				node = req->comp_list.next;
+				req->flags &= ~REQ_F_REISSUE;
+				io_queue_iowq(req);
+				continue;
+			}
 			if (req->flags & REQ_F_REFCOUNT) {
 				node = req->comp_list.next;
 				if (!req_ref_put_and_test(req))
@@ -1442,7 +1448,12 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 					    comp_list);
 
-		if (!(req->flags & REQ_F_CQE_SKIP) &&
+		/*
+		 * Requests marked with REQUEUE should not post a CQE, they
+		 * will go through the io-wq retry machinery and post one
+		 * later.
+		 */
+		if (!(req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE)) &&
 		    unlikely(!io_fill_cqe_req(ctx, req))) {
 			if (ctx->lockless_cq) {
 				spin_lock(&ctx->completion_lock);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index afc669048c5d..c52c0515f0a2 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -202,7 +202,7 @@ static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 	 * mean that the underlying data can be gone at any time. But that
 	 * should be fixed seperately, and then this check could be killed.
 	 */
-	if (!(req->flags & REQ_F_REFCOUNT)) {
+	if (!(req->flags & (REQ_F_REISSUE | REQ_F_REFCOUNT))) {
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 		io_rw_recycle(req, issue_flags);
 	}
@@ -455,19 +455,12 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 	return NULL;
 }
 
-#ifdef CONFIG_BLOCK
-static void io_resubmit_prep(struct io_kiocb *req)
-{
-	struct io_async_rw *io = req->async_data;
-	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-
-	io_meta_restore(io, &rw->kiocb);
-	iov_iter_restore(&io->iter, &io->iter_state);
-}
-
 static bool io_rw_should_reissue(struct io_kiocb *req)
 {
+#ifdef CONFIG_BLOCK
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	umode_t mode = file_inode(req->file)->i_mode;
+	struct io_async_rw *io = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!S_ISBLK(mode) && !S_ISREG(mode))
@@ -488,17 +481,14 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 	 */
 	if (!same_thread_group(req->tctx->task, current) || !in_task())
 		return false;
+
+	io_meta_restore(io, &rw->kiocb);
+	iov_iter_restore(&io->iter, &io->iter_state);
 	return true;
-}
 #else
-static void io_resubmit_prep(struct io_kiocb *req)
-{
-}
-static bool io_rw_should_reissue(struct io_kiocb *req)
-{
 	return false;
-}
 #endif
+}
 
 static void io_req_end_write(struct io_kiocb *req)
 {
@@ -525,22 +515,16 @@ static void io_req_io_end(struct io_kiocb *req)
 	}
 }
 
-static bool __io_complete_rw_common(struct io_kiocb *req, long res)
+static void __io_complete_rw_common(struct io_kiocb *req, long res)
 {
-	if (unlikely(res != req->cqe.res)) {
-		if (res == -EAGAIN && io_rw_should_reissue(req)) {
-			/*
-			 * Reissue will start accounting again, finish the
-			 * current cycle.
-			 */
-			io_req_io_end(req);
-			req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
-			return true;
-		}
+	if (res == req->cqe.res)
+		return;
+	if (res == -EAGAIN && io_rw_should_reissue(req)) {
+		req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
+	} else {
 		req_set_fail(req);
 		req->cqe.res = res;
 	}
-	return false;
 }
 
 static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
@@ -583,8 +567,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 
 	if (!kiocb->dio_complete || !(kiocb->ki_flags & IOCB_DIO_CALLER_COMP)) {
-		if (__io_complete_rw_common(req, res))
-			return;
+		__io_complete_rw_common(req, res);
 		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
 	}
 	req->io_task_work.func = io_req_rw_complete;
@@ -646,26 +629,19 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 	if (ret >= 0 && req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = rw->kiocb.ki_pos;
 	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
-		if (!__io_complete_rw_common(req, ret)) {
-			/*
-			 * Safe to call io_end from here as we're inline
-			 * from the submission path.
-			 */
-			io_req_io_end(req);
-			io_req_set_res(req, final_ret,
-				       io_put_kbuf(req, ret, issue_flags));
-			io_req_rw_cleanup(req, issue_flags);
-			return IOU_OK;
-		}
+		__io_complete_rw_common(req, ret);
+		/*
+		 * Safe to call io_end from here as we're inline
+		 * from the submission path.
+		 */
+		io_req_io_end(req);
+		io_req_set_res(req, final_ret, io_put_kbuf(req, ret, issue_flags));
+		io_req_rw_cleanup(req, issue_flags);
+		return IOU_OK;
 	} else {
 		io_rw_done(&rw->kiocb, ret);
 	}
 
-	if (req->flags & REQ_F_REISSUE) {
-		req->flags &= ~REQ_F_REISSUE;
-		io_resubmit_prep(req);
-		return -EAGAIN;
-	}
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
 
@@ -944,8 +920,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret == -EOPNOTSUPP && force_nonblock)
 		ret = -EAGAIN;
 
-	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
-		req->flags &= ~REQ_F_REISSUE;
+	if (ret == -EAGAIN) {
 		/* If we can poll, just do that. */
 		if (io_file_can_poll(req))
 			return -EAGAIN;
@@ -1154,11 +1129,6 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		ret2 = -EINVAL;
 
-	if (req->flags & REQ_F_REISSUE) {
-		req->flags &= ~REQ_F_REISSUE;
-		ret2 = -EAGAIN;
-	}
-
 	/*
 	 * Raw bdev writes will return -EOPNOTSUPP for IOCB_NOWAIT. Just
 	 * retry them without IOCB_NOWAIT.
-- 
2.47.1


