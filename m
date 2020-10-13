Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF8728C846
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 07:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732408AbgJMFbU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 01:31:20 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:41788 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726963AbgJMFbU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 01:31:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UBttVd3_1602567077;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UBttVd3_1602567077)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Oct 2020 13:31:18 +0800
Subject: Re: Loophole in async page I/O
To:     Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
        io-uring@vger.kernel.org
Cc:     Johannes Weiner <hannes@cmpxchg.org>
References: <20201012211355.GC20115@casper.infradead.org>
 <14d97ab3-edf7-c72a-51eb-d335e2768b65@kernel.dk>
From:   Hao_Xu <haoxu@linux.alibaba.com>
Message-ID: <61743c36-ff6a-fce6-a3c4-55ec1c3f1cfa@linux.alibaba.com>
Date:   Tue, 13 Oct 2020 13:31:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <14d97ab3-edf7-c72a-51eb-d335e2768b65@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2020/10/13 上午6:08, Jens Axboe 写道:
> On 10/12/20 3:13 PM, Matthew Wilcox wrote:
>> This one's pretty unlikely, but there's a case in buffered reads where
>> an IOCB_WAITQ read can end up sleeping.
>>
>> generic_file_buffered_read():
>>                  page = find_get_page(mapping, index);
>> ...
>>                  if (!PageUptodate(page)) {
>> ...
>>                          if (iocb->ki_flags & IOCB_WAITQ) {
>> ...
>>                                  error = wait_on_page_locked_async(page,
>>                                                                  iocb->ki_waitq);
>> wait_on_page_locked_async():
>>          if (!PageLocked(page))
>>                  return 0;
>> (back to generic_file_buffered_read):
>>                          if (!mapping->a_ops->is_partially_uptodate(page,
>>                                                          offset, iter->count))
>>                                  goto page_not_up_to_date_locked;
>>
>> page_not_up_to_date_locked:
>>                  if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT)) {
>>                          unlock_page(page);
>>                          put_page(page);
>>                          goto would_block;
>>                  }
>> ...
>>                  error = mapping->a_ops->readpage(filp, page);
>> (will unlock page on I/O completion)
>>                  if (!PageUptodate(page)) {
>>                          error = lock_page_killable(page);
>>
>> So if we have IOCB_WAITQ set but IOCB_NOWAIT clear, we'll call ->readpage()
>> and wait for the I/O to complete.  I can't quite figure out if this is
>> intentional -- I think not; if I understand the semantics right, we
>> should be returning -EIOCBQUEUED and punting to an I/O thread to
>> kick off the I/O and wait.
>>
>> I think the right fix is to return -EIOCBQUEUED from
>> wait_on_page_locked_async() if the page isn't locked.  ie this:
>>
>> @@ -1258,7 +1258,7 @@ static int wait_on_page_locked_async(struct page *page,
>>                                       struct wait_page_queue *wait)
>>   {
>>          if (!PageLocked(page))
>> -               return 0;
>> +               return -EIOCBQUEUED;
>>          return __wait_on_page_locked_async(compound_head(page), wait, false);
>>   }
>>   
>> But as I said, I'm not sure what the semantics are supposed to be.
> 
> If NOWAIT isn't set, then the issue attempt is from the helper thread
> already, and IOCB_WAITQ shouldn't be set either (the latter doesn't
> matter for this discussion). So it's totally fine and expected to block
> at that point.
> 
> Hmm actually, I believe that:
> 
> commit c8d317aa1887b40b188ec3aaa6e9e524333caed1
> Author: Hao Xu <haoxu@linux.alibaba.com>
> Date:   Tue Sep 29 20:00:45 2020 +0800
> 
>      io_uring: fix async buffered reads when readahead is disabled
> 
> maybe messed up that case, so we could block off the retry-path. I'll
> take a closer look, looks like that can be the case if read-ahead is
> disabled.
> 
> In general, we can only return -EIOCBQUEUED if the IO has been started
> or is in progress already. That means we can safely rely on being told
> when it's unlocked/done. If we need to block, we should be returning
> -EAGAIN, which would punt to a worker thread.
> 
Hi Jens,
My undertanding of io_uring buffered reads process after the commit 
c8d317aa1887b40b188ec3aaa6e9e524333caed1 has been merged is:
the first io_uring IO try is with IOCB_NOWAIT, the second retry in the 
same context is with IOCB_WAITQ but without IOCB_NOWAIT.
so in Matthew's case, lock_page_async() will be called after calling 
mapping->a_ops->readpage(), So it won't end up sleeping.
Actually this case is what happens when readahead is disabled or somehow 
skipped for reasons like blk_cgroup_congested() returns true. And this 
case is my commit c8d317aa1887b40b188e for.

Regards,
Hao

