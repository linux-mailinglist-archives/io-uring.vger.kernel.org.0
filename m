Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC826AE237
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 15:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjCGOZn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 09:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjCGOZW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 09:25:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CEF898EF
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 06:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678198741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+90Rb+haSZGac0ZvSGoJPrVktpBwQO8o56mWUCSTShE=;
        b=Y+TdIEMyu8npmbvnSMTqAAltb0IY+miz+pSbEEoIstDUE0nZsWeqDgaOyD0EWa7ofEDshK
        IutVeiUiVx3S9Eg6p3blv6aY+nPz8KRuVvoAqBYvrCny2AM1o8p49ONPN51+Q6hW+DTZTV
        sJ7EDpiUPjzwGBpcXdbCpRcJ/gFDbXk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-28nEGoq0M1ST71E-lwIrDg-1; Tue, 07 Mar 2023 09:15:32 -0500
X-MC-Unique: 28nEGoq0M1ST71E-lwIrDg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE4141802D44;
        Tue,  7 Mar 2023 14:15:31 +0000 (UTC)
Received: from localhost (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B934C492B00;
        Tue,  7 Mar 2023 14:15:30 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Date:   Tue,  7 Mar 2023 22:15:03 +0800
Message-Id: <20230307141520.793891-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
64byte SQE(slave) is another normal 64byte OP. For any OP which needs
to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
and its ->issue() can retrieve/import buffer from master request's
fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
submits slave OP just like normal OP issued from userspace, that said,
SQE order is kept, and batching handling is done too.

Please see detailed design in commit log of the 3th patch, and one big
point is how to handle buffer ownership.

With this way, it is easy to support zero copy for ublk/fuse device.

Basically userspace can specify any sub-buffer of the ublk block request
buffer from the fused command just by setting 'offset/len'
in the slave SQE for running slave OP. This way is flexible to implement
io mapping: mirror, stripped, ...

The 4th & 5th patches enable fused slave support for the following OPs:

	OP_READ/OP_WRITE
	OP_SEND/OP_RECV/OP_SEND_ZC

The other ublk patches cleans ublk driver and implement fused command
for supporting zero copy.

Follows userspace code:

https://github.com/ming1/ubdsrv/tree/fused-cmd-zc-v2

All three(loop, nbd and qcow2) ublk targets have supported zero copy by passing:

	ublk add -t [loop|nbd|qcow2] -z .... 

Basic fs mount/kernel building and builtin test are done.

Also add liburing test case for covering fused command based on miniublk
of blktest:

https://github.com/ming1/liburing/commits/fused_cmd_miniublk

Performance improvement is obvious on memory bandwidth
related workloads, such as, 1~2X improvement on 64K/512K BS
IO test on loop with ramfs backing file.

Any comments are welcome!

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

Ming Lei (17):
  io_uring: add IO_URING_F_FUSED and prepare for supporting OP_FUSED_CMD
  io_uring: increase io_kiocb->flags into 64bit
  io_uring: add IORING_OP_FUSED_CMD
  io_uring: support OP_READ/OP_WRITE for fused slave request
  io_uring: support OP_SEND_ZC/OP_RECV for fused slave request
  block: ublk_drv: mark device as LIVE before adding disk
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

 drivers/block/ublk_drv.c       | 605 ++++++++++++++++++++++++++-------
 drivers/char/mem.c             |   4 +
 drivers/nvme/host/ioctl.c      |   9 +
 include/linux/io_uring.h       |  49 ++-
 include/linux/io_uring_types.h |  18 +-
 include/uapi/linux/io_uring.h  |   1 +
 include/uapi/linux/ublk_cmd.h  |  37 +-
 io_uring/Makefile              |   2 +-
 io_uring/fused_cmd.c           | 232 +++++++++++++
 io_uring/fused_cmd.h           |  11 +
 io_uring/io_uring.c            |  22 +-
 io_uring/io_uring.h            |   3 +
 io_uring/net.c                 |  23 +-
 io_uring/opdef.c               |  17 +
 io_uring/opdef.h               |   2 +
 io_uring/rw.c                  |  20 ++
 16 files changed, 926 insertions(+), 129 deletions(-)
 create mode 100644 io_uring/fused_cmd.c
 create mode 100644 io_uring/fused_cmd.h

-- 
2.39.2

