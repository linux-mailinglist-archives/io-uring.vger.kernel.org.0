Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134896D0350
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 13:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjC3Lhx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 07:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjC3Lhf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 07:37:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08ECB185
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 04:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680176210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FQbJpo8DfRhF5qSisIUk4m0kSC7VBBioGITHpw45wmo=;
        b=GJsvA/5Ia3nA5SJUTfmDathx5rroHXZ0/h5lI9GakgpIQAfSOEfW4cVqEPdjJYUoR7665j
        MZVwZ6CiD6g/cO7H6aGojASZVyhiqfcQsM8RNPMmXyxMS9ZrWF76s4I1HnFapyIy3I/U0W
        +E+jG5mI2H9Sw7a2Z76f05ckZIDQALk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-lUZBAN4vPMiFAq0RTvAnVA-1; Thu, 30 Mar 2023 07:36:47 -0400
X-MC-Unique: lUZBAN4vPMiFAq0RTvAnVA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABA80185A792;
        Thu, 30 Mar 2023 11:36:46 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B326B2166B33;
        Thu, 30 Mar 2023 11:36:44 +0000 (UTC)
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
Subject: [PATCH V6 00/17] io_uring/ublk: add generic IORING_OP_FUSED_CMD
Date:   Thu, 30 Mar 2023 19:36:13 +0800
Message-Id: <20230330113630.1388860-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Jens and Guys,

Add generic fused command, which can include one primary command and multiple
secondary requests. This command provides one safe way to share resource between
primary command and secondary requests, and primary command is always
completed after all secondary requests are done, and resource lifetime
is bound with primary command.

With this way, it is easy to support zero copy for ublk/fuse device, and
there could be more potential use cases, such as offloading complicated logic
into userspace, or decouple kernel subsystems.

Follows ublksrv code, which implements zero copy for loop, nbd and
qcow2 targets with fused command:

https://github.com/ming1/ubdsrv/tree/fused-cmd-zc-for-v6

All three(loop, nbd and qcow2) ublk targets have supported zero copy by passing:

	ublk add -t [loop|nbd|qcow2] -z .... 

Also add liburing test case for covering fused command based on miniublk
of blktest.

https://github.com/ming1/liburing/tree/fused_cmd_miniublk_for_v6

Performance improvement is obvious on memory bandwidth related workloads,
such as, 1~2X improvement on 64K/512K BS IO test on loop with ramfs backing file.
ublk-null shows 5X IOPS improvement on big BS test when the copy is avoided.

Please review and consider for v6.4.

V6:
	- re-design fused command, and make it more generic, moving sharing buffer
	as one plugin of fused command, so in future we can implement more plugins
	- document potential other use cases of fused command
	- drop support for builtin secondary sqe in SQE128, so all secondary
	  requests has standalone SQE
	- make fused command as one feature
	- cleanup & improve naming

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


Ming Lei (17):
  io_uring: increase io_kiocb->flags into 64bit
  io_uring: use ctx->cached_sq_head to calculate left sqes
  io_uring: add generic IORING_OP_FUSED_CMD
  io_uring: support providing buffer by IORING_OP_FUSED_CMD
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
 include/linux/io_uring.h       |  41 ++-
 include/linux/io_uring_types.h |  76 +++--
 include/uapi/linux/io_uring.h  |  22 +-
 include/uapi/linux/ublk_cmd.h  |  37 +-
 io_uring/Makefile              |   2 +-
 io_uring/fused_cmd.c           | 239 +++++++++++++
 io_uring/fused_cmd.h           |  16 +
 io_uring/io_uring.c            |  57 +++-
 io_uring/io_uring.h            |   5 +
 io_uring/net.c                 |  30 +-
 io_uring/opdef.c               |  22 ++
 io_uring/opdef.h               |   7 +
 io_uring/rw.c                  |  21 ++
 15 files changed, 1124 insertions(+), 180 deletions(-)
 create mode 100644 io_uring/fused_cmd.c
 create mode 100644 io_uring/fused_cmd.h

-- 
2.39.2

