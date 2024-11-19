Return-Path: <io-uring+bounces-4797-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1E949D1D38
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:24:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87490283270
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 01:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A528139566;
	Tue, 19 Nov 2024 01:22:55 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5901386C9
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 01:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731979375; cv=none; b=HZP1I+VUST1cLu0e/eycc4xnjSq8NXqROUNb9JW0S+hd2ZaRQBpO2dB1IhQcF754WctBCkgaWP4WPtfsxIaFGOqca2Y1zVlxXkTUvz2tbz0M9Lj/OHVcMaJ6CiPuExmI+aP4j7B4blkQ6nGL567jLNJEPQaJxoWj/B3qrgFg3fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731979375; c=relaxed/simple;
	bh=hMb6E+YED+4OQMrJnHN4W1txNtDj4Yc3THt4Dun3F7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srxr6eon941sNg/NcXGGgwdOp5IajTu0vxSkgslsHVReBlt8GpRliK1/PTTfnzgIvEeVA7IOVlFhXn6zE5QWd5xALgPOaW1fXIKK0uHbnjBVDmQ3zLSDTRKSpzl8ftFM4AfEqiR5UM+kX5W/F8qkIebJEyvzIbKkI7HPKkWH2WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 266DA218A8;
	Tue, 19 Nov 2024 01:22:52 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D88CF1376E;
	Tue, 19 Nov 2024 01:22:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gizHLmvoO2fKLgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 19 Nov 2024 01:22:51 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 6/9] io_uring/net: Allocate msghdr async data through helper
Date: Mon, 18 Nov 2024 20:22:21 -0500
Message-ID: <20241119012224.1698238-7-krisman@suse.de>
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
	TAGGED_RCPT(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 266DA218A8
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 

This abstracts away the cache details.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/net.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index df1f7dc6f1c8..104863101980 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -160,25 +160,17 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_async_msghdr *hdr;
 
-	hdr = io_alloc_cache_get(&ctx->netmsg_cache);
-	if (hdr) {
-		if (hdr->free_iov) {
-			kasan_mempool_unpoison_object(hdr->free_iov,
-				hdr->free_iov_nr * sizeof(struct iovec));
-			req->flags |= REQ_F_NEED_CLEANUP;
-		}
-		req->flags |= REQ_F_ASYNC_DATA;
-		req->async_data = hdr;
-		return hdr;
-	}
-
-	if (!io_alloc_async_data(req)) {
-		hdr = req->async_data;
-		hdr->free_iov_nr = 0;
-		hdr->free_iov = NULL;
-		return hdr;
+	hdr = io_uring_alloc_async_data(&ctx->netmsg_cache, req);
+	if (!hdr)
+		return NULL;
+
+	/* If the async data was cached, we might have an iov cached inside. */
+	if (hdr->free_iov) {
+		kasan_mempool_unpoison_object(hdr->free_iov,
+					      hdr->free_iov_nr * sizeof(struct iovec));
+		req->flags |= REQ_F_NEED_CLEANUP;
 	}
-	return NULL;
+	return hdr;
 }
 
 /* assign new iovec to kmsg, if we need to */
-- 
2.47.0


