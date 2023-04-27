Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33DD6F059D
	for <lists+io-uring@lfdr.de>; Thu, 27 Apr 2023 14:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243760AbjD0MRj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Apr 2023 08:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243885AbjD0MRg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Apr 2023 08:17:36 -0400
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CED3E4F;
        Thu, 27 Apr 2023 05:17:34 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Vh7USU._1682597850;
Received: from 30.221.148.223(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Vh7USU._1682597850)
          by smtp.aliyun-inc.com;
          Thu, 27 Apr 2023 20:17:31 +0800
Message-ID: <3e04dbdc-335a-8cc1-f1e2-72e395700da6@linux.alibaba.com>
Date:   Thu, 27 Apr 2023 20:17:30 +0800
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
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <ZEkxUG4AUcBQKfdr@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.3 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On Wed, Apr 26, 2023 at 09:19:57PM +0800, Xiaoguang Wang wrote:
>> hi all,
>>
>> Recently we start to test nvme passthrough feature, which is based on io_uring. Originally we
>> thought its performance would be much better than normal polled nvme test, but test results
>> show that it's not:
>> $ sudo taskset -c 1 /home/feiman.wxg/fio/t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -O0 -n1  -u1 /dev/ng1n1
>> IOPS=891.49K, BW=435MiB/s, IOS/call=32/31
>> IOPS=891.07K, BW=435MiB/s, IOS/call=31/31
>>
>> $ sudo taskset -c 1 /home/feiman.wxg/fio/t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -O1 -n1 /dev/nvme1n1
>> IOPS=807.81K, BW=394MiB/s, IOS/call=32/31
>> IOPS=808.13K, BW=394MiB/s, IOS/call=32/32
>>
>> about 10% iops improvement, I'm not saying its not good, just had thought it should
>> perform much better.
> What did you think it should be? What is the maximum 512b read IOPs your device
> is capable of producing?
From the naming of this feature, I thought it would bypass blocker thoroughly, hence
would gain much higher performance, for myself, if this feature can improves 25% higher
or more, that would be much more attractive, and users would like to try it. Again, I'm
not saying this feature is not good, just thought it would perform much better for small io.

My test environment has one intel p4510 nvme ssd and one intel p4800x nvme ssd.
According to spec, p4510 's rand read iops is about 640000, and p4800x is 550000.
To maximizing device performance, I'll do one discard before test, that is
sudo blkdiscard /dev/nvme0n1 or /dev/nvme1n1.

In 6.3.0-rc2, taskset -c 1 /home/feiman.wxg/fio/t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -O0 -n1  -u1 /dev/ng1n1
shows 890k iops. I modified codes a bit to get rid of blkcg overhead, iops will increase 920k.
And if I benchmark /dev/ng0n1 and /dev/ng1n1 at the same time, total iops would be
about 1150k, cannot utilize the maximum capacity of these two devices.

>
>> After reading codes, I finds that this nvme passthrough feature
>> is still based on blk-mq, use perf tool to analyse and there are some block layer
>> overheads that seems somewhat big:
>> 1. 2.48%  io_uring  [kernel.vmlinux]  [k] blk_stat_add
>> In our kernel config, no active ﻿q->stats->callbacks, but still has this overhead.
>>
>> 2. 0.97%  io_uring  [kernel.vmlinux]  [k] bio_associate_blkg_from_css
>>     0.85%  io_uring  [kernel.vmlinux]  [k] bio_associate_blkg
>>     0.74%  io_uring  [kernel.vmlinux]  [k] blkg_lookup_create
>> For nvme passthrough feature, it tries to dispatch nvme commands to nvme
>> controller directly, so should get rid of these overheads.
>>
>> 3. 3.19%  io_uring  [kernel.vmlinux]  [k] __rcu_read_unlock
>>     2.65%  io_uring  [kernel.vmlinux]  [k] __rcu_read_lock
>> Frequent rcu_read_lock/unlcok overheads, not sure whether we can improve a bit.
>>
>> 4. 7.90%  io_uring  [nvme]            [k] nvme_poll
>>     3.59%  io_uring  [nvme_core]       [k] nvme_ns_chr_uring_cmd_iopoll
>>     2.63%  io_uring  [kernel.vmlinux]  [k] blk_mq_poll_classic
>>     1.88%  io_uring  [nvme]            [k] nvme_poll_cq
>>     1.74%  io_uring  [kernel.vmlinux]  [k] bio_poll
>>     1.89%  io_uring  [kernel.vmlinux]  [k] xas_load
>>     0.86%  io_uring  [kernel.vmlinux]  [k] xas_start
>>     0.80%  io_uring  [kernel.vmlinux]  [k] xas_start
>> Seems that the block poll operation call chain is somewhat deep, also
> It's not really that deep, though the xarray lookups are unfortunate.
>
> And if you were to remove block layer, it looks like you'd end up just shifting
> the CPU utilization to a different polling function without increasing IOPs.
> Your hardware doesn't look fast enough for this software overhead to be a
> concern.
No, I may not agree with you here, sorry. Real products(not like t/io_uring tools,
which just polls block layer when ios are issued) will have many other work
to run, such as network work. If we can cut the nvme passthrough overhead more,
saved cpu will use to do other useful work.

For example, some produces would poll storage and network, if we can reduce
poll storage quicker, we can poll network earlier, which may reduce network
latency. As I said in below section, If we can map nvme cqes to user space, we
may check whether io has been completed in user space, only do kernel block iopoll
necessary.

>
>> not sure whether we can improve it a bit, and the xas overheads also
>> looks big, it's introduced by https://lore.kernel.org/all/20220307064401.30056-7-ming.lei@redhat.com/
>> which fixed one use-after-free bug.
>>
>> 5. other blocker overhead I don't spend time to look into.
>>
>> Some of our clients are interested in nvme passthrough feature, they visit
>> nvme devices by open(2) and read(2)/write(2) nvme device files directly, bypass
>> filesystem, so they'd like to try nvme passthrough feature, to gain bigger iops, but
>> currenty performance seems not that good. And they don't want to use spdk yet,
>> still try to build fast storage based on linux kernel io stack for various reasons  :)
>>
>> So I'd like to propose a new nvme passthrough design here, which may improve
>> performance a lot. Here are just rough design ideas here, not start to code yet.
>>   1. There are three types of nvme hardware queues, "default", "write" and "poll",
>> currently all these queues are visible to block layer, blk-mq will map these queues
>> properly.  Here this new design will add two new nvme hardware queues, name them
>> "user_irq" and "user_poll" queues, which will need to add two nvme module parameters,
>> similar to current "write_queues" and "poll_queues".
>>   2. "user_irq" and "user_poll" queues will not be visible to block layer, and will create
>> corresponding char device file for them,  that means nvme hardware queues will be
>> abstracted as linux file, not sure whether to support read_iter or write_iter, but
>> uring_cmd() interface will be supported firstly. user_irq queue will still have irq, user_poll
>> queue will support poll.
>>   3. Finally the data flow will look like below in example of user_irq queue:
>> io issue: io_uring  uring_cmd >> prep nvme command in its char device's uring_cmd() >> submit to nvme.
>> io reap: find io_uring request by nvme command id, and call uring_cmd_done for it.
>> Yeah, need to build association between io_uring request and nvme command id.
>>
>> Possible advantages:
>> 1. Bypass block layer thoroughly.
> blk-mq has common solutions that we don't want to duplicate in driver. It
> provides safe access to shared tags across multiple processes, ensures queue
> live-ness during a controller reset, tracks commands for timeouts, among other
> things.
Yeah, I agree there will be some duplicate functionality with blk-mq,
not start to do detailed design yet(will do later), but I think there maybe
not much. I'd like to implement prototype firstly for you to review, to see
what performance we can get. If performance data is really impressive, I
think it maybe deserve the duplicate.

Regards,
Xiaoguang Wang

