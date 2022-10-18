Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D643603389
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 21:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiJRTwp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Oct 2022 15:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiJRTwk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 15:52:40 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5E7857F5;
        Tue, 18 Oct 2022 12:52:30 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id y14so34869847ejd.9;
        Tue, 18 Oct 2022 12:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F/aQ8vmh1jZL17zaP9aQue+c8W/pbna/0wkMpy2D0Vo=;
        b=jvWw9ru2o3Oj8dramvcuYh4qUbMzZVFrRRtnU0R2o9qlGMM30cKLMz+hL0+8Mg7C6B
         6gQBjOV42HYC3k7jQ9TbK+Q3s+0rEUCX3mUsyyoZiEHxdLk8I+yv1LFO5p/SlaBP1U5z
         5OGe+4LYLTIwynUdRhvA4oXyILoHVRxxWKGbXUAhx0KsXoHw3aOutng6yz3QutlAC0Ac
         Oq6eO67IRQC4rY0AXprrZ/uSpqCq7OFNfXeh5zZHHKF/YFHRHl06jYZQ4WPh8w9U4j8n
         8UVxAOsWxttfx42qdlj0hawDwMu5UfmgmsyqhrpHqjLB+uwM29flR3KsqvSSUXiMaxF9
         +G4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F/aQ8vmh1jZL17zaP9aQue+c8W/pbna/0wkMpy2D0Vo=;
        b=WTb8o+CZeg1HWKbNruNERDVwZ/3NjBzJkoOQf3Q5fq0eII9/sZRmolEQDyYxBCfGq2
         7Jypz25v3nAbmlsCvOcleAHyDzOtTJY/tCsN6qyEQs88PixwSVg4kpPy1yBba9ZQm+Oy
         eTlGz/jP896Kta387ZUT02N8wC23BPw3EHajMSvVtroQZ3fKE8uWwE6VjfGDshKOwrqS
         lotm5rPl3u4Khtt3i+eTLsmdT3D0Okreakl+E7zS3f/MfFrAIwaUgMhYx0gXaW3l8m9p
         Z/pbugVehyz51LBC59N7rbKJdkfySLzB6HpaXyEXPySBtk5Tfwb4jLBBw+6LqES42aWP
         bbMA==
X-Gm-Message-State: ACrzQf2Ep39kLDLfSfrnA7nkgLVt5F6FqKjy1x104XhnkuV2lmBDUww5
        +qEbeSUIYnM5bx9RTxYhAzp/3JdYYmI=
X-Google-Smtp-Source: AMsMyM4cZM94eibR4vsky9wpZ0U43PkV1uNynN0mLu9z6GZbqC1oGvFBDbBqWU7Wr3kxBXTm/7NSBg==
X-Received: by 2002:a17:907:d04:b0:76e:e208:27ba with SMTP id gn4-20020a1709070d0400b0076ee20827bamr3931422ejc.652.1666122727949;
        Tue, 18 Oct 2022 12:52:07 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id r1-20020a1709061ba100b0072a881b21d8sm7945858ejg.119.2022.10.18.12.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 12:52:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC for-next v2 3/4] block/bio: add pcpu caching for non-polling bio_put
Date:   Tue, 18 Oct 2022 20:50:57 +0100
Message-Id: <9fd04486d972c1f3ef273fa26b4b6bf51a5e4270.1666122465.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666122465.git.asml.silence@gmail.com>
References: <cover.1666122465.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch extends REQ_ALLOC_CACHE to IRQ completions, whenever
currently it's only limited to iopoll. Instead of guarding the list with
irq toggling on alloc, which is expensive, it keeps an additional
irq-safe list from which bios are spliced in batches to ammortise
overhead. On the put side it toggles irqs, but in many cases they're
already disabled and so cheap.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c | 64 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 53 insertions(+), 11 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index ac16cc154476..c2dda2759df5 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -25,9 +25,15 @@
 #include "blk-rq-qos.h"
 #include "blk-cgroup.h"
 
+#define ALLOC_CACHE_THRESHOLD	16
+#define ALLOC_CACHE_SLACK	64
+#define ALLOC_CACHE_MAX		512
+
 struct bio_alloc_cache {
 	struct bio		*free_list;
+	struct bio		*free_list_irq;
 	unsigned int		nr;
+	unsigned int		nr_irq;
 };
 
 static struct biovec_slab {
@@ -408,6 +414,22 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
 	queue_work(bs->rescue_workqueue, &bs->rescue_work);
 }
 
+static void bio_alloc_irq_cache_splice(struct bio_alloc_cache *cache)
+{
+	unsigned long flags;
+
+	/* cache->free_list must be empty */
+	if (WARN_ON_ONCE(cache->free_list))
+		return;
+
+	local_irq_save(flags);
+	cache->free_list = cache->free_list_irq;
+	cache->free_list_irq = NULL;
+	cache->nr += cache->nr_irq;
+	cache->nr_irq = 0;
+	local_irq_restore(flags);
+}
+
 static struct bio *bio_alloc_percpu_cache(struct block_device *bdev,
 		unsigned short nr_vecs, blk_opf_t opf, gfp_t gfp,
 		struct bio_set *bs)
@@ -417,9 +439,17 @@ static struct bio *bio_alloc_percpu_cache(struct block_device *bdev,
 
 	cache = per_cpu_ptr(bs->cache, get_cpu());
 	if (!cache->free_list) {
-		put_cpu();
-		return NULL;
+		if (READ_ONCE(cache->nr_irq) < ALLOC_CACHE_THRESHOLD) {
+			put_cpu();
+			return NULL;
+		}
+		bio_alloc_irq_cache_splice(cache);
+		if (!cache->free_list) {
+			put_cpu();
+			return NULL;
+		}
 	}
+
 	bio = cache->free_list;
 	cache->free_list = bio->bi_next;
 	cache->nr--;
@@ -676,11 +706,8 @@ void guard_bio_eod(struct bio *bio)
 	bio_truncate(bio, maxsector << 9);
 }
 
-#define ALLOC_CACHE_MAX		512
-#define ALLOC_CACHE_SLACK	 64
-
-static void bio_alloc_cache_prune(struct bio_alloc_cache *cache,
-				  unsigned int nr)
+static int __bio_alloc_cache_prune(struct bio_alloc_cache *cache,
+				   unsigned int nr)
 {
 	unsigned int i = 0;
 	struct bio *bio;
@@ -692,6 +719,17 @@ static void bio_alloc_cache_prune(struct bio_alloc_cache *cache,
 		if (++i == nr)
 			break;
 	}
+	return i;
+}
+
+static void bio_alloc_cache_prune(struct bio_alloc_cache *cache,
+				  unsigned int nr)
+{
+	nr -= __bio_alloc_cache_prune(cache, nr);
+	if (!READ_ONCE(cache->free_list)) {
+		bio_alloc_irq_cache_splice(cache);
+		__bio_alloc_cache_prune(cache, nr);
+	}
 }
 
 static int bio_cpu_dead(unsigned int cpu, struct hlist_node *node)
@@ -728,6 +766,7 @@ static void bio_alloc_cache_destroy(struct bio_set *bs)
 static inline void bio_put_percpu_cache(struct bio *bio)
 {
 	struct bio_alloc_cache *cache;
+	unsigned long flags;
 
 	cache = per_cpu_ptr(bio->bi_pool->cache, get_cpu());
 	bio_uninit(bio);
@@ -737,12 +776,15 @@ static inline void bio_put_percpu_cache(struct bio *bio)
 		cache->free_list = bio;
 		cache->nr++;
 	} else {
-		put_cpu();
-		bio_free(bio);
-		return;
+		local_irq_save(flags);
+		bio->bi_next = cache->free_list_irq;
+		cache->free_list_irq = bio;
+		cache->nr_irq++;
+		local_irq_restore(flags);
 	}
 
-	if (cache->nr > ALLOC_CACHE_MAX + ALLOC_CACHE_SLACK)
+	if (READ_ONCE(cache->nr_irq) + cache->nr >
+	    ALLOC_CACHE_MAX + ALLOC_CACHE_SLACK)
 		bio_alloc_cache_prune(cache, ALLOC_CACHE_SLACK);
 	put_cpu();
 }
-- 
2.38.0

