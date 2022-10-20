Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1326055F8
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 05:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJTDfX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 23:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiJTDfW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 23:35:22 -0400
Received: from out199-3.us.a.mail.aliyun.com (out199-3.us.a.mail.aliyun.com [47.90.199.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D965BDED14
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 20:35:19 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VSdMTGR_1666236914;
Received: from 30.97.56.192(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VSdMTGR_1666236914)
          by smtp.aliyun-inc.com;
          Thu, 20 Oct 2022 11:35:15 +0800
Message-ID: <500982a6-da38-0d8c-dc5d-e08787362d71@linux.alibaba.com>
Date:   Thu, 20 Oct 2022 11:35:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [RFC PATCH v2 00/13] zero-copy RX for io_uring
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2022/10/19 03:15, Jonathan Lemon wrote:
> This series is a RFC for io_uring/zctap.  This is an evolution of
> the earlier zctap work, re-targeted to use io_uring as the userspace
> API.  The current code is intended to provide a zero-copy RX path for
> upper-level networking protocols (aka TCP and UDP).  The current draft
> focuses on host-provided memory (not GPU memory).
> 
> This RFC contains the upper-level core code required for operation,
> with the intent of soliciting feedback on the general API.  This does
> not contain the network driver side changes required for complete
> operation.  Also please note that as an RFC, there are some things
> which are incomplete or in need of rework.
> 
> The intent is to use a network driver which provides header/data
> splitting, so the frame header (which is processed by the networking
> stack) does not reside in user memory.
> 
> The code is successfully receiving a zero-copy TCP stream from a
> remote sender.  An RFC, the intent is to solicit feedback on the
> API and overall design.  The current code will also work with
> system pages, copying the data out to the application - this is
> intended as a fallback/testing path.
> 
> Performance numbers are coming soon!
> 
> High level description:
> 
> The application allocates a frame backing store, and provides this
> to the kernel for use.  An interface queue is requested from the
> networking device, and incoming frames are deposited into the provided
> memory region.
> 
> Responsibility for correctly steering incoming frames to the queue
> is outside the scope of this work - it is assumed that the user 
> has set steering rules up separately.
> 
> Incoming frames are sent up the stack as skb's and eventually
> land in the application's socket receive queue.  This differs
> from AF_XDP, which receives raw frames directly to userspace,
> without protocol processing.
> 
> The RECV_ZC opcode then returns an iov[] style vector which points
> to the data in userspace memory.  When the application has completed
> processing of the data, the buffer is returned back to the kernel
> through a fill ring for reuse.
> 
> Changelog:
>  v1: initial version
>  v2: Remove separate PROVIDE_REGION opcode, fold this functionality
>      into REGISTER_IFQ.  Remove page_pool hooks, as it appears the 
>      page pool is currently incompatible with user-mapped memory.
>      Add io_zctap_buffers and network driver API.
> .
> 
> Jonathan Lemon (13):
>   io_uring: add zctap ifq definition
>   netdevice: add SETUP_ZCTAP to the netdev_bpf structure
>   io_uring: add register ifq opcode
>   io_uring: create a zctap region for a mapped buffer
>   io_uring: create page freelist for the ifq region
>   io_uring: Provide driver API for zctap packet buffers.
>   io_uring: Allocate the zctap buffers for the device
>   io_uring: Add zctap buffer get/put functions and refcounting.
>   skbuff: Introduce SKBFL_FIXED_FRAG and skb_fixed()
>   io_uring: Allocate a uarg for use by the ifq RX
>   io_uring: Define the zctap iov[] returned to the user.
>   io_uring: add OP_RECV_ZC command.
>   io_uring: Make remove_ifq_region a delayed work call
> 
>  include/linux/io_uring.h       |  35 ++
>  include/linux/io_uring_types.h |  11 +
>  include/linux/netdevice.h      |   6 +
>  include/linux/skbuff.h         |  10 +-
>  include/uapi/linux/io_uring.h  |  24 +
>  io_uring/Makefile              |   3 +-
>  io_uring/io_uring.c            |   8 +
>  io_uring/kbuf.c                |  13 +
>  io_uring/kbuf.h                |   2 +
>  io_uring/net.c                 | 123 +++++
>  io_uring/opdef.c               |  15 +
>  io_uring/zctap.c               | 842 +++++++++++++++++++++++++++++++++
>  io_uring/zctap.h               |  16 +
>  13 files changed, 1106 insertions(+), 2 deletions(-)
>  create mode 100644 io_uring/zctap.c
>  create mode 100644 io_uring/zctap.h
> 

Hi, Jonathan

We are interested in your work, too. I think the API is better than V1.
I have a question: Is this patchset still incomplete? We'd like to know how to
split msg header and body by XDP with io_uring ZC_RECV. Or could you please
share one runnable demo which could run with your previous liburing patch.

Regards,
Zhang.

