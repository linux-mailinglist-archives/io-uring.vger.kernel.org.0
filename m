Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A41C77C666
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 05:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbjHODc0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 23:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbjHOD3r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 23:29:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D502B1FF2
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 20:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=3R6E9lJA1fDVHLkeYLU6dejaQkhuWTMTotkeI2cZgmY=; b=r8z4nRTXrUlGt13XLtw/J29M57
        5iYsOyQKNe8VJqfMxhGgwmnIe/R287HhpT++UwKivgqqDadScL+cz1sFbsrfBDQx1g3458ci4PhgF
        AyqC1KGX1VAcEIXgdJddQfARtBt/P3ebW/WGT3S0ssSHOfR1GKjklwZbK3EtyoQLS+kR0WEOzfCWF
        EEGSEJHJkpURJptXSmoen5k0UFL3E5ZM63L/CZDu1Q7cuogfE2xBXKgx/t89+2l2tkmPEjnl6abqq
        xwcxNnoVELc6pqnj+swY5/8Tyr64hTvra/bMZy/pb6i6ZklQVPzlMXgJfbUarjRUjB98cD/EFFfm9
        NDrl8r2g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVkhm-005qah-Vy; Tue, 15 Aug 2023 03:26:51 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 9/9] mm: Free up a word in the first tail page
Date:   Tue, 15 Aug 2023 04:26:45 +0100
Message-Id: <20230815032645.1393700-10-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230815032645.1393700-1-willy@infradead.org>
References: <20230815032645.1393700-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Store the folio order in the low byte of the flags word in the first
tail page.  This frees up the word that was being used to store the
order and dtor bytes previously.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h       | 10 +++++-----
 include/linux/mm_types.h |  3 +--
 kernel/crash_core.c      |  1 -
 mm/internal.h            |  2 +-
 mm/page_alloc.c          |  4 +++-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cf0ae8c51d7f..85568e2b2556 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1028,7 +1028,7 @@ struct inode;
  * compound_order() can be called without holding a reference, which means
  * that niceties like page_folio() don't work.  These callers should be
  * prepared to handle wild return values.  For example, PG_head may be
- * set before _folio_order is initialised, or this may be a tail page.
+ * set before the order is initialised, or this may be a tail page.
  * See compaction.c for some good examples.
  */
 static inline unsigned int compound_order(struct page *page)
@@ -1037,7 +1037,7 @@ static inline unsigned int compound_order(struct page *page)
 
 	if (!test_bit(PG_head, &folio->flags))
 		return 0;
-	return folio->_folio_order;
+	return folio->_flags_1 & 0xff;
 }
 
 /**
@@ -1053,7 +1053,7 @@ static inline unsigned int folio_order(struct folio *folio)
 {
 	if (!folio_test_large(folio))
 		return 0;
-	return folio->_folio_order;
+	return folio->_flags_1 & 0xff;
 }
 
 #include <linux/huge_mm.h>
@@ -2025,7 +2025,7 @@ static inline long folio_nr_pages(struct folio *folio)
 #ifdef CONFIG_64BIT
 	return folio->_folio_nr_pages;
 #else
-	return 1L << folio->_folio_order;
+	return 1L << (folio->_flags_1 & 0xff);
 #endif
 }
 
@@ -2043,7 +2043,7 @@ static inline unsigned long compound_nr(struct page *page)
 #ifdef CONFIG_64BIT
 	return folio->_folio_nr_pages;
 #else
-	return 1L << folio->_folio_order;
+	return 1L << (folio->_flags_1 & 0xff);
 #endif
 }
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d45a2b8041e0..659c7b84726c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -282,7 +282,6 @@ static inline struct page *encoded_page_ptr(struct encoded_page *page)
  * @_refcount: Do not access this member directly.  Use folio_ref_count()
  *    to find how many references there are to this folio.
  * @memcg_data: Memory Control Group data.
- * @_folio_order: Do not use directly, call folio_order().
  * @_entire_mapcount: Do not use directly, call folio_entire_mapcount().
  * @_nr_pages_mapped: Do not use directly, call folio_mapcount().
  * @_pincount: Do not use directly, call folio_maybe_dma_pinned().
@@ -334,8 +333,8 @@ struct folio {
 		struct {
 			unsigned long _flags_1;
 			unsigned long _head_1;
+			unsigned long _folio_avail;
 	/* public: */
-			unsigned char _folio_order;
 			atomic_t _entire_mapcount;
 			atomic_t _nr_pages_mapped;
 			atomic_t _pincount;
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 934dd86e19f5..693445e1f7f6 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -455,7 +455,6 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_OFFSET(page, lru);
 	VMCOREINFO_OFFSET(page, _mapcount);
 	VMCOREINFO_OFFSET(page, private);
-	VMCOREINFO_OFFSET(folio, _folio_order);
 	VMCOREINFO_OFFSET(page, compound_head);
 	VMCOREINFO_OFFSET(pglist_data, node_zones);
 	VMCOREINFO_OFFSET(pglist_data, nr_zones);
diff --git a/mm/internal.h b/mm/internal.h
index e3d11119b04e..c415260c1f06 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -407,7 +407,7 @@ static inline void folio_set_order(struct folio *folio, unsigned int order)
 	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
 		return;
 
-	folio->_folio_order = order;
+	folio->_flags_1 = (folio->_flags_1 & ~0xffUL) | order;
 #ifdef CONFIG_64BIT
 	folio->_folio_nr_pages = 1U << order;
 #endif
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9fe9209605a5..0e0e0d18a81b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1115,8 +1115,10 @@ static __always_inline bool free_pages_prepare(struct page *page,
 
 		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
 
-		if (compound)
+		if (compound) {
 			ClearPageHasHWPoisoned(page);
+			page[1].flags &= ~0xffUL;
+		}
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_page_prepare(page, page + i);
-- 
2.40.1

