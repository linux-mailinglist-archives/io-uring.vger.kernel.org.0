Return-Path: <io-uring+bounces-10535-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EDB4C520A9
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 12:43:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BE1A3A9EB0
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 11:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E242F311951;
	Wed, 12 Nov 2025 11:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tssltd.ru header.i=@tssltd.ru header.b="X8F6rha8"
X-Original-To: io-uring@vger.kernel.org
Received: from forward100a.mail.yandex.net (forward100a.mail.yandex.net [178.154.239.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBB7299AB5;
	Wed, 12 Nov 2025 11:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762947473; cv=none; b=KiTpSXLy+jqEy9zdc/9aHAdff3PMc1msO0ZwdQb+ArG690nwzoY0NvaL8iJSgzxggBEuzYCM5XD9ecSoBjfKENwyjWl4oLkwxDd1K8VXbd1+mIYRQqRsqLgMR1QE+8GfxgLijV7sM9JodG45kkAHl+/CUMkQMj2IDsQLoJxWBzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762947473; c=relaxed/simple;
	bh=Nqgas7GiliM6f4hdPxwETZq0KRMgTU9NytxRsquiSrY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Rg0re9Yay5vzwFggdaSzMU8XQlRmUA1q1ZtrMKfVVFMWoVH8iajmUFCHbIHOqtBTrm19o3TgAh614laN8/Jcppf4SrrZ60vGibhGkCHw25mjhSY7NVKCILiCA170FoB0MLemArbqCc6tTlTTcqRCV1GwpLzQmLRTC3l1PCvSi7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tssltd.ru; spf=pass smtp.mailfrom=tssltd.ru; dkim=pass (1024-bit key) header.d=tssltd.ru header.i=@tssltd.ru header.b=X8F6rha8; arc=none smtp.client-ip=178.154.239.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tssltd.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tssltd.ru
Received: from mail-nwsmtp-smtp-production-main-73.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-73.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:8583:0:640:4841:0])
	by forward100a.mail.yandex.net (Yandex) with ESMTPS id 27261C0197;
	Wed, 12 Nov 2025 14:37:41 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-73.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 8bNmXh1LSmI0-DzCqPhFU;
	Wed, 12 Nov 2025 14:37:40 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tssltd.ru; s=mail;
	t=1762947460; bh=SYA/S7aWl0ErpoDeBicsv0aZyCAPuChwqx/jUn5emuw=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=X8F6rha8hVsY1Sp7aX37uungA7fmgpe2WPwJSbeH/b8rx+3znMvaE7lSJIxmMJq66
	 tGBpnAcIK/NCZkTNsZaJ3PgOTMoNihsaWtraRLHvLsd5dUkZZ0+2g07zJtDEBYhZig
	 jRstBJHmZ6OnoveL+ns1HxirZw5V4kSgzFf0RSag=
Authentication-Results: mail-nwsmtp-smtp-production-main-73.iva.yp-c.yandex.net; dkim=pass header.i=@tssltd.ru
From: Stepan Artuhov <s.artuhov@tssltd.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Olivier Langlois <olivier@trillion01.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Stepan Artuhov <s.artuhov@tssltd.ru>
Subject: [PATCH 6.12] io_uring/napi: fix io_napi_entry RCU accesses
Date: Wed, 12 Nov 2025 14:37:06 +0300
Message-Id: <20251112113706.533309-1-s.artuhov@tssltd.ru>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 io_uring/napi.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index d0cf694d0172..fa959fd32042 100644
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
2.39.5


