Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B938A77C688
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 05:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbjHODx6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 23:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbjHODxJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 23:53:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEE31FEF
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 20:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=AkiwaMX9J2EStw5aS/8SkpjxSTrjAeNOcY6xWBx7phM=; b=umf5Qjlr4TVGgREeM841PEBgao
        U/OYkolNBqfy6XznAkCSwddr8yp9BZo/N9H1CdaqwxN06gvrn6jvEqEPblAuMZ/waLUZPVkZ5q7wx
        OY71tWBf9TI6QkfLbu7dgqNXSXjR5cCPXH9ZMZrrX3Q83VTs2JfbkUELVZd2w5ggZLg/uOH7iCSh7
        2YnG4iRVeFk3+o/A8i46rvMVdmIyfKMXspzjCxKR1/AKExDZARAfxbaXsajqLo8bw0bsZglLNg7re
        Wx2OkHUSPmqEJE+LQBQ3M/ETqVLMRr+AXX3FtZWRR6GV/lEPaWXQBv+151JJoN3WDoLIzN8AfnjbB
        6hPPGVtg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVkhm-005qab-LN; Tue, 15 Aug 2023 03:26:50 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 6/9] mm: Remove HUGETLB_PAGE_DTOR
Date:   Tue, 15 Aug 2023 04:26:42 +0100
Message-Id: <20230815032645.1393700-7-willy@infradead.org>
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

We can use a bit in page[1].flags to indicate that this folio belongs
to hugetlb instead of using a value in page[1].dtors.  That lets
folio_test_hugetlb() become an inline function like it should be.
We can also get rid of NULL_COMPOUND_DTOR.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 .../admin-guide/kdump/vmcoreinfo.rst          | 10 +---
 include/linux/mm.h                            |  2 -
 include/linux/page-flags.h                    | 21 +++++++-
 kernel/crash_core.c                           |  2 +-
 mm/hugetlb.c                                  | 49 +++----------------
 5 files changed, 29 insertions(+), 55 deletions(-)

diff --git a/Documentation/admin-guide/kdump/vmcoreinfo.rst b/Documentation/admin-guide/kdump/vmcoreinfo.rst
index c18d94fa6470..baa1c355741d 100644
--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst
+++ b/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -325,8 +325,8 @@ NR_FREE_PAGES
 On linux-2.6.21 or later, the number of free pages is in
 vm_stat[NR_FREE_PAGES]. Used to get the number of free pages.
 
-PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_slab|PG_hwpoision|PG_head_mask
-------------------------------------------------------------------------------
+PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_slab|PG_hwpoision|PG_head_mask|PG_hugetlb
+-----------------------------------------------------------------------------------------
 
 Page attributes. These flags are used to filter various unnecessary for
 dumping pages.
@@ -338,12 +338,6 @@ More page attributes. These flags are used to filter various unnecessary for
 dumping pages.
 
 
-HUGETLB_PAGE_DTOR
------------------
-
-The HUGETLB_PAGE_DTOR flag denotes hugetlbfs pages. Makedumpfile
-excludes these pages.
-
 x86_64
 ======
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index cf6707a7069e..c8c8b1fd64d3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1269,9 +1269,7 @@ unsigned long nr_free_buffer_pages(void);
 
 /* Compound pages may have a special destructor */
 enum compound_dtor_id {
-	NULL_COMPOUND_DTOR,
 	COMPOUND_PAGE_DTOR,
-	HUGETLB_PAGE_DTOR,
 	TRANSHUGE_PAGE_DTOR,
 	NR_COMPOUND_DTORS
 };
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 92a2063a0a23..01d98695e79f 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -180,6 +180,9 @@ enum pageflags {
 	PG_has_hwpoisoned = PG_error,
 #endif
 
+	/* Is a hugetlb page.  Stored in first tail page. */
+	PG_hugetlb = PG_writeback,
+
 	/* non-lru isolated movable page */
 	PG_isolated = PG_reclaim,
 
@@ -812,7 +815,23 @@ static inline void ClearPageCompound(struct page *page)
 
 #ifdef CONFIG_HUGETLB_PAGE
 int PageHuge(struct page *page);
-bool folio_test_hugetlb(struct folio *folio);
+SETPAGEFLAG(HugeTLB, hugetlb, PF_SECOND)
+CLEARPAGEFLAG(HugeTLB, hugetlb, PF_SECOND)
+
+/**
+ * folio_test_hugetlb - Determine if the folio belongs to hugetlbfs
+ * @folio: The folio to test.
+ *
+ * Context: Any context.  Caller should have a reference on the folio to
+ * prevent it from being turned into a tail page.
+ * Return: True for hugetlbfs folios, false for anon folios or folios
+ * belonging to other filesystems.
+ */
+static inline bool folio_test_hugetlb(struct folio *folio)
+{
+	return folio_test_large(folio) &&
+		test_bit(PG_hugetlb, folio_flags(folio, 1));
+}
 #else
 TESTPAGEFLAG_FALSE(Huge, hugetlb)
 #endif
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 90ce1dfd591c..dd5f87047d06 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -490,7 +490,7 @@ static int __init crash_save_vmcoreinfo_init(void)
 #define PAGE_BUDDY_MAPCOUNT_VALUE	(~PG_buddy)
 	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
 #ifdef CONFIG_HUGETLB_PAGE
-	VMCOREINFO_NUMBER(HUGETLB_PAGE_DTOR);
+	VMCOREINFO_NUMBER(PG_hugetlb);
 #define PAGE_OFFLINE_MAPCOUNT_VALUE	(~PG_offline)
 	VMCOREINFO_NUMBER(PAGE_OFFLINE_MAPCOUNT_VALUE);
 #endif
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bc340f5dbbd4..a1cebcee6503 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1585,25 +1585,7 @@ static inline void __clear_hugetlb_destructor(struct hstate *h,
 {
 	lockdep_assert_held(&hugetlb_lock);
 
-	/*
-	 * Very subtle
-	 *
-	 * For non-gigantic pages set the destructor to the normal compound
-	 * page dtor.  This is needed in case someone takes an additional
-	 * temporary ref to the page, and freeing is delayed until they drop
-	 * their reference.
-	 *
-	 * For gigantic pages set the destructor to the null dtor.  This
-	 * destructor will never be called.  Before freeing the gigantic
-	 * page destroy_compound_gigantic_folio will turn the folio into a
-	 * simple group of pages.  After this the destructor does not
-	 * apply.
-	 *
-	 */
-	if (hstate_is_gigantic(h))
-		folio_set_compound_dtor(folio, NULL_COMPOUND_DTOR);
-	else
-		folio_set_compound_dtor(folio, COMPOUND_PAGE_DTOR);
+	folio_clear_hugetlb(folio);
 }
 
 /*
@@ -1690,7 +1672,7 @@ static void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 		h->surplus_huge_pages_node[nid]++;
 	}
 
-	folio_set_compound_dtor(folio, HUGETLB_PAGE_DTOR);
+	folio_set_hugetlb(folio);
 	folio_change_private(folio, NULL);
 	/*
 	 * We have to set hugetlb_vmemmap_optimized again as above
@@ -1814,9 +1796,8 @@ static void free_hpage_workfn(struct work_struct *work)
 		/*
 		 * The VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio) in
 		 * folio_hstate() is going to trigger because a previous call to
-		 * remove_hugetlb_folio() will call folio_set_compound_dtor
-		 * (folio, NULL_COMPOUND_DTOR), so do not use folio_hstate()
-		 * directly.
+		 * remove_hugetlb_folio() will clear the hugetlb bit, so do
+		 * not use folio_hstate() directly.
 		 */
 		h = size_to_hstate(page_size(page));
 
@@ -1955,7 +1936,7 @@ static void __prep_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 {
 	hugetlb_vmemmap_optimize(h, &folio->page);
 	INIT_LIST_HEAD(&folio->lru);
-	folio_set_compound_dtor(folio, HUGETLB_PAGE_DTOR);
+	folio_set_hugetlb(folio);
 	hugetlb_set_folio_subpool(folio, NULL);
 	set_hugetlb_cgroup(folio, NULL);
 	set_hugetlb_cgroup_rsvd(folio, NULL);
@@ -2070,28 +2051,10 @@ int PageHuge(struct page *page)
 	if (!PageCompound(page))
 		return 0;
 	folio = page_folio(page);
-	return folio->_folio_dtor == HUGETLB_PAGE_DTOR;
+	return folio_test_hugetlb(folio);
 }
 EXPORT_SYMBOL_GPL(PageHuge);
 
-/**
- * folio_test_hugetlb - Determine if the folio belongs to hugetlbfs
- * @folio: The folio to test.
- *
- * Context: Any context.  Caller should have a reference on the folio to
- * prevent it from being turned into a tail page.
- * Return: True for hugetlbfs folios, false for anon folios or folios
- * belonging to other filesystems.
- */
-bool folio_test_hugetlb(struct folio *folio)
-{
-	if (!folio_test_large(folio))
-		return false;
-
-	return folio->_folio_dtor == HUGETLB_PAGE_DTOR;
-}
-EXPORT_SYMBOL_GPL(folio_test_hugetlb);
-
 /*
  * Find and lock address space (mapping) in write mode.
  *
-- 
2.40.1

