Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4665B31F5E2
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 09:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhBSI2h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 03:28:37 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:44315 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229639AbhBSI2b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 03:28:31 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UOxXHe9_1613723257;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UOxXHe9_1613723257)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 19 Feb 2021 16:27:44 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Subject: [PATCH v3 5.12] io_uring: don't hold uring_lock when calling io_run_task_work*
Date:   Fri, 19 Feb 2021 16:27:34 +0800
Message-Id: <1613723254-114070-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Abaci reported the below issue:
[  141.400455] hrtimer: interrupt took 205853 ns
[  189.869316] process 'usr/local/ilogtail/ilogtail_0.16.26' started with executable stack
[  250.188042]
[  250.188327] ============================================
[  250.189015] WARNING: possible recursive locking detected
[  250.189732] 5.11.0-rc4 #1 Not tainted
[  250.190267] --------------------------------------------
[  250.190917] a.out/7363 is trying to acquire lock:
[  250.191506] ffff888114dbcbe8 (&ctx->uring_lock){+.+.}-{3:3}, at: __io_req_task_submit+0x29/0xa0
[  250.192599]
[  250.192599] but task is already holding lock:
[  250.193309] ffff888114dbfbe8 (&ctx->uring_lock){+.+.}-{3:3}, at: __x64_sys_io_uring_register+0xad/0x210
[  250.194426]
[  250.194426] other info that might help us debug this:
[  250.195238]  Possible unsafe locking scenario:
[  250.195238]
[  250.196019]        CPU0
[  250.196411]        ----
[  250.196803]   lock(&ctx->uring_lock);
[  250.197420]   lock(&ctx->uring_lock);
[  250.197966]
[  250.197966]  *** DEADLOCK ***
[  250.197966]
[  250.198837]  May be due to missing lock nesting notation
[  250.198837]
[  250.199780] 1 lock held by a.out/7363:
[  250.200373]  #0: ffff888114dbfbe8 (&ctx->uring_lock){+.+.}-{3:3}, at: __x64_sys_io_uring_register+0xad/0x210
[  250.201645]
[  250.201645] stack backtrace:
[  250.202298] CPU: 0 PID: 7363 Comm: a.out Not tainted 5.11.0-rc4 #1
[  250.203144] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  250.203887] Call Trace:
[  250.204302]  dump_stack+0xac/0xe3
[  250.204804]  __lock_acquire+0xab6/0x13a0
[  250.205392]  lock_acquire+0x2c3/0x390
[  250.205928]  ? __io_req_task_submit+0x29/0xa0
[  250.206541]  __mutex_lock+0xae/0x9f0
[  250.207071]  ? __io_req_task_submit+0x29/0xa0
[  250.207745]  ? 0xffffffffa0006083
[  250.208248]  ? __io_req_task_submit+0x29/0xa0
[  250.208845]  ? __io_req_task_submit+0x29/0xa0
[  250.209452]  ? __io_req_task_submit+0x5/0xa0
[  250.210083]  __io_req_task_submit+0x29/0xa0
[  250.210687]  io_async_task_func+0x23d/0x4c0
[  250.211278]  task_work_run+0x89/0xd0
[  250.211884]  io_run_task_work_sig+0x50/0xc0
[  250.212464]  io_sqe_files_unregister+0xb2/0x1f0
[  250.213109]  __io_uring_register+0x115a/0x1750
[  250.213718]  ? __x64_sys_io_uring_register+0xad/0x210
[  250.214395]  ? __fget_files+0x15a/0x260
[  250.214956]  __x64_sys_io_uring_register+0xbe/0x210
[  250.215620]  ? trace_hardirqs_on+0x46/0x110
[  250.216205]  do_syscall_64+0x2d/0x40
[  250.216731]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  250.217455] RIP: 0033:0x7f0fa17e5239
[  250.218034] Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05  3d 01 f0 ff ff 73 01 c3 48 8b 0d 27 ec 2c 00 f7 d8 64 89 01 48
[  250.220343] RSP: 002b:00007f0fa1eeac48 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
[  250.221360] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0fa17e5239
[  250.222272] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000008
[  250.223185] RBP: 00007f0fa1eeae20 R08: 0000000000000000 R09: 0000000000000000
[  250.224091] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  250.224999] R13: 0000000000021000 R14: 0000000000000000 R15: 00007f0fa1eeb700

This is caused by calling io_run_task_work_sig() to do work under
uring_lock while the caller io_sqe_files_unregister() already held
uring_lock.
To fix this issue, briefly drop uring_lock when calling
io_run_task_work_sig(), and there are two things to concern:

- hold uring_lock in io_ring_ctx_free() around io_sqe_files_unregister()
    this is for consistency of lock/unlock.
- add new fixed rsrc ref node before dropping uring_lock
    it's not safe to do io_uring_enter-->percpu_ref_get() with a dying one.
- check if rsrc_data->refs is dying to avoid parallel io_sqe_files_unregister

Reported-by: Abaci <abaci@linux.alibaba.com>
Fixes: 1ffc54220c44 ("io_uring: fix io_sqe_files_unregister() hangs")
Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

v1->v2
  - take in Pavel's suggestion and idea and form a new version
v2->v3
 - rebase against the latest for-5.12/io_uring branch

 fs/io_uring.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 53 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1cb5e40d9822..cf6d5257e491 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7316,12 +7316,23 @@ static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
 	percpu_ref_get(&rsrc_data->refs);
 }
 
-static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
-			       struct io_ring_ctx *ctx,
-			       struct fixed_rsrc_ref_node *backup_node)
+static int io_sqe_rsrc_add_node(struct io_ring_ctx *ctx)
 {
-	struct fixed_rsrc_ref_node *ref_node;
-	int ret;
+	struct rsrc_data *data = ctx->rsrc_data;
+	struct fixed_rsrc_ref_node *backup_node;
+
+	backup_node = alloc_fixed_rsrc_ref_node(ctx);
+	if (!backup_node)
+		return -ENOMEM;
+
+	io_sqe_rsrc_set_node(data, backup_node);
+
+	return 0;
+}
+
+static void io_sqe_rsrc_kill_node(struct fixed_rsrc_data *data)
+{
+	struct fixed_rsrc_ref_node *ref_node = NULL;
 
 	io_rsrc_ref_lock(ctx);
 	ref_node = data->node;
@@ -7329,6 +7340,15 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
 
+}
+
+static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
+			       struct io_ring_ctx *ctx,
+			       struct fixed_rsrc_ref_node *backup_node)
+{
+	int ret;
+
+	io_sqe_rsrc_kill_node(data);
 	percpu_ref_kill(&data->refs);
 
 	/* wait for all refs nodes to complete */
@@ -7337,14 +7357,27 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 		ret = wait_for_completion_interruptible(&data->done);
 		if (!ret)
 			break;
+
+		ret = io_sqe_rsrc_add_node(ctx);
+		if (ret < 0)
+			break;
+		/*
+		 * There is small possibility that data->done is already completed
+		 * So reinit it here
+		 */
+		reinit_completion(&data->done);
+		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig();
-		if (ret < 0) {
-			percpu_ref_resurrect(&data->refs);
-			reinit_completion(&data->done);
-			io_sqe_rsrc_set_node(ctx, data, backup_node);
-			return ret;
-		}
-	} while (1);
+		mutex_lock(&ctx->uring_lock);
+		io_sqe_rsrc_kill_node(data);
+	} while (ret >= 0);
+
+	if (ret < 0) {
+		percpu_ref_resurrect(&data->refs);
+		reinit_completion(&data->done);
+		io_sqe_rsrc_set_node(ctx, data, backup_node);
+		return ret;
+	}
 
 	destroy_fixed_rsrc_ref_node(backup_node);
 	return 0;
@@ -7382,7 +7415,12 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	unsigned nr_tables, i;
 	int ret;
 
-	if (!data)
+	/*
+	 * percpu_ref_is_dying() is to stop parallel files unregister
+	 * Since we possibly drop uring lock later in this function to
+	 * run task work.
+	 */
+	if (!data || percpu_ref_is_dying(&data->refs))
 		return -ENXIO;
 	backup_node = alloc_fixed_rsrc_ref_node(ctx);
 	if (!backup_node)
@@ -8731,7 +8769,9 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		css_put(ctx->sqo_blkcg_css);
 #endif
 
+	mutex_lock(&ctx->uring_lock);
 	io_sqe_files_unregister(ctx);
+	mutex_unlock(&ctx->uring_lock);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
 	idr_destroy(&ctx->personality_idr);
-- 
1.8.3.1

