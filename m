Return-Path: <io-uring+bounces-4997-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55A319D6559
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 22:16:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 928ACB22EBE
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 21:16:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CACA1175D25;
	Fri, 22 Nov 2024 21:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HSsdL44B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5Xsw2e/m";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HSsdL44B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5Xsw2e/m"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA40185935
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 21:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732310174; cv=none; b=bZxXoDqq/zZMg67WvtdIqKc+EZRFyYhdgBsal/za2dMy7rsXkT1+gwc57e9YE/cGCs7gSOeV5f9DhZPqmhF8iaaXWPAnSOMdBfG2KpISo+8whs1uQwEU52kLNaYMoRL/S8+olyMwek5V4fcuvMLgMfscRd3n5W5pvLpqwyTpSQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732310174; c=relaxed/simple;
	bh=ug5qwzfDoq4jP8N+GgqelNZOEIYdlOPn+CA1KbzYS80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vl/y2uz0BHd6418O/JPRrEp3DmbHleoqFnA2ievhPJ5q4bjfae57BTj+Egcdm8imAdkuZ/VNjkD6khiljLi1dOG31ps5yj5Yt5r2PyYNiChu+euykqQqTORFTMZXjendPm4QC0X8BGJLV2Ho8Q7Bc87qo3v5bPUY8ZqB5Ee2aVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HSsdL44B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5Xsw2e/m; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HSsdL44B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5Xsw2e/m; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A4839211FF;
	Fri, 22 Nov 2024 21:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fit5cB00P9J1ddoFuX578NEg8p69De2TjOOtiEvyYUI=;
	b=HSsdL44BJ5nRY2k1Ax5f/bzTW4rR0mnNFjPDSnZcfy6N+P+XVQO0RP4ZZaCM5EowzApX9V
	MwPf4O0bLVAyn0gvcla+w3BOabLrm4iufwb6bnzdw8pUxOc0Viti58aSxgqTFD4wx2fpWH
	8gQaw+Hstc7bBSeJWXrL08Y8peJecdY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310171;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fit5cB00P9J1ddoFuX578NEg8p69De2TjOOtiEvyYUI=;
	b=5Xsw2e/mGvUxAz0/B7PmeJgmAQ5Hj2lLzsFuXqHLNn4cyu1H9eqm+Fwvsei88db7/PyvG7
	qb/ZZJBHskdn0WAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fit5cB00P9J1ddoFuX578NEg8p69De2TjOOtiEvyYUI=;
	b=HSsdL44BJ5nRY2k1Ax5f/bzTW4rR0mnNFjPDSnZcfy6N+P+XVQO0RP4ZZaCM5EowzApX9V
	MwPf4O0bLVAyn0gvcla+w3BOabLrm4iufwb6bnzdw8pUxOc0Viti58aSxgqTFD4wx2fpWH
	8gQaw+Hstc7bBSeJWXrL08Y8peJecdY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310171;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fit5cB00P9J1ddoFuX578NEg8p69De2TjOOtiEvyYUI=;
	b=5Xsw2e/mGvUxAz0/B7PmeJgmAQ5Hj2lLzsFuXqHLNn4cyu1H9eqm+Fwvsei88db7/PyvG7
	qb/ZZJBHskdn0WAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6CAAC13998;
	Fri, 22 Nov 2024 21:16:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +NSOFJv0QGfaXQAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 22 Nov 2024 21:16:11 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 8/9] io_uring: Move old async data allocation helper to header
Date: Fri, 22 Nov 2024 16:15:40 -0500
Message-ID: <20241122211541.2135280-9-krisman@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
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
index bd71782057de..08c42a0e3e74 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1616,19 +1616,6 @@ io_req_flags_t io_file_get_flags(struct file *file)
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
index 91414a4da1b2..cbd2c0358bb1 100644
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
index 5b12bd6a804c..078dfd6fcf71 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -526,10 +526,9 @@ static int __io_timeout_prep(struct io_kiocb *req,
 
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


