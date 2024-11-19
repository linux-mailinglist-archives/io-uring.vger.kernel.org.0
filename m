Return-Path: <io-uring+bounces-4799-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 653369D1D3B
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:24:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64AE01F223A2
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 01:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 140B177111;
	Tue, 19 Nov 2024 01:23:03 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAFD13665A
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 01:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731979383; cv=none; b=jIwr7zQ0ny/Q2BSDvbAjcook7wsZq5K86rvoSc4Iy8QR0wi6tLdE+HHOIQWssB92Zo3N7DjFehjnUVD0zQ+kUel6hTo5HZU37gBwYa5588+E+G78e3QfYWP04OjebkSBof0IOpFNXyMR1r+VbtXtbUN3uPdDJNsuUmAXAXdKfJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731979383; c=relaxed/simple;
	bh=02qyuUlKws+7p4641Yn4QbzQH5KLwQpzrF7WaKbqHtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkOjMXMvr4GqiO6vLwp8uOUNQgoxUedVBE/HOBoDpAeSCPPGvHlAy4c07cAhV1/E+we8qbhl4c76sGk93upmr40gDbTk0MbNZ2x3C6tb27XGzookoKMa+1rw8w1B06IJOhn5/n2a26/shL3/+TYNCU//InsLjfLLGVSUvTtEo6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CC01B1F37C;
	Tue, 19 Nov 2024 01:22:59 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9406F1376E;
	Tue, 19 Nov 2024 01:22:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Fv8fHnPoO2fULgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 19 Nov 2024 01:22:59 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 8/9] io_uring: Move old async data allocation helper to header
Date: Mon, 18 Nov 2024 20:22:23 -0500
Message-ID: <20241119012224.1698238-9-krisman@suse.de>
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
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	TAGGED_RCPT(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: CC01B1F37C
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
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
index f35bf7ef68f3..13e07e65c0a1 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -12,6 +12,7 @@
 #include "io-wq.h"
 #include "slist.h"
 #include "filetable.h"
+#include "opdef.h"
 
 #ifndef CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -232,6 +233,17 @@ static inline void *io_uring_alloc_async_data(struct io_alloc_cache *cache,
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


