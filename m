Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505EE5F9A3A
	for <lists+io-uring@lfdr.de>; Mon, 10 Oct 2022 09:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbiJJHmr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Oct 2022 03:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbiJJHlx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Oct 2022 03:41:53 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103B845F69
        for <io-uring@vger.kernel.org>; Mon, 10 Oct 2022 00:37:15 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0VRo4rs8_1665387432;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0VRo4rs8_1665387432)
          by smtp.aliyun-inc.com;
          Mon, 10 Oct 2022 15:37:13 +0800
Date:   Mon, 10 Oct 2022 15:37:12 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, io-uring@vger.kernel.org
Subject: Re: [RFC v1 0/9] zero-copy RX for io_uring
Message-ID: <20221010073712.GE108825@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20221007211713.170714-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007211713.170714-1-jonathan.lemon@gmail.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 07, 2022 at 02:17:04PM -0700, Jonathan Lemon wrote:
>This series is a RFC for io_uring/zctap.  This is an evolution of
>the earlier zctap work, re-targeted to use io_uring as the userspace
>API.  The current code is intended to provide a zero-copy RX path for
>upper-level networking protocols (aka TCP and UDP).  The current draft
>focuses on host-provided memory (not GPU memory).
>
>This RFC contains the upper-level core code required for operation,
>with the intent of soliciting feedback on the general API.  This does
>not contain the network driver side changes required for complete
>operation.  Also please note that as an RFC, there are some things
>which are incomplete or in need of rework.
>
>The intent is to use a network driver which provides header/data
>splitting, so the frame header (which is processed by the networking
>stack) does not reside in user memory.
>
>The code is roughly working (in that it has successfully received
>a TCP stream from a remote sender), but as an RFC, the intent is
>to solicit feedback on the API and overall design.  The current code
>will also work with system pages, copying the data out to the
>application - this is intended as a fallback/testing path.
>
>High level description:
>
>The application allocates a frame backing store, and provides this
>to the kernel for use.  An interface queue is requested from the
>networking device, and incoming frames are deposited into the provided
>memory region.
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
>processing of the data, the buffer is returned back to the kernel
>through a fill ring for reuse.

Interesting work ! Any userspace demo and performance data ?

>
>Jonathan Lemon (9):
>  io_uring: add zctap ifq definition
>  netdevice: add SETUP_ZCTAP to the netdev_bpf structure
>  io_uring: add register ifq opcode
>  io_uring: add provide_ifq_region opcode
>  io_uring: Add io_uring zctap iov structure and helpers
>  io_uring: introduce reference tracking for user pages.
>  page_pool: add page allocation and free hooks.
>  io_uring: provide functions for the page_pool.
>  io_uring: add OP_RECV_ZC command.
>
> include/linux/io_uring.h       |  24 ++
> include/linux/io_uring_types.h |  10 +
> include/linux/netdevice.h      |   6 +
> include/net/page_pool.h        |   6 +
> include/uapi/linux/io_uring.h  |  26 ++
> io_uring/Makefile              |   3 +-
> io_uring/io_uring.c            |  10 +
> io_uring/kbuf.c                |  13 +
> io_uring/kbuf.h                |   2 +
> io_uring/net.c                 | 123 ++++++
> io_uring/opdef.c               |  23 +
> io_uring/zctap.c               | 749 +++++++++++++++++++++++++++++++++
> io_uring/zctap.h               |  20 +
> net/core/page_pool.c           |  41 +-
> 14 files changed, 1048 insertions(+), 8 deletions(-)
> create mode 100644 io_uring/zctap.c
> create mode 100644 io_uring/zctap.h
>
>-- 
>2.30.2
