Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CAB21AF36
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 08:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgGJGPP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 02:15:15 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7830 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725851AbgGJGPP (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 10 Jul 2020 02:15:15 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F20893357126DAC07796;
        Fri, 10 Jul 2020 14:15:09 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Fri, 10 Jul 2020
 14:15:04 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix memleak in io_sqe_files_register()
Date:   Fri, 10 Jul 2020 14:14:20 +0000
Message-ID: <20200710141420.3987063-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I got a memleak report when doing some fuzz test:

BUG: memory leak
unreferenced object 0x607eeac06e78 (size 8):
  comm "test", pid 295, jiffies 4294735835 (age 31.745s)
  hex dump (first 8 bytes):
    00 00 00 00 00 00 00 00                          ........
  backtrace:
    [<00000000932632e6>] percpu_ref_init+0x2a/0x1b0
    [<0000000092ddb796>] __io_uring_register+0x111d/0x22a0
    [<00000000eadd6c77>] __x64_sys_io_uring_register+0x17b/0x480
    [<00000000591b89a6>] do_syscall_64+0x56/0xa0
    [<00000000864a281d>] entry_SYSCALL_64_after_hwframe+0x44/0xa9


Call percpu_ref_exit() on error path to avoid
refcount memleak.

Fixes: 05f3fb3c5397 ("io_uring: avoid ring quiesce for fixed file set unregister and update")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d37d7ea5ebe5..ea81be3c14af 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6693,6 +6693,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		for (i = 0; i < nr_tables; i++)
 			kfree(ctx->file_data->table[i].files);
 
+		percpu_ref_exit(&ctx->file_data->refs);
 		kfree(ctx->file_data->table);
 		kfree(ctx->file_data);
 		ctx->file_data = NULL;
-- 
2.25.1

