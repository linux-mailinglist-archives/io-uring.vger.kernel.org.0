Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEE377C65F
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 05:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbjHODbr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 23:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234355AbjHOD3m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 23:29:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D945119B3
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 20:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=6nmvblvWXlPo+vgOoHsa5fU8BOXGI6xh6C5MkcfJnu8=; b=uE35NeTccLrzc2mwOmGSkD+XiV
        ESkGD0Ap1IZcCKQLYz2mTohMvFcEgsxpgxjLqQijm+MiUs6O6t7Dz++YKZkO3zCN7DTLYymhVBzlX
        la2f/xf12C6Qt9sP+kQfLCltasZurSSVUNT1xG5G5F2UoOvFnT+r6oLLZWJLecXHqObYfP/Kvof4C
        3zs5KJ8MNCBF5v71mHMxn6VsbQ6yXBdnz0qlhhTTrszc51EGcix058lyUYtVmuJbPpafczORHF1Eq
        wqVEcqU6W7SzXOix8V82PlEbXhBLU2HLDZfMotkCC4B/GPpb3cRUm35GNx2nkcu+xrfJ3KO68dPB9
        s2EKOwhA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVkhm-005qaV-Bq; Tue, 15 Aug 2023 03:26:50 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 3/9] mm: Call free_transhuge_folio() directly from destroy_large_folio()
Date:   Tue, 15 Aug 2023 04:26:39 +0100
Message-Id: <20230815032645.1393700-4-willy@infradead.org>
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
a direct call, and pass a folio instead of the head page for type safety.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/huge_mm.h | 2 +-
 mm/huge_memory.c        | 5 ++---
 mm/page_alloc.c         | 8 +++++---
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 20284387b841..24aee49a581a 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -144,7 +144,7 @@ unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 
 void prep_transhuge_page(struct page *page);
-void free_transhuge_page(struct page *page);
+void free_transhuge_folio(struct folio *folio);
 
 bool can_split_folio(struct folio *folio, int *pextra_pins);
 int split_huge_page_to_list(struct page *page, struct list_head *list);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8480728fa220..516fe3c26ef3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2779,9 +2779,8 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	return ret;
 }
 
-void free_transhuge_page(struct page *page)
+void free_transhuge_folio(struct folio *folio)
 {
-	struct folio *folio = (struct folio *)page;
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 	unsigned long flags;
 
@@ -2798,7 +2797,7 @@ void free_transhuge_page(struct page *page)
 		}
 		spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 	}
-	free_compound_page(page);
+	free_compound_page(&folio->page);
 }
 
 void deferred_split_folio(struct folio *folio)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1f67d4968590..feb2e95cf021 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -287,9 +287,6 @@ const char * const migratetype_names[MIGRATE_TYPES] = {
 static compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS] = {
 	[NULL_COMPOUND_DTOR] = NULL,
 	[COMPOUND_PAGE_DTOR] = free_compound_page,
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	[TRANSHUGE_PAGE_DTOR] = free_transhuge_page,
-#endif
 };
 
 int min_free_kbytes = 1024;
@@ -624,6 +621,11 @@ void destroy_large_folio(struct folio *folio)
 		return;
 	}
 
+	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR) {
+		free_transhuge_folio(folio);
+		return;
+	}
+
 	VM_BUG_ON_FOLIO(dtor >= NR_COMPOUND_DTORS, folio);
 	compound_page_dtors[dtor](&folio->page);
 }
-- 
2.40.1

