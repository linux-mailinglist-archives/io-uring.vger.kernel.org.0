Return-Path: <io-uring+bounces-2004-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 101518D4F11
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 17:28:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FEC71C232D5
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 15:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4988F2B9A7;
	Thu, 30 May 2024 15:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Um9PW3OR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E39176253
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 15:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717082920; cv=none; b=kjBxxm+JdRBpTRq2M5h7GyT/JEm2uBWYTr1qRLalJpefzJgz3B6Y4PI9V2Vj1NKx6JICcCkHMzEe36N8ngWrAJEVXZCmeFRXunyQB6AGz2sNNX2uepfEBOfWufX5Kc8DjZ3KeIbH5s4XABUNN3LsTl6bznzqQFCY85rwmTvdqG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717082920; c=relaxed/simple;
	bh=I0yGKyybH2NDIn++3egAuNa/4hf42t0sOqm6hWTfrmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqj65/CCIILu7fnYgSRClArM2tFlLcUOWg+DQetEa64HgPJ7OLUYsUV4SP/6Wzmae66iH0ijHX7ofxnI4YGdnSCTxB9FrlG1w8Ls5qNGYED7VZjsM7ImhCGQHxBH4kIi6oIrNYeTCEafpfKISYnQiJoImsAOg4Bl6lf2aH5EeYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Um9PW3OR; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3d1d411ffbbso32259b6e.3
        for <io-uring@vger.kernel.org>; Thu, 30 May 2024 08:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717082917; x=1717687717; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2TgpfwreZeaYJNBx6Jv2LBjJ5S4QzmxlRqOX0v4pzc8=;
        b=Um9PW3ORomNaGpfDKBGOPooKrrpNg/6t0aTZo3pK+dCZgN1qeWqmFSWVHPvz/VBGmT
         wpyVHAj47lGRMtxf8vG2xG9ajzSBAAuGfIs5InES21ID98uuDX8mP2zmaQEO16e5c6lI
         qnhQmW9CgEPuS2bG1/AOdQOjqX9lWaHGgy+tzFpfIVFiXBBdgF3rYa/ybz+VmABcL/D1
         goD3TWaS+A2Z8s82OE4dy0bJKkNI0WZDoREFr76X/GcGBKZM0PZ/a0MrQppDxgLxMZZt
         58ucZP2pmfhhEocrnedMg+/zTdp5di2Ms3PWPNQJpsivc8MJpwc2V2e6MtuZlTrCVult
         G6Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717082917; x=1717687717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2TgpfwreZeaYJNBx6Jv2LBjJ5S4QzmxlRqOX0v4pzc8=;
        b=TZZ5UiIg6cfULzZ5xyMSmQwPgvm+vX2yZCJ9knyiohZtTDlAgdrJ+61XWyQshtNATx
         ODp0K2FF8tkVYqkBaJbq6Ejcx4UzXUlbU3ThUxCbpYeCC7SxHKjvSkA/pfxJAzNf2R9D
         ZDmB0xfAZ7GE4+i6/61g1YuQ0m4C30W8KCNDHhnjTrIUaGvTdJTyZoEU2IpPHqqer1yO
         SejvjR1bpxyd9m9NfHSHraxNa1/EvHpDisn3COz6b0tdOUagSfqI6lIHlsTZP5QLivGU
         +/wmpGPgLiFUB6W10IuADBz81JjlBBuSopshUc63kXtkI52eEURx8Iecz7KQvDbSg7pz
         hlLA==
X-Gm-Message-State: AOJu0YzEDTj/St9fCoez3YfDzIoJDULi5AV+WgrEx1LbjAm7Xl/QgJ1m
	x2y7dHUEPRL9oPk/37B0+W7fwby29kOg+fkd+MR57jjfHoFBNovUPMJIPpe+yXP+BrPXN6VyxY8
	W
X-Google-Smtp-Source: AGHT+IE+GpXa5K1gLsVGH9sEsMXgHbL7bZ5bCiwb97FrrEZf/91NNqsNEbbIR3VElXbEVWLt1RTExQ==
X-Received: by 2002:a05:6808:1903:b0:3d1:df5a:2e01 with SMTP id 5614622812f47-3d1df5a3ac4mr1658954b6e.5.1717082917067;
        Thu, 30 May 2024 08:28:37 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d1b3682381sm2008136b6e.2.2024.05.30.08.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 08:28:35 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/7] io_uring/msg_ring: avoid double indirection task_work for data messages
Date: Thu, 30 May 2024 09:23:40 -0600
Message-ID: <20240530152822.535791-5-axboe@kernel.dk>
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

If IORING_SETUP_DEFER_TASKRUN is set, then we can't post CQEs remotely
to the target ring. Instead, task_work is queued for the target ring,
which is used to post the CQE. To make matters worse, once the target
CQE has been posted, task_work is then queued with the originator to
fill the completion.

This obviously adds a bunch of overhead and latency. Instead of relying
on generic kernel task_work for this, fill an overflow entry on the
target ring and flag it as such that the target ring will flush it. This
avoids both the task_work for posting the CQE, and it means that the
originator CQE can be filled inline as well.

In local testing, this reduces the latency on the sender side by 5-6x.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 87 ++++++++++++++++++++++++++++-----------------
 1 file changed, 55 insertions(+), 32 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 15e7bda77d0d..bdb935ef7aa2 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -87,38 +87,61 @@ static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
 
-static void io_msg_tw_complete(struct callback_head *head)
+static struct io_overflow_cqe *io_alloc_overflow(struct io_ring_ctx *target_ctx)
 {
-	struct io_msg *msg = container_of(head, struct io_msg, tw);
-	struct io_kiocb *req = cmd_to_io_kiocb(msg);
-	struct io_ring_ctx *target_ctx = req->file->private_data;
-	int ret = 0;
-
-	if (current->flags & PF_EXITING) {
-		ret = -EOWNERDEAD;
-	} else {
-		u32 flags = 0;
-
-		if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
-			flags = msg->cqe_flags;
-
-		/*
-		 * If the target ring is using IOPOLL mode, then we need to be
-		 * holding the uring_lock for posting completions. Other ring
-		 * types rely on the regular completion locking, which is
-		 * handled while posting.
-		 */
-		if (target_ctx->flags & IORING_SETUP_IOPOLL)
-			mutex_lock(&target_ctx->uring_lock);
-		if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
-			ret = -EOVERFLOW;
-		if (target_ctx->flags & IORING_SETUP_IOPOLL)
-			mutex_unlock(&target_ctx->uring_lock);
+	bool is_cqe32 = target_ctx->flags & IORING_SETUP_CQE32;
+	size_t cqe_size = sizeof(struct io_overflow_cqe);
+	struct io_overflow_cqe *ocqe;
+
+	if (is_cqe32)
+		cqe_size += sizeof(struct io_uring_cqe);
+
+	ocqe = kmalloc(cqe_size, GFP_ATOMIC | __GFP_ACCOUNT);
+	if (!ocqe)
+		return NULL;
+
+	if (is_cqe32)
+		ocqe->cqe.big_cqe[0] = ocqe->cqe.big_cqe[1] = 0;
+
+	return ocqe;
+}
+
+/*
+ * Entered with the target uring_lock held, and will drop it before
+ * returning. Adds a previously allocated ocqe to the overflow list on
+ * the target, and marks it appropriately for flushing.
+ */
+static void io_msg_add_overflow(struct io_msg *msg,
+				struct io_ring_ctx *target_ctx,
+				struct io_overflow_cqe *ocqe, int ret,
+				u32 flags)
+	__releases(&target_ctx->completion_lock)
+{
+	if (list_empty(&target_ctx->cq_overflow_list)) {
+		set_bit(IO_CHECK_CQ_OVERFLOW_BIT, &target_ctx->check_cq);
+		atomic_or(IORING_SQ_TASKRUN, &target_ctx->rings->sq_flags);
 	}
 
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_queue_tw_complete(req, ret);
+	ocqe->cqe.user_data = msg->user_data;
+	ocqe->cqe.res = ret;
+	ocqe->cqe.flags = flags;
+	list_add_tail(&ocqe->list, &target_ctx->cq_overflow_list);
+	spin_unlock(&target_ctx->completion_lock);
+	wake_up_state(target_ctx->submitter_task, TASK_INTERRUPTIBLE);
+}
+
+static int io_msg_fill_remote(struct io_msg *msg, unsigned int issue_flags,
+			      struct io_ring_ctx *target_ctx, u32 flags)
+{
+	struct io_overflow_cqe *ocqe;
+
+	ocqe = io_alloc_overflow(target_ctx);
+	if (!ocqe)
+		return -ENOMEM;
+
+	spin_lock(&target_ctx->completion_lock);
+	io_msg_add_overflow(msg, target_ctx, ocqe, msg->len, flags);
+	return 0;
 }
 
 static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
@@ -135,12 +158,12 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
 		return -EBADFD;
 
-	if (io_msg_need_remote(target_ctx))
-		return io_msg_exec_remote(req, io_msg_tw_complete);
-
 	if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
 		flags = msg->cqe_flags;
 
+	if (io_msg_need_remote(target_ctx))
+		return io_msg_fill_remote(msg, issue_flags, target_ctx, flags);
+
 	ret = -EOVERFLOW;
 	if (target_ctx->flags & IORING_SETUP_IOPOLL) {
 		if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
-- 
2.43.0


