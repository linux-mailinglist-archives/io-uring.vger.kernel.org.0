Return-Path: <io-uring+bounces-411-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F29F82FE24
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 01:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9E3B28B8E9
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 00:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3F6C17E9;
	Wed, 17 Jan 2024 00:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XwJo1JTL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34266138E
	for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 00:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705453170; cv=none; b=LE2TV/1IHr+x0hLRNSJtdZKhwrl0zp1wh+3ql1PcaPV+lMWJI2cg8m1MS/pEEUqHuAVd/DFRx7B7TjB2fsLME65moU75oo1wiRFcomnXG5XnjYZ6NVY1cNE6ya0EmfWZhfLyLpdAELxU6675yoLNYU4nEf4fj52FLgj0nL4Rgdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705453170; c=relaxed/simple;
	bh=rRFNEh5/N51L2i8Mdq5SIEhRw7W3IA/LOnvqibLLf78=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding; b=tG0yQUc0ioObmR/5PKs83J3PmWmuyfLuCib0/EhDjdvWFgQ1B1FdplXps02rLtfYtCjXlnoo4PAN9b/+MlSrGkxecAEn5wXgvlW7n9sw/O2j6FKb2sIjk7C3ZN/VbQlL4IiqqzQZQKSxVKc8Mqli3aHApyIfEED0y6ZYpU9TD34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XwJo1JTL; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-55817a12ad8so8410138a12.2
        for <io-uring@vger.kernel.org>; Tue, 16 Jan 2024 16:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705453167; x=1706057967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0tg1lNXY4N8veawkRu72zeREgoxTdgotTNGnpnLmM60=;
        b=XwJo1JTLR9TPOVogdYoHWVPIJgFTB9bIhxA5nVoCskwOYpeSGwPfbA02POiCo+3a+V
         +m2LhvEJXGXYNLp4YqwuLAsv3EGTQc42xZnF89wHLDDKykB4++CdrMMYpS4wClFyDqdv
         HG9KlilMlxC9saMST8okXMkNooeEK7y6wTJNnRu2jlK+BMqVffaIaoHGhGQ9uWkRUrY5
         ynKiSsPr3/Kc0QJJpV29JY4PXaCEaHZljYqXtA9fJbekE6ayd+3t1Z8wLQbCYTHzkea6
         gjHgRED18RC6meUxwUQV3rKuiS0lqXMlTFmP/X+az4QySljLD7220z3kPIqECnClbYAX
         TNag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705453167; x=1706057967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0tg1lNXY4N8veawkRu72zeREgoxTdgotTNGnpnLmM60=;
        b=D1GB6AtF98oAkO46s+5+MD53XwbwytgKtAg2qEftANOp9uRmdm3um057k1lPS1xg5F
         RnsoWD2vKQDVklxTNHalkhlifMkMzmcaiAJnMQN2cF3zSMGmQcvbXouYLjh7/NkanzvU
         Vro1s+vuTXk63hnkoxtLUhgji8WbxEmmvr3IrqEdv8Vb5DqZmJfRqukRhZGkOHZdXz9S
         klR0rk9nxiOTr/djlmL8t+ViCrPM3OduqXwpXKDSHsNGq3RtqgJ+y6KM1oznFctLQcnC
         +Dm5A9DDSk4l+h7WEbZi9ID4JVbO2dAd8xGSt2RojfensHphZZIvNTWCETAvJNHJFAZe
         Xshw==
X-Gm-Message-State: AOJu0YyTLUlwCch/HBID7Ft592T7cnqcqPb4Yb1Ju1TP35B2nqbTJdF0
	zNljbrzYxTRYXcE296qngMk7WqFo9Qw=
X-Google-Smtp-Source: AGHT+IHhNYuofaQX09fGAVkWba+n7ihK8UYhm8pSbuqC90qp50ZtF2m4lbVeBVW3d1W7A73YlSmKPA==
X-Received: by 2002:a17:906:38c2:b0:a28:b021:abe5 with SMTP id r2-20020a17090638c200b00a28b021abe5mr3903084ejd.126.1705453167123;
        Tue, 16 Jan 2024 16:59:27 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.96])
        by smtp.gmail.com with ESMTPSA id t15-20020a17090605cf00b00a28aa4871c7sm7038982ejt.205.2024.01.16.16.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jan 2024 16:59:26 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 3/4] io_uring: clean *local_work_add var naming
Date: Wed, 17 Jan 2024 00:57:28 +0000
Message-ID: <3b8be483b52f58a524185bb88694b8a268e7e85d.1705438669.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1705438669.git.asml.silence@gmail.com>
References: <cover.1705438669.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

if (!first) { ... }

While it reads as do something if it's not the first entry, it does
exactly the opposite because "first" here is a pointer to the first
entry. Remove the confusion by renaming it into "head".

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3ab7e6a46149..3508198d17ba 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1304,16 +1304,16 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned nr_wait, nr_tw, nr_tw_prev;
-	struct llist_node *first;
+	struct llist_node *head;
 
 	if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
 		flags &= ~IOU_F_TWQ_LAZY_WAKE;
 
-	first = READ_ONCE(ctx->work_llist.first);
+	head = READ_ONCE(ctx->work_llist.first);
 	do {
 		nr_tw_prev = 0;
-		if (first) {
-			struct io_kiocb *first_req = container_of(first,
+		if (head) {
+			struct io_kiocb *first_req = container_of(head,
 							struct io_kiocb,
 							io_task_work.node);
 			/*
@@ -1328,8 +1328,8 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 			nr_tw = INT_MAX;
 
 		req->nr_tw = nr_tw;
-		req->io_task_work.node.next = first;
-	} while (!try_cmpxchg(&ctx->work_llist.first, &first,
+		req->io_task_work.node.next = head;
+	} while (!try_cmpxchg(&ctx->work_llist.first, &head,
 			      &req->io_task_work.node));
 
 	/*
@@ -1340,7 +1340,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	 * is similar to the wait/wawke task state sync.
 	 */
 
-	if (!first) {
+	if (!head) {
 		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 		if (ctx->has_evfd)
-- 
2.43.0


