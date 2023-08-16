Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9527277E4C9
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 17:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344044AbjHPPMe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 11:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344085AbjHPPMU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 11:12:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED60E1BE8
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 08:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=d5h4S2y+YltKDNvOm19F9OUGylDTy6Ryq5upqyiDXRE=; b=EQoJabietG+7Znr2TPFURSO4A7
        uZUAqir164dW0b3lNiNjAkblxhvr6aLwfoKnF/5yPzhlAmSqXvxgtN4NxRKmOIML40q/srn9/55IB
        wNsWn/UZXDSvHtaUOjAnpfG//AUVKubFNZwGogoJIRfFI7hs2SnE6wxi1YQ6WkW5e/Z31XgaqaYgM
        mIj8i7E7LtwDd6sO3T2S9QoKk1ICA5fkp0CziyAVNAL+/WIN8U2wrswxXXYQqblio8fE9ajmNC0kU
        K0an/POrGoOc0PItpK214vVs9iqSt0e3gw9IoOkrlhS76GH/4NXVOr8sOFlHdSXRJrgjktEbbQAJz
        ve6uvjEA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qWIBu-00FL8c-Ee; Wed, 16 Aug 2023 15:12:10 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v2 07/13] mm: Remove HUGETLB_PAGE_DTOR
Date:   Wed, 16 Aug 2023 16:11:55 +0100
Message-Id: <20230816151201.3655946-8-willy@infradead.org>
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

We can use a bit in page[1].flags to indicate that this folio belongs
to hugetlb instead of using a value in page[1].dtors.  That lets
folio_test_hugetlb() become an inline function like it should be.
We can also get rid of NULL_COMPOUND_DTOR.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 .../admin-guide/kdump/vmcoreinfo.rst          | 10 +---
 include/linux/mm.h                            |  4 --
 include/linux/page-flags.h                    | 43 ++++++++++++----
 kernel/crash_core.c                           |  2 +-
 mm/hugetlb.c                                  | 49 +++----------------
 mm/page_alloc.c                               |  2 +-
 6 files changed, 43 insertions(+), 67 deletions(-)

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
index 7b800d1298dc..642f5fe5860e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1268,11 +1268,7 @@ void folio_copy(struct folio *dst, struct folio *src);
 unsigned long nr_free_buffer_pages(void);
 
 enum compound_dtor_id {
-	NULL_COMPOUND_DTOR,
 	COMPOUND_PAGE_DTOR,
-#ifdef CONFIG_HUGETLB_PAGE
-	HUGETLB_PAGE_DTOR,
-#endif
 	TRANSHUGE_PAGE_DTOR,
 	NR_COMPOUND_DTORS,
 };
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 92a2063a0a23..aeecf0cf1456 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -171,15 +171,6 @@ enum pageflags {
 	/* Remapped by swiotlb-xen. */
 	PG_xen_remapped = PG_owner_priv_1,
 
-#ifdef CONFIG_MEMORY_FAILURE
-	/*
-	 * Compound pages. Stored in first tail page's flags.
-	 * Indicates that at least one subpage is hwpoisoned in the
-	 * THP.
-	 */
-	PG_has_hwpoisoned = PG_error,
-#endif
-
 	/* non-lru isolated movable page */
 	PG_isolated = PG_reclaim,
 
@@ -190,6 +181,15 @@ enum pageflags {
 	/* For self-hosted memmap pages */
 	PG_vmemmap_self_hosted = PG_owner_priv_1,
 #endif
+
+	/*
+	 * Flags only valid for compound pages.  Stored in first tail page's
+	 * flags word.
+	 */
+
+	/* At least one page in this folio has the hwpoison flag set */
+	PG_has_hwpoisoned = PG_error,
+	PG_hugetlb = PG_active,
 };
 
 #define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
@@ -812,7 +812,23 @@ static inline void ClearPageCompound(struct page *page)
 
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
@@ -1040,6 +1056,13 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
 #define PAGE_FLAGS_CHECK_AT_PREP	\
 	((PAGEFLAGS_MASK & ~__PG_HWPOISON) | LRU_GEN_MASK | LRU_REFS_MASK)
 
+/*
+ * Flags stored in the second page of a compound page.  They may overlap
+ * the CHECK_AT_FREE flags above, so need to be cleared.
+ */
+#define PAGE_FLAGS_SECOND						\
+	(1UL << PG_has_hwpoisoned	| 1UL << PG_hugetlb)
+
 #define PAGE_FLAGS_PRIVATE				\
 	(1UL << PG_private | 1UL << PG_private_2)
 /**
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
index 086eb51bf845..389490f100b0 100644
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
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9638fdddf065..f8e276de4fd5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1122,7 +1122,7 @@ static __always_inline bool free_pages_prepare(struct page *page,
 		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
 
 		if (compound)
-			ClearPageHasHWPoisoned(page);
+			page[1].flags &= ~PAGE_FLAGS_SECOND;
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_page_prepare(page, page + i);
-- 
2.40.1

