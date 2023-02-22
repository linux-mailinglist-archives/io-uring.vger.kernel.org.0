Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9F969F546
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 14:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjBVN0N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 08:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbjBVN0M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 08:26:12 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1238D3B64F;
        Wed, 22 Feb 2023 05:25:41 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VcH3mW5_1677072334;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VcH3mW5_1677072334)
          by smtp.aliyun-inc.com;
          Wed, 22 Feb 2023 21:25:34 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ming.lei@redhat.com, axboe@kernel.dk, asml.silence@gmail.com,
        ZiyangZhang@linux.alibaba.com
Subject: [RFC v2 0/4] Add io_uring & ebpf based methods to implement zero-copy for ublk
Date:   Wed, 22 Feb 2023 21:25:30 +0800
Message-Id: <20230222132534.114574-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Normally, userspace block device implementations need to copy data between
kernel block layer's io requests and userspace block device's userspace
daemon. For example, ublk and tcmu both have similar logic, but this
operation will consume cpu resources obviously, especially for large io.

There are methods trying to reduce these cpu overheads, then userspace
block device's io performance will be improved further. These methods
contain: 1) use special hardware to do memory copy, but seems not all
architectures have these special hardware; 2) software methods, such as
mmap kernel block layer's io requests's data to userspace daemon [1],
but it has page table's map/unmap, tlb flush overhead, security issue,
etc, and it maybe only friendly to large io.

To solve this problem, I'd propose a new method, which will combine the
respective advantages of io_uring and ebpf. Add a new program type
BPF_PROG_TYPE_UBLK for ublk, userspace block device daemon process will
register ebpf progs, which will use bpf helper offered by ublk bpf prog
type to submit io requests on behalf of daemon process in kernel, note
io requests will use kernel block layer io reqeusts's pages to do io,
then the memory copy overhead will be gone.

Currently only one helper has beed added:
    u64 bpf_ublk_queue_sqe(struct ublk_io_bpf_ctx *bpf_ctx,
                struct io_uring_sqe *sqe, u32 sqe_len, u32, fd)

This helper will use io_uring to submit io requests, so we need to make
io_uring be able to submit a sqe located in kernel(Some codes idea comes
from Pavel's patchset [2], but pavel's patch needs sqe->buf comes from
userspace addr). Bpf prog will initialize sqes, but does not need to
initializes sqes' buf field, sqe->buf will come from kernel block layer
io requests in some form. See patch 2 for more.

By using ebpf, we can implement various userspace io logic in kernel,
and the ultimate goal is to support users to build an in-kernel io
agent for userspace daemon, userspace block device's daemon justs
registers an ebpf at startup, though which I think there'll be a long
way to go. There'll be advantages at least:
  1. Remove memory copy between kernel block layer and userspace daemon
completely.
  2. Save memory. Userspace daemon doesn't need to maintain memory to
issue and complete io requests, and use kernel block layer io requests
memory directly.
  2. We may reduce the number of round trips between kernel and userspace
daemon, so may reduce kernel & userspace context switch overheads.

HOW to test:
  git clone https://github.com/ming1/ubdsrv
  cd ubdsrv
  git am -3 0001-Add-ebpf-support.patch
  # replace "/root/ublk/" with your own linux build directory
  cd bpf; make; cd ..;
  ./build_with_liburing_src
  ./ublk add -t loop -q 1 -d 128 -f loop.file

fio job file:
  [global]
  direct=1
  filename=/dev/ublkb0
  time_based
  runtime=60
  numjobs=1
  cpus_allowed=1

  [rand-read-4k]
  bs=2048K
  iodepth=16
  ioengine=libaio
  rw=randwrite
  stonewall

Without this patch:
  READ: bw=373MiB/s (392MB/s), 373MiB/s-373MiB/s (392MB/s-392MB/s), io=21.9GiB (23.5GB), run=60042-60042msec
  WRITE: bw=371MiB/s (389MB/s), 371MiB/s-371MiB/s (389MB/s-389MB/s), io=21.8GiB (23.4GB), run=60042-60042msec
  ublk daemon's cpu utilization is about 12.5%, showed by top tool.

With this patch:
  READ: bw=373MiB/s (392MB/s), 373MiB/s-373MiB/s (392MB/s-392MB/s), io=21.9GiB (23.5GB), run=60043-60043msec
  WRITE: bw=371MiB/s (389MB/s), 371MiB/s-371MiB/s (389MB/s-389MB/s), io=21.8GiB (23.4GB), run=60043-60043msec
ublk daemon's cpu utilization is about 1%, showed by top tool.

From above tests, this method can reduce cpu copy overhead obviously.

TODO:
I must say this patchset is still just a RFC for design.

1. Currently for this patchset, I just make ublk ebpf prog submit io requests
using io_uring in kernel, cqe event still needs to be handled in userspace
daemon. Once later we succeed in make io_uring handle cqe in kernel, ublk
ebpf prog can implement io in kernel.

2. I have not done much tests yet, will run liburing/ublk/blktests later.

3. Try to build complicated ebpf prog.

Any review and suggestions are welcome, thanks.

[1] https://lore.kernel.org/all/20220318095531.15479-1-xiaoguang.wang@linux.alibaba.com/
[2] https://lore.kernel.org/all/cover.1621424513.git.asml.silence@gmail.com/

Xiaoguang Wang (4):
  bpf: add UBLK program type
  io_uring: enable io_uring to submit sqes located in kernel
  io_uring: introduce IORING_URING_CMD_UNLOCK flag
  ublk_drv: add ebpf support

 drivers/block/ublk_drv.c       | 284 +++++++++++++++++++++++++++++++--
 include/linux/bpf_types.h      |   2 +
 include/linux/io_uring.h       |  12 ++
 include/linux/io_uring_types.h |   8 +-
 include/uapi/linux/bpf.h       |   2 +
 include/uapi/linux/io_uring.h  |   5 +
 include/uapi/linux/ublk_cmd.h  |  18 +++
 io_uring/io_uring.c            |  59 ++++++-
 io_uring/rsrc.c                |  18 +++
 io_uring/rsrc.h                |   4 +
 io_uring/rw.c                  |   7 +
 io_uring/uring_cmd.c           |   6 +-
 kernel/bpf/syscall.c           |   1 +
 kernel/bpf/verifier.c          |  10 +-
 scripts/bpf_doc.py             |   4 +
 tools/include/uapi/linux/bpf.h |  10 ++
 tools/lib/bpf/libbpf.c         |   1 +
 17 files changed, 434 insertions(+), 17 deletions(-)

-- 
2.31.1

