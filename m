Return-Path: <io-uring+bounces-5512-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B24079F3C28
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 22:06:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE0B2188C8DA
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 21:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 443C31D61A7;
	Mon, 16 Dec 2024 20:46:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DA01DDA10
	for <io-uring@vger.kernel.org>; Mon, 16 Dec 2024 20:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734382019; cv=none; b=AnEJsDx+lla8sLQ4mqqccW/IBLgWkK/zvUhRhNVvoezFBLaUvZR1s69ur2fpYdsDuGveIEhU9wpgSzeMM2X0nKg7Ft0pV6KqspzHUu0aNgOfTVldU02eqF81Y8ikK2+oFX1RwRR1QuVQAxWALPWwPhfwkbB9WclwkePvuMydUZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734382019; c=relaxed/simple;
	bh=T5ZoPB4jTWtkbjxlS0b+n+6kPmQ9I5vGUofva+V6WTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMao4WmCUz6/QewQHkpUhQxSmWiol26EF1xg0zP4xCM+vtFjyjlx5zovDdiZGQpp0kk9xGL7oifipnqrUAtVd79wO76Z6YhQkhKxSgZEWH9xFM5uVkTRqXSjAbWVcdv/adL9mczvuTqtAC0HDM+/99WrMnhK5q7eIeK8ZHuUvNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 243F01F37E;
	Mon, 16 Dec 2024 20:46:56 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1764137CF;
	Mon, 16 Dec 2024 20:46:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 65wDMb+RYGcOZQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 16 Dec 2024 20:46:55 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RESEND v2 9/9] io_uring/msg_ring: Drop custom destructor
Date: Mon, 16 Dec 2024 15:46:15 -0500
Message-ID: <20241216204615.759089-10-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241216204615.759089-1-krisman@suse.de>
References: <20241216204615.759089-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 243F01F37E
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 

kfree can handle slab objects nowadays. Drop the extra callback and just
use kfree.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io_uring.c | 4 ++--
 io_uring/msg_ring.c | 7 -------
 io_uring/msg_ring.h | 1 -
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e34a4af54e6b..5535a72b0ce1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -361,7 +361,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
 	io_alloc_cache_free(&ctx->uring_cache, kfree);
-	io_alloc_cache_free(&ctx->msg_cache, io_msg_cache_free);
+	io_alloc_cache_free(&ctx->msg_cache, kfree);
 	io_futex_cache_free(ctx);
 	kvfree(ctx->cancel_table.hbs);
 	xa_destroy(&ctx->io_bl_xa);
@@ -2692,7 +2692,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
 	io_alloc_cache_free(&ctx->uring_cache, kfree);
-	io_alloc_cache_free(&ctx->msg_cache, io_msg_cache_free);
+	io_alloc_cache_free(&ctx->msg_cache, kfree);
 	io_futex_cache_free(ctx);
 	io_destroy_buffers(ctx);
 	io_free_region(ctx, &ctx->param_region);
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 333c220d322a..bd3cd78d2dba 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -354,10 +354,3 @@ int io_uring_sync_msg_ring(struct io_uring_sqe *sqe)
 	return  __io_msg_ring_data(fd_file(f)->private_data,
 				   &io_msg, IO_URING_F_UNLOCKED);
 }
-
-void io_msg_cache_free(const void *entry)
-{
-	struct io_kiocb *req = (struct io_kiocb *) entry;
-
-	kmem_cache_free(req_cachep, req);
-}
diff --git a/io_uring/msg_ring.h b/io_uring/msg_ring.h
index 38e7f8f0c944..32236d2fb778 100644
--- a/io_uring/msg_ring.h
+++ b/io_uring/msg_ring.h
@@ -4,4 +4,3 @@ int io_uring_sync_msg_ring(struct io_uring_sqe *sqe);
 int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags);
 void io_msg_ring_cleanup(struct io_kiocb *req);
-void io_msg_cache_free(const void *entry);
-- 
2.47.0


