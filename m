Return-Path: <io-uring+bounces-4996-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90DE79D6558
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 22:16:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FBA516145C
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 21:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0886A18732B;
	Fri, 22 Nov 2024 21:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="U5aVAIOe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/Qw3cns8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qMt/lF1K";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gi6Wd+cU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A68C175D25
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 21:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732310173; cv=none; b=j/jspnioj/GvSvQs1b4P4jvi1pZ2+5acfrf/jpOlTtlFYUO4j85oK7EqHStrSXeUxO0VTFgSba3erQweUhpDM+VfrroGuOYoOFdaxV5xe+Mt8M5MYpxmE8huW4MBSUKbsuyXs85RMtqHm9WrSUdYcAMk1PBDkip5H8hESM9COos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732310173; c=relaxed/simple;
	bh=USjvZpgabqKVE4L8ueOmg5x9CHE86v8DH9caKMaFsV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFkenVXHBEG2BHKp+5UakHC7KjsO/TvFpqB8zXXtCA5Z6SyXylMEQjaZFNPbM0ah8lzFQAINi/LEBUMhO41pcbPWOfFqc9m6lcUObI1ZaVG2/W+7QwPAv5/MNeeRUIPFt2VPQws9Ii3yFqE8RUZlnHgTLJNziLx/MMHLqK7Tr5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=U5aVAIOe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/Qw3cns8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qMt/lF1K; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gi6Wd+cU; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D3EE41F79A;
	Fri, 22 Nov 2024 21:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310170; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DVMCZhA7JpbHKzYBjwLx6OI2Apsvr/ckMYSKmJ4Mqw8=;
	b=U5aVAIOe/NxvYy2Bw+NaWZymwUuiOGRLE2MMAazwZCkF8qGbynLHL/IQyqp2QtFKQAFmQ2
	47YX2fY7+iOeVwH74Pd46/iCET69LxfVomUiZCWWFHUXqh986S94AHy2uXZg/X6qjzb0o/
	uZNZuXB5yrZK9FPQixhlLHRXEPZHe6U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310170;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DVMCZhA7JpbHKzYBjwLx6OI2Apsvr/ckMYSKmJ4Mqw8=;
	b=/Qw3cns8UlG46Gx48tGqZaSPS8aH5zOL2ydoMilTaWhX/oODTdCqFwMp+tN0bgcZoDiCqQ
	LA6r5kBoLdNc/fBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="qMt/lF1K";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gi6Wd+cU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310169; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DVMCZhA7JpbHKzYBjwLx6OI2Apsvr/ckMYSKmJ4Mqw8=;
	b=qMt/lF1Ke/sXq+EYu+avD6GBSOtD1Iwv9TjK7oiyaxj0EoQ4syAsfGRVc1D2vL76O5BWNY
	GopViFW3vmnnxUCUmpgV9pkHHdw4npRIhZ45IcbzwCXkVZkUI+HGOXNpE0yyR44t3q/bYY
	5k7UJ5nKdTudx/+nnOrYw5J7hjiLIlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310169;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DVMCZhA7JpbHKzYBjwLx6OI2Apsvr/ckMYSKmJ4Mqw8=;
	b=gi6Wd+cUpEsv+djvQDNVtZay2qr49v+js9ZM6FReojLDM6iJClgVs8DRW88BGCJJXUtbMM
	ewxagrcNxdi6NRCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 81F9B13998;
	Fri, 22 Nov 2024 21:16:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l42PE5n0QGfXXQAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 22 Nov 2024 21:16:09 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 7/9] io_uring/rw: Allocate async data through helper
Date: Fri, 22 Nov 2024 16:15:39 -0500
Message-ID: <20241122211541.2135280-8-krisman@suse.de>
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
X-Rspamd-Queue-Id: D3EE41F79A
X-Spam-Score: -1.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

This abstract away the cache details.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/rw.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index b62cdb5fc936..0db9259bcdd8 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -208,33 +208,29 @@ static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 	}
 }
 
+static void io_rw_async_data_init(void *obj)
+{
+	struct io_async_rw *rw = (struct io_async_rw *)obj;
+
+	rw->free_iovec = 0;
+	rw->bytes_done = 0;
+}
+
 static int io_rw_alloc_async(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_async_rw *rw;
 
-	rw = io_alloc_cache_get(&ctx->rw_cache);
-	if (rw) {
-		if (rw->free_iovec) {
-			kasan_mempool_unpoison_object(rw->free_iovec,
-				rw->free_iov_nr * sizeof(struct iovec));
-			req->flags |= REQ_F_NEED_CLEANUP;
-		}
-		req->flags |= REQ_F_ASYNC_DATA;
-		req->async_data = rw;
-		goto done;
-	}
-
-	if (!io_alloc_async_data(req)) {
-		rw = req->async_data;
-		rw->free_iovec = NULL;
-		rw->free_iov_nr = 0;
-done:
+	rw = io_uring_alloc_async_data(&ctx->rw_cache, req, io_rw_async_data_init);
+	if (!rw)
+		return -ENOMEM;
+	if (rw->free_iovec) {
+		kasan_mempool_unpoison_object(rw->free_iovec,
+					      rw->free_iov_nr * sizeof(struct iovec));
+		req->flags |= REQ_F_NEED_CLEANUP;
 		rw->bytes_done = 0;
-		return 0;
 	}
-
-	return -ENOMEM;
+	return 0;
 }
 
 static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
-- 
2.47.0


