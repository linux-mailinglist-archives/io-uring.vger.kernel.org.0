Return-Path: <io-uring+bounces-543-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4587084BAE8
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CF99FB22D7A
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 352E4134742;
	Tue,  6 Feb 2024 16:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hqr7BZsj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96994134751
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236855; cv=none; b=JuWN3oduIiHMPey88cOOZHUS7I7o1e+ZSVQHsSpHi/OFLKuALrNjx7Hp/l0hWsJzTswEUT1NBV53A4iBSKz6QuqSusXSl35btvBENDti3j/5wMwNeLY1+0BfR2htT9gwPxXIBo1XUVAX5nZaPs9ey3uraglh2h7nBwzCN213/v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236855; c=relaxed/simple;
	bh=llxWWIJLMUC6G4gnBEi54TwdikqeX/a5DdLpTgHz0YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWdpWf59K24nIunsvjt+yMOaY8u6RdM+9Dd6LW5hzPsqE5YpeE28kZvCPg+AQAA3pnhNNCLjtPQkQen42x648PTokKvnaA51atgz3gG1/YMmKkbEz+nATTFPUgvmdAoijdEjKFwDHJ9eZXPzUdc1cB0K1t4Q9AeByYpO/Cc7Z1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hqr7BZsj; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso74150339f.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236852; x=1707841652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eLH6DE53yx0jld1mygpcddfhbdnTIuRzvYOhl0FgAIY=;
        b=hqr7BZsjeSj8cGAipE2CCV7C12vJiRk4+BghQC0+BbeMXpaGIaV+Re3xMaWogwjCje
         iCVAAAx9teJDBojVu9auaOTVA0C7cC1u00azu562LUsvZ/347G6OBy1tMJfiKilJ/x4Q
         II5MMHNuFsqqovfm7JZawqihMqSqUiIsnqmgHpe4rZ3iKoNwguGY1iVvYZU7O6GDxREy
         YSWt8DWfeqQj3s1LMvOd/y6rSW3sy40leaFXCnAJNRGbiONdV5H6c1I5iqvGOB4nPCTG
         sCCGtY9JXP8hu9P9/UAdedZ7meYA/uQC1qo6ShnlBdGqoYFzP6S0qiGeZO2KQEamul2b
         C0kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236852; x=1707841652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eLH6DE53yx0jld1mygpcddfhbdnTIuRzvYOhl0FgAIY=;
        b=CjDl1AMHTfCN1L2a3jmvvGBgWSHVuoVngrlwwN850fW/Vpe5N7u21F2vyKWd3GfI34
         5WDFXAzSV2lNyFIwya1jiG3frbsDeTR98epYR2AWb4tlSRY4ISwIGALTLfA7Q7X1AU1Z
         PsduIoTUkEScHPBHo7dXWwu6wVhLLPHoLtjMUoBynJSak6tSXq3eOOvaHfIIzIjCgku3
         FxSh3F7e0/KyrLux6/WMjlT8JgxHTRwPXA0IqMkO3eoe0kYVh3MoLucMCaJNc+7ouzfA
         AQKnXZj/Y++6mxO3vaMNKxTCDz6RWlITPEuyRTdu4qnlJCIjdTeSBLso75BUKoI32Jgq
         hVvg==
X-Gm-Message-State: AOJu0YyxXwp8zYdwn/96AdibxGPKFUBmPolYR9h2jWpFL0WiwIXhwV/g
	O0Di7IAYgTduqXKtS/9+R3PS9WDISN9GAv3YIF0hMSRwiV4ygzzJ4qk3xAcc6je7XCdOc+fq7yv
	cvA8=
X-Google-Smtp-Source: AGHT+IGHwBwIIYownnFD9Jplqr3dXvtds83VT0eBHZNWF5JRgu3hsJGpj0vE+rDB6SQyYicUbFAB+w==
X-Received: by 2002:a6b:670e:0:b0:7c3:eda5:f41a with SMTP id b14-20020a6b670e000000b007c3eda5f41amr2935780ioc.1.1707236852169;
        Tue, 06 Feb 2024 08:27:32 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a1-20020a6b6601000000b007bffd556183sm513309ioc.14.2024.02.06.08.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:27:30 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/10] io_uring: remove looping around handling traditional task_work
Date: Tue,  6 Feb 2024 09:24:36 -0700
Message-ID: <20240206162726.644202-3-axboe@kernel.dk>
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

A previous commit added looping around handling traditional task_work
as an optimization, and while that may seem like a good idea, it's also
possible to run into application starvation doing so. If the task_work
generation is bursty, we can get very deep task_work queues, and we can
end up looping in here for a very long time.

One immediately observable problem with that is handling network traffic
using provided buffers, where flooding incoming traffic and looping
task_work handling will very quickly lead to buffer starvation as we
keep running task_work rather than returning to the application so it
can handle the associated CQEs and also provide buffers back.

Fixes: 3a0c037b0e16 ("io_uring: batch task_work")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 45 +++++++--------------------------------------
 1 file changed, 7 insertions(+), 38 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9b499864f10d..ae5b38355864 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1175,12 +1175,11 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 
 static unsigned int handle_tw_list(struct llist_node *node,
 				   struct io_ring_ctx **ctx,
-				   struct io_tw_state *ts,
-				   struct llist_node *last)
+				   struct io_tw_state *ts)
 {
 	unsigned int count = 0;
 
-	while (node && node != last) {
+	do {
 		struct llist_node *next = node->next;
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
@@ -1204,7 +1203,7 @@ static unsigned int handle_tw_list(struct llist_node *node,
 			*ctx = NULL;
 			cond_resched();
 		}
-	}
+	} while (node);
 
 	return count;
 }
@@ -1223,22 +1222,6 @@ static inline struct llist_node *io_llist_xchg(struct llist_head *head,
 	return xchg(&head->first, new);
 }
 
-/**
- * io_llist_cmpxchg - possibly swap all entries in a lock-less list
- * @head:	the head of lock-less list to delete all entries
- * @old:	expected old value of the first entry of the list
- * @new:	new entry as the head of the list
- *
- * perform a cmpxchg on the first entry of the list.
- */
-
-static inline struct llist_node *io_llist_cmpxchg(struct llist_head *head,
-						  struct llist_node *old,
-						  struct llist_node *new)
-{
-	return cmpxchg(&head->first, old, new);
-}
-
 static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 {
 	struct llist_node *node = llist_del_all(&tctx->task_list);
@@ -1273,9 +1256,7 @@ void tctx_task_work(struct callback_head *cb)
 	struct io_ring_ctx *ctx = NULL;
 	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
 						  task_work);
-	struct llist_node fake = {};
 	struct llist_node *node;
-	unsigned int loops = 0;
 	unsigned int count = 0;
 
 	if (unlikely(current->flags & PF_EXITING)) {
@@ -1283,21 +1264,9 @@ void tctx_task_work(struct callback_head *cb)
 		return;
 	}
 
-	do {
-		loops++;
-		node = io_llist_xchg(&tctx->task_list, &fake);
-		count += handle_tw_list(node, &ctx, &ts, &fake);
-
-		/* skip expensive cmpxchg if there are items in the list */
-		if (READ_ONCE(tctx->task_list.first) != &fake)
-			continue;
-		if (ts.locked && !wq_list_empty(&ctx->submit_state.compl_reqs)) {
-			io_submit_flush_completions(ctx);
-			if (READ_ONCE(tctx->task_list.first) != &fake)
-				continue;
-		}
-		node = io_llist_cmpxchg(&tctx->task_list, &fake, NULL);
-	} while (node != &fake);
+	node = llist_del_all(&tctx->task_list);
+	if (node)
+		count = handle_tw_list(node, &ctx, &ts);
 
 	ctx_flush_and_put(ctx, &ts);
 
@@ -1305,7 +1274,7 @@ void tctx_task_work(struct callback_head *cb)
 	if (unlikely(atomic_read(&tctx->in_cancel)))
 		io_uring_drop_tctx_refs(current);
 
-	trace_io_uring_task_work_run(tctx, count, loops);
+	trace_io_uring_task_work_run(tctx, count, 1);
 }
 
 static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
-- 
2.43.0


