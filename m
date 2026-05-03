Return-Path: <io-uring+bounces-13215-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gGn7EGKM92mIiwIAu9opvQ
	(envelope-from <io-uring+bounces-13215-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 19:56:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D665F4B6DCB
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 19:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AC2D8300132D
	for <lists+io-uring@lfdr.de>; Sun,  3 May 2026 17:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7768638B7C9;
	Sun,  3 May 2026 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DiEQIAh6"
X-Original-To: io-uring@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E67D2F5321
	for <io-uring@vger.kernel.org>; Sun,  3 May 2026 17:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777831006; cv=none; b=sv9VI5/3CpzOsxlIf7IixNx5BZbODxx1w2CdjYM0G6PQrwaYhpJLHUw5hzfGGDgSOOUlE/lsDljYINntg//akiZ6w5s7Xmppuwh5y9aA7k8Biy3rur1oZNnYIUWHhRkZra+Al9BxX31uHAWajM45e/cCcK68S48q2ueAGspLMB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777831006; c=relaxed/simple;
	bh=7ahk+cyd+Ykz0DPf7VMnmcmikFGXAUd7gkJxFqh0OM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LA7jo3Li2CcNE0jvl16vG3jaq6NlmfWyIh+JoN+kNSo+zt1+Ug0EXDtL70QhyFIScLbqZo/k1h2Q1xa0CNcnkQ7WD5p+Dxb4F3wQ+7O8bomi27ywMlo+J7qZWGDUXuugzyy/D76e80lKDBu3DYmP2KyAMKB77IxN+QxzoX6l5GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DiEQIAh6; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777830992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KVZAyenmg6uHIjzqnMjtVdghGxJ7d9wH9NxhdoU4n8s=;
	b=DiEQIAh6pEpaLsM5rumkKgAFY2sGbHuWXKhBs1S+8exoBFGO/zX7CXeDoIQyhOJD1hJ8um
	C2GFWkIES1MvhKtSLABpgGS/9u29JWBk2iaG9qHq0WzNtrQQnWTozsP7lN4XF2a1ZLg8oc
	yp2M2M+qDq3it7QnXhagw+9M5IfFMvY=
From: Yufan Chen <yufan.chen@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yufan Chen <ericterminal@gmail.com>
Subject: [PATCH] io_uring/napi: clear tracked NAPI entries on unregister
Date: Mon,  4 May 2026 01:56:10 +0800
Message-ID: <20260503175610.35521-1-yufan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5179; i=ericterminal@gmail.com; h=from:subject; bh=Mr1xhXx7+1wrsNWOap7PT4FX8fgwPSFqmjcW06xdup8=; b=owGbwMvMwCXWM/dCzeS3H+sZT6slMWR+71ox7Yzg3DXu7Z+bFrv9ncLW5qWlVLvtvGR88bPwa v2LvusPd0xkYRDjYrAUU2S5+3/f3FyvW3Oucx/OhZnDygQyRFqkgQEIWBj4chPzSo10jPRMtQ31 DI10DHSMGbg4BWCqL3UwMjRnaPG/iVeaUHPtdUiCzhRhsZPXXH9f8Hqr0CygV35o1kyGP1xMrv/ DdywLmvNyEs9XKfW8RQeWPXeP3DVJ/+nqEK15TQwA
X-Developer-Key: i=ericterminal@gmail.com; a=openpgp; fpr=DDFFBE9D6D4ADA9CD70BC36D8C9DD07C93EDF17F
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D665F4B6DCB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13215-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yufan.chen@linux.dev,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]

From: Yufan Chen <ericterminal@gmail.com>

IORING_UNREGISTER_NAPI disables NAPI busy polling, but it currently
leaves any previously tracked NAPI IDs on the ring context. The normal
wait path only checks whether the list is empty before entering the busy
poll helper, so an unregistered ring can still observe stale entries and
run an unexpected busy poll pass.

Make unregister switch the context to inactive and free the tracked
entries. Do the same inactive transition while changing the tracking
strategy, and recheck the expected tracking mode under napi_lock before
inserting a newly learned NAPI ID. This prevents a racing poll path from
repopulating the list after unregister or reconfiguration.

Also make the busy poll dispatcher ignore inactive mode explicitly.

Signed-off-by: Yufan Chen <ericterminal@gmail.com>
---
 io_uring/napi.c | 27 ++++++++++++++++++++-------
 io_uring/napi.h |  8 +++++---
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 8d68366a4b9..bfc77144591 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -38,7 +38,8 @@ static inline ktime_t net_to_ktime(unsigned long t)
 	return ns_to_ktime(t << 10);
 }
 
-int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id)
+int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id,
+		     unsigned int mode)
 {
 	struct hlist_head *hash_list;
 	struct io_napi_entry *e;
@@ -69,6 +70,11 @@ int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id)
 	 * kfree()
 	 */
 	spin_lock(&ctx->napi_lock);
+	if (unlikely(READ_ONCE(ctx->napi_track_mode) != mode)) {
+		spin_unlock(&ctx->napi_lock);
+		kfree(e);
+		return -EINVAL;
+	}
 	if (unlikely(io_napi_hash_find(hash_list, napi_id))) {
 		spin_unlock(&ctx->napi_lock);
 		kfree(e);
@@ -196,9 +202,14 @@ __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
 		       bool (*loop_end)(void *, unsigned long),
 		       void *loop_end_arg)
 {
-	if (READ_ONCE(ctx->napi_track_mode) == IO_URING_NAPI_TRACKING_STATIC)
+	switch (READ_ONCE(ctx->napi_track_mode)) {
+	case IO_URING_NAPI_TRACKING_STATIC:
 		return static_tracking_do_busy_loop(ctx, loop_end, loop_end_arg);
-	return dynamic_tracking_do_busy_loop(ctx, loop_end, loop_end_arg);
+	case IO_URING_NAPI_TRACKING_DYNAMIC:
+		return dynamic_tracking_do_busy_loop(ctx, loop_end, loop_end_arg);
+	default:
+		return false;
+	}
 }
 
 static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
@@ -273,13 +284,13 @@ static int io_napi_register_napi(struct io_ring_ctx *ctx,
 	default:
 		return -EINVAL;
 	}
-	/* clean the napi list for new settings */
+	WRITE_ONCE(ctx->napi_track_mode, IO_URING_NAPI_TRACKING_INACTIVE);
 	io_napi_free(ctx);
-	WRITE_ONCE(ctx->napi_track_mode, napi->op_param);
 	/* cap NAPI at 10 msec of spin time */
 	napi->busy_poll_to = min(10000, napi->busy_poll_to);
 	WRITE_ONCE(ctx->napi_busy_poll_dt, napi->busy_poll_to * NSEC_PER_USEC);
 	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi->prefer_busy_poll);
+	WRITE_ONCE(ctx->napi_track_mode, napi->op_param);
 	return 0;
 }
 
@@ -315,7 +326,8 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 	case IO_URING_NAPI_STATIC_ADD_ID:
 		if (curr.op_param != IO_URING_NAPI_TRACKING_STATIC)
 			return -EINVAL;
-		return __io_napi_add_id(ctx, napi.op_param);
+		return __io_napi_add_id(ctx, napi.op_param,
+					IO_URING_NAPI_TRACKING_STATIC);
 	case IO_URING_NAPI_STATIC_DEL_ID:
 		if (curr.op_param != IO_URING_NAPI_TRACKING_STATIC)
 			return -EINVAL;
@@ -343,9 +355,10 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
 	if (arg && copy_to_user(arg, &curr, sizeof(curr)))
 		return -EFAULT;
 
+	WRITE_ONCE(ctx->napi_track_mode, IO_URING_NAPI_TRACKING_INACTIVE);
 	WRITE_ONCE(ctx->napi_busy_poll_dt, 0);
 	WRITE_ONCE(ctx->napi_prefer_busy_poll, false);
-	WRITE_ONCE(ctx->napi_track_mode, IO_URING_NAPI_TRACKING_INACTIVE);
+	io_napi_free(ctx);
 	return 0;
 }
 
diff --git a/io_uring/napi.h b/io_uring/napi.h
index fa742f42e09..e0aecccc506 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -15,7 +15,8 @@ void io_napi_free(struct io_ring_ctx *ctx);
 int io_register_napi(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg);
 
-int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id);
+int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id,
+		     unsigned int mode);
 
 void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq);
 int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx);
@@ -43,13 +44,14 @@ static inline void io_napi_add(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct socket *sock;
+	unsigned int mode = IO_URING_NAPI_TRACKING_DYNAMIC;
 
-	if (READ_ONCE(ctx->napi_track_mode) != IO_URING_NAPI_TRACKING_DYNAMIC)
+	if (READ_ONCE(ctx->napi_track_mode) != mode)
 		return;
 
 	sock = sock_from_file(req->file);
 	if (sock && sock->sk)
-		__io_napi_add_id(ctx, READ_ONCE(sock->sk->sk_napi_id));
+		__io_napi_add_id(ctx, READ_ONCE(sock->sk->sk_napi_id), mode);
 }
 
 #else
-- 
2.47.3


