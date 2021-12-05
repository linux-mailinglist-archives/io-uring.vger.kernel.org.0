Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBD3468BC1
	for <lists+io-uring@lfdr.de>; Sun,  5 Dec 2021 16:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhLEP1C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Dec 2021 10:27:02 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:47317 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235767AbhLEPZK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Dec 2021 10:25:10 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UzSFq5I_1638717701;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UzSFq5I_1638717701)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 05 Dec 2021 23:21:42 +0800
Subject: Re: Question about sendfile
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <6a7ceb04-3503-7300-8089-86c106a95e96@linux.alibaba.com>
 <4831bcfd-ce4a-c386-c5b2-a1417a23c500@gmail.com>
 <1414c8f9-e454-fb5a-7e44-cead5bbd61ea@linux.alibaba.com>
 <8cc826ea-c721-a178-eea1-2ee2a03722f3@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <7035ed41-d1ac-773c-04d8-83dda1983e5d@linux.alibaba.com>
Date:   Sun, 5 Dec 2021 23:21:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <8cc826ea-c721-a178-eea1-2ee2a03722f3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/12/4 上午12:03, Pavel Begunkov 写道:
> On 11/26/21 08:50, Hao Xu wrote:
>> 在 2021/7/7 下午10:16, Pavel Begunkov 写道:
>>> On 7/3/21 11:47 AM, Hao Xu wrote:
>>>> Hi Pavel,
>>>> I found this mail about sendfile in the maillist, may I ask why it's 
>>>> not
>>>> good to have one pipe each for a io-wq thread.
>>>> https://lore.kernel.org/io-uring/94dbbb15-4751-d03c-01fd-d25a0fe98e25@gmail.com/ 
>>>>
>>>
>>> IIRC, it's one page allocated for each such task, which is bearable but
>>> don't like yet another chunk of uncontrollable implicit state. If there
>>> not a bunch of active workers, IFAIK there is no way to force them to
>>> drop their pipes.
>>>
>>> I also don't remember the restrictions on the sendfile and what's with
>>> the eternal question of "what to do if the write part of sendfile has
>>> failed".
>> Hi Pavel,
>> Could you explain this question a little bit.., is there any special
>> concern? What I thought is sendfile does what it does,when it fails,
>> it will return -1 and errno is set appropriately.
> 
> I don't have much concern about this one, though interesting how
> it was solved and whether you need to know the issuing task to
> handle errors.
> 
> I didn't like more having uncontrollable memory, i.e. a pipe per
> worker that used sendfile (IIRC it keeps 1 page), and no way to
> reuse the memory or release it. In other words, a sendfile request
> chooses to which worker it goes randomly. E.g. First sendfile may go
> to worker 1 leaving 1 page allocated. The second sendfile goes to
> worker 2, so after we have 2 pages allocated, an so on. At some
> point you have N pages, where any particular one may likely be
> rarely used.
I'm not sure when the pipe is freed(seems it won't be freed after
sendfile call and it is reused). If it won't be freed automatically
we can manually free it when a worker completes a sendfile work. I think
in normal cases, a user cannot and shouldn't visit the internal pipe
after senfile is done no matter it succeeds or fails, which means we
can free the pipe at that time. Not 100% sure but probably..
> 
> Please correct me if I forgot how it works and wrong here.
> 
>>> Though, workers are now much more alike to user threads, so there
>>> should be less of concern. And even though my gut feeling don't like
>>> them, it may actually be useful. Do you have a good use case where
>>> explicit pipes don't work well?
> 

