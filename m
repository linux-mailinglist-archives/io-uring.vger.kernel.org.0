Return-Path: <io-uring+bounces-3632-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B0ED699BAD5
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 20:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5995E1F2141D
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 18:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F070113D52C;
	Sun, 13 Oct 2024 18:28:53 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8674B13AD22
	for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 18:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728844133; cv=none; b=mf/WN9NBDz6o3piWo0OQxf03zqIAlG8f5xI7wr6dtiPvF96qMonhIuCjDo+ypPgBwRQLp4QJzUB/6qaLTmHBJ7MsTV3dGr/27IcExad50YBG7l66BnSxpTEohu5/prsxc1noMq6xQfJZYAF7lDfMPFLtPuZndg5LJXjgWK5blCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728844133; c=relaxed/simple;
	bh=pygfYihDgA3LjNtu/7GYo38yPcgPaTexokneQUDDEEA=;
	h=From:Date:Message-ID:In-Reply-To:References:To:Subject; b=B1FM1YGzRHo+oSHApUtd9608pUFMBKpKKVHeE87/MSahJyk+OzKKEg6uoO58KZsJHLfIW49nwQLVfyJI4HmLC0k/n4CJtKUHqKF80onDZtC5oipDsw2JfIvFZCJK6DahiknyMtUX7s7USccdgN3EBe0hadgnr1vaUDMysm3Gxxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=44464 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1t03Kl-0002l7-0W;
	Sun, 13 Oct 2024 14:28:51 -0400
From: Olivier Langlois <olivier@trillion01.com>
Date: Sun, 13 Oct 2024 14:28:50 -0400
Message-ID: <d637fa3b437d753c0f4e44ff6a7b5bf2c2611270.1728828877.git.olivier@trillion01.com>
In-Reply-To: <cover.1728828877.git.olivier@trillion01.com>
References: <cover.1728828877.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Subject: [PATCH v4 3/6] io_uring/napi: improve __io_napi_add
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

1. move the sock->sk pointer validity test outside the function to
   avoid the function call overhead and to make the function more
   more reusable
2. change its name to __io_napi_add_id to be more precise about it is
   doing
3. return an error code to report errors

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 io_uring/napi.c | 19 ++++++-------------
 io_uring/napi.h |  6 +++---
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 921de9de8d75..5e2299e7ff8e 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -38,22 +38,14 @@ static inline ktime_t net_to_ktime(unsigned long t)
 	return ns_to_ktime(t << 10);
 }
 
-void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
+int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id)
 {
 	struct hlist_head *hash_list;
-	unsigned int napi_id;
-	struct sock *sk;
 	struct io_napi_entry *e;
 
-	sk = sock->sk;
-	if (!sk)
-		return;
-
-	napi_id = READ_ONCE(sk->sk_napi_id);
-
 	/* Non-NAPI IDs can be rejected. */
 	if (napi_id < MIN_NAPI_ID)
-		return;
+		return -EINVAL;
 
 	hash_list = &ctx->napi_ht[hash_min(napi_id, HASH_BITS(ctx->napi_ht))];
 
@@ -62,13 +54,13 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
 	if (e) {
 		WRITE_ONCE(e->timeout, jiffies + NAPI_TIMEOUT);
 		rcu_read_unlock();
-		return;
+		return -EEXIST;
 	}
 	rcu_read_unlock();
 
 	e = kmalloc(sizeof(*e), GFP_NOWAIT);
 	if (!e)
-		return;
+		return -ENOMEM;
 
 	e->napi_id = napi_id;
 	e->timeout = jiffies + NAPI_TIMEOUT;
@@ -77,12 +69,13 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
 	if (unlikely(io_napi_hash_find(hash_list, napi_id))) {
 		spin_unlock(&ctx->napi_lock);
 		kfree(e);
-		return;
+		return -EEXIST;
 	}
 
 	hlist_add_tail_rcu(&e->node, hash_list);
 	list_add_tail_rcu(&e->list, &ctx->napi_list);
 	spin_unlock(&ctx->napi_lock);
+	return 0;
 }
 
 static void __io_napi_remove_stale(struct io_ring_ctx *ctx)
diff --git a/io_uring/napi.h b/io_uring/napi.h
index fd275ef0456d..4ae622f37b30 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -15,7 +15,7 @@ void io_napi_free(struct io_ring_ctx *ctx);
 int io_register_napi(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg);
 
-void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock);
+int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id);
 
 void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq);
 int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx);
@@ -48,8 +48,8 @@ static inline void io_napi_add(struct io_kiocb *req)
 		return;
 
 	sock = sock_from_file(req->file);
-	if (sock)
-		__io_napi_add(ctx, sock);
+	if (sock && sock->sk)
+		__io_napi_add_id(ctx, READ_ONCE(sock->sk->sk_napi_id));
 }
 
 #else
-- 
2.47.0


