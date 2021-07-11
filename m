Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C5F3C3D8A
	for <lists+io-uring@lfdr.de>; Sun, 11 Jul 2021 17:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhGKPNG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Jul 2021 11:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234887AbhGKPNF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Jul 2021 11:13:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB1DC0613DD;
        Sun, 11 Jul 2021 08:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=855AUMnreo1HN0f6x88VXU6uE3rYZIQf/z+jfpkStV8=; b=oVIZqa/cHJZKqXZURbCu4vT/My
        3BjLnO4TkSqsT9gs6iXSZs8ludP41KEhRV5E8IsEhnliSztIFL3IpFtnoF5KLgWKKfArUBzubosmE
        rQN6FVFqnPpMJ0Gugb4rkaj3RbStL+V1/TJ0mQApGauvjMrAquxmHATfaodvJgGXrWNZvJ9WiAsdn
        q2N2nAdWb5ocKFZWL3YUhMKvAdc9wJCjCmKdubSAdWA1/JuiyBzqKMroaxPxefQW/vsiKTLWHbjKB
        otXyUSBk3qGPfV5NMqMT5cszCvX9w4DzRRsJW7zTEOdB7GtuzQhCXOwbyw9cnCcs6WUzArF6RaBjt
        ZU1FuerA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2b5b-00GMAM-0h; Sun, 11 Jul 2021 15:09:54 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        io-uring@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org
Subject: [PATCH 2/2] mm/filemap: Prevent waiting for memory for NOWAIT reads
Date:   Sun, 11 Jul 2021 16:09:27 +0100
Message-Id: <20210711150927.3898403-3-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210711150927.3898403-1-willy@infradead.org>
References: <20210711150927.3898403-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Readahead memory allocations won't block for much today, as they're
already marked as NOFS and NORETRY, but they can still sleep, and
they shouldn't if the read is marked as IOCB_NOWAIT.  Clearing the
DIRECT_RECLAIM flag will prevent sleeping.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/filemap.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index d1458ecf2f51..2be27b686518 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2435,21 +2435,27 @@ static int filemap_create_page(struct file *file,
 
 static int filemap_readahead(struct kiocb *iocb, struct file *file,
 		struct address_space *mapping, struct page *page,
-		pgoff_t last_index)
+		pgoff_t index, pgoff_t last_index)
 {
+	DEFINE_READAHEAD(ractl, file, &file->f_ra, mapping, index);
+
 	if (iocb->ki_flags & IOCB_NOIO)
 		return -EAGAIN;
-	page_cache_async_readahead(mapping, &file->f_ra, file, page,
-			page->index, last_index - page->index);
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		ractl.gfp_flags &= ~__GFP_DIRECT_RECLAIM;
+
+	if (page)
+		page_cache_async_ra(&ractl, page, last_index - index);
+	else
+		page_cache_sync_ra(&ractl, last_index - index);
 	return 0;
 }
 
 static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
 		struct pagevec *pvec)
 {
-	struct file *filp = iocb->ki_filp;
-	struct address_space *mapping = filp->f_mapping;
-	struct file_ra_state *ra = &filp->f_ra;
+	struct file *file = iocb->ki_filp;
+	struct address_space *mapping = file->f_mapping;
 	pgoff_t index = iocb->ki_pos >> PAGE_SHIFT;
 	pgoff_t last_index;
 	struct page *page;
@@ -2462,16 +2468,16 @@ static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
 
 	filemap_get_read_batch(mapping, index, last_index, pvec);
 	if (!pagevec_count(pvec)) {
-		if (iocb->ki_flags & IOCB_NOIO)
-			return -EAGAIN;
-		page_cache_sync_readahead(mapping, ra, filp, index,
-				last_index - index);
+		err = filemap_readahead(iocb, file, mapping, NULL, index,
+					last_index);
+		if (err)
+			return err;
 		filemap_get_read_batch(mapping, index, last_index, pvec);
 	}
 	if (!pagevec_count(pvec)) {
 		if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))
 			return -EAGAIN;
-		err = filemap_create_page(filp, mapping,
+		err = filemap_create_page(file, mapping,
 				iocb->ki_pos >> PAGE_SHIFT, pvec);
 		if (err == AOP_TRUNCATED_PAGE)
 			goto retry;
@@ -2480,7 +2486,8 @@ static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
 
 	page = pvec->pages[pagevec_count(pvec) - 1];
 	if (PageReadahead(page)) {
-		err = filemap_readahead(iocb, filp, mapping, page, last_index);
+		err = filemap_readahead(iocb, file, mapping, page, page->index,
+					last_index);
 		if (err)
 			goto err;
 	}
-- 
2.30.2

