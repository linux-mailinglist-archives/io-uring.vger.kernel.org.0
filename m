Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D6A1F4DF4
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2020 08:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgFJGPM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Jun 2020 02:15:12 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:46549 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbgFJGPM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Jun 2020 02:15:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07484;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U.9MKit_1591769708;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U.9MKit_1591769708)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Jun 2020 14:15:09 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH] io_uring: add EPOLLEXCLUSIVE flag to aoid thundering herd type behavior
Date:   Wed, 10 Jun 2020 14:15:08 +0800
Message-Id: <1591769708-55768-1-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Applications can use this flag to avoid accept thundering herd.

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 fs/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f668982..b8102b2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4109,7 +4109,10 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 
 	pt->error = 0;
 	poll->head = head;
-	add_wait_queue(head, &poll->wait);
+	if (poll->events & EPOLLEXCLUSIVE)
+		add_wait_queue_exclusive(head, &poll->wait);
+	else
+		add_wait_queue(head, &poll->wait);
 }
 
 static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
@@ -4530,7 +4533,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return -EBADF;
 
 	events = READ_ONCE(sqe->poll_events);
-	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
+	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP | EPOLLEXCLUSIVE;
 
 	get_task_struct(current);
 	req->task = current;
-- 
1.8.3.1

