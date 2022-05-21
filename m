Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827B652FD2A
	for <lists+io-uring@lfdr.de>; Sat, 21 May 2022 16:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236216AbiEUOPI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 May 2022 10:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbiEUOPI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 May 2022 10:15:08 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F415DE58;
        Sat, 21 May 2022 07:15:06 -0700 (PDT)
Received: from kwepemi500022.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4L55DJ0tJMz1JBZ5;
        Sat, 21 May 2022 22:13:36 +0800 (CST)
Received: from kwepemm600004.china.huawei.com (7.193.23.242) by
 kwepemi500022.china.huawei.com (7.221.188.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 21 May 2022 22:15:01 +0800
Received: from huawei.com (10.175.124.27) by kwepemm600004.china.huawei.com
 (7.193.23.242) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 21 May
 2022 22:15:00 +0800
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <houtao1@huawei.com>, <yi.zhang@huawei.com>,
        <chengzhihao1@huawei.com>, <guoxuenan@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] io_uring: add a schedule condition in io_submit_sqes
Date:   Sat, 21 May 2022 22:33:27 +0800
Message-ID: <20220521143327.3959685-1-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600004.china.huawei.com (7.193.23.242)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

when set up sq ring size with IORING_MAX_ENTRIES, io_submit_sqes may
looping ~32768 times which may trigger soft lockups. add need_resched
condition to avoid this bad situation.

set sq ring size 32768 and using io_sq_thread to perform stress test
as follows:
watchdog: BUG: soft lockup - CPU#2 stuck for 26s! [iou-sqp-600:601]
Kernel panic - not syncing: softlockup: hung tasks
CPU: 2 PID: 601 Comm: iou-sqp-600 Tainted: G L 5.18.0-rc7+ #3
Hardware name: linux,dummy-virt (DT)
Call trace:
 dump_backtrace+0x218/0x228
 show_stack+0x20/0x68
 dump_stack_lvl+0x68/0x84
 dump_stack+0x1c/0x38
 panic+0x1ec/0x3ec
 watchdog_timer_fn+0x28c/0x300
 __hrtimer_run_queues+0x1d8/0x498
 hrtimer_interrupt+0x238/0x558
 arch_timer_handler_virt+0x48/0x60
 handle_percpu_devid_irq+0xdc/0x270
 generic_handle_domain_irq+0x50/0x70
 gic_handle_irq+0x8c/0x4bc
 call_on_irq_stack+0x2c/0x38
 do_interrupt_handler+0xc4/0xc8
 el1_interrupt+0x48/0xb0
 el1h_64_irq_handler+0x18/0x28
 el1h_64_irq+0x74/0x78
 console_unlock+0x5d0/0x908
 vprintk_emit+0x21c/0x470
 vprintk_default+0x40/0x50
 vprintk+0xd0/0x128
 _printk+0xb4/0xe8
 io_issue_sqe+0x1784/0x2908
 io_submit_sqes+0x538/0x2880
 io_sq_thread+0x328/0x7b0
 ret_from_fork+0x10/0x20
SMP: stopping secondary CPUs
Kernel Offset: 0x40f1e8600000 from 0xffff800008000000
PHYS_OFFSET: 0xfffffa8c80000000
CPU features: 0x110,0000cf09,00001006
Memory Limit: none
---[ end Kernel panic - not syncing: softlockup: hung tasks ]---

Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 92ac50f139cd..d897c6798f00 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7864,7 +7864,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 			if (!(ctx->flags & IORING_SETUP_SUBMIT_ALL))
 				break;
 		}
-	} while (submitted < nr);
+	} while (submitted < nr && !need_resched());
 
 	if (unlikely(submitted != nr)) {
 		int ref_used = (submitted == -EAGAIN) ? 0 : submitted;
-- 
2.25.1

