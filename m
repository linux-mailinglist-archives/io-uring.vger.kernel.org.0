Return-Path: <io-uring+bounces-5507-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 89DED9F3C0F
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 22:04:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9B377A5C73
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 21:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B53C1D618C;
	Mon, 16 Dec 2024 20:46:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6271C1D5CD7
	for <io-uring@vger.kernel.org>; Mon, 16 Dec 2024 20:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734381997; cv=none; b=X0OLtI1g2ma6T6ihltlWWRJ/1YShCRq/bmZ3qW0dTg7aB8DNd7LKeEUdy8xnLdFIK8wKjqfRys9sb3yqezmh8C/1H0h+x3KlORd4z8v0GlaKNslUtHRDQ5lXdsKaOeYrsigejUUaUfA8YReydsMvukxAj05gfdgJn4CpLbzTNgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734381997; c=relaxed/simple;
	bh=xGkMWaPS2znrD/WhJrBKlRpXK6N5nUuaOnCu686nGYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkEsgiSwg+J0KSAnkXhRBo3V2wdJwALXWHwSMM9BqLhDx4uPHr+scuszVxVFJ+q/Xmil0T0qdG2iPF/pdTJxJwsHFvbFiSQLwJnEXjz2BFlhhhvu8XWba2e4++DBs0j906gECtIm73IQ457/CJz0FMsB1n5woSDaZMvFejLCyVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DE26421120;
	Mon, 16 Dec 2024 20:46:34 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9B350137CF;
	Mon, 16 Dec 2024 20:46:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0TKMH6qRYGfmZAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 16 Dec 2024 20:46:34 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RESEND v2 4/9] io_uring/poll: Allocate apoll with generic alloc_cache helper
Date: Mon, 16 Dec 2024 15:46:10 -0500
Message-ID: <20241216204615.759089-5-krisman@suse.de>
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
X-Rspamd-Queue-Id: DE26421120
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

This abstracts away the cache details to simplify the code.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/poll.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index bced9edd5233..cc01c40b43d3 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -648,15 +648,12 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 	if (req->flags & REQ_F_POLLED) {
 		apoll = req->apoll;
 		kfree(apoll->double_poll);
-	} else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-		apoll = io_alloc_cache_get(&ctx->apoll_cache);
-		if (!apoll)
-			goto alloc_apoll;
-		apoll->poll.retries = APOLL_MAX_RETRY;
 	} else {
-alloc_apoll:
-		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
-		if (unlikely(!apoll))
+		if (!(issue_flags & IO_URING_F_UNLOCKED))
+			apoll = io_cache_alloc(&ctx->apoll_cache, GFP_ATOMIC, NULL);
+		else
+			apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+		if (!apoll)
 			return NULL;
 		apoll->poll.retries = APOLL_MAX_RETRY;
 	}
-- 
2.47.0


