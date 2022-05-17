Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D918529928
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 07:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbiEQFyR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 01:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiEQFyQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 01:54:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AEA7C3E5D8
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 22:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652766854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RgTypiFU9MrdMuBL1b7sGuUaK5nVLbYzi48+VEP8fg4=;
        b=JefJNz0KbRxHpo+0q4A+lRun2muv6lCpYclXgARsVk6EacquxLr0pn9iuJuuORKB1D324n
        DbjPYV1RZC0WTtJEHOu1zJ/OnEJWXzOC+/ZI7/AM3M/dZwg1ZQ62u/wugBuE/U1qwajgpw
        9/Li1br88K7sLS3b0wK4kP7S8sEN+VA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-z4MWKAO9Oe2XSSonbbh3UQ-1; Tue, 17 May 2022 01:54:13 -0400
X-MC-Unique: z4MWKAO9Oe2XSSonbbh3UQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AACA811E78;
        Tue, 17 May 2022 05:54:12 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 767951561476;
        Tue, 17 May 2022 05:54:11 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 0/1] ubd: add io_uring based userspace block driver
Date:   Tue, 17 May 2022 13:53:57 +0800
Message-Id: <20220517055358.3164431-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Guys,

ubd driver is one kernel driver for implementing generic userspace block
device/driver, which delivers io request from ubd block device(/dev/ubdbN) into
ubd server[1] which is the userspace part of ubd for communicating
with ubd driver and handling specific io logic by its target module.

Another thing ubd driver handles is to copy data between user space buffer
and request/bio's pages, or take zero copy if mm is ready for support it in
future. ubd driver doesn't handle any IO logic of the specific driver, so
it is small/simple, and all io logics are done by the target code in ubdserver.

The above two are main jobs done by ubd driver.

ubd driver can help to move IO logic into userspace, in which the
development work is easier/more effective than doing in kernel, such as,
ubd-loop takes < 200 lines of loop specific code to get basically same 
function with kernel loop block driver, meantime the performance is
still good. ubdsrv[1] provide built-in test for comparing both by running
"make test T=loop".

Another example is high performance qcow2 support[2], which could be built with
ubd framework more easily than doing it inside kernel.

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
It is suggested to use io_uring in userspace(target part of ubd server)
to handle IO request too. And it is still easy for ubdserver to support
io handling by non-io_uring, and this work isn't done yet, but can be
supported easily with help o eventfd.

This way is efficient since no extra io command copy is required, no sleep
is needed in transferring io command to userspace. Meantime the communication
protocol is simple and efficient, one single command of
UBD_IO_COMMIT_AND_FETCH_REQ can handle both fetching io request desc and commit
command result in one trip. IO handling is often batched after single
io_uring_enter() returns, both IO requests from ubd server target and
IO commands could be handled as a whole batch.

Remove RFC now because ubd driver codes gets lots of cleanup, enhancement and
bug fixes since V1:

- cleanup uapi: remove ubd specific error code,  switch to linux error code,
remove one command op, remove one field from cmd_desc

- add monitor mechanism to handle ubq_daemon being killed, ubdsrv[1]
  includes builtin tests for covering heavy IO with deleting ubd / killing
  ubq_daemon at the same time, and V2 pass all the two tests(make test T=generic),
  and the abort/stop mechanism is simple

- fix MQ command buffer mmap bug, and now 'xfstetests -g auto' works well on
  MQ ubd-loop devices(test/scratch)

- improve batching submission as suggested by Jens

- improve handling for starting device, replace random wait/poll with
completion

- all kinds of cleanup, bug fix,..

And the patch by patch change since V1 can be found in the following
tree:

https://github.com/ming1/linux/commits/my_for-5.18-ubd-devel_v2

Todo:
	- add lazy user page release for avoiding cost of pinning user pages in
	ubd_copy_pages() most of time, so we can save CPU for handling io logic
	in userpsace


[1] ubd server
https://github.com/ming1/ubdsrv/commits/devel-v2

[2] qcow2 kernel driver attempt
https://www.spinics.net/lists/kernel/msg4292965.html
https://patchwork.kernel.org/project/linux-block/cover/20190823225619.15530-1-development@manuel-bentele.de/#22841183

[3] [LSF/MM/BPF TOPIC] block drivers in user space
https://lore.kernel.org/linux-block/87tucsf0sr.fsf@collabora.com/

[4] Follow up on UBD discussion
https://lore.kernel.org/linux-block/YnsW+utCrosF0lvm@T590/#r

Ming Lei (1):
  ubd: add io_uring based userspace block driver

 drivers/block/Kconfig        |    6 +
 drivers/block/Makefile       |    2 +
 drivers/block/ubd_drv.c      | 1444 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/ubd_cmd.h |  158 ++++
 4 files changed, 1610 insertions(+)
 create mode 100644 drivers/block/ubd_drv.c
 create mode 100644 include/uapi/linux/ubd_cmd.h

-- 
2.31.1

