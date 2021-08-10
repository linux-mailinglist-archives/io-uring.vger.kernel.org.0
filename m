Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62953E7D95
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 18:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbhHJQh6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 12:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235901AbhHJQh6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 12:37:58 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65C8C0613D3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 09:37:35 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so6187592pjb.3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 09:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1RA9V7Otxh4nwqoHM1FxmgmC9MK5/ORNFdKMxH+oR/U=;
        b=OO5wlqX82B3SOe9CMR+tYp4e0+G/qDK/NoOH3oDvA+t2PXPPZQaldwxSIWkL7M/4PG
         SWIdNH1YWdOitqF5+fn4eX0kUg5EXx4fdN5kGkmE+hHMuJ6BYzQy86GiqszHsKqcbOjW
         d/NtlveyUfA6aTtfFKlmlPfxpM4tAN9TkKyBlTIyD4ZRdOY81e0xZs8J4dM+dlH/C6EQ
         u1ugW3iB6LLu70IvD/pJtYk07/5OkNyCQh/lBNIjF/lgAETt/+Bl0/ZOqbIuV/3m3Un4
         8wcHsD6aSKQnNC51fuvSJGWqPNHfho5NH/Wn2bp0KibmFQSlOfuZlJdFHIRbSpot3JaE
         QhpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1RA9V7Otxh4nwqoHM1FxmgmC9MK5/ORNFdKMxH+oR/U=;
        b=r2rVVozN6oMcODIc/8Z+cern1HhatsTxlHzewzuiIjRxC3luJtYOjgT53fdp2HTP5W
         +FsDdtYQt10dNk9vcFGcQKnd9CfX9oPLaDQppQu1ptkspo6wrplYgprU6NSpe9LQxnwP
         5zq5MOQyRwxil98dpB5mmndAyY4RkyCL2ZOPm+RZ01I9o9LwcYovgHqUzvwlEdp97XMi
         ie4efFme7hIDCa8wXdCpN1Qln6RMopVh8raFwyzrNnHGaFFPnPFDLs1bc9uIDjUPPAGV
         239pL4fUg6GAQeII1KTfj9MZo7oW3zXWhm1FQUHHfGxt1Ysc0haW2VvFHT4ucufhd1az
         54MA==
X-Gm-Message-State: AOAM531x9rPgze1V7ykyy/s4anthNATEKEhW47EB7J5LVvrdmbFyN/Te
        yeacLOjriMPlccgfyd7n1eGtmhv2pEYYUgFB
X-Google-Smtp-Source: ABdhPJxHEGFaMaF22Z5HCW2H2t3D7mp6MSlHF9fy86Ov0iLlq6iEGORrlkti+etsVz0JrSf5pn8RxA==
X-Received: by 2002:a17:902:ab91:b029:12b:8dae:b1ff with SMTP id f17-20020a170902ab91b029012b8daeb1ffmr464808plr.52.1628613455084;
        Tue, 10 Aug 2021 09:37:35 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id pi14sm3517744pjb.38.2021.08.10.09.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 09:37:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] bio: add allocation cache abstraction
Date:   Tue, 10 Aug 2021 10:37:24 -0600
Message-Id: <20210810163728.265939-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810163728.265939-1-axboe@kernel.dk>
References: <20210810163728.265939-1-axboe@kernel.dk>
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
 block/bio.c         | 123 ++++++++++++++++++++++++++++++++++++++++----
 include/linux/bio.h |  24 +++++++--
 2 files changed, 131 insertions(+), 16 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 1fab762e079b..e3680702aeae 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -238,6 +238,35 @@ static void bio_free(struct bio *bio)
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
@@ -246,7 +275,7 @@ static void bio_free(struct bio *bio)
 void bio_init(struct bio *bio, struct bio_vec *table,
 	      unsigned short max_vecs)
 {
-	memset(bio, 0, sizeof(*bio));
+	__bio_init(bio);
 	atomic_set(&bio->__bi_remaining, 1);
 	atomic_set(&bio->__bi_cnt, 1);
 
@@ -591,6 +620,19 @@ void guard_bio_eod(struct bio *bio)
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
@@ -601,17 +643,8 @@ void guard_bio_eod(struct bio *bio)
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
 
@@ -1595,6 +1628,74 @@ int bioset_init_from_src(struct bio_set *bs, struct bio_set *src)
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
+struct bio *bio_cache_get(struct bio_alloc_cache *cache, gfp_t gfp,
+			  unsigned short nr_vecs, struct bio_set *bs)
+{
+	struct bio *bio;
+
+	if (nr_vecs > BIO_INLINE_VECS)
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
+void bio_cache_put(struct bio_alloc_cache *cache, struct bio *bio)
+{
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
index 2203b686e1f0..c351aa88d137 100644
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
+struct bio *bio_cache_get(struct bio_alloc_cache *, gfp_t, unsigned short, struct bio_set *bs);
+void bio_cache_put(struct bio_alloc_cache *, struct bio *);
+
 /*
  * Increment chain count for the bio. Make sure the CHAIN flag update
  * is visible before the raised count.
-- 
2.32.0

