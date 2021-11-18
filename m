Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E537455258
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 02:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242357AbhKRBtp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 20:49:45 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:26323 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239516AbhKRBto (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Nov 2021 20:49:44 -0500
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HvjFm1xCQzbj0j;
        Thu, 18 Nov 2021 09:41:48 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Thu, 18 Nov
 2021 09:46:43 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH -next] io_uring: Fix undefined-behaviour in io_issue_sqe
Date:   Thu, 18 Nov 2021 09:59:07 +0800
Message-ID: <20211118015907.844807-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We got issue as follows:
================================================================================
UBSAN: Undefined behaviour in ./include/linux/ktime.h:42:14
signed integer overflow:
-4966321760114568020 * 1000000000 cannot be represented in type 'long long int'
CPU: 1 PID: 2186 Comm: syz-executor.2 Not tainted 4.19.90+ #12
Hardware name: linux,dummy-virt (DT)
Call trace:
 dump_backtrace+0x0/0x3f0 arch/arm64/kernel/time.c:78
 show_stack+0x28/0x38 arch/arm64/kernel/traps.c:158
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x170/0x1dc lib/dump_stack.c:118
 ubsan_epilogue+0x18/0xb4 lib/ubsan.c:161
 handle_overflow+0x188/0x1dc lib/ubsan.c:192
 __ubsan_handle_mul_overflow+0x34/0x44 lib/ubsan.c:213
 ktime_set include/linux/ktime.h:42 [inline]
 timespec64_to_ktime include/linux/ktime.h:78 [inline]
 io_timeout fs/io_uring.c:5153 [inline]
 io_issue_sqe+0x42c8/0x4550 fs/io_uring.c:5599
 __io_queue_sqe+0x1b0/0xbc0 fs/io_uring.c:5988
 io_queue_sqe+0x1ac/0x248 fs/io_uring.c:6067
 io_submit_sqe fs/io_uring.c:6137 [inline]
 io_submit_sqes+0xed8/0x1c88 fs/io_uring.c:6331
 __do_sys_io_uring_enter fs/io_uring.c:8170 [inline]
 __se_sys_io_uring_enter fs/io_uring.c:8129 [inline]
 __arm64_sys_io_uring_enter+0x490/0x980 fs/io_uring.c:8129
 invoke_syscall arch/arm64/kernel/syscall.c:53 [inline]
 el0_svc_common+0x374/0x570 arch/arm64/kernel/syscall.c:121
 el0_svc_handler+0x190/0x260 arch/arm64/kernel/syscall.c:190
 el0_svc+0x10/0x218 arch/arm64/kernel/entry.S:1017
================================================================================

As ktime_set only judge 'secs' if big than KTIME_SEC_MAX, but if we pass
negative value maybe lead to overflow.
To address this issue, we must check if 'sec' is negative.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f9e720595860..d8a6446a7921 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6157,6 +6157,9 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
 		return -EFAULT;
 
+	if (data->ts.tv_sec < 0 || data->ts.tv_nsec < 0)
+		return -EINVAL;
+
 	data->mode = io_translate_timeout_mode(flags);
 	hrtimer_init(&data->timer, io_timeout_get_clock(data), data->mode);
 
-- 
2.31.1

