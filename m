Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A98377E4C5
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 17:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344037AbjHPPMa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 11:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344069AbjHPPMO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 11:12:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CCE26AA
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 08:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=0vtiyxjxIiaXbIAeymWG2xctwrMSMhwhXh76m1ko6N4=; b=WlknXyZuozWr/mDoG17T9epOii
        ow7iLBULSWgdtKs8v7Xqw+ORWhqJ0TVudIUNaiSUnJv0Le1gaUH4UbGA/egB13UsHJWAd+q3A4+qj
        vfScYM+JAWQKn32132LyvsY+nJnvK3H1IHLzxrxPnQFXx9hdfiq0wvorG0K4efZcBmD4gLVaxkrrV
        zzsjJi1rNKgkFoUi8NdO8FL4R5fp2WVf/vS9zNlRplQqX7HRVNMIZ1mzOGXJluJrSfatef2H99k9w
        nkW0bJujqUFiIrBZW2OBrJRLcN1d7FxXyOeGPDoIbUjp/anNBCDqdizH/GuVm0VUlVzQ4a943byHm
        oj9MbNvg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qWIBv-00FL96-2R; Wed, 16 Aug 2023 15:12:11 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v2 13/13] mm: Convert split_huge_pages_pid() to use a folio
Date:   Wed, 16 Aug 2023 16:12:01 +0100
Message-Id: <20230816151201.3655946-14-willy@infradead.org>
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

Replaces five calls to compound_head with one.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/huge_memory.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c721f7ec5b6a..4ffc78edaf26 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -584,14 +584,11 @@ void folio_prep_large_rmappable(struct folio *folio)
 	folio_set_large_rmappable(folio);
 }
 
-static inline bool is_transparent_hugepage(struct page *page)
+static inline bool is_transparent_hugepage(struct folio *folio)
 {
-	struct folio *folio;
-
-	if (!PageCompound(page))
+	if (!folio_test_large(folio))
 		return false;
 
-	folio = page_folio(page);
 	return is_huge_zero_page(&folio->page) ||
 		folio_test_large_rmappable(folio);
 }
@@ -3015,6 +3012,7 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 	for (addr = vaddr_start; addr < vaddr_end; addr += PAGE_SIZE) {
 		struct vm_area_struct *vma = vma_lookup(mm, addr);
 		struct page *page;
+		struct folio *folio;
 
 		if (!vma)
 			break;
@@ -3031,22 +3029,23 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 		if (IS_ERR_OR_NULL(page))
 			continue;
 
-		if (!is_transparent_hugepage(page))
+		folio = page_folio(page);
+		if (!is_transparent_hugepage(folio))
 			goto next;
 
 		total++;
-		if (!can_split_folio(page_folio(page), NULL))
+		if (!can_split_folio(folio, NULL))
 			goto next;
 
-		if (!trylock_page(page))
+		if (!folio_trylock(folio))
 			goto next;
 
-		if (!split_huge_page(page))
+		if (!split_folio(folio))
 			split++;
 
-		unlock_page(page);
+		folio_unlock(folio);
 next:
-		put_page(page);
+		folio_put(folio);
 		cond_resched();
 	}
 	mmap_read_unlock(mm);
-- 
2.40.1

