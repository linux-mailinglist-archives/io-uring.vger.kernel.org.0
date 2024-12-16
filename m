Return-Path: <io-uring+bounces-5510-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E178F9F3C11
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 22:04:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09BB5166D9E
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 21:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 135111DD0F2;
	Mon, 16 Dec 2024 20:46:48 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E77B1DDC07
	for <io-uring@vger.kernel.org>; Mon, 16 Dec 2024 20:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734382008; cv=none; b=QphqeCbnukq7BZ2deE3HEUo+3Sz52HtIesaQH9bZ+6m7H0qe/op/BdCJhH15MQZyWYwMK+5CI46eFQePsGvI4RMiz4Wvd+po9/WGch6YmEVD2s0BZPqU3/IRqy8St3D+FXKvu11WkIrLUszefkS8EvjPc3A/tbWfvGF17AUpnBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734382008; c=relaxed/simple;
	bh=3nULw4xyKngF3OssTsavNb+GJVZWUqjbedLz9oxLqFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwxQVpWSR6X6t29BjLuNWEyMVC+wqXVUSwuuqWgUzXQ/mmVaJJDZpBFHhYFgQaCfDDByC6tdHtRqnrr/O1mdNH4/tCKQNyV90g5lzKU1blksMYrLMB1/AyiNy78DlRkyNaBtFVF1D8Vez6+3ed+4958RS6H5lvrccWsWtIl1M+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 91E501F37E;
	Mon, 16 Dec 2024 20:46:44 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 414AF137CF;
	Mon, 16 Dec 2024 20:46:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mZzwArSRYGf9ZAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 16 Dec 2024 20:46:44 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RESEND v2 7/9] io_uring/rw: Allocate async data through helper
Date: Mon, 16 Dec 2024 15:46:13 -0500
Message-ID: <20241216204615.759089-8-krisman@suse.de>
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
X-Rspamd-Queue-Id: 91E501F37E
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 

This abstract away the cache details.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/rw.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 5b24fd8b69f6..bdfc3faef85d 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -208,33 +208,29 @@ static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 	}
 }
 
+static void io_rw_async_data_init(void *obj)
+{
+	struct io_async_rw *rw = (struct io_async_rw *)obj;
+
+	rw->free_iovec = 0;
+	rw->bytes_done = 0;
+}
+
 static int io_rw_alloc_async(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_async_rw *rw;
 
-	rw = io_alloc_cache_get(&ctx->rw_cache);
-	if (rw) {
-		if (rw->free_iovec) {
-			kasan_mempool_unpoison_object(rw->free_iovec,
-				rw->free_iov_nr * sizeof(struct iovec));
-			req->flags |= REQ_F_NEED_CLEANUP;
-		}
-		req->flags |= REQ_F_ASYNC_DATA;
-		req->async_data = rw;
-		goto done;
-	}
-
-	if (!io_alloc_async_data(req)) {
-		rw = req->async_data;
-		rw->free_iovec = NULL;
-		rw->free_iov_nr = 0;
-done:
+	rw = io_uring_alloc_async_data(&ctx->rw_cache, req, io_rw_async_data_init);
+	if (!rw)
+		return -ENOMEM;
+	if (rw->free_iovec) {
+		kasan_mempool_unpoison_object(rw->free_iovec,
+					      rw->free_iov_nr * sizeof(struct iovec));
+		req->flags |= REQ_F_NEED_CLEANUP;
 		rw->bytes_done = 0;
-		return 0;
 	}
-
-	return -ENOMEM;
+	return 0;
 }
 
 static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
-- 
2.47.0


