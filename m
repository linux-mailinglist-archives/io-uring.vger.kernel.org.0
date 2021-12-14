Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8808547488B
	for <lists+io-uring@lfdr.de>; Tue, 14 Dec 2021 17:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbhLNQxw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Dec 2021 11:53:52 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:55332 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229685AbhLNQxw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Dec 2021 11:53:52 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V-dpChw_1639500829;
Received: from 192.168.209.55(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V-dpChw_1639500829)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 15 Dec 2021 00:53:50 +0800
Subject: Re: [POC RFC 0/3] support graph like dependent sqes
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211214055734.61702-1-haoxu@linux.alibaba.com>
 <4ef630f4-54d8-e8c6-8622-dccef5323864@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <7607c0f9-cad3-cfc5-687e-07dc82684b4e@linux.alibaba.com>
Date:   Wed, 15 Dec 2021 00:53:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <4ef630f4-54d8-e8c6-8622-dccef5323864@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


在 2021/12/14 下午11:21, Pavel Begunkov 写道:
> On 12/14/21 05:57, Hao Xu wrote:
>> This is just a proof of concept which is incompleted, send it early for
>> thoughts and suggestions.
>>
>> We already have IOSQE_IO_LINK to describe linear dependency
>> relationship sqes. While this patchset provides a new feature to
>> support DAG dependency. For instance, 4 sqes have a relationship
>> as below:
>>        --> 2 --
>>       /        \
>> 1 ---          ---> 4
>>       \        /
>>        --> 3 --
>> IOSQE_IO_LINK serializes them to 1-->2-->3-->4, which unneccessarily
>> serializes 2 and 3. But a DAG can fully describe it.
>>
>> For the detail usage, see the following patches' messages.
>>
>> Tested it with 100 direct read sqes, each one reads a BS=4k block data
>> in a same file, blocks are not overlapped. These sqes form a graph:
>>        2
>>        3
>> 1 --> 4 --> 100
>>       ...
>>        99
>>
>> This is an extreme case, just to show the idea.
>>
>> results below:
>> io_link:
>> IOPS: 15898251
>> graph_link:
>> IOPS: 29325513
>> io_link:
>> IOPS: 16420361
>> graph_link:
>> IOPS: 29585798
>> io_link:
>> IOPS: 18148820
>> graph_link:
>> IOPS: 27932960
>
> Hmm, what do we compare here? IIUC,
> "io_link" is a huge link of 100 requests. Around 15898251 IOPS
> "graph_link" is a graph of diameter 3. Around 29585798 IOPS
>
> Is that right? If so it'd more more fair to compare with a
> similar graph-like scheduling on the userspace side.

The above test is more like to show the disadvantage of LINK

But yes, it's better to test the similar userspace  scheduling since

LINK is definitely not a good choice so have to prove the graph stuff

beat the userspace scheduling. Will test that soon. Thanks.

>
> submit(req={1});
> wait(nr=1);
> submit({2-99});
> wait(nr=98);
> submit(req={100});
> wait(nr=1);
>
>
>> Tested many times, numbers are not very stable but shows the difference.
>>
>> something to concern:
>> 1. overhead to the hot path: several IF checks
>> 2. many memory allocations
>> 3. many atomic_read/inc/dec stuff
>>
>> many things to be done:
>> 1. cancellation, failure path
>> 2. integrate with other features.
>> 3. maybe need some cache design to overcome the overhead of memory
>>     allcation
>> 4. some thing like topological sorting to avoid rings in the graph
>>
>> Any thoughts?
>>
>> Hao Xu (3):
>>    io_uring: add data structure for graph sqe feature
>>    io_uring: implement new sqe opcode to build graph like links
>>    io_uring: implement logic of IOSQE_GRAPH request
>>
>>   fs/io_uring.c                 | 231 +++++++++++++++++++++++++++++++++-
>>   include/uapi/linux/io_uring.h |   9 ++
>>   2 files changed, 235 insertions(+), 5 deletions(-)
>>
>
