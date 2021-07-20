Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F033CF633
	for <lists+io-uring@lfdr.de>; Tue, 20 Jul 2021 10:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhGTHzb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jul 2021 03:55:31 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:12279 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbhGTHzB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jul 2021 03:55:01 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GTX3d0Qf8z7wDb;
        Tue, 20 Jul 2021 16:30:53 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 16:35:28 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 20 Jul
 2021 16:35:27 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>
Subject: [PATCH] io_uring: fix memleak in io_init_wq_offload()
Date:   Tue, 20 Jul 2021 16:38:05 +0800
Message-ID: <20210720083805.3030730-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I got memory leak report when doing fuzz test:

BUG: memory leak
unreferenced object 0xffff888107310a80 (size 96):
comm "syz-executor.6", pid 4610, jiffies 4295140240 (age 20.135s)
hex dump (first 32 bytes):
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00 .....N..........
backtrace:
[<000000001974933b>] kmalloc include/linux/slab.h:591 [inline]
[<000000001974933b>] kzalloc include/linux/slab.h:721 [inline]
[<000000001974933b>] io_init_wq_offload fs/io_uring.c:7920 [inline]
[<000000001974933b>] io_uring_alloc_task_context+0x466/0x640 fs/io_uring.c:7955
[<0000000039d0800d>] __io_uring_add_tctx_node+0x256/0x360 fs/io_uring.c:9016
[<000000008482e78c>] io_uring_add_tctx_node fs/io_uring.c:9052 [inline]
[<000000008482e78c>] __do_sys_io_uring_enter fs/io_uring.c:9354 [inline]
[<000000008482e78c>] __se_sys_io_uring_enter fs/io_uring.c:9301 [inline]
[<000000008482e78c>] __x64_sys_io_uring_enter+0xabc/0xc20 fs/io_uring.c:9301
[<00000000b875f18f>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
[<00000000b875f18f>] do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
[<000000006b0a8484>] entry_SYSCALL_64_after_hwframe+0x44/0xae

CPU0                          CPU1
io_uring_enter                io_uring_enter
io_uring_add_tctx_node        io_uring_add_tctx_node
__io_uring_add_tctx_node      __io_uring_add_tctx_node
io_uring_alloc_task_context   io_uring_alloc_task_context
io_init_wq_offload            io_init_wq_offload
hash = kzalloc                hash = kzalloc
ctx->hash_map = hash          ctx->hash_map = hash <- one of the hash is leaked

When calling io_uring_enter() in parallel, the 'hash_map' will be leaked, 
add uring_lock to protect 'hash_map'.

Fixes: e941894eae31 ("io-wq: make buffered file write hashed work map per-ctx")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 fs/io_uring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0cac361bf6b8..63d3a9c2a2a6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7899,15 +7899,19 @@ static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 	struct io_wq_data data;
 	unsigned int concurrency;
 
+	mutex_lock(&ctx->uring_lock);
 	hash = ctx->hash_map;
 	if (!hash) {
 		hash = kzalloc(sizeof(*hash), GFP_KERNEL);
-		if (!hash)
+		if (!hash) {
+			mutex_unlock(&ctx->uring_lock);
 			return ERR_PTR(-ENOMEM);
+		}
 		refcount_set(&hash->refs, 1);
 		init_waitqueue_head(&hash->wait);
 		ctx->hash_map = hash;
 	}
+	mutex_unlock(&ctx->uring_lock);
 
 	data.hash = hash;
 	data.task = task;
-- 
2.25.1

