Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1DF3FA434
	for <lists+io-uring@lfdr.de>; Sat, 28 Aug 2021 09:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbhH1HLf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Aug 2021 03:11:35 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:36402 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233348AbhH1HLf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Aug 2021 03:11:35 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UmKo.Gp_1630134642;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UmKo.Gp_1630134642)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 28 Aug 2021 15:10:43 +0800
Subject: Re: [PATCH for-5.15 v2] io_uring: consider cgroup setting when
 binding sqpoll cpu
To:     Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>,
        Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, cgroups@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210827141315.235974-1-haoxu@linux.alibaba.com>
 <0988b0dc-232f-80cd-c984-2364c0dee69f@kernel.dk>
 <592ba01a-a128-f781-d920-2b480f91c451@linux.alibaba.com>
 <d413acfe-333a-9b7d-aba8-6e99db376fd6@linux.alibaba.com>
 <9028a8de-a290-a955-1eac-43bec6e8702d@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <33f674a7-8332-7dd6-6694-e5e9e5a5884f@linux.alibaba.com>
Date:   Sat, 28 Aug 2021 15:10:42 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <9028a8de-a290-a955-1eac-43bec6e8702d@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/28 上午1:09, Jens Axboe 写道:
> On 8/27/21 11:03 AM, Hao Xu wrote:
>> 在 2021/8/28 上午12:57, Hao Xu 写道:
>>> 在 2021/8/27 下午10:18, Jens Axboe 写道:
>>>> On 8/27/21 8:13 AM, Hao Xu wrote:
>>>>> Since sqthread is userspace like thread now, it should respect cgroup
>>>>> setting, thus we should consider current allowed cpuset when doing
>>>>> cpu binding for sqthread.
>>>>
>>>> In general, this looks way better than v1. Just a few minor comments
>>>> below.
>>>>
>>>>> @@ -7000,6 +7001,16 @@ static bool io_sqd_handle_event(struct
>>>>> io_sq_data *sqd)
>>>>>        return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
>>>>>    }
>>>>> +static int io_sq_bind_cpu(int cpu)
>>>>> +{
>>>>> +    if (!test_cpu_in_current_cpuset(cpu))
>>>>> +        pr_warn("sqthread %d: bound cpu not allowed\n", current->pid);
>>>>> +    else
>>>>> +        set_cpus_allowed_ptr(current, cpumask_of(cpu));
>>>>> +
>>>>> +    return 0;
>>>>> +}
>>>>
>>>> This should not be triggerable, unless the set changes between creation
>>>> and the thread being created. Hence maybe the warn is fine. I'd probably
>>>> prefer terminating the thread at that point, which would result in an
>>>> -EOWNERDEAD return when someone attempts to wake the thread.
>>>>
>>>> Which is probably OK, as we really should not hit this path.
>>> Actually I think cpuset change offen happen in container environment(
>>> at leaset in my practice), eg. by resource monitor and balancer. So I
>>> did this check to make sure we are still maintain sq_cpu logic at that
>>> time as possible as we can. Though the problem is still there during
>>> sqthread running time(the cpuset can change at anytime, which changes
>>> the cpumask of sqthread)
>> And because the cpumask of sqthread may be changed by the cgroup cpuset
>> change at any time, so here I just print a warnning rather than
>> terminating sqthread due to this 'normal thing'..
> 
> Do we even want the warning then? If it's an expected thing, seems very
> annoying to warn about it.Hmm, there are several things:
1) cpuset change may happen several times a day on some environment, so
it doesn't make sense to exit
2) there won't be big chance that the cpuset change happen between
sqthread creation and waken up. So there probably won't be many
warnning.
3) Though we can warn about cpuset change in case 2), but we cannot warn
at the sqthread running time (when it's in while loop) when cpuset
change. And I don't think we should do cpu check and re-binding from
time to time in sqthread. Good thing is users can get this info in
userspace on their own.
So maybe you're right, we should remove this warnning since it doesn't
raise up just for 2), not for all cases, and users can get to know the
situation by taskset command. Jens, What do you think?

> 

