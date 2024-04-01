Return-Path: <io-uring+bounces-1352-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F72E894492
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 19:58:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D8CC1C21238
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 17:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C3794D5B0;
	Mon,  1 Apr 2024 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tKnu4VW4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C28C4D5A0
	for <io-uring@vger.kernel.org>; Mon,  1 Apr 2024 17:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711994284; cv=none; b=J7CHs59ITynpOe1gwCi4ZDK6g/hkUje5Qwrkpa9JoQgX2+tFrcZqGT+gxzwWRw64RZg0Mnpn3zhymK9NIsSoZGrWwZmhH/baOkq4zmPr9yWj8lrtw7iEDw3MYcqoBRMUGj7FMuiexT5RelOq0/v6gOMq3yZzAnPN+heeG0XjJ6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711994284; c=relaxed/simple;
	bh=0dlb5Uv64P4r6ph5NGQK7SoDKDCUoEbzqHnGGTKzLxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rp9NQGLXtHBPms/sFOvKqHODNQY3G8m3CP5tZ3/pFSso46sQba3X9g/PU/A2hYPfvBg+0Z/WRzGI2jusnwYFMZ586Sqz5A4BTEefYmEx2KGH3jUAuZxjpRhS/rWzxPlJfrxj30tLqnFdIAyixpAXyaeMNu/r3bhTRAUoOZQ/OGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tKnu4VW4; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3688dcc5055so1652445ab.1
        for <io-uring@vger.kernel.org>; Mon, 01 Apr 2024 10:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711994281; x=1712599081; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cp6tb70QFmVP8n5qDgYVvaom2mmSERZ5XsLDZh6LdM8=;
        b=tKnu4VW4HE9Or8TnWqosBgQaLU15OgW29k7w4zEZCdVouoqZTWZi3TESlU/ohdkMgS
         8I4/n4vV3fRUJSfjK2Iil37tmx835sJnNpOfQD605QXkgBr598T9HRFqM8iyJ1qYJXiT
         M3+ae98qDABA14wp6ki6EfGcGlPFi3Zl9J9cDLzdJssaRnTQ210DbdMaqUvH9WSMYwsL
         4u7RruPgl8O9aHDOW+IVPJb2eF/p10EjzmxghddZIieSgZDq10cOiby7c2+992Fhgh/o
         mVUe4QbIx/yAB1QYkeuxeTFZwMajpnqOO7s6/NTP8HnEJEwOSa/96WT3HppPY61V2vSy
         1T0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711994281; x=1712599081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cp6tb70QFmVP8n5qDgYVvaom2mmSERZ5XsLDZh6LdM8=;
        b=nshhNSp6NlfckdZMP36NnIIVxtD3bK8hIg/on7grlRHzJ+jI80j3sEqk2I8yjauXcI
         rbehx9Id0l7hKmpYTuYRN1dNtTijjDAajbzhIjFET66ge1GbeA91tgzZq5PQBbZw7umk
         fSFd8VikLmN15G/AsAWCUcw9vdsvNrjuB7D5dmxYmvUBwU8ERuMlUJV1BAoLMUbEyBWk
         d7TMwiIlGNCq83rqmlX69i3b7ICx/2FtnvdtvOmz7jjPk5qr9GSJl/Z7xfurDW7vI5fS
         /02igFQCw9JS/5HDe+r1aEgjRt1yT9tlfZdLY5DDnoqS2mwzEwc1c2+kts2y4BfKAByW
         Rk2A==
X-Gm-Message-State: AOJu0Yx3rlR/HQ5P/WxHa3fxgOSDmKUz0WZaBs6VaDYXCkrhvsG8mXVO
	cY2FwmViyKgzsK5MNViBXry/71xkIuPaAG0sT9PU9DuiYhUvEFNuA6dpWMSTb/fDBSS3+zzHurT
	j
X-Google-Smtp-Source: AGHT+IFawOtf5PX3/tyg6qDQmMEG+D6uKZmOe/72Y9mQtpW7ir+qL2vcSL/7Qn/jhgJXx6cwEoHnfw==
X-Received: by 2002:a05:6e02:350c:b0:365:224b:e5f7 with SMTP id bu12-20020a056e02350c00b00365224be5f7mr10762961ilb.1.1711994281077;
        Mon, 01 Apr 2024 10:58:01 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ge9-20020a056638680900b0047730da740dsm2685669jab.49.2024.04.01.10.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 10:57:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: add remote task_work execution helper
Date: Mon,  1 Apr 2024 11:56:26 -0600
Message-ID: <20240401175757.1054072-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240401175757.1054072-1-axboe@kernel.dk>
References: <20240401175757.1054072-1-axboe@kernel.dk>
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
index 9986e9bb825a..df4d9c9aeeab 100644
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


