Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DD3296085
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 15:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900531AbgJVN64 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 09:58:56 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:42979 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2443798AbgJVN6z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 09:58:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UCqWeHm_1603375114;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UCqWeHm_1603375114)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 22 Oct 2020 21:58:51 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH RFC] mm: fix the sync buffered read to the old way
Date:   Thu, 22 Oct 2020 21:58:34 +0800
Message-Id: <1603375114-58419-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The commit 324bcf54c449 changed the code path of async buffered reads
to go with the page_cache_sync_readahead() way when readahead is
disabled, meanwhile the sync buffered reads are forced to do IO in the
above way as well, which makes it go to a more complex code path.

Fixes: 324bcf54c449 ("mm: use limited read-ahead to satisfy read")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

Hi Jens,
I see it from the commit 324bcf54c449 ("mm: use limited read-ahead to
satisfy read") that we have forced normal sync buffered reads go with
the page_cache_sync_readahead() when readahead is disabled. I'm not
sure if this is what you expected. Here I changed the sync buffered
reads to go with the old code path(a_ops->readpage()), and tested the
performance of them, the results of IOPS and cpu time are similar. I
need your opinion on this.

 mm/filemap.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index e4101b5bfa82..0b2a0f633c01 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2224,9 +2224,14 @@ ssize_t generic_file_buffered_read(struct kiocb *iocb,
 		if (!page) {
 			if (iocb->ki_flags & IOCB_NOIO)
 				goto would_block;
-			page_cache_sync_readahead(mapping,
-					ra, filp,
-					index, last_index - index);
+			/*
+			 * when readahead is disabled and IOCB_WAITQ isn't set
+			 * we should go with the readpage() way.
+			 */
+			if (ra->ra_pages || (iocb->ki_flags & IOCB_WAITQ))
+				page_cache_sync_readahead(mapping,
+						ra, filp,
+						index, last_index - index);
 			page = find_get_page(mapping, index);
 			if (unlikely(page == NULL))
 				goto no_cached_page;
-- 
1.8.3.1

