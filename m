Return-Path: <io-uring+bounces-5504-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21AD39F3C24
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 22:06:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B606188ABFC
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 21:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E0C1D5CE5;
	Mon, 16 Dec 2024 20:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DdsiPTfH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aVV0+N5y";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DdsiPTfH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aVV0+N5y"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0491D5AB7
	for <io-uring@vger.kernel.org>; Mon, 16 Dec 2024 20:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734381993; cv=none; b=i4zvWXXxgYNyHFnfiYYy3imOsQsPejp3IMmeFXQvow7fwS83nTGMI6usmhEoBxpRZQVBqZZN8sNwjVQ+m8yCRdqnBl1v/zhgORGlx1/WOfXxTphy9Xz+NefxA4mRkNfrQu0gtswgRD8XVzi5Loe5NYxSu4+8UOz2lOi229eyigY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734381993; c=relaxed/simple;
	bh=BBaMLGHJfK2NjRYV4grWKBmxae8Q/AOnhL16FkoD8tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnRNTfbKu5J21b9AXvGQxhpi+k+qARS4SJCGb7rnr+5HWRjXeu2UKO+Q2bOlFBJ13FoaS08ivk13Q7Ij61dkIx48tMl7qfsLJMmDQKzzq/X8/QABB8TJqADpA57H2rTpCyISJk7svIcAwTCYdH0nRZCP1sXpbFwC2wliI47jB4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DdsiPTfH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aVV0+N5y; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DdsiPTfH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aVV0+N5y; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B9B2D21120;
	Mon, 16 Dec 2024 20:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1734381989; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/287T9g3gFxMclWhQz7JGBexhglTHPIXP8sYh5trkAE=;
	b=DdsiPTfHNjpnjaNRoNL22C3y5NsKfdQvV5C80U0zhCh808fWTdUf6ASTst9vLbnjdD36iL
	Lr0iF1ytKz7E2RnO2tg+TxVGBGF1/tBC4QPSIJz3Y8g1QkO9+bPhTnn/6gGjHMd4/Ij92a
	eEMEJztZbZlZojlCIgvXKKjdqgREUMM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1734381989;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/287T9g3gFxMclWhQz7JGBexhglTHPIXP8sYh5trkAE=;
	b=aVV0+N5yA6P344VxEZztcQY9A88b1jlVkvdJ/+IXwWSOHRAF8Nqs1Cs4n05HO+xjGiKSDc
	eiakw91Hx1rB8KAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1734381989; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/287T9g3gFxMclWhQz7JGBexhglTHPIXP8sYh5trkAE=;
	b=DdsiPTfHNjpnjaNRoNL22C3y5NsKfdQvV5C80U0zhCh808fWTdUf6ASTst9vLbnjdD36iL
	Lr0iF1ytKz7E2RnO2tg+TxVGBGF1/tBC4QPSIJz3Y8g1QkO9+bPhTnn/6gGjHMd4/Ij92a
	eEMEJztZbZlZojlCIgvXKKjdqgREUMM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1734381989;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/287T9g3gFxMclWhQz7JGBexhglTHPIXP8sYh5trkAE=;
	b=aVV0+N5yA6P344VxEZztcQY9A88b1jlVkvdJ/+IXwWSOHRAF8Nqs1Cs4n05HO+xjGiKSDc
	eiakw91Hx1rB8KAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7F8EA137CF;
	Mon, 16 Dec 2024 20:46:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yD/cGKWRYGfbZAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 16 Dec 2024 20:46:29 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RESEND v2 1/9] io_uring: Fold allocation into alloc_cache helper
Date: Mon, 16 Dec 2024 15:46:07 -0500
Message-ID: <20241216204615.759089-2-krisman@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -5.30
X-Spam-Flag: NO

The allocation paths that use alloc_cache duplicate the same code
pattern, sometimes in a quite convoluted way.  Fold the allocation into
the cache code itself, making it just an allocator function, and keeping
the cache policy invisible to callers.  Another justification for doing
this, beyond code simplicity, is that it makes it trivial to test the
impact of disabling the cache and using slab directly, which I've used
for slab improvement experiments.

One relevant detail is that we provide a callback to optionally
initialize memory only when we actually reach slab.  This allows us to
avoid blindly executing the allocation with GFP_ZERO and only clean
fields when they matter.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

---
since v1:
  - add a callback to initialize objects coming from slab
  - rename io_alloc_cache_alloc -> io_cache_alloc
---
 io_uring/alloc_cache.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index b7a38a2069cf..a3a8cfec32ce 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -30,6 +30,19 @@ static inline void *io_alloc_cache_get(struct io_alloc_cache *cache)
 	return NULL;
 }
 
+static inline void *io_cache_alloc(struct io_alloc_cache *cache, gfp_t gfp,
+				   void (*init_once)(void *obj))
+{
+	if (unlikely(!cache->nr_cached)) {
+		void *obj = kmalloc(cache->elem_size, gfp);
+
+		if (obj && init_once)
+			init_once(obj);
+		return obj;
+	}
+	return io_alloc_cache_get(cache);
+}
+
 /* returns false if the cache was initialized properly */
 static inline bool io_alloc_cache_init(struct io_alloc_cache *cache,
 				       unsigned max_nr, size_t size)
-- 
2.47.0


