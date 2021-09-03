Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1974001AC
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 17:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhICPFK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 11:05:10 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:49378 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229997AbhICPFK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 11:05:10 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Un7GxII_1630681447;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Un7GxII_1630681447)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 03 Sep 2021 23:04:07 +0800
Subject: Re: [PATCH 2/2] io_uring: consider cgroup setting when binding sqpoll
 cpu
To:     Tejun Heo <tj@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, cgroups@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
 <20210901124322.164238-3-haoxu@linux.alibaba.com>
 <YS+tPq1eiQLx4P3M@slm.duckdns.org>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <c49d9b26-1c74-316a-c933-e6964695a286@linux.alibaba.com>
Date:   Fri, 3 Sep 2021 23:04:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YS+tPq1eiQLx4P3M@slm.duckdns.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/2 上午12:41, Tejun Heo 写道:
Hi Tejun,
> Hello,
> 
> On Wed, Sep 01, 2021 at 08:43:22PM +0800, Hao Xu wrote:
>> @@ -7112,11 +7113,9 @@ static int io_sq_thread(void *data)
>>   
>>   	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
>>   	set_task_comm(current, buf);
>> +	if (sqd->sq_cpu != -1 && test_cpu_in_current_cpuset(sqd->sq_cpu))
>>   		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
>> +
> 
> Would it make sense to just test whether set_cpus_allowed_ptr() succeeded
> afterwards?
Do you mean: if (sqd->sq_cpu != -1 && !set_cpus_allowed_ptr(current, 
cpumask_of(sqd->sq_cpu)))

I'm not familiar with set_cpus_allowed_ptr(), you mean it contains the
similar logic of test_cpu_in_current_cpuset?
> 
>> @@ -8310,8 +8309,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
>>   			int cpu = p->sq_thread_cpu;
>>   
>>   			ret = -EINVAL;
>> -			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
>> +			if (cpu >= nr_cpu_ids || !cpu_online(cpu) ||
>> +			    !test_cpu_in_current_cpuset(cpu))
>>   				goto err_sqpoll;
>> +
> 
> Failing operations on transient conditions like this may be confusing. Let's
> ignore cpuset for now. CPU hotplug is sometimes driven automatically for
> power saving purposes, so failing operation based on whether a cpu is online
> means that the success or failure of the operation can seem arbitrary. If
> the operation takes place while the cpu happens to be online, it succeeds
> and the thread gets unbound and rebound automatically as the cpu goes
This is a bit beyond of my knowledge, so you mean if the cpu back
online, the task will automatically schedule to this cpu? if it's true,
I think the code logic here is fine.
> offline and online. If the operation takes place while the cpu happens to be
> offline, the operation fails.
It's ok that it fails, we leave the option of retry to users themselves.
> 
> I don't know what the intended behavior here should be and we haven't been
> pretty bad at defining reasonable behavior around cpu hotplug, so it'd
> probably be worthwhile to consider what the behavior should be.
> 
> Thanks.
> 
Thanks,
Hao

