Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF7D304A2B
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 21:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbhAZFKZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 00:10:25 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:40002 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727870AbhAYMPk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 07:15:40 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UMpeZ6G_1611576820;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UMpeZ6G_1611576820)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Jan 2021 20:13:41 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com
Cc:     joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v2 0/6] dm: support IO polling for bio-based dm device
Date:   Mon, 25 Jan 2021 20:13:34 +0800
Message-Id: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since currently we have no simple but efficient way to implement the
bio-based IO polling in the split-bio tracking style, this patch set
turns to the original implementation mechanism that iterates and
polls all underlying hw queues in polling mode. One optimization is
introduced to mitigate the race of one hw queue among multiple polling
instances.

I'm still open to the split bio tracking mechanism, if there's
reasonable way to implement it.


[Performance Test]
The performance is tested by fio (engine=io_uring) 4k randread on
dm-linear device. The dm-linear device is built upon nvme devices,
and every nvme device has one polling hw queue (nvme.poll_queues=1).

Test Case		    | IOPS in IRQ mode | IOPS in polling mode | Diff
			    | (hipri=0)	       | (hipri=1)	      |
--------------------------- | ---------------- | -------------------- | ----
3 target nvme, num_jobs = 1 | 198k 	       | 276k		      | ~40%
3 target nvme, num_jobs = 3 | 608k 	       | 705k		      | ~16%
6 target nvme, num_jobs = 6 | 1197k 	       | 1347k		      | ~13%
3 target nvme, num_jobs = 6 | 1285k 	       | 1293k		      | ~0%

As the number of polling instances (num_jobs) increases, the
performance improvement decreases, though it's still positive
compared to the IRQ mode.

[Optimization]
To mitigate the race when iterating all the underlying hw queues, one
flag is maintained on a per-hw-queue basis. This flag is used to
indicate whether this polling hw queue currently being polled on or
not. Every polling hw queue is exclusive to one polling instance, i.e.,
the polling instance will skip this polling hw queue if this hw queue
currently is being polled by another polling instance, and start
polling on the next hw queue.

This per-hw-queue flag map is currently maintained in dm layer. In
the table load phase, a table describing all underlying polling hw
queues is built and stored in 'struct dm_table'. It is safe when
reloading the mapping table.


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


Jeffle Xu (6):
  block: move definition of blk_qc_t to types.h
  block: add queue_to_disk() to get gendisk from request_queue
  block: add iopoll method to support bio-based IO polling
  dm: always return BLK_QC_T_NONE for bio-based device
  block: add QUEUE_FLAG_POLL_CAP flag
  dm: support IO polling for bio-based dm device

 block/blk-core.c             |  76 +++++++++++++++++++++
 block/blk-mq.c               |  76 +++------------------
 block/blk-sysfs.c            |   3 +-
 drivers/md/dm-core.h         |  21 ++++++
 drivers/md/dm-table.c        | 127 +++++++++++++++++++++++++++++++++++
 drivers/md/dm.c              |  61 ++++++++++++-----
 include/linux/blk-mq.h       |   3 +
 include/linux/blk_types.h    |   2 +-
 include/linux/blkdev.h       |   9 +++
 include/linux/fs.h           |   2 +-
 include/linux/types.h        |   3 +
 include/trace/events/kyber.h |   6 +-
 12 files changed, 302 insertions(+), 87 deletions(-)

-- 
2.27.0

