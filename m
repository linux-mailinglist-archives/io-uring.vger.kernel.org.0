Return-Path: <io-uring+bounces-3213-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D864197A7BE
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 21:20:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A38A1C243E2
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 19:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 487B815C13B;
	Mon, 16 Sep 2024 19:20:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9907D14BFA3
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 19:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726514440; cv=none; b=YzfcSh49K984BXUSOn7hfxN+b1Sgw5vMkOnSI4okyDndby4GePa2ofxDzNfu1kuYCFUhVoM865yrD17pCjb2uPgWSu6LzdgonzsksSMx4mF0hIYF41l4XeDyQMiFrBxnBHykDT4YBQfGBwClqRzDiQbVk0mM6zD6yI0P9g8+9oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726514440; c=relaxed/simple;
	bh=nAgFS5CSjzmj800vyciOXMFPWu5va1l9KVaDHQDNGh4=;
	h=From:Date:Message-ID:In-Reply-To:References:To:Subject; b=Tk0UqVVEvl5nRqkZXL11FT5B0aTpDJqPQ9aiGQZ47SZ69uN1vuf3m9cw2TYBiq4aaTdRYzOV+0l1vyZv8X2fMIOv7VbpQf2qps2kCaoG4Hc8F/wN379NICGHe3ngAfdVEml7LuoMTRx8YSOARjjvbYNHXFulauJDMfD6jY7tyPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=59084 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sqHH3-00068e-1P;
	Mon, 16 Sep 2024 15:20:37 -0400
From: Olivier Langlois <olivier@trillion01.com>
Date: Mon, 16 Sep 2024 15:20:36 -0400
Message-ID: <21f0dc072dce6699a8fe4ced734fed066dee09bf.1726354973.git.olivier@trillion01.com>
In-Reply-To: <cover.1726354973.git.olivier@trillion01.com>
References: <cover.1726354973.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Subject: [PATCH v2 2/3] io_uring/napi: fix io_napi_entry RCU accesses
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

correct 3 RCU structures modifications that were not using the RCU
functions to make their update.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 io_uring/napi.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 1dd2df9da468..738d88bc050a 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -81,7 +81,7 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
 	}
 
 	hlist_add_tail_rcu(&e->node, hash_list);
-	list_add_tail(&e->list, &ctx->napi_list);
+	list_add_tail_rcu(&e->list, &ctx->napi_list);
 	spin_unlock(&ctx->napi_lock);
 }
 
@@ -91,9 +91,15 @@ static void __io_napi_remove_stale(struct io_ring_ctx *ctx)
 	unsigned int i;
 
 	spin_lock(&ctx->napi_lock);
+	/*
+	 * hash_for_each_safe() is not required as long as:
+	 * 1. hash_del_rcu() does not reset the deleted node next pointer
+	 * 2. kfree_rcu() delays the memory freeing until the next quiescent
+	 *    state
+	 */
 	hash_for_each(ctx->napi_ht, i, e, node) {
 		if (time_after(jiffies, READ_ONCE(e->timeout))) {
-			list_del(&e->list);
+			list_del_rcu(&e->list);
 			hash_del_rcu(&e->node);
 			kfree_rcu(e, rcu);
 		}
@@ -207,6 +213,7 @@ void io_napi_free(struct io_ring_ctx *ctx)
 	unsigned int i;
 
 	spin_lock(&ctx->napi_lock);
+	INIT_LIST_HEAD_RCU(&ctx->napi_list);
 	hash_for_each(ctx->napi_ht, i, e, node) {
 		hash_del_rcu(&e->node);
 		kfree_rcu(e, rcu);
-- 
2.46.0


