Return-Path: <io-uring+bounces-7298-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90885A752D3
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 00:11:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C78616E4C2
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 23:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 442C484E1C;
	Fri, 28 Mar 2025 23:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gds2eB6M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEC755E69
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 23:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743203476; cv=none; b=KJBM5ILIVxOnUXqb7VZIWL/i9uJeaHwCAqd3fvBCK2FmWuKMSzF/imWVav3zLemtGNXC5Lm2AFvG92PaffglM71NaH6q1Wuf3c5lA0zsMhcw1b0HmcQ2dUKMKbCirXfISBoRZQoaKUexi/Rpkowaj85km0aSGJZvyAciq7rmyL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743203476; c=relaxed/simple;
	bh=zzNtkvUrfeOOBoNxfSUZYr7UG8fRHlF70F71wLKfzG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqvCwNArC+RgaYbK8VY9LWhywLftDmqjpRjEd4lWpHyr5abD0GrgNUj57DwfcLw1EM2KHnOhtQEvebb37PaXN127VcHnt422+oHkYOrDSkRmqkTlw85Y/IUgxV5B4L7A7jrkuJnYVrAyPXQcaNlR4A5lnnG6shoQOMLfazdj/OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gds2eB6M; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ac2963dc379so424535266b.2
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 16:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743203472; x=1743808272; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rrg9HKTbnVX3X/GC5vKkjmMwZeokcH5kbmWyen5l6Pw=;
        b=gds2eB6MUOmlroTo7HXuGStiYRs1lzYfNMvHrwa1l6uwj/5zxNuTMy8KfNlzq71KFf
         UmueHiLrSipdPhNXJo9BoHmmTl2lr1yldBo7Y8xU/ZuWjbu/5HyHfjYn1Pw/sg3jNsAG
         AGhKkJrDCwL1wz7GH1pJ1XqiVfEAi2oyhHzxP80FUr0qT3VWe4KbeI7P9lrRHhVRPovq
         uWQsgo9CFMxETS7b1oarmPCORBYLIQSOQSIarKYPRYd0OgGGlz57NtrXScN7cAXGck2A
         QVN3/AAUk0yJh+5WMxwzvmwbU1zGv71dqvdqcQxCnv8IB3SUZ+lVppJrwEwIkinCpAyi
         YPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743203472; x=1743808272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rrg9HKTbnVX3X/GC5vKkjmMwZeokcH5kbmWyen5l6Pw=;
        b=sh5W7qlUidaXV571W2FUYota6gom60GSIHLqVnBp89mRZIk9jJkEuXXK9Le9D0pKzl
         7igUYk9W48otJtht/iJOZhtO1TuC6Q57L5BIIQfcCEGcSSEfsR/LBkGViNU9kEhvmXst
         gzDv1Itgf9eX+gFEB6BCqs3/qeS5aD0F3/fIXZCUaqFQPVkgy2PMjxLZmSuTwbhmSkra
         KiAKAslkl21+vBMMXUKSMKa3M+H0z/QzZnAgoa2/JKeLlhRjLRJI5R4wiHLVsg2XHFE/
         HY4Q9zwFFmyV3cEsqC8BYrRhxjf1yZJ6jL9DLUxdyCPek+SuixzVO3f7fX+p88Ay+A21
         4Oxg==
X-Gm-Message-State: AOJu0YzPdoMVzx1GED07bbbe+KRBLLZ49eCKy4ofBmXgeTpHBayja6UF
	l7aCs1FURVJ6auuA672LkGLezjGD0ae8VJe3wuAg8AeY2rN6XZxTWZgL1g==
X-Gm-Gg: ASbGnctMbx6ZM88q17xmNJPfhcybaIkLVDOWLVuYHJwvOQm1f7iHCj1jpjl3ON4w6EJ
	8D0rD9B2L2HVSD+WP2dpuroPvFnDtqEQ2zTWZ+yH+3WBPUYvyoE2EA1xJOqgA13tSFZGxQjThHO
	GQN091sP47xprR6Rni8UBXXy4iN9t5COf4mHKXvIO8yYGSmPqseeeCEch//bBG4ccKm2z6yU2ez
	KGe46tM+gblF63zGG+mS5vUPcDPDz/4DoUGt4HZSYcOIDK2YnDrIedgMWTcEKqrGVn9MgVEWCL3
	fMd1RuHOTbXT1zAGDM9sO6tVcwuJavlwLAqAvz6aMaJKs8XvTp56o71LG6g598izFeE5tg==
X-Google-Smtp-Source: AGHT+IE3pYEPeiTblj/i8Srzv2hVCRdjuJRytgjc83rYhjQJ58zHp9yeIrjHKzuHMMXbBh8W9t741A==
X-Received: by 2002:a17:907:7f22:b0:ac6:f6f4:adad with SMTP id a640c23a62f3a-ac738b5160fmr80344666b.45.1743203472276;
        Fri, 28 Mar 2025 16:11:12 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71966df80sm222838166b.125.2025.03.28.16.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 16:11:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/3] io_uring: don't pass ctx to tw add remote helper
Date: Fri, 28 Mar 2025 23:11:51 +0000
Message-ID: <721f51cf34996d98b48f0bfd24ad40aa2730167e.1743190078.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743190078.git.asml.silence@gmail.com>
References: <cover.1743190078.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unlike earlier versions, io_msg_remote_post() creates a valid request
with a proper context, so don't pass a context to
io_req_task_work_add_remote() explicitly but derive it from the request.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 14 ++++++--------
 io_uring/io_uring.h |  3 +--
 io_uring/msg_ring.c |  2 +-
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4e362c8542a7..cb17deffd6ca 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1141,10 +1141,9 @@ void tctx_task_work(struct callback_head *cb)
 	WARN_ON_ONCE(ret);
 }
 
-static inline void io_req_local_work_add(struct io_kiocb *req,
-					 struct io_ring_ctx *ctx,
-					 unsigned flags)
+static void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 {
+	struct io_ring_ctx *ctx = req->ctx;
 	unsigned nr_wait, nr_tw, nr_tw_prev;
 	struct llist_node *head;
 
@@ -1239,17 +1238,16 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
 {
 	if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
-		io_req_local_work_add(req, req->ctx, flags);
+		io_req_local_work_add(req, flags);
 	else
 		io_req_normal_work_add(req);
 }
 
-void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
-				 unsigned flags)
+void io_req_task_work_add_remote(struct io_kiocb *req, unsigned flags)
 {
-	if (WARN_ON_ONCE(!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)))
+	if (WARN_ON_ONCE(!(req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)))
 		return;
-	io_req_local_work_add(req, ctx, flags);
+	__io_req_task_work_add(req, flags);
 }
 
 static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2308f39ed915..861f4fcb1398 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -89,8 +89,7 @@ struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 			       unsigned issue_flags);
 
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
-void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
-				 unsigned flags);
+void io_req_task_work_add_remote(struct io_kiocb *req, unsigned flags);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
 void io_req_task_complete(struct io_kiocb *req, io_tw_token_t tw);
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 6c51b942d020..50a958e9c921 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -100,7 +100,7 @@ static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->ctx = ctx;
 	req->tctx = NULL;
 	req->io_task_work.func = io_msg_tw_complete;
-	io_req_task_work_add_remote(req, ctx, IOU_F_TWQ_LAZY_WAKE);
+	io_req_task_work_add_remote(req, IOU_F_TWQ_LAZY_WAKE);
 	return 0;
 }
 
-- 
2.48.1


