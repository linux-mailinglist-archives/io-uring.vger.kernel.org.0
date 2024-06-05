Return-Path: <io-uring+bounces-2114-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB5908FD0E8
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 16:35:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82513B2D6B3
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 14:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8A2B1B95B;
	Wed,  5 Jun 2024 14:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HvZYE6zE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148D0199A2
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 14:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717597188; cv=none; b=V2DGlvMePRooO4MQSDBhNHSLEC2fP4+VPqzV1ljS3vGYTNFPX/QzBAGnLZpCUT6fOXO2JpKZvpsrvgeS7U1gOo5PHV2x6eZ6DzbdOuYD8qFPQLEWgHWpmIsnQZ6/A91rDc95bCmpb44Sk8sA176IDn0VCSs8OL6BB1rP8GXaJgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717597188; c=relaxed/simple;
	bh=vHYUrcMtnuCg2wrAbOmWy2FCmOHpz5C0fyDjYykFbj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRPizw29YX0eTYpCQ88Aqxv3VdSyHJkfpduAVufRIP5l6uwhXpVE9D3P6RYA81QpbNi2qJmc5nEMASqo5Wlp6Ag6xI0/h/vwdfUYrwkta8Na/GtezAf+BslC7hGdvnHciMLIn2Spw2q+EpEfBagY4vnyfGRX8MRDv6Ac5GqE7Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HvZYE6zE; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-24c582673a5so193707fac.2
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 07:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717597186; x=1718201986; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ET9g4vu0P/A3wT5hqKQuO00wFCpSRk4smWZdVZtC6W0=;
        b=HvZYE6zEs2PxK1A3Axdqv/o8/GzhLxWwdnkjTJ+ssPo7AqyaaNcZp5xLKBtNEJuG4b
         tOhTX47/pMbRjhsHsxsTFQXlt9EO/dpPyc9JsWV30bqtDeqVH2OI9pd//ZHOkWyjiQmE
         Hlg/14bywvyJMv5JiCSxwdXM5cKVEt5JcFnlCydSeTEM12vJpPXkjL9T+/I/b8q84ulh
         lDBOIUUaqGxqqZDaG9HZC5RzaoyY4EPptv0mzagmqiFT6FINKxik5z89Wq2Hr8YOD5ys
         j4M9CG7/s0D3UuA+OLl/hmH+caxkM8oGrUocTVxMK1pHWiS1O4MYBrpj5JB6ncxVOBYu
         /r0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717597186; x=1718201986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ET9g4vu0P/A3wT5hqKQuO00wFCpSRk4smWZdVZtC6W0=;
        b=obfssl+1BnkMYK0ld6CvG/PG2dHlIxoyLvytv8BRHmZ9gD1IHAM8daCuPsYCJ3X5p2
         3rXADmvCnJS6Rk9+H4IvMMmuu1iq6cbg3oVtfP/1xY/uLWh3m9zy8rouH2Xex2t/EJ5a
         6piBfx9HfPL4hxUsBbIS2p2Hk72FqXlisEECh/2lfomfOUh7ugVIgzZfSEGuhU278CsM
         /CMpTdCGjPsAYuxFP6hG9occQSuCBBgqDwouGEYUQ9weGS5y5E08cc1sg76eWPs1VWAh
         mXOt1aUn0alVLZA9joeoBpEoaC/1VuXRCiGnZhJOj5SEWJY8g/MVQaYVMNxK57LBH53j
         6RJA==
X-Gm-Message-State: AOJu0YznfEq7yH7DQwspfU84p+wh+VcusLnyIbPIXmtk3NZ6e7h1f/jv
	X6X3r/jnHC2cSVyeVPW1pDrFPZBKUN+LB1rZ6fiVC4rXnTMpp/XNHSn5qjM6lu3xqJ9NHfhqGa1
	z
X-Google-Smtp-Source: AGHT+IFC3CEAmLGrbI6oTWiB6bqIVyxAr09Sz8ovhGrAiTjOOVn7rqYj2Ouhgk2uNCgdPd1vpq3Nuw==
X-Received: by 2002:a05:6871:2882:b0:250:826d:5202 with SMTP id 586e51a60fabf-25122078d9amr2800548fac.3.1717597185473;
        Wed, 05 Jun 2024 07:19:45 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-250853ca28esm4048918fac.55.2024.06.05.07.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 07:19:44 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/9] io_uring/msg_ring: avoid double indirection task_work for data messages
Date: Wed,  5 Jun 2024 07:51:12 -0600
Message-ID: <20240605141933.11975-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240605141933.11975-1-axboe@kernel.dk>
References: <20240605141933.11975-1-axboe@kernel.dk>
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
 io_uring/msg_ring.c | 88 ++++++++++++++++++++++++++++-----------------
 1 file changed, 56 insertions(+), 32 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 9fdb0cc19bfd..2b649087fe5c 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -87,38 +87,62 @@ static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
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
+	target_ctx->nr_overflow++;
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
@@ -135,12 +159,12 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
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


