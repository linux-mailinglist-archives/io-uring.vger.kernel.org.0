Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134E577C677
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 05:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbjHODk7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 23:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbjHODiC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 23:38:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A691FF3
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 20:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=hTIBRejTHMVa47/OsAXgkrlKS1/xzRl/GmhV8qZATSk=; b=n+CmbhnpgxNvlfkTNzd9P2ZaHX
        Cn45PUv3SBi6Yq/3tgjPgZhhAF2R2RadpQ+j8MfyJ+gBK8nKGwkGNhQ686uOAnB/GaaXr+OxhWr/p
        CASKUPLP7CqSS81qN2gJHZahP+7uSiKiEV4IW3JtnHcTDEa4hCgyR7CvAytGlgvXzWDCF3TVZEDZT
        w+BU72BcAA/EyE38WlK6CoB6yKsCJr6xxLzEE0WqV0pzP4I7ls5jzKE9jdghA3qHmXUIzBqX6yoQu
        GEGXj1HYkffhAfBUhFp2clFl6v+eHn7AFzflOwOs2BCJFy6D3/dLnWFXx+28EhmUUUebp0RPGbtkk
        /d4Hpkjw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVkhm-005qaX-Eo; Tue, 15 Aug 2023 03:26:50 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 4/9] mm: Make free_compound_page() static
Date:   Tue, 15 Aug 2023 04:26:40 +0100
Message-Id: <20230815032645.1393700-5-willy@infradead.org>
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

free_compound_page() is the only remaining dynamic destructor.
Call it unconditionally from destroy_large_folio() and convert it
to take a folio.  It used to be the last thing called from
free_transhuge_folio(), and the call from destroy_large_folio()
will take care of that case too.

This was the last entry in the compound_page_dtors array, so delete it
and reword the comments that referred to it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h | 11 +----------
 mm/huge_memory.c   |  1 -
 mm/page_alloc.c    | 23 +++++++----------------
 3 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7fb529dbff31..cf6707a7069e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1267,14 +1267,7 @@ void folio_copy(struct folio *dst, struct folio *src);
 
 unsigned long nr_free_buffer_pages(void);
 
-/*
- * Compound pages have a destructor function.  Provide a
- * prototype for that function and accessor functions.
- * These are _only_ valid on the head of a compound page.
- */
-typedef void compound_page_dtor(struct page *);
-
-/* Keep the enum in sync with compound_page_dtors array in mm/page_alloc.c */
+/* Compound pages may have a special destructor */
 enum compound_dtor_id {
 	NULL_COMPOUND_DTOR,
 	COMPOUND_PAGE_DTOR,
@@ -1325,8 +1318,6 @@ static inline unsigned long thp_size(struct page *page)
 	return PAGE_SIZE << thp_order(page);
 }
 
-void free_compound_page(struct page *page);
-
 #ifdef CONFIG_MMU
 /*
  * Do pte_mkwrite, but only if the vma says VM_WRITE.  We do this when
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 516fe3c26ef3..99e36ad540c4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2797,7 +2797,6 @@ void free_transhuge_folio(struct folio *folio)
 		}
 		spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 	}
-	free_compound_page(&folio->page);
 }
 
 void deferred_split_folio(struct folio *folio)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index feb2e95cf021..804982faba4e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -284,11 +284,6 @@ const char * const migratetype_names[MIGRATE_TYPES] = {
 #endif
 };
 
-static compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS] = {
-	[NULL_COMPOUND_DTOR] = NULL,
-	[COMPOUND_PAGE_DTOR] = free_compound_page,
-};
-
 int min_free_kbytes = 1024;
 int user_min_free_kbytes = -1;
 static int watermark_boost_factor __read_mostly = 15000;
@@ -587,17 +582,17 @@ static inline void free_the_page(struct page *page, unsigned int order)
  * The remaining PAGE_SIZE pages are called "tail pages". PageTail() is encoded
  * in bit 0 of page->compound_head. The rest of bits is pointer to head page.
  *
- * The first tail page's ->compound_dtor holds the offset in array of compound
- * page destructors. See compound_page_dtors.
+ * The first tail page's ->compound_dtor describes how to destroy the
+ * compound page.
  *
  * The first tail page's ->compound_order holds the order of allocation.
  * This usage means that zero-order pages may not be compound.
  */
 
-void free_compound_page(struct page *page)
+static void free_compound_page(struct folio *folio)
 {
-	mem_cgroup_uncharge(page_folio(page));
-	free_the_page(page, compound_order(page));
+	mem_cgroup_uncharge(folio);
+	free_the_page(&folio->page, folio_order(folio));
 }
 
 void prep_compound_page(struct page *page, unsigned int order)
@@ -621,13 +616,9 @@ void destroy_large_folio(struct folio *folio)
 		return;
 	}
 
-	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR) {
+	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR)
 		free_transhuge_folio(folio);
-		return;
-	}
-
-	VM_BUG_ON_FOLIO(dtor >= NR_COMPOUND_DTORS, folio);
-	compound_page_dtors[dtor](&folio->page);
+	free_compound_page(folio);
 }
 
 static inline void set_buddy_order(struct page *page, unsigned int order)
-- 
2.40.1

