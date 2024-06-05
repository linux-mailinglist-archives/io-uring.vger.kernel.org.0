Return-Path: <io-uring+bounces-2119-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D033A8FD0B7
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 16:20:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 670F4288EE8
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 14:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EC481C686;
	Wed,  5 Jun 2024 14:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="o2nGBF1+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E313B1DA58
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 14:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717597196; cv=none; b=ckpSVFhsNdlHHoZZ44RNVlDl/RFS+MTSMmgesiggkfmM5pBbeQgkWOct6RcEUR91qwr/UMcTbgkvA9O3VRBeCIPf1gxXcBKmHXb2mrhdgvPe/Yi2KwNzHjH4W3x2j1eLRuysz46w827MhgRzxd63hO4d5IDCHrVvIz4LfSDpN+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717597196; c=relaxed/simple;
	bh=HBWZSW6GaRg+Bo8l1b/YRXXah+qHcJJASJWS1lbRkjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1yq79GPR3kv9crfGInnkbioWg8+xvetrjbdKpU8+Bsz901sLByi5V6uhVZPh03DvFz7tp1IUZb9wlfwuZXEFEPVPjm3HhyrM1BW7Zf3G5iCjicIShRI0dGnAgGzf0kKcBKBQwugirU4HVKIneDI4RP9rxfhJgxxEDtTpCwDYwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=o2nGBF1+; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6f94ab45376so11279a34.2
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 07:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717597193; x=1718201993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D8v+/zxeBFDAYrEYgAGJcLmN2TRS+9P3Sfsn7WN/CWE=;
        b=o2nGBF1+zQWJN2R1Ec3kg2lcTxS5IBp4G1Jt1As3i8KjwewgBwIK+jj831HB4mKiI8
         s9S1eeRZUSmyWadI+QSXOCNqkxLoizt3PBbhFksrQ7NxP9C3ZLA57HPboH123r0JLzwC
         MmaxGrfTjnXrxmBhfZcj8rtjlq5llETkb+BU3Shp4V5RmEjXCbAv2ZXfgynIq3zf9jcL
         jaZGw7U9WsCAG+d9UX48s5wil3IbGGL3AQOFRQ5BhQPua50UJ0YgeA9vn5VRDrkrsScc
         VMUriLU3Lj6u4NBOk8M8Gt7EULVzpDL8obZ1SqXKQjygC72r2FnTF+PeBRvcLP2zMCQA
         a71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717597193; x=1718201993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D8v+/zxeBFDAYrEYgAGJcLmN2TRS+9P3Sfsn7WN/CWE=;
        b=M7+u0ZffoybPRHkuvz21lCExiVMngGTigsnE3zHYFoRx71szW8XIKKGO1a1zJnfYw2
         2oNVho8V6MaKFKmMZiByMuZnLZsu7oIq1b+dr7R07pCdn2wX3dYt/rW1FyPZLuzhtbwj
         W6bUMl6A7CzJ+wAskLGEMhN+e7YWgp+3L8lhB4ROOJ5bSqquNVHDm6TTKyj/aquKGi4B
         LFVycW7gWVpR9+v98sX5Vj6KR1AteLKJAtObxvRQ6XBLG3mvCo2xJ5RZm0exG3kovfUN
         /7g9WDo+ajEQLnxlEduIH67nRY+OXBReqB2fCakJB4i4Xmr0Zy06CyeQ/oBwzCdoD5dC
         A5yA==
X-Gm-Message-State: AOJu0YyqbYYsQmR229+vJivE3ItNR19EWngusnMB+yKjT5uES9WE27cU
	wG9t/LGTgdXWgB3JUVJpocNIi+VhWhd84q+dSOkAlO2wP8klaKbfL3i0OL6ieqdU4vJglEAz1o+
	a
X-Google-Smtp-Source: AGHT+IFJRphuUXx7n0loteYVj0MdhSfj5eB26Mgkm5UX1a9bctHC3mJj/YlOh7sUh6QVWCXssbhFCA==
X-Received: by 2002:a05:6871:294:b0:24f:ea59:4e1c with SMTP id 586e51a60fabf-2512242cc12mr2986101fac.4.1717597193430;
        Wed, 05 Jun 2024 07:19:53 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-250853ca28esm4048918fac.55.2024.06.05.07.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 07:19:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 9/9] io_uring/msg_ring: remove non-remote message passing
Date: Wed,  5 Jun 2024 07:51:17 -0600
Message-ID: <20240605141933.11975-10-axboe@kernel.dk>
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

Now that the overflow approach works well, there's no need to retain the
double locking for direct CQ posting on the target ring. Just have any
kind of target ring use the same messaging mechanism.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 79 ++++++++-------------------------------------
 1 file changed, 14 insertions(+), 65 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index eeca1563ceed..9fb355b7e736 100644
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
 	__acquires(&target_ctx->completion_lock)
 {
@@ -109,7 +99,7 @@ static void io_msg_add_overflow(struct io_msg *msg,
 				u32 flags)
 	__releases(&target_ctx->completion_lock)
 {
-	unsigned nr_prev, nr_wait;
+	unsigned nr_prev;
 
 	if (list_empty(&target_ctx->cq_overflow_list)) {
 		set_bit(IO_CHECK_CQ_OVERFLOW_BIT, &target_ctx->check_cq);
@@ -122,11 +112,17 @@ static void io_msg_add_overflow(struct io_msg *msg,
 	nr_prev = target_ctx->nr_overflow++;
 	list_add_tail(&ocqe->list, &target_ctx->cq_overflow_list);
 	spin_unlock(&target_ctx->completion_lock);
-	rcu_read_lock();
-	io_defer_tw_count(target_ctx, &nr_wait);
-	nr_prev += nr_wait;
-	io_defer_wake(target_ctx, nr_prev + 1, nr_prev);
-	rcu_read_unlock();
+	if (target_ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+		unsigned nr_wait;
+
+		rcu_read_lock();
+		io_defer_tw_count(target_ctx, &nr_wait);
+		nr_prev += nr_wait;
+		io_defer_wake(target_ctx, nr_prev + 1, nr_prev);
+		rcu_read_unlock();
+	} else if (wq_has_sleeper(&target_ctx->cq_wait)) {
+		wake_up(&target_ctx->cq_wait);
+	}
 }
 
 static int io_msg_fill_remote(struct io_msg *msg, unsigned int issue_flags,
@@ -149,7 +145,6 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	u32 flags = 0;
-	int ret;
 
 	if (msg->src_fd || msg->flags & ~IORING_MSG_RING_FLAGS_PASS)
 		return -EINVAL;
@@ -161,19 +156,7 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -194,38 +177,6 @@ static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_fl
 	return file;
 }
 
-static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_ring_ctx *target_ctx = req->file->private_data;
-	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
-	struct file *src_file = msg->src_file;
-	int ret;
-
-	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
-		return -EAGAIN;
-
-	ret = __io_fixed_fd_install(target_ctx, src_file, msg->dst_fd);
-	if (ret < 0)
-		goto out_unlock;
-
-	msg->src_file = NULL;
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-
-	if (msg->flags & IORING_MSG_RING_CQE_SKIP)
-		goto out_unlock;
-	/*
-	 * If this fails, the target still received the file descriptor but
-	 * wasn't notified of the fact. This means that if this request
-	 * completes with -EOVERFLOW, then the sender must ensure that a
-	 * later IORING_OP_MSG_RING delivers the message.
-	 */
-	if (!io_post_aux_cqe(target_ctx, msg->user_data, ret, 0))
-		ret = -EOVERFLOW;
-out_unlock:
-	io_double_unlock_ctx(target_ctx);
-	return ret;
-}
-
 static int io_msg_install_remote(struct io_kiocb *req, unsigned int issue_flags,
 				 struct io_ring_ctx *target_ctx)
 {
@@ -284,9 +235,7 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
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


