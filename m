Return-Path: <io-uring+bounces-4989-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89B239D6551
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 22:16:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A205283071
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 21:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2804176AAE;
	Fri, 22 Nov 2024 21:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AqWRKetO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="11dN+SOJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AqWRKetO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="11dN+SOJ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6505175D25
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 21:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732310157; cv=none; b=UkL0usyce8WYrookgEtNq3hexpUqCEBohFfRCOCved0EwhEnxHrUnjo1QNLss19ehZlwRK72kXAS4i9IQh1cY1zjQRg6h+aGpDxA8sbh3nBpTn4zlO6awlA7BEnwzVIMv2GvC9f6xeCL+O9GQxdgHfuSWstXjIRXgM5T3bFt7+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732310157; c=relaxed/simple;
	bh=BBaMLGHJfK2NjRYV4grWKBmxae8Q/AOnhL16FkoD8tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjRzcxBPPad6HOtLGYy3rWKinZRXNdDsyFxLtLFiPncE6QQFE9UJTgcv3D+OR69PKpUeJzfwWjGoZ5qrPypT0FL2wT/mi6znw9bHG0dDwf6RI5hjIXnKDJ5NNVCmUCUKGNN6ziuDGOK+2p96adKN9BshonMTUNXKWTsefzHHv0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AqWRKetO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=11dN+SOJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AqWRKetO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=11dN+SOJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D55AC211FF;
	Fri, 22 Nov 2024 21:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310153; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/287T9g3gFxMclWhQz7JGBexhglTHPIXP8sYh5trkAE=;
	b=AqWRKetOf44rKHmilScnlg9aaxmkOXKl1KxbS69g8xkjQ0wraI7Kjmt8057NhMBmsXeNsZ
	hsoXZfOuTeMTpfPCtaQhl179bFAuykBiSdS92fiY4DNK0Ml1Ovz2Ihf0KpOi0PubL0VCey
	RNqU51wcLllalJpU+GRWHiSdgg2etCc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310153;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/287T9g3gFxMclWhQz7JGBexhglTHPIXP8sYh5trkAE=;
	b=11dN+SOJvZxO1K4W0PPDMXJWL+K7UibzbDJN/OKlGNRcetGYIXhkrOWeVISFdHo7JHe+CD
	1VwUIKEEtAHFAfAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310153; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/287T9g3gFxMclWhQz7JGBexhglTHPIXP8sYh5trkAE=;
	b=AqWRKetOf44rKHmilScnlg9aaxmkOXKl1KxbS69g8xkjQ0wraI7Kjmt8057NhMBmsXeNsZ
	hsoXZfOuTeMTpfPCtaQhl179bFAuykBiSdS92fiY4DNK0Ml1Ovz2Ihf0KpOi0PubL0VCey
	RNqU51wcLllalJpU+GRWHiSdgg2etCc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310153;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/287T9g3gFxMclWhQz7JGBexhglTHPIXP8sYh5trkAE=;
	b=11dN+SOJvZxO1K4W0PPDMXJWL+K7UibzbDJN/OKlGNRcetGYIXhkrOWeVISFdHo7JHe+CD
	1VwUIKEEtAHFAfAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9DED013998;
	Fri, 22 Nov 2024 21:15:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 84WMIIn0QGe7XQAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 22 Nov 2024 21:15:53 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 1/9] io_uring: Fold allocation into alloc_cache helper
Date: Fri, 22 Nov 2024 16:15:33 -0500
Message-ID: <20241122211541.2135280-2-krisman@suse.de>
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
X-Spam-Level: 
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -1.30
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


