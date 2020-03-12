Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E50182ECD
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2020 12:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgCLLQr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Mar 2020 07:16:47 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:42460 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbgCLLQq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Mar 2020 07:16:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04396;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0TsNh5VG_1584011789;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TsNh5VG_1584011789)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 Mar 2020 19:16:34 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [FIO PATCH] engines/io_uring: delete fio_option_is_set() calls when submitting sqes
Date:   Thu, 12 Mar 2020 19:16:17 +0800
Message-Id: <20200312111617.7384-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.14.4.44.g2045bb6
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The fio_option_is_set() call in fio_ioring_prep() is time-consuming,
which will reduce sqe's submit rate drastically. To fix this issue,
add two new variables to record whether ioprio_class or ioprio_set
is set. I use a simple fio job to evaluate the performance:
    fio -name=fiotest -filename=/dev/nvme0n1 -iodepth=4 -thread -rw=read
    -ioengine=io_uring -hipri=0 -sqthread_poll=0 -direct=1 -bs=4k -size=10G
    -numjobs=1 -time_based -runtime=120

Before this patch:
  READ: bw=969MiB/s (1016MB/s), 969MiB/s-969MiB/s (1016MB/s-1016MB/s),
  io=114GiB (122GB), run=120001-120001msec

With this patch:
  READ: bw=1259MiB/s (1320MB/s), 1259MiB/s-1259MiB/s (1320MB/s-1320MB/s),
  io=148GiB (158GB), run=120001-120001msec

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 engines/io_uring.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 1efc6cf..ac57af8 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -63,6 +63,8 @@ struct ioring_data {
 	int queued;
 	int cq_ring_off;
 	unsigned iodepth;
+	bool ioprio_class_set;
+	bool ioprio_set;
 
 	struct ioring_mmap mmap[3];
 };
@@ -233,9 +235,9 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 		}
 		if (!td->o.odirect && o->uncached)
 			sqe->rw_flags = RWF_UNCACHED;
-		if (fio_option_is_set(&td->o, ioprio_class))
+		if (ld->ioprio_class_set)
 			sqe->ioprio = td->o.ioprio_class << 13;
-		if (fio_option_is_set(&td->o, ioprio))
+		if (ld->ioprio_set)
 			sqe->ioprio |= td->o.ioprio;
 		sqe->off = io_u->offset;
 	} else if (ddir_sync(io_u->ddir)) {
@@ -685,6 +687,12 @@ static int fio_ioring_init(struct thread_data *td)
 		td_verror(td, EINVAL, "fio_io_uring_init");
 		return 1;
 	}
+
+	if (fio_option_is_set(&td->o, ioprio_class))
+		ld->ioprio_class_set = true;
+	if (fio_option_is_set(&td->o, ioprio))
+		ld->ioprio_set = true;
+
 	return 0;
 }
 
-- 
1.8.3.1

