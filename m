Return-Path: <io-uring+bounces-4800-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8557A9D1D3C
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:24:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9489B220C8
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 01:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B8A07C6E6;
	Tue, 19 Nov 2024 01:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JH7w0LPp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uRfaQdot";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JH7w0LPp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uRfaQdot"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C646A13665A
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 01:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731979385; cv=none; b=AJadXGMOSkN7n4EorzX1EXkf31n1BwQxarwhK+J8OV0rPCtiFdI6IRZRYkpsrVsUGkOYRu2l0iex9QKLUg4yuLl5YtCp/GFGuHxeUgZJlyrnP4sPcqRZuoKI7ebQ65NrWqk77AWXhTH0/kR+qcy2EQJl9N8ugRlWojhrI7gkeW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731979385; c=relaxed/simple;
	bh=Fgfw0rnRWuj34c7lmsjDmG4onhxt8XB673osQsaNJTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzcknJXGV0xqEgj5GVPXkSC/1YlG+5LNcwUUwvaYkk3s4ETHgbynPuyCbcw06KKdIfazcM+Atk2Omc3yPM80sTJZkVOKTRVmDwYZYD95vwdaDsfh1k+UiNJbIP4faGM/6SWgIT2vwwQSn0DYPhnfDPxWPI78+KhgxUp0W4JgrBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JH7w0LPp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uRfaQdot; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JH7w0LPp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uRfaQdot; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 15FE41F391;
	Tue, 19 Nov 2024 01:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731979382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ztVHk8HwhzP7hT8mRZgASJKgTI7AJFZ8CjPhxJFXT1w=;
	b=JH7w0LPp7rkE8Dd2eApC9nk5ScYW3ods8lc1hDg8a2nelkdCTiCTWivVA+DBBWDqLNRBg1
	3cCTwDUyaC7jaaQWieO7spT9cTQprN474IV0TgjxW03rMAml3pGY3TtqjUwaS+j3Tz3KHq
	QzaJEZlZb262mn8+kD0Iy6Jf3MhaBYs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731979382;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ztVHk8HwhzP7hT8mRZgASJKgTI7AJFZ8CjPhxJFXT1w=;
	b=uRfaQdotRXNFV7QdD1OuGfDgzkQN+GvBt1zmCXLHVnAPjpXNIWKzMa1SzQp0EzaWP+7OdJ
	PltRTCRZ+k+MToAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731979382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ztVHk8HwhzP7hT8mRZgASJKgTI7AJFZ8CjPhxJFXT1w=;
	b=JH7w0LPp7rkE8Dd2eApC9nk5ScYW3ods8lc1hDg8a2nelkdCTiCTWivVA+DBBWDqLNRBg1
	3cCTwDUyaC7jaaQWieO7spT9cTQprN474IV0TgjxW03rMAml3pGY3TtqjUwaS+j3Tz3KHq
	QzaJEZlZb262mn8+kD0Iy6Jf3MhaBYs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731979382;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ztVHk8HwhzP7hT8mRZgASJKgTI7AJFZ8CjPhxJFXT1w=;
	b=uRfaQdotRXNFV7QdD1OuGfDgzkQN+GvBt1zmCXLHVnAPjpXNIWKzMa1SzQp0EzaWP+7OdJ
	PltRTCRZ+k+MToAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B97A81376E;
	Tue, 19 Nov 2024 01:23:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v/ITIXXoO2fYLgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 19 Nov 2024 01:23:01 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 9/9] io_uring/msg_ring: Drop custom destructor
Date: Mon, 18 Nov 2024 20:22:24 -0500
Message-ID: <20241119012224.1698238-10-krisman@suse.de>
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
	BAYES_HAM(-3.00)[100.00%];
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

kfree can handle slab objects nowadays. Drop the extra callback and just
use kfree.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io_uring.c | 4 ++--
 io_uring/msg_ring.c | 7 -------
 io_uring/msg_ring.h | 1 -
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 08c42a0e3e74..1e591234f32b 100644
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
@@ -2693,7 +2693,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
 	io_alloc_cache_free(&ctx->uring_cache, kfree);
-	io_alloc_cache_free(&ctx->msg_cache, io_msg_cache_free);
+	io_alloc_cache_free(&ctx->msg_cache, kfree);
 	io_futex_cache_free(ctx);
 	io_destroy_buffers(ctx);
 	io_unregister_cqwait_reg(ctx);
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index e63af34004b7..d41ea29802a6 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -358,10 +358,3 @@ int io_uring_sync_msg_ring(struct io_uring_sqe *sqe)
 	}
 	return ret;
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


