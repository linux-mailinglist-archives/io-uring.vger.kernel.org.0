Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CED77E4CA
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 17:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344043AbjHPPMd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 11:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344083AbjHPPMR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 11:12:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F43026A1
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 08:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=TyqYL8l3qs+xOFQuesU5MOYpRgSi95CwYfVSpPbXZWA=; b=ALXkIbksumnsHHzGJk5XV5Da9S
        +oitdX450l78/oEz2xFPniFUnC3jjMneq6gxMiMjPiGnWD5RrW8lA0dXRX17krh+vAgjeLvA9NFMe
        TVLycQ/QXKjgwI1e0b5rYbWoJzCa5W2aguQ6pY7r6tdgz860KetDC9GVekzrv/S0l5LUpQyQosutq
        soHHJBFf6nrX94ciA/Ihavh/nZol+9jPWipjQwVsSp+Oi3kDn7Godj/Lr9TWyC2Po/jrpyBN3TpxP
        25+mO5nUueLwjlQw5XololLzaXq2mzUMOlgp2FWh5o7MkOnbMZOarM5319l6hjR64o7pePb+DAmDc
        u17NN8hA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qWIBu-00FL8V-75; Wed, 16 Aug 2023 15:12:10 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v2 04/13] mm: Convert free_transhuge_folio() to folio_undo_large_rmappable()
Date:   Wed, 16 Aug 2023 16:11:52 +0100
Message-Id: <20230816151201.3655946-5-willy@infradead.org>
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

Indirect calls are expensive, thanks to Spectre.  Test for
TRANSHUGE_PAGE_DTOR and destroy the folio appropriately.  Move the
free_compound_page() call into destroy_large_folio() to simplify later
patches.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/huge_mm.h |  2 --
 include/linux/mm.h      |  2 --
 mm/huge_memory.c        | 22 +++++++++++-----------
 mm/internal.h           |  2 ++
 mm/page_alloc.c         |  9 ++++++---
 5 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 20284387b841..f351c3f9d58b 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -144,8 +144,6 @@ unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 
 void prep_transhuge_page(struct page *page);
-void free_transhuge_page(struct page *page);
-
 bool can_split_folio(struct folio *folio, int *pextra_pins);
 int split_huge_page_to_list(struct page *page, struct list_head *list);
 static inline int split_huge_page(struct page *page)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 19493d6a2bb8..6c338b65b86b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1281,9 +1281,7 @@ enum compound_dtor_id {
 #ifdef CONFIG_HUGETLB_PAGE
 	HUGETLB_PAGE_DTOR,
 #endif
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	TRANSHUGE_PAGE_DTOR,
-#endif
 	NR_COMPOUND_DTORS,
 };
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8480728fa220..9598bbe6c792 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2779,10 +2779,9 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	return ret;
 }
 
-void free_transhuge_page(struct page *page)
+void folio_undo_large_rmappable(struct folio *folio)
 {
-	struct folio *folio = (struct folio *)page;
-	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
+	struct deferred_split *ds_queue;
 	unsigned long flags;
 
 	/*
@@ -2790,15 +2789,16 @@ void free_transhuge_page(struct page *page)
 	 * deferred_list. If folio is not in deferred_list, it's safe
 	 * to check without acquiring the split_queue_lock.
 	 */
-	if (data_race(!list_empty(&folio->_deferred_list))) {
-		spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-		if (!list_empty(&folio->_deferred_list)) {
-			ds_queue->split_queue_len--;
-			list_del(&folio->_deferred_list);
-		}
-		spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	if (data_race(list_empty(&folio->_deferred_list)))
+		return;
+
+	ds_queue = get_deferred_split_queue(folio);
+	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	if (!list_empty(&folio->_deferred_list)) {
+		ds_queue->split_queue_len--;
+		list_del(&folio->_deferred_list);
 	}
-	free_compound_page(page);
+	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 }
 
 void deferred_split_folio(struct folio *folio)
diff --git a/mm/internal.h b/mm/internal.h
index 5a03bc4782a2..1e98c867f0de 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -413,6 +413,8 @@ static inline void folio_set_order(struct folio *folio, unsigned int order)
 #endif
 }
 
+void folio_undo_large_rmappable(struct folio *folio);
+
 static inline void prep_compound_head(struct page *page, unsigned int order)
 {
 	struct folio *folio = (struct folio *)page;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b569fd5562aa..0dbc2ecdefa5 100644
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
@@ -624,6 +621,12 @@ void destroy_large_folio(struct folio *folio)
 		return;
 	}
 
+	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR) {
+		folio_undo_large_rmappable(folio);
+		free_compound_page(&folio->page);
+		return;
+	}
+
 	VM_BUG_ON_FOLIO(dtor >= NR_COMPOUND_DTORS, folio);
 	compound_page_dtors[dtor](&folio->page);
 }
-- 
2.40.1

