Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858F52FCC87
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 09:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbhATIPN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jan 2021 03:15:13 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:52578 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730407AbhATIMy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jan 2021 03:12:54 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UMJCvX-_1611130310;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UMJCvX-_1611130310)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 20 Jan 2021 16:11:50 +0800
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: leave clean req to be done in flush overflow
Date:   Wed, 20 Jan 2021 16:11:50 +0800
Message-Id: <1611130310-108105-1-git-send-email-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Abaci reported the following BUG:

[   27.629441] BUG: sleeping function called from invalid context at fs/file.c:402
[   27.631317] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 1012, name: io_wqe_worker-0
[   27.633220] 1 lock held by io_wqe_worker-0/1012:
[   27.634286]  #0: ffff888105e26c98 (&ctx->completion_lock){....}-{2:2}, at: __io_req_complete.part.102+0x30/0x70
[   27.636487] irq event stamp: 66658
[   27.637302] hardirqs last  enabled at (66657): [<ffffffff8144ba02>] kmem_cache_free+0x1f2/0x3b0
[   27.639211] hardirqs last disabled at (66658): [<ffffffff82003a77>] _raw_spin_lock_irqsave+0x17/0x50
[   27.641196] softirqs last  enabled at (64686): [<ffffffff824003c5>] __do_softirq+0x3c5/0x5aa
[   27.643062] softirqs last disabled at (64681): [<ffffffff8220108f>] asm_call_irq_on_stack+0xf/0x20
[   27.645029] CPU: 1 PID: 1012 Comm: io_wqe_worker-0 Not tainted 5.11.0-rc4+ #68
[   27.646651] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[   27.649249] Call Trace:
[   27.649874]  dump_stack+0xac/0xe3
[   27.650666]  ___might_sleep+0x284/0x2c0
[   27.651566]  put_files_struct+0xb8/0x120
[   27.652481]  __io_clean_op+0x10c/0x2a0
[   27.653362]  __io_cqring_fill_event+0x2c1/0x350
[   27.654399]  __io_req_complete.part.102+0x41/0x70
[   27.655464]  io_openat2+0x151/0x300
[   27.656297]  io_issue_sqe+0x6c/0x14e0
[   27.657170]  ? lock_acquire+0x31a/0x440
[   27.658068]  ? io_worker_handle_work+0x24e/0x8a0
[   27.659119]  ? find_held_lock+0x28/0xb0
[   27.660026]  ? io_wq_submit_work+0x7f/0x240
[   27.660991]  io_wq_submit_work+0x7f/0x240
[   27.661915]  ? trace_hardirqs_on+0x46/0x110
[   27.662890]  io_worker_handle_work+0x501/0x8a0
[   27.663917]  ? io_wqe_worker+0x135/0x520
[   27.664836]  io_wqe_worker+0x158/0x520
[   27.665719]  ? __kthread_parkme+0x96/0xc0
[   27.666663]  ? io_worker_handle_work+0x8a0/0x8a0
[   27.667726]  kthread+0x134/0x180
[   27.668506]  ? kthread_create_worker_on_cpu+0x90/0x90
[   27.669641]  ret_from_fork+0x1f/0x30

It blames we call cond_resched() with completion_lock when clean
request. In fact we will do it during flush overflow and it seems we
have no reason to do it before. So just remove io_clean_op() in
__io_cqring_fill_event() to fix this BUG.

Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 985a9e3..9b937d1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1860,7 +1860,6 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 			set_bit(0, &ctx->cq_check_overflow);
 			ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
 		}
-		io_clean_op(req);
 		req->result = res;
 		req->compl.cflags = cflags;
 		refcount_inc(&req->refs);
-- 
1.8.3.1

