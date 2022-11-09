Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5ADA622402
	for <lists+io-uring@lfdr.de>; Wed,  9 Nov 2022 07:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiKIGhu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Nov 2022 01:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKIGht (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Nov 2022 01:37:49 -0500
Received: from out199-2.us.a.mail.aliyun.com (out199-2.us.a.mail.aliyun.com [47.90.199.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B1E1A21E
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 22:37:47 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VUMahW3_1667975862;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0VUMahW3_1667975862)
          by smtp.aliyun-inc.com;
          Wed, 09 Nov 2022 14:37:43 +0800
Date:   Wed, 9 Nov 2022 14:37:42 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, io-uring@vger.kernel.org
Cc:     kernel-team@meta.com
Subject: Re: [PATCH v1 00/15] zero-copy RX for io_uring
Message-ID: <20221109063742.GI56517@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 07, 2022 at 09:05:06PM -0800, Jonathan Lemon wrote:
>This series introduces network RX zerocopy for io_uring.
>
>This is an evolution of the earlier zctap work, re-targeted to use
>io_uring as the userspace API.  The code is intends to provide a 
>ZC RX path for upper-level networking protocols (aka TCP and UDP),
>with a focus on focuses on host-provided memory (not GPU memory).
>
>This patch contains the upper-level core code required for operation,
>but does not not contain the network driver side changes required for
>true zero-copy operation.  The io_uring RECV_ZC opcode will work 
>without hardware support, albeit in copy mode.
>
>The intent is to use a network driver which provides header/data
>splitting, so the frame header which is processed by the networking
>stack is not placed in user memory.
>
>The code is successfully receiving a zero-copy TCP stream from a
>remote sender.
>
>There is a liburing fork providing the needed wrappers:
>
>    https://github.com/jlemon/liburing/tree/zctap
>
>Which contains an examples/io_uring-net test application exercising
>these features.  A sample run:
>
>  # ./io_uring-net -i eth1 -q 20 -p 9999 -r 3000
>   copy bytes: 1938872
>     ZC bytes: 996683008
>  Total bytes: 998621880, nsec:1025219375
>         Rate: 7.79 Gb/s
>
>If no queue is specified, then non-zc mode is used:
>
>  # ./io_uring-net -p 9999
>   copy bytes: 998621880
>     ZC bytes: 0
>  Total bytes: 998621880, nsec:1051515726
>         Rate: 7.60 Gb/s

Haven't dive into your test case yet, but the performance data
looks disappointing

I don't know why we need zerocopy if we can't get a big performance
gain.

Have you tested large messages with jumbo or LRO enabled ?

Thanks

>
>There is also an iperf3 fork as well:
>
>   https://github.com/jlemon/iperf/tree/io_uring
>
>This allows running single tests with either:
>   * select (normal iperf3)
>   * io_uring READ
>   * io_uring RECV_ZC copy mode
>   * io_uring RECV_ZC hardware mode
>
>Current testing shows similar BW between RECV_ZC and READ modes
>(running at 22Gbit/sec), but a reduction of ~50% of MemBW.
>
>High level description:
>
>The application allocates a frame backing store, and provides this
>to the kernel for use.  An interface queue is requested from the
>networking device, and incoming frames are deposited into the provided
>memory region.  The NIC should provide a header splitting feature, so
>only the frame payload is placed in the user space area.
>
>Responsibility for correctly steering incoming frames to the queue
>is outside the scope of this work - it is assumed that the user 
>has set steering rules up separately.
>
>Incoming frames are sent up the stack as skb's and eventually
>land in the application's socket receive queue.  This differs
>from AF_XDP, which receives raw frames directly to userspace,
>without protocol processing.
>
>The RECV_ZC opcode then returns an iov[] style vector which points
>to the data in userspace memory.  When the application has completed
>processing of the data, the buffers are returned back to the kernel
>through a fill ring for reuse.
>
>Jonathan Lemon (15):
>  io_uring: add zctap ifq definition
>  netdevice: add SETUP_ZCTAP to the netdev_bpf structure
>  io_uring: add register ifq opcode
>  io_uring: create a zctap region for a mapped buffer
>  io_uring: mark pages in ifq region with zctap information.
>  io_uring: Provide driver API for zctap packet buffers.
>  io_uring: Allocate zctap device buffers and dma map them.
>  io_uring: Add zctap buffer get/put functions and refcounting.
>  skbuff: Introduce SKBFL_FIXED_FRAG and skb_fixed()
>  io_uring: Allocate a uarg for use by the ifq RX
>  io_uring: Define the zctap iov[] returned to the user.
>  io_uring: add OP_RECV_ZC command.
>  io_uring: Make remove_ifq_region a delayed work call
>  io_uring: Add a buffer caching mechanism for zctap.
>  io_uring: Notify the application as the fillq is drained.
>
> include/linux/io_uring.h       |   47 ++
> include/linux/io_uring_types.h |   12 +
> include/linux/netdevice.h      |    6 +
> include/linux/skbuff.h         |   10 +-
> include/uapi/linux/io_uring.h  |   24 +
> io_uring/Makefile              |    3 +-
> io_uring/io_uring.c            |    8 +
> io_uring/kbuf.c                |   13 +
> io_uring/kbuf.h                |    2 +
> io_uring/net.c                 |  123 ++++
> io_uring/opdef.c               |   15 +
> io_uring/zctap.c               | 1001 ++++++++++++++++++++++++++++++++
> io_uring/zctap.h               |   31 +
> 13 files changed, 1293 insertions(+), 2 deletions(-)
> create mode 100644 io_uring/zctap.c
> create mode 100644 io_uring/zctap.h
>
>-- 
>2.30.2
