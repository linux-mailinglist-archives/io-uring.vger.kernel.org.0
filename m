Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13FA77E4D1
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 17:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344051AbjHPPND (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 11:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344067AbjHPPMl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 11:12:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6F726A1
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 08:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Yb8cVNWb8z5GNmNc3FWgSac9oq6EX+gmDVSFMjhGtks=; b=DabP8WdAO3X/gEmJlM460ah4RY
        5isfWex7DWLji7uwdADOemzGwlsRWsIQMHC4OJs3qII+6C+pzAkii5jkI5+sNQ7Vt0hoSFez9k0PO
        b8LcBIQyvaFZLx5mnpFObQHTBhvEgtLZGIjirjnf3w2EcWgrNnBdOKFs3avdMP2ufTZDEFcXpOqO4
        P0atvCgTqJNjlTZDDyQYR5SiAWfcPvkzjy/+fx7gH/GpxMOp4BKAltN5nqQ+e0wLPO0PMhSVmkz1a
        1xc90vXMMST8+NUNZx3ql8WgFHLPTX6sPtnoQoDjsm2Ol0nlErzKVzXU0gjfhsm3h7X1kNR4e2RVx
        Diie69nQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qWIBu-00FL8i-Nc; Wed, 16 Aug 2023 15:12:10 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v2 10/13] mm: Free up a word in the first tail page
Date:   Wed, 16 Aug 2023 16:11:58 +0100
Message-Id: <20230816151201.3655946-11-willy@infradead.org>
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

Store the folio order in the low byte of the flags word in the first
tail page.  This frees up the word that was being used to store the
order and dtor bytes previously.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h         | 10 +++++-----
 include/linux/mm_types.h   |  3 +--
 include/linux/page-flags.h |  7 ++++---
 kernel/crash_core.c        |  1 -
 mm/internal.h              |  2 +-
 5 files changed, 11 insertions(+), 12 deletions(-)

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
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index b452fba9bc71..5b466e619f71 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -184,7 +184,8 @@ enum pageflags {
 
 	/*
 	 * Flags only valid for compound pages.  Stored in first tail page's
-	 * flags word.
+	 * flags word.  Cannot use the first 8 flags or any flag marked as
+	 * PF_ANY.
 	 */
 
 	/* At least one page in this folio has the hwpoison flag set */
@@ -1065,8 +1066,8 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
  * the CHECK_AT_FREE flags above, so need to be cleared.
  */
 #define PAGE_FLAGS_SECOND						\
-	(1UL << PG_has_hwpoisoned	| 1UL << PG_hugetlb |		\
-	 1UL << PG_large_rmappable)
+	(0xffUL /* order */		| 1UL << PG_has_hwpoisoned |	\
+	 1UL << PG_hugetlb		| 1UL << PG_large_rmappable)
 
 #define PAGE_FLAGS_PRIVATE				\
 	(1UL << PG_private | 1UL << PG_private_2)
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
index 9dc7629ffbc9..5c777b6779fa 100644
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
-- 
2.40.1

