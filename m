Return-Path: <io-uring+bounces-4794-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 02F109D1D37
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:24:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E612B2360B
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 01:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0551478C90;
	Tue, 19 Nov 2024 01:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="D420OM5M";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6vpx21sx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="D420OM5M";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6vpx21sx"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B5E1384BF
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 01:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731979361; cv=none; b=IHLdqvXnTYjoBx3RdC+Hktb+MkOG5JcW+5XbneCH7WGFs++dHGdI6/d/Io8kdpZck4UaZyJQLcKgznknP/60n/MieJMYqOIJprp38raYuX0N9sxuEv63M9ZNtsxBr/TIfVnY1BjcCW3F6Gvf72kc/xKwoaOyy+p1NjHBNxiT5gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731979361; c=relaxed/simple;
	bh=6RVog7w+XkCPr2WwNoAjidSoEkacfQpPXFdvrjZGSGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pteSw7mtYDDBeipHfbHjFye/eczFYV5sa23Ie/jS2WA8WNaeG9vUHjaPJIe4/Tdhg4ZRISlpeb5tGfu46js6mmSBJ28M0t66xRV9d7E7cbgVbylHYzILgTxb62z1/F7sRk/mVS5bj64KgE/UsOlmXX8sFKMqf9PZUNTLJ73zmqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=D420OM5M; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6vpx21sx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=D420OM5M; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6vpx21sx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9CE531F37C;
	Tue, 19 Nov 2024 01:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731979358; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tvp/fdjzmqfd4dz+XQcuqURNw/Scsk9jyml7xMRedPw=;
	b=D420OM5MAe+2+Va51pdwuLAxv5+wYAmsbQ/0wJBHREWzfC2eM+Np8DWSgHKvGwFZb0V2ol
	QvecvQ8OE+YGaiPOuqGc8R/B4gJ3d4e0h0Hgl+Z4Y/1VJ1LfMeP45LimhKJjuByo/Cw44s
	tkX/ivk3dpvuTaVVGv2xgcdl4yWrlv4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731979358;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tvp/fdjzmqfd4dz+XQcuqURNw/Scsk9jyml7xMRedPw=;
	b=6vpx21sxYMryAf8hdQMjUmqfn6frMvjyhjG2P3wMx4W0MwVxQ70hyJxgVB35aHCkRa19Al
	0me6MSzaCJmfGSAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731979358; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tvp/fdjzmqfd4dz+XQcuqURNw/Scsk9jyml7xMRedPw=;
	b=D420OM5MAe+2+Va51pdwuLAxv5+wYAmsbQ/0wJBHREWzfC2eM+Np8DWSgHKvGwFZb0V2ol
	QvecvQ8OE+YGaiPOuqGc8R/B4gJ3d4e0h0Hgl+Z4Y/1VJ1LfMeP45LimhKJjuByo/Cw44s
	tkX/ivk3dpvuTaVVGv2xgcdl4yWrlv4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731979358;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tvp/fdjzmqfd4dz+XQcuqURNw/Scsk9jyml7xMRedPw=;
	b=6vpx21sxYMryAf8hdQMjUmqfn6frMvjyhjG2P3wMx4W0MwVxQ70hyJxgVB35aHCkRa19Al
	0me6MSzaCJmfGSAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5E0581376E;
	Tue, 19 Nov 2024 01:22:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yhPGEF7oO2e6LgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 19 Nov 2024 01:22:38 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 3/9] io_uring/futex: Allocate ifd with generic alloc_cache helper
Date: Mon, 18 Nov 2024 20:22:18 -0500
Message-ID: <20241119012224.1698238-4-krisman@suse.de>
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
X-Spam-Level: 
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -5.30
X-Spam-Flag: NO

Instead of open-coding the allocation, use the generic alloc_cache
helper.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/futex.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index e29662f039e1..dd9dddea2a9b 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -251,17 +251,6 @@ static void io_futex_wake_fn(struct wake_q_head *wake_q, struct futex_q *q)
 	io_req_task_work_add(req);
 }
 
-static struct io_futex_data *io_alloc_ifd(struct io_ring_ctx *ctx)
-{
-	struct io_futex_data *ifd;
-
-	ifd = io_alloc_cache_get(&ctx->futex_cache);
-	if (ifd)
-		return ifd;
-
-	return kmalloc(sizeof(struct io_futex_data), GFP_NOWAIT);
-}
-
 int io_futexv_wait(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
@@ -331,7 +320,7 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	io_ring_submit_lock(ctx, issue_flags);
-	ifd = io_alloc_ifd(ctx);
+	ifd = io_alloc_cache_alloc(&ctx->futex_cache, GFP_NOWAIT);
 	if (!ifd) {
 		ret = -ENOMEM;
 		goto done_unlock;
-- 
2.47.0


