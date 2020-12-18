Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464A72DDF0F
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 08:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732966AbgLRH1c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 02:27:32 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:56669 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732686AbgLRH1c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 02:27:32 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UJ-.pew_1608276408;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UJ-.pew_1608276408)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 18 Dec 2020 15:26:48 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com
Subject: [PATCH] io_uring: fix io_wqe->work_list corruption
Date:   Fri, 18 Dec 2020 15:26:48 +0800
Message-Id: <20201218072648.9649-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For the first time a req punted to io-wq, we'll initialize io_wq_work's
list to be NULL, then insert req to io_wqe->work_list. If this req is not
inserted into tail of io_wqe->work_list, this req's io_wq_work list will
point to another req's io_wq_work. For splitted bio case, this req maybe
inserted to io_wqe->work_list repeatedly, once we insert it to tail of
io_wqe->work_list for the second time, now io_wq_work->list->next will be
invalid pointer, which then result in many strang error, panic, kernel
soft-lockup, rcu stall, etc.

In my vm, kernel doest not have commit cc29e1bf0d63f7 ("block: disable
iopoll for split bio"), below fio job can reproduce this bug steadily:
[global]
name=iouring-sqpoll-iopoll-1
ioengine=io_uring
iodepth=128
numjobs=1
thread
rw=randread
direct=1
registerfiles=1
hipri=1
bs=4m
size=100M
runtime=120
time_based
group_reporting
randrepeat=0

[device]
directory=/home/feiman.wxg/mntpoint/  # an ext4 mount point

If we have commit cc29e1bf0d63f7 ("block: disable iopoll for split bio"),
there will no splitted bio case for polled io, but I think we still to need
to fix this list corruption, it also should maybe go to stable branchs.

To fix this corruption, if a req is inserted into tail of io_wqe->work_list,
initialize req->io_wq_work->list->next to bu NULL.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io-wq.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 069496c6d4f9..75113bcd5889 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -59,6 +59,7 @@ static inline void wq_list_add_tail(struct io_wq_work_node *node,
 		list->last->next = node;
 		list->last = node;
 	}
+	node->next = NULL;
 }
 
 static inline void wq_list_cut(struct io_wq_work_list *list,
-- 
2.17.2

