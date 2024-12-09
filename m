Return-Path: <io-uring+bounces-5360-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A119EA303
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:43:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B594188602A
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:43:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88471224898;
	Mon,  9 Dec 2024 23:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bWkOht73";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zejb8964";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bWkOht73";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zejb8964"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8706C19CC33
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 23:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733787815; cv=none; b=mhWd3MnIJVR3++2OcgbBNBwtUZkbCdaGC5UkiExUsIwsQNlrEtRK2J/sK46/e4UepRNtJbYN51rGvWd9DwiPbF6gXPsWV2X3BQ3O/2X87AzRUqTIJ5iNh3AaoFassz4jI3J7Zf1Cg7fPoSaCcN6IS4W29X5x6bGR9l5Cz4iYHZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733787815; c=relaxed/simple;
	bh=kRDBxwz+6YveQEeqSLq+C9Fv2dd2d16OGfWYfGvoqDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2KmSgrjUmGOV7uRMu1HjvQH0HgzGJknQFGExKelPv5O9SF66bC0ql5R/Vpk7fJ6Fa6LIWLDaSJcrgA0GrPwOKD0z2uXO/5szltIsTgbdAZkp4dBcgAcctuXRWIFa1+ERcOg87/VmHkr/KOBF2Z3fi+//8cWyheUirv8P3dG3UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bWkOht73; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zejb8964; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bWkOht73; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zejb8964; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CA8FC1F44F;
	Mon,  9 Dec 2024 23:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787811; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=25eEZurrVZ82xZwHvea2HsSxglpjw6qEO7CU7KTegLE=;
	b=bWkOht7338fwZ+jZAaBq8gs4f1qRr+d9BFYy1hrCVhLoy0KAwFm7JwfQOyFyBDsqF2pRmM
	N/YwNWAXhL9jfBKko6jrIBI2jRo8GU2z31JANIt+k0dI4OzOp8Plq8z4hL59Shm2xq7LSh
	mausjP3NmXBhC3K2LZvjHUK4rgE5qnA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787811;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=25eEZurrVZ82xZwHvea2HsSxglpjw6qEO7CU7KTegLE=;
	b=zejb89647WRMFLdnkCOkuOipozmA9Taow1sXeQVq8oG3chRLf3/cMdC658r6Ny8fausOId
	YLfxAjtzzpJA6sBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787811; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=25eEZurrVZ82xZwHvea2HsSxglpjw6qEO7CU7KTegLE=;
	b=bWkOht7338fwZ+jZAaBq8gs4f1qRr+d9BFYy1hrCVhLoy0KAwFm7JwfQOyFyBDsqF2pRmM
	N/YwNWAXhL9jfBKko6jrIBI2jRo8GU2z31JANIt+k0dI4OzOp8Plq8z4hL59Shm2xq7LSh
	mausjP3NmXBhC3K2LZvjHUK4rgE5qnA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787811;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=25eEZurrVZ82xZwHvea2HsSxglpjw6qEO7CU7KTegLE=;
	b=zejb89647WRMFLdnkCOkuOipozmA9Taow1sXeQVq8oG3chRLf3/cMdC658r6Ny8fausOId
	YLfxAjtzzpJA6sBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E17D138A5;
	Mon,  9 Dec 2024 23:43:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XVVnFqOAV2fsHAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 09 Dec 2024 23:43:31 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	josh@joshtriplett.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RFC 1/9] io_uring: Drop __io_req_find_next_prep
Date: Mon,  9 Dec 2024 18:43:03 -0500
Message-ID: <20241209234316.4132786-2-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241209234316.4132786-1-krisman@suse.de>
References: <20241209234316.4132786-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid];
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
	RCPT_COUNT_FIVE(0.00)[5];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -1.30
X-Spam-Flag: NO

This is only used inside io_req_find_next.  Inline it and drop the helper.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io_uring.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a8cbe674e5d6..57d8947ae69e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -989,15 +989,6 @@ __cold void io_free_req(struct io_kiocb *req)
 	io_req_task_work_add(req);
 }
 
-static void __io_req_find_next_prep(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	spin_lock(&ctx->completion_lock);
-	io_disarm_next(req);
-	spin_unlock(&ctx->completion_lock);
-}
-
 static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt;
@@ -1008,8 +999,11 @@ static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 	 * dependencies to the next request. In case of failure, fail the rest
 	 * of the chain.
 	 */
-	if (unlikely(req->flags & IO_DISARM_MASK))
-		__io_req_find_next_prep(req);
+	if (unlikely(req->flags & IO_DISARM_MASK)) {
+		spin_lock(&req->ctx->completion_lock);
+		io_disarm_next(req);
+		spin_unlock(&req->ctx->completion_lock);
+	}
 	nxt = req->link;
 	req->link = NULL;
 	return nxt;
-- 
2.47.0


