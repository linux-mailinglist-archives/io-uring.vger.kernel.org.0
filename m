Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094F621960E
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 04:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgGICMp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 22:12:45 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60244 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726118AbgGICMo (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 8 Jul 2020 22:12:44 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 772BA91C3703B6672BBD;
        Thu,  9 Jul 2020 10:12:43 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Thu, 9 Jul 2020
 10:12:41 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix memleak in __io_sqe_files_update()
Date:   Thu, 9 Jul 2020 10:11:41 +0000
Message-ID: <20200709101141.3261977-1-yangyingliang@huawei.com>
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
unreferenced object 0xffff888113e02300 (size 488):
comm "syz-executor401", pid 356, jiffies 4294809529 (age 11.954s)
hex dump (first 32 bytes):
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
a0 a4 ce 19 81 88 ff ff 60 ce 09 0d 81 88 ff ff ........`.......
backtrace:
[<00000000129a84ec>] kmem_cache_zalloc include/linux/slab.h:659 [inline]
[<00000000129a84ec>] __alloc_file+0x25/0x310 fs/file_table.c:101
[<000000003050ad84>] alloc_empty_file+0x4f/0x120 fs/file_table.c:151
[<000000004d0a41a3>] alloc_file+0x5e/0x550 fs/file_table.c:193
[<000000002cb242f0>] alloc_file_pseudo+0x16a/0x240 fs/file_table.c:233
[<00000000046a4baa>] anon_inode_getfile fs/anon_inodes.c:91 [inline]
[<00000000046a4baa>] anon_inode_getfile+0xac/0x1c0 fs/anon_inodes.c:74
[<0000000035beb745>] __do_sys_perf_event_open+0xd4a/0x2680 kernel/events/core.c:11720
[<0000000049009dc7>] do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:359
[<00000000353731ca>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881152dd5e0 (size 16):
comm "syz-executor401", pid 356, jiffies 4294809529 (age 11.954s)
hex dump (first 16 bytes):
01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 ................
backtrace:
[<0000000074caa794>] kmem_cache_zalloc include/linux/slab.h:659 [inline]
[<0000000074caa794>] lsm_file_alloc security/security.c:567 [inline]
[<0000000074caa794>] security_file_alloc+0x32/0x160 security/security.c:1440
[<00000000c6745ea3>] __alloc_file+0xba/0x310 fs/file_table.c:106
[<000000003050ad84>] alloc_empty_file+0x4f/0x120 fs/file_table.c:151
[<000000004d0a41a3>] alloc_file+0x5e/0x550 fs/file_table.c:193
[<000000002cb242f0>] alloc_file_pseudo+0x16a/0x240 fs/file_table.c:233
[<00000000046a4baa>] anon_inode_getfile fs/anon_inodes.c:91 [inline]
[<00000000046a4baa>] anon_inode_getfile+0xac/0x1c0 fs/anon_inodes.c:74
[<0000000035beb745>] __do_sys_perf_event_open+0xd4a/0x2680 kernel/events/core.c:11720
[<0000000049009dc7>] do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:359
[<00000000353731ca>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

If io_sqe_file_register() failed, we need put the file that get by fget()
to avoid the memleak.

Fixes: c3a31e605620 ("io_uring: add support for IORING_REGISTER_FILES_UPDATE")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e507737f044e..5c2487d954b2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6814,8 +6814,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			}
 			table->files[index] = file;
 			err = io_sqe_file_register(ctx, file, i);
-			if (err)
+			if (err) {
+				fput(file);
 				break;
+			}
 		}
 		nr_args--;
 		done++;
-- 
2.17.1

