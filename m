Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD82D32C5B4
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhCDAYE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 19:24:04 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:52252 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1442091AbhCCL61 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 06:58:27 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UQFn1H2_1614772660;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQFn1H2_1614772660)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Mar 2021 19:57:40 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     msnitzer@redhat.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, mpatocka@redhat.com,
        caspar@linux.alibaba.com, joseph.qi@linux.alibaba.com
Subject: [PATCH v5 00/12] dm: support polling
Date:   Wed,  3 Mar 2021 19:57:28 +0800
Message-Id: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[Changes since v4]
- rebased to 5.12

- refactor patch 10 (fastpath) to fix the issue proposed by Mikulas
  Patocka in [1].
When bio doesn't get split and is submitted to *one* underlying device,
then the o=polling routine will go into the fastpath. The refactored
design is to return the dev_t of the underlying device the bio finnaly
submitted to as the returned cookie. The following polling routine will
call blkdev_get_no_open() to get blkdev by the dev_t stored in the
cookie, and thus fetch the corresponding hw queue.
One remained issue is that, blkdev_get_no_open() need to acquire global
lock @inode_hash_lock in ilookup(), and this may become the hot spot as
the polling threads increase. The RCU version (i.e.,
find_inode_by_ino_rcu()) maybe could be used here as an optimization.

- call disk->fops->poll() recursively in patch 12 to fix the issue
  described in [2] .

- update performance tests in [Performance Tests] chapter.

[1] https://listman.redhat.com/archives/dm-devel/2021-February/msg00255.html
[2] https://listman.redhat.com/archives/dm-devel/2021-February/msg00254.html



[Intention]
Bio-based polling (e.g., for dm/md devices) is one indispensable part of
high performance IO stack. As far as I know, dm (e.g., dm-stripe) is
widely used in database, splicing several NVMe disks as one whole disk,
in hope of achieving better performance. With this patch set, io_uring
could be used upon dm devices.


[Performance Tests]
1. fastpath (patch 10)
The polling routine will go into this path when bio submitted to dm
device is not split.

In this case, there will be only one bio submitted to only one polling
hw queue of one underlying mq device, and thus we don't need to track
all split bios or iterate through all polling hw queues. The pointer to
the polling hw queue the bio submitted to is returned here as the
returned cookie. In this case, the polling routine will call
mq_ops->poll() directly with the hw queue converted from the input
cookie.

- One process reading dm-linear (mapping to three underlying NVMe devices,
with one polling hw queue per NVMe device).

(ioengine=io_uring, iodepth=128, numjobs=1, rw=randread, sqthread_poll=0
direct=1, bs=4k)

	    	 | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
---------------- | --------------- | -------------------- | ----
with patchset    |	      214k |		     282k | ~32%


- Three processes reading dm-linear (mapping to three underlying NVMe
devices, with three polling hw queues per NVMe device), with every
process pinned to one CPU and mapped to one exclusive hw queue.

(ioengine=io_uring, iodepth=128, numjobs=3, rw=randread, sqthread_poll=0
direct=1, bs=4k)

	    	 | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
---------------- | --------------- | -------------------- | ----
with patchset    |	      629k |		     820k | ~30%



2. sub-fastpath (patch 11)

The polling routine will go into this path when bio submitted to dm
device gets split and enqueued into multiple hw queues, while the IO
submission process has not been migrated to another CPU.

In this case, the IO submission routine will return the CPU number on
which the IO submission happened as the returned cookie, while the
polling routine will only iterate and poll on hw queues that this CPU
number maps, instead of iterating *all* hw queues.

This optimization can dramatically reduce cache ping-pong and thus
improve the polling performance, when multiple hw queues in polling mode
per device could be reserved when there are multiple polling processes.

- Three processes reading dm-stripe (mapping to three underlying NVMe
devices, with three polling hw queues per NVMe device), with every
process pinned to one CPU and mapped to one exclusive hw queue.

(ioengine=io_uring, iodepth=128, numjobs=3, rw=randread, sqthread_poll=0
direct=1, bs=12k(4k for every NVMe device))

	    	 | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
---------------- | --------------- | -------------------- | ----
with patchset    |	      311k |		     409k | ~32%



[Changes since v3]
- newly add patch 7 and patch 11, as a new optimization improving
performance of multiple polling processes. Now performance of multiple
polling processes can be as scalable as single polling process (~30%).
Refer to the following [Performance] chapter for more details.


[Changes since v2]

Patchset v2 caches all hw queues (in polling mode) of underlying mq
devices in dm layer. The polling routine actually iterates through all
these cached hw queues.

However, mq may change the queue mapping at runtime (e.g., NVMe RESET
command), thus the cached hw queues in dm layer may be out-of-date. Thus
patchset v3 falls back to the implementation of the very first RFC
version, in which the mq layer needs to export one interface iterating
all polling hw queues (patch 5), and the bio-based polling routine just
calls this interface to iterate all polling hw queues.

Besides, several new optimization is proposed.


- patch 1,2,7
same as v2, untouched

- patch 3
Considering advice from Christoph Hellwig, while refactoring blk_poll(),
split mq and bio-based polling routine from the very beginning. Now
blk_poll() is just a simple entry. blk_bio_poll() is simply copied from
blk_mq_poll(), while the loop structure is some sort of duplication
though.

- patch 4
This patch is newly added to support turning on/off polling through
'/sys/block/<dev>/queue/io_poll' dynamiclly for bio-based devices.
Patchset v2 implemented this functionality by added one new queue flag,
which is not preferred since the queue flag resource is quite short of
nowadays.

- patch 5
This patch is newly added, preparing for the following bio-based
polling. The following bio-based polling will call this helper function,
accounting on the corresponding hw queue.

- patch 6
It's from the very first RFC version, preparing for the following
bio-based polling.

- patch 8
One fixing patch needed by the following bio-based polling. It's
actually a v2 of [1]. I had sent the v2 singly in-reply-to [1], though
it has not been visible on the mailing list maybe due to the delay.

- patch 9
It's from the very first RFC version.

- patch 10
This patch is newly added. Patchset v2 had ever proposed one
optimization that, skipping the **busy** hw queues during the iteration
phase. Back upon that time, one flag of 'atomic_t' is specifically
maintained in dm layer, representing if the corresponding hw queue is
busy or not. The idea is inherited, while the implementation changes.
Now @nvmeq->cq_poll_lock is used directly here, no need for extra flag
anymore.

This optimization can significantly reduce the competition for one hw
queue between multiple polling instances. Following statistics is the
test result when 3 threads concurrently randread (bs=4k, direct=1) one
dm-linear device, which is built upon 3 nvme devices, with one polling
hw queue per nvme device.

	    | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
----------- | --------------- | -------------------- | ----
without opt | 		 318k |		 	256k | ~-20%
with opt    |		 314k |		 	354k | ~13%
							

- patch 11
This is another newly added optimizatin for bio-based polling.

One intuitive insight is that, when the original bio submitted to dm
device doesn't get split, then the bio gets enqueued into only one hw
queue of one of the underlying mq devices. In this case, we no longer
need to track all split bios, and one cookie (for the only split bio)
is enough. It is implemented by returning the pointer to the
corresponding hw queue in this case.

It should be safe by directly returning the pointer to the hw queue,
since 'struct blk_mq_hw_ctx' won't be freed during the whole lifetime of
'struct request_queue'. Even when the number of hw queues may decrease
when NVMe RESET happens, the 'struct request_queue' structure of decreased
hw queues won't be freed, instead it's buffered into
&q->unused_hctx_list list.

Though this optimization seems quite intuitive, the performance test
shows that it does no benefit nor harm to the performance, while 3
threads concurrently randreading (bs=4k, direct=1) one dm-linear
device, which is built upon 3 nvme devices, with one polling hw queue
per nvme device.

I'm not sure why it doesn't work, maybe because the number of devices,
or the depth of the devcice stack is to low in my test case?


changes since v1:
- patch 1,2,4 is the same as v1 and have already been reviewed
- patch 3 is refactored a bit on the basis of suggestions from
Mike Snitzer.
- patch 5 is newly added and introduces one new queue flag
representing if the queue is capable of IO polling. This mainly
simplifies the logic in queue_poll_store().
- patch 6 implements the core mechanism supporting IO polling.
The sanity check checking if the dm device supports IO polling is
also folded into this patch, and the queue flag will be cleared if
it doesn't support, in case of table reloading.




Jeffle Xu (12):
  block: move definition of blk_qc_t to types.h
  block: add queue_to_disk() to get gendisk from request_queue
  block: add poll method to support bio-based IO polling
  block: add poll_capable method to support bio-based IO polling
  blk-mq: extract one helper function polling hw queue
  blk-mq: add iterator for polling hw queues
  blk-mq: add one helper function getting hw queue
  dm: always return BLK_QC_T_NONE for bio-based device
  nvme/pci: don't wait for locked polling queue
  block: fastpath for bio-based polling
  block: sub-fastpath for bio-based polling
  dm: support IO polling for bio-based dm device

 block/blk-core.c              | 143 +++++++++++++++++++++++++++++++++-
 block/blk-mq.c                |  37 +++------
 block/blk-sysfs.c             |  14 +++-
 drivers/md/dm-table.c         |  26 +++++++
 drivers/md/dm.c               |  98 +++++++++++++++++++----
 drivers/nvme/host/pci.c       |   4 +-
 include/linux/blk-mq.h        |  23 ++++++
 include/linux/blk_types.h     |  96 ++++++++++++++++++++++-
 include/linux/blkdev.h        |   4 +
 include/linux/device-mapper.h |   1 +
 include/linux/fs.h            |   2 +-
 include/linux/types.h         |   3 +
 include/trace/events/kyber.h  |   6 +-
 13 files changed, 405 insertions(+), 52 deletions(-)

-- 
2.27.0

