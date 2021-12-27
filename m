Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1355F47F9F5
	for <lists+io-uring@lfdr.de>; Mon, 27 Dec 2021 04:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhL0D13 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 26 Dec 2021 22:27:29 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:40236 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230347AbhL0D13 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 26 Dec 2021 22:27:29 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V.pJDMk_1640575646;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V.pJDMk_1640575646)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Dec 2021 11:27:27 +0800
Subject: Re: [POC RFC 0/3] support graph like dependent sqes
To:     Christian Dietrich <stettberger@dokucode.de>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
        horst.schirmeier@tu-dresden.de,
        "Franz-B. Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Hendrik Sieck <hendrik.sieck@tuhh.de>
References: <20211214055734.61702-1-haoxu@linux.alibaba.com>
 <s7by24bd49y.fsf@dokucode.de>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <78dbcb47-edde-2d44-a095-e53469634926@linux.alibaba.com>
Date:   Mon, 27 Dec 2021 11:27:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <s7by24bd49y.fsf@dokucode.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/12/23 下午6:06, Christian Dietrich 写道:
> Hi everyone!
> 
> We experimented with the BPF patchset provided by Pavel a few months
> ago. And I had the exact same question: How can we compare the benefits
> and drawbacks of a more flexible io_uring implementation? In that
> specific use case, I wanted to show that a flexible SQE-dependency
> generation with BPF could outperform user-space SQE scheduling. From my
> experience with BPF, I learned that it is quite hard to beat
> io_uring+userspace, if there is enough parallelism in your IO jobs.
> 
> For this purpose, I've built a benchmark generator that is able to
> produce random dependency graphs of various shapes (isolated nodes,
> binary tree, parallel-dependency chains, random DAC) and different
> scheduling backends (usual system-call backend, plain io_uring,
> BPF-enhanced io_uring) and different workloads.
> 
> At this point, I didn't have the time to polish the generator and
> publish it, but I put the current state into this git:
> 
> https://collaborating.tuhh.de/e-exk4/projects/syscall-graph-generator
> 
> After running:
> 
>      ./generate.sh
>      [sudo modprobe null_blk...]
>      ./run.sh
>      ./analyze.py
> 
> You get the following results (at least if you own my machine):
> 
> generator              iouring      syscall      iouring_norm
> graph action size
> chain read   128    938.563366  2019.199010   46.48%
> flat  read   128    922.132673  2011.566337   45.84%
> graph read   128   1129.017822  2021.905941   55.84%
> rope  read   128   2051.763366  2014.563366  101.85%
> tree  read   128   1049.427723  2015.254455   52.07%
> 
Hi Christian,
Great! Thanks for the testing, a question here: the first generator
iouring means BPF-enhanced iouring?
> For the userspace scheduler, I perform an offline analysis that finds
> linear chains of operations that are not (anymore) dependent on other previous
> unfinished results. These linear chains are then pushed into io_uring
> with a SQE-link chain.
> 
> As I'm highly interested in this topic of pushing complex
> IO-dependencies into the kernel space, I would be delighted to see how
> your SQE-graph extension would compare against my rudimentary userspace
> scheduler.
> 
> @Hao: Do you have a specific use case for your graph-like dependencies
>        in mind? If you need assistance with the generator, please feel
>        free to contact me.
I currently don't have a specifuc use case, just feel this may be useful
since there are simple cases like open-->parallel reads->close that
linear dependency doesn't apply, so this POC is sent more like to get
people's thought about user cases..
Thanks again for the benchmark, I'll leverage it to test my approach
though a bit busy with other work recently..

Regards,
Hao
> 
> chris
> 

