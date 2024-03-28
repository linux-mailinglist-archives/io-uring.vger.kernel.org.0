Return-Path: <io-uring+bounces-1301-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C47E8908A9
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 19:54:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFB4729D148
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 18:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26960137759;
	Thu, 28 Mar 2024 18:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LevyyLA5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF23137766
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 18:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711652061; cv=none; b=OpB1oTxdv2xh82R6vD7nWdH+dxy6U7xmDJKvuhTMZSlPf7DFN0PkO3+z1Sq9AO2QPYGviCSkviCY4B+RwGB9E4M2nHUipUGm3meggQ7nqTdA5YqOkA+pBewWUkGjmH/fvT7TS+Iw48FuZo3og4f/rYMlSVNtWHxx5IoEZriAFJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711652061; c=relaxed/simple;
	bh=SuVysJvN/C0i3B+xcpafFcXUecl4OdhFCgCxJR2gnx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SV+w8gCj+Oyunp7/r8p+a0oecn6vNHUNrNCZTiffB/N/VWXVCy/TG0LsAgv7rwZ2kqSb7ZTEd0RjFpMLqKLQ1ZI11i5G/76qMq99KaEKEDXhHrW8Y6auTWxEsdAgBR+EL2vX6CAfJ3LXH/hQrRyLxWcJKzwItvRZJdmxPrYgZps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LevyyLA5; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6ea729f2e38so275304b3a.1
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 11:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711652057; x=1712256857; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jDmmOrv9idjYjnsKvLCtkIkZDzm6Obo3xt1sDFxhCKw=;
        b=LevyyLA5461a9vfPlnHQHPEmxv26bfVt3OrNIqd1Sn2gJpQfIDihtt978OTXQSqNDz
         DSgWjCGELvndv4iX3FBC/VeNzOnQu3s1ta9u3zSFjtRihuwVVHnLKtRyiFcj35H7eyej
         2z3/yxk1j7W0LaZWFqRQScuO7rMR+fmhZqgEm10AWIdlKvVoWC+CdlqmmAKMqA6ykdYH
         fLeptQc2LLBfC6KfdC64AXdnH0arc9H/G1m3WWLi/VT5YSV49qN+YuJCnJ9qJOVv/oxK
         eXBJRRXBXI37PS+zviC/wYc1qHmIAdeiVlK71OWugWjIMIRaCfMnWe8hKuIZi0091Em+
         SKiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711652057; x=1712256857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jDmmOrv9idjYjnsKvLCtkIkZDzm6Obo3xt1sDFxhCKw=;
        b=ddPqX8qM4rb191r7ytIyFnPVcUiQRlH6sIR/SJUJ/8/4/HtJsSR1SSbxI7cRiY+WOf
         TYPh5UPfYbHBpJxOrqqy5PdB4NpYDQFVe6afuzGIOCETFB1HtvzG6GvR1+kWZNrXQ+mY
         7PFBMUgl6HW0qhooukSM94DRqX0B8EvyELKMqn80m7WKgaeD5mHhVS4foBmFigWDh0I6
         4cfdIVuiIU0pb8ObyVi0skvi3tl6NXp9W+YbdvyjpsirSfLp8kW9jkkw9QmZ4YupDSlI
         WX0JWVK4XuIl3i7Uc33/s/mPtqOkeB2AX/dMyc4YBSq297bQXUqs1MDwiIdjndXG6SS0
         cmnA==
X-Gm-Message-State: AOJu0YwZI1wve+lhTAOaigqDjgWF5/eN3f4CHMd+tC1gaLOcPARbu6e+
	Dt2SSZtFEFcuy4L9JffkeAhTlEMjZswCOUQtvMRs19oYZPofWPdof5WZXRc9NWmqw2WmuCTTwRo
	+
X-Google-Smtp-Source: AGHT+IG0uGNLUvBaa0KwXhiDsTpLdZs9JJnqX7s8GV+6QUQo9jgdW2Z9ndEV9yErSxRCMiokGN8mtg==
X-Received: by 2002:a05:6a00:d4d:b0:6ea:bb00:a52f with SMTP id n13-20020a056a000d4d00b006eabb00a52fmr138075pfv.3.1711652057214;
        Thu, 28 Mar 2024 11:54:17 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:b138])
        by smtp.gmail.com with ESMTPSA id v17-20020a056a00149100b006e631af9cefsm1717357pfu.62.2024.03.28.11.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 11:54:15 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: add remote task_work execution helper
Date: Thu, 28 Mar 2024 12:52:43 -0600
Message-ID: <20240328185413.759531-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240328185413.759531-1-axboe@kernel.dk>
References: <20240328185413.759531-1-axboe@kernel.dk>
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
caller to pass in the target io_ring_ctx and task.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 27 +++++++++++++++++++--------
 io_uring/io_uring.h |  2 ++
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9978dbe00027..609ff9ea5930 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1241,9 +1241,10 @@ void tctx_task_work(struct callback_head *cb)
 	WARN_ON_ONCE(ret);
 }
 
-static inline void io_req_local_work_add(struct io_kiocb *req, unsigned tw_flags)
+static inline void io_req_local_work_add(struct io_kiocb *req,
+					 struct io_ring_ctx *ctx,
+					 unsigned tw_flags)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	unsigned nr_wait, nr_tw, nr_tw_prev;
 	unsigned long flags;
 
@@ -1291,9 +1292,10 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned tw_flags
 	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
 }
 
-static void io_req_normal_work_add(struct io_kiocb *req)
+static void io_req_normal_work_add(struct io_kiocb *req,
+				   struct task_struct *task)
 {
-	struct io_uring_task *tctx = req->task->io_uring;
+	struct io_uring_task *tctx = task->io_uring;
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 	bool was_empty;
@@ -1319,7 +1321,7 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 		return;
 	}
 
-	if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
+	if (likely(!task_work_add(task, &tctx->task_work, ctx->notify_method)))
 		return;
 
 	io_fallback_tw(tctx, false);
@@ -1328,9 +1330,18 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
 {
 	if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
-		io_req_local_work_add(req, flags);
+		io_req_local_work_add(req, req->ctx, flags);
+	else
+		io_req_normal_work_add(req, req->task);
+}
+
+void io_req_task_work_add_remote(struct io_kiocb *req, struct task_struct *task,
+				 struct io_ring_ctx *ctx, unsigned flags)
+{
+	if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+		io_req_local_work_add(req, ctx, flags);
 	else
-		io_req_normal_work_add(req);
+		io_req_normal_work_add(req, task);
 }
 
 static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
@@ -1349,7 +1360,7 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 						    io_task_work.node);
 
 		node = node->next;
-		io_req_normal_work_add(req);
+		io_req_normal_work_add(req, req->task);
 	}
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index bde463642c71..a6dec5321ec4 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -74,6 +74,8 @@ struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 			       unsigned issue_flags);
 
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
+void io_req_task_work_add_remote(struct io_kiocb *req, struct task_struct *task,
+				 struct io_ring_ctx *ctx, unsigned flags);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
 void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);
-- 
2.43.0


