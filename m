Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A646A6CC643
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 17:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbjC1P2f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Mar 2023 11:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbjC1P2R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Mar 2023 11:28:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED94611EA3
        for <io-uring@vger.kernel.org>; Tue, 28 Mar 2023 08:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680017119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pLTOFnnc1VmpWj6ZA8kv034hcnFXFgv2qtrDVUrrsM0=;
        b=ehCDvNoztetL670WJGETNLmxV6x7Y19RmQ236J2xjfl/Nup2OUV8yx0kj16GoE2TcF/WWb
        OpiIvXR/xW14gd8IxotI1EwkIKXAGi0SQ1qkjpPTos3CeEpLlkuQorjG4yV7YJJ4VcH5gL
        jHXSlqRjQCTl5Mi2Hp/u3ryoR5q1O+o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-ycV7bpnvMMST_p2X3cu_lw-1; Tue, 28 Mar 2023 11:11:25 -0400
X-MC-Unique: ycV7bpnvMMST_p2X3cu_lw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEDB8887401;
        Tue, 28 Mar 2023 15:10:46 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8E024020C82;
        Tue, 28 Mar 2023 15:10:45 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Date:   Tue, 28 Mar 2023 23:09:42 +0800
Message-Id: <20230328150958.1253547-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Jens,

Add IORING_OP_FUSED_CMD, it is one special URING_CMD, the 1st SQE(primary) is
one 64byte URING_CMD, and the 2nd 64byte SQE(secondary) is another normal
64byte OP. The primary command provides device/file io buffer and
submits OP represented by the secondary SQE using the provided buffer. This way
solves ublk zero copy problem easily, since io buffer shares same lifetime with
the primary command.

The secondary OP is actually submitted from kernel, part of this idea is from
Xiaoguang's ublk ebpf patchset, but this patchset submits secondary OP just
like normal OP issued from userspace, that said, SQE order is kept, and
batching handling is done too.

Please see detailed design in commit log of the 2th patch, and one big
point is how to handle buffer lifetime/ownership.

With this way, it is easy to support zero copy for ublk/fuse device.

Basically userspace can specify any sub-buffer of the ublk block request
buffer from the fused command just by setting 'offset/len'
in the secondary SQE for running secondary OP. This way is flexible to implement
io mapping: mirror, stripped, ...

The 4th & 5th patches enable fused secondary support for the following OPs:

	OP_READ/OP_WRITE
	OP_SEND/OP_RECV/OP_SEND_ZC

The other ublk patches cleans ublk driver and implement fused command
for supporting zero copy.

Follows userspace code, which supports 128byte SQE fused command only:

https://github.com/ming1/ubdsrv/tree/fused-cmd-zc-for-v5

All three(loop, nbd and qcow2) ublk targets have supported zero copy by passing:

	ublk add -t [loop|nbd|qcow2] -z .... 

Basic fs mount/kernel building and builtin test are done, and also not
observe regression on xfstest test over ublk-loop with zero copy.

Also add liburing test case for covering fused command based on miniublk
of blktest(supports 64byte normal SQE only)

https://github.com/ming1/liburing/tree/fused_cmd_miniublk_for_v5

Performance improvement is obvious on memory bandwidth related workloads,
such as, 1~2X improvement on 64K/512K BS IO test on loop with ramfs backing file.
ublk-null shows 5X IOPS improvement on big BS test when the copy is avoided.

Please review and consider for v6.4.

V5:
	- rebase on for-6.4/io_uring
	- rename to primary/secondary as suggested by Jens
	- reserve interface for extending to support multiple secondary OPs in future,
	which isn't a must, because it can be done by submitting multiple fused
	commands with same primary request
	- rename to primary/secondary in ublksrv and liburing test code

V4:
	- improve APIs naming(patch 1 ~ 4)
	- improve documents and commit log(patch 2)
	- add buffer direction bit to opdef, suggested by Jens(patch 2)
	- add ublk zero copy document for cover: technical requirements(most related with
	buffer lifetime), and explains why splice isn't good and how fused command solves it(patch 17)
	- fix sparse warning(patch 7)
	- supports 64byte SQE fused command(patch 3)

V3:
	- fix build warning reported by kernel test robot
	- drop patch for checking fused flags on existed drivers with
	  ->uring_command(), which isn't necessary, since we do not do that
      when adding new ioctl or uring command
    - inline io_init_rq() for core code, so just export io_init_secondary_req
	- return result of failed secondary request unconditionally since REQ_F_CQE_SKIP
	will be cleared
	- pass xfstest over ublk-loop

V2:
	- don't resue io_mapped_ubuf (io_uring)
	- remove REQ_F_FUSED_MASTER_BIT (io_uring)
	- fix compile warning (io_uring)
	- rebase on v6.3-rc1 (io_uring)
	- grabbing io request reference when handling fused command 
	- simplify ublk_copy_user_pages() by iov iterator
	- add read()/write() for userspace to read/write ublk io buffer, so
	that some corner cases(read zero, passthrough request(report zones)) can
	be handled easily in case of zero copy; this way also helps to switch to
	zero copy completely
	- misc cleanup

Ming Lei (16):
  io_uring: increase io_kiocb->flags into 64bit
  io_uring: add IORING_OP_FUSED_CMD
  io_uring: support normal SQE for fused command
  io_uring: support OP_READ/OP_WRITE for fused secondary request
  io_uring: support OP_SEND_ZC/OP_RECV for fused secondary request
  block: ublk_drv: add common exit handling
  block: ublk_drv: don't consider flush request in map/unmap io
  block: ublk_drv: add two helpers to clean up map/unmap request
  block: ublk_drv: clean up several helpers
  block: ublk_drv: cleanup 'struct ublk_map_data'
  block: ublk_drv: cleanup ublk_copy_user_pages
  block: ublk_drv: grab request reference when the request is handled by
    userspace
  block: ublk_drv: support to copy any part of request pages
  block: ublk_drv: add read()/write() support for ublk char device
  block: ublk_drv: don't check buffer in case of zero copy
  block: ublk_drv: apply io_uring FUSED_CMD for supporting zero copy

 Documentation/block/ublk.rst   | 126 ++++++-
 drivers/block/ublk_drv.c       | 603 ++++++++++++++++++++++++++-------
 include/linux/io_uring.h       |  50 ++-
 include/linux/io_uring_types.h |  77 +++--
 include/uapi/linux/io_uring.h  |  11 +-
 include/uapi/linux/ublk_cmd.h  |  37 +-
 io_uring/Makefile              |   2 +-
 io_uring/fused_cmd.c           | 267 +++++++++++++++
 io_uring/fused_cmd.h           |  11 +
 io_uring/io_uring.c            |  51 ++-
 io_uring/io_uring.h            |   5 +
 io_uring/net.c                 |  30 +-
 io_uring/opdef.c               |  22 ++
 io_uring/opdef.h               |   7 +
 io_uring/rw.c                  |  21 ++
 15 files changed, 1142 insertions(+), 178 deletions(-)
 create mode 100644 io_uring/fused_cmd.c
 create mode 100644 io_uring/fused_cmd.h

-- 
2.39.2

