Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880D6400167
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 16:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349113AbhICOpC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 10:45:02 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:50565 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349502AbhICOpC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 10:45:02 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Un6xNvp_1630680239;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Un6xNvp_1630680239)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 03 Sep 2021 22:43:59 +0800
Subject: Re: [PATCH v4 0/2] refactor sqthread cpu binding logic
To:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>,
        Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, cgroups@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
 <20210902164808.GA10014@blackbody.suse.cz>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <b78d63d1-1cd8-a6d0-c26e-3d6c270abbb4@linux.alibaba.com>
Date:   Fri, 3 Sep 2021 22:43:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210902164808.GA10014@blackbody.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/3 上午12:48, Michal Koutný 写道:
> Hello Hao.
> 
> On Wed, Sep 01, 2021 at 08:43:20PM +0800, Hao Xu <haoxu@linux.alibaba.com> wrote:
>> This patchset is to enhance sqthread cpu binding logic, we didn't
>> consider cgroup setting before. In container environment, theoretically
>> sqthread is in its container's task group, it shouldn't occupy cpu out
>> of its container.
> 
> I see in the discussions that there's struggle to make
> set_cpus_allowed_ptr() do what's intended under the given constraints.
> 
> IIUC, set_cpus_allowed_ptr() is conventionally used for kernel threads
> [1]. But does the sqthread fall into this category? You want to have it
> _directly_ associated with a container and its cgroups. It looks to me
sqthread is in it's creator's task group, so it is like a userspace
thread from this perspective. When it comes to container environemt
sqthread naturely belongs to a container which also contains its creator
And it has same cgroup setting with it's creator by default.
> more like a userspace thread (from this perspective, not literally). Or
> is there a different intention?
> 
> It seems to me that reusing the sched_setaffinity() (with all its
> checks and race pains/solutions) would be a more universal approach.
> (I don't mean calling sched_setaffinity() directly, some parts would
> need to be factored separately to this end.) WDYT?
> 
> 
> Regards,
> Michal
> 
> [1] Not only spending their life in kernel but providing some
> delocalized kernel service.
> 

