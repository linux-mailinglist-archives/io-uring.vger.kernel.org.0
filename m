Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2D66EF564
	for <lists+io-uring@lfdr.de>; Wed, 26 Apr 2023 15:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241118AbjDZNUG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Apr 2023 09:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241117AbjDZNUF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Apr 2023 09:20:05 -0400
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFE2A2;
        Wed, 26 Apr 2023 06:20:02 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Vh3W2.4_1682515198;
Received: from 30.221.148.51(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Vh3W2.4_1682515198)
          by smtp.aliyun-inc.com;
          Wed, 26 Apr 2023 21:19:59 +0800
Message-ID: <24179a47-ab37-fa32-d177-1086668fbd3d@linux.alibaba.com>
Date:   Wed, 26 Apr 2023 21:19:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Content-Language: en-US
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: another nvme pssthrough design based on nvme hardware queue file
 abstraction
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi all,

Recently we start to test nvme passthrough feature, which is based on io_uring. Originally we
thought its performance would be much better than normal polled nvme test, but test results
show that it's not:
$ sudo taskset -c 1 /home/feiman.wxg/fio/t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -O0 -n1  -u1 /dev/ng1n1
IOPS=891.49K, BW=435MiB/s, IOS/call=32/31
IOPS=891.07K, BW=435MiB/s, IOS/call=31/31

$ sudo taskset -c 1 /home/feiman.wxg/fio/t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -O1 -n1 /dev/nvme1n1
IOPS=807.81K, BW=394MiB/s, IOS/call=32/31
IOPS=808.13K, BW=394MiB/s, IOS/call=32/32

about 10% iops improvement, I'm not saying its not good, just had thought it should
perform much better. After reading codes, I finds that this nvme passthrough feature
is still based on blk-mq, use perf tool to analyse and there are some block layer
overheads that seems somewhat big:
1. 2.48%  io_uring  [kernel.vmlinux]  [k] blk_stat_add
In our kernel config, no active ﻿q->stats->callbacks, but still has this overhead.

2. 0.97%  io_uring  [kernel.vmlinux]  [k] bio_associate_blkg_from_css
    0.85%  io_uring  [kernel.vmlinux]  [k] bio_associate_blkg
    0.74%  io_uring  [kernel.vmlinux]  [k] blkg_lookup_create
For nvme passthrough feature, it tries to dispatch nvme commands to nvme
controller directly, so should get rid of these overheads.

3. 3.19%  io_uring  [kernel.vmlinux]  [k] __rcu_read_unlock
    2.65%  io_uring  [kernel.vmlinux]  [k] __rcu_read_lock
Frequent rcu_read_lock/unlcok overheads, not sure whether we can improve a bit.

4. 7.90%  io_uring  [nvme]            [k] nvme_poll
    3.59%  io_uring  [nvme_core]       [k] nvme_ns_chr_uring_cmd_iopoll
    2.63%  io_uring  [kernel.vmlinux]  [k] blk_mq_poll_classic
    1.88%  io_uring  [nvme]            [k] nvme_poll_cq
    1.74%  io_uring  [kernel.vmlinux]  [k] bio_poll
    1.89%  io_uring  [kernel.vmlinux]  [k] xas_load
    0.86%  io_uring  [kernel.vmlinux]  [k] xas_start
    0.80%  io_uring  [kernel.vmlinux]  [k] xas_start
Seems that the block poll operation call chain is somewhat deep, also
not sure whether we can improve it a bit, and the xas overheads also
looks big, it's introduced by https://lore.kernel.org/all/20220307064401.30056-7-ming.lei@redhat.com/
which fixed one use-after-free bug.

5. other blocker overhead I don't spend time to look into.

Some of our clients are interested in nvme passthrough feature, they visit
nvme devices by open(2) and read(2)/write(2) nvme device files directly, bypass
filesystem, so they'd like to try nvme passthrough feature, to gain bigger iops, but
currenty performance seems not that good. And they don't want to use spdk yet,
still try to build fast storage based on linux kernel io stack for various reasons  :)

So I'd like to propose a new nvme passthrough design here, which may improve
performance a lot. Here are just rough design ideas here, not start to code yet.
  1. There are three types of nvme hardware queues, "default", "write" and "poll",
currently all these queues are visible to block layer, blk-mq will map these queues
properly.  Here this new design will add two new nvme hardware queues, name them
"user_irq" and "user_poll" queues, which will need to add two nvme module parameters,
similar to current "write_queues" and "poll_queues".
  2. "user_irq" and "user_poll" queues will not be visible to block layer, and will create
corresponding char device file for them,  that means nvme hardware queues will be
abstracted as linux file, not sure whether to support read_iter or write_iter, but
uring_cmd() interface will be supported firstly. user_irq queue will still have irq, user_poll
queue will support poll.
  3. Finally the data flow will look like below in example of user_irq queue:
io issue: io_uring  uring_cmd >> prep nvme command in its char device's uring_cmd() >> submit to nvme.
io reap: find io_uring request by nvme command id, and call uring_cmd_done for it.
Yeah, need to build association between io_uring request and nvme command id.

Possible advantages:
1. Bypass block layer thoroughly.
2. Since now we have file abstraction, it can support mmap operation, we can mmap
nvme hardware queue's cqes to user space, then we can implement a much efficient
poll. We may run nvme_cqe_pending()'s logic in user space, only it shows there are nvme
requests completed, can we enter kernel to reap them. As I said before, current
kernel poll chain looks deep, with this method, we can eliminate much useless iopoll
operation. In my t/io_uring tests, below bpftrace script shows that half of iopoll operations
are useless:
BEGIN
{
    @a = 0;
    @b = 0;
}

kretprobe:nvme_poll
{
    if (retval == 0) {
        @a++;
    } else{
        @b++;
    }
}

3. With file based hardware queue abstraction, we may implement various qos
strategy in user space based queue depth control, or more flexible control, user
space apps can map cpu to hardware queue arbitrarily, not like current blk-mq,
which has fixed map strategy.

Finally, as I said before, current it's just rough ideas, and there will definitely be
overlapping functionality with blk-mq, at least this new char device file needs
to map user space add to pages, then nvme sgls or prps could be set properly.

Any feedback are welcome, thanks.

Regards,
Xiaoguang Wang
