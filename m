Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7E728D500
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 21:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgJMT53 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 15:57:29 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:37861 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726848AbgJMT53 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 15:57:29 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UBxxpSw_1602619045;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UBxxpSw_1602619045)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 14 Oct 2020 03:57:26 +0800
Subject: Re: Loophole in async page I/O
To:     Matthew Wilcox <willy@infradead.org>
Cc:     io-uring@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Jens Axboe <axboe@kernel.dk>
References: <20201012211355.GC20115@casper.infradead.org>
 <6e341fd1-bd2a-7774-5323-41f3a0531295@linux.alibaba.com>
 <20201013120119.GD20115@casper.infradead.org>
From:   Hao_Xu <haoxu@linux.alibaba.com>
Message-ID: <34097eb9-c517-6ddb-1765-433e7d5083ed@linux.alibaba.com>
Date:   Wed, 14 Oct 2020 03:57:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201013120119.GD20115@casper.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2020/10/13 下午8:01, Matthew Wilcox 写道:
> On Tue, Oct 13, 2020 at 01:13:48PM +0800, Hao_Xu wrote:
>> 在 2020/10/13 上午5:13, Matthew Wilcox 写道:
>>> This one's pretty unlikely, but there's a case in buffered reads where
>>> an IOCB_WAITQ read can end up sleeping.
>>>
>>> generic_file_buffered_read():
>>>                   page = find_get_page(mapping, index);
>>> ...
>>>                   if (!PageUptodate(page)) {
>>> ...
>>>                           if (iocb->ki_flags & IOCB_WAITQ) {
>>> ...
>>>                                   error = wait_on_page_locked_async(page,
>>>                                                                   iocb->ki_waitq);
>>> wait_on_page_locked_async():
>>>           if (!PageLocked(page))
>>>                   return 0;
>>> (back to generic_file_buffered_read):
>>>                           if (!mapping->a_ops->is_partially_uptodate(page,
>>>                                                           offset, iter->count))
>>>                                   goto page_not_up_to_date_locked;
>>>
>>> page_not_up_to_date_locked:
>>>                   if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT)) {
>>>                           unlock_page(page);
>>>                           put_page(page);
>>>                           goto would_block;
>>>                   }
>>> ...
>>>                   error = mapping->a_ops->readpage(filp, page);
>>> (will unlock page on I/O completion)
>>>                   if (!PageUptodate(page)) {
>>>                           error = lock_page_killable(page);
>>>
>>> So if we have IOCB_WAITQ set but IOCB_NOWAIT clear, we'll call ->readpage()
>>> and wait for the I/O to complete.  I can't quite figure out if this is
>>> intentional -- I think not; if I understand the semantics right, we
>>> should be returning -EIOCBQUEUED and punting to an I/O thread to
>>> kick off the I/O and wait.
>>>
>>> I think the right fix is to return -EIOCBQUEUED from
>>> wait_on_page_locked_async() if the page isn't locked.  ie this:
>>>
>>> @@ -1258,7 +1258,7 @@ static int wait_on_page_locked_async(struct page *page,
>>>                                        struct wait_page_queue *wait)
>>>    {
>>>           if (!PageLocked(page))
>>> -               return 0;
>>> +               return -EIOCBQUEUED;
>>>           return __wait_on_page_locked_async(compound_head(page), wait, false);
>>>    }
>>> But as I said, I'm not sure what the semantics are supposed to be.
>>>
>> Hi Matthew,
>> which kernel version are you use, I believe I've fixed this case in the
>> commit c8d317aa1887b40b188ec3aaa6e9e524333caed1
> 
> Ah, I don't have that commit in my tree.
> 
> Nevertheless, there is still a problem.  The ->readpage implementation
> is not required to execute asynchronously.  For example, it may enter
> page reclaim by using GFP_KERNEL.  Indeed, I feel it is better if it
> works synchronously as it can then report the actual error from an I/O
> instead of the almost-meaningless -EIO.
> 
> This patch series documents 12 filesystems which implement ->readpage
> in a synchronous way today (for at least some cases) and converts iomap
> to be synchronous (making two more filesystems synchronous).
> 
> https://lore.kernel.org/linux-fsdevel/20201009143104.22673-1-willy@infradead.org/
> 
Thanks, Matthew. I didn't have this knowledge before, thank you for your 
share and information. It's really kind of you. I'll look into it soon.
