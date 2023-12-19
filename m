Return-Path: <io-uring+bounces-302-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 680818191E7
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:04:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E0BE283298
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FAC23A1B5;
	Tue, 19 Dec 2023 21:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="mQAsWpko"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61DA3B29D
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5c701bd98f3so1901362a12.1
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019849; x=1703624649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w5PuaR4d/MoGidxq0L3iO4s55XxlUWagn7UVjiQLif0=;
        b=mQAsWpko25z+CTg2NQCrn3+F/sH0Eoi9YUbQHrgmGGxjLbwEY6YsIfzFpthxOJgOHX
         /hALO3Q5rXgVxL3NRJZslycn3rMeSPWyiiHt5OvhvjwvAOYc2iDrpr8dywWrkF9EprJ7
         nNSvXpPKDJumRdZR+LIgNdtx+pTAUwW8ULXiJxim6D1rFNY28QWkslqjV7anF+dZJk2N
         uKF+dhTG9TEGUd39BJAXU7J00Cpnhz3Pv3BY4KdbN5nyL4qh/pCEd8aelMV09LenVurg
         8TSxPHs5nGOQ89YNnSU5PJt2G8DmyZKYxwKngjr1hbQVw/mTBwvsrcmb2cLPj4HT7pLT
         nDGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019849; x=1703624649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w5PuaR4d/MoGidxq0L3iO4s55XxlUWagn7UVjiQLif0=;
        b=Z75qWvs3ViSE0ArPj+7eNPeORCaOYZpI8vOMg9oChw3tQa29qffsE9DqBb5gI0ydjg
         +zzwpLzejfZ9/pgJwreS0MaFejJjMuxUWgzZTc1ExaqM91f4V2uoh61Vnx6UrMLJwoLD
         o7qXedOxY0RjFkwkhGQDOl63hJK4sLND/ALE6LIWEstiCZwgoGGn8/G6lhWMS/FaYRSf
         OsCKeilprsyWPz3xuUXk+SsUvQmiCdL9N0uJaLAs41vHK6iOlRVaSRLQMhnRvkc81B0H
         hvTcAHjMrw0eHvjrNAqgKSYEMLt485RVrjs3N7+uLSSp+FgO1yPmO9C6IX+JhdzDpDBV
         gBBg==
X-Gm-Message-State: AOJu0YypiifJXjB8WlaSUNDqNAhbzeAkpoNcmZEM3Ir3wrafdK0G7ZLw
	izTryx/rMnIRXAlKBHTDzq86N7suVyWAr7L7l5p0tQ==
X-Google-Smtp-Source: AGHT+IFxU8K97jLnXcSyyO+D+sbfKINOieazzqXKOxdloDIB5FLVgcl8B8HXGUFAAoIhc0I94Q4ixg==
X-Received: by 2002:a17:90a:7405:b0:28b:9a2d:c1c3 with SMTP id a5-20020a17090a740500b0028b9a2dc1c3mr2555650pjg.80.1703019848745;
        Tue, 19 Dec 2023 13:04:08 -0800 (PST)
Received: from localhost (fwdproxy-prn-008.fbsv.net. [2a03:2880:ff:8::face:b00c])
        by smtp.gmail.com with ESMTPSA id bx15-20020a17090af48f00b0028b89520c7asm2091559pjb.9.2023.12.19.13.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:08 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v3 04/20] net: enable napi_pp_put_page for ppiov
Date: Tue, 19 Dec 2023 13:03:41 -0800
Message-Id: <20231219210357.4029713-5-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231219210357.4029713-1-dw@davidwei.uk>
References: <20231219210357.4029713-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

NOT FOR UPSTREAM

Teach napi_pp_put_page() how to work with ppiov.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/helpers.h |  2 +-
 net/core/page_pool.c            |  3 ---
 net/core/skbuff.c               | 28 ++++++++++++++++------------
 3 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/include/net/page_pool/helpers.h b/include/net/page_pool/helpers.h
index ef380ee8f205..aca3a52d0e22 100644
--- a/include/net/page_pool/helpers.h
+++ b/include/net/page_pool/helpers.h
@@ -381,7 +381,7 @@ static inline long page_pool_defrag_page(struct page *page, long nr)
 	long ret;
 
 	if (page_is_page_pool_iov(page))
-		return -EINVAL;
+		return 0;
 
 	/* If nr == pp_frag_count then we have cleared all remaining
 	 * references to the page:
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index ecf90a1ccabe..71af9835638e 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -922,9 +922,6 @@ static void page_pool_empty_alloc_cache_once(struct page_pool *pool)
 {
 	struct page *page;
 
-	if (pool->destroy_cnt)
-		return;
-
 	/* Empty alloc cache, assume caller made sure this is
 	 * no-longer in use, and page_pool_alloc_pages() cannot be
 	 * call concurrently.
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f44c53b0ca27..cf523d655f92 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -896,19 +896,23 @@ bool napi_pp_put_page(struct page *page, bool napi_safe)
 	bool allow_direct = false;
 	struct page_pool *pp;
 
-	page = compound_head(page);
-
-	/* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
-	 * in order to preserve any existing bits, such as bit 0 for the
-	 * head page of compound page and bit 1 for pfmemalloc page, so
-	 * mask those bits for freeing side when doing below checking,
-	 * and page_is_pfmemalloc() is checked in __page_pool_put_page()
-	 * to avoid recycling the pfmemalloc page.
-	 */
-	if (unlikely((page->pp_magic & ~0x3UL) != PP_SIGNATURE))
-		return false;
+	if (page_is_page_pool_iov(page)) {
+		pp = page_to_page_pool_iov(page)->pp;
+	} else {
+		page = compound_head(page);
+
+		/* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
+		 * in order to preserve any existing bits, such as bit 0 for the
+		 * head page of compound page and bit 1 for pfmemalloc page, so
+		 * mask those bits for freeing side when doing below checking,
+		 * and page_is_pfmemalloc() is checked in __page_pool_put_page()
+		 * to avoid recycling the pfmemalloc page.
+		 */
+		if (unlikely((page->pp_magic & ~0x3UL) != PP_SIGNATURE))
+			return false;
 
-	pp = page->pp;
+		pp = page->pp;
+	}
 
 	/* Allow direct recycle if we have reasons to believe that we are
 	 * in the same context as the consumer would run, so there's
-- 
2.39.3


