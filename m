Return-Path: <io-uring+bounces-4792-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 406EC9D1D34
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:24:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E65FC1F20EDE
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 01:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D944137745;
	Tue, 19 Nov 2024 01:22:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BF52AD20
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 01:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731979358; cv=none; b=imMPaFswTSHgQtp9V6+K38ZYTsIrGrCY8igkjT9EDT1u6sHkK3ur0D1ieaEG9iIuids7TJBR6ZqXRHZZyZ1FfQMANkD7wseXJ27V/GNzQnT/vW0G/qDkMhg58zu7xfLkvN+vmmjXq2PYhH0gScwLzVueXncfsoxMDMz2dmL2eEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731979358; c=relaxed/simple;
	bh=P2UkaPxWbqus01Nu/82O+EvyK9m3GBJZoxWn/6L0UDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5R6CHWf7Q8tYgq40ZGqxDd3p80HfyC0xsrsrmaevgc07aqXVtvV5PXCpmKfslaxdWrnM0LqbZG7d0ihXX5ig8jyl1UMdZC2V6wsjk5oNONNqEOCMpuUpySTHnfmAi+NJT5Yoh5lNP8uhCHCKRb0//K0jgdYZsvuS3JuNSVceqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9FBF91F37C;
	Tue, 19 Nov 2024 01:22:34 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 665911376E;
	Tue, 19 Nov 2024 01:22:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WDDEDFroO2emLgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 19 Nov 2024 01:22:34 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 1/9] io_uring: Fold allocation into alloc_cache helper
Date: Mon, 18 Nov 2024 20:22:16 -0500
Message-ID: <20241119012224.1698238-2-krisman@suse.de>
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
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU]
X-Spam-Score: -4.00
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 9FBF91F37C
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

The allocation paths that use alloc_cache duplicate the same code
pattern, sometimes in a quite convoluted way.  Fold the allocation into
the cache code itself, making it just an allocator function, and keeping
the cache policy invisible to callers.  Another justification for doing
this, beyond code simplicity, is that it makes it trivial to test the
impact of disabling the cache and using slab directly, which I've used
for slab improvement experiments.

One relevant detail is that this allocates zeroed memory.  Rationale is
that it simplifies the handling of the embedded free_iov in some of the
cached objects, and the performance impact shouldn't be meaningful,
since we are supposed to be hitting the cache most of the time and the
allocation is already the slow path.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/alloc_cache.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index b7a38a2069cf..6b34e491a30a 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -30,6 +30,13 @@ static inline void *io_alloc_cache_get(struct io_alloc_cache *cache)
 	return NULL;
 }
 
+static inline void *io_alloc_cache_alloc(struct io_alloc_cache *cache, gfp_t gfp)
+{
+	if (!cache->nr_cached)
+		return kzalloc(cache->elem_size, gfp);
+	return io_alloc_cache_get(cache);
+}
+
 /* returns false if the cache was initialized properly */
 static inline bool io_alloc_cache_init(struct io_alloc_cache *cache,
 				       unsigned max_nr, size_t size)
-- 
2.47.0


