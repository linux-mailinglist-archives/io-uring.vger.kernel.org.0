Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CB61F723C
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 04:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgFLCaY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Jun 2020 22:30:24 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:58790 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726326AbgFLCaY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Jun 2020 22:30:24 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U.K0ya1_1591929020;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U.K0ya1_1591929020)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 12 Jun 2020 10:30:21 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH v3 2/2] io_uring: use EPOLLEXCLUSIVE flag to aoid thundering herd type behavior
Date:   Fri, 12 Jun 2020 10:30:18 +0800
Message-Id: <1591929018-73954-3-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591929018-73954-1-git-send-email-jiufei.xue@linux.alibaba.com>
References: <1591929018-73954-1-git-send-email-jiufei.xue@linux.alibaba.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Applications can pass this flag in to avoid accept thundering herd.

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 fs/io_uring.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6250227..03951ec 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4289,7 +4289,11 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 
 	pt->error = 0;
 	poll->head = head;
-	add_wait_queue(head, &poll->wait);
+
+	if (poll->events & EPOLLEXCLUSIVE)
+		add_wait_queue_exclusive(head, &poll->wait);
+	else
+		add_wait_queue(head, &poll->wait);
 }
 
 static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
@@ -4612,7 +4616,8 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return -EBADF;
 
 	events = READ_ONCE(sqe->poll_events);
-	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
+	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP |
+		       (events & EPOLLEXCLUSIVE);
 
 	get_task_struct(current);
 	req->task = current;
-- 
1.8.3.1

