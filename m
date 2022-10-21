Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE320607514
	for <lists+io-uring@lfdr.de>; Fri, 21 Oct 2022 12:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiJUKgZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 06:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiJUKgY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 06:36:24 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B3F1A3E24;
        Fri, 21 Oct 2022 03:36:18 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id j7so4218223wrr.3;
        Fri, 21 Oct 2022 03:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dbgij4KdCuUgIto/9QTZly2/sdw9SHJOJXzPvbzOwA0=;
        b=TdDeffCwT0HzaCa7kEAmaBrZcGFasxW+K+LaBBZViyzAeKspc/DZr+YsQ3MOoQtN5r
         8O/gjSjabUQjqevTVYQXI6AdrzyP3DLVHR0bbSicHjSCTcLBIK3PKvpf6Ctphs8xU+bp
         GmPCssPjIfgaYUOlIuTGISGdtmRnzoHGavKVHwYvao07jNN+V99LPq7OLvku5ZwantST
         W2tHVHorgwtJ+t1t2gMy7aXQG9KofVgnFmJJktOGbf2Rg9U34gptTGpHcFW4QrSdAIZa
         0jC7MCAP/+DuhKX2YH/eWTxAVfOPOPwk6LnaiP3r5MD9V/SKb1gshEZ+vv9Ysu5aeXlB
         JLVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dbgij4KdCuUgIto/9QTZly2/sdw9SHJOJXzPvbzOwA0=;
        b=jXFKxXmMi4buu+OR7NP+9CuC1iBzCZS85Dg9VNjFrwiVA2tWfWzIlpFBuBveTvybe5
         XHj/MFIW84WkjMNQJ4AlEi5qxhDXlSskU6FKqp10e/O09ouadvH2DFFWKh3hE89vkpeo
         9Uy91Bq8qe/n2n6F4p3cR+wdkSGpFagGr6MD7W0eGgOtkKY7eVY7Uf5eNY/Al+VqORLr
         JZYNLL8QT3lQh16ZX80iD/OsRppLIhbL7xFS6dz9p5uviJiaUEgauWSLDyiPxnvArJP3
         chd0aiUMZaVePZHPGzbk99cYQnjlUdwqgANZzJVasP27o924ViIgbo+zHuaiovGeF9fd
         0IhQ==
X-Gm-Message-State: ACrzQf11f/Hr/BL4JqFF9ZUIeZR4t1QkOJrKV8pw48BkDF9bZRSRNsOK
        KMWiQHy+CnltFD6x1f9EgkE=
X-Google-Smtp-Source: AMsMyM5T1SB+SiekgWPLqAopHmHeNbObB4Cruq1OCGKO9x5y5hm55FkE//h8CVaFPe2nPzlrgzByLQ==
X-Received: by 2002:a05:6000:1561:b0:22e:6c59:e347 with SMTP id 1-20020a056000156100b0022e6c59e347mr12033097wrz.519.1666348576869;
        Fri, 21 Oct 2022 03:36:16 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id e14-20020a5d65ce000000b0022abcc1e3cesm18544759wrw.116.2022.10.21.03.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 03:36:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH for-next v3 2/3] block/bio: add pcpu caching for non-polling bio_put
Date:   Fri, 21 Oct 2022 11:34:06 +0100
Message-Id: <4bf4e1716600b929866c13b4c15dcf94f11f9f3f.1666347703.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666347703.git.asml.silence@gmail.com>
References: <cover.1666347703.git.asml.silence@gmail.com>
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
 block/bio.c | 63 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 51 insertions(+), 12 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 7a573e0f5f52..f7c57352f306 100644
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
@@ -737,12 +771,17 @@ static inline void bio_put_percpu_cache(struct bio *bio)
 		cache->free_list = bio;
 		cache->nr++;
 	} else {
-		put_cpu();
-		bio_free(bio);
-		return;
+		unsigned long flags;
+
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

