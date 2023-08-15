Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF1177C664
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 05:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbjHODcX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 23:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbjHOD3p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 23:29:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7D41FED
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 20:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=f59aeb0mmdHQJI1C4RwzY3Ldg6y1fWJH+3t+QmXVWA0=; b=JGbswiDJ34dDq4gaBq7kG58sIS
        ZFsx9XleJZknvuEtpNq42FfDPlnHuX6TJKg+qKrB9bPr27v53sWti/JJY3r4PKJ0bZg6XW2eRIQ+Q
        Mdz3lE5/xT1YzPMl2rGLC45LWCh7CMhhqc4XE/Z0tkyAwARxFW4BlJJetWxK1o7XDA96tY9wgNqlt
        fJC3fFpbLEm4XMYOsXG3w5i+3DeaIX45zQbQvlUVXb0qInhNW50xMQkZz72aFiy+C1WcUi+rJ9wvN
        uWB4pyQ8mCy6Y5iofpd7VKM0IPNOwIYAaszCRZFEp3heABqH4/zWVq/nij67Ybt462ftX48Hf5zIX
        RlDlHxrw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVkhm-005qaf-Rr; Tue, 15 Aug 2023 03:26:50 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 8/9] mm: Rearrange page flags
Date:   Tue, 15 Aug 2023 04:26:44 +0100
Message-Id: <20230815032645.1393700-9-willy@infradead.org>
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

Move PG_writeback into bottom byte so that it can use PG_waiters in a
later patch.  Move PG_head into bottom byte as well to match with where
'order' is moving next.  PG_active and PG_workingset move into the second
byte to make room for them.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/page-flags.h | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index aabf50dc71a3..6a0dd94b2460 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -99,13 +99,15 @@
  */
 enum pageflags {
 	PG_locked,		/* Page is locked. Don't touch. */
+	PG_writeback,		/* Page is under writeback */
 	PG_referenced,
 	PG_uptodate,
 	PG_dirty,
 	PG_lru,
+	PG_head,		/* Must be in bit 6 */
+	PG_waiters,		/* Page has waiters, check its waitqueue. Must be bit #7 and in the same byte as "PG_locked" */
 	PG_active,
 	PG_workingset,
-	PG_waiters,		/* Page has waiters, check its waitqueue. Must be bit #7 and in the same byte as "PG_locked" */
 	PG_error,
 	PG_slab,
 	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
@@ -113,8 +115,6 @@ enum pageflags {
 	PG_reserved,
 	PG_private,		/* If pagecache, has fs-private data */
 	PG_private_2,		/* If pagecache, has fs aux data */
-	PG_writeback,		/* Page is under writeback */
-	PG_head,		/* A head page */
 	PG_mappedtodisk,	/* Has blocks allocated on-disk */
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_swapbacked,		/* Page is backed by RAM/swap */
@@ -171,21 +171,19 @@ enum pageflags {
 	/* Remapped by swiotlb-xen. */
 	PG_xen_remapped = PG_owner_priv_1,
 
-#ifdef CONFIG_MEMORY_FAILURE
 	/*
-	 * Compound pages. Stored in first tail page's flags.
-	 * Indicates that at least one subpage is hwpoisoned in the
-	 * THP.
+	 * Flags only valid for compound pages.  Stored in first tail page's
+	 * flags word.
 	 */
-	PG_has_hwpoisoned = PG_error,
-#endif
-
-	/* Is a hugetlb page.  Stored in first tail page. */
-	PG_hugetlb = PG_writeback,
 
-	/* Has a deferred list (may be empty).  First tail page. */
+	/* At least one page is hwpoisoned in the folio.  */
+	PG_has_hwpoisoned = PG_error,
+	/* Belongs to hugetlb */
+	PG_hugetlb = PG_active,
+	/* Has a deferred list (does not indicate whether it is active) */
 	PG_deferred_list = PG_reclaim,
 
+
 	/* non-lru isolated movable page */
 	PG_isolated = PG_reclaim,
 
-- 
2.40.1

