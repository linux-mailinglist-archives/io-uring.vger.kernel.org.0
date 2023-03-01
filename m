Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFDA6A6DDB
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 15:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjCAOI0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 09:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCAOIZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 09:08:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6304D2A6F3
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 06:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677679666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=utGXQWkLu0b7Z5wyTAim3ydtWqCkLOZ4Jgg2eOkulrU=;
        b=Njjg7dhAd4OnjEAOrMks9ycjhh0hfhGSDBxdJqo4hK9X2bdxc91MD3Wf/xBRi7jlc6WyMa
        Llvi1Vjx+8XzvmZwf9UmeWx58B+Gm6B1yFqyMYe7VxbjA4qSO6pZeFq9gs/kUDLUGxMPf/
        dJtpYo2hKlosP4ENX/625bU3y0e8gEo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-GkOoL6nHP6WvT3Oxgxqf8w-1; Wed, 01 Mar 2023 09:07:37 -0500
X-MC-Unique: GkOoL6nHP6WvT3Oxgxqf8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 698333853422;
        Wed,  1 Mar 2023 14:06:24 +0000 (UTC)
Received: from localhost (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BB622026D2A;
        Wed,  1 Mar 2023 14:06:23 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 00/12] io_uring: add IORING_OP_FUSED_CMD
Date:   Wed,  1 Mar 2023 22:05:59 +0800
Message-Id: <20230301140611.163055-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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

Please see detailed design in commit log of the 7th patch, and one big
point is how to handle buffer ownership.

With this way, it is easy to support zero copy for ublk/fuse device.

Basically userspace can specify any sub-buffer of the ublk block request
buffer from the fused command just by setting 'offset/len'
in the slave SQE for running slave OP. This way is flexible to implement
io mapping: mirror, stripped, ...

The 8th & 9th patches enable fused slave support for the following OPs:

	OP_READ/OP_WRITE
	OP_SEND/OP_RECV/OP_SEND_ZC

The last 3 patches implement fused command support for ublk driver.

Follows userspace code:

https://github.com/ming1/ubdsrv/tree/fused-cmd-zc

Both loop and nbd ublk targets have supported zero copy by passing:

	ublk add -t [loop|nbd] -z .... 

Basic fs mount/kernel building and builtin test are done.

Performance improvement is obvious on memory bandwidth
related workloads, such as, 1~2X improvement on 64K/512K BS
IO test on loop with ramfs backing file.

Any comments are welcome!


Ming Lei (12):
  io_uring: increase io_kiocb->flags into 64bit
  io_uring: define io_mapped_ubuf->acct_pages as unsigned integer
  io_uring: extend io_mapped_ubuf to cover external bvec table
  io_uring: rename io_mapped_ubuf as io_mapped_buf
  io_uring: export 'struct io_mapped_buf' for fused cmd buffer
  io_uring: add IO_URING_F_FUSED and prepare for supporting OP_FUSED_CMD
  io_uring: add IORING_OP_FUSED_CMD
  io_uring: support OP_READ/OP_WRITE for fused slave request
  io_uring: support OP_SEND_ZC/OP_RECV for fused slave request
  block: ublk_drv: mark device as LIVE before adding disk
  block: ublk_drv: add common exit handling
  block: ublk_drv: apply io_uring FUSED_CMD for supporting zero copy

 drivers/block/ublk_drv.c       | 189 ++++++++++++++++++++++++--
 drivers/char/mem.c             |   4 +
 drivers/nvme/host/ioctl.c      |   9 ++
 include/linux/io_uring.h       |  65 ++++++++-
 include/linux/io_uring_types.h |  26 +++-
 include/uapi/linux/io_uring.h  |   1 +
 include/uapi/linux/ublk_cmd.h  |   1 +
 io_uring/Makefile              |   2 +-
 io_uring/fdinfo.c              |   6 +-
 io_uring/fused_cmd.c           | 233 +++++++++++++++++++++++++++++++++
 io_uring/fused_cmd.h           |  11 ++
 io_uring/io_uring.c            |  24 +++-
 io_uring/io_uring.h            |   3 +
 io_uring/net.c                 |  23 +++-
 io_uring/opdef.c               |  17 +++
 io_uring/opdef.h               |   2 +
 io_uring/rsrc.c                |  31 ++---
 io_uring/rsrc.h                |  12 +-
 io_uring/rw.c                  |  20 +++
 19 files changed, 623 insertions(+), 56 deletions(-)
 create mode 100644 io_uring/fused_cmd.c
 create mode 100644 io_uring/fused_cmd.h

-- 
2.31.1

