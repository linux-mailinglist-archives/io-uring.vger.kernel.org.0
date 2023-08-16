Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDFE77E4CE
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 17:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240774AbjHPPNC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 11:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344041AbjHPPMc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 11:12:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DDE211E
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 08:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=jXAd6te3eevEbVqabkMpBNzRJH0aU7U0+nA6iByh2bk=; b=V4d1z6UWihqSb/dNTj9KkjPJjC
        or7aj4YOKjDW9jwii8ErZHlhHochwR/HSrYKVXI3b1zrI8iUnkC0u+Yr9/rMo1Qi7PhoSTyiOAnt4
        yQgVLhmctuEGzQOEWtSrAtXo4ShPRDQL8SgC8P1r/xp1L2ePmGScEChQM2z2aQdairZLStValuMTd
        Vq0e9Is6O6Duw44HTFIkGHuGTk4im0XJqTI4P8OzNbR6JXuJ/tBfZGw4CUDf4b+XiuaVyyF3LArSy
        znBt2uuXD0y8iQotfzRJPM8f37dXfsx6V34jcQuQ85JZKPCyVEa2vSiWOwzrbXxcXY3ZS9p+vS7Fy
        XSd7dsjw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qWIBt-00FL8P-Uf; Wed, 16 Aug 2023 15:12:09 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org, David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 01/13] io_uring: Stop calling free_compound_page()
Date:   Wed, 16 Aug 2023 16:11:49 +0100
Message-Id: <20230816151201.3655946-2-willy@infradead.org>
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

folio_put() is the standard way to write this, and it's not appreciably
slower.  This is an enabling patch for removing free_compound_page()
entirely.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
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

