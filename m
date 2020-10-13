Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8446D28C827
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 07:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732295AbgJMFNv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 01:13:51 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:54986 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729939AbgJMFNv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 01:13:51 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UBuAlRH_1602566028;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UBuAlRH_1602566028)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Oct 2020 13:13:49 +0800
Subject: Re: Loophole in async page I/O
To:     Matthew Wilcox <willy@infradead.org>, io-uring@vger.kernel.org
Cc:     Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>
References: <20201012211355.GC20115@casper.infradead.org>
From:   Hao_Xu <haoxu@linux.alibaba.com>
Message-ID: <6e341fd1-bd2a-7774-5323-41f3a0531295@linux.alibaba.com>
Date:   Tue, 13 Oct 2020 13:13:48 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201012211355.GC20115@casper.infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ÔÚ 2020/10/13 ÉÏÎç5:13, Matthew Wilcox Ð´µÀ:
> This one's pretty unlikely, but there's a case in buffered reads where
> an IOCB_WAITQ read can end up sleeping.
> 
> generic_file_buffered_read():
>                  page = find_get_page(mapping, index);
> ...
>                  if (!PageUptodate(page)) {
> ...
>                          if (iocb->ki_flags & IOCB_WAITQ) {
> ...
>                                  error = wait_on_page_locked_async(page,
>                                                                  iocb->ki_waitq);
> wait_on_page_locked_async():
>          if (!PageLocked(page))
>                  return 0;
> (back to generic_file_buffered_read):
>                          if (!mapping->a_ops->is_partially_uptodate(page,
>                                                          offset, iter->count))
>                                  goto page_not_up_to_date_locked;
> 
> page_not_up_to_date_locked:
>                  if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT)) {
>                          unlock_page(page);
>                          put_page(page);
>                          goto would_block;
>                  }
> ...
>                  error = mapping->a_ops->readpage(filp, page);
> (will unlock page on I/O completion)
>                  if (!PageUptodate(page)) {
>                          error = lock_page_killable(page);
> 
> So if we have IOCB_WAITQ set but IOCB_NOWAIT clear, we'll call ->readpage()
> and wait for the I/O to complete.  I can't quite figure out if this is
> intentional -- I think not; if I understand the semantics right, we
> should be returning -EIOCBQUEUED and punting to an I/O thread to
> kick off the I/O and wait.
> 
> I think the right fix is to return -EIOCBQUEUED from
> wait_on_page_locked_async() if the page isn't locked.  ie this:
> 
> @@ -1258,7 +1258,7 @@ static int wait_on_page_locked_async(struct page *page,
>                                       struct wait_page_queue *wait)
>   {
>          if (!PageLocked(page))
> -               return 0;
> +               return -EIOCBQUEUED;
>          return __wait_on_page_locked_async(compound_head(page), wait, false);
>   }
>   
> But as I said, I'm not sure what the semantics are supposed to be.
> 
Hi Matthew,
which kernel version are you use, I believe I've fixed this case in the 
commit c8d317aa1887b40b188ec3aaa6e9e524333caed1
in this commit, I did the modification:

diff --git a/mm/filemap.c b/mm/filemap.c
index 1aaea26556cc..ea383478fc22 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2267,7 +2267,11 @@ ssize_t generic_file_buffered_read(struct kiocb 
*iocb,
                 }

                 if (!PageUptodate(page)) {
-                       error = lock_page_killable(page);
+                       if (iocb->ki_flags & IOCB_WAITQ)
+                               error = lock_page_async(page, 
iocb->ki_waitq);
+                       else
+                               error = lock_page_killable(page);
+
                         if (unlikely(error))
                                 goto readpage_error;
                         if (!PageUptodate(page)) {

lock_page_killable() won't be called in this case.
