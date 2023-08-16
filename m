Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6998877E4C2
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 17:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344036AbjHPPM3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 11:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbjHPPMO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 11:12:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E5D1FCE
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 08:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=7hrNLrvBiputkK0Ez5NemxjwUyUDBXLdxg6jqp/GSn4=; b=THK3UzQTMK0YVS/5sddRPJdEQz
        yzCRsqAftx1rcqtnfHPKVKCb1IJCJpqBMVJHvItV3dqPitxX1z+gd850NiqENXc15t6SrL9STeJyS
        7qaBCI3YB4eRNvWq56ASqo6kwwLjxAW9mBqFHN1H7dDhzNBWWr5haIdfIpftOZ2kejf0J32b24CDs
        TrXd0Jf5/37br0+ab4qgGHO87F/Pi3HqL8HzX35v9piXwQlTUJGdsmDyNXuaM+yogo6vFd0LHS2Pn
        f/LBd40mpafoHB5cBIy4ag6iyrH6s8te6miyvm+SFaVIeJICVRp1iJsEuYR4obHQNsAfRwhpYg6J8
        73YEidLw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qWIBu-00FL8R-17; Wed, 16 Aug 2023 15:12:10 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v2 02/13] mm: Call free_huge_page() directly
Date:   Wed, 16 Aug 2023 16:11:50 +0100
Message-Id: <20230816151201.3655946-3-willy@infradead.org>
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

Indirect calls are expensive, thanks to Spectre.  Call free_huge_page()
directly if the folio belongs to hugetlb.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/hugetlb.h | 3 ++-
 mm/page_alloc.c         | 8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 0a393bc02f25..5a1dfaffbd80 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -26,6 +26,8 @@ typedef struct { unsigned long pd; } hugepd_t;
 #define __hugepd(x) ((hugepd_t) { (x) })
 #endif
 
+void free_huge_page(struct page *page);
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
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8fe9ff917850..548c8016190b 100644
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
+		free_huge_page(&folio->page);
+		return;
+	}
+
 	VM_BUG_ON_FOLIO(dtor >= NR_COMPOUND_DTORS, folio);
 	compound_page_dtors[dtor](&folio->page);
 }
-- 
2.40.1

