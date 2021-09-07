Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864FF402EF3
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 21:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240940AbhIGTaB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 15:30:01 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:40862 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229574AbhIGT36 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Sep 2021 15:29:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Uncl1PM_1631042928;
Received: from 30.30.107.109(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uncl1PM_1631042928)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 Sep 2021 03:28:49 +0800
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
 <c49d9b26-1c74-316a-c933-e6964695a286@linux.alibaba.com>
 <YTeZUnshr+mgf5GS@slm.duckdns.org>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <f7ae868d-0997-8e94-53a3-a5d6513f7447@linux.alibaba.com>
Date:   Wed, 8 Sep 2021 03:28:48 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YTeZUnshr+mgf5GS@slm.duckdns.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/8 上午12:54, Tejun Heo 写道:
> Hello,
> 
> On Fri, Sep 03, 2021 at 11:04:07PM +0800, Hao Xu wrote:
>>> Would it make sense to just test whether set_cpus_allowed_ptr() succeeded
>>> afterwards?
>> Do you mean: if (sqd->sq_cpu != -1 && !set_cpus_allowed_ptr(current,
>> cpumask_of(sqd->sq_cpu)))
>>
>> I'm not familiar with set_cpus_allowed_ptr(), you mean it contains the
>> similar logic of test_cpu_in_current_cpuset?
> 
> It's kinda muddy unfortunately. I think it rejects if the target cpu is
> offline but accept and ignores if the cpu is excluded by cpuset.
> 
>> This is a bit beyond of my knowledge, so you mean if the cpu back
>> online, the task will automatically schedule to this cpu? if it's true,
>> I think the code logic here is fine.
>>
>>> offline and online. If the operation takes place while the cpu happens to be
>>> offline, the operation fails.
>> It's ok that it fails, we leave the option of retry to users themselves.
> 
> I think the first thing to do is defining the desired behavior, hopefully in
> a consistent manner, rather than letting it be defined by implementation.
> e.g. If the desired behavior is the per-cpu helper failing, then it should
> probably exit when the target cpu isn't available for whatever reason. If
> the desired behavior is best effort when cpu goes away (ie. ignore
Hmm, I see. First I think we should move the set_cpus_allowed_ptr() to
sqthread creation place not when it is running(not sure why it is
currently at the beginning of sqthred itself), then we can have
consistent behaviour.(if we do the check at sqthread's running time,
then no matter we kill it or still allow it to run when cpu_online
check fails, it's hard to let users know the result of their cpu binding
since users don't know the exact time when sqthread waken up and begin
to run, so that they can check their cpu binding result).
Second, I think users' cpu binding is a kind of 'advice', not 'command'.
So no matter cpu_online check succeeds or fails, we still let sqthread
run, meanwhile return the cpu binding result to the userspace.
Anyway, I'd like to know Jens' thoughts on this.
> affinity), the creation likely shouldn't fail when the target cpu is
> unavailable but can become available in the future.
> 
> Thanks.
> 

