Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C783E98E5
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 21:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhHKTgJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 15:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbhHKTgG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 15:36:06 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734F2C06179C
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:35:42 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so11293729pjn.4
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tDPWk1yBG9VXyK3+TgNLLGFSPQaPVX6OpfLB0cZ8UbY=;
        b=N2SQk0jWGzefn7ZryjJ+8B+QR0pYyx4832XiD6ixNsbDDZCpt6DYBxR2dxyldJKzdY
         VCB9KfHGLTD0aJUvMCZR9U8AnmMFBAHxvDfp3OQoK4r+I/b5T4sZbd5UUu5V2Dd8+DD7
         hJD2LKuwpYPXzdp3a3/L1Gc/VFh7W5u4+IsCaqDczxooSruYkJL6Qunr3HipCQhbNSXc
         6sVmdNmH989spY+tC4SxRFGmxnlSMMZbnPhwLdPiCuipIUiire6Qomwz7nbwD/kQKbTK
         EerDk1VUGMtqWIx6p/Q0do7egCZWgsrR1CUGdhvSATQd1nH7mJkFIqK9L1r0+WVHYl11
         G9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tDPWk1yBG9VXyK3+TgNLLGFSPQaPVX6OpfLB0cZ8UbY=;
        b=cNnnl7tNvPp5p7OmWZ1CmJH4AvojTWDB8XuehH7GNbN40FS4UfAQyZQEHW7E0wwB/y
         M2soR5+IT4SZJNDaQCBdQDh1/ltdEfSb+ueFk+EeS5yrwD4Mor4xVSG+8ez7ES3DMEpG
         Xc5uyrZ+eNt9/3Getxq8DIr7qhbkvM0i/Su+hGNl3uHzgWUv18Jq+zF0UBf4WF1MwPPl
         rs8sIGn8Ikzc2hFDvY+bugfKBa3z0Z+LqKTvNJFPrDBcZuZjvoFP0fGmqh5JaUv2WfSv
         YjNsTkb9+Ig8zV3F4rSqK9zaji6HG0ILiL0GFcgiqeCKqnXSgQN/8TipRoHUVHFSjwXM
         VHaw==
X-Gm-Message-State: AOAM531EGRar+dUVcI6saE7JyvmqBsOpMYgyK7Cxc7OHBT6eb2ljr9zd
        Rjs74As2/rh+Rl0CiznKnGqDExfoFUVZAiit
X-Google-Smtp-Source: ABdhPJww6eH4MuL0ZbF6qoK+twZet8gFfzBwTPEE1tkzFOCe9g9QtblnV8z3DFLRqEzevVBtsuizRg==
X-Received: by 2002:a63:e116:: with SMTP id z22mr278412pgh.361.1628710541727;
        Wed, 11 Aug 2021 12:35:41 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id u20sm286487pgm.4.2021.08.11.12.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 12:35:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, hch@infradead.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] bio: add allocation cache abstraction
Date:   Wed, 11 Aug 2021 13:35:30 -0600
Message-Id: <20210811193533.766613-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210811193533.766613-1-axboe@kernel.dk>
References: <20210811193533.766613-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a per-cpu bio_set cache for bio allocations, enabling us to quickly
recycle them instead of going through the slab allocator. This cache
isn't IRQ safe, and hence is only really suitable for polled IO.

Very simple - keeps a count of bio's in the cache, and maintains a max
of 512 with a slack of 64. If we get above max + slack, we drop slack
number of bio's.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/bio.c                | 139 +++++++++++++++++++++++++++++++++----
 include/linux/bio.h        |  23 ++++--
 include/linux/blk_types.h  |   1 +
 include/linux/cpuhotplug.h |   1 +
 4 files changed, 144 insertions(+), 20 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 0b1025899131..689335c00937 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -25,6 +25,11 @@
 #include "blk.h"
 #include "blk-rq-qos.h"
 
+struct bio_alloc_cache {
+	struct bio_list		free_list;
+	unsigned int		nr;
+};
+
 static struct biovec_slab {
 	int nr_vecs;
 	char *name;
@@ -620,6 +625,69 @@ void guard_bio_eod(struct bio *bio)
 	bio_truncate(bio, maxsector << 9);
 }
 
+#define ALLOC_CACHE_MAX		512
+#define ALLOC_CACHE_SLACK	 64
+
+static void bio_alloc_cache_prune(struct bio_alloc_cache *cache,
+				  unsigned int nr)
+{
+	struct bio *bio;
+	unsigned int i;
+
+	i = 0;
+	while ((bio = bio_list_pop(&cache->free_list)) != NULL) {
+		cache->nr--;
+		bio_free(bio);
+		if (++i == nr)
+			break;
+	}
+}
+
+static int bio_cpu_dead(unsigned int cpu, struct hlist_node *node)
+{
+	struct bio_set *bs;
+
+	bs = hlist_entry_safe(node, struct bio_set, cpuhp_dead);
+	if (bs->cache) {
+		struct bio_alloc_cache *cache = per_cpu_ptr(bs->cache, cpu);
+
+		bio_alloc_cache_prune(cache, -1U);
+	}
+	return 0;
+}
+
+static void bio_alloc_cache_destroy(struct bio_set *bs)
+{
+	int cpu;
+
+	if (!bs->cache)
+		return;
+
+	preempt_disable();
+	cpuhp_state_remove_instance_nocalls(CPUHP_BIO_DEAD, &bs->cpuhp_dead);
+	for_each_possible_cpu(cpu) {
+		struct bio_alloc_cache *cache;
+
+		cache = per_cpu_ptr(bs->cache, cpu);
+		bio_alloc_cache_prune(cache, -1U);
+	}
+	preempt_enable();
+	free_percpu(bs->cache);
+}
+
+static inline bool __bio_put(struct bio *bio)
+{
+	if (!bio_flagged(bio, BIO_REFFED))
+		return true;
+
+	BIO_BUG_ON(!atomic_read(&bio->__bi_cnt));
+
+	/*
+	 * last put frees it
+	 */
+	return atomic_dec_and_test(&bio->__bi_cnt);
+}
+
 /**
  * bio_put - release a reference to a bio
  * @bio:   bio to release reference to
@@ -630,16 +698,21 @@ void guard_bio_eod(struct bio *bio)
  **/
 void bio_put(struct bio *bio)
 {
-	if (!bio_flagged(bio, BIO_REFFED))
-		bio_free(bio);
-	else {
-		BIO_BUG_ON(!atomic_read(&bio->__bi_cnt));
+	if (unlikely(!__bio_put(bio)))
+		return;
 
-		/*
-		 * last put frees it
-		 */
-		if (atomic_dec_and_test(&bio->__bi_cnt))
-			bio_free(bio);
+	if (bio_flagged(bio, BIO_PERCPU_CACHE)) {
+		struct bio_alloc_cache *cache;
+
+		bio_uninit(bio);
+		cache = per_cpu_ptr(bio->bi_pool->cache, get_cpu());
+		bio_list_add_head(&cache->free_list, bio);
+		cache->nr++;
+		if (cache->nr > ALLOC_CACHE_MAX + ALLOC_CACHE_SLACK)
+			bio_alloc_cache_prune(cache, ALLOC_CACHE_SLACK);
+		put_cpu();
+	} else {
+		bio_free(bio);
 	}
 }
 EXPORT_SYMBOL(bio_put);
@@ -1531,6 +1604,7 @@ int biovec_init_pool(mempool_t *pool, int pool_entries)
  */
 void bioset_exit(struct bio_set *bs)
 {
+	bio_alloc_cache_destroy(bs);
 	if (bs->rescue_workqueue)
 		destroy_workqueue(bs->rescue_workqueue);
 	bs->rescue_workqueue = NULL;
@@ -1592,12 +1666,18 @@ int bioset_init(struct bio_set *bs,
 	    biovec_init_pool(&bs->bvec_pool, pool_size))
 		goto bad;
 
-	if (!(flags & BIOSET_NEED_RESCUER))
-		return 0;
-
-	bs->rescue_workqueue = alloc_workqueue("bioset", WQ_MEM_RECLAIM, 0);
-	if (!bs->rescue_workqueue)
-		goto bad;
+	if (flags & BIOSET_NEED_RESCUER) {
+		bs->rescue_workqueue = alloc_workqueue("bioset",
+							WQ_MEM_RECLAIM, 0);
+		if (!bs->rescue_workqueue)
+			goto bad;
+	}
+	if (flags & BIOSET_PERCPU_CACHE) {
+		bs->cache = alloc_percpu(struct bio_alloc_cache);
+		if (!bs->cache)
+			goto bad;
+		cpuhp_state_add_instance_nocalls(CPUHP_BIO_DEAD, &bs->cpuhp_dead);
+	}
 
 	return 0;
 bad:
@@ -1624,6 +1704,32 @@ int bioset_init_from_src(struct bio_set *bs, struct bio_set *src)
 }
 EXPORT_SYMBOL(bioset_init_from_src);
 
+struct bio *bio_alloc_kiocb(struct kiocb *kiocb, gfp_t gfp,
+			    unsigned short nr_vecs, struct bio_set *bs)
+{
+	struct bio_alloc_cache *cache = NULL;
+	struct bio *bio;
+
+	if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE) || nr_vecs > BIO_INLINE_VECS)
+		goto normal_alloc;
+
+	cache = per_cpu_ptr(bs->cache, get_cpu());
+	bio = bio_list_pop(&cache->free_list);
+	if (bio) {
+		cache->nr--;
+		put_cpu();
+		bio_init(bio, nr_vecs ? bio->bi_inline_vecs : NULL, nr_vecs);
+		bio_set_flag(bio, BIO_PERCPU_CACHE);
+		return bio;
+	}
+	put_cpu();
+normal_alloc:
+	bio = bio_alloc_bioset(gfp, nr_vecs, bs);
+	if (cache)
+		bio_set_flag(bio, BIO_PERCPU_CACHE);
+	return bio;
+}
+
 static int __init init_bio(void)
 {
 	int i;
@@ -1638,6 +1744,9 @@ static int __init init_bio(void)
 				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 	}
 
+	cpuhp_setup_state_multi(CPUHP_BIO_DEAD, "block/bio:dead", NULL,
+					bio_cpu_dead);
+
 	if (bioset_init(&fs_bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS))
 		panic("bio: can't allocate bios\n");
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 2203b686e1f0..5f4a741ee97d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -401,6 +401,7 @@ static inline struct bio *bio_next_split(struct bio *bio, int sectors,
 enum {
 	BIOSET_NEED_BVECS = BIT(0),
 	BIOSET_NEED_RESCUER = BIT(1),
+	BIOSET_PERCPU_CACHE = BIT(2),
 };
 extern int bioset_init(struct bio_set *, unsigned int, unsigned int, int flags);
 extern void bioset_exit(struct bio_set *);
@@ -409,6 +410,8 @@ extern int bioset_init_from_src(struct bio_set *bs, struct bio_set *src);
 
 struct bio *bio_alloc_bioset(gfp_t gfp, unsigned short nr_iovecs,
 		struct bio_set *bs);
+struct bio *bio_alloc_kiocb(struct kiocb *kiocb, gfp_t, unsigned short nr_vecs,
+		struct bio_set *bs);
 struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned short nr_iovecs);
 extern void bio_put(struct bio *);
 
@@ -652,18 +655,22 @@ static inline struct bio *bio_list_peek(struct bio_list *bl)
 	return bl->head;
 }
 
-static inline struct bio *bio_list_pop(struct bio_list *bl)
+static inline void bio_list_del_head(struct bio_list *bl, struct bio *head)
 {
-	struct bio *bio = bl->head;
-
-	if (bio) {
+	if (head) {
 		bl->head = bl->head->bi_next;
 		if (!bl->head)
 			bl->tail = NULL;
 
-		bio->bi_next = NULL;
+		head->bi_next = NULL;
 	}
+}
+
+static inline struct bio *bio_list_pop(struct bio_list *bl)
+{
+	struct bio *bio = bl->head;
 
+	bio_list_del_head(bl, bio);
 	return bio;
 }
 
@@ -699,6 +706,12 @@ struct bio_set {
 	struct kmem_cache *bio_slab;
 	unsigned int front_pad;
 
+	/*
+	 * per-cpu bio alloc cache and notifier
+	 */
+	struct bio_alloc_cache __percpu *cache;
+	struct hlist_node cpuhp_dead;
+
 	mempool_t bio_pool;
 	mempool_t bvec_pool;
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 290f9061b29a..f68d4e8c775e 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -301,6 +301,7 @@ enum {
 	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_LOCKED,	/* Owns a zoned device zone write lock */
+	BIO_PERCPU_CACHE,	/* can participate in per-cpu alloc cache */
 	BIO_FLAG_LAST
 };
 
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index f39b34b13871..fe72c8d6c980 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -46,6 +46,7 @@ enum cpuhp_state {
 	CPUHP_ARM_OMAP_WAKE_DEAD,
 	CPUHP_IRQ_POLL_DEAD,
 	CPUHP_BLOCK_SOFTIRQ_DEAD,
+	CPUHP_BIO_DEAD,
 	CPUHP_ACPI_CPUDRV_DEAD,
 	CPUHP_S390_PFAULT_DEAD,
 	CPUHP_BLK_MQ_DEAD,
-- 
2.32.0

