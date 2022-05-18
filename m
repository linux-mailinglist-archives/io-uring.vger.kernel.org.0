Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0197552B2A9
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 08:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiERGiT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 02:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbiERGiS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 02:38:18 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124ECA196;
        Tue, 17 May 2022 23:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652855897; x=1684391897;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SccqK8pQ+krYGgs0A+kpUPRwXH/oMFCZKToaB5yNYLI=;
  b=X/A8bvYUSgijymIEAXm5yeA8/A0jXHZRQfzXy/Uq4C9TSpgMwQd7HZY8
   SbLeiMQPHdsrHkbTyQAGESGn3VSB9nroAcQCqbf/J3gbHU0y7TsFgIZOY
   bjeUXhwdhVB8aUFFKUoSEOdGB/OW9+TzOO8SnImjl5xxdLnikvtGk9UqK
   8CR98KY04N1h1Ac/bU+689o9dVQwn3HVy8KdQPVReFJy68vfmZAQ3uIu4
   8exWgzFBaeqWafd2D1aP/PsuUNbsSX621VzfLTNHuImTu5ceWVXlPitYv
   y6d4BBwr3N/NRPABu7cF1jGyk7qAEd6S4e9Ed8uF+d56ZjPm1wIaXvSw/
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="332125885"
X-IronPort-AV: E=Sophos;i="5.91,234,1647327600"; 
   d="scan'208";a="332125885"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 23:38:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,234,1647327600"; 
   d="scan'208";a="545281761"
Received: from storage2.sh.intel.com (HELO localhost) ([10.67.110.197])
  by orsmga006.jf.intel.com with ESMTP; 17 May 2022 23:38:11 -0700
Date:   Wed, 18 May 2022 02:38:08 -0400
From:   Liu Xiaodong <xiaodong.liu@intel.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Liu Xiaodong <xiaodong.liu@intel.com>
Subject: Re: [PATCH V2 0/1] ubd: add io_uring based userspace block driver
Message-ID: <20220518063808.GA168577@storage2.sh.intel.com>
References: <20220517055358.3164431-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517055358.3164431-1-ming.lei@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 17, 2022 at 01:53:57PM +0800, Ming Lei wrote:
> Hello Guys,
> 
> ubd driver is one kernel driver for implementing generic userspace block
> device/driver, which delivers io request from ubd block device(/dev/ubdbN) into
> ubd server[1] which is the userspace part of ubd for communicating
> with ubd driver and handling specific io logic by its target module.
> 
> Another thing ubd driver handles is to copy data between user space buffer
> and request/bio's pages, or take zero copy if mm is ready for support it in
> future. ubd driver doesn't handle any IO logic of the specific driver, so
> it is small/simple, and all io logics are done by the target code in ubdserver.
> 
> The above two are main jobs done by ubd driver.

Hi, Lei

Your UBD implementation looks great. Its io_uring based design is interesting
and brilliant.
Towards the purpose of userspace block device, last year,
VDUSE initialized by Yongji is going to do a similar work. But VDUSE is under
vdpa. VDUSE will present a virtio-blk device to other userspace process
like containers, while serving virtio-blk req also by an userspace target.
https://lists.linuxfoundation.org/pipermail/iommu/2021-June/056956.html 

I've been working and thinking on serving RUNC container by SPDK efficiently.
But this work requires a new proper userspace block device module in kernel.
The highlevel design idea for userspace block device implementations
should be that: Using ring for IO request, so client and target can exchange
req/resp quickly in batch; Map bounce buffer between kernel and userspace
target, so another extra IO data copy like NBD can be avoid. (Oh, yes, SPDK
needs this kernel module has some more minor functions)

UBD and VDUSE are both implemented in this way, while of course each of
them has specific features and advantages.

Not like UBD which is straightforward and starts from scratch, VDUSE is
embedded in virtio framework. So its implementation is more complicated, but
all virtio frontend utilities can be leveraged.
When considering security/permission issues, feels UBD would be easier to
solve them.

So my questions are:
1. what do you think about the purpose overlap between UBD and VDUSE?
2. Could UBD be implemented with SPDK friendly functionalities? (mainly about
io data mapping, since HW devices in SPDK need to access the mapped data
buffer. Then, in function ubdsrv.c/ubdsrv_init_io_bufs(),
"addr = mmap(,,,,dev->cdev_fd,)", SPDK needs to know the PA of "addr".
Also memory pointed by "addr" should be pinned all the time.)

Thanks
Xiaodong

> 
> ubd driver can help to move IO logic into userspace, in which the
> development work is easier/more effective than doing in kernel, such as,
> ubd-loop takes < 200 lines of loop specific code to get basically same 
> function with kernel loop block driver, meantime the performance is
> still good. ubdsrv[1] provide built-in test for comparing both by running
> "make test T=loop".
> 
> Another example is high performance qcow2 support[2], which could be built with
> ubd framework more easily than doing it inside kernel.
> 
> Also there are more people who express interests on userspace block driver[3],
> Gabriel Krisman Bertazi proposes this topic in lsf/mm/ebpf 2022 and mentioned
> requirement from Google. Ziyang Zhang from Alibaba said they "plan to
> replace TCMU by UBD as a new choice" because UBD can get better throughput than
> TCMU even with single queue[4], meantime UBD is simple. Also there is userspace
> storage service for providing storage to containers.
> 
> It is io_uring based: io request is delivered to userspace via new added
> io_uring command which has been proved as very efficient for making nvme
> passthrough IO to get better IOPS than io_uring(READ/WRITE). Meantime one
> shared/mmap buffer is used for sharing io descriptor to userspace, the
> buffer is readonly for userspace, each IO just takes 24bytes so far.
> It is suggested to use io_uring in userspace(target part of ubd server)
> to handle IO request too. And it is still easy for ubdserver to support
> io handling by non-io_uring, and this work isn't done yet, but can be
> supported easily with help o eventfd.
> 
> This way is efficient since no extra io command copy is required, no sleep
> is needed in transferring io command to userspace. Meantime the communication
> protocol is simple and efficient, one single command of
> UBD_IO_COMMIT_AND_FETCH_REQ can handle both fetching io request desc and commit
> command result in one trip. IO handling is often batched after single
> io_uring_enter() returns, both IO requests from ubd server target and
> IO commands could be handled as a whole batch.
> 
> Remove RFC now because ubd driver codes gets lots of cleanup, enhancement and
> bug fixes since V1:
> 
> - cleanup uapi: remove ubd specific error code,  switch to linux error code,
> remove one command op, remove one field from cmd_desc
> 
> - add monitor mechanism to handle ubq_daemon being killed, ubdsrv[1]
>   includes builtin tests for covering heavy IO with deleting ubd / killing
>   ubq_daemon at the same time, and V2 pass all the two tests(make test T=generic),
>   and the abort/stop mechanism is simple
> 
> - fix MQ command buffer mmap bug, and now 'xfstetests -g auto' works well on
>   MQ ubd-loop devices(test/scratch)
> 
> - improve batching submission as suggested by Jens
> 
> - improve handling for starting device, replace random wait/poll with
> completion
> 
> - all kinds of cleanup, bug fix,..
> 
> And the patch by patch change since V1 can be found in the following
> tree:
> 
> https://github.com/ming1/linux/commits/my_for-5.18-ubd-devel_v2
> 
> Todo:
> 	- add lazy user page release for avoiding cost of pinning user pages in
> 	ubd_copy_pages() most of time, so we can save CPU for handling io logic
> 	in userpsace
> 
> 
> [1] ubd server
> https://github.com/ming1/ubdsrv/commits/devel-v2
> 
> [2] qcow2 kernel driver attempt
> https://www.spinics.net/lists/kernel/msg4292965.html
> https://patchwork.kernel.org/project/linux-block/cover/20190823225619.15530-1-development@manuel-bentele.de/#22841183
> 
> [3] [LSF/MM/BPF TOPIC] block drivers in user space
> https://lore.kernel.org/linux-block/87tucsf0sr.fsf@collabora.com/
> 
> [4] Follow up on UBD discussion
> https://lore.kernel.org/linux-block/YnsW+utCrosF0lvm@T590/#r
> 
> Ming Lei (1):
>   ubd: add io_uring based userspace block driver
> 
>  drivers/block/Kconfig        |    6 +
>  drivers/block/Makefile       |    2 +
>  drivers/block/ubd_drv.c      | 1444 ++++++++++++++++++++++++++++++++++
>  include/uapi/linux/ubd_cmd.h |  158 ++++
>  4 files changed, 1610 insertions(+)
>  create mode 100644 drivers/block/ubd_drv.c
>  create mode 100644 include/uapi/linux/ubd_cmd.h
> 
> -- 
> 2.31.1
