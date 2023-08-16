Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDA677E4C8
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 17:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344045AbjHPPMe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 11:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344087AbjHPPMW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 11:12:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3721BE8
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 08:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=+wksrpuMSy6CV2cZEpXEutvCbbKjfqW/cPXVAdCuyuo=; b=tmVq5saABvN00mJkJdnS+Y3+mY
        qLOyK1ue+l62Dp2ifNrh2b+/xawwxv/Vc392QDMTJldeyilfF+4bpevB+uIuNHCzC5qWUzM8YMrYF
        hEovgk7pX/aC5SKQUicswH5ePEPsk8hamGziReIrC5g4Y84ZVtES8cIk/6jytSqrHrNx3ClAMWV0x
        QHlFrNaO0V2Gyfls4nsXbXTep3O/o9xsQxPaK34Q7oGtuwufcXA7fDDRJRbKu/oWQd75n7FgvMSEg
        HSJWAzzxU1cpzIJXfdemzELk+aZnSDbm7A6rUT8Hh+gJNV5L15ufqFBXIaaBpc+o8e/LuLbFiXxcb
        PTcAKx/w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qWIBu-00FL8a-C0; Wed, 16 Aug 2023 15:12:10 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v2 06/13] mm: Remove free_compound_page() and the compound_page_dtors array
Date:   Wed, 16 Aug 2023 16:11:54 +0100
Message-Id: <20230816151201.3655946-7-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230816151201.3655946-1-willy@infradead.org>
References: <20230816151201.3655946-1-willy@infradead.org>
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

The only remaining destructor is free_compound_page().  Inline it
into destroy_large_folio() and remove the array it used to live in.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h | 10 ----------
 mm/page_alloc.c    | 24 +++++-------------------
 2 files changed, 5 insertions(+), 29 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6c338b65b86b..7b800d1298dc 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1267,14 +1267,6 @@ void folio_copy(struct folio *dst, struct folio *src);
 
 unsigned long nr_free_buffer_pages(void);
 
-/*
- * Compound pages have a destructor function.  Provide a
- * prototype for that function and accessor functions.
- * These are _only_ valid on the head of a compound page.
- */
-typedef void compound_page_dtor(struct page *);
-
-/* Keep the enum in sync with compound_page_dtors array in mm/page_alloc.c */
 enum compound_dtor_id {
 	NULL_COMPOUND_DTOR,
 	COMPOUND_PAGE_DTOR,
@@ -1327,8 +1319,6 @@ static inline unsigned long thp_size(struct page *page)
 	return PAGE_SIZE << thp_order(page);
 }
 
-void free_compound_page(struct page *page);
-
 #ifdef CONFIG_MMU
 /*
  * Do pte_mkwrite, but only if the vma says VM_WRITE.  We do this when
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5ee4dc9318b7..9638fdddf065 100644
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
@@ -587,19 +582,13 @@ static inline void free_the_page(struct page *page, unsigned int order)
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
-{
-	mem_cgroup_uncharge(page_folio(page));
-	free_the_page(page, compound_order(page));
-}
-
 void prep_compound_page(struct page *page, unsigned int order)
 {
 	int i;
@@ -621,14 +610,11 @@ void destroy_large_folio(struct folio *folio)
 		return;
 	}
 
-	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR) {
+	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR)
 		folio_undo_large_rmappable(folio);
-		free_compound_page(&folio->page);
-		return;
-	}
 
-	VM_BUG_ON_FOLIO(dtor >= NR_COMPOUND_DTORS, folio);
-	compound_page_dtors[dtor](&folio->page);
+	mem_cgroup_uncharge(folio);
+	free_the_page(&folio->page, folio_order(folio));
 }
 
 static inline void set_buddy_order(struct page *page, unsigned int order)
-- 
2.40.1

