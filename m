Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B80359334
	for <lists+io-uring@lfdr.de>; Fri,  9 Apr 2021 05:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhDIDoD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Apr 2021 23:44:03 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:48228 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232941AbhDIDoD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Apr 2021 23:44:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UUx4rqm_1617939829;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UUx4rqm_1617939829)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 09 Apr 2021 11:43:50 +0800
Subject: Re: [PATCH 5.13 v2] io_uring: maintain drain requests' logic
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
 <00898a9b-d2f2-1108-b9d9-2d6acea6e713@kernel.dk>
 <32f812e1-c044-d4b3-d26f-3721e4611a1d@linux.alibaba.com>
 <119436dd-5e55-9812-472c-7a257bda12fb@linux.alibaba.com>
 <826e199f-1cc0-f529-f200-5fa643a62bca@gmail.com>
 <9e38a7cc-9dbc-371e-3d6e-344afecb554a@linux.alibaba.com>
Message-ID: <e3d2c516-cda5-2328-dd8b-af97bdbf7384@linux.alibaba.com>
Date:   Fri, 9 Apr 2021 11:43:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <9e38a7cc-9dbc-371e-3d6e-344afecb554a@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/9 上午11:12, Hao Xu 写道:
> 在 2021/4/8 下午8:22, Pavel Begunkov 写道:
>> On 08/04/2021 12:43, Hao Xu wrote:
>>> 在 2021/4/8 下午6:16, Hao Xu 写道:
>>>> 在 2021/4/7 下午11:49, Jens Axboe 写道:
>>>>> On 4/7/21 5:23 AM, Hao Xu wrote:
>>>>>> more tests comming, send this out first for comments.
>>>>>>
>>>>>> Hao Xu (3):
>>>>>>     io_uring: add IOSQE_MULTI_CQES/REQ_F_MULTI_CQES for multishot 
>>>>>> requests
>>>>>>     io_uring: maintain drain logic for multishot requests
>>>>>>     io_uring: use REQ_F_MULTI_CQES for multipoll IORING_OP_ADD
>>>>>>
>>>>>>    fs/io_uring.c                 | 34 
>>>>>> +++++++++++++++++++++++++++++-----
>>>>>>    include/uapi/linux/io_uring.h |  8 +++-----
>>>>>>    2 files changed, 32 insertions(+), 10 deletions(-)
>>>>>
>>>>> Let's do the simple cq_extra first. I don't see a huge need to add an
>>>>> IOSQE flag for this, probably best to just keep this on a per opcode
>>>>> basis for now, which also then limits the code path to just touching
>>>>> poll for now, as nothing else supports multishot CQEs at this point.
>>>>>
>>>> gotcha.
>>>> a small issue here:
>>>>    sqe-->sqe(link)-->sqe(link)-->sqe(link, multishot)-->sqe(drain)
>>>>
>>>> in the above case, assume the first 3 single-shot reqs have completed.
>>>> then I think the drian request won't be issued now unless the 
>>>> multishot request in the linkchain has been issued. The trick is: a 
>>>> multishot req
>>>> in a linkchain consumes cached_sq_head when io_get_sqe(), which 
>>>> means it
>>>> is counted in seq, but we will deduct the sqe when it is issued if we
>>>> want to do the job per opcode not in the main code path.
>>>> before the multishot req issued:
>>>>        all_sqes(4) - multishot_sqes(0) == all_cqes(3) - 
>>>> multishot_cqes(0)
>>>> after the multishot req issued:
>>>>        all_sqes(4) - multishot_sqes(1) == all_cqes(3) - 
>>>> multishot_cqes(0)
>>>
>>> Sorry, my statement is wrong. It's not "won't be issued now unless the
>>> multishot request in the linkchain has been issued". Actually I now
>>> think the drain req won't be issued unless the multishot request in the
>>> linkchain has completed. Because we may first check req_need_defer()
>>> then issue(req->link), so:
>>>     sqe0-->sqe1(link)-->sqe2(link)-->sqe3(link, multishot)-->sqe4(drain)
>>>
>>>    sqe2 is completed:
>>>      call req_need_defer:
>>>      all_sqes(4) - multishot_sqes(0) == all_cqes(3) - multishot_cqes(0)
>>>    sqe3 is issued:
>>>      all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(0)
>>>    sqe3 is completed:
>>>      call req_need_defer:
>>>      all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(0)
>>>
>>> sqe4 shouldn't wait sqe3.
>>
>> Do you mean it wouldn't if the patch is applied? Because any drain
>> request must wait for all requests submitted before to complete. And
>> so before issuing sqe4 it must wait for sqe3 __request__ to die, and
>> so for all sqe3's CQEs.
>>
>> previously
>>
> Hi Pavel, the issue is what will happen after the patch being applied. 
> The patch is to ignore all the multishot sqes and cqes. So by design,
> sqe4 should wait for sqe0,1,2's completion, not sqe3's. But since we
> implement it in per opcode place and don't touch the main code path, we
> deduct a multishot sqe when issusing it(eg. call io_poll_add()).
> So only when we issue sqe3, the equation is true:
>     all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(0)
> But at this point, we already missed
> io_commit_cqring()-->__io_queue_deferred(), the next time 
> __io_queue_deferred() being called is when sqe3 completed, so now sqe4
> has waited for sqe3, this is not by design.
> 
> Regards,
> Hao
> 
Moreover, I found when sqe3 completed, the equation is:
    all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(1)
thus sqe4 will never be issued.
> 
>>

