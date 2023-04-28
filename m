Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685696F107B
	for <lists+io-uring@lfdr.de>; Fri, 28 Apr 2023 04:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjD1Cmj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Apr 2023 22:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjD1Cmi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Apr 2023 22:42:38 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3795F26A6;
        Thu, 27 Apr 2023 19:42:36 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Vh9QPcX_1682649752;
Received: from 30.221.147.121(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Vh9QPcX_1682649752)
          by smtp.aliyun-inc.com;
          Fri, 28 Apr 2023 10:42:33 +0800
Message-ID: <4ab4b11f-d775-1c75-127a-c62535de897b@linux.alibaba.com>
Date:   Fri, 28 Apr 2023 10:42:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: another nvme pssthrough design based on nvme hardware queue file
 abstraction
Content-Language: en-US
To:     Keith Busch <kbusch@kernel.org>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <24179a47-ab37-fa32-d177-1086668fbd3d@linux.alibaba.com>
 <ZEkxUG4AUcBQKfdr@kbusch-mbp.dhcp.thefacebook.com>
 <3e04dbdc-335a-8cc1-f1e2-72e395700da6@linux.alibaba.com>
 <ZEqOy6oFp7tc06dH@kbusch-mbp.dhcp.thefacebook.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <ZEqOy6oFp7tc06dH@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.3 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On Thu, Apr 27, 2023 at 08:17:30PM +0800, Xiaoguang Wang wrote:
>>> On Wed, Apr 26, 2023 at 09:19:57PM +0800, Xiaoguang Wang wrote:
>>>> hi all,
>>>>
>>>> Recently we start to test nvme passthrough feature, which is based on io_uring. Originally we
>>>> thought its performance would be much better than normal polled nvme test, but test results
>>>> show that it's not:
>>>> $ sudo taskset -c 1 /home/feiman.wxg/fio/t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -O0 -n1  -u1 /dev/ng1n1
>>>> IOPS=891.49K, BW=435MiB/s, IOS/call=32/31
>>>> IOPS=891.07K, BW=435MiB/s, IOS/call=31/31
>>>>
>>>> $ sudo taskset -c 1 /home/feiman.wxg/fio/t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -O1 -n1 /dev/nvme1n1
>>>> IOPS=807.81K, BW=394MiB/s, IOS/call=32/31
>>>> IOPS=808.13K, BW=394MiB/s, IOS/call=32/32
>>>>
>>>> about 10% iops improvement, I'm not saying its not good, just had thought it should
>>>> perform much better.
>>> What did you think it should be? What is the maximum 512b read IOPs your device
>>> is capable of producing?
>> From the naming of this feature, I thought it would bypass blocker thoroughly, hence
>> would gain much higher performance, for myself, if this feature can improves 25% higher
>> or more, that would be much more attractive, and users would like to try it. Again, I'm
>> not saying this feature is not good, just thought it would perform much better for small io.
> It does bypass the block layer. The driver just uses library functions provided
> by the block layer for things it doesn't want to duplicate. Reimplementing that
> functionality in driver isn't going to improve anything.
>
>>>> In our kernel config, no active ﻿q->stats->callbacks, but still has this overhead.
>>>>
>>>> 2. 0.97%  io_uring  [kernel.vmlinux]  [k] bio_associate_blkg_from_css
>>>>     0.85%  io_uring  [kernel.vmlinux]  [k] bio_associate_blkg
>>>>     0.74%  io_uring  [kernel.vmlinux]  [k] blkg_lookup_create
>>>> For nvme passthrough feature, it tries to dispatch nvme commands to nvme
>>>> controller directly, so should get rid of these overheads.
>>>>
>>>> 3. 3.19%  io_uring  [kernel.vmlinux]  [k] __rcu_read_unlock
>>>>     2.65%  io_uring  [kernel.vmlinux]  [k] __rcu_read_lock
>>>> Frequent rcu_read_lock/unlcok overheads, not sure whether we can improve a bit.
>>>>
>>>> 4. 7.90%  io_uring  [nvme]            [k] nvme_poll
>>>>     3.59%  io_uring  [nvme_core]       [k] nvme_ns_chr_uring_cmd_iopoll
>>>>     2.63%  io_uring  [kernel.vmlinux]  [k] blk_mq_poll_classic
>>>>     1.88%  io_uring  [nvme]            [k] nvme_poll_cq
>>>>     1.74%  io_uring  [kernel.vmlinux]  [k] bio_poll
>>>>     1.89%  io_uring  [kernel.vmlinux]  [k] xas_load
>>>>     0.86%  io_uring  [kernel.vmlinux]  [k] xas_start
>>>>     0.80%  io_uring  [kernel.vmlinux]  [k] xas_start
>>>> Seems that the block poll operation call chain is somewhat deep, also
>>> It's not really that deep, though the xarray lookups are unfortunate.
>>>
>>> And if you were to remove block layer, it looks like you'd end up just shifting
>>> the CPU utilization to a different polling function without increasing IOPs.
>>> Your hardware doesn't look fast enough for this software overhead to be a
>>> concern.
>> No, I may not agree with you here, sorry. Real products(not like t/io_uring tools,
>> which just polls block layer when ios are issued) will have many other work
>> to run, such as network work. If we can cut the nvme passthrough overhead more,
>> saved cpu will use to do other useful work.
> You initiated this thread with supposed underwhelming IOPs improvements from
> the io engine, but now you've shifted your criteria.
Sorry, but how did you come to this conclusion that I have shifted my criteria...
I'm not a native english speaker, may not express my thoughts clearly. And
I forgot to mention that indeed in real products, they may manage more than
one nvme ssd with one cpu(software is taskseted to corresponding cpu), so
I think software overhead would be a concern.

No offense at all, I initiated this thread just to discuss whether we can improve
nvme passthrough performance more. For myself, also need to understand
nvme codes more.
>
> You can always turn off the kernel's stats and cgroups if you don't find them
> useful.
In example of cgroups, do you mean disable CONFIG_BLK_CGROUP?
I'm not sure it will work, a physical machine may have many disk drives,
others drives may need blkcg.

Regards,
Xiaoguang Wang


