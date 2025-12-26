Return-Path: <io-uring+bounces-11311-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 561D1CDE592
	for <lists+io-uring@lfdr.de>; Fri, 26 Dec 2025 06:17:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0CB043012BE2
	for <lists+io-uring@lfdr.de>; Fri, 26 Dec 2025 05:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41100265629;
	Fri, 26 Dec 2025 05:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vj7vg8uv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD352609FD
	for <io-uring@vger.kernel.org>; Fri, 26 Dec 2025 05:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766726235; cv=none; b=BLgQg2zQrFAGXmMTtejrGugJBnCTIxVAFsEIvRelzK5gXekUOO8C2ZgL86LHifpvALSGZ83u9YBFU0pPqw5SyuKegPs7c7C3xbz3C4avufB62pjG/PyHSA3rjPcaVJGvQdCZHmSv4GXBCsOZUKtMvejHZjRACSC5E0il5hCNTrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766726235; c=relaxed/simple;
	bh=z6tN2koOVYt5xxAFCQCSSARH1+DI6PvUPVVhQVBJ6fM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iZHAexlacEj/QEuIXXR5cPeKQo2LfEUmPwZrs6X+MM9EE0SP1260jjHlyXEDmvNZApQ5txGV4iLpYSNP++XPz0/CxyvCcQ0GTpL7VTchGXD7/cqHKv0Mxp5gqRZi/FKBpDx7WCD4iGtzlwYoWJASv/gX5I5s7DpsofRmZOB9W+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vj7vg8uv; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso74081865ad.1
        for <io-uring@vger.kernel.org>; Thu, 25 Dec 2025 21:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766726233; x=1767331033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m9FIBnBIT8ZoZIIN6usk5vCof387U33RW9IfQgNu4dE=;
        b=Vj7vg8uvSpW8pSSvOsaq4AgFRhgWEqRJyFSQNhScyIoCx9t91GoXkDbEpwqasNETYD
         fdpajnE7fgaM4vooYyljW/p90FEd10ZKz3p5SeqHU5UlIQ+DvNgrjjCXQY8rxOLHT4fJ
         Hpndhj9yVIdLuJDcGe6m/X9FyGjP93YMzABhL3Qkc4g/7nvgqyDhZosHJntcs95fLbbG
         TJGNptDTCNOoJ2gWqK05gbTSHTeWXx3ZlMskyCfQynw127gL/ul3d34E1HtR0oUhrIKN
         nqTo4bdyOPH8ibtYrFNmUgJm941XtYjMSdp40H8gu5kV+nJH6nQy+AqEGirnikaDChvN
         an0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766726233; x=1767331033;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m9FIBnBIT8ZoZIIN6usk5vCof387U33RW9IfQgNu4dE=;
        b=kpQ3nkaSNVjoTUoUJk5f45bLEy/+CEye3AV8YZYFXVU+kBpHESTE3HGngtDOfQXMrj
         0T+OCCvZsi7E4eKeDDIZf+BtTA2ih3xax03fv3XI7aq++0ALFHPHu/AgGiGJ+a4PQZb0
         AsTfQJMOQSTGcStv0ul/lwm7YQY3NU+avjhcHV0OyAVvoOFf2pvRmUh4xWGm9gjCDvWj
         x9rffR1fKjBg8q2XqmIBbZho9EyPZ6ky9lZ7eJBslj15ccDYOJTByz0viEG0x563FbbS
         dTyHNPRGoNaNPtdDqBX66v3qeXhkTFhrOCnu911hs9My69QgsNrwhK3Hu/tUzzA5FAHN
         WIJA==
X-Gm-Message-State: AOJu0Ywoa7wWEtDdwHTbzWC/YGHIE3FPNg3NPVBhxf9jNuFUz4FyADOz
	pTqT53hjYbIhuyURgptoLvV9uTQzOmSdsCqVy1oUwZ6BHQuBaO1YKLiZtyV4dA==
X-Gm-Gg: AY/fxX4QiFVEkHv/PcU3PSg8a6X4D6RrrCaveWIYcm2loKuDRkdTrNOJiCvVbv+6qNm
	1pnejGtWL37FH1RV36YgFxUkCm66GJ+DJkiw1sn+P+ui6pHqdnxj06a75thTf1DUvnxj3lh5MlD
	Oms5BFYr7NQFEiSzGa5XwLPRlazzf7RlF6cXspQ7HOhc1iNSawwn4KBT3r40WEVdeT6oTY5ruge
	4IMDByalE0lanXLrHJSQv9exdRMcsv0ZC8bamOwdeBhqeZhn6qsSFXM7Cb204AUGUGbNIr6D/Di
	ykRYpwlNJ0WkJsZI8vPILmbWZq68SzHAsz9S0AlZZOOg0KsoeUHBia3tHIx9q0tEokL5K+FAvyP
	HE1F6V8lLcwNtasa3qbXsiR9AwnaHHuy5iEEFw+voIaTovWN/M7M50gGewNqF4j0Uij7B6CZCZQ
	NleeM6q/6IzbuOHpAmwVUHuTa8aRj22oPyEI1VJnK30SUWdhch4x4=
X-Google-Smtp-Source: AGHT+IF+0jA+Wk/IxGkJejZoWaUDwFSIVKNCa82JxbexbFr7JdRi7N174T19loWbeLafMPokiOiILg==
X-Received: by 2002:a17:902:d488:b0:2a0:7f9e:518c with SMTP id d9443c01a7336-2a2f222aed1mr218214765ad.16.1766726232867;
        Thu, 25 Dec 2025 21:17:12 -0800 (PST)
Received: from gourav-pc.lan (host-30-47.highlandsfibernetwork.com. [216.9.30.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c74490sm191467395ad.5.2025.12.25.21.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Dec 2025 21:17:12 -0800 (PST)
From: Gourav Roy <gourav.bit@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Gourav Roy <gourav.bit@gmail.com>
Subject: [PATCH] io-uring: fixed an int type code style issue
Date: Thu, 25 Dec 2025 21:16:16 -0800
Message-ID: <20251226051616.124925-1-gourav.bit@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixed a code style issue to prefer 'unsigned int' over bare use of 'unsigned'.

Signed-off-by: Gourav Roy <gourav.bit@gmail.com>
---
 io_uring/alloc_cache.c | 2 +-
 io_uring/alloc_cache.h | 2 +-
 io_uring/cancel.c      | 2 +-
 io_uring/eventfd.c     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/alloc_cache.c b/io_uring/alloc_cache.c
index 58423888b736..9aee9f944d2c 100644
--- a/io_uring/alloc_cache.c
+++ b/io_uring/alloc_cache.c
@@ -19,7 +19,7 @@ void io_alloc_cache_free(struct io_alloc_cache *cache,
 
 /* returns false if the cache was initialized properly */
 bool io_alloc_cache_init(struct io_alloc_cache *cache,
-			 unsigned max_nr, unsigned int size,
+			 unsigned int max_nr, unsigned int size,
 			 unsigned int init_bytes)
 {
 	cache->entries = kvmalloc_array(max_nr, sizeof(void *), GFP_KERNEL);
diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index d33ce159ef33..8f70af6eb341 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -11,7 +11,7 @@
 void io_alloc_cache_free(struct io_alloc_cache *cache,
 			 void (*free)(const void *));
 bool io_alloc_cache_init(struct io_alloc_cache *cache,
-			 unsigned max_nr, unsigned int size,
+			 unsigned int max_nr, unsigned int size,
 			 unsigned int init_bytes);
 
 void *io_cache_alloc_new(struct io_alloc_cache *cache, gfp_t gfp);
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index ca12ac10c0ae..a9a674581871 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -104,7 +104,7 @@ static int io_async_cancel_one(struct io_uring_task *tctx,
 }
 
 int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
-		  unsigned issue_flags)
+		  unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = cd->ctx;
 	int ret;
diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 78f8ab7db104..ecf899a9c697 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -15,7 +15,7 @@ struct io_ev_fd {
 	struct eventfd_ctx	*cq_ev_fd;
 	unsigned int		eventfd_async;
 	/* protected by ->completion_lock */
-	unsigned		last_cq_tail;
+	unsigned int		last_cq_tail;
 	refcount_t		refs;
 	atomic_t		ops;
 	struct rcu_head		rcu;
-- 
2.51.0


