Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832D91E2442
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 16:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgEZOmW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 10:42:22 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:57259 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726437AbgEZOmW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 10:42:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01419;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TzjST-6_1590504120;
Received: from 30.0.168.64(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TzjST-6_1590504120)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 26 May 2020 22:42:00 +0800
Subject: Re: [PATCH] io_uring: create percpu io sq thread when
 IORING_SETUP_SQ_AFF is flagged
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com, yujian.wu1@gmail.com
References: <20200520115648.6140-1-xiaoguang.wang@linux.alibaba.com>
 <3bea8be7-2a82-cf24-a8b6-327672a64535@gmail.com>
 <242c17f3-b9b3-30cb-ff3d-a33aeef36ad1@linux.alibaba.com>
 <13dd7a1f-63df-6a0c-74ed-d5ff12a0bf96@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <c077a2dc-7b69-5ee4-24a3-3dd3df57b201@linux.alibaba.com>
Date:   Tue, 26 May 2020 22:42:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <13dd7a1f-63df-6a0c-74ed-d5ff12a0bf96@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 22/05/2020 11:33, Xiaoguang Wang wrote:
>> hi Pavel,
>>
>> First thanks for reviewing!
> 
> sure, you're welcome!
> 
>>> On 20/05/2020 14:56, Xiaoguang Wang wrote:
>>>>
>>>> To fix this issue, when io_uring instance uses IORING_SETUP_SQ_AFF to specify a
>>>> cpu,  we create a percpu io sq_thread to handle multiple io_uring instances' io
>>>> requests serially. With this patch, in same environment, we get a huge
>>>> improvement:
>>>
>>> Consider that a user can issue a long sequence of requests, say 2^15 of them,
>>> and all of them will happen in a single call to io_submit_sqes(). Just preparing
>>> them would take much time, apart from that it can do some effective work for
>>> each of them, e.g. copying a page. And now there is another io_uring, caring
>>> much about latencies and nevertheless waiting for _very_ long for its turn.
>> Indeed I had thought this case before and don't clearly know how to optimize it
>> yet.
>> But I think if user has above usage scenarios, they probably shouldn't make
>> io_uring
>> instances share same cpu core. I'd like to explain more about our usage scenarios.
> 
> IIRC, you create _globally_ available per-cpu threads, so 2 totally independent
> users may greatly affect each other, e.g. 2 docker containers in a hosted
> server, and that would be nasty. But if it's limited to a "single user", it'd be
> fine by me, see below for more details.Not sure I follow you.
You say "2 totally independent users may greatly affect each other", can you explain more?
With this patch, if user A and user B's io_uring instances are bound to same cpu core,
say 10, this patch will only create one io_sq_thread for cpu 10, then user A and user B
can share it. If their io_uring instance are bound to different cpu cores, I think user A
and user B won't affect each orther.

> 
> BTW, out of curiosity, what's the performance\latency impact of disabling SQPOLL
> at all for your app? Say, comparing with non contended case.
Sorry, our application based on io_uring is still under development, When it's ready
later, I'll show more information.

> 
>> In a physical machine, say there are 96 cores, and it runs multiple cgroups, every
>> cgroup run same application and will monopoly 16 cpu cores. This application will
>> create 16 io threads and every io thread will create an io_uring instance and every
>> thread will be bound to a different cpu core, these io threads will receive io
>> requests.
>> If we enable SQPOLL for these io threads, we allocate one or two cpu cores for
>> these
>> io_uring instances at most, so they must share allocated cpu core. It's totally
>> disaster
>> that some io_uring instances' busy loop in their sq_thread_idle period will
>> impact other
>> io_uring instances which have io requests to handle.
>>
>>>
>>> Another problem is that with it a user can't even guess when its SQ would be
>>> emptied, and would need to constantly poll.
>> In this patch, in every iteration, we only handle io requests already queued,
>> will not constantly poll.
> 
> I was talking about a user polling _from userspace_ its full SQ, to understand
> when it can submit more. That's if it doesn't want to wait for CQEs yet for some
> reason (e.g. useful for net apps).
> 
>>
>>>
>>> In essence, the problem is in bypassing thread scheduling, and re-implementing
>>> poor man's version of it (round robin by io_uring).
>> Yes :) Currently I use round robin strategy to handle multiple io_uring instance
>> in every iteration.
>>
>>> The idea and the reasoning are compelling, but I think we need to do something
>>> about unrelated io_uring instances obstructing each other. At least not making
>>> it mandatory behaviour.
>>>
>>> E.g. it's totally fine by me, if a sqpoll kthread is shared between specified
>>> bunch of io_urings -- the user would be responsible for binding them and not
>>> screwing up latencies/whatever. Most probably there won't be much (priviledged)
>>> users using SQPOLL, and they all be a part of a single app, e.g. with
>>> multiple/per-thread io_urings.
>> Did you read my patch? In this patch, I have implemented this idea :)
> 
> Took a glance, may have overlooked things. I meant to do as in your patch, but
> not sharing threads between ALL io_uring in the system, but rather between a
Yes, I don't try to make all io_uring instances in the system share threads, I just
make io_uring instances which are bound to same cpu core, share one io_sq_thread that
only is created once for every cpu core.
Otherwise in current io_uring mainline codes, we'd better not bind different io_uring
instances to same cpu core,  some instances' busy loop in its sq_thread_idle period will
impact other instanes who currently there are reqs to handle.

> specified set of them. In other words, making yours @percpu_threads not global,
> but rather binding to a set of io_urings.
> 
> e.g. create 2 independent per-cpu sets of threads. 1st one for {a1,a2,a3}, 2nd
> for {b1,b2,b3}.
> 
> a1 = create_uring()
> a2 = create_uring(shared_sq_threads=a1)
> a3 = create_uring(shared_sq_threads=a1)
> 
> b1 = create_uring()
> b2 = create_uring(shared_sq_threads=b1)
> b3 = create_uring(shared_sq_threads=b1)
Thanks your suggestions, I'll try to consider it in V2 patch.

But I still have one question: now "shared_sq_threads=a1" and "shared_sq_threads=b1"
can be bound to same cpu core? I think it's still not efficient. E.g. "shared_sq_threads=a1"
busy loop in its sq_thread_idle period will impact shared_sq_threads=b1 who currently
there are reqs to handle.

Now I also wonder whether a io_uring instance,which has SQPOLL enabed and does not
specify a sq_thread_cpu, can be used in real business environment, the io_sq_thread
may run in any cpu cores, which may affect any other application, e.g. cpu resource
contend. So if trying to use SQPOLL, we'd better allocate specified cpu.

Regards,
Xiaoguang Wang

> 
> And then:
> - it somehow solves the problem. As long as it doesn't effect much other users,
> it's ok to let userspace screw itself by submitting 2^16 requests.
> 
> - there is still a problem with a simple round robin. E.g. >100 io_urings per
> such set. Even though, a user may decide for itself, it worth to think about. I
> don't want another scheduling framework here. E.g. first round-robin, then
> weighted one, etc.
> 
> - it's actually not a set of threads (i.e. per-cpu) the API should operate on,
> but just binding io_urings to a single SQPOLL thread.
> 
> - there is no need to restrict it to cpu-pinned case >
>>>
>>> Another way would be to switch between io_urings faster, e.g. after processing
>>> not all requests but 1 or some N of them. But that's very thin ice, and I
>>> already see other bag of issues.
>> Sounds good, could you please lift detailed issues? Thanks.
> 
> Sounds terrible, TBH. Especially with arbitrary length links.
> 
> 
