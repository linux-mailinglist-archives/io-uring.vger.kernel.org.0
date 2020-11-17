Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315EB2B5A95
	for <lists+io-uring@lfdr.de>; Tue, 17 Nov 2020 08:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgKQH4a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Nov 2020 02:56:30 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:37963 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbgKQH4a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Nov 2020 02:56:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UFgn5fM_1605599785;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UFgn5fM_1605599785)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 17 Nov 2020 15:56:25 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     axboe@kernel.dk, hch@infradead.org, ming.lei@redhat.com
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com
Subject: [PATCH v4 0/2] block, iomap: disable iopoll for split bio
Date:   Tue, 17 Nov 2020 15:56:23 +0800
Message-Id: <20201117075625.46118-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset is to fix the potential hang occurred in sync polling.

Please refer the following link for background info and the v1 patch:
https://patchwork.kernel.org/project/linux-block/patch/20201013084051.27255-1-jefflexu@linux.alibaba.com/

The first patch disables iopoll for split bio in block layer, which is
suggested by Ming Lei.


The second patch disables iopoll when one dio need to be split into
multiple bios. As for this patch, Ming Lei had ever asked what's the
expected behaviour of upper layers when simply clear IOCB_HIPRI in
the direct routine of blkdev fs, iomap-based fs. Currently there are
two parts concerning IOCB_HIPRI (or io polling). One is the sync
polling logic embedded in the direct IO routine. In this case, sync
polling won't be executed any more since IOCB_HIPRI flag has been
cleared from iocb->ki_flags. Consider the following code snippet:

fs/block_dev.c: __blkdev_direct_IO
	for (;;) {
		...
		if (!(iocb->ki_flags & IOCB_HIPRI) ||
		    !blk_poll(bdev_get_queue(bdev), qc, true))
			blk_io_schedule();
	}

fs/iomap/direct-io.c: __iomap_dio_rw
	for (;;) {
		...
		if (!(iocb->ki_flags & IOCB_HIPRI) ||
		    !dio->submit.last_queue ||
		    !blk_poll(dio->submit.last_queue,
				 dio->submit.cookie, true))
			blk_io_schedule();
	}


The other part is io_uring. 

fs/io_uring.c: 
io_iopoll_getevents
  io_do_iopoll
    list_for_each_entry_safe(...) {
      ret = kiocb->ki_filp->f_op->iopoll(kiocb, spin);
    }

In this case, though the split bios have been enqueued into DEFAULT
hw queues, io_uring will still poll POLL hw queues. When polling on
the cookie returned by split bio, blk_poll() will return 0 immediately
since the hw queue type check added in patch 1. If there's no other
bio in the POLL hw queues, io_do_iopoll() will loop indefinitely
until the split bio is completed by interrupt of DEFAULT queue. Indeed
there may be a pulse of high CPU sys in this time window here, but it
is no worse than before. After all io_do_iopoll() will still get stuck
in this loop when there's only one bio (that we are polling on) in POLL
hw queue, before this patch applied.

The situation described above may be less impossible. As long as there
are other bios in POLL hw queue, work of io_do_iopoll() is still
meaningful as it *helps* reap these other bios in POLL hw queue, while
the split bios are still completed by interrupt of DEFAULT hw queue.


changes since v3:
- patch 1: add hw queue type check in blk_poll(), so that cookie returned
  by split bio won't get into the real polling routine

changes since v2:
- tune the line length of patch 1
- fix the condition checking whether split needed in patch 2

changes since v1:
- adopt the fix suggested by Ming Lei, to disable iopoll for split bio directly
- disable iopoll in direct IO routine of blkdev fs and iomap

Jeffle Xu (2):
  block: disable iopoll for split bio
  block,iomap: disable iopoll when split needed

 block/blk-merge.c    |  7 +++++++
 block/blk-mq.c       |  6 ++++--
 fs/block_dev.c       |  9 +++++++++
 fs/iomap/direct-io.c | 10 ++++++++++
 4 files changed, 30 insertions(+), 2 deletions(-)

-- 
2.27.0

