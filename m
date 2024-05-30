Return-Path: <io-uring+bounces-2008-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 835398D4F15
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 17:28:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E72B1B2731F
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 15:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D6A62B9A7;
	Thu, 30 May 2024 15:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YQQcnAv7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9327C17624F
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 15:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717082926; cv=none; b=jVLPgaiMzQbL+e3R3g5DiEXguedu59KPILjCJn8cPZTvIRC752ewzjfgigjqrefY1NRj5/RL9Lo2z+70bO6SyQ5KI9Joe8612SK7bBZu1li/0I9Ips7WeXnL3c+svrutNPoLj9109zodBVIUrkqi+AsItYEecSmELeU7QoAKPYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717082926; c=relaxed/simple;
	bh=R2nR5aqjT40TN62fl+jJCzr0JgVCInPf3GEawhRpgzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbhM/xb39sJQaWg4bhwuLbF7CzNlY/8czhYc79qHWxa25uBpOM1DZ4//tqNXuOFzn2I3XRUSAoRgCDU2I1Dxx24vy8JWBzGOVzuW7CaGmztY6vt+XjQkH2UP8Hi3eiDTRnit+2bwhQNEdwHBYlcPH0gqcERRROfm5AgpWVcl6sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YQQcnAv7; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3d1b5f32065so37670b6e.2
        for <io-uring@vger.kernel.org>; Thu, 30 May 2024 08:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717082923; x=1717687723; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mL4ig77LMuOf22qhBfVwnNckeSTb3q7YGNu4PwzjitM=;
        b=YQQcnAv7xD/D5i31VRkh9Bt4J8GLxSJZV+FSuKp8mzd2SuZ8PLx8Mr7fRkZvkQde/f
         pBI29zZFPaffdA9zUlydQoS0EoucDE80KO1WsCYOrIyi+TFRv0GwcBDKfHe4a+aGBBm8
         nbsiXGbWDoZ2cyryySauvrc3L0VaTrziNMrn+6oFqvpKgLEInQm2mxkCs8mFI11bDDI8
         H8DUBDriJ2Y4AJ7Qnw1VRC6GhlHMj07BBWZ09MFb3jueMUTN2hJ5gifQfHn2K+pBmNqT
         0cg5ypTwU2zyv8yja/6JTqU34eUFTRTzJdsm86DLWSgXPh3xKgU3EYA23jl/GXpnstWy
         rP7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717082923; x=1717687723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mL4ig77LMuOf22qhBfVwnNckeSTb3q7YGNu4PwzjitM=;
        b=K1xrTq9PNg4fmBmFr/I77hmcZTCVYDNIA6yOR3WlWbzNJEeQz0yVBc7U0VuuiOh1n9
         bJ25MGFYJeh/4dPMaWsEOstbTJkClacyMNbwc/rPFc29ftJCnqqJAufyLYI+JRKfxh2u
         xKITqe2yNXrsGzcqV6CuUynEdh4ORZoUlEg/a6di3ajW4AZvbUl6gd/fzuPpeVMAPv5j
         qBNbI2uOZIhqtNeWfgewwlIVM8Nts/SoGeKJkGZEtx0ODQf2ngPH+9075kbMP5FEy4PL
         nsKD6lGMSy9nggYLgDsSgPPr5Ez+YmowqjGw3zwGbHxA9a7s9ZTa7G8hMqHsSaupIe44
         nolw==
X-Gm-Message-State: AOJu0YzsPPowGMwApEKSIhZLXBdFskpiMmysOKMzM9jQ1J4ITTY6F0hT
	/fPG89uSBlf2z1JGE7I0/KGhik/nycGoLaAm6hTfIz7SSk2q2Q2FnKhrsQJrsMwjFNFyJHOqKBI
	c
X-Google-Smtp-Source: AGHT+IEZNpd0Op4s16qP6oP5y5XRAGp9QmySDH0EeCgV5483qGc3SlLjp2RPD4At/cxqapHnQJxc9A==
X-Received: by 2002:a05:6808:bd5:b0:3c9:9474:cfda with SMTP id 5614622812f47-3d1dcbea465mr2455724b6e.0.1717082922903;
        Thu, 30 May 2024 08:28:42 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d1b3682381sm2008136b6e.2.2024.05.30.08.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 08:28:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/7] io_uring/msg_ring: remove non-remote message passing
Date: Thu, 30 May 2024 09:23:44 -0600
Message-ID: <20240530152822.535791-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240530152822.535791-2-axboe@kernel.dk>
References: <20240530152822.535791-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the overflow approach works well, there's no need to retain the
double locking for direct CQ posting on the target ring. Just have any
kind of target ring use the same messaging mechanism.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 78 +++++----------------------------------------
 1 file changed, 8 insertions(+), 70 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 5264ba346df8..e966ec8757cb 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -33,11 +33,6 @@ struct io_msg {
 	u32 flags;
 };
 
-static void io_double_unlock_ctx(struct io_ring_ctx *octx)
-{
-	mutex_unlock(&octx->uring_lock);
-}
-
 static int io_double_lock_ctx(struct io_ring_ctx *octx,
 			      unsigned int issue_flags)
 {
@@ -66,11 +61,6 @@ void io_msg_ring_cleanup(struct io_kiocb *req)
 	msg->src_file = NULL;
 }
 
-static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
-{
-	return target_ctx->task_complete;
-}
-
 static struct io_overflow_cqe *io_alloc_overflow(struct io_ring_ctx *target_ctx)
 {
 	struct io_overflow_cqe *ocqe;
@@ -106,6 +96,8 @@ static void io_msg_add_overflow(struct io_msg *msg,
 				u32 flags)
 	__releases(&target_ctx->completion_lock)
 {
+	struct task_struct *task = READ_ONCE(target_ctx->submitter_task);
+
 	if (list_empty(&target_ctx->cq_overflow_list)) {
 		set_bit(IO_CHECK_CQ_OVERFLOW_BIT, &target_ctx->check_cq);
 		atomic_or(IORING_SQ_TASKRUN, &target_ctx->rings->sq_flags);
@@ -116,7 +108,10 @@ static void io_msg_add_overflow(struct io_msg *msg,
 	ocqe->cqe.flags = flags;
 	list_add_tail(&ocqe->list, &target_ctx->cq_overflow_list);
 	spin_unlock(&target_ctx->completion_lock);
-	wake_up_state(target_ctx->submitter_task, TASK_INTERRUPTIBLE);
+	if (task)
+		wake_up_state(task, TASK_INTERRUPTIBLE);
+	else if (wq_has_sleeper(&target_ctx->cq_wait))
+		wake_up(&target_ctx->cq_wait);
 }
 
 static int io_msg_fill_remote(struct io_msg *msg, unsigned int issue_flags,
@@ -141,7 +136,6 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	u32 flags = 0;
-	int ret;
 
 	if (msg->src_fd || msg->flags & ~IORING_MSG_RING_FLAGS_PASS)
 		return -EINVAL;
@@ -153,19 +147,7 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 	if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
 		flags = msg->cqe_flags;
 
-	if (io_msg_need_remote(target_ctx))
-		return io_msg_fill_remote(msg, issue_flags, target_ctx, flags);
-
-	ret = -EOVERFLOW;
-	if (target_ctx->flags & IORING_SETUP_IOPOLL) {
-		if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
-			return -EAGAIN;
-	}
-	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
-		ret = 0;
-	if (target_ctx->flags & IORING_SETUP_IOPOLL)
-		io_double_unlock_ctx(target_ctx);
-	return ret;
+	return io_msg_fill_remote(msg, issue_flags, target_ctx, flags);
 }
 
 static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_flags)
@@ -186,48 +168,6 @@ static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_fl
 	return file;
 }
 
-static int __io_msg_install_complete(struct io_kiocb *req)
-{
-	struct io_ring_ctx *target_ctx = req->file->private_data;
-	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
-	struct file *src_file = msg->src_file;
-	int ret;
-
-	ret = __io_fixed_fd_install(target_ctx, src_file, msg->dst_fd);
-	if (ret < 0)
-		return ret;
-
-	msg->src_file = NULL;
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-
-	if (msg->flags & IORING_MSG_RING_CQE_SKIP)
-		return ret;
-
-	/*
-	 * If this fails, the target still received the file descriptor but
-	 * wasn't notified of the fact. This means that if this request
-	 * completes with -EOVERFLOW, then the sender must ensure that a
-	 * later IORING_OP_MSG_RING delivers the message.
-	 */
-	if (!io_post_aux_cqe(target_ctx, msg->user_data, ret, 0))
-		return -EOVERFLOW;
-
-	return ret;
-}
-
-static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_ring_ctx *target_ctx = req->file->private_data;
-	int ret;
-
-	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
-		return -EAGAIN;
-
-	ret = __io_msg_install_complete(req);
-	io_double_unlock_ctx(target_ctx);
-	return ret;
-}
-
 static int io_msg_install_remote(struct io_kiocb *req, unsigned int issue_flags,
 				 struct io_ring_ctx *target_ctx)
 {
@@ -285,9 +225,7 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
 
-	if (io_msg_need_remote(target_ctx))
-		return io_msg_install_remote(req, issue_flags, target_ctx);
-	return io_msg_install_complete(req, issue_flags);
+	return io_msg_install_remote(req, issue_flags, target_ctx);
 }
 
 int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-- 
2.43.0


