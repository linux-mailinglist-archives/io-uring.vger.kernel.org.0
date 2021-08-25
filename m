Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949D43F7B88
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 19:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbhHYR1n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 13:27:43 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:59044 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242194AbhHYR1m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 13:27:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UlskFCQ_1629912414;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UlskFCQ_1629912414)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 26 Aug 2021 01:26:55 +0800
Subject: Re: [RFC 0/2] io_task_work optimization
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210823183648.163361-1-haoxu@linux.alibaba.com>
 <503f1587-f7d9-13a9-a509-f9623d8748e9@kernel.dk>
 <19c77256-c83b-62b2-f3fb-7c85c882b5b2@linux.alibaba.com>
 <39252708-3e63-b87d-553d-f201872ed68f@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <db742c7c-851b-3c46-5403-ec6b00b573d3@linux.alibaba.com>
Date:   Thu, 26 Aug 2021 01:26:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <39252708-3e63-b87d-553d-f201872ed68f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/26 上午12:46, Pavel Begunkov 写道:
> On 8/25/21 5:39 PM, Hao Xu wrote:
>> 在 2021/8/25 下午11:58, Jens Axboe 写道:
>>> On 8/23/21 12:36 PM, Hao Xu wrote:
>>>> running task_work may not be a big bottleneck now, but it's never worse
>>>> to make it move forward a little bit.
>>>> I'm trying to construct tests to prove it is better in some cases where
>>>> it should be theoretically.
>>>> Currently only prove it is not worse by running fio tests(sometimes a
>>>> little bit better). So just put it here for comments and suggestion.
>>>
>>> I think this is interesting, particularly for areas where we have a mix
>>> of task_work uses because obviously it won't really matter if the
>>> task_work being run is homogeneous.
>>>
>>> That said, would be nice to have some numbers associated with it. We
>>> have a few classes of types of task_work:
>>>
>>> 1) Work completes really fast, we want to just do those first
>>> 2) Work is pretty fast, like async buffered read copy
>>> 3) Work is more expensive, might require a full retry of the operation
>>>
>>> Might make sense to make this classification explicit. Problem is, with
>>> any kind of scheduling like that, you risk introducing latency bubbles
>>> because the prio1 list grows really fast, for example.
>> Yes, this may intrpduce latency if overwhelming 1) comes in short time.
>> I'll try more tests to see if the problem exists and if there is a
>> better way, like put limited number of 1) to the front. Anyway, I'll
>> update this thread when I get some data.
> 
> Not sure, but it looks that IRQ completion batching is coming to
> 5.15. With that you may also want to flush completions after the
> IRQ sublist is exhausted.
> 
> May be worth to consider having 2 lists in the future
I'll think about that, and there may be a way to reduce lock cost if
there are multiple lists.
lists.
> 

