Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7046B4779C6
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 17:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239748AbhLPQzy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 11:55:54 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:38878 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238700AbhLPQzx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 11:55:53 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V-plzSV_1639673751;
Received: from 192.168.31.207(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V-plzSV_1639673751)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 17 Dec 2021 00:55:51 +0800
Subject: Re: [POC RFC 0/3] support graph like dependent sqes
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211214055734.61702-1-haoxu@linux.alibaba.com>
 <4ef630f4-54d8-e8c6-8622-dccef5323864@gmail.com>
 <7607c0f9-cad3-cfc5-687e-07dc82684b4e@linux.alibaba.com>
 <06e21b01-a168-e25f-1b42-97789392bd89@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <c6e18c00-7c1b-d1e9-a152-91b86f426289@linux.alibaba.com>
Date:   Fri, 17 Dec 2021 00:55:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <06e21b01-a168-e25f-1b42-97789392bd89@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


在 2021/12/15 上午2:16, Pavel Begunkov 写道:
> On 12/14/21 16:53, Hao Xu wrote:
>>
>> 在 2021/12/14 下午11:21, Pavel Begunkov 写道:
>>> On 12/14/21 05:57, Hao Xu wrote:
>>>> This is just a proof of concept which is incompleted, send it early 
>>>> for
>>>> thoughts and suggestions.
>>>>
>>>> We already have IOSQE_IO_LINK to describe linear dependency
>>>> relationship sqes. While this patchset provides a new feature to
>>>> support DAG dependency. For instance, 4 sqes have a relationship
>>>> as below:
>>>>        --> 2 --
>>>>       /        \
>>>> 1 ---          ---> 4
>>>>       \        /
>>>>        --> 3 --
>>>> IOSQE_IO_LINK serializes them to 1-->2-->3-->4, which unneccessarily
>>>> serializes 2 and 3. But a DAG can fully describe it.
>>>>
>>>> For the detail usage, see the following patches' messages.
>>>>
>>>> Tested it with 100 direct read sqes, each one reads a BS=4k block data
>>>> in a same file, blocks are not overlapped. These sqes form a graph:
>>>>        2
>>>>        3
>>>> 1 --> 4 --> 100
>>>>       ...
>>>>        99
>>>>
>>>> This is an extreme case, just to show the idea.
>>>>
>>>> results below:
>>>> io_link:
>>>> IOPS: 15898251
>>>> graph_link:
>>>> IOPS: 29325513
>>>> io_link:
>>>> IOPS: 16420361
>>>> graph_link:
>>>> IOPS: 29585798
>>>> io_link:
>>>> IOPS: 18148820
>>>> graph_link:
>>>> IOPS: 27932960
>>>
>>> Hmm, what do we compare here? IIUC,
>>> "io_link" is a huge link of 100 requests. Around 15898251 IOPS
>>> "graph_link" is a graph of diameter 3. Around 29585798 IOPS
>
> Diam 2 graph, my bad
>
>
>>> Is that right? If so it'd more more fair to compare with a
>>> similar graph-like scheduling on the userspace side.
>>
>> The above test is more like to show the disadvantage of LINK
>
> Oh yeah, links can be slow, especially when it kills potential
> parallelism or need extra allocations for keeping state, like
> READV and WRITEV.
>
>
>> But yes, it's better to test the similar userspace  scheduling since
>>
>> LINK is definitely not a good choice so have to prove the graph stuff
>>
>> beat the userspace scheduling. Will test that soon. Thanks.
>
> Would be also great if you can also post the benchmark once
> it's done

Wrote a new test to test nop sqes forming a full binary tree with 
(2^10)-1 nodes,

which I think it a more general case.  Turns out the result is still not 
stable and

the kernel side graph link is much slow. I'll try to optimize it.

Btw, is there any comparison data between the current io link feature 
and the

userspace scheduling.


Regards,

Hao

>
>
>>> submit(req={1});
>>> wait(nr=1);
>>> submit({2-99});
>>> wait(nr=98);
>>> submit(req={100});
>>> wait(nr=1);
>>>
>
