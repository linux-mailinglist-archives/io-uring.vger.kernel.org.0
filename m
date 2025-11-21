Return-Path: <io-uring+bounces-10720-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BEA5C79733
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 14:34:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 028384E03F1
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 13:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70F22349B14;
	Fri, 21 Nov 2025 13:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixsTrCzh"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C328D341ADF;
	Fri, 21 Nov 2025 13:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732048; cv=none; b=XS0CyN1e5cYeIqa5JjAnBYQ4qJo+REUEzj2gWE4AvRY6AoRnpzrog6egdT4sf+QDUadv0niHellBvc9fYHfFZ3VcFOJAopqXDJWPla5lfIHutCEVP1a1wtNqFKPjZdqKL/L82FV8lw6EmoyZdk0nPmhKgVNdfRT2QJIq19dXaN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732048; c=relaxed/simple;
	bh=Kt0WK/P2k+swnJmGRIaPTdk0Gp0S+goQ0cpYXZei7Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhaSAWlquWsSKGg6gl6hplqcn2gq3wItg2T6EF9gHJhrNHzF3sQPqxwrcuEbWflhhd3DEKmfSR+N/Np8pgtbKgAeWuqi9NHl/xw6FKF2peZ7fLTEun3akRljOKcQu4kaidsr5X6H8VXrCtuCh9aeDaEOBtHQcbZwEo46MWydstU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixsTrCzh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132E3C4CEFB;
	Fri, 21 Nov 2025 13:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732048;
	bh=Kt0WK/P2k+swnJmGRIaPTdk0Gp0S+goQ0cpYXZei7Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixsTrCzhY4cqKMpH2uqVraELke1h8WLLJRBImL5NNGp8ed870QTxI6cxt3ymzuHPv
	 bavnS1eUBK6TQMncv2Ksj8TCNu0xqVtJiM54bZ0mwwb6M1P0Aj+fJfhdi3iAPoIQqI
	 ZnltcI3TxlG5Ch+UQBNrhW7XJMXLTzE7Yfp8ptbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Olivier Langlois <olivier@trillion01.com>,
	Stepan Artuhov <s.artuhov@tssltd.ru>
Subject: [PATCH 6.12 172/185] io_uring/napi: fix io_napi_entry RCU accesses
Date: Fri, 21 Nov 2025 14:13:19 +0100
Message-ID: <20251121130150.093076960@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Langlois <olivier@trillion01.com>

[Upstream commit 45b3941d09d13b3503309be1f023b83deaf69b4d ]

correct 3 RCU structures modifications that were not using the RCU
functions to make their update.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: lvc-project@linuxtesting.org
Signed-off-by: Olivier Langlois <olivier@trillion01.com>
Link: https://lore.kernel.org/r/9f53b5169afa8c7bf3665a0b19dc2f7061173530.1728828877.git.olivier@trillion01.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[Stepan Artuhov: cherry-picked a commit]
Signed-off-by: Stepan Artuhov <s.artuhov@tssltd.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/napi.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -81,19 +81,24 @@ void __io_napi_add(struct io_ring_ctx *c
 	}
 
 	hlist_add_tail_rcu(&e->node, hash_list);
-	list_add_tail(&e->list, &ctx->napi_list);
+	list_add_tail_rcu(&e->list, &ctx->napi_list);
 	spin_unlock(&ctx->napi_lock);
 }
 
 static void __io_napi_remove_stale(struct io_ring_ctx *ctx)
 {
 	struct io_napi_entry *e;
-	unsigned int i;
 
 	spin_lock(&ctx->napi_lock);
-	hash_for_each(ctx->napi_ht, i, e, node) {
-		if (time_after(jiffies, e->timeout)) {
-			list_del(&e->list);
+	/*
+	 * list_for_each_entry_safe() is not required as long as:
+	 * 1. list_del_rcu() does not reset the deleted node next pointer
+	 * 2. kfree_rcu() delays the memory freeing until the next quiescent
+	 *    state
+	 */
+	list_for_each_entry(e, &ctx->napi_list, list) {
+		if (time_after(jiffies, READ_ONCE(e->timeout))) {
+			list_del_rcu(&e->list);
 			hash_del_rcu(&e->node);
 			kfree_rcu(e, rcu);
 		}
@@ -204,13 +209,13 @@ void io_napi_init(struct io_ring_ctx *ct
 void io_napi_free(struct io_ring_ctx *ctx)
 {
 	struct io_napi_entry *e;
-	unsigned int i;
 
 	spin_lock(&ctx->napi_lock);
-	hash_for_each(ctx->napi_ht, i, e, node) {
+	list_for_each_entry(e, &ctx->napi_list, list) {
 		hash_del_rcu(&e->node);
 		kfree_rcu(e, rcu);
 	}
+	INIT_LIST_HEAD_RCU(&ctx->napi_list);
 	spin_unlock(&ctx->napi_lock);
 }
 



