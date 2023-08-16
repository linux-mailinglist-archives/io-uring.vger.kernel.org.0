Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2BD677E4D4
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 17:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344046AbjHPPNC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 11:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344051AbjHPPMf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 11:12:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D861B211E
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 08:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=fRlSze2Vu2RAUc5LjCjDIqaAj5/iOS1M5mvXvX9PDDw=; b=hqH+Q0gPF+1UpvSSyqUxsFf4I0
        X97/VQIqchvL8dLzAOuQqjV7diMHv6PpA47rTRkvtyc+aaoSTHazv0MbfgJYGZrT6265rX3Za0llG
        kiVcHK9BbDrHW+izGIIVTQ4+l7K/fCH95DwfXshiXgIu5QKRcMPyWm1oOvcgYIYyu07pYV8BzDNSO
        iQ/KCHQ6Gnjqf5TX3PEdpyupPqQh343vZ33oCBxk0E9OhP3TWqNygV/fy1Qbpup4ISwkfaZcbPUYB
        k78xN3790BwfNHze1FN4ZiVhkVuSYlbnaIk0mvwObBBGQi7piqGcmNr63IKJHlObElgumTBnzwrCY
        M1ycGL+Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qWIBu-00FL8g-Kq; Wed, 16 Aug 2023 15:12:10 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v2 09/13] mm: Rearrange page flags
Date:   Wed, 16 Aug 2023 16:11:57 +0100
Message-Id: <20230816151201.3655946-10-willy@infradead.org>
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

Move PG_writeback into bottom byte so that it can use PG_waiters in a
later patch.  Move PG_head into bottom byte as well to match with where
'order' is moving next.  PG_active and PG_workingset move into the second
byte to make room for them.

By putting PG_head in bit 6, we ensure that it is cleared by assigning
the folio order to the bottom byte of the first tail page (since the
order cannot be larger than 63).

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/page-flags.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 732d13c708e7..b452fba9bc71 100644
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
-- 
2.40.1

