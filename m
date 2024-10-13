Return-Path: <io-uring+bounces-3633-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99CF499BAD6
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 20:29:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C9DE1F214D4
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 18:29:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ADBA13D52C;
	Sun, 13 Oct 2024 18:29:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B062813AD22
	for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 18:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728844145; cv=none; b=dGdCemjC7/2Q4pbqHz57GZwMeReys0ZUqCW28JHZOxiTdxDVS9TgzzzBQ9CY0nfBHB09W1h7oRRakX7/hihKGVzsfj7+7NlvxFzubbKJiVLgbZv+N28J/1H60Dndd4LVf1MgKwOheba1yXuNJxlm/WU+y+pntDqJ6PUoxlgFG3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728844145; c=relaxed/simple;
	bh=jPcXzvTUPk1tjsQYyE6/m3gYkcrwXQrcu3P2eTCKMUM=;
	h=From:Date:Message-ID:In-Reply-To:References:To:Subject; b=WMvLUP8yklUiSYqP6yMcWFsMVSYhVjftlzMsk5nc6e9bQvjHwq5ZZqrWsKtrtd/OU+QZJuSwMfCkbo0Or6fl8LAxZuY3WplK4guNiFy2WIrUTRpcMz/WakIXS721IsXXF63ji57XfA18Pqoos2cKJ6mHaFPF+3LguKeb+/SvXiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=52780 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1t03Kw-0002lq-2J;
	Sun, 13 Oct 2024 14:29:02 -0400
From: Olivier Langlois <olivier@trillion01.com>
Date: Sun, 13 Oct 2024 14:29:02 -0400
Message-ID: <2680ca47ee183cfdb89d1a40c84d349edeb620ab.1728828877.git.olivier@trillion01.com>
In-Reply-To: <cover.1728828877.git.olivier@trillion01.com>
References: <cover.1728828877.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Subject: [PATCH v4 4/6] io_uring/napi: Use lock guards
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

Convert napi locks to use the shiny new Scope-Based Resource Management
machinery.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 io_uring/napi.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 5e2299e7ff8e..6d5fdd397f2f 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -49,14 +49,13 @@ int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id)
 
 	hash_list = &ctx->napi_ht[hash_min(napi_id, HASH_BITS(ctx->napi_ht))];
 
-	rcu_read_lock();
-	e = io_napi_hash_find(hash_list, napi_id);
-	if (e) {
-		WRITE_ONCE(e->timeout, jiffies + NAPI_TIMEOUT);
-		rcu_read_unlock();
-		return -EEXIST;
+	scoped_guard(rcu) {
+		e = io_napi_hash_find(hash_list, napi_id);
+		if (e) {
+			WRITE_ONCE(e->timeout, jiffies + NAPI_TIMEOUT);
+			return -EEXIST;
+		}
 	}
-	rcu_read_unlock();
 
 	e = kmalloc(sizeof(*e), GFP_NOWAIT);
 	if (!e)
@@ -65,6 +64,10 @@ int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id)
 	e->napi_id = napi_id;
 	e->timeout = jiffies + NAPI_TIMEOUT;
 
+	/*
+	 * guard(spinlock) is not used to manually unlock it before calling
+	 * kfree()
+	 */
 	spin_lock(&ctx->napi_lock);
 	if (unlikely(io_napi_hash_find(hash_list, napi_id))) {
 		spin_unlock(&ctx->napi_lock);
@@ -82,7 +85,7 @@ static void __io_napi_remove_stale(struct io_ring_ctx *ctx)
 {
 	struct io_napi_entry *e;
 
-	spin_lock(&ctx->napi_lock);
+	guard(spinlock)(&ctx->napi_lock);
 	/*
 	 * list_for_each_entry_safe() is not required as long as:
 	 * 1. list_del_rcu() does not reset the deleted node next pointer
@@ -96,7 +99,6 @@ static void __io_napi_remove_stale(struct io_ring_ctx *ctx)
 			kfree_rcu(e, rcu);
 		}
 	}
-	spin_unlock(&ctx->napi_lock);
 }
 
 static inline void io_napi_remove_stale(struct io_ring_ctx *ctx, bool is_stale)
@@ -168,11 +170,12 @@ static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
 	if (list_is_singular(&ctx->napi_list))
 		loop_end_arg = iowq;
 
-	rcu_read_lock();
-	do {
-		is_stale = __io_napi_do_busy_loop(ctx, loop_end_arg);
-	} while (!io_napi_busy_loop_should_end(iowq, start_time) && !loop_end_arg);
-	rcu_read_unlock();
+	scoped_guard(rcu) {
+		do {
+			is_stale = __io_napi_do_busy_loop(ctx, loop_end_arg);
+		} while (!io_napi_busy_loop_should_end(iowq, start_time) &&
+			 !loop_end_arg);
+	}
 
 	io_napi_remove_stale(ctx, is_stale);
 }
@@ -203,13 +206,12 @@ void io_napi_free(struct io_ring_ctx *ctx)
 {
 	struct io_napi_entry *e;
 
-	spin_lock(&ctx->napi_lock);
+	guard(spinlock)(&ctx->napi_lock);
 	list_for_each_entry(e, &ctx->napi_list, list) {
 		hash_del_rcu(&e->node);
 		kfree_rcu(e, rcu);
 	}
 	INIT_LIST_HEAD_RCU(&ctx->napi_list);
-	spin_unlock(&ctx->napi_lock);
 }
 
 /*
@@ -305,9 +307,9 @@ int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
 	if (list_empty_careful(&ctx->napi_list))
 		return 0;
 
-	rcu_read_lock();
-	is_stale = __io_napi_do_busy_loop(ctx, NULL);
-	rcu_read_unlock();
+	scoped_guard(rcu) {
+		is_stale = __io_napi_do_busy_loop(ctx, NULL);
+	}
 
 	io_napi_remove_stale(ctx, is_stale);
 	return 1;
-- 
2.47.0


