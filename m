Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89216BC446
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 04:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjCPDNr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 23:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCPDNr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 23:13:47 -0400
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD432D173;
        Wed, 15 Mar 2023 20:13:44 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VdyJZbd_1678936419;
Received: from 30.221.146.182(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VdyJZbd_1678936419)
          by smtp.aliyun-inc.com;
          Thu, 16 Mar 2023 11:13:40 +0800
Message-ID: <fd30b561-86dd-5061-714f-e46058f7079f@linux.alibaba.com>
Date:   Thu, 16 Mar 2023 11:13:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
Content-Language: en-US
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <20230314125727.1731233-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> Hello,
>
> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> and its ->issue() can retrieve/import buffer from master request's
> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> submits slave OP just like normal OP issued from userspace, that said,
> SQE order is kept, and batching handling is done too.
Thanks for this great work, seems that we're now in the right direction
to support ublk zero copy, I believe this feature will improve io throughput
greatly and reduce ublk's cpu resource usage.

I have gone through your 2th patch, and have some little concerns here:
Say we have one ublk loop target device, but it has 4 backend files,
every file will carry 25% of device capacity and it's implemented in stripped
way, then for every io request, current implementation will need issed 4
fused_cmd, right? 4 slave sqes are necessary, but it would be better to
have just one master sqe, so I wonder whether we can have another
method. The key point is to let io_uring support register various kernel
memory objects, which come from kernel, such as ITER_BVEC or
ITER_KVEC. so how about below actions:
1. add a new infrastructure in io_uring, which will support to register
various kernel memory objects in it, this new infrastructure could be
maintained in a xarray structure, every memory objects in it will have
a unique id. This registration could be done in a ublk uring cmd, io_uring
offers registration interface.
2. then any sqe can use these memory objects freely, so long as it
passes above unique id in sqe properly.
Above are just rough ideas, just for your reference.

And current zero-copy method only supports raw data redirection, if
ublk targets need to crc, compress, encrypt raw io requests' pages,
then we'll still need to copy block layer's io data to userspace daemon.
In that way, ebpf may give a help :) we directly operate block layer's
io data in ebpf prog, doing crc or compress, encrypt, still does not need
to copy to userspace daemon. But as you said before, ebpf may not
support complicated user io logic, a much long way to go...

Regards,
Xiaoguang Wang

>
> Please see detailed design in commit log of the 2th patch, and one big
> point is how to handle buffer ownership.
>
> With this way, it is easy to support zero copy for ublk/fuse device.
>
> Basically userspace can specify any sub-buffer of the ublk block request
> buffer from the fused command just by setting 'offset/len'
> in the slave SQE for running slave OP. This way is flexible to implement
> io mapping: mirror, stripped, ...
>
> The 3th & 4th patches enable fused slave support for the following OPs:
>
> 	OP_READ/OP_WRITE
> 	OP_SEND/OP_RECV/OP_SEND_ZC
>
> The other ublk patches cleans ublk driver and implement fused command
> for supporting zero copy.
>
> Follows userspace code:
>
> https://github.com/ming1/ubdsrv/tree/fused-cmd-zc-v2
>
> All three(loop, nbd and qcow2) ublk targets have supported zero copy by passing:
>
> 	ublk add -t [loop|nbd|qcow2] -z .... 
>
> Basic fs mount/kernel building and builtin test are done, and also not
> observe regression on xfstest test over ublk-loop with zero copy.
>
> Also add liburing test case for covering fused command based on miniublk
> of blktest:
>
> https://github.com/ming1/liburing/commits/fused_cmd_miniublk
>
> Performance improvement is obvious on memory bandwidth
> related workloads, such as, 1~2X improvement on 64K/512K BS
> IO test on loop with ramfs backing file.
>
> Any comments are welcome!
>
> V3:
> 	- fix build warning reported by kernel test robot
> 	- drop patch for checking fused flags on existed drivers with
> 	  ->uring_command(), which isn't necessary, since we do not do that
>       when adding new ioctl or uring command
>     - inline io_init_rq() for core code, so just export io_init_slave_req
> 	- return result of failed slave request unconditionally since REQ_F_CQE_SKIP
> 	will be cleared
> 	- pass xfstest over ublk-loop
>
> V2:
> 	- don't resue io_mapped_ubuf (io_uring)
> 	- remove REQ_F_FUSED_MASTER_BIT (io_uring)
> 	- fix compile warning (io_uring)
> 	- rebase on v6.3-rc1 (io_uring)
> 	- grabbing io request reference when handling fused command 
> 	- simplify ublk_copy_user_pages() by iov iterator
> 	- add read()/write() for userspace to read/write ublk io buffer, so
> 	that some corner cases(read zero, passthrough request(report zones)) can
> 	be handled easily in case of zero copy; this way also helps to switch to
> 	zero copy completely
> 	- misc cleanup
>
>
> Ming Lei (16):
>   io_uring: increase io_kiocb->flags into 64bit
>   io_uring: add IORING_OP_FUSED_CMD
>   io_uring: support OP_READ/OP_WRITE for fused slave request
>   io_uring: support OP_SEND_ZC/OP_RECV for fused slave request
>   block: ublk_drv: mark device as LIVE before adding disk
>   block: ublk_drv: add common exit handling
>   block: ublk_drv: don't consider flush request in map/unmap io
>   block: ublk_drv: add two helpers to clean up map/unmap request
>   block: ublk_drv: clean up several helpers
>   block: ublk_drv: cleanup 'struct ublk_map_data'
>   block: ublk_drv: cleanup ublk_copy_user_pages
>   block: ublk_drv: grab request reference when the request is handled by
>     userspace
>   block: ublk_drv: support to copy any part of request pages
>   block: ublk_drv: add read()/write() support for ublk char device
>   block: ublk_drv: don't check buffer in case of zero copy
>   block: ublk_drv: apply io_uring FUSED_CMD for supporting zero copy
>
>  drivers/block/ublk_drv.c       | 602 ++++++++++++++++++++++++++-------
>  include/linux/io_uring.h       |  49 ++-
>  include/linux/io_uring_types.h |  80 +++--
>  include/uapi/linux/io_uring.h  |   1 +
>  include/uapi/linux/ublk_cmd.h  |  37 +-
>  io_uring/Makefile              |   2 +-
>  io_uring/fused_cmd.c           | 245 ++++++++++++++
>  io_uring/fused_cmd.h           |  11 +
>  io_uring/io_uring.c            |  28 +-
>  io_uring/io_uring.h            |   3 +
>  io_uring/net.c                 |  30 +-
>  io_uring/opdef.c               |  17 +
>  io_uring/opdef.h               |   2 +
>  io_uring/rw.c                  |  20 ++
>  14 files changed, 967 insertions(+), 160 deletions(-)
>  create mode 100644 io_uring/fused_cmd.c
>  create mode 100644 io_uring/fused_cmd.h
>

