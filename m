Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE1E6032C2
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 20:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiJRSs7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Oct 2022 14:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiJRSs4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 14:48:56 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFCDA02FA;
        Tue, 18 Oct 2022 11:48:49 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id a67so21824063edf.12;
        Tue, 18 Oct 2022 11:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZenMiiiYQ0xZIz3KLnoOLLCCa6zuOP8hwCIircl7LY=;
        b=TMW6J/GJG6ZptFWYW7eF0s8MW93rzpdA+HBUOR9t4xb7SNHvfuXDwdA9Gx/2KFwcyd
         4IXLZ1thCDtzhPWTLNeKXgWQeg9VYur41LLvc6jHgXUGjM011GB4t92rLcphcS5zfx+8
         v/QVqnanfeC8a+g7NPIgGocQoqVY3P/+WLi/2t05SBr9qtArj4jM6A5iYWYoqkfOqzSn
         1fYly/urPxlsjKB2KFGcLwA/wwkJKzmajOHrHq6NFqYuSBa6G/S7psrbRmDRqoIdiIUQ
         2IpIP2K+lKsioSW8QsmSk9lGfrX3H2b8oSV507r5CgYc/Rx0xDvp3TNmJDtR9+FwB2nX
         JkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZenMiiiYQ0xZIz3KLnoOLLCCa6zuOP8hwCIircl7LY=;
        b=I/FOePsvHQqNGmnoh06FMV9UcCb4QWN3jAKTbIBwCOZKQVP6ei9wJ1byxLH2KTmkxq
         tuTz/jkLP74BAHpPWt958iu+ttmL7ynj6z4CvzW0iPQRThblkIyuS9GcsTr8BEZs37N+
         9fN7TkFn8qp91HXr2xP1Cl113QR36i9OY+lf38bDm2shg+aU1vaA2ySQ3a3GWZ6mp3i+
         9E4hg0/TOrMcz/9V/VBvq8UzqeaE6ec5mrxryoYDGlf3Ithm4mLcv1oMqvnFJclLcPrR
         Uo1hOQiYd4cmHQiFtYJxrTpwaB5G/pdB2rPECwXSBuTzGiTgKlCIwYSdh8pAJMsz9NPY
         tnxQ==
X-Gm-Message-State: ACrzQf2UyQLoiOU2NxIVKWdD6aJ4ELya9Rj/PkrSw7AcNqXzmUYWrN5Y
        idKpDATa0VCXH1ddyweeHUk4wi2tWnY=
X-Google-Smtp-Source: AMsMyM4bPDTbrQdyKQ+dTTuCA2wtNNsuQHTZq/B0dIsswYrbRBYKxETkmcIUg3RQDxgfPo6Az7FVwA==
X-Received: by 2002:a05:6402:354d:b0:45c:b772:5ef4 with SMTP id f13-20020a056402354d00b0045cb7725ef4mr3987962edd.225.1666118926805;
        Tue, 18 Oct 2022 11:48:46 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id j18-20020a17090623f200b0078db18d7972sm7855355ejg.117.2022.10.18.11.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 11:48:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC for-next 3/4] block/bio: add pcpu caching for non-polling bio_put
Date:   Tue, 18 Oct 2022 19:47:15 +0100
Message-Id: <646001320f5543e0e23a4a64e886fa8ed768d2c1.1666114003.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666114003.git.asml.silence@gmail.com>
References: <cover.1666114003.git.asml.silence@gmail.com>
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
 block/bio.c | 62 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 50 insertions(+), 12 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index ac16cc154476..75107dc27304 100644
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
@@ -416,9 +438,13 @@ static struct bio *bio_alloc_percpu_cache(struct block_device *bdev,
 	struct bio *bio;
 
 	cache = per_cpu_ptr(bs->cache, get_cpu());
-	if (!cache->free_list) {
-		put_cpu();
-		return NULL;
+	if (!cache->free_list &&
+	    READ_ONCE(cache->nr_irq) >= ALLOC_CACHE_THRESHOLD) {
+		bio_alloc_irq_cache_splice(cache);
+		if (!cache->free_list) {
+			put_cpu();
+			return NULL;
+		}
 	}
 	bio = cache->free_list;
 	cache->free_list = bio->bi_next;
@@ -676,11 +702,8 @@ void guard_bio_eod(struct bio *bio)
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
@@ -692,6 +715,17 @@ static void bio_alloc_cache_prune(struct bio_alloc_cache *cache,
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
@@ -728,6 +762,7 @@ static void bio_alloc_cache_destroy(struct bio_set *bs)
 static inline void bio_put_percpu_cache(struct bio *bio)
 {
 	struct bio_alloc_cache *cache;
+	unsigned long flags;
 
 	cache = per_cpu_ptr(bio->bi_pool->cache, get_cpu());
 	bio_uninit(bio);
@@ -737,12 +772,15 @@ static inline void bio_put_percpu_cache(struct bio *bio)
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

