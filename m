Return-Path: <io-uring+bounces-4998-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45B369D655A
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 22:16:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB6D7B23214
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 21:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 995F517DFFC;
	Fri, 22 Nov 2024 21:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wO3Qla++";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tJjkbJse";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wO3Qla++";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tJjkbJse"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB96189909
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 21:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732310176; cv=none; b=eYcYAwpprL+e1J0OnBVyYLoMB524jWEC5wPDF4Wfgw2rpfKfzA0Mh6+j48V5KZXnj+XgyS5ZMvJanhHSZ8WjGHoMeQcG9B7jbVE4Z212SkXCAIfrNyd4HQ8XDMNwBJYJc2v0g2BHuNbyT/uV/BdSNHD4ZmvHRUhXnYUZXIVBg+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732310176; c=relaxed/simple;
	bh=Fgfw0rnRWuj34c7lmsjDmG4onhxt8XB673osQsaNJTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VY10Y3oTW7ocMEUHpDF8/ZA0Pue9zJwM3S992vSpAKuG8NF1J/2Qn6BUZHlLJAsvxv4xxI68edNmRA3lv571SFx0ixBJ2RaD0C6i5hy+W85nopLthKrQHy9XuTRXk9BxQgi9F8Pzy9BzmthOZFo/GwLQ6Lvroim7SW0Rrq4EUSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wO3Qla++; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tJjkbJse; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wO3Qla++; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tJjkbJse; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 531EF21200;
	Fri, 22 Nov 2024 21:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ztVHk8HwhzP7hT8mRZgASJKgTI7AJFZ8CjPhxJFXT1w=;
	b=wO3Qla++zDzVMNqweFmahPzR8+QhPnHs7S67D7WGEt7UsGbnvUQAfnNqZbeczXNdjwC43r
	6UlPPEFXLqqzwZAA/s1XEeKs88EDSYbqEsDb1xiZ7/z9AmwT++HYlRR8d9+cjAN8qZjkeI
	tk30DalcysQtDrNVgMZ20ScZPF109a8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310173;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ztVHk8HwhzP7hT8mRZgASJKgTI7AJFZ8CjPhxJFXT1w=;
	b=tJjkbJseHGLA6m2BLhcqqnvBpwx0BI/sO23XF5qEKUz8/f89b4YxK/gRM4/dWO03QkVmEt
	JLSvSwkc/qFVZABA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ztVHk8HwhzP7hT8mRZgASJKgTI7AJFZ8CjPhxJFXT1w=;
	b=wO3Qla++zDzVMNqweFmahPzR8+QhPnHs7S67D7WGEt7UsGbnvUQAfnNqZbeczXNdjwC43r
	6UlPPEFXLqqzwZAA/s1XEeKs88EDSYbqEsDb1xiZ7/z9AmwT++HYlRR8d9+cjAN8qZjkeI
	tk30DalcysQtDrNVgMZ20ScZPF109a8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310173;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ztVHk8HwhzP7hT8mRZgASJKgTI7AJFZ8CjPhxJFXT1w=;
	b=tJjkbJseHGLA6m2BLhcqqnvBpwx0BI/sO23XF5qEKUz8/f89b4YxK/gRM4/dWO03QkVmEt
	JLSvSwkc/qFVZABA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C0EC13998;
	Fri, 22 Nov 2024 21:16:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id q/riOJz0QGfcXQAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 22 Nov 2024 21:16:12 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 9/9] io_uring/msg_ring: Drop custom destructor
Date: Fri, 22 Nov 2024 16:15:41 -0500
Message-ID: <20241122211541.2135280-10-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241122211541.2135280-1-krisman@suse.de>
References: <20241122211541.2135280-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
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


