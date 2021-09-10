Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30AA94067B3
	for <lists+io-uring@lfdr.de>; Fri, 10 Sep 2021 09:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhIJHeV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Sep 2021 03:34:21 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:19022 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbhIJHeR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Sep 2021 03:34:17 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H5SDG4b8tzbmKM;
        Fri, 10 Sep 2021 15:29:02 +0800 (CST)
Received: from dggpemm500004.china.huawei.com (7.185.36.219) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 10 Sep 2021 15:33:04 +0800
Received: from huawei.com (10.174.28.241) by dggpemm500004.china.huawei.com
 (7.185.36.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 10 Sep
 2021 15:33:04 +0800
From:   Bixuan Cui <cuibixuan@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <john.wanghui@huawei.com>
Subject: [PATCH -next v2] io-wq: Fix memory leak in create_io_worker
Date:   Fri, 10 Sep 2021 15:29:10 +0800
Message-ID: <20210910072910.43319-1-cuibixuan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.28.241]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500004.china.huawei.com (7.185.36.219)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Kmemleak tool detected a memory leak.

====================
unreferenced object 0xffff888126fcd6c0 (size 192):
  comm "syz-executor.1", pid 11934, jiffies 4294983026 (age 15.690s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81632c91>] kmalloc_node include/linux/slab.h:609 [inline]
    [<ffffffff81632c91>] kzalloc_node include/linux/slab.h:732 [inline]
    [<ffffffff81632c91>] create_io_worker+0x41/0x1e0 fs/io-wq.c:739
    [<ffffffff8163311e>] io_wqe_create_worker fs/io-wq.c:267 [inline]
    [<ffffffff8163311e>] io_wqe_enqueue+0x1fe/0x330 fs/io-wq.c:866
    [<ffffffff81620b64>] io_queue_async_work+0xc4/0x200 fs/io_uring.c:1473
    [<ffffffff8162c59c>] __io_queue_sqe+0x34c/0x510 fs/io_uring.c:6933
    [<ffffffff8162c7ab>] io_req_task_submit+0x4b/0xa0 fs/io_uring.c:2233
    [<ffffffff8162cb48>] io_async_task_func+0x108/0x1c0 fs/io_uring.c:5462
    [<ffffffff816259e3>] tctx_task_work+0x1b3/0x3a0 fs/io_uring.c:2158
    [<ffffffff81269b43>] task_work_run+0x73/0xb0 kernel/task_work.c:164
    [<ffffffff812dcdd1>] tracehook_notify_signal include/linux/tracehook.h:212 [inline]
    [<ffffffff812dcdd1>] handle_signal_work kernel/entry/common.c:146 [inline]
    [<ffffffff812dcdd1>] exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
    [<ffffffff812dcdd1>] exit_to_user_mode_prepare+0x151/0x180 kernel/entry/common.c:209
    [<ffffffff843ff25d>] __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
    [<ffffffff843ff25d>] syscall_exit_to_user_mode+0x1d/0x40 kernel/entry/common.c:302
    [<ffffffff843fa4a2>] do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
    [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae
====================

If io_should_retry_thread is false in create_io_worker() and
io_queue_worker_create is false in io_workqueue_create(), free the worker.

Fixes: 3146cba99aa2 ("io-wq: make worker creation resilient against signals")
Reported-by: syzbot+65454c239241d3d647da@syzkaller.appspotmail.com
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
---
Changes in v2:
* Add free worker if io_queue_worker_create is false in io_workqueue_create();
* Add kmemleak calltrace in commit message;

 fs/io-wq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index d80e4a735677..c24f79cf2b97 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -725,6 +725,7 @@ static void io_workqueue_create(struct work_struct *work)
 	if (!io_queue_worker_create(worker, acct, create_worker_cont)) {
 		clear_bit_unlock(0, &worker->create_state);
 		io_worker_release(worker);
+		kfree(worker);
 	}
 }
 
@@ -759,6 +760,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	if (!IS_ERR(tsk)) {
 		io_init_new_worker(wqe, worker, tsk);
 	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
+		kfree(worker);
 		goto fail;
 	} else {
 		INIT_WORK(&worker->work, io_workqueue_create);
-- 
2.17.1

