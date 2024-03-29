Return-Path: <io-uring+bounces-1333-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 094ED8924F6
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 21:12:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2005285DCC
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 20:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE08613B58D;
	Fri, 29 Mar 2024 20:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KnaRqCO5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2670313B2BF
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 20:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711743169; cv=none; b=tebcE/Wg3An/+2FagOuMbRJZ9Pw3pAZLON4RNjC74BQcb1xhxEyHIaJoNXD2IEmrv/kyiwWixgDMQk2TARgXWHKNYCRAii3HTjYskghAbASqXJhBbzjMFsmgXwf9NDi9EuO0ICcKZbUtr79w+4pYnozzbdkeYxEZb5ynDjT+fys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711743169; c=relaxed/simple;
	bh=qDcqDLDpAnd9K/RjdyVGBRpxWCnWUrsRiDpoplnVPpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+jCJwIIZHwV7neDq+PTFu7ubp0+0i7n+uoKpiuiA/1FMTG6VaQp+1GS0in1VBqtlTeaYppPGwUe6R3iZ3nTI2NHJPzZluB+duELyuo9kh68ofYwh+QJv6T4uZh1BsAFF2t9g3CXW9QgAI2v+cHQm9XG6EXbeB2rdT4kn3OsUE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KnaRqCO5; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e6ca65edc9so587273b3a.0
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 13:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711743166; x=1712347966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JPzqmNhp9AOxTrMleb/aj2Nsy4wAvG/gncziR99ZHk8=;
        b=KnaRqCO5GDmNVPYsxBojn/U32/SJkpJ8gREPRfyBOUEEt2b3S6dQPqhPfLFfUg+nbz
         +pbPOyHTOSGCxBIcwokjFT445lCxN/JvJZbZ+DG1zs5XVBGjNDw4pBN1nbZHXZBAkVyO
         AuOelra47q5bHGZx/PWL+/KdL4+uzk+lzKYwR+cYZeSepDDvAGo8Gqj4/BDhDWBOlIei
         CAy3s1ECXS01TqH/vy/N6QJbsA3t47OxrZz87366PHhXQ7LPcE2V7czBi7O6LlwbX4hr
         I8mpDdCNOS25RGZCO+nxPYRQ4cpEiNXHfPJ4nknWWNP3BW4wQXmOiX8XH4RR9UduPdyW
         PHxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711743166; x=1712347966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JPzqmNhp9AOxTrMleb/aj2Nsy4wAvG/gncziR99ZHk8=;
        b=adiVuKQC9B9vLiDaAupY9F5rXx8FX8MgKUriqGzaWAh6lpLaIoYpvsn96gGItjrIeo
         ntq8bBG2l48uY1D+xfmtsRGULySCbf8BnB3PqD3is9DhzYM7/3ZCWYVeihZqOaPyU4Am
         0vOceB1gAbfhSTPu1Bogrzg0Z2TVaZ6EKPlv0O3w48EsshgwysglMOzSgf91Rze1I013
         RGcv0saK4ZqrqWdYUKSW5GnAyMqj1PU79oouKoTvAQgkkNRZuAPpHn5QfnHDL2K/muDT
         C8xsicLffSEO4pqNHLrTSnu6ZleG6yyWHZ4L902f6t3s6/b6TCPGqoTBDb2DnCsAMsZh
         h3sA==
X-Gm-Message-State: AOJu0YwWhEpxJ0NFUrXyP8SIz4Tg821Qr+m3PVWDIp677LK9XwC2C4Ib
	y3E5UzZ4NJWq0yI/K+JlAZxBmO0cPEIhMHHb2I4+M+jIy6HW4GCcotKGGkStR2SI6/2iYfmgqaI
	f
X-Google-Smtp-Source: AGHT+IHSoG03GFYcjR0a75xAP7usojCkIso5NXcueassNABkKMK7nBar/I6g717QUyphOH+HG4Hz4A==
X-Received: by 2002:a05:6a00:bda:b0:6ea:d0b0:3f96 with SMTP id x26-20020a056a000bda00b006ead0b03f96mr3433388pfu.1.1711743165678;
        Fri, 29 Mar 2024 13:12:45 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:40c6])
        by smtp.gmail.com with ESMTPSA id b11-20020aa7810b000000b006ea90941b22sm3388728pfi.40.2024.03.29.13.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 13:12:43 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: add remote task_work execution helper
Date: Fri, 29 Mar 2024 14:09:28 -0600
Message-ID: <20240329201241.874888-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240329201241.874888-1-axboe@kernel.dk>
References: <20240329201241.874888-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All our task_work handling is targeted at the state in the io_kiocb
itself, which is what it is being used for. However, MSG_RING rolls its
own task_work handling, ignoring how that is usually done.

In preparation for switching MSG_RING to be able to use the normal
task_work handling, add io_req_task_work_add_remote() which allows the
caller to pass in the target io_ring_ctx.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 30 ++++++++++++++++++++++--------
 io_uring/io_uring.h |  2 ++
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fddaefb9cbff..a311a244914b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1232,9 +1232,10 @@ void tctx_task_work(struct callback_head *cb)
 	WARN_ON_ONCE(ret);
 }
 
-static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
+static inline void io_req_local_work_add(struct io_kiocb *req,
+					 struct io_ring_ctx *ctx,
+					 unsigned flags)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	unsigned nr_wait, nr_tw, nr_tw_prev;
 	struct llist_node *head;
 
@@ -1300,9 +1301,10 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
 }
 
-static void io_req_normal_work_add(struct io_kiocb *req)
+static void io_req_normal_work_add(struct io_kiocb *req,
+				   struct task_struct *task)
 {
-	struct io_uring_task *tctx = req->task->io_uring;
+	struct io_uring_task *tctx = task->io_uring;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	/* task_work already pending, we're done */
@@ -1321,7 +1323,7 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 		return;
 	}
 
-	if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
+	if (likely(!task_work_add(task, &tctx->task_work, ctx->notify_method)))
 		return;
 
 	io_fallback_tw(tctx, false);
@@ -1331,10 +1333,22 @@ void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
 {
 	if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
 		rcu_read_lock();
-		io_req_local_work_add(req, flags);
+		io_req_local_work_add(req, req->ctx, flags);
+		rcu_read_unlock();
+	} else {
+		io_req_normal_work_add(req, req->task);
+	}
+}
+
+void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
+				 unsigned flags)
+{
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+		rcu_read_lock();
+		io_req_local_work_add(req, ctx, flags);
 		rcu_read_unlock();
 	} else {
-		io_req_normal_work_add(req);
+		io_req_normal_work_add(req, READ_ONCE(ctx->submitter_task));
 	}
 }
 
@@ -1348,7 +1362,7 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 						    io_task_work.node);
 
 		node = node->next;
-		io_req_normal_work_add(req);
+		io_req_normal_work_add(req, req->task);
 	}
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 1eb65324792a..4155379ee586 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -74,6 +74,8 @@ struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 			       unsigned issue_flags);
 
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
+void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
+				 unsigned flags);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
 void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);
-- 
2.43.0


