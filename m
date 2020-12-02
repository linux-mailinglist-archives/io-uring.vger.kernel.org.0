Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7B42CBB95
	for <lists+io-uring@lfdr.de>; Wed,  2 Dec 2020 12:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgLBLco (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Dec 2020 06:32:44 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:43570 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLBLco (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Dec 2020 06:32:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UHJfHVH_1606908711;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UHJfHVH_1606908711)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Dec 2020 19:31:52 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH] io_uring: always let io_iopoll_complete() complete polled io.
Date:   Wed,  2 Dec 2020 19:31:51 +0800
Message-Id: <20201202113151.1680-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Abaci Fuzz reported a double-free or invalid-free BUG in io_commit_cqring():
[   95.504842] BUG: KASAN: double-free or invalid-free in io_commit_cqring+0x3ec/0x8e0
[   95.505921]
[   95.506225] CPU: 0 PID: 4037 Comm: io_wqe_worker-0 Tainted: G    B
W         5.10.0-rc5+ #1
[   95.507434] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[   95.508248] Call Trace:
[   95.508683]  dump_stack+0x107/0x163
[   95.509323]  ? io_commit_cqring+0x3ec/0x8e0
[   95.509982]  print_address_description.constprop.0+0x3e/0x60
[   95.510814]  ? vprintk_func+0x98/0x140
[   95.511399]  ? io_commit_cqring+0x3ec/0x8e0
[   95.512036]  ? io_commit_cqring+0x3ec/0x8e0
[   95.512733]  kasan_report_invalid_free+0x51/0x80
[   95.513431]  ? io_commit_cqring+0x3ec/0x8e0
[   95.514047]  __kasan_slab_free+0x141/0x160
[   95.514699]  kfree+0xd1/0x390
[   95.515182]  io_commit_cqring+0x3ec/0x8e0
[   95.515799]  __io_req_complete.part.0+0x64/0x90
[   95.516483]  io_wq_submit_work+0x1fa/0x260
[   95.517117]  io_worker_handle_work+0xeac/0x1c00
[   95.517828]  io_wqe_worker+0xc94/0x11a0
[   95.518438]  ? io_worker_handle_work+0x1c00/0x1c00
[   95.519151]  ? __kthread_parkme+0x11d/0x1d0
[   95.519806]  ? io_worker_handle_work+0x1c00/0x1c00
[   95.520512]  ? io_worker_handle_work+0x1c00/0x1c00
[   95.521211]  kthread+0x396/0x470
[   95.521727]  ? _raw_spin_unlock_irq+0x24/0x30
[   95.522380]  ? kthread_mod_delayed_work+0x180/0x180
[   95.523108]  ret_from_fork+0x22/0x30
[   95.523684]
[   95.523985] Allocated by task 4035:
[   95.524543]  kasan_save_stack+0x1b/0x40
[   95.525136]  __kasan_kmalloc.constprop.0+0xc2/0xd0
[   95.525882]  kmem_cache_alloc_trace+0x17b/0x310
[   95.533930]  io_queue_sqe+0x225/0xcb0
[   95.534505]  io_submit_sqes+0x1768/0x25f0
[   95.535164]  __x64_sys_io_uring_enter+0x89e/0xd10
[   95.535900]  do_syscall_64+0x33/0x40
[   95.536465]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   95.537199]
[   95.537505] Freed by task 4035:
[   95.538003]  kasan_save_stack+0x1b/0x40
[   95.538599]  kasan_set_track+0x1c/0x30
[   95.539177]  kasan_set_free_info+0x1b/0x30
[   95.539798]  __kasan_slab_free+0x112/0x160
[   95.540427]  kfree+0xd1/0x390
[   95.540910]  io_commit_cqring+0x3ec/0x8e0
[   95.541516]  io_iopoll_complete+0x914/0x1390
[   95.542150]  io_do_iopoll+0x580/0x700
[   95.542724]  io_iopoll_try_reap_events.part.0+0x108/0x200
[   95.543512]  io_ring_ctx_wait_and_kill+0x118/0x340
[   95.544206]  io_uring_release+0x43/0x50
[   95.544791]  __fput+0x28d/0x940
[   95.545291]  task_work_run+0xea/0x1b0
[   95.545873]  do_exit+0xb6a/0x2c60
[   95.546400]  do_group_exit+0x12a/0x320
[   95.546967]  __x64_sys_exit_group+0x3f/0x50
[   95.547605]  do_syscall_64+0x33/0x40
[   95.548155]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

The reason is that once we got a non EAGAIN error in io_wq_submit_work(),
we'll complete req by calling io_req_complete(), which will hold completion_lock
to call io_commit_cqring(), but for polled io, io_iopoll_complete() won't
hold completion_lock to call io_commit_cqring(), then there maybe concurrent
access to ctx->defer_list, double free may happen.

To fix this bug, we always let io_iopoll_complete() complete polled io.

Reported-by: Abaci Fuzz <abaci@linux.alibaba.com>
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a8c136a..901ca67 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6074,8 +6074,19 @@ static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
 	}
 
 	if (ret) {
-		req_set_fail_links(req);
-		io_req_complete(req, ret);
+		/*
+		 * io_iopoll_complete() does not hold completion_lock to complete
+		 * polled io, so here for polled io, just mark it done and still let
+		 * io_iopoll_complete() complete it.
+		 */
+		if (req->ctx->flags & IORING_SETUP_IOPOLL) {
+			struct kiocb *kiocb = &req->rw.kiocb;
+
+			kiocb_done(kiocb, ret, NULL);
+		} else {
+			req_set_fail_links(req);
+			io_req_complete(req, ret);
+		}
 	}
 
 	return io_steal_work(req);
-- 
1.8.3.1

