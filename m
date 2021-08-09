Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58D23E4E5A
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 23:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhHIVYa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 17:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbhHIVYa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 17:24:30 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B3BC061796
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 14:24:09 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d17so18023193plr.12
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 14:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kwxhg+k9Vp47rFzfroR6CXyf8w3Mx34MsOmSxP+U8Vw=;
        b=o0BxthJJQLcYeaGAWebI8muOYZ65I+IpoOYzcZpo/MWRER4HE8/qhqZUUfAMYmgHV1
         bp2tM82xSlFDLJ2gd2MIX+mZroUQ8T8jPNqOCPycXFqGIvs4SeWHyZd0EaUfWaGHj4iW
         qhFwjiSNMQU31SvnTkBMu5cHgBrbPNkL/jemya27jc6ng5kPBYmkee6GHY05sBuoQJlt
         uNtsnde6QvEs8JhpaM0p2UrKbt5q1lkBlRsR+ah39UmHjWViZhRmPWRpMSQEJrNsAKiX
         RM05khVZT2hmX63vQ4Z72utyySoCzR9j/hAC2MIL4bT8xBpHlJrhCQ3rufhwDr7MzpVo
         f1GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kwxhg+k9Vp47rFzfroR6CXyf8w3Mx34MsOmSxP+U8Vw=;
        b=KE6xqE/7OH48KXOb1m9UCWjEo6zc8GSmY9KtMh5y3WDpDWJS6WlmDBTTXCPgyT1zMx
         Izu748RebAaDVN5ggzaw8Su9p/GloL/8FgKXapa8eb7PvfQuDt5yRrtdPTfQhMnFneqB
         465eTOvRbsecLAFSnBowHe6Q0TpXwWB67pI99N05PNMXDUMef6gUsaj/ScZlS1Jz7TxS
         UlMH+7NkroohmmLCFXh72SicXdaMRhjhcmc46vqk8y+PNGd1g/Ztw7XluG1DsR/zmY4p
         XFyzS4SpF0VPnTE8zbkAfIAIvzVPKB90TTppLJDmGJrWjCQV6+PjlRActnFQxXttiwZQ
         UnTQ==
X-Gm-Message-State: AOAM531JiOqUEz1hYPp4vK1oRnG6nzhv83LoyLkR2hcjDjzVlGuw1LQi
        fIXP3QHHnbuV5MylAwiGyAHmXELcKWjXrKGL
X-Google-Smtp-Source: ABdhPJyo5i6FEVjJLVnBQFVIuF8/3kg3pz2/BPNdtQySqRhvt007jmUZi3VbUEnhJ+Uq74mA3gcIXA==
X-Received: by 2002:a17:902:dcd5:b029:12d:219f:6c04 with SMTP id t21-20020a170902dcd5b029012d219f6c04mr7028661pll.7.1628544248475;
        Mon, 09 Aug 2021 14:24:08 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id m16sm439885pjz.30.2021.08.09.14.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 14:24:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] bio: add allocation cache abstraction
Date:   Mon,  9 Aug 2021 15:23:58 -0600
Message-Id: <20210809212401.19807-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809212401.19807-1-axboe@kernel.dk>
References: <20210809212401.19807-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a set of helpers that can encapsulate bio allocations, reusing them
as needed. Caller must provide the necessary locking, if any is needed.
The primary intended use case is polled IO from io_uring, which will not
need any external locking.

Very simple - keeps a count of bio's in the cache, and maintains a max
of 512 with a slack of 64. If we get above max + slack, we drop slack
number of bio's.

The cache is intended to be per-task, and the user will need to supply
the storage for it. As io_uring will be the only user right now, provide
a hook that returns the cache there. Stub it out as NULL initially.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/bio.c              | 126 +++++++++++++++++++++++++++++++++++----
 include/linux/bio.h      |  24 ++++++--
 include/linux/io_uring.h |   7 +++
 3 files changed, 141 insertions(+), 16 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 1fab762e079b..3bbda1be27be 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -20,6 +20,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/blk-crypto.h>
 #include <linux/xarray.h>
+#include <linux/io_uring.h>
 
 #include <trace/events/block.h>
 #include "blk.h"
@@ -238,6 +239,35 @@ static void bio_free(struct bio *bio)
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
@@ -246,7 +276,7 @@ static void bio_free(struct bio *bio)
 void bio_init(struct bio *bio, struct bio_vec *table,
 	      unsigned short max_vecs)
 {
-	memset(bio, 0, sizeof(*bio));
+	__bio_init(bio);
 	atomic_set(&bio->__bi_remaining, 1);
 	atomic_set(&bio->__bi_cnt, 1);
 
@@ -591,6 +621,19 @@ void guard_bio_eod(struct bio *bio)
 	bio_truncate(bio, maxsector << 9);
 }
 
+static bool __bio_put(struct bio *bio)
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
@@ -601,17 +644,8 @@ void guard_bio_eod(struct bio *bio)
  **/
 void bio_put(struct bio *bio)
 {
-	if (!bio_flagged(bio, BIO_REFFED))
+	if (__bio_put(bio))
 		bio_free(bio);
-	else {
-		BIO_BUG_ON(!atomic_read(&bio->__bi_cnt));
-
-		/*
-		 * last put frees it
-		 */
-		if (atomic_dec_and_test(&bio->__bi_cnt))
-			bio_free(bio);
-	}
 }
 EXPORT_SYMBOL(bio_put);
 
@@ -1595,6 +1629,76 @@ int bioset_init_from_src(struct bio_set *bs, struct bio_set *src)
 }
 EXPORT_SYMBOL(bioset_init_from_src);
 
+void bio_alloc_cache_init(struct bio_alloc_cache *cache)
+{
+	bio_list_init(&cache->free_list);
+	cache->nr = 0;
+}
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
+void bio_alloc_cache_destroy(struct bio_alloc_cache *cache)
+{
+	bio_alloc_cache_prune(cache, -1U);
+}
+
+struct bio *bio_cache_get(gfp_t gfp, unsigned short nr_vecs, struct bio_set *bs)
+{
+	struct bio_alloc_cache *cache = io_uring_bio_cache();
+	struct bio *bio;
+
+	if (!cache || nr_vecs > BIO_INLINE_VECS)
+		return NULL;
+	if (bio_list_empty(&cache->free_list)) {
+alloc:
+		if (bs)
+			return bio_alloc_bioset(gfp, nr_vecs, bs);
+		else
+			return bio_alloc(gfp, nr_vecs);
+	}
+
+	bio = bio_list_peek(&cache->free_list);
+	if (bs && bio->bi_pool != bs)
+		goto alloc;
+	bio_list_del_head(&cache->free_list, bio);
+	cache->nr--;
+	bio_init(bio, nr_vecs ? bio->bi_inline_vecs : NULL, nr_vecs);
+	return bio;
+}
+
+#define ALLOC_CACHE_MAX		512
+#define ALLOC_CACHE_SLACK	 64
+
+void bio_cache_put(struct bio *bio)
+{
+	struct bio_alloc_cache *cache = io_uring_bio_cache();
+
+	if (unlikely(!__bio_put(bio)))
+		return;
+	if (cache) {
+		bio_uninit(bio);
+		bio_list_add_head(&cache->free_list, bio);
+		cache->nr++;
+		if (cache->nr > ALLOC_CACHE_MAX + ALLOC_CACHE_SLACK)
+			bio_alloc_cache_prune(cache, ALLOC_CACHE_SLACK);
+	} else {
+		bio_free(bio);
+	}
+}
+
 static int __init init_bio(void)
 {
 	int i;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 2203b686e1f0..b70c72365fa2 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -652,18 +652,22 @@ static inline struct bio *bio_list_peek(struct bio_list *bl)
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
 
+static inline struct bio *bio_list_pop(struct bio_list *bl)
+{
+	struct bio *bio = bl->head;
+
+	bio_list_del_head(bl, bio);
 	return bio;
 }
 
@@ -676,6 +680,16 @@ static inline struct bio *bio_list_get(struct bio_list *bl)
 	return bio;
 }
 
+struct bio_alloc_cache {
+	struct bio_list		free_list;
+	unsigned int		nr;
+};
+
+void bio_alloc_cache_init(struct bio_alloc_cache *);
+void bio_alloc_cache_destroy(struct bio_alloc_cache *);
+struct bio *bio_cache_get(gfp_t, unsigned short, struct bio_set *bs);
+void bio_cache_put(struct bio *);
+
 /*
  * Increment chain count for the bio. Make sure the CHAIN flag update
  * is visible before the raised count.
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 04b650bcbbe5..2fb53047638e 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -5,6 +5,8 @@
 #include <linux/sched.h>
 #include <linux/xarray.h>
 
+struct bio_alloc_cache;
+
 #if defined(CONFIG_IO_URING)
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(struct files_struct *files);
@@ -40,4 +42,9 @@ static inline void io_uring_free(struct task_struct *tsk)
 }
 #endif
 
+static inline struct bio_alloc_cache *io_uring_bio_cache(void)
+{
+	return NULL;
+}
+
 #endif
-- 
2.32.0

