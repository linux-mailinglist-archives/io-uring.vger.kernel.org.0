Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1029235C967
	for <lists+io-uring@lfdr.de>; Mon, 12 Apr 2021 17:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239886AbhDLPH1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Apr 2021 11:07:27 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:36928 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237526AbhDLPH0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Apr 2021 11:07:26 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UVMmZzk_1618240026;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UVMmZzk_1618240026)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 12 Apr 2021 23:07:06 +0800
Subject: Re: [PATCH 5.13 v2] io_uring: maintain drain requests' logic
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
 <00898a9b-d2f2-1108-b9d9-2d6acea6e713@kernel.dk>
 <32f812e1-c044-d4b3-d26f-3721e4611a1d@linux.alibaba.com>
 <119436dd-5e55-9812-472c-7a257bda12fb@linux.alibaba.com>
 <826e199f-1cc0-f529-f200-5fa643a62bca@gmail.com>
 <19183813-6755-52bb-5391-4809a837ec5f@kernel.dk>
 <9fd3a4c0-488f-ca82-083a-78d448a1564e@linux.alibaba.com>
 <ba02965b-69e5-a72f-e9cf-a613af55c7b5@linux.alibaba.com>
 <b56053a6-9aa1-f682-3079-0aeb32da8074@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <4d3b0998-d732-9af9-a1f7-b8fa59207554@linux.alibaba.com>
Date:   Mon, 12 Apr 2021 23:07:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <b56053a6-9aa1-f682-3079-0aeb32da8074@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/9 下午3:50, Pavel Begunkov 写道:
> On 09/04/2021 08:05, Hao Xu wrote:
>> 在 2021/4/9 下午2:15, Hao Xu 写道:
>>> 在 2021/4/9 上午12:18, Jens Axboe 写道:
>>>> On 4/8/21 6:22 AM, Pavel Begunkov wrote:
>>>>> On 08/04/2021 12:43, Hao Xu wrote:
>>>>>> 在 2021/4/8 下午6:16, Hao Xu 写道:
>>>>>>> 在 2021/4/7 下午11:49, Jens Axboe 写道:
>>>>>>>> On 4/7/21 5:23 AM, Hao Xu wrote:
>>>>>>>>> more tests comming, send this out first for comments.
>>>>>>>>>
>>>>>>>>> Hao Xu (3):
>>>>>>>>>      io_uring: add IOSQE_MULTI_CQES/REQ_F_MULTI_CQES for multishot requests
>>>>>>>>>      io_uring: maintain drain logic for multishot requests
>>>>>>>>>      io_uring: use REQ_F_MULTI_CQES for multipoll IORING_OP_ADD
>>>>>>>>>
>>>>>>>>>     fs/io_uring.c                 | 34 +++++++++++++++++++++++++++++-----
>>>>>>>>>     include/uapi/linux/io_uring.h |  8 +++-----
>>>>>>>>>     2 files changed, 32 insertions(+), 10 deletions(-)
>>>>>>>>
>>>>>>>> Let's do the simple cq_extra first. I don't see a huge need to add an
>>>>>>>> IOSQE flag for this, probably best to just keep this on a per opcode
>>>>>>>> basis for now, which also then limits the code path to just touching
>>>>>>>> poll for now, as nothing else supports multishot CQEs at this point.
>>>>>>>>
>>>>>>> gotcha.
>>>>>>> a small issue here:
>>>>>>>     sqe-->sqe(link)-->sqe(link)-->sqe(link, multishot)-->sqe(drain)
>>>>>>>
>>>>>>> in the above case, assume the first 3 single-shot reqs have completed.
>>>>>>> then I think the drian request won't be issued now unless the multishot request in the linkchain has been issued. The trick is: a multishot req
>>>>>>> in a linkchain consumes cached_sq_head when io_get_sqe(), which means it
>>>>>>> is counted in seq, but we will deduct the sqe when it is issued if we
>>>>>>> want to do the job per opcode not in the main code path.
>>>>>>> before the multishot req issued:
>>>>>>>         all_sqes(4) - multishot_sqes(0) == all_cqes(3) - multishot_cqes(0)
>>>>>>> after the multishot req issued:
>>>>>>>         all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(0)
>>>>>>
>>>>>> Sorry, my statement is wrong. It's not "won't be issued now unless the
>>>>>> multishot request in the linkchain has been issued". Actually I now
>>>>>> think the drain req won't be issued unless the multishot request in the
>>>>>> linkchain has completed. Because we may first check req_need_defer()
>>>>>> then issue(req->link), so:
>>>>>>      sqe0-->sqe1(link)-->sqe2(link)-->sqe3(link, multishot)-->sqe4(drain)
>>>>>>
>>>>>>     sqe2 is completed:
>>>>>>       call req_need_defer:
>>>>>>       all_sqes(4) - multishot_sqes(0) == all_cqes(3) - multishot_cqes(0)
>>>>>>     sqe3 is issued:
>>>>>>       all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(0)
>>>>>>     sqe3 is completed:
>>>>>>       call req_need_defer:
>>>>>>       all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(0)
>>>>>>
>>>>>> sqe4 shouldn't wait sqe3.
>>>>>
>>>>> Do you mean it wouldn't if the patch is applied? Because any drain
>>>>> request must wait for all requests submitted before to complete. And
>>>>> so before issuing sqe4 it must wait for sqe3 __request__ to die, and
>>>>> so for all sqe3's CQEs.
>>>>>
>>>>> previously
>>>>
>>>> I think we need to agree on what multishot means for dependencies. Does
>>>> it mean it just needs to trigger once? Or does it mean that it needs to
>>>> be totally finished. The latter may obviously never happen, depending on
>>>> the use case. Or it may be an expected condition because the caller will
>>>> cancel it at some point.
>>>>
>>>> The most logical view imho is that multishot changes nothing wrt drain.
>>>> If you ask for drain before something executes and you are using
>>>> multishot, then you need to understand that the multishot request needs
>>>> to fully complete before that condition is true and your dependency can
>>>> execute.
>>> This makes sense, and the implementation would be quite simpler. but we
>>> really need to document it somewhere so that users easily get to know
>>> that they cannot put a drain req after some multishot reqs if they don't
>>> want it to wait for them. Otherwise I worry about wrong use of it since
>>> the meaning of 'put a drain req after some multishot reqs' isn't so
>>> obvious:
>>>      - does it waits for those multishot reqs to complete once
>>>      - or does it waits for those ones to fully complete
>>>      - or does it ignore those ones at all
>>>
>> I realised that if a drain req has to wait for multishot reqs' fully
>>   completion, then users have to explicitly cancel all the previous
>> multishot reqs, otherwise it won't execute forever:
>>      sqe0(multishot)-->sqe1(drain)-->sqe2(cancel multishot)    stuck
> 
> And it's not a new behaviour, e.g. read(pipe); drain(); where nobody
> writes to the pipe will stuck as well.
> 
> I like that it currently provides a full barrier between requests, are
> there other patterns used by someone?
> 
As I'm writing a test for it, I found there is something different.
we can break the stuck case above(read(pipe); drain();) easily since 
writing something to the pipe is independant to the sqring itself.
But for a multishot req, there are many restrictions for the cancel req.
   1. we cannot mark a cancel as LINK or DRAIN:
         (1)sqe(multishot)->sqe(link, cancel)->sqe(link, drain)
         (2)sqe(multishot)->sqe(cancel, drain)
         (3)the linkchain fails at some member, which leads to
            cancellation of the cancel req. and users have to retry.

   2. we have to be careful when marking a multishot req with LINK or
      DRAIN
       (1)sqe0(nop, link)->sqe1(multishot, link)->sqe2(nop)->sqe3(cancel)
         *  sqe3 may execute before sqe1, and cancels nothing
         in other words, we have to carefully arrange them to make sure
         the cancel req works.
       (2) sqe(multshot, drain)

There may be other cases. I feel it not easy for users to jump over
  these traps.



