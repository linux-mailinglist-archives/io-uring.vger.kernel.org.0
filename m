Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8CF6EF60B
	for <lists+io-uring@lfdr.de>; Wed, 26 Apr 2023 16:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240801AbjDZOMi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Apr 2023 10:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjDZOMh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Apr 2023 10:12:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507E76A79;
        Wed, 26 Apr 2023 07:12:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0A5863671;
        Wed, 26 Apr 2023 14:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66D5C433D2;
        Wed, 26 Apr 2023 14:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682518355;
        bh=7OXT3YuCJUY3llu7VSfiw6P+rLFiJggThGRt+RH+Zw0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zf+AvvTjpI2OLx+aN1CbMkHsD/dskLxeqlmtQQM7iySMvxqhQjMKUMYSXRXWCmR1u
         3d1lTuYDBKo+ePjmqlSgbz917/mFHozi8UiwG4oEIasNLLXUbnSM+sLAubzOqoEI98
         ih6xVNKfdGnyFuiEnH92tG1vgMF8ze1l0IjYCw5jRpizo3VJQydcbQ1w62cOJ/J94X
         xG3zSu46LZoZ7xJNf/iHGi02awn0T44rKQ9ghJ3hE2ypnGG+O3eCnvwB7/vV2uIbF4
         wtPoKHGqzc3PimryM1QNdoUuykokHHCFSt4qkAW4pUd/1VtMP0LDcbpUhAhylVglrY
         XGnKp2Ua7YF9A==
Date:   Wed, 26 Apr 2023 08:12:32 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: another nvme pssthrough design based on nvme hardware queue file
 abstraction
Message-ID: <ZEkxUG4AUcBQKfdr@kbusch-mbp.dhcp.thefacebook.com>
References: <24179a47-ab37-fa32-d177-1086668fbd3d@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24179a47-ab37-fa32-d177-1086668fbd3d@linux.alibaba.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 26, 2023 at 09:19:57PM +0800, Xiaoguang Wang wrote:
> hi all,
> 
> Recently we start to test nvme passthrough feature, which is based on io_uring. Originally we
> thought its performance would be much better than normal polled nvme test, but test results
> show that it's not:
> $ sudo taskset -c 1 /home/feiman.wxg/fio/t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -O0 -n1  -u1 /dev/ng1n1
> IOPS=891.49K, BW=435MiB/s, IOS/call=32/31
> IOPS=891.07K, BW=435MiB/s, IOS/call=31/31
> 
> $ sudo taskset -c 1 /home/feiman.wxg/fio/t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -O1 -n1 /dev/nvme1n1
> IOPS=807.81K, BW=394MiB/s, IOS/call=32/31
> IOPS=808.13K, BW=394MiB/s, IOS/call=32/32
> 
> about 10% iops improvement, I'm not saying its not good, just had thought it should
> perform much better.

What did you think it should be? What is the maximum 512b read IOPs your device
is capable of producing?

> After reading codes, I finds that this nvme passthrough feature
> is still based on blk-mq, use perf tool to analyse and there are some block layer
> overheads that seems somewhat big:
> 1. 2.48%  io_uring  [kernel.vmlinux]  [k] blk_stat_add
> In our kernel config, no active ﻿q->stats->callbacks, but still has this overhead.
> 
> 2. 0.97%  io_uring  [kernel.vmlinux]  [k] bio_associate_blkg_from_css
>     0.85%  io_uring  [kernel.vmlinux]  [k] bio_associate_blkg
>     0.74%  io_uring  [kernel.vmlinux]  [k] blkg_lookup_create
> For nvme passthrough feature, it tries to dispatch nvme commands to nvme
> controller directly, so should get rid of these overheads.
> 
> 3. 3.19%  io_uring  [kernel.vmlinux]  [k] __rcu_read_unlock
>     2.65%  io_uring  [kernel.vmlinux]  [k] __rcu_read_lock
> Frequent rcu_read_lock/unlcok overheads, not sure whether we can improve a bit.
> 
> 4. 7.90%  io_uring  [nvme]            [k] nvme_poll
>     3.59%  io_uring  [nvme_core]       [k] nvme_ns_chr_uring_cmd_iopoll
>     2.63%  io_uring  [kernel.vmlinux]  [k] blk_mq_poll_classic
>     1.88%  io_uring  [nvme]            [k] nvme_poll_cq
>     1.74%  io_uring  [kernel.vmlinux]  [k] bio_poll
>     1.89%  io_uring  [kernel.vmlinux]  [k] xas_load
>     0.86%  io_uring  [kernel.vmlinux]  [k] xas_start
>     0.80%  io_uring  [kernel.vmlinux]  [k] xas_start
> Seems that the block poll operation call chain is somewhat deep, also

It's not really that deep, though the xarray lookups are unfortunate.

And if you were to remove block layer, it looks like you'd end up just shifting
the CPU utilization to a different polling function without increasing IOPs.
Your hardware doesn't look fast enough for this software overhead to be a
concern.

> not sure whether we can improve it a bit, and the xas overheads also
> looks big, it's introduced by https://lore.kernel.org/all/20220307064401.30056-7-ming.lei@redhat.com/
> which fixed one use-after-free bug.
> 
> 5. other blocker overhead I don't spend time to look into.
> 
> Some of our clients are interested in nvme passthrough feature, they visit
> nvme devices by open(2) and read(2)/write(2) nvme device files directly, bypass
> filesystem, so they'd like to try nvme passthrough feature, to gain bigger iops, but
> currenty performance seems not that good. And they don't want to use spdk yet,
> still try to build fast storage based on linux kernel io stack for various reasons  :)
> 
> So I'd like to propose a new nvme passthrough design here, which may improve
> performance a lot. Here are just rough design ideas here, not start to code yet.
>   1. There are three types of nvme hardware queues, "default", "write" and "poll",
> currently all these queues are visible to block layer, blk-mq will map these queues
> properly.  Here this new design will add two new nvme hardware queues, name them
> "user_irq" and "user_poll" queues, which will need to add two nvme module parameters,
> similar to current "write_queues" and "poll_queues".
>   2. "user_irq" and "user_poll" queues will not be visible to block layer, and will create
> corresponding char device file for them,  that means nvme hardware queues will be
> abstracted as linux file, not sure whether to support read_iter or write_iter, but
> uring_cmd() interface will be supported firstly. user_irq queue will still have irq, user_poll
> queue will support poll.
>   3. Finally the data flow will look like below in example of user_irq queue:
> io issue: io_uring  uring_cmd >> prep nvme command in its char device's uring_cmd() >> submit to nvme.
> io reap: find io_uring request by nvme command id, and call uring_cmd_done for it.
> Yeah, need to build association between io_uring request and nvme command id.
> 
> Possible advantages:
> 1. Bypass block layer thoroughly.

blk-mq has common solutions that we don't want to duplicate in driver. It
provides safe access to shared tags across multiple processes, ensures queue
live-ness during a controller reset, tracks commands for timeouts, among other
things.
