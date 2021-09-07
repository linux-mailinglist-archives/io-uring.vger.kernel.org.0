Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CAC402386
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 08:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbhIGGkE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 02:40:04 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:47848 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233050AbhIGGkD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Sep 2021 02:40:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UnYpry5_1630996735;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UnYpry5_1630996735)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Sep 2021 14:38:56 +0800
Subject: Re: [PATCH 4/6] io_uring: let fast poll support multishot
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-5-haoxu@linux.alibaba.com>
 <b3ea4817-98d9-def8-d75e-9758ca7d1c33@gmail.com>
 <8f3046d9-d678-f755-e7af-a0e5040699ca@linux.alibaba.com>
 <45ccd2d3-267c-16df-c4be-c4530f50db86@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <a08e74b5-1dc5-5f0a-f176-005240f20548@linux.alibaba.com>
Date:   Tue, 7 Sep 2021 14:38:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <45ccd2d3-267c-16df-c4be-c4530f50db86@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/7 上午3:09, Pavel Begunkov 写道:
> On 9/6/21 6:40 PM, Hao Xu wrote:
>> 在 2021/9/6 下午11:56, Pavel Begunkov 写道:
>>> On 9/3/21 12:00 PM, Hao Xu wrote:
>>>> For operations like accept, multishot is a useful feature, since we can
>>>> reduce a number of accept sqe. Let's integrate it to fast poll, it may
>>>> be good for other operations in the future.
>>>
>>> __io_arm_poll_handler()         |
>>>     -> vfs_poll()                 |
>>>                                   | io_async_task_func() // post CQE
>>>                                   | ...
>>>                                   | do_apoll_rewait();
>>>     -> continues after vfs_poll(),|
>>>        removing poll->head of     |
>>>        the second poll attempt.
         this(removal) only happen when there is error or it is
EPOLLONESHOT
    |
>>>
>>>
>> Sorry.. a little bit confused by this case, would you mind explain a bit
>> more..is the right part a system-workqueue context? and is
>> do_apoll_rewait() io_poll_rewait() function?
> 
> I meant in a broad sense. If your patches make lifetime of an accept
> request to be like:
> 
> accept() -> arm_apoll() -> apoll_func() -> accept() -> ...
>      -> ... (repeat many times)
> 
> then do_apoll_rewait() is the second accept in the scheme.
> 
> If not, and it's
> 
> accept() -> arm_poll() -> apoll_func() -> apoll_func() ->
>   ... -> ?
> 
> Then that "do_apoll_rewait()" should have been second and
> other apoll_func()s.
> 
> So, it's rather a thing to look after, but not a particular
> bug.
> 
> 
>>> One of the reasons for forbidding multiple apoll's is that it
>>> might be racy. I haven't looked into this implementation, but
>>> we should check if there will be problems from that.
>>>
>>> FWIW, putting aside this patchset, the poll/apoll is not in
>>> the best shape and can use some refactoring.
>>>
>>>
> [...]
> 

