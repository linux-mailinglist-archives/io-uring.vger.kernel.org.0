Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A2477C663
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 05:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbjHODcc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 23:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234459AbjHOD3q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 23:29:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87A51FF0
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 20:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=LklJPoQHz5gx0kkx3SxtlRYJZMYAdukfOsnGQ5XVKy4=; b=GU31PFG+QORyW43Si703UzIVka
        mjKR/IuX+RvLygPYzwjw6rTHsyBo9ofDiCRQAP+DqpvYkUBes1SHvpYqwhbc1EQWayzS+9R+57E5d
        sX8G9JDumR6p4MmIoYneqnekW9XCf1UnRVlhXS4NIu5luZeraaL005PAFQh+BDLrisg6Wgb6BeBOR
        oQsB1Euafhr7n49QZ+PAcpaAHYUqxE0bdhrJ6xrZxezyUmxbTKaErzLHGhuSWf6FsI3CTeLKAQHNz
        VivihZYRv6iRluHL6MI0fPb3p7DMD2x+GnoI18HsrNBbK+CzxYG/tXYkPRzpMQR5tPMNPxGWoK8EZ
        +mMRKj9g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVkhm-005qaR-5N; Tue, 15 Aug 2023 03:26:50 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 1/9] io_uring: Stop calling free_compound_page()
Date:   Tue, 15 Aug 2023 04:26:37 +0100
Message-Id: <20230815032645.1393700-2-willy@infradead.org>
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

folio_put() is the standard way to write this, and it's not
appreciably slower.  This is an enabling patch for removing
free_compound_page() entirely.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 io_uring/io_uring.c | 6 +-----
 io_uring/kbuf.c     | 6 +-----
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index dcf5fc7d2820..a5b9b5de7aff 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2664,14 +2664,10 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 static void io_mem_free(void *ptr)
 {
-	struct page *page;
-
 	if (!ptr)
 		return;
 
-	page = virt_to_head_page(ptr);
-	if (put_page_testzero(page))
-		free_compound_page(page);
+	folio_put(virt_to_folio(ptr));
 }
 
 static void io_pages_free(struct page ***pages, int npages)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 2f0181521c98..556f4df25b0f 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -218,11 +218,7 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	if (bl->is_mapped) {
 		i = bl->buf_ring->tail - bl->head;
 		if (bl->is_mmap) {
-			struct page *page;
-
-			page = virt_to_head_page(bl->buf_ring);
-			if (put_page_testzero(page))
-				free_compound_page(page);
+			folio_put(virt_to_folio(bl->buf_ring));
 			bl->buf_ring = NULL;
 			bl->is_mmap = 0;
 		} else if (bl->buf_nr_pages) {
-- 
2.40.1

