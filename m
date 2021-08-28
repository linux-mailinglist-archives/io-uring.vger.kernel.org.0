Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0310F3FA448
	for <lists+io-uring@lfdr.de>; Sat, 28 Aug 2021 09:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhH1Haa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Aug 2021 03:30:30 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:52346 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233375AbhH1HaX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Aug 2021 03:30:23 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UmKo1gY_1630135771;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UmKo1gY_1630135771)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 28 Aug 2021 15:29:31 +0800
Subject: Re: [PATCH for-5.15 v2] io_uring: consider cgroup setting when
 binding sqpoll cpu
To:     Tejun Heo <tj@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, cgroups@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Waiman Long <longman@redhat.com>
References: <20210827141315.235974-1-haoxu@linux.alibaba.com>
 <YSkgKN/LviOvmeVH@slm.duckdns.org>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <0ceebbaa-a5ce-1e85-4be2-95331bca34ef@linux.alibaba.com>
Date:   Sat, 28 Aug 2021 15:29:31 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YSkgKN/LviOvmeVH@slm.duckdns.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/28 上午1:26, Tejun Heo 写道:
> Hello,
> 
> On Fri, Aug 27, 2021 at 10:13:15PM +0800, Hao Xu wrote:
>> +static int io_sq_bind_cpu(int cpu)
>> +{
>> +	if (!test_cpu_in_current_cpuset(cpu))
>> +		pr_warn("sqthread %d: bound cpu not allowed\n", current->pid);
>> +	else
>> +		set_cpus_allowed_ptr(current, cpumask_of(cpu));
>> +
>> +	return 0;
>> +}
> ...
>> @@ -8208,8 +8217,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
>>   			int cpu = p->sq_thread_cpu;
>>   
>>   			ret = -EINVAL;
>> -			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
>> +			if (cpu >= nr_cpu_ids || !cpu_online(cpu) ||
>> +			    !test_cpu_in_current_cpuset(cpu))
>>   				goto err_sqpoll;
> 
> Given that sq_thread is user-like thread and belongs to the right cgroup,
> I'm not quite sure what the above achieves - the affinities can break
A user of io_uring can pass a cpu id to the kernel to indicate which cpu
the sq_thread should be bound to.
> anytime, so one-time check doesn't really solve the problem. All it seems to
Yes, this a problem.
> add is warning messages. What's the expected behavior when an io thread
> can't run on the target cpu anymore?
A user binds sqthread to some cpu due to some reason which we may not
know, so if the target cpu isn't available anymore, I think cpuset of
sqthread should be as same as the task group's it sits, since we don't
know which cpu we should re-bind it to. And this is the current
behavior. I think Jens knows this question better than I do, Jens?

> 
> Thanks.
> 

