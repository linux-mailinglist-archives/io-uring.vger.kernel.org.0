Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A84427C857
	for <lists+io-uring@lfdr.de>; Tue, 29 Sep 2020 14:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbgI2MBW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Sep 2020 08:01:22 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:60637 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731686AbgI2MBD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Sep 2020 08:01:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UATygG0_1601380850;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UATygG0_1601380850)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 29 Sep 2020 20:01:00 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Hao Xu <haoxu@linux.alibaba.com>
Subject: [PATCH] io_uring: support async buffered reads when readahead is disabled
Date:   Tue, 29 Sep 2020 20:00:45 +0800
Message-Id: <1601380845-206925-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The async buffered reads feature is not working when readahead is
turned off. There are two things to concern:

- when doing retry in io_read, not only the IOCB_WAITQ flag but also
  the IOCB_NOWAIT flag is still set, which makes it goes to would_block
  phase in generic_file_buffered_read() and then return -EAGAIN. After
  that, the io-wq thread work is queued, and later doing the async
  reads in the old way.

- even if we remove IOCB_NOWAIT when doing retry, the feature is still
  not running properly, since in generic_file_buffered_read() it goes to
  lock_page_killable() after calling mapping->a_ops->readpage() to do
  IO, and thus causing process to sleep.

Fixes: 1a0a7853b901 ("mm: support async buffered reads in generic_file_buffered_read()")
Fixes: 3b2a4439e0ae ("io_uring: get rid of kiocb_wait_page_queue_init()")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 1 +
 mm/filemap.c  | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 556e4a2ead07..e7e8ea58274e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3106,6 +3106,7 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	wait->wait.flags = 0;
 	INIT_LIST_HEAD(&wait->wait.entry);
 	kiocb->ki_flags |= IOCB_WAITQ;
+	kiocb->ki_flags &= ~IOCB_NOWAIT;
 	kiocb->ki_waitq = wait;
 
 	io_get_req_task(req);
diff --git a/mm/filemap.c b/mm/filemap.c
index 1aaea26556cc..ea383478fc22 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2267,7 +2267,11 @@ ssize_t generic_file_buffered_read(struct kiocb *iocb,
 		}
 
 		if (!PageUptodate(page)) {
-			error = lock_page_killable(page);
+			if (iocb->ki_flags & IOCB_WAITQ)
+				error = lock_page_async(page, iocb->ki_waitq);
+			else
+				error = lock_page_killable(page);
+
 			if (unlikely(error))
 				goto readpage_error;
 			if (!PageUptodate(page)) {
-- 
1.8.3.1

