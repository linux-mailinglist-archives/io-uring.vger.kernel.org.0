Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117CB77E4C4
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 17:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbjHPPM3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 11:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344065AbjHPPMO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 11:12:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B161268D
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 08:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=uUh5RzdeUjxu8QH/NZha9zu8/cTsRUc2q74yTYqB5GQ=; b=JPOMDJLWRR9qz7iWGg+vxMn6xJ
        YypX9IaF7FCfgzt54snUSOb0G0mYNTkZxZR1mHEDpsnoro/ulTpsXRYroXgEVz45EudlB/HYvkkL9
        cYcalW2OLpHrCKILPx8d82zqIUSPE+eG3iJIqRIjWtzbYcfznWX5/XfJJLABj8G5jertDB7o/D7Al
        nyqt61Lqj5g06bI8l/Idf5H3U0lwPR9QvWC2uOhPxtcRfdADLPTVqa6JB72h5mXNKbAfA71gNR0QP
        y2Ab2a+In1ZiDl6nYWWoWo/A9hQt7mq6b/mnzVNetlu1+K0IdP28y8hTprxQFfm8VeESjFHju3T4y
        zktds10A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qWIBu-00FL8r-QS; Wed, 16 Aug 2023 15:12:10 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v2 11/13] mm: Remove folio_test_transhuge()
Date:   Wed, 16 Aug 2023 16:11:59 +0100
Message-Id: <20230816151201.3655946-12-willy@infradead.org>
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

This function is misleading; people think it means "Is this a THP",
when all it actually does is check whether this is a large folio.
Remove it; the one remaining user should have been checking to see
whether the folio is PMD sized or not.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/page-flags.h | 5 -----
 mm/memcontrol.c            | 2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 5b466e619f71..e3ca17e95bbf 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -853,11 +853,6 @@ static inline int PageTransHuge(struct page *page)
 	return PageHead(page);
 }
 
-static inline bool folio_test_transhuge(struct folio *folio)
-{
-	return folio_test_head(folio);
-}
-
 /*
  * PageTransCompound returns true for both transparent huge pages
  * and hugetlbfs pages, so it should only be called when it's known
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 35d7e66ab032..67bda1ceedbe 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5765,7 +5765,7 @@ static int mem_cgroup_move_account(struct page *page,
 		if (folio_mapped(folio)) {
 			__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
 			__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
-			if (folio_test_transhuge(folio)) {
+			if (folio_test_pmd_mappable(folio)) {
 				__mod_lruvec_state(from_vec, NR_ANON_THPS,
 						   -nr_pages);
 				__mod_lruvec_state(to_vec, NR_ANON_THPS,
-- 
2.40.1

