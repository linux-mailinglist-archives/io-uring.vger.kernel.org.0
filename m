Return-Path: <io-uring+bounces-2259-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0066E90DC03
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 20:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 199D81C2303E
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 18:56:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1058F15ECE0;
	Tue, 18 Jun 2024 18:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="d7Q545mf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E7E15ECE3
	for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 18:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718737004; cv=none; b=NEFnrdRtCMUvSYijui/pquZQJNTNFAyykfeuJX7f/4h8dlo5lDbwrevM2rG3854+UgVFGLVyKRr/aYGZIhXQtMcBqfZjM7kByHaSOUgZ1TRP7fN7tpLgfW/Lj66CVekH7RXIjndRn4qdiQ4X1HW/wFF/DLsQIWuKnfZnISyMC3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718737004; c=relaxed/simple;
	bh=tU23bRJ3dVyD1aJPTclIDtk2SIjAEcnouQm0D7I2J0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRfYa9CeINEImUcWsUSuZmw1uYQ4BPUVUXtMO38jhNQIK3MTpPxyJraDIAQlI1EbE2BFQY+JZrbRHPZxHen+af5oJ2jBK1dVnpBRFyMwe4VFhOIcIIIZeJBOUifnqdRAT/yktOWeeiIlB3y/484jwbmH7Nb7fxRa+r7XI1HXHsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=d7Q545mf; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-25c98395938so7520fac.3
        for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 11:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718737002; x=1719341802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BIasNGfmpgFLYp8BWXtQg7WqBx1vlCg1C/16+esEzSY=;
        b=d7Q545mfZmBN3f6QtF/W/I3OAbu59CofZcKR0T17U/Cc6BO8/FQg4+FQ90hW+66Ocf
         lGJsTbdIulANA51HyQaYMjngO87G/H2szKkvaFX4Ph6rRAPDc5MTTQTk4Zfil+g+4FYr
         YOvnAwbaoX+wyVyLzh0G5mjCd3ZsdTCNBOi+jz3cT8MNHYVhS4l5jMzMuTsBxZiFiKYg
         /dWRNmHNndpF2UmqtygY21nWhJSfKGNsbuDZsXb5qTjtBvryTkCZFI+RqNWpDPsvKqv7
         EQJXCjgLTMN8qwRU7ELTjk1q0fQJbNRksIaH/N/oKYWWJEZd3AG38NiJvoimiV4GEEQq
         ZKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718737002; x=1719341802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BIasNGfmpgFLYp8BWXtQg7WqBx1vlCg1C/16+esEzSY=;
        b=rQJ85X2oDaoIGE2ggYZhQRX6opkZrPkErZuJ/qpsXttdTM1AZWlSoIObD+udATSRWZ
         uv+uGVT/abOAnJj058rSF9F2fj8Pk8B7mVzDO1ZwasYgd8yQ/wS4Vzao/VyZw4R7HLly
         UABEdc3imzBUG77tsxuJQX25fW4F8HCxDYzWDyCKueNWbRZNWbwvX/WGJCJmZX32X7YN
         Z8BMOE7SraLtqMZ0UZ4J3vOIPXofX4K9qp+VicxUfhKKisP9xmBb4lvupswb4vjgEGiy
         2GQum7Y4qLN8YOINnLI+lc4PSPiu/TKeuZxLvlT1zoZYOZENdlqJgm0qg+GF0uKf51tk
         Sa/A==
X-Gm-Message-State: AOJu0Yz58FWKYVYi5v0UVJ8GcvE+9pHk6RDcHgUx5BU6S5aUvrTTFPlL
	k+pnMrnEJ97nJ3cUe+nSEjowne8FryWCiC51qau5JsQj2joHlkQZfN3Bm5hjPVkA+HCNqKOAygG
	D
X-Google-Smtp-Source: AGHT+IEIveQUz5X9WkVpqscuNZzgHgQjow5mb24Qtlnd92BEahMFUNUauWgYvhwqp4b4bnoBrx9eEg==
X-Received: by 2002:a05:6870:d1c9:b0:259:8928:85ec with SMTP id 586e51a60fabf-25c9496379bmr751910fac.2.1718737002120;
        Tue, 18 Jun 2024 11:56:42 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2567a9f7d6fsm3255492fac.20.2024.06.18.11.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 11:56:40 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring/msg_ring: improve handling of target CQE posting
Date: Tue, 18 Jun 2024 12:48:43 -0600
Message-ID: <20240618185631.71781-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618185631.71781-1-axboe@kernel.dk>
References: <20240618185631.71781-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the exported helper for queueing task_work for message passing,
rather than rolling our own.

Note that this is only done for strict data messages for now, file
descriptor passing messages still rely on the kernel task_work. It could
get converted at some point if it's performance critical.

This improves peak performance of message passing by about 5x in some
basic testing, with 2 threads just sending messages to each other.
Before this change, it was capped at around 700K/sec, with the change
it's at over 4M/sec.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 90 +++++++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 43 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 9fdb0cc19bfd..ad7d67d44461 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -13,7 +13,6 @@
 #include "filetable.h"
 #include "msg_ring.h"
 
-
 /* All valid masks for MSG_RING */
 #define IORING_MSG_RING_MASK		(IORING_MSG_RING_CQE_SKIP | \
 					IORING_MSG_RING_FLAGS_PASS)
@@ -71,54 +70,43 @@ static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
 	return target_ctx->task_complete;
 }
 
-static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
+static void io_msg_tw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
-	struct io_ring_ctx *ctx = req->file->private_data;
-	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
-	struct task_struct *task = READ_ONCE(ctx->submitter_task);
-
-	if (unlikely(!task))
-		return -EOWNERDEAD;
+	struct io_ring_ctx *ctx = req->ctx;
 
-	init_task_work(&msg->tw, func);
-	if (task_work_add(task, &msg->tw, TWA_SIGNAL))
-		return -EOWNERDEAD;
+	io_add_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, req->cqe.flags);
+	kmem_cache_free(req_cachep, req);
+	percpu_ref_put(&ctx->refs);
+}
 
-	return IOU_ISSUE_SKIP_COMPLETE;
+static void io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
+			       int res, u32 cflags, u64 user_data)
+{
+	req->cqe.user_data = user_data;
+	io_req_set_res(req, res, cflags);
+	percpu_ref_get(&ctx->refs);
+	req->ctx = ctx;
+	req->task = READ_ONCE(ctx->submitter_task);
+	req->io_task_work.func = io_msg_tw_complete;
+	io_req_task_work_add_remote(req, ctx, IOU_F_TWQ_LAZY_WAKE);
 }
 
-static void io_msg_tw_complete(struct callback_head *head)
+static int io_msg_data_remote(struct io_kiocb *req)
 {
-	struct io_msg *msg = container_of(head, struct io_msg, tw);
-	struct io_kiocb *req = cmd_to_io_kiocb(msg);
 	struct io_ring_ctx *target_ctx = req->file->private_data;
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
-	}
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	struct io_kiocb *target;
+	u32 flags = 0;
 
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_queue_tw_complete(req, ret);
+	target = kmem_cache_alloc(req_cachep, GFP_KERNEL);
+	if (unlikely(!target))
+		return -ENOMEM;
+
+	if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
+		flags = msg->cqe_flags;
+
+	io_msg_remote_post(target_ctx, target, msg->len, flags, msg->user_data);
+	return 0;
 }
 
 static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
@@ -136,7 +124,7 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 		return -EBADFD;
 
 	if (io_msg_need_remote(target_ctx))
-		return io_msg_exec_remote(req, io_msg_tw_complete);
+		return io_msg_data_remote(req);
 
 	if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
 		flags = msg->cqe_flags;
@@ -216,6 +204,22 @@ static void io_msg_tw_fd_complete(struct callback_head *head)
 	io_req_queue_tw_complete(req, ret);
 }
 
+static int io_msg_fd_remote(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->file->private_data;
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	struct task_struct *task = READ_ONCE(ctx->submitter_task);
+
+	if (unlikely(!task))
+		return -EOWNERDEAD;
+
+	init_task_work(&msg->tw, io_msg_tw_fd_complete);
+	if (task_work_add(task, &msg->tw, TWA_SIGNAL))
+		return -EOWNERDEAD;
+
+	return IOU_ISSUE_SKIP_COMPLETE;
+}
+
 static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
@@ -238,7 +242,7 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	if (io_msg_need_remote(target_ctx))
-		return io_msg_exec_remote(req, io_msg_tw_fd_complete);
+		return io_msg_fd_remote(req);
 	return io_msg_install_complete(req, issue_flags);
 }
 
-- 
2.43.0


