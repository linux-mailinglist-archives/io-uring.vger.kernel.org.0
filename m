Return-Path: <io-uring+bounces-4798-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B5319D1D3A
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:24:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFEA128287A
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 01:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5EF1CA8D;
	Tue, 19 Nov 2024 01:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="j8/Dchyx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="V3EtcsCn";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="j8/Dchyx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="V3EtcsCn"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43411386BF
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 01:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731979377; cv=none; b=YwU4V/+p9175IQxVvYANUR+qElD+DT+RtZxV+OeK6+WUs0jLBVI+bbyf6XQUSccZdbblBjFY6rZXrpf6+9ja9znWatGkqscGzGqSVp5M3bVfNwar4rTV4lMVYKFVb5NH0tU8O4wRskwGaOuSA1CLVLefDn5PQfEPFncL14GiW3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731979377; c=relaxed/simple;
	bh=9dBrYGAQ8ilIIzVDCaqoG/VErvL3ZEIZkyBx4+sXHz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qA3ksj2boM2luGP5V6obuSApcgWVykwK1m87zhMrDofZB2q/Y6+r378oayzYACpsS34Ft3wsxQmDTZ0AH/Bw2+EVu6w6VRjUqZGmKky4V+kH9AcGEq/0w+TxuuJtoYqr0xuvH4mx/BeyPytTrRq0SzRnuD0tL/FkxwzW2lG/RAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=j8/Dchyx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=V3EtcsCn; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=j8/Dchyx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=V3EtcsCn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0B7FF218B5;
	Tue, 19 Nov 2024 01:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731979374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KWCxKVpFbIONu3Cw1vdvPSH1Hgecr2dmuDGraH7ZEpM=;
	b=j8/DchyxH6TazjMcNJhEi0s3FYBfwCvkE+skfeeBq8DU4w0WAuZSsg5CoUdpXJwfYbTcpk
	68hzC2NZgxEazgJn4dlh6gkInyy4EgwWovX2VJqFbcdCiMO4riccFDS37bg30Vn33SWI9J
	9Llyl6vlvOW06QsgXlXWPqdWjGY8Uw8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731979374;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KWCxKVpFbIONu3Cw1vdvPSH1Hgecr2dmuDGraH7ZEpM=;
	b=V3EtcsCnuYUVoDoO16dyN7EuUxTfkCjE3ilyAsdoCuFBT1QcWt1JvB1yPksxi7+av0VoN2
	WOIb6nSrnlSMymAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731979374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KWCxKVpFbIONu3Cw1vdvPSH1Hgecr2dmuDGraH7ZEpM=;
	b=j8/DchyxH6TazjMcNJhEi0s3FYBfwCvkE+skfeeBq8DU4w0WAuZSsg5CoUdpXJwfYbTcpk
	68hzC2NZgxEazgJn4dlh6gkInyy4EgwWovX2VJqFbcdCiMO4riccFDS37bg30Vn33SWI9J
	9Llyl6vlvOW06QsgXlXWPqdWjGY8Uw8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731979374;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KWCxKVpFbIONu3Cw1vdvPSH1Hgecr2dmuDGraH7ZEpM=;
	b=V3EtcsCnuYUVoDoO16dyN7EuUxTfkCjE3ilyAsdoCuFBT1QcWt1JvB1yPksxi7+av0VoN2
	WOIb6nSrnlSMymAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C726B1376E;
	Tue, 19 Nov 2024 01:22:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pzd3Km3oO2fMLgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 19 Nov 2024 01:22:53 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 7/9] io_uring/rw: Allocate async data through helper
Date: Mon, 18 Nov 2024 20:22:22 -0500
Message-ID: <20241119012224.1698238-8-krisman@suse.de>
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

This abstract away the cache details.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/rw.c | 28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index b62cdb5fc936..7f1890f23312 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -213,28 +213,16 @@ static int io_rw_alloc_async(struct io_kiocb *req)
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
+	rw = io_uring_alloc_async_data(&ctx->rw_cache, req);
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


