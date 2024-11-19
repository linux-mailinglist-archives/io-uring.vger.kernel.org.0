Return-Path: <io-uring+bounces-4795-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 038849D1D36
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:24:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C65652827A1
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 01:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E3D91384BF;
	Tue, 19 Nov 2024 01:22:47 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6B01386BF
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 01:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731979367; cv=none; b=NGJ/5fyzHXnmadandhGlWpmMYkNttLhO6VE5UKr3EAJ8G2mSh7/8WdXgbRTeOc841oMXVET1pJOG/TKKUBNlzKCyxF565MReNS9/GKzM4eHG4USHXQZo+TFo6Vw8MtHbrOPNnVbETqP7zuPOg+bSUqoFo6NGer8S+S5PwRhPRao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731979367; c=relaxed/simple;
	bh=M0462ik/401Sqm1U6bgX88P3/xwXBfk0fYCA+6VDU0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iE6pq3uQ455LAnZNWmsw2HZSp32YR0uVKhtRMsIQQaKCFn1z/Y5vCHVSUtR2x1+RAv6HQmStXkTvZGO1lKu1pqUuJXEtyhs3oMQY1Fgo/uc+GT+gpFeXjadfK+eTl5A8JAxwv80kTBTUgukeTcFBZX9CN4GiZxOIGCUGu6+tXtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 67F81218A8;
	Tue, 19 Nov 2024 01:22:44 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2F33E1376E;
	Tue, 19 Nov 2024 01:22:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id J0tmBWToO2fALgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 19 Nov 2024 01:22:44 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 4/9] io_uring/poll: Allocate apoll with generic alloc_cache helper
Date: Mon, 18 Nov 2024 20:22:19 -0500
Message-ID: <20241119012224.1698238-5-krisman@suse.de>
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
X-Rspamd-Queue-Id: 67F81218A8
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 

This abstracts away the cache details to simplify the code.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/poll.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index bced9edd5233..837790ed6816 100644
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
+			apoll = io_alloc_cache_alloc(&ctx->apoll_cache, GFP_ATOMIC);
+		else
+			apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+		if (!apoll)
 			return NULL;
 		apoll->poll.retries = APOLL_MAX_RETRY;
 	}
-- 
2.47.0


