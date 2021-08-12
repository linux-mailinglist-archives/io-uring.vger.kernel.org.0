Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8557D3EA7CF
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 17:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238240AbhHLPmV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 11:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238262AbhHLPmV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 11:42:21 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24195C0617AE
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:41:56 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id c23-20020a0568301af7b029050cd611fb72so8255685otd.3
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TLRHeGT8+RAZgeaFPRMZhCfLrpW1DAxjHOSfqTjELLw=;
        b=ljWjTyij5TeS7JhqwXA0iOGT+ucvLdoOGLydmfS9GD2K8uEDdDgqLX9P+V1g3oxQY9
         Gq96HSqQD+op6EH3OpxWG4qY5pVkLiSAkRjhMhr4I9D7V6Q6lzgkVyQs2qa+/z/OzH9G
         XmQ5oRVvVi9pKyU8Qz5zXpquf6z/H95EIbEZw6TORKrQq3QYQmvIpNp4VuzkknICwEsw
         2ZDWQyPWp2RkM6DULlcPsA8Fxdv09M8+gLd/UmliKJ/rhCIj7kjI2T4Wk8kANdezlmCk
         5W1WY4357cn5fVlTtBdnJGA35GL+z+QuoROGM1ngxNnlDXn5U1Ox4WRgLYCQmENQKVgN
         0gXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TLRHeGT8+RAZgeaFPRMZhCfLrpW1DAxjHOSfqTjELLw=;
        b=ZVP9dLmAzaYfFT08fXcf3grJgeLGGcuGEE2/rQeL3cPfsAKcZzlbVAKXGlBkhvglL8
         X1ZHdvL7aK6b6nyu8+DTd9m+VI1yYyGL+CWvPVqK0Pr59J8esQEUZykQW6dwI05DcK/t
         lAFkBhH+aCyppJROGasgEQcy8y7XClgfSieCKK49jz1K2Szw9Bwg5r306aIbaaMOVy1C
         nyIbl0dlkwDrlrTaryhFsqcL0Pkh/Yv1ch8lmrqIDFQdXtx7Q5B8XL+nIEJegviiw+zm
         Nfz2RbwqvhzAir5B0lIIjSl94rpXt2ib1aJhT9OQPbR3ko6enQdTlWIw4sgHxvPuGLjP
         I2jQ==
X-Gm-Message-State: AOAM533zqdidwDPIyDSeBpgs0To3iO9gCLtlwOtmnQp769Lix6HUhOYh
        oGE4Mn/1O1Rs/EuH8Wcl8SBfvVMeTwoLaFYG
X-Google-Smtp-Source: ABdhPJxqjFwV8cVjOOHG1jf7xvGdpcGqEBX+rEXLpzT4YVw+QOHWV2mKqYtMtGYC/LiaXBRszAmT9Q==
X-Received: by 2002:a9d:65d9:: with SMTP id z25mr4068996oth.200.1628782914299;
        Thu, 12 Aug 2021 08:41:54 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w16sm690973oih.19.2021.08.12.08.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 08:41:53 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, hch@infradead.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] bio: add allocation cache abstraction
Date:   Thu, 12 Aug 2021 09:41:46 -0600
Message-Id: <20210812154149.1061502-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210812154149.1061502-1-axboe@kernel.dk>
References: <20210812154149.1061502-1-axboe@kernel.dk>
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
 block/bio.c                | 135 +++++++++++++++++++++++++++++++++----
 include/linux/bio.h        |  13 ++++
 include/linux/blk_types.h  |   1 +
 include/linux/cpuhotplug.h |   1 +
 4 files changed, 136 insertions(+), 14 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 9bf98b877aba..0fa2990018de 100644
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
@@ -618,6 +623,55 @@ void guard_bio_eod(struct bio *bio)
 	bio_truncate(bio, maxsector << 9);
 }
 
+#define ALLOC_CACHE_MAX		512
+#define ALLOC_CACHE_SLACK	 64
+
+static void bio_alloc_cache_prune(struct bio_alloc_cache *cache,
+				  unsigned int nr)
+{
+	unsigned int i = 0;
+	struct bio *bio;
+
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
 /**
  * bio_put - release a reference to a bio
  * @bio:   bio to release reference to
@@ -628,16 +682,23 @@ void guard_bio_eod(struct bio *bio)
  **/
 void bio_put(struct bio *bio)
 {
-	if (!bio_flagged(bio, BIO_REFFED))
-		bio_free(bio);
-	else {
+	if (unlikely(bio_flagged(bio, BIO_REFFED))) {
 		BIO_BUG_ON(!atomic_read(&bio->__bi_cnt));
-
-		/*
-		 * last put frees it
-		 */
 		if (atomic_dec_and_test(&bio->__bi_cnt))
-			bio_free(bio);
+			return;
+	}
+
+	if (bio_flagged(bio, BIO_PERCPU_CACHE)) {
+		struct bio_alloc_cache *cache;
+
+		bio_uninit(bio);
+		cache = per_cpu_ptr(bio->bi_pool->cache, get_cpu());
+		bio_list_add_head(&cache->free_list, bio);
+		if (++cache->nr > ALLOC_CACHE_MAX + ALLOC_CACHE_SLACK)
+			bio_alloc_cache_prune(cache, ALLOC_CACHE_SLACK);
+		put_cpu();
+	} else {
+		bio_free(bio);
 	}
 }
 EXPORT_SYMBOL(bio_put);
@@ -1529,6 +1590,7 @@ int biovec_init_pool(mempool_t *pool, int pool_entries)
  */
 void bioset_exit(struct bio_set *bs)
 {
+	bio_alloc_cache_destroy(bs);
 	if (bs->rescue_workqueue)
 		destroy_workqueue(bs->rescue_workqueue);
 	bs->rescue_workqueue = NULL;
@@ -1590,12 +1652,18 @@ int bioset_init(struct bio_set *bs,
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
@@ -1622,6 +1690,42 @@ int bioset_init_from_src(struct bio_set *bs, struct bio_set *src)
 }
 EXPORT_SYMBOL(bioset_init_from_src);
 
+/**
+ * bio_alloc_kiocb - Allocate a bio from bio_set based on kiocb
+ * @kiocb:	kiocb describing the IO
+ * @bs:		bio_set to allocate from
+ *
+ * Description:
+ *    Like @bio_alloc_bioset, but pass in the kiocb. The kiocb is only
+ *    used to check if we should dip into the per-cpu bio_set allocation
+ *    cache. The allocation uses GFP_KERNEL internally.
+ *
+ */
+struct bio *bio_alloc_kiocb(struct kiocb *kiocb, unsigned short nr_vecs,
+			    struct bio_set *bs)
+{
+	struct bio_alloc_cache *cache;
+	struct bio *bio;
+
+	if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE) || nr_vecs > BIO_INLINE_VECS)
+		return bio_alloc_bioset(GFP_KERNEL, nr_vecs, bs);
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
+	bio = bio_alloc_bioset(GFP_KERNEL, nr_vecs, bs);
+	bio_set_flag(bio, BIO_PERCPU_CACHE);
+	return bio;
+}
+EXPORT_SYMBOL_GPL(bio_alloc_kiocb);
+
 static int __init init_bio(void)
 {
 	int i;
@@ -1636,6 +1740,9 @@ static int __init init_bio(void)
 				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 	}
 
+	cpuhp_setup_state_multi(CPUHP_BIO_DEAD, "block/bio:dead", NULL,
+					bio_cpu_dead);
+
 	if (bioset_init(&fs_bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS))
 		panic("bio: can't allocate bios\n");
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 2203b686e1f0..89ad28213b1d 100644
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
+struct bio *bio_alloc_kiocb(struct kiocb *kiocb, unsigned short nr_vecs,
+		struct bio_set *bs);
 struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned short nr_iovecs);
 extern void bio_put(struct bio *);
 
@@ -699,6 +702,11 @@ struct bio_set {
 	struct kmem_cache *bio_slab;
 	unsigned int front_pad;
 
+	/*
+	 * per-cpu bio alloc cache
+	 */
+	struct bio_alloc_cache __percpu *cache;
+
 	mempool_t bio_pool;
 	mempool_t bvec_pool;
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
@@ -715,6 +723,11 @@ struct bio_set {
 	struct bio_list		rescue_list;
 	struct work_struct	rescue_work;
 	struct workqueue_struct	*rescue_workqueue;
+
+	/*
+	 * Hot un-plug notifier for the per-cpu cache, if used
+	 */
+	struct hlist_node cpuhp_dead;
 };
 
 static inline bool bioset_initialized(struct bio_set *bs)
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

