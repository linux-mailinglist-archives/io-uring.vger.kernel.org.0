Return-Path: <io-uring+bounces-5508-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 83E249F3C25
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 22:06:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3338188B893
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 21:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D026E1D5CD9;
	Mon, 16 Dec 2024 20:46:43 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1B31DD0F2
	for <io-uring@vger.kernel.org>; Mon, 16 Dec 2024 20:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734382003; cv=none; b=EjUJVP3RB3trkNI1auv38gcAkD5DxskhQKYiMsq1q1WKdad+t4NOkT/Br1kjzAEMrp48vB4WCgkfxvckl9+2ZN5IMwerbRtyBowHBQ6u0aDbA4nJjnur+kVzTa7p8sqORMzgRu4uw8eKafBzWnC+uFcrfr0kreVggHWWoOBJc50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734382003; c=relaxed/simple;
	bh=L/A43CpJRy2ai6bk6igGg6mnkrnpONKOHzS/zl3VWk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJZfBk7Ad96UvYDF6Rs7TdwNtyz7AOxeQlykTrjq5SarCS9qZgYkVAkdZBIE0buO7sruEwgsMBYi7r4aLOLJPkyyK4q+DXksDFTCbPtaFWiWQA8lsBjyPZUlb0p6NgdBhpMJZicpkjfa/2+3uzVPxHMuX5Eq6iteSQrsR3cUg5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 930B81F37E;
	Mon, 16 Dec 2024 20:46:40 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D993137CF;
	Mon, 16 Dec 2024 20:46:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RC+4CLCRYGf3ZAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 16 Dec 2024 20:46:40 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RESEND v2 5/9] io_uring/uring_cmd: Allocate async data through generic helper
Date: Mon, 16 Dec 2024 15:46:11 -0500
Message-ID: <20241216204615.759089-6-krisman@suse.de>
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
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Spam-Score: -4.00
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 930B81F37E
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

This abstracts away the cache details and simplify the code.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io_uring.h  |  1 +
 io_uring/uring_cmd.c | 20 ++------------------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index cd7bf71574e4..e43e9194dd0a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -8,6 +8,7 @@
 #include <linux/poll.h>
 #include <linux/io_uring_types.h>
 #include <uapi/linux/eventpoll.h>
+#include "alloc_cache.h"
 #include "io-wq.h"
 #include "slist.h"
 #include "filetable.h"
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index af842e9b4eb9..d6ff803dbbe1 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -16,22 +16,6 @@
 #include "rsrc.h"
 #include "uring_cmd.h"
 
-static struct uring_cache *io_uring_async_get(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct uring_cache *cache;
-
-	cache = io_alloc_cache_get(&ctx->uring_cache);
-	if (cache) {
-		req->flags |= REQ_F_ASYNC_DATA;
-		req->async_data = cache;
-		return cache;
-	}
-	if (!io_alloc_async_data(req))
-		return req->async_data;
-	return NULL;
-}
-
 static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
@@ -185,8 +169,8 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	struct uring_cache *cache;
 
-	cache = io_uring_async_get(req);
-	if (unlikely(!cache))
+	cache = io_uring_alloc_async_data(&req->ctx->uring_cache, req, NULL);
+	if (!cache)
 		return -ENOMEM;
 
 	if (!(req->flags & REQ_F_FORCE_ASYNC)) {
-- 
2.47.0


