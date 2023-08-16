Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D7F77E4D0
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 17:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbjHPPNB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 11:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbjHPPMa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 11:12:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85BB1FCE
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 08:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=OqHtlaBwPOyYVd0BxuxqJHAwBK92pIIYqbMfco12ie4=; b=MYS2+QQ+X+fK4cGw3tU2wA2sSl
        MjekAsM3RnYqbnq8S1LtlyrLH4UL8MVTTuK23DRXIG6iQmyAkDDzKxZ5wK85oubGzcJts7DRZeUc4
        Xu0Z//4Im2awNk/ExV2MJjM/NlSvo5zxOeiRqbkSMo8A2qEpkhftSpoemyd9GQMFw3QK1Tu8hbj/U
        Xjy+51WMZI19LNCx/ahY8MOGBcFhMu0wQnzWWM3zW5KOnzcW4JFSSfeRXyPmTFUla6DjF6jWh59E+
        5N8G/u3ZZ4GNZni7vCgFRdeF57he5ZZhXdW+cr8JZUUXSO92jT83PMe1aLz4msy0Ub3awvjg9kR4W
        +3oWGX0w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qWIBu-00FL8X-9l; Wed, 16 Aug 2023 15:12:10 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v2 05/13] mm; Convert prep_transhuge_page() to folio_prep_large_rmappable()
Date:   Wed, 16 Aug 2023 16:11:53 +0100
Message-Id: <20230816151201.3655946-6-willy@infradead.org>
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

Match folio_undo_large_rmappable(), and move the casting from page to
folio into the callers (which they were largely doing anyway).

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/huge_mm.h |  4 ++--
 mm/huge_memory.c        |  4 +---
 mm/khugepaged.c         |  2 +-
 mm/mempolicy.c          | 15 ++++++++-------
 mm/page_alloc.c         |  7 ++++---
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f351c3f9d58b..6d812b8856c8 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -143,7 +143,7 @@ bool hugepage_vma_check(struct vm_area_struct *vma, unsigned long vm_flags,
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 
-void prep_transhuge_page(struct page *page);
+void folio_prep_large_rmappable(struct folio *folio);
 bool can_split_folio(struct folio *folio, int *pextra_pins);
 int split_huge_page_to_list(struct page *page, struct list_head *list);
 static inline int split_huge_page(struct page *page)
@@ -283,7 +283,7 @@ static inline bool hugepage_vma_check(struct vm_area_struct *vma,
 	return false;
 }
 
-static inline void prep_transhuge_page(struct page *page) {}
+static inline void folio_prep_large_rmappable(struct folio *folio) {}
 
 #define transparent_hugepage_flags 0UL
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9598bbe6c792..04664e6918c1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -577,10 +577,8 @@ struct deferred_split *get_deferred_split_queue(struct folio *folio)
 }
 #endif
 
-void prep_transhuge_page(struct page *page)
+void folio_prep_large_rmappable(struct folio *folio)
 {
-	struct folio *folio = (struct folio *)page;
-
 	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
 	INIT_LIST_HEAD(&folio->_deferred_list);
 	folio_set_compound_dtor(folio, TRANSHUGE_PAGE_DTOR);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index bb76a5d454de..a8e0eca2cd1e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -896,7 +896,7 @@ static bool hpage_collapse_alloc_page(struct page **hpage, gfp_t gfp, int node,
 		return false;
 	}
 
-	prep_transhuge_page(*hpage);
+	folio_prep_large_rmappable((struct folio *)*hpage);
 	count_vm_event(THP_COLLAPSE_ALLOC);
 	return true;
 }
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index c53f8beeb507..4afbb67ccf27 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2189,9 +2189,9 @@ struct folio *vma_alloc_folio(gfp_t gfp, int order, struct vm_area_struct *vma,
 		mpol_cond_put(pol);
 		gfp |= __GFP_COMP;
 		page = alloc_page_interleave(gfp, order, nid);
-		if (page && order > 1)
-			prep_transhuge_page(page);
 		folio = (struct folio *)page;
+		if (folio && order > 1)
+			folio_prep_large_rmappable(folio);
 		goto out;
 	}
 
@@ -2202,9 +2202,9 @@ struct folio *vma_alloc_folio(gfp_t gfp, int order, struct vm_area_struct *vma,
 		gfp |= __GFP_COMP;
 		page = alloc_pages_preferred_many(gfp, order, node, pol);
 		mpol_cond_put(pol);
-		if (page && order > 1)
-			prep_transhuge_page(page);
 		folio = (struct folio *)page;
+		if (folio && order > 1)
+			folio_prep_large_rmappable(folio);
 		goto out;
 	}
 
@@ -2300,10 +2300,11 @@ EXPORT_SYMBOL(alloc_pages);
 struct folio *folio_alloc(gfp_t gfp, unsigned order)
 {
 	struct page *page = alloc_pages(gfp | __GFP_COMP, order);
+	struct folio *folio = (struct folio *)page;
 
-	if (page && order > 1)
-		prep_transhuge_page(page);
-	return (struct folio *)page;
+	if (folio && order > 1)
+		folio_prep_large_rmappable(folio);
+	return folio;
 }
 EXPORT_SYMBOL(folio_alloc);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0dbc2ecdefa5..5ee4dc9318b7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4548,10 +4548,11 @@ struct folio *__folio_alloc(gfp_t gfp, unsigned int order, int preferred_nid,
 {
 	struct page *page = __alloc_pages(gfp | __GFP_COMP, order,
 			preferred_nid, nodemask);
+	struct folio *folio = (struct folio *)page;
 
-	if (page && order > 1)
-		prep_transhuge_page(page);
-	return (struct folio *)page;
+	if (folio && order > 1)
+		folio_prep_large_rmappable(folio);
+	return folio;
 }
 EXPORT_SYMBOL(__folio_alloc);
 
-- 
2.40.1

