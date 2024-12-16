Return-Path: <io-uring+bounces-5509-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D6D39F3C26
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 22:06:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58C57188BF11
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 21:04:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C4B1DD867;
	Mon, 16 Dec 2024 20:46:45 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02366175BF
	for <io-uring@vger.kernel.org>; Mon, 16 Dec 2024 20:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734382005; cv=none; b=QG2LfOxRoFBi7JYII7w+E0YLgspyIBaxnMorHdi2BhhgU96mhkHnlWVidPFYHGcYcerhj2Jv6PqAb5ZOcXydpnaTvov59NZOcvBR3F3CrMIUDb5ur4l4VFc74i01jo1ChZetk6Xd0pAO9s8tNAeeM52OycPPZnT7+SsImFomI3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734382005; c=relaxed/simple;
	bh=o3XWb+ztFT4nsPWZIrjZBjjgOz24AeHFlG1kxx8yMMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/S4o/l+uoPTcbylEv16k86idMob46bVgB1p1Yum/C6J1ZQvqZ/EH9to5EhEegwhoOIpT8l9G04OPnTfdbirCFM9s20iS2mQZAZyMjAamd7hc6YWuwpgHK5k/wObWt1PNmYxcwl/S5CjNHD1YEhHyafw+pYAxVUW1EL221920vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 53EC92111F;
	Mon, 16 Dec 2024 20:46:42 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 038A0137CF;
	Mon, 16 Dec 2024 20:46:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Y23yMbGRYGf5ZAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 16 Dec 2024 20:46:41 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RESEND v2 6/9] io_uring/net: Allocate msghdr async data through helper
Date: Mon, 16 Dec 2024 15:46:12 -0500
Message-ID: <20241216204615.759089-7-krisman@suse.de>
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
X-Rspamd-Queue-Id: 53EC92111F
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 

This abstracts away the cache details.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/net.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index df1f7dc6f1c8..8457408194e7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -155,30 +155,31 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 	}
 }
 
+static void io_msg_async_data_init(void *obj)
+{
+	struct io_async_msghdr *hdr = (struct io_async_msghdr *)obj;
+
+	hdr->free_iov = NULL;
+	hdr->free_iov_nr = 0;
+}
+
 static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req)
 {
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
+	hdr = io_uring_alloc_async_data(&ctx->netmsg_cache, req,
+					io_msg_async_data_init);
+	if (!hdr)
+		return NULL;
 
-	if (!io_alloc_async_data(req)) {
-		hdr = req->async_data;
-		hdr->free_iov_nr = 0;
-		hdr->free_iov = NULL;
-		return hdr;
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


