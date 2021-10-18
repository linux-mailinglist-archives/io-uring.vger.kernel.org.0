Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7E74318F3
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 14:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhJRMW3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 08:22:29 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:59500 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231727AbhJRMW0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 08:22:26 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UsfKww5_1634559613;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UsfKww5_1634559613)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 18 Oct 2021 20:20:14 +0800
Subject: Re: [PATCH 2/2] io_uring: implement async hybrid mode for pollable
 requests
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211018112923.16874-1-haoxu@linux.alibaba.com>
 <20211018112923.16874-3-haoxu@linux.alibaba.com>
 <07ecb722-bf42-b785-2064-79221a3362cc@linux.alibaba.com>
 <30f3642e-972b-fa0f-6ce5-2208a29dad4d@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <1fa473be-1802-8a8d-b4af-bd9afaf6d925@linux.alibaba.com>
Date:   Mon, 18 Oct 2021 20:20:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <30f3642e-972b-fa0f-6ce5-2208a29dad4d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/18 下午8:10, Pavel Begunkov 写道:
> On 10/18/21 11:34, Hao Xu wrote:
>> 在 2021/10/18 下午7:29, Hao Xu 写道:
>>> The current logic of requests with IOSQE_ASYNC is first queueing it to
>>> io-worker, then execute it in a synchronous way. For unbound works like
>>> pollable requests(e.g. read/write a socketfd), the io-worker may stuck
>>> there waiting for events for a long time. And thus other works wait in
>>> the list for a long time too.
>>> Let's introduce a new way for unbound works (currently pollable
>>> requests), with this a request will first be queued to io-worker, then
>>> executed in a nonblock try rather than a synchronous way. Failure of
>>> that leads it to arm poll stuff and then the worker can begin to handle
>>> other works.
>>> The detail process of this kind of requests is:
>>>
>>> step1: original context:
>>>             queue it to io-worker
>>> step2: io-worker context:
>>>             nonblock try(the old logic is a synchronous try here)
>>>                 |
>>>                 |--fail--> arm poll
>>>                              |
>>>                              |--(fail/ready)-->synchronous issue
>>>                              |
>>>                              |--(succeed)-->worker finish it's job, tw
>>>                                             take over the req
>>>
>>> This works much better than the old IOSQE_ASYNC logic in cases where
>>> unbound max_worker is relatively small. In this case, number of
>>> io-worker eazily increments to max_worker, new worker cannot be created
>>> and running workers stuck there handling old works in IOSQE_ASYNC mode.
>>>
>>> In my 64-core machine, set unbound max_worker to 20, run echo-server,
>>> turns out:
>>> (arguments: register_file, connetion number is 1000, message size is 12
>>> Byte)
>>> original IOSQE_ASYNC: 76664.151 tps
>>> after this patch: 166934.985 tps
>>>
>>> Suggested-by: Jens Axboe <axboe@kernel.dk>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> An irrelevant question: why do we do linked timeout logic in
>> io_wq_submit_work() again regarding that we've already done it in
>> io_queue_async_work().
> 
> Because io_wq_free_work() may enqueue new work (by returning it)
> without going through io_queue_async_work(), and we don't care
> enough to split those cases.
Make sense. Thanks.
> 

