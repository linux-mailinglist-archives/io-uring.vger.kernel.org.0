Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD092462B4C
	for <lists+io-uring@lfdr.de>; Tue, 30 Nov 2021 04:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237956AbhK3DwE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Nov 2021 22:52:04 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:49217 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229769AbhK3DwD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Nov 2021 22:52:03 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UypgNRP_1638244122;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UypgNRP_1638244122)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 30 Nov 2021 11:48:42 +0800
Subject: Re: [RFC 0/9] fixed worker: a new way to handle io works
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211124044648.142416-1-haoxu@linux.alibaba.com>
 <a8bbe4e1-9017-76a4-eddb-d6a6676f7290@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <1c900f05-5f3f-9649-5240-813b16daf8eb@linux.alibaba.com>
Date:   Tue, 30 Nov 2021 11:48:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a8bbe4e1-9017-76a4-eddb-d6a6676f7290@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/11/25 下午11:09, Pavel Begunkov 写道:
> On 11/24/21 04:46, Hao Xu wrote:
>> There is big contension in current io-wq implementation. Introduce a new
>> type io-worker called fixed-worker to solve this problem. it is also a
>> new way to handle works. In this new system, works are dispatched to
>> different private queues rather than a long shared queue.
> 
> It's really great to temper the contention here, even though it looks
> we are stepping onto the path of reinventing all the optimisations
> solved long ago in other thread pools. Work stealing is probably
Hmm, hope io_uring can do it better, a powerful iowq! :)
> the next, but guess it's inevitable :)
Probably yes :)
> 
> First four patchhes sound like a good idea, they will probably go
> first. However, IIUC, the hashing is crucial and it's a must have.
> Are you planning to add it? If not, is there an easy way to leave
I'm planning to add it, still need some time to make it robust.
> hashing working even if hashed reqs not going through those new
> per-worker queues? E.g. (if it's not already as this...)
> 
> if (hashed) {
>      // fixed workers don't support hashing, so go through the
>      // old path and place into the shared queue.
>      enqueue_shared_queue();
> } else
>      enqueue_new_path();
>
Good idea.


> And last note, just fyi, it's easier to sell patches if you put
> numbers in the cover letter
Thanks Pavel, that's definitely clearer for people to review.

Cheers,
Hao
> 
> 
>> Hao Xu (9):
>>    io-wq: decouple work_list protection from the big wqe->lock
>>    io-wq: reduce acct->lock crossing functions lock/unlock
>>    io-wq: update check condition for lock
>>    io-wq: use IO_WQ_ACCT_NR rather than hardcoded number
>>    io-wq: move hash wait entry to io_wqe_acct
>>    io-wq: add infra data structure for fix workers
>>    io-wq: implement fixed worker logic
>>    io-wq: batch the handling of fixed worker private works
>>    io-wq: small optimization for __io_worker_busy()
>>
>>   fs/io-wq.c | 415 ++++++++++++++++++++++++++++++++++++++---------------
>>   fs/io-wq.h |   5 +
>>   2 files changed, 308 insertions(+), 112 deletions(-)
>>
> 

