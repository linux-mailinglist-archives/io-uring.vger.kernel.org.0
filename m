Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9788F2050D0
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 13:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732347AbgFWLer (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Jun 2020 07:34:47 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:45099 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732443AbgFWLeL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Jun 2020 07:34:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U0VyxOO_1592912046;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0U0VyxOO_1592912046)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Jun 2020 19:34:07 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     io-uring <io-uring@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     Dust.li@linux.alibaba.com
Subject: [PATCH v2] io_uring: fix io_sq_thread no schedule when busy
Date:   Tue, 23 Jun 2020 19:34:06 +0800
Message-Id: <bb5be3f3976e1c56f4bcc309ea417a20ea384853.1592912043.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <a932f437e5337cbfb42db660473fa55fa7aff9f6.1592804776.git.xuanzhuo@linux.alibaba.com>
References: <a932f437e5337cbfb42db660473fa55fa7aff9f6.1592804776.git.xuanzhuo@linux.alibaba.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When the user consumes and generates sqe at a fast rate,
io_sqring_entries can always get sqe, and ret will not be equal to -EBUSY,
so that io_sq_thread will never call cond_resched or schedule, and then
we will get the following system error prompt:

rcu: INFO: rcu_sched self-detected stall on CPU
or
watchdog: BUG: soft lockup-CPU#23 stuck for 112s! [io_uring-sq:1863]

This patch checks whether need to call cond_resched() by checking
the need_resched() function every cycle.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a78201b..9de9db7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6011,7 +6011,7 @@ static int io_sq_thread(void *data)
 		 * If submit got -EBUSY, flag us as needing the application
 		 * to enter the kernel to reap and flush events.
 		 */
-		if (!to_submit || ret == -EBUSY) {
+		if (!to_submit || ret == -EBUSY || need_resched()) {
 			/*
 			 * Drop cur_mm before scheduling, we can't hold it for
 			 * long periods (or over schedule()). Do this before
@@ -6027,7 +6027,7 @@ static int io_sq_thread(void *data)
 			 * more IO, we should wait for the application to
 			 * reap events and wake us up.
 			 */
-			if (!list_empty(&ctx->poll_list) ||
+			if (!list_empty(&ctx->poll_list) || need_resched() ||
 			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
 			    !percpu_ref_is_dying(&ctx->refs))) {
 				if (current->task_works)
-- 
1.8.3.1

