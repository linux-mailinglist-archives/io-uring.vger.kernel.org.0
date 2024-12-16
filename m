Return-Path: <io-uring+bounces-5511-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82C969F3C27
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 22:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A17C188C6F1
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 21:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE9311DDC05;
	Mon, 16 Dec 2024 20:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BbBtUWJw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BKihP6LO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BbBtUWJw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BKihP6LO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFD6175BF
	for <io-uring@vger.kernel.org>; Mon, 16 Dec 2024 20:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734382017; cv=none; b=WvTvZs2z+wdUbsKvgjknttRHUMhTNq/qkJGBPgKFnrv2e5kIvnZHBKa1E9BM9aNJYTmQhDLf/0Dy2yEjAx4cNKOG/utsHR4rhXU7fFOPLcbYb4EmAmFJ+alJdGOuOByQ4LgekzAREz6lrbMexjTqPVY4AZidW/3l2OoQDHgmokU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734382017; c=relaxed/simple;
	bh=wzcPNTearvL23esFLZrvk0GL5LtF7FQ0AuP3SDkoqt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcOki3VYef74NXS4jutKsKIzg8pyoNJU8L1+RuvaLzUejbe+ALfwTb1t3G6oVv2/Cja9ew58Wi4MODSANLzL3QkDsCC1nMKDEq8xm8K3XR0K/uPR9Odf6xUlXQGD4Jm4CdGX6NmlMu9wm/zI4naKBtG0SonmjzuDQDtvqIm/nlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BbBtUWJw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BKihP6LO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BbBtUWJw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BKihP6LO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4F1992111F;
	Mon, 16 Dec 2024 20:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1734382014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LChTt1bCaXhqCjHmHPyn9J5d31DczI1zw8IsfSwq6hc=;
	b=BbBtUWJwW1zBVgBVx4WVpsgHQ8RDghZYUi4PW/olPrGAD5mZQ3NdxxMRwgZv15NVGfvUmh
	7TKgl7irRoV2ST3Vv2nlvMftWPLPchdsDe9CxWltyUnz6aszA5u92vjwig9op+pweRxvBZ
	bckCzeX/1M6H8D5RDP8ZAftlJ2Q1hwI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1734382014;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LChTt1bCaXhqCjHmHPyn9J5d31DczI1zw8IsfSwq6hc=;
	b=BKihP6LO9KgZESjD5BjxygvqG5/1rbglGXWQIiiYx8Vf7R7ETOyAt2V4ri3ZBrah79P3Cv
	i5EefGe0gNq/3eBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1734382014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LChTt1bCaXhqCjHmHPyn9J5d31DczI1zw8IsfSwq6hc=;
	b=BbBtUWJwW1zBVgBVx4WVpsgHQ8RDghZYUi4PW/olPrGAD5mZQ3NdxxMRwgZv15NVGfvUmh
	7TKgl7irRoV2ST3Vv2nlvMftWPLPchdsDe9CxWltyUnz6aszA5u92vjwig9op+pweRxvBZ
	bckCzeX/1M6H8D5RDP8ZAftlJ2Q1hwI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1734382014;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LChTt1bCaXhqCjHmHPyn9J5d31DczI1zw8IsfSwq6hc=;
	b=BKihP6LO9KgZESjD5BjxygvqG5/1rbglGXWQIiiYx8Vf7R7ETOyAt2V4ri3ZBrah79P3Cv
	i5EefGe0gNq/3eBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 13A35137CF;
	Mon, 16 Dec 2024 20:46:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id azolOr2RYGcEZQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 16 Dec 2024 20:46:53 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RESEND v2 8/9] io_uring: Move old async data allocation helper to header
Date: Mon, 16 Dec 2024 15:46:14 -0500
Message-ID: <20241216204615.759089-9-krisman@suse.de>
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
X-Spam-Score: -5.30
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 

There are two remaining uses of the old async data allocator that do not
rely on the alloc cache.  I don't want to make them use the new
allocator helper because that would require a if(cache) check, which
will result in dead code for the cached case (for callers passing a
cache, gcc can't prove the cache isn't NULL, and will therefore preserve
the check.  Since this is an inline function and just a few lines long,
keep a second helper to deal with cases where we don't have an async
data cache.

No functional change intended here.  This is just moving the helper
around and making it inline.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io_uring.c | 13 -------------
 io_uring/io_uring.h | 12 ++++++++++++
 io_uring/timeout.c  |  5 ++---
 io_uring/waitid.c   |  4 ++--
 4 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ae36aa702f46..e34a4af54e6b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1639,19 +1639,6 @@ io_req_flags_t io_file_get_flags(struct file *file)
 	return res;
 }
 
-bool io_alloc_async_data(struct io_kiocb *req)
-{
-	const struct io_issue_def *def = &io_issue_defs[req->opcode];
-
-	WARN_ON_ONCE(!def->async_size);
-	req->async_data = kmalloc(def->async_size, GFP_KERNEL);
-	if (req->async_data) {
-		req->flags |= REQ_F_ASYNC_DATA;
-		return false;
-	}
-	return true;
-}
-
 static u32 io_get_sequence(struct io_kiocb *req)
 {
 	u32 seq = req->ctx->cached_sq_head;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e43e9194dd0a..032758b28d78 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -12,6 +12,7 @@
 #include "io-wq.h"
 #include "slist.h"
 #include "filetable.h"
+#include "opdef.h"
 
 #ifndef CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -233,6 +234,17 @@ static inline void *io_uring_alloc_async_data(struct io_alloc_cache *cache,
 	return req->async_data;
 }
 
+static inline void *io_uring_alloc_async_data_nocache(struct io_kiocb *req)
+{
+	const struct io_issue_def *def = &io_issue_defs[req->opcode];
+
+	WARN_ON_ONCE(!def->async_size);
+	req->async_data = kmalloc(def->async_size, GFP_KERNEL);
+	if (req->async_data)
+		req->flags |= REQ_F_ASYNC_DATA;
+	return req->async_data;
+}
+
 static inline bool req_has_async_data(struct io_kiocb *req)
 {
 	return req->flags & REQ_F_ASYNC_DATA;
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index f3d502717aeb..f55e25338b23 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -525,10 +525,9 @@ static int __io_timeout_prep(struct io_kiocb *req,
 
 	if (WARN_ON_ONCE(req_has_async_data(req)))
 		return -EFAULT;
-	if (io_alloc_async_data(req))
+	data = io_uring_alloc_async_data_nocache(req);
+	if (!data)
 		return -ENOMEM;
-
-	data = req->async_data;
 	data->req = req;
 	data->flags = flags;
 
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index daef5dd644f0..6778c0ee76c4 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -303,10 +303,10 @@ int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_waitid_async *iwa;
 	int ret;
 
-	if (io_alloc_async_data(req))
+	iwa = io_uring_alloc_async_data_nocache(req);
+	if (!iwa)
 		return -ENOMEM;
 
-	iwa = req->async_data;
 	iwa->req = req;
 
 	ret = kernel_waitid_prepare(&iwa->wo, iw->which, iw->upid, &iw->info,
-- 
2.47.0


