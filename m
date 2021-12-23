Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6695147DE37
	for <lists+io-uring@lfdr.de>; Thu, 23 Dec 2021 05:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346299AbhLWEOU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Dec 2021 23:14:20 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:37773 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346298AbhLWEOT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Dec 2021 23:14:19 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V.ULv6H_1640232857;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V.ULv6H_1640232857)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Dec 2021 12:14:17 +0800
Subject: Re: [POC RFC 0/3] support graph like dependent sqes
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211214055734.61702-1-haoxu@linux.alibaba.com>
 <4ef630f4-54d8-e8c6-8622-dccef5323864@gmail.com>
 <7607c0f9-cad3-cfc5-687e-07dc82684b4e@linux.alibaba.com>
 <06e21b01-a168-e25f-1b42-97789392bd89@gmail.com>
 <c6e18c00-7c1b-d1e9-a152-91b86f426289@linux.alibaba.com>
 <aebc5433-258d-2d36-9e38-36860b99a669@gmail.com>
 <96155b9c-9f35-53b8-456a-8623fc850b03@linux.alibaba.com>
 <84ed785a-b0b0-6d05-2c13-7c3efe9fd60b@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <a0e53941-0093-5e55-ac9b-b2e2c1f32060@linux.alibaba.com>
Date:   Thu, 23 Dec 2021 12:14:16 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <84ed785a-b0b0-6d05-2c13-7c3efe9fd60b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/12/22 上午12:19, Pavel Begunkov 写道:
> On 12/18/21 06:57, Hao Xu wrote:
>> 在 2021/12/18 上午3:33, Pavel Begunkov 写道:
>>> On 12/16/21 16:55, Hao Xu wrote:
>>>> 在 2021/12/15 上午2:16, Pavel Begunkov 写道:
>>>>> On 12/14/21 16:53, Hao Xu wrote:
>>>>>> 在 2021/12/14 下午11:21, Pavel Begunkov 写道:
>>>>>>> On 12/14/21 05:57, Hao Xu wrote:
>>>>>>>> This is just a proof of concept which is incompleted, send it 
>>>>>>>> early for
>>>>>>>> thoughts and suggestions.
>>>>>>>>
>>>>>>>> We already have IOSQE_IO_LINK to describe linear dependency
>>>>>>>> relationship sqes. While this patchset provides a new feature to
>>>>>>>> support DAG dependency. For instance, 4 sqes have a relationship
>>>>>>>> as below:
>>>>>>>>        --> 2 --
>>>>>>>>       /        \
>>>>>>>> 1 ---          ---> 4
>>>>>>>>       \        /
>>>>>>>>        --> 3 --
>>>>>>>> IOSQE_IO_LINK serializes them to 1-->2-->3-->4, which 
>>>>>>>> unneccessarily
>>>>>>>> serializes 2 and 3. But a DAG can fully describe it.
>>>>>>>>
>>>>>>>> For the detail usage, see the following patches' messages.
>>>>>>>>
>>>>>>>> Tested it with 100 direct read sqes, each one reads a BS=4k 
>>>>>>>> block data
>>>>>>>> in a same file, blocks are not overlapped. These sqes form a graph:
>>>>>>>>        2
>>>>>>>>        3
>>>>>>>> 1 --> 4 --> 100
>>>>>>>>       ...
>>>>>>>>        99
>>>>>>>>
>>>>>>>> This is an extreme case, just to show the idea.
>>>>>>>>
>>>>>>>> results below:
>>>>>>>> io_link:
>>>>>>>> IOPS: 15898251
>>>>>>>> graph_link:
>>>>>>>> IOPS: 29325513
>>>>>>>> io_link:
>>>>>>>> IOPS: 16420361
>>>>>>>> graph_link:
>>>>>>>> IOPS: 29585798
>>>>>>>> io_link:
>>>>>>>> IOPS: 18148820
>>>>>>>> graph_link:
>>>>>>>> IOPS: 27932960
>>>>>>>
>>>>>>> Hmm, what do we compare here? IIUC,
>>>>>>> "io_link" is a huge link of 100 requests. Around 15898251 IOPS
>>>>>>> "graph_link" is a graph of diameter 3. Around 29585798 IOPS
>>>>>
>>>>> Diam 2 graph, my bad
>>>>>
>>>>>
>>>>>>> Is that right? If so it'd more more fair to compare with a
>>>>>>> similar graph-like scheduling on the userspace side.
>>>>>>
>>>>>> The above test is more like to show the disadvantage of LINK
>>>>>
>>>>> Oh yeah, links can be slow, especially when it kills potential
>>>>> parallelism or need extra allocations for keeping state, like
>>>>> READV and WRITEV.
>>>>>
>>>>>
>>>>>> But yes, it's better to test the similar userspace  scheduling since
>>>>>>
>>>>>> LINK is definitely not a good choice so have to prove the graph stuff
>>>>>>
>>>>>> beat the userspace scheduling. Will test that soon. Thanks.
>>>>>
>>>>> Would be also great if you can also post the benchmark once
>>>>> it's done
>>>>
>>>> Wrote a new test to test nop sqes forming a full binary tree with 
>>>> (2^10)-1 nodes,
>>>> which I think it a more general case.  Turns out the result is still 
>>>> not stable and
>>>> the kernel side graph link is much slow. I'll try to optimize it.
>>>
>>> That's expected unfortunately. And without reacting on results
>>> of previous requests, it's hard to imagine to be useful. BPF may
>>> have helped, e.g. not keeping an explicit graph but just generating
>>> new requests from the kernel... But apparently even with this it's
>>> hard to compete with just leaving it in userspace.
Not sure what it looks like by 'generating new requests by BPF', since
a sqe may have multiple pre-sqes. Can a BPF sleeps there and waits for
all the pre-sqes done, and if it can, there still have to be some
counting stuff and wakeups. Another problem is does the bpf sleep blocks
the main context? So not sure 'BPF fully controls graph/link logic'
beats 'only let BPF do data flow and build graph/link explicitly'.
Have you tested using BPF to form links/graph, curious about the
real performance comparison with userspace scheduling.
>>>
>> Tried to exclude the memory allocation stuff, seems it's a bit better 
>> than the user graph.
>>
>> For the result delivery, I was thinking of attaching BPF program 
>> within a sqe, not creating
>> a single BPF type sqe. Then we can have data flow in the graph or 
>> linkchain. But I haven't
>> had a clear draft for it
> 
> Oh, I dismissed this idea before. Even if it can be done in-place 
> without any
> additional tw (consider recursion and submit_state not prepared for 
> that), it'll
> be a horror to maintain. And I also don't see it being flexible enough
> 
> There is one idea from guys that I have to implement, i.e. having a per-CQ
> callback. Might interesting to experiment, but I don't see it being viable
> in the long run.
> 
> 
>>>> Btw, is there any comparison data between the current io link 
>>>> feature and the
>>>> userspace scheduling.
>>>
>>> Don't remember. I'd try to look up the cover-letter for the patches
>>> implementing it, I believe there should've been some numbers and
>>> hopefully test description.
>>>
>>> fwiw, before io_uring mailing list got established patches/etc.
>>> were mostly going through linux-block mailing list. Links are old, so
>>> patches might be there.
>>>
> 
https://lore.kernel.org/linux-block/20190517214131.5925-1-axboe@kernel.dk/
found the initial patchset here, seems Jens tested it by
example/iouring-cp, I'll test it later. Also found the same idea of 
attaching BPF to a sqe so that it can run at the end of sqe completion.
Curious if there has been POC implemented before and numbers of this,
compared with userspace result delivery.


