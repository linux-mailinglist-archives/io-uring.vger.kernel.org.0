Return-Path: <io-uring+bounces-3631-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A503899BAD4
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 20:28:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DCAE2812E8
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 18:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5542F13D52C;
	Sun, 13 Oct 2024 18:28:43 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBF713AD22
	for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 18:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728844123; cv=none; b=V4HaMcZ0gt0qliT9Weys1r0zTVmUruvugjdlC7aZ+KnCV6JaaTOKnkCIvNREOt8m2E1Px5JZJBozsJjYcWlspDlSrk6Rz6H43lMvf7ZFV5wQ/sryeZQKPJH1pUJ2c6EQ1ECFfLg2HMID7kFQg1WQuXaBHEkesK77HgOSg4FDWCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728844123; c=relaxed/simple;
	bh=+INTVSSsgBMSUVTx5i/51LG8M8l0DQWPagLuI8sfkAM=;
	h=From:Date:Message-ID:In-Reply-To:References:To:Subject; b=KUY9ZNHrHzUbMoQKXngN2B2z617KnWggF58wzb//VriI9PH3FYWrEwQGT8u6xr12AcLae6xGQlKHDUFcEBDQtEKLQXPnBRqw9/BU8PrN1tt84Hz02ueS6WbMgoR8bmelg4Tdpm+yeMhmkYn7ULuXiydD2unJaC8V4wPUpMU5drg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=60118 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1t03KZ-0002kN-1I;
	Sun, 13 Oct 2024 14:28:39 -0400
From: Olivier Langlois <olivier@trillion01.com>
Date: Sun, 13 Oct 2024 14:28:38 -0400
Message-ID: <9f53b5169afa8c7bf3665a0b19dc2f7061173530.1728828877.git.olivier@trillion01.com>
In-Reply-To: <cover.1728828877.git.olivier@trillion01.com>
References: <cover.1728828877.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Subject: [PATCH v4 2/6] io_uring/napi: fix io_napi_entry RCU accesses
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
 io_uring/napi.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index dda2e083fb5d..921de9de8d75 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -81,19 +81,24 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
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
+	/*
+	 * list_for_each_entry_safe() is not required as long as:
+	 * 1. list_del_rcu() does not reset the deleted node next pointer
+	 * 2. kfree_rcu() delays the memory freeing until the next quiescent
+	 *    state
+	 */
+	list_for_each_entry(e, &ctx->napi_list, list) {
 		if (time_after(jiffies, READ_ONCE(e->timeout))) {
-			list_del(&e->list);
+			list_del_rcu(&e->list);
 			hash_del_rcu(&e->node);
 			kfree_rcu(e, rcu);
 		}
@@ -204,13 +209,13 @@ void io_napi_init(struct io_ring_ctx *ctx)
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
 
-- 
2.47.0


