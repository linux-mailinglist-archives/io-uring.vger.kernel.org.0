Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFFD77E4D2
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 17:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344050AbjHPPNC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 11:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344063AbjHPPMj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 11:12:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BEE26AD
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 08:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=D7lpiBJxqamGLQ0V34zZ/ZLZ7rblS7AEFq4ixwWOreE=; b=crMLMxItw7rkFzvfYZVu83t4Te
        EErKxqDP16qUFf7uP9ThpSWzMpAk73QwaRBYqKAXYTQubX+5E3Sq2BMgKnF5RmcaiK6AX/xdY4LnZ
        xhLstz+32jcyPbBvNfwGSMgYOoYgsp0Osg6KdXs104oIA7LE6v7moPESIr3nqyhbMuXuHg0H2Xqnb
        uZzVb3/HVf0X7almE/N+OpgBN0q7fg8Zioh2duj05S2KTPSXb6WBGqCJ6gQcki0N8BGZkrGkhSH5l
        xnHhek7TNhRZ4yyWFDvgx1pdvC9RW1pGuxmvt5f76xeefIKe9ICQ58dns/blN4zNxh9kxjOzdppYJ
        77YGfSDA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qWIBu-00FL8e-Hi; Wed, 16 Aug 2023 15:12:10 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v2 08/13] mm: Add large_rmappable page flag
Date:   Wed, 16 Aug 2023 16:11:56 +0100
Message-Id: <20230816151201.3655946-9-willy@infradead.org>
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

Stored in the first tail page's flags, this flag replaces the destructor.
That removes the last of the destructors, so remove all references to
folio_dtor and compound_dtor.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 Documentation/admin-guide/kdump/vmcoreinfo.rst |  4 ++--
 include/linux/mm.h                             | 13 -------------
 include/linux/mm_types.h                       |  2 --
 include/linux/page-flags.h                     |  7 ++++++-
 kernel/crash_core.c                            |  1 -
 mm/huge_memory.c                               |  4 ++--
 mm/internal.h                                  |  1 -
 mm/page_alloc.c                                |  7 +------
 8 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/Documentation/admin-guide/kdump/vmcoreinfo.rst b/Documentation/admin-guide/kdump/vmcoreinfo.rst
index baa1c355741d..3bd38ac0e7de 100644
--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst
+++ b/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -141,8 +141,8 @@ nodemask_t
 The size of a nodemask_t type. Used to compute the number of online
 nodes.
 
-(page, flags|_refcount|mapping|lru|_mapcount|private|compound_dtor|compound_order|compound_head)
--------------------------------------------------------------------------------------------------
+(page, flags|_refcount|mapping|lru|_mapcount|private|compound_order|compound_head)
+----------------------------------------------------------------------------------
 
 User-space tools compute their values based on the offset of these
 variables. The variables are used when excluding unnecessary pages.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 642f5fe5860e..cf0ae8c51d7f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1267,19 +1267,6 @@ void folio_copy(struct folio *dst, struct folio *src);
 
 unsigned long nr_free_buffer_pages(void);
 
-enum compound_dtor_id {
-	COMPOUND_PAGE_DTOR,
-	TRANSHUGE_PAGE_DTOR,
-	NR_COMPOUND_DTORS,
-};
-
-static inline void folio_set_compound_dtor(struct folio *folio,
-		enum compound_dtor_id compound_dtor)
-{
-	VM_BUG_ON_FOLIO(compound_dtor >= NR_COMPOUND_DTORS, folio);
-	folio->_folio_dtor = compound_dtor;
-}
-
 void destroy_large_folio(struct folio *folio);
 
 /* Returns the number of bytes in this potentially compound page. */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index da538ff68953..d45a2b8041e0 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -282,7 +282,6 @@ static inline struct page *encoded_page_ptr(struct encoded_page *page)
  * @_refcount: Do not access this member directly.  Use folio_ref_count()
  *    to find how many references there are to this folio.
  * @memcg_data: Memory Control Group data.
- * @_folio_dtor: Which destructor to use for this folio.
  * @_folio_order: Do not use directly, call folio_order().
  * @_entire_mapcount: Do not use directly, call folio_entire_mapcount().
  * @_nr_pages_mapped: Do not use directly, call folio_mapcount().
@@ -336,7 +335,6 @@ struct folio {
 			unsigned long _flags_1;
 			unsigned long _head_1;
 	/* public: */
-			unsigned char _folio_dtor;
 			unsigned char _folio_order;
 			atomic_t _entire_mapcount;
 			atomic_t _nr_pages_mapped;
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index aeecf0cf1456..732d13c708e7 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -190,6 +190,7 @@ enum pageflags {
 	/* At least one page in this folio has the hwpoison flag set */
 	PG_has_hwpoisoned = PG_error,
 	PG_hugetlb = PG_active,
+	PG_large_rmappable = PG_workingset, /* anon or file-backed */
 };
 
 #define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
@@ -806,6 +807,9 @@ static inline void ClearPageCompound(struct page *page)
 	BUG_ON(!PageHead(page));
 	ClearPageHead(page);
 }
+PAGEFLAG(LargeRmappable, large_rmappable, PF_SECOND)
+#else
+TESTPAGEFLAG_FALSE(LargeRmappable, large_rmappable)
 #endif
 
 #define PG_head_mask ((1UL << PG_head))
@@ -1061,7 +1065,8 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
  * the CHECK_AT_FREE flags above, so need to be cleared.
  */
 #define PAGE_FLAGS_SECOND						\
-	(1UL << PG_has_hwpoisoned	| 1UL << PG_hugetlb)
+	(1UL << PG_has_hwpoisoned	| 1UL << PG_hugetlb |		\
+	 1UL << PG_large_rmappable)
 
 #define PAGE_FLAGS_PRIVATE				\
 	(1UL << PG_private | 1UL << PG_private_2)
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index dd5f87047d06..934dd86e19f5 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -455,7 +455,6 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_OFFSET(page, lru);
 	VMCOREINFO_OFFSET(page, _mapcount);
 	VMCOREINFO_OFFSET(page, private);
-	VMCOREINFO_OFFSET(folio, _folio_dtor);
 	VMCOREINFO_OFFSET(folio, _folio_order);
 	VMCOREINFO_OFFSET(page, compound_head);
 	VMCOREINFO_OFFSET(pglist_data, node_zones);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 04664e6918c1..c721f7ec5b6a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -581,7 +581,7 @@ void folio_prep_large_rmappable(struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
 	INIT_LIST_HEAD(&folio->_deferred_list);
-	folio_set_compound_dtor(folio, TRANSHUGE_PAGE_DTOR);
+	folio_set_large_rmappable(folio);
 }
 
 static inline bool is_transparent_hugepage(struct page *page)
@@ -593,7 +593,7 @@ static inline bool is_transparent_hugepage(struct page *page)
 
 	folio = page_folio(page);
 	return is_huge_zero_page(&folio->page) ||
-	       folio->_folio_dtor == TRANSHUGE_PAGE_DTOR;
+		folio_test_large_rmappable(folio);
 }
 
 static unsigned long __thp_get_unmapped_area(struct file *filp,
diff --git a/mm/internal.h b/mm/internal.h
index 1e98c867f0de..9dc7629ffbc9 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -419,7 +419,6 @@ static inline void prep_compound_head(struct page *page, unsigned int order)
 {
 	struct folio *folio = (struct folio *)page;
 
-	folio_set_compound_dtor(folio, COMPOUND_PAGE_DTOR);
 	folio_set_order(folio, order);
 	atomic_set(&folio->_entire_mapcount, -1);
 	atomic_set(&folio->_nr_pages_mapped, 0);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f8e276de4fd5..81b1c7e3a28b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -582,9 +582,6 @@ static inline void free_the_page(struct page *page, unsigned int order)
  * The remaining PAGE_SIZE pages are called "tail pages". PageTail() is encoded
  * in bit 0 of page->compound_head. The rest of bits is pointer to head page.
  *
- * The first tail page's ->compound_dtor describes how to destroy the
- * compound page.
- *
  * The first tail page's ->compound_order holds the order of allocation.
  * This usage means that zero-order pages may not be compound.
  */
@@ -603,14 +600,12 @@ void prep_compound_page(struct page *page, unsigned int order)
 
 void destroy_large_folio(struct folio *folio)
 {
-	enum compound_dtor_id dtor = folio->_folio_dtor;
-
 	if (folio_test_hugetlb(folio)) {
 		free_huge_folio(folio);
 		return;
 	}
 
-	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR)
+	if (folio_test_large_rmappable(folio))
 		folio_undo_large_rmappable(folio);
 
 	mem_cgroup_uncharge(folio);
-- 
2.40.1

