Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F342C1E9C
	for <lists+io-uring@lfdr.de>; Tue, 24 Nov 2020 08:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbgKXHDJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Nov 2020 02:03:09 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:57226 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725786AbgKXHDJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Nov 2020 02:03:09 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UGOgQVw_1606201383;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UGOgQVw_1606201383)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 24 Nov 2020 15:03:03 +0800
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Subject: [PATCH] io_uring: fix shift-out-of-bounds when round up cq size
Date:   Tue, 24 Nov 2020 15:03:03 +0800
Message-Id: <1606201383-62294-1-git-send-email-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Abaci Fuzz reported a shift-out-of-bounds BUG in io_uring_create():

[ 59.598207] UBSAN: shift-out-of-bounds in ./include/linux/log2.h:57:13
[ 59.599665] shift exponent 64 is too large for 64-bit type 'long unsigned int'
[ 59.601230] CPU: 0 PID: 963 Comm: a.out Not tainted 5.10.0-rc4+ #3
[ 59.602502] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[ 59.603673] Call Trace:
[ 59.604286] dump_stack+0x107/0x163
[ 59.605237] ubsan_epilogue+0xb/0x5a
[ 59.606094] __ubsan_handle_shift_out_of_bounds.cold+0xb2/0x20e
[ 59.607335] ? lock_downgrade+0x6c0/0x6c0
[ 59.608182] ? rcu_read_lock_sched_held+0xaf/0xe0
[ 59.609166] io_uring_create.cold+0x99/0x149
[ 59.610114] io_uring_setup+0xd6/0x140
[ 59.610975] ? io_uring_create+0x2510/0x2510
[ 59.611945] ? lockdep_hardirqs_on_prepare+0x286/0x400
[ 59.613007] ? syscall_enter_from_user_mode+0x27/0x80
[ 59.614038] ? trace_hardirqs_on+0x5b/0x180
[ 59.615056] do_syscall_64+0x2d/0x40
[ 59.615940] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 59.617007] RIP: 0033:0x7f2bb8a0b239

This is caused by roundup_pow_of_two() if the input entries larger
enough, e.g. 2^32-1. For sq_entries, it will check first and we allow
at most IORING_MAX_ENTRIES, so it is okay. But for cq_entries, we do
round up first, that may overflow and truncate it to 0, which is not
the expected behavior. So check the cq size first and then do round up.

Fixes: 88ec3211e463 ("io_uring: round-up cq size before comparing with rounded sq size")
Reported-by: Abaci Fuzz <abaci@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a8c136a..f971589 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9252,14 +9252,16 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		 * to a power-of-two, if it isn't already. We do NOT impose
 		 * any cq vs sq ring sizing.
 		 */
-		p->cq_entries = roundup_pow_of_two(p->cq_entries);
-		if (p->cq_entries < p->sq_entries)
+		if (!p->cq_entries)
 			return -EINVAL;
 		if (p->cq_entries > IORING_MAX_CQ_ENTRIES) {
 			if (!(p->flags & IORING_SETUP_CLAMP))
 				return -EINVAL;
 			p->cq_entries = IORING_MAX_CQ_ENTRIES;
 		}
+		p->cq_entries = roundup_pow_of_two(p->cq_entries);
+		if (p->cq_entries < p->sq_entries)
+			return -EINVAL;
 	} else {
 		p->cq_entries = 2 * p->sq_entries;
 	}
-- 
1.8.3.1

