Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F43A1A9FE6
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2020 14:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409836AbgDOMSr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Apr 2020 08:18:47 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:37841 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S368858AbgDOMSp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Apr 2020 08:18:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0TvcGRQr_1586953104;
Received: from 30.225.32.94(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TvcGRQr_1586953104)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 15 Apr 2020 20:18:25 +0800
Subject: Re: Should io_sq_thread belongs to specific cpu, not io_uring
 instance
To:     Yu Jian Wu <yujian.wu1@gmail.com>, io-uring@vger.kernel.org,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        joseph qi <joseph.qi@linux.alibaba.com>,
        asaf.cidon@columbia.edu, stutsman@cs.utah.edu
References: <16ed5a58-e011-97f3-0ed7-e57fa37cede1@linux.alibaba.com>
 <e876a7e8-982b-a193-f4dc-56e7e990b7c5@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <c94098d2-279e-a552-91ec-8a8f177d770a@linux.alibaba.com>
Date:   Wed, 15 Apr 2020 20:18:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e876a7e8-982b-a193-f4dc-56e7e990b7c5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> 
> On 4/14/20 9:08 AM, Xiaoguang Wang wrote:
>> hi，
>>
>> Currently we can create multiple io_uring instances which all have SQPOLL
>> enabled and make them run in the same cpu core by setting sq_thread_cpu
>> argument, but I think this behaviour maybe not efficient. Say we create two
>> io_uring instances, which both have sq_thread_cpu set to 1 and sq_thread_idle
>> set to 1000 milliseconds, there maybe such scene below:
>>    For example, in 0-1s time interval, io_uring instance0 has neither sqes
>> nor cqes, so it just busy waits for new sqes in 0-1s time interval, but
>> io_uring instance1 have work to do, submitting sqes or polling issued requests,
>> then io_uring instance0 will impact io_uring instance1. Of cource io_uring
>> instance1 may impact iouring instance0 as well, which is not efficient. I think
>> the complete disorder of multiple io_uring instances running in same cpu core is
>> not good.
>>
>> How about we create one io_sq_thread for user specified cpu for multiple io_uring
>> instances which try to share this cpu core, that means this io_sq_thread does not
>> belong to specific io_uring instance, it belongs to specific cpu and will
>> handle requests from mulpile io_uring instance, see simple running flow:
>>    1, for cpu 1, now there are no io_uring instances bind to it, so do not create io_sq_thread
>>    2, io_uring instance1 is created and bind to cpu 1, then create cpu1's io_sq_thread
>>    3, io_sq_thread will handle io_uring instance1's requests
>>    4, io_uring instance2 is created and bind to cpu 1, since there are already an
>>       io_sq_thread for cpu 1, will not create an io_sq_thread for cpu1.
>>    5. now io_sq_thread in cpu1 will handle both io_uring instances' requests.
>>
>> What do you think about it? Thanks.
>>
>> Regards,
>> Xiaoguang Wang
>>
> Hi Xiaoguang,
> 
> We (a group of researchers at Utah and Columbia) are currently trying that right now.
Cool, thanks, let me explain more why we need this feature :)
Cpu is a much more important resource. Say a physical machine has 96 cores,
if we run many io_uring instances which all have sqpoll enabled, indeed we
can only allocate a small number of cpus to io_sq_thread, so sharing cpu to
poll is valuable.

> 
> We have an initial prototype going, and we are assessing the performance impact now to see if we can see gains. Basically, have a rcu-list of io_uring_ctx and then traverse the list and do work in a shared io_sq_thread. We are starting experiments on a machine with fast SSDs where we hope to see some performance benefits.
You can try this test case to assessing the performance :)
   1. create two io_uring instances, which both have sqpoll enabled, set
sq_thread_idle to 1000ms and bind to same cpu core.
   2. one io_uring instance just sends one io request per 500ms, which will
make this instance's io_sq_thead always contend for the cpu.
   3. another io_uring instance issues io requests continually, so this
instance's io_sq_thread will also contend for the cpu.
In current io_uring implementation, I think the second io_uring instance will
be impacted by the first io_uring instance.

> 
> We will send the list of patches soon, once we are sure the approach works and we finish cleaning it up. (There is a subtlety of what to do with the timeouts and resched() when not pinning.)
> 
> We'll keep you in the loop on any updates. Feel free to contact any of us.
OK, thanks.

Regards,
Xiaoguang Wang
> 
> Thanks,
> 
> Yu Jian Wu
> 
