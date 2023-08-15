Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2452B77C669
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 05:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbjHODc3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 23:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbjHOD3s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 23:29:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF961FF6
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 20:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=9AFjGPtcNZvRdattiMeM+NhO363S0DBsMAr8j6pNUgk=; b=jaNFDNXx63oA6YktKdyny5R+FA
        RVh5LmTlc1op/Sst8fvW70x9QNRDwuwJOHdIIjJZWUf6guT7CgC+x3iC4VTc0Z5C7ZeV8vywxhRn2
        iQv7KMpfL46Nk/RHw5syw8gNRhvNS9JKOkvCC4s91EKuD+3TD2PM7Lck/sH50znrz4zhJ66K/6xqW
        frQp6MmSz5oZtlGIHcjgVJoS3tN28ZkHgwNnW2HzRzSYdibignJU8xbNbAUpTqqzvPL/2uF4lwhl+
        HhW8C6yHRX3CyVf75d3s/k2AEl+VW5wqASKAdQSwMdsKUrccMFJq47rXEAyQWAHYMWzz3V5pr2xvE
        93mcRMSg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVkhm-005qad-Or; Tue, 15 Aug 2023 03:26:50 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 7/9] mm: Add deferred_list page flag
Date:   Tue, 15 Aug 2023 04:26:43 +0100
Message-Id: <20230815032645.1393700-8-willy@infradead.org>
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

Stored in the first tail page's flags, this flag replaces the destructor.
That removes the last of the destructors, so remove all references to
folio_dtor and compound_dtor.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 Documentation/admin-guide/kdump/vmcoreinfo.rst |  4 ++--
 include/linux/mm.h                             | 14 --------------
 include/linux/mm_types.h                       |  2 --
 include/linux/page-flags.h                     |  6 ++++++
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
index c8c8b1fd64d3..cf0ae8c51d7f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1267,20 +1267,6 @@ void folio_copy(struct folio *dst, struct folio *src);
 
 unsigned long nr_free_buffer_pages(void);
 
-/* Compound pages may have a special destructor */
-enum compound_dtor_id {
-	COMPOUND_PAGE_DTOR,
-	TRANSHUGE_PAGE_DTOR,
-	NR_COMPOUND_DTORS
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
index 01d98695e79f..aabf50dc71a3 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -183,6 +183,9 @@ enum pageflags {
 	/* Is a hugetlb page.  Stored in first tail page. */
 	PG_hugetlb = PG_writeback,
 
+	/* Has a deferred list (may be empty).  First tail page. */
+	PG_deferred_list = PG_reclaim,
+
 	/* non-lru isolated movable page */
 	PG_isolated = PG_reclaim,
 
@@ -809,6 +812,9 @@ static inline void ClearPageCompound(struct page *page)
 	BUG_ON(!PageHead(page));
 	ClearPageHead(page);
 }
+PAGEFLAG(DeferredList, deferred_list, PF_SECOND)
+#else
+TESTPAGEFLAG_FALSE(DeferredList, deferred_list)
 #endif
 
 #define PG_head_mask ((1UL << PG_head))
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
index 99e36ad540c4..3b5db99eb7ac 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -583,7 +583,7 @@ void prep_transhuge_page(struct page *page)
 
 	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
 	INIT_LIST_HEAD(&folio->_deferred_list);
-	folio_set_compound_dtor(folio, TRANSHUGE_PAGE_DTOR);
+	folio_set_deferred_list(folio);
 }
 
 static inline bool is_transparent_hugepage(struct page *page)
@@ -595,7 +595,7 @@ static inline bool is_transparent_hugepage(struct page *page)
 
 	folio = page_folio(page);
 	return is_huge_zero_page(&folio->page) ||
-	       folio->_folio_dtor == TRANSHUGE_PAGE_DTOR;
+		folio_test_deferred_list(folio);
 }
 
 static unsigned long __thp_get_unmapped_area(struct file *filp,
diff --git a/mm/internal.h b/mm/internal.h
index 5a03bc4782a2..e3d11119b04e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -417,7 +417,6 @@ static inline void prep_compound_head(struct page *page, unsigned int order)
 {
 	struct folio *folio = (struct folio *)page;
 
-	folio_set_compound_dtor(folio, COMPOUND_PAGE_DTOR);
 	folio_set_order(folio, order);
 	atomic_set(&folio->_entire_mapcount, -1);
 	atomic_set(&folio->_nr_pages_mapped, 0);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 21af71aea6eb..9fe9209605a5 100644
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
 		free_huge_page(folio);
 		return;
 	}
 
-	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR)
+	if (folio_test_deferred_list(folio))
 		free_transhuge_folio(folio);
 	mem_cgroup_uncharge(folio);
 	free_the_page(&folio->page, folio_order(folio));
-- 
2.40.1

