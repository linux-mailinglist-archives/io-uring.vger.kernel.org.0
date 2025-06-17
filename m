Return-Path: <io-uring+bounces-8386-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B62F4ADCBF1
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:50:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0258718984E6
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 12:50:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6188F28BAB3;
	Tue, 17 Jun 2025 12:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LzKYQwER"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7241F874C
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 12:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750164569; cv=none; b=bH6OGpIVIvUwi4MQa7j7BTvamC8FhrPT6dv19A4ijA7+JOVlaFGkt7p8b6utFdbnmiQJVgcjV5zieDGTDsPZFuG01K9bmJGLjTK+vS2hmgN/vZT0OxyDYbLMgZySDFgGqb5M9Me95Qh82hbz73srwCCNEBWH0cjtSDGmf0r1uuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750164569; c=relaxed/simple;
	bh=YnhGYsChP7V5qQvM8tVIaMv/2vyhq0Olayiiz1sEQFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clsW4CAgw+EwwodM8qIYsrbGt3epmTU3wqM+JQq7KMdFUj9ApuhSplzOI+We5KHSAjkdytFWXA0wrlm06oKonjGrfRkHDmwCY6jT8Wo4wKSOyb0gGra3G4xFkVVwnCve3nqVkB9TXiGVcUb1UviIrI6EX0EYrn8xm39kJ+VIqUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LzKYQwER; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3de0f5ff22dso8994715ab.1
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 05:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750164566; x=1750769366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+v1TEp7JFvHZOwfztPs2w4IdI9A1YGYm2Jk/PztqfwQ=;
        b=LzKYQwER8VMjbni9dOm1PpFfGQYGK/JSl7kzdD+5IcJDA3Uo29ymt8XfYOHSe2ecYZ
         lh/hIT/GQD9hJ3yhxmU711mAalGXlA1rs+1MGQcq8qCM4nNL68S0DyypPRHwTcTrdOL0
         d/+QA/Djagx+cFs0lsDRgJo/RsHgGm00ON8cEHd7Xe+g2Z8JKgSVybjfyvpJJlvWuvam
         wyNlMPd6JG7e7upwUyCvrGaAddTkBp38Fhw0+4j67Bf4FHrXd6wl+OXsiAo69pRApbZF
         mnncvaIQ1qUNNnzSjBEuGgOAHiFUBHPA6EH/ZkySlqR+S2HAdzzj0C0eJz99+Fyp9uai
         Y0sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750164566; x=1750769366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+v1TEp7JFvHZOwfztPs2w4IdI9A1YGYm2Jk/PztqfwQ=;
        b=P6nKmnBYNUrDq7M+aA+cNdnwtg6beM2peShhNhsSxuwC9JEb21/Bq8E4AvzN+JQGr7
         Q9LtMKQv2ihAj0CQ0lVgYU2bpmFHEwVuIBY/x3deOwUUuuwliMH/VIrk037BP7mq6kcu
         iEJr724ALl9DWVFBuDZGgDTlslGz5cOr5neN/2GBSY+tZvDdt5K1KNujxZYNlKvk016q
         arnT2IX7Ol+5keAvr7hpNisIpAZkZzkjDNQZSP+0Wc843CchKdNFMEtBUCHlL4l/eziZ
         hWYp76frUy67tgK1hZiEfUdc6HcVeb3plPF9ihuYHZ9NEGpE9OOsihy4kEhFHGFFc5YY
         cwbg==
X-Gm-Message-State: AOJu0Yw9T45RQP4ow37fXY3WbpVLIgoPHC3RcsT/B6Kkq3+R6vSugf15
	UyzmFW3dYq606f+J3mA742UmttZN5CxYFnAFkO0a7Y+5O/+9ymilPyvbfjsb44smUNLjF2Jh5W2
	Y7JRW
X-Gm-Gg: ASbGncsxEBlsyd5uPvfw75o50yPkSMWC+Yqmenqj6EiXGvzENtyR6fxDuFYzNqj4tGo
	V0LWiGSIDiTc1zncHGGgPiXp5L9+NOy7/ZTWEgaa8hLZP6NPef+2vIQDPwStKHTE8teuzBwTdS8
	2A6eyJxOrJliwAvHEz9NV5r9+xTxddC4qrWOPrx2iauk89sgaNoRMQ/vkwlgWWZBpclz+DrZKBv
	diy1vYxSeaQ9hhcXQ5jPka4vOamb75cKRGIbAvFJyH4GurZwjVlA9gOqOoVTx3Lc0Pf03I/GSnH
	DeHOh/l7MHFrEIT4sMah742kxXDdL85SBn2BTJw26HFl4HI2IiEKUBmF
X-Google-Smtp-Source: AGHT+IF7PRjzCR0vK3rffdZAWLOVjbGDrFc+KLhuLQLtrcgtjxqGSBYXrKZnC9KHhbQJHO7FEO41EQ==
X-Received: by 2002:a05:6e02:461b:b0:3dd:c067:20bf with SMTP id e9e14a558f8ab-3de22c13552mr28391185ab.2.1750164566109;
        Tue, 17 Jun 2025 05:49:26 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50149c6c900sm2161057173.76.2025.06.17.05.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 05:49:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+763e12bbf004fb1062e4@syzkaller.appspotmail.com
Subject: [PATCH 2/2] io_uring/sqpoll: don't put task_struct on tctx setup failure
Date: Tue, 17 Jun 2025 06:48:32 -0600
Message-ID: <20250617124920.1187544-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250617124920.1187544-1-axboe@kernel.dk>
References: <20250617124920.1187544-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A recent commit moved the error handling of sqpoll thread and tctx
failures into the thread itself, as part of fixing an issue. However, it
missed that tctx allocation may also fail, and that
io_sq_offload_create() does its own error handling for the task_struct
in that case.

Remove the manual task putting in io_sq_offload_create(), as
io_sq_thread() will notice that the tctx did not get setup and hence it
should put itself and exit.

Reported-by: syzbot+763e12bbf004fb1062e4@syzkaller.appspotmail.com
Fixes: ac0b8b327a56 ("io_uring: fix use-after-free of sq->thread in __io_uring_show_fdinfo()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/sqpoll.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index fa5a6750ee52..a3f11349ce06 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -420,7 +420,6 @@ void io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 				struct io_uring_params *p)
 {
-	struct task_struct *task_to_put = NULL;
 	int ret;
 
 	/* Retain compatibility with failing for an invalid attach attempt */
@@ -499,7 +498,7 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 		rcu_assign_pointer(sqd->thread, tsk);
 		mutex_unlock(&sqd->lock);
 
-		task_to_put = get_task_struct(tsk);
+		get_task_struct(tsk);
 		ret = io_uring_alloc_task_context(tsk, ctx);
 		wake_up_new_task(tsk);
 		if (ret)
@@ -514,8 +513,6 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 	complete(&ctx->sq_data->exited);
 err:
 	io_sq_thread_finish(ctx);
-	if (task_to_put)
-		put_task_struct(task_to_put);
 	return ret;
 }
 
-- 
2.50.0


