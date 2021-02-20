Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE3A3204F4
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 12:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBTLHb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 06:07:31 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:47365 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229734AbhBTLHY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 06:07:24 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UP1N.Dc_1613819197;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UP1N.Dc_1613819197)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Feb 2021 19:06:37 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, axboe@kernel.dk
Cc:     hch@lst.de, ming.lei@redhat.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com
Subject: [PATCH v4 00/12] dm: support IO polling
Date:   Sat, 20 Feb 2021 19:06:25 +0800
Message-Id: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[Changes since v3]
- newly add patch 7 and patch 11, as a new optimization improving
performance of multiple polling processes. Now performance of multiple
polling processes can be as scalable as single polling process (~30%).
Refer to the following [Performance] chapter for more details.


[Intention]
Bio-based polling (e.g., for dm/md devices) is one indispensable part of
high performance IO stack. As far as I know, dm (e.g., dm-stripe) is
widely used in database, splicing several NVMe disks as one whole disk,
in hope of achieving better performance. With this patch set, io_uring
could be used upon dm devices.


[Optimizations]
Basically, there are three paths for IO polling.

1. fastpath (patch 9/10)
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
with patchset    |	      212k |		     284k | ~32%


- Three processes reading dm-linear (mapping to three underlying NVMe
devices, with one polling hw queue per NVMe device).

(ioengine=io_uring, iodepth=128, numjobs=3, rw=randread, sqthread_poll=0
direct=1, bs=4k)

	    	 | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
---------------- | --------------- | -------------------- | ----
with patchset    |	      615k |		     735k | ~16%


- Three processes reading dm-linear (mapping to three underlying NVMe
devices, with three polling hw queues per NVMe device), with every
process pinned to one CPU and mapped to one exclusive hw queue.

(ioengine=io_uring, iodepth=128, numjobs=3, rw=randread, sqthread_poll=0
direct=1, bs=4k)

	    	 | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
---------------- | --------------- | -------------------- | ----
with patchset    |	      631k |		     833k | ~32%



2. sub-fastpath (patch 7/11)

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
with patchset    |	      307k |		     412k | ~34%


3. default path

It will fall back to iterating all hw queues in polling mode, once bio
submitted to dm device gets split and enqueued into multiple hw queues,
and the IO process has ever been migrated to another CPU during the IO
submission phase.


[Remained Issue]
It has been mentioned in patch 4 that, users could change the state of
the underlying devices through '/sys/block/<dev>/io_poll', bypassing
the dm device above. Thus it can cause a situation where QUEUE_FLAG_POLL
is still set for the request_queue of dm device, while one of the
underlying mq device may has cleared this flag.

In this case, it will pass the 'test_bit(QUEUE_FLAG_POLL, &q->queue_flags)'
check in blk_poll(), while the input cookie may actually points to a hw
queue in IRQ mode since patch 11. Thus for this hw queue (in IRQ mode),
the bio-based polling routine will handle this hw queue acquiring
'spin_lock(&nvmeq->cq_poll_lock)' (refer
drivers/nvme/host/pci.c:nvme_poll), which is not adequate since this hw
queue may also be accessed in IRQ context. In other words,
spin_lock_irq() should be used here.

I have not come up one simple way to fix it. I don't want to do sanity
check (e.g., the type of the hw queue is HCTX_TYPE_POLL or not) in the
IO path (submit_bio()/blk_poll()), i.e., fast path.

We'd better fix it in the control path, i.e., dm could be aware of the
change when attribute (e.g., support io_poll or not) of one of the
underlying devices changed at runtime.




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

 block/blk-core.c              | 112 +++++++++++++++++++++++++++++++++-
 block/blk-mq.c                |  37 ++++-------
 block/blk-sysfs.c             |  14 ++++-
 drivers/md/dm-table.c         |  26 ++++++++
 drivers/md/dm.c               | 102 ++++++++++++++++++++++++++-----
 drivers/nvme/host/pci.c       |   4 +-
 include/linux/blk-mq.h        |  23 +++++++
 include/linux/blk_types.h     |  66 +++++++++++++++++++-
 include/linux/blkdev.h        |   4 ++
 include/linux/device-mapper.h |   1 +
 include/linux/fs.h            |   2 +-
 include/linux/types.h         |   3 +
 include/trace/events/kyber.h  |   6 +-
 13 files changed, 350 insertions(+), 50 deletions(-)

-- 
2.27.0

