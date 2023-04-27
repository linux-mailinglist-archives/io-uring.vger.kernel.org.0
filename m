Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387546F07D4
	for <lists+io-uring@lfdr.de>; Thu, 27 Apr 2023 17:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243577AbjD0PDp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Apr 2023 11:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243520AbjD0PDo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Apr 2023 11:03:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1956E1992;
        Thu, 27 Apr 2023 08:03:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8FB663921;
        Thu, 27 Apr 2023 15:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03CAC433D2;
        Thu, 27 Apr 2023 15:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682607822;
        bh=xcd6XEBmruik18HKPh5fM0OLhLHBkJHfnUPr0koBNIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rpqEvN1aXAHVdk71XXuC7NOzyMTs8Ls/CX3qrzIJmt5vJ04KOyTBa41CNXojTvNeD
         exd61xkVd+E4g6l51CkQ5f3oDQCRPoznKPh82CCKxju8QEQIOrYsh4GiwODfqPJ2B1
         Iod3XcgwjURdZhIDO92ZCge6UCWlcBVspgxuQmP/Sw9UuIzsHvFx+4CeDhs6XqeKQG
         JFHHY56UKsoC6gppnerhI4QjQWBkeHgQMdRaOutIRBlxAq+CIH140+f/NfQ2RvsQ8g
         JHUugzptbmH1tiYfrmmyNtCMriq2oVgRior4fyjs06NrpsLcudE8ONujcAOmyWXvVL
         3IRHPiNI1FGuQ==
Date:   Thu, 27 Apr 2023 09:03:39 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: another nvme pssthrough design based on nvme hardware queue file
 abstraction
Message-ID: <ZEqOy6oFp7tc06dH@kbusch-mbp.dhcp.thefacebook.com>
References: <24179a47-ab37-fa32-d177-1086668fbd3d@linux.alibaba.com>
 <ZEkxUG4AUcBQKfdr@kbusch-mbp.dhcp.thefacebook.com>
 <3e04dbdc-335a-8cc1-f1e2-72e395700da6@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e04dbdc-335a-8cc1-f1e2-72e395700da6@linux.alibaba.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 27, 2023 at 08:17:30PM +0800, Xiaoguang Wang wrote:
> > On Wed, Apr 26, 2023 at 09:19:57PM +0800, Xiaoguang Wang wrote:
> >> hi all,
> >>
> >> Recently we start to test nvme passthrough feature, which is based on io_uring. Originally we
> >> thought its performance would be much better than normal polled nvme test, but test results
> >> show that it's not:
> >> $ sudo taskset -c 1 /home/feiman.wxg/fio/t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -O0 -n1  -u1 /dev/ng1n1
> >> IOPS=891.49K, BW=435MiB/s, IOS/call=32/31
> >> IOPS=891.07K, BW=435MiB/s, IOS/call=31/31
> >>
> >> $ sudo taskset -c 1 /home/feiman.wxg/fio/t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -O1 -n1 /dev/nvme1n1
> >> IOPS=807.81K, BW=394MiB/s, IOS/call=32/31
> >> IOPS=808.13K, BW=394MiB/s, IOS/call=32/32
> >>
> >> about 10% iops improvement, I'm not saying its not good, just had thought it should
> >> perform much better.
> > What did you think it should be? What is the maximum 512b read IOPs your device
> > is capable of producing?
> From the naming of this feature, I thought it would bypass blocker thoroughly, hence
> would gain much higher performance, for myself, if this feature can improves 25% higher
> or more, that would be much more attractive, and users would like to try it. Again, I'm
> not saying this feature is not good, just thought it would perform much better for small io.

It does bypass the block layer. The driver just uses library functions provided
by the block layer for things it doesn't want to duplicate. Reimplementing that
functionality in driver isn't going to improve anything.

> >> In our kernel config, no active ﻿q->stats->callbacks, but still has this overhead.
> >>
> >> 2. 0.97%  io_uring  [kernel.vmlinux]  [k] bio_associate_blkg_from_css
> >>     0.85%  io_uring  [kernel.vmlinux]  [k] bio_associate_blkg
> >>     0.74%  io_uring  [kernel.vmlinux]  [k] blkg_lookup_create
> >> For nvme passthrough feature, it tries to dispatch nvme commands to nvme
> >> controller directly, so should get rid of these overheads.
> >>
> >> 3. 3.19%  io_uring  [kernel.vmlinux]  [k] __rcu_read_unlock
> >>     2.65%  io_uring  [kernel.vmlinux]  [k] __rcu_read_lock
> >> Frequent rcu_read_lock/unlcok overheads, not sure whether we can improve a bit.
> >>
> >> 4. 7.90%  io_uring  [nvme]            [k] nvme_poll
> >>     3.59%  io_uring  [nvme_core]       [k] nvme_ns_chr_uring_cmd_iopoll
> >>     2.63%  io_uring  [kernel.vmlinux]  [k] blk_mq_poll_classic
> >>     1.88%  io_uring  [nvme]            [k] nvme_poll_cq
> >>     1.74%  io_uring  [kernel.vmlinux]  [k] bio_poll
> >>     1.89%  io_uring  [kernel.vmlinux]  [k] xas_load
> >>     0.86%  io_uring  [kernel.vmlinux]  [k] xas_start
> >>     0.80%  io_uring  [kernel.vmlinux]  [k] xas_start
> >> Seems that the block poll operation call chain is somewhat deep, also
> > It's not really that deep, though the xarray lookups are unfortunate.
> >
> > And if you were to remove block layer, it looks like you'd end up just shifting
> > the CPU utilization to a different polling function without increasing IOPs.
> > Your hardware doesn't look fast enough for this software overhead to be a
> > concern.
> No, I may not agree with you here, sorry. Real products(not like t/io_uring tools,
> which just polls block layer when ios are issued) will have many other work
> to run, such as network work. If we can cut the nvme passthrough overhead more,
> saved cpu will use to do other useful work.

You initiated this thread with supposed underwhelming IOPs improvements from
the io engine, but now you've shifted your criteria.

You can always turn off the kernel's stats and cgroups if you don't find them
useful.
