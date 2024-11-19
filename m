Return-Path: <io-uring+bounces-4796-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BBF9D9D1D39
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:24:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63922B220E3
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 01:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A9AD13AA2B;
	Tue, 19 Nov 2024 01:22:49 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16F01386BF
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 01:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731979369; cv=none; b=RQiJKAo8r4jvXFB8ijdH0Usyzsqyq0jU6E++Ir0Ww7rjIDF69HE3spClQc30vA17NNm4yZK3fyvYPIic1qBOUNGX2lMj0JuGuCnaXj9Gr0yCkbjT10prNtPJGITrP6Yej8JPLPcu1ihFm+JEyEE9NVh2ZgzWImdoEvUdVN3VAKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731979369; c=relaxed/simple;
	bh=318j64Chrkzgf1RVtFnPf2j1ynBSgAY2F04oYBMnNBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvJv6VgeRL/AFhFFH5/kC0TNj/C9NgzG5UmQKrlI0LlId4r2JrsTuEoGarvNcXG8GVd+Kz5x5wGVy5rJLk8zSBGpbk/zxC4OZbdSQaMpT6j0BZpILDMi6nTXFFIBM1G4lOdIK6+Mo2Xk8CUSYsnI8vHK+djmKYI2gU5gWOXcPQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7BC5D218B5;
	Tue, 19 Nov 2024 01:22:46 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4347F1376E;
	Tue, 19 Nov 2024 01:22:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vt5HCmboO2fGLgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 19 Nov 2024 01:22:46 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 5/9] io_uring/uring_cmd: Allocate async data through generic helper
Date: Mon, 18 Nov 2024 20:22:20 -0500
Message-ID: <20241119012224.1698238-6-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241119012224.1698238-1-krisman@suse.de>
References: <20241119012224.1698238-1-krisman@suse.de>
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
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	TAGGED_RCPT(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 7BC5D218B5
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 

This abstracts away the cache details and simplify the code.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io_uring.h  |  1 +
 io_uring/uring_cmd.c | 20 ++------------------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 9c158e401ecb..f35bf7ef68f3 100644
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
index e9d99d3ecc34..b029672f3ec3 100644
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
@@ -181,8 +165,8 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	struct uring_cache *cache;
 
-	cache = io_uring_async_get(req);
-	if (unlikely(!cache))
+	cache = io_uring_alloc_async_data(&req->ctx->uring_cache, req);
+	if (!cache)
 		return -ENOMEM;
 
 	if (!(req->flags & REQ_F_FORCE_ASYNC)) {
-- 
2.47.0


