Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E424477C667
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 05:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbjHODcU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 23:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbjHOD3n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 23:29:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB5B1FEB
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 20:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=uE1o3xYTfNoT/OXe1q8MbroOJ3TtLR0fpcc8smSdFiQ=; b=vFZnTKXSmWpfKeIh2BcvGDa7T3
        HsNqT/kyBENsHsnvkcr+2U5F4CV6/WHN4UBv9jaDxFO7aaTEbBqJnkXv8nLS9xR/wQf1L2jpaS3/8
        bz6mdqZ6LwPyTRb8PyuYWf/EOkpnsd3AFC0iaq9T9t23WbjukvSDJACX/xrjl3CnP1sgIfzl7hkVe
        J4deXtWhnatjTXkkMLTrxZg5ZHHanaI8y9PNwt142O/LmcypHAHfrDRH2ADYu2OErqmm6Md1++gXP
        bL13ExJQlZs1MWyz5PcNN3ggmfVNs4fw56j+MynJKpFh/3wte4odcC3GpWQBdFrbHhlXGH75gK6mH
        pCwRfLaw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVkhm-005qaT-8c; Tue, 15 Aug 2023 03:26:50 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 2/9] mm: Call the hugetlb destructor directly
Date:   Tue, 15 Aug 2023 04:26:38 +0100
Message-Id: <20230815032645.1393700-3-willy@infradead.org>
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

Indirect calls are expensive, thanks to Spectre.  Convert this one to
a direct call, and pass a folio instead of the head page to save a few
more instructions.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/hugetlb.h |  3 ++-
 include/linux/mm.h      |  6 +-----
 mm/hugetlb.c            | 26 ++++++++++++--------------
 mm/page_alloc.c         |  8 +++++---
 4 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 0a393bc02f25..9555859537a3 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -26,6 +26,8 @@ typedef struct { unsigned long pd; } hugepd_t;
 #define __hugepd(x) ((hugepd_t) { (x) })
 #endif
 
+void free_huge_page(struct folio *folio);
+
 #ifdef CONFIG_HUGETLB_PAGE
 
 #include <linux/mempolicy.h>
@@ -165,7 +167,6 @@ int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				bool *migratable_cleared);
 void folio_putback_active_hugetlb(struct folio *folio);
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
-void free_huge_page(struct page *page);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
 u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 19493d6a2bb8..7fb529dbff31 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1278,13 +1278,9 @@ typedef void compound_page_dtor(struct page *);
 enum compound_dtor_id {
 	NULL_COMPOUND_DTOR,
 	COMPOUND_PAGE_DTOR,
-#ifdef CONFIG_HUGETLB_PAGE
 	HUGETLB_PAGE_DTOR,
-#endif
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	TRANSHUGE_PAGE_DTOR,
-#endif
-	NR_COMPOUND_DTORS,
+	NR_COMPOUND_DTORS
 };
 
 static inline void folio_set_compound_dtor(struct folio *folio,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e327a5a7602c..bc340f5dbbd4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1875,13 +1875,12 @@ struct hstate *size_to_hstate(unsigned long size)
 	return NULL;
 }
 
-void free_huge_page(struct page *page)
+void free_huge_page(struct folio *folio)
 {
 	/*
 	 * Can't pass hstate in here because it is called from the
 	 * compound page destructor.
 	 */
-	struct folio *folio = page_folio(page);
 	struct hstate *h = folio_hstate(folio);
 	int nid = folio_nid(folio);
 	struct hugepage_subpool *spool = hugetlb_folio_subpool(folio);
@@ -1936,7 +1935,7 @@ void free_huge_page(struct page *page)
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
 	} else {
-		arch_clear_hugepage_flags(page);
+		arch_clear_hugepage_flags(&folio->page);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 	}
@@ -2246,7 +2245,7 @@ static int alloc_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed,
 		folio = alloc_fresh_hugetlb_folio(h, gfp_mask, node,
 					nodes_allowed, node_alloc_noretry);
 		if (folio) {
-			free_huge_page(&folio->page); /* free it into the hugepage allocator */
+			free_huge_page(folio); /* free it into the hugepage allocator */
 			return 1;
 		}
 	}
@@ -2435,7 +2434,7 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
 		folio_set_hugetlb_temporary(folio);
 		spin_unlock_irq(&hugetlb_lock);
-		free_huge_page(&folio->page);
+		free_huge_page(folio);
 		return NULL;
 	}
 
@@ -2547,8 +2546,7 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 	__must_hold(&hugetlb_lock)
 {
 	LIST_HEAD(surplus_list);
-	struct folio *folio;
-	struct page *page, *tmp;
+	struct folio *folio, *tmp;
 	int ret;
 	long i;
 	long needed, allocated;
@@ -2608,11 +2606,11 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 	ret = 0;
 
 	/* Free the needed pages to the hugetlb pool */
-	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
+	list_for_each_entry_safe(folio, tmp, &surplus_list, lru) {
 		if ((--needed) < 0)
 			break;
 		/* Add the page to the hugetlb allocator */
-		enqueue_hugetlb_folio(h, page_folio(page));
+		enqueue_hugetlb_folio(h, folio);
 	}
 free:
 	spin_unlock_irq(&hugetlb_lock);
@@ -2621,8 +2619,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 	 * Free unnecessary surplus pages to the buddy allocator.
 	 * Pages have no ref count, call free_huge_page directly.
 	 */
-	list_for_each_entry_safe(page, tmp, &surplus_list, lru)
-		free_huge_page(page);
+	list_for_each_entry_safe(folio, tmp, &surplus_list, lru)
+		free_huge_page(folio);
 	spin_lock_irq(&hugetlb_lock);
 
 	return ret;
@@ -3232,7 +3230,7 @@ static void __init gather_bootmem_prealloc(void)
 		if (prep_compound_gigantic_folio(folio, huge_page_order(h))) {
 			WARN_ON(folio_test_reserved(folio));
 			prep_new_hugetlb_folio(h, folio, folio_nid(folio));
-			free_huge_page(page); /* add to the hugepage allocator */
+			free_huge_page(folio); /* add to the hugepage allocator */
 		} else {
 			/* VERY unlikely inflated ref count on a tail page */
 			free_gigantic_folio(folio, huge_page_order(h));
@@ -3264,7 +3262,7 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 					&node_states[N_MEMORY], NULL);
 			if (!folio)
 				break;
-			free_huge_page(&folio->page); /* free it into the hugepage allocator */
+			free_huge_page(folio); /* free it into the hugepage allocator */
 		}
 		cond_resched();
 	}
@@ -3658,7 +3656,7 @@ static int demote_free_hugetlb_folio(struct hstate *h, struct folio *folio)
 			prep_compound_page(subpage, target_hstate->order);
 		folio_change_private(inner_folio, NULL);
 		prep_new_hugetlb_folio(target_hstate, inner_folio, nid);
-		free_huge_page(subpage);
+		free_huge_page(inner_folio);
 	}
 	mutex_unlock(&target_hstate->resize_lock);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8fe9ff917850..1f67d4968590 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -287,9 +287,6 @@ const char * const migratetype_names[MIGRATE_TYPES] = {
 static compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS] = {
 	[NULL_COMPOUND_DTOR] = NULL,
 	[COMPOUND_PAGE_DTOR] = free_compound_page,
-#ifdef CONFIG_HUGETLB_PAGE
-	[HUGETLB_PAGE_DTOR] = free_huge_page,
-#endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	[TRANSHUGE_PAGE_DTOR] = free_transhuge_page,
 #endif
@@ -622,6 +619,11 @@ void destroy_large_folio(struct folio *folio)
 {
 	enum compound_dtor_id dtor = folio->_folio_dtor;
 
+	if (folio_test_hugetlb(folio)) {
+		free_huge_page(folio);
+		return;
+	}
+
 	VM_BUG_ON_FOLIO(dtor >= NR_COMPOUND_DTORS, folio);
 	compound_page_dtors[dtor](&folio->page);
 }
-- 
2.40.1

