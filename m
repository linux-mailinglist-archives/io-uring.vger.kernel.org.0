Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2993C3D88
	for <lists+io-uring@lfdr.de>; Sun, 11 Jul 2021 17:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbhGKPMq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Jul 2021 11:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234859AbhGKPMp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Jul 2021 11:12:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B15C0613DD;
        Sun, 11 Jul 2021 08:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=8GduWunndRkt/zvmZxhBRXnTi7c25FVkVOoI9I1j1WI=; b=Xubiupq9tpL0QEZKdWBAtzT8HN
        AGDBM4xgt21nYmNICM1Nqm1oifADesE2s7aWm2aaHXv6JJ8YBDaK/J65rz9yZUplhcMabKl68AjjT
        ESAyLIohfKYP66suy7Lnbbd/rLbwiVRLgXuzO5AIjcOnN6ETDOX74DD2w4Tr6oSQt3Fqut7t9EPFy
        xyDAfC7+Ck/FH/WXEmn8X2tfSxbrglOlyE4tUcr79adLmnXJXGG3d12Tn8RyDB4DuzoBOZhDeg2HJ
        rkzysDuE+nom2VwDk0cPWyyrDsX0b/L+NzhQc6egsqyFMyvR2a/Df0IJapU6g+XF6yCP9a7CPK/bI
        p6zyYPRA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2b5P-00GMAF-Rm; Sun, 11 Jul 2021 15:09:42 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        io-uring@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org
Subject: [PATCH 1/2] mm/readahead: Add gfp_flags to ractl
Date:   Sun, 11 Jul 2021 16:09:26 +0100
Message-Id: <20210711150927.3898403-2-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210711150927.3898403-1-willy@infradead.org>
References: <20210711150927.3898403-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It is currently possible for an I/O request that specifies IOCB_NOWAIT
to sleep waiting for I/O to complete in order to allocate pages for
readahead.  In order to fix that, we need the caller to be able to
specify the GFP flags to use for memory allocation in the rest of the
readahead path.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h |  3 +++
 mm/readahead.c          | 16 ++++++++--------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ed02aa522263..00abb2b2f158 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -833,11 +833,13 @@ static inline int add_to_page_cache(struct page *page,
  *	  May be NULL if invoked internally by the filesystem.
  * @mapping: Readahead this filesystem object.
  * @ra: File readahead state.  May be NULL.
+ * @gfp_flags: Memory allocation flags to use.
  */
 struct readahead_control {
 	struct file *file;
 	struct address_space *mapping;
 	struct file_ra_state *ra;
+	gfp_t gfp_flags;
 /* private: use the readahead_* accessors instead */
 	pgoff_t _index;
 	unsigned int _nr_pages;
@@ -849,6 +851,7 @@ struct readahead_control {
 		.file = f,						\
 		.mapping = m,						\
 		.ra = r,						\
+		.gfp_flags = readahead_gfp_mask(m),			\
 		._index = i,						\
 	}
 
diff --git a/mm/readahead.c b/mm/readahead.c
index d589f147f4c2..58937d1fe3f7 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -177,7 +177,6 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 	struct address_space *mapping = ractl->mapping;
 	unsigned long index = readahead_index(ractl);
 	LIST_HEAD(page_pool);
-	gfp_t gfp_mask = readahead_gfp_mask(mapping);
 	unsigned long i;
 
 	/*
@@ -212,14 +211,14 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 			continue;
 		}
 
-		page = __page_cache_alloc(gfp_mask);
+		page = __page_cache_alloc(ractl->gfp_flags);
 		if (!page)
 			break;
 		if (mapping->a_ops->readpages) {
 			page->index = index + i;
 			list_add(&page->lru, &page_pool);
 		} else if (add_to_page_cache_lru(page, mapping, index + i,
-					gfp_mask) < 0) {
+					ractl->gfp_flags) < 0) {
 			put_page(page);
 			read_pages(ractl, &page_pool, true);
 			i = ractl->_index + ractl->_nr_pages - index - 1;
@@ -663,7 +662,6 @@ void readahead_expand(struct readahead_control *ractl,
 	struct address_space *mapping = ractl->mapping;
 	struct file_ra_state *ra = ractl->ra;
 	pgoff_t new_index, new_nr_pages;
-	gfp_t gfp_mask = readahead_gfp_mask(mapping);
 
 	new_index = new_start / PAGE_SIZE;
 
@@ -675,10 +673,11 @@ void readahead_expand(struct readahead_control *ractl,
 		if (page && !xa_is_value(page))
 			return; /* Page apparently present */
 
-		page = __page_cache_alloc(gfp_mask);
+		page = __page_cache_alloc(ractl->gfp_flags);
 		if (!page)
 			return;
-		if (add_to_page_cache_lru(page, mapping, index, gfp_mask) < 0) {
+		if (add_to_page_cache_lru(page, mapping, index,
+					  ractl->gfp_flags) < 0) {
 			put_page(page);
 			return;
 		}
@@ -698,10 +697,11 @@ void readahead_expand(struct readahead_control *ractl,
 		if (page && !xa_is_value(page))
 			return; /* Page apparently present */
 
-		page = __page_cache_alloc(gfp_mask);
+		page = __page_cache_alloc(ractl->gfp_flags);
 		if (!page)
 			return;
-		if (add_to_page_cache_lru(page, mapping, index, gfp_mask) < 0) {
+		if (add_to_page_cache_lru(page, mapping, index,
+					  ractl->gfp_flags) < 0) {
 			put_page(page);
 			return;
 		}
-- 
2.30.2

