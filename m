Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25BEF56D2EC
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 04:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiGKCUl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jul 2022 22:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGKCUk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Jul 2022 22:20:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18D5F18388
        for <io-uring@vger.kernel.org>; Sun, 10 Jul 2022 19:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657506037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=V90RpXCMUf166H8KtoRQf7fVa5XCqmkDpqP3naudejY=;
        b=UdUEKjtakFCKPZmE1e1sxd4LtyQiUONJLiqe81JT42qDXDmtpshdVXRp0yZmrbcC1p+GI/
        NFVzlKKzeBZ2KLVsJ8/q59qkreBRfgle2d56kdAEhMaU8HjpZPdPLvSXizLDqmNM4SHH7O
        eoDl7YzyAJW3jOH53+7FT5XNH7iY4mk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-yAUo5vN3P0GA7O74f7r8bQ-1; Sun, 10 Jul 2022 22:20:34 -0400
X-MC-Unique: yAUo5vN3P0GA7O74f7r8bQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B21B1C13940;
        Mon, 11 Jul 2022 02:20:33 +0000 (UTC)
Received: from localhost (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 242961121314;
        Mon, 11 Jul 2022 02:20:31 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 0/2] ublk: add io_uring based userspace block driver
Date:   Mon, 11 Jul 2022 10:20:22 +0800
Message-Id: <20220711022024.217163-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Guys,

ublk driver is one kernel driver for implementing generic userspace block
device/driver, which delivers io request from ublk block device(/dev/ublkbN) into
ublk server[1] which is the userspace part of ublk for communicating
with ublk driver and handling specific io logic by its target module.

Another thing ublk driver handles is to copy data between user space buffer
and request/bio's pages, or take zero copy if mm is ready for support it in
future. ublk driver doesn't handle any IO logic of the specific driver, so
it is small/simple, and all io logics are done by the target code in ublkserver.

The above two are main jobs done by ublk driver.

ublk driver can help to move IO logic into userspace, in which the
development work is easier/more effective than doing in kernel, such as,
ublk-loop takes < 200 lines of loop specific code to get basically same 
function with kernel loop block driver, meantime the performance is
is even better than kernel loop with same setting. ublksrv[1] provide built-in
test for comparing both by running "make test T=loop", for example, see
the test result running on VM which is over my lattop(root disk is
nvme/device mapper/xfs):

	[root@ktest-36 ubdsrv]#make -s -C /root/git/ubdsrv/tests run T=loop/001 R=10
	running loop/001
		fio (ublk/loop(/root/git/ubdsrv/tests/tmp/ublk_loop_VqbMA), libaio, bs 4k, dio, hw queues:1)...
		randwrite: jobs 1, iops 32572
		randread: jobs 1, iops 143052
		rw: jobs 1, iops read 29919 write 29964
	
	[root@ktest-36 ubdsrv]# make test T=loop/003
	make -s -C /root/git/ubdsrv/tests run T=loop/003 R=10
	running loop/003
		fio (kernel_loop/kloop(/root/git/ubdsrv/tests/tmp/ublk_loop_ZIVnG), libaio, bs 4k, dio, hw queues:1)...
		randwrite: jobs 1, iops 27436
		randread: jobs 1, iops 95273
		rw: jobs 1, iops read 22542 write 22543 


Another example is high performance qcow2 support[2], which could be built with
ublk framework more easily than doing it inside kernel.

Also there are more people who express interests on userspace block driver[3],
Gabriel Krisman Bertazi proposes this topic in lsf/mm/ebpf 2022 and mentioned
requirement from Google. Ziyang Zhang from Alibaba said they "plan to
replace TCMU by UBD as a new choice" because UBD can get better throughput than
TCMU even with single queue[4], meantime UBD is simple. Also there is userspace
storage service for providing storage to containers.

It is io_uring based: io request is delivered to userspace via new added
io_uring command which has been proved as very efficient for making nvme
passthrough IO to get better IOPS than io_uring(READ/WRITE). Meantime one
shared/mmap buffer is used for sharing io descriptor to userspace, the
buffer is readonly for userspace, each IO just takes 24bytes so far.
It is suggested to use io_uring in userspace(target part of ublk server)
to handle IO request too. And it is still easy for ublkserver to support
io handling by non-io_uring, and this work isn't done yet, but can be
supported easily with help o eventfd.

This way is efficient since no extra io command copy is required, no sleep
is needed in transferring io command to userspace. Meantime the communication
protocol is simple and efficient, one single command of
UBD_IO_COMMIT_AND_FETCH_REQ can handle both fetching io request desc and commit
command result in one trip. IO handling is often batched after single
io_uring_enter() returns, both IO requests from ublk server target and
IO commands could be handled as a whole batch.

And the patch by patch change can be found in the following
tree:

https://github.com/ming1/linux/tree/my_for-5.20-ubd-devel_v4

ublk server repo(master branch):

	https://github.com/ming1/ubdsrv

Any comments are welcome!

Since V3:
- address Gabriel Krisman Bertazi's comments on V3: add userspace data
  validation before handling command, remove warning, ...
- remove UBLK_IO_COMMIT_REQ command as suggested by Zixiang and Gabriel Krisman Bertazi
- fix one request double free when running abort
- rewrite/cleanup ublk_copy_pages(), then this handling becomes very
  clean
- add one command of UBLK_IO_REFETCH_REQ for allowing ublk_drv to build
  as module

Since V2:
- fix one big performance problem:
	https://github.com/ming1/linux/commit/3c9fd476951759858cc548dee4cedc074194d0b0
- rename as ublk, as suggested by Gabriel Krisman Bertazi 
- lots of cleanup & code improvement & bugfix, see details in git
  hisotry


Since V1:

Remove RFC now because ublk driver codes gets lots of cleanup, enhancement and
bug fixes since V1:

- cleanup uapi: remove ublk specific error code,  switch to linux error code,
remove one command op, remove one field from cmd_desc

- add monitor mechanism to handle ubq_daemon being killed, ublksrv[1]
  includes builtin tests for covering heavy IO with deleting ublk / killing
  ubq_daemon at the same time, and V2 pass all the two tests(make test T=generic),
  and the abort/stop mechanism is simple

- fix MQ command buffer mmap bug, and now 'xfstetests -g auto' works well on
  MQ ublk-loop devices(test/scratch)

- improve batching submission as suggested by Jens

- improve handling for starting device, replace random wait/poll with
completion

- all kinds of cleanup, bug fix,..

Ming Lei (2):
  ublk: add io_uring based userspace block driver
  ublk_drv: add UBLK_IO_REFETCH_REQ for supporting to build as module

 drivers/block/Kconfig         |    6 +
 drivers/block/Makefile        |    2 +
 drivers/block/ublk_drv.c      | 1701 +++++++++++++++++++++++++++++++++
 include/uapi/linux/ublk_cmd.h |  173 ++++
 4 files changed, 1882 insertions(+)
 create mode 100644 drivers/block/ublk_drv.c
 create mode 100644 include/uapi/linux/ublk_cmd.h

-- 
2.31.1

