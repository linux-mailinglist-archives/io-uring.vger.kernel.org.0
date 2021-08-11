Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCF93E8BC8
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 10:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhHKI1t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 04:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbhHKI1t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 04:27:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE107C061765;
        Wed, 11 Aug 2021 01:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wubnmL+nApnyzJ217TdFPpi4zHxmgJ+FqhTaq34wnf4=; b=nzLhiP64XdYzHmD2W1WRi47jvU
        1I7Zcf92+r1Zg4p/v09md5CxA2Aupq7I5bz0qGcX8Uq/IOMQiJpMf9UmQZLW3qrnfx5V8ykwLdgmI
        v+LDQa6C1+nLA0Ucibgu2LHxeF9uRf81vOYgcTxS0mFBATY9XlemeVBH0yeIRBVq25rzDkqLg73J1
        Aqf2JfO3Luho7h9JBy7gxcC7RZJ14JBMcWEjEResmZdqr89PPEvIYpVAZ5oXTH/ylX0p718R5BjAP
        Vlj6pRrdoxlUrAU4byw0TPRxznTNTpfw/yDaYbM+1/2s2TJFo37QjYkmkX8bAPSNvlpXRMJJze/0h
        QxIG/eRw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDjZJ-00DA25-Mj; Wed, 11 Aug 2021 08:26:52 +0000
Date:   Wed, 11 Aug 2021 09:26:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCHSET v3 0/5] Enable bio recycling for polled IO
Message-ID: <YROJuSsUX7y236BW@infradead.org>
References: <20210810163728.265939-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810163728.265939-1-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I really don't like all the layering violations in here.  What is the
problem with a simple (optional) percpu cache in the bio_set?  Something
like the completely untested patch below:

diff --git a/block/bio.c b/block/bio.c
index 33160007f4e0..edd4a83b96fa 100644
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
@@ -239,6 +244,35 @@ static void bio_free(struct bio *bio)
 	}
 }
 
+static inline void __bio_init(struct bio *bio)
+{
+	bio->bi_next = NULL;
+	bio->bi_bdev = NULL;
+	bio->bi_opf = 0;
+	bio->bi_flags = bio->bi_ioprio = bio->bi_write_hint = 0;
+	bio->bi_status = 0;
+	bio->bi_iter.bi_sector = 0;
+	bio->bi_iter.bi_size = 0;
+	bio->bi_iter.bi_idx = 0;
+	bio->bi_iter.bi_bvec_done = 0;
+	bio->bi_end_io = NULL;
+	bio->bi_private = NULL;
+#ifdef CONFIG_BLK_CGROUP
+	bio->bi_blkg = NULL;
+	bio->bi_issue.value = 0;
+#ifdef CONFIG_BLK_CGROUP_IOCOST
+	bio->bi_iocost_cost = 0;
+#endif
+#endif
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	bio->bi_crypt_context = NULL;
+#endif
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+	bio->bi_integrity = NULL;
+#endif
+	bio->bi_vcnt = 0;
+}
+
 /*
  * Users of this function have their own bio allocation. Subsequently,
  * they must remember to pair any call to bio_init() with bio_uninit()
@@ -247,7 +281,7 @@ static void bio_free(struct bio *bio)
 void bio_init(struct bio *bio, struct bio_vec *table,
 	      unsigned short max_vecs)
 {
-	memset(bio, 0, sizeof(*bio));
+	__bio_init(bio);
 	atomic_set(&bio->__bi_remaining, 1);
 	atomic_set(&bio->__bi_cnt, 1);
 	bio->bi_cookie = BLK_QC_T_NONE;
@@ -470,6 +504,31 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, unsigned short nr_iovecs,
 }
 EXPORT_SYMBOL(bio_alloc_bioset);
 
+struct bio *bio_alloc_iocb(struct kiocb *iocb, unsigned short nr_vecs,
+			     struct bio_set *bs)
+{
+	struct bio_alloc_cache *cache = NULL;
+	struct bio *bio;
+
+	if (!(iocb->ki_flags & IOCB_HIPRI) ||
+	    !(iocb->ki_flags & IOCB_NOWAIT) ||
+	    nr_vecs > BIO_INLINE_VECS)
+		return bio_alloc_bioset(GFP_KERNEL, nr_vecs, bs);
+
+	cache = per_cpu_ptr(bs->cache, get_cpu());
+	bio = bio_list_pop(&cache->free_list);
+	if (bio) {
+		bio_init(bio, nr_vecs ? bio->bi_inline_vecs : NULL, nr_vecs);
+		cache->nr--;
+	}
+	put_cpu();
+
+	if (!bio)
+		bio = bio_alloc_bioset(GFP_KERNEL, nr_vecs, bs);
+	bio_set_flag(bio, BIO_CACHEABLE);
+	return bio;
+}
+
 /**
  * bio_kmalloc - kmalloc a bio for I/O
  * @gfp_mask:   the GFP_* mask given to the slab allocator
@@ -588,6 +647,46 @@ void guard_bio_eod(struct bio *bio)
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
+#if 0
+// XXX: add a cpu down notifier to call this
+void bio_alloc_cache_destroy(struct bio_alloc_cache *cache)
+{
+	bio_alloc_cache_prune(cache, -1U);
+}
+#endif
+
+static void bio_add_to_cache(struct bio *bio)
+{
+	struct bio_alloc_cache *cache;
+
+	bio_uninit(bio);
+
+	cache = per_cpu_ptr(bio->bi_pool->cache, get_cpu());
+	bio_list_add_head(&cache->free_list, bio);
+	cache->nr++;
+	if (cache->nr > ALLOC_CACHE_MAX + ALLOC_CACHE_SLACK)
+		bio_alloc_cache_prune(cache, ALLOC_CACHE_SLACK);
+	put_cpu();
+}
+
 /**
  * bio_put - release a reference to a bio
  * @bio:   bio to release reference to
@@ -598,17 +697,16 @@ void guard_bio_eod(struct bio *bio)
  **/
 void bio_put(struct bio *bio)
 {
-	if (!bio_flagged(bio, BIO_REFFED))
-		bio_free(bio);
-	else {
+	if (bio_flagged(bio, BIO_REFFED)) {
 		BIO_BUG_ON(!atomic_read(&bio->__bi_cnt));
-
-		/*
-		 * last put frees it
-		 */
-		if (atomic_dec_and_test(&bio->__bi_cnt))
-			bio_free(bio);
+		if (!atomic_dec_and_test(&bio->__bi_cnt))
+			return;
 	}
+
+	if (bio_flagged(bio, BIO_CACHEABLE))
+		bio_add_to_cache(bio);
+	else
+		bio_free(bio);
 }
 EXPORT_SYMBOL(bio_put);
 
@@ -1487,6 +1585,7 @@ int biovec_init_pool(mempool_t *pool, int pool_entries)
  */
 void bioset_exit(struct bio_set *bs)
 {
+	free_percpu(bs->cache);
 	if (bs->rescue_workqueue)
 		destroy_workqueue(bs->rescue_workqueue);
 	bs->rescue_workqueue = NULL;
@@ -1548,12 +1647,18 @@ int bioset_init(struct bio_set *bs,
 	    biovec_init_pool(&bs->bvec_pool, pool_size))
 		goto bad;
 
-	if (!(flags & BIOSET_NEED_RESCUER))
-		return 0;
-
-	bs->rescue_workqueue = alloc_workqueue("bioset", WQ_MEM_RECLAIM, 0);
-	if (!bs->rescue_workqueue)
-		goto bad;
+	if (flags & BIOSET_NEED_RESCUER) {
+		bs->rescue_workqueue = alloc_workqueue("bioset", WQ_MEM_RECLAIM,
+						       0);
+		if (!bs->rescue_workqueue)
+			goto bad;
+	}
+	
+	if (flags & BIOSET_PERCPU_CACHE) {
+		bs->cache = alloc_percpu(struct bio_alloc_cache);
+		if (!bs->cache)
+			goto bad;
+	}
 
 	return 0;
 bad:
@@ -1594,7 +1699,8 @@ static int __init init_bio(void)
 				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 	}
 
-	if (bioset_init(&fs_bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS))
+	if (bioset_init(&fs_bio_set, BIO_POOL_SIZE, 0,
+			BIOSET_NEED_BVECS | BIOSET_PERCPU_CACHE))
 		panic("bio: can't allocate bios\n");
 
 	if (bioset_integrity_create(&fs_bio_set, BIO_POOL_SIZE))
diff --git a/fs/block_dev.c b/fs/block_dev.c
index e95889ff4fba..c67043bfb788 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -376,8 +376,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	    (bdev_logical_block_size(bdev) - 1))
 		return -EINVAL;
 
-	bio = bio_alloc_bioset(GFP_KERNEL, nr_pages, &blkdev_dio_pool);
-
+	bio = bio_alloc_iocb(iocb, nr_pages, &blkdev_dio_pool);
 	dio = container_of(bio, struct blkdev_dio, bio);
 	dio->is_sync = is_sync = is_sync_kiocb(iocb);
 	if (dio->is_sync) {
@@ -452,7 +451,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 		}
 
 		submit_bio(bio);
-		bio = bio_alloc(GFP_KERNEL, nr_pages);
+		bio = bio_alloc_iocb(iocb, nr_pages, &fs_bio_set);
 	}
 
 	if (!(iocb->ki_flags & IOCB_HIPRI))
@@ -497,7 +496,9 @@ blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 
 static __init int blkdev_init(void)
 {
-	return bioset_init(&blkdev_dio_pool, 4, offsetof(struct blkdev_dio, bio), BIOSET_NEED_BVECS);
+	return bioset_init(&blkdev_dio_pool, 4,
+			   offsetof(struct blkdev_dio, bio),
+			   BIOSET_NEED_BVECS | BIOSET_PERCPU_CACHE);
 }
 module_init(blkdev_init);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 35de19f2ae88..69850bfddf18 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -400,6 +400,7 @@ static inline struct bio *bio_next_split(struct bio *bio, int sectors,
 enum {
 	BIOSET_NEED_BVECS = BIT(0),
 	BIOSET_NEED_RESCUER = BIT(1),
+	BIOSET_PERCPU_CACHE = BIT(2),
 };
 extern int bioset_init(struct bio_set *, unsigned int, unsigned int, int flags);
 extern void bioset_exit(struct bio_set *);
@@ -656,7 +657,7 @@ static inline void bio_inc_remaining(struct bio *bio)
 struct bio_set {
 	struct kmem_cache *bio_slab;
 	unsigned int front_pad;
-
+	struct bio_alloc_cache __percpu *cache;
 	mempool_t bio_pool;
 	mempool_t bvec_pool;
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index e3a70dd0470b..7a7d9c6b33ee 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -300,6 +300,7 @@ enum {
 	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_LOCKED,	/* Owns a zoned device zone write lock */
+	BIO_CACHEABLE,		/* can be added to the percpu cache */
 	BIO_FLAG_LAST
 };
 
