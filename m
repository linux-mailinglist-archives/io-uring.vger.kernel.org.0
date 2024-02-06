Return-Path: <io-uring+bounces-549-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 86EDD84BAEA
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:27:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1D1A1F24689
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D975134CD3;
	Tue,  6 Feb 2024 16:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rk2DPj9x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBED132C0B
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236867; cv=none; b=dkQW9K7wgL64WZu23fWwytAcH7LLdvTdFOzLbbq+rgUr5GZSpP7RUS5A0cbtAG5RT/IK6+4Ovg3uc8ZucxV0JLuDoex0BgxPkeGjytv/wlWqcmEQY638xO1nUXvQtw9/4tN5s8SxlKR2WTP4J4L0IlqtN8tuN8dni5zshhlcJaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236867; c=relaxed/simple;
	bh=A8v5M+kh6Kj98O4IuUeYD895rOnf2yOV0i92sC0594s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNqthcsC6nw0Wo5Tz9cCvPASFTKxO4a5juz6eguGcyu7gI0Mw7GtMqwHLqFOxw3uOMH2tLWPamBKHI/h7837Zr6wMT9DYDexqy8v9IU/QzsuDzGoB42i06oVAOKXZgEIRh7Hq/nbhwxijYElDrOdhMxi80fJKUIoLgrcXnWEKnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rk2DPj9x; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7c3e06c8608so30228539f.1
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236864; x=1707841664; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vbJhfpH4iKSKSZ/16S2TsiEr44tXFsUlzF+G3Ah5qqg=;
        b=rk2DPj9xUY/dXtSEj5WutGPjSJ5GeBGryHaCz+wQ73/bG0FAw/2sQqTA6eftb6hjFu
         vAJf0JbHOnY+qGdSiWsTaLeIt3aD0gFhRaWK5RtIV3uXOZYUhih5DEzaubeoEsjbOFsN
         cKKLgoaqEFS1C6J2Kw2DYmEt3vGPj7Ls2LcPXpWFhr6WlfymwHwdYpSUG6Yn+8dyxG4a
         QrhEWIjLWHpyRAtuO79aVg42hjBI6OT+ttHwzZkNUgLwmJlYAD+3oKn+tFphvpVk6ycx
         8CuSOX1si7Gw9nbJ1daagS4BDpTwgZAZ9gzeZ/ZxTEn4vjP75tv5lCt49aoNBvcjyALT
         wzUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236864; x=1707841664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vbJhfpH4iKSKSZ/16S2TsiEr44tXFsUlzF+G3Ah5qqg=;
        b=bf/wS6ydUZaDPjdaujeDvDAhnAVOxrKPx7RAiKP4dBV7rjcSzyodLyrNhvS+UBgaTR
         J2CoeMwfQk0tZi5cbSZBYjKwsfRcwdpGq+j6RcY1AMWgQ8HnUXELejGnDEPESeZZ1DYr
         0mS34RJ8DHbqJPHMGh18B/9/RAA9vnhMLHdbKnZ4eY4NJBeGDju77Ptq3wkNozfjxCQG
         BtoKW5uGqFUCgm9RM9L0zkshrc5bxFIuSWHlzjbCpgjw3T43PqQgWGeKhPQTDAfV5Boh
         Hj6esLY2mnEY0oy6QBctSLxP3NZlI76ixs1zT6sZ0/xcRc14oNgB9tFT6qQUCqN9qrOY
         i+2A==
X-Gm-Message-State: AOJu0Yxztp0EuD/FYGZ9YvWFV8GaUZwn7ZwHaMCckymXddEof6x571GG
	zUzv4NTPa6OYcM92I9AMJsy3KT2LATM8JOedZjOfCl/AG5jOAmxauSUehqBEnB6iR5xdlYXmd3h
	LibY=
X-Google-Smtp-Source: AGHT+IGSSsVLQiWDs3N6ML78uWrmHKo+Opl7QzDtncSvoCo/Zhf/bdLpoXM+tcVya/YGoGZHQ+rYtA==
X-Received: by 2002:a6b:db13:0:b0:7c3:edbb:1816 with SMTP id t19-20020a6bdb13000000b007c3edbb1816mr2791524ioc.2.1707236864514;
        Tue, 06 Feb 2024 08:27:44 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a1-20020a6b6601000000b007bffd556183sm513309ioc.14.2024.02.06.08.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:27:42 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/10] io_uring: cleanup handle_tw_list() calling convention
Date: Tue,  6 Feb 2024 09:24:42 -0700
Message-ID: <20240206162726.644202-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206162726.644202-1-axboe@kernel.dk>
References: <20240206162726.644202-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that we don't loop around task_work anymore, there's no point in
maintaining the ring and locked state outside of handle_tw_list(). Get
rid of passing in those pointers (and pointers to pointers) and just do
the management internally in handle_tw_list().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ddbce269b6a7..df02ed6677c5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1173,10 +1173,10 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 	percpu_ref_put(&ctx->refs);
 }
 
-static unsigned int handle_tw_list(struct llist_node *node,
-				   struct io_ring_ctx **ctx,
-				   struct io_tw_state *ts)
+static unsigned int handle_tw_list(struct llist_node *node)
 {
+	struct io_ring_ctx *ctx = NULL;
+	struct io_tw_state ts = { };
 	unsigned int count = 0;
 
 	do {
@@ -1184,25 +1184,26 @@ static unsigned int handle_tw_list(struct llist_node *node,
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
 
-		if (req->ctx != *ctx) {
-			ctx_flush_and_put(*ctx, ts);
-			*ctx = req->ctx;
+		if (req->ctx != ctx) {
+			ctx_flush_and_put(ctx, &ts);
+			ctx = req->ctx;
 			/* if not contended, grab and improve batching */
-			ts->locked = mutex_trylock(&(*ctx)->uring_lock);
-			percpu_ref_get(&(*ctx)->refs);
+			ts.locked = mutex_trylock(&ctx->uring_lock);
+			percpu_ref_get(&ctx->refs);
 		}
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
-				req, ts);
+				req, &ts);
 		node = next;
 		count++;
 		if (unlikely(need_resched())) {
-			ctx_flush_and_put(*ctx, ts);
-			*ctx = NULL;
+			ctx_flush_and_put(ctx, &ts);
+			ctx = NULL;
 			cond_resched();
 		}
 	} while (node);
 
+	ctx_flush_and_put(ctx, &ts);
 	return count;
 }
 
@@ -1250,8 +1251,6 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 
 void tctx_task_work(struct callback_head *cb)
 {
-	struct io_tw_state ts = {};
-	struct io_ring_ctx *ctx = NULL;
 	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
 						  task_work);
 	struct llist_node *node;
@@ -1264,9 +1263,7 @@ void tctx_task_work(struct callback_head *cb)
 
 	node = llist_del_all(&tctx->task_list);
 	if (node)
-		count = handle_tw_list(llist_reverse_order(node), &ctx, &ts);
-
-	ctx_flush_and_put(ctx, &ts);
+		count = handle_tw_list(llist_reverse_order(node));
 
 	/* relaxed read is enough as only the task itself sets ->in_cancel */
 	if (unlikely(atomic_read(&tctx->in_cancel)))
-- 
2.43.0


