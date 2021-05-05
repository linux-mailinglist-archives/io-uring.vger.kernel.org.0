Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F283738F4
	for <lists+io-uring@lfdr.de>; Wed,  5 May 2021 13:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbhEELEv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 07:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbhEELEu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 07:04:50 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9A6C061574;
        Wed,  5 May 2021 04:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=LFmASb7+Qh69wknfhzFhMRba205E6B5Mf0FBOcwFrRY=; b=FAWOI7mIDBoVOuvaRay7/8hBTW
        MhQGaVO2rAQxj5zagzmRGY2is20Kt2D0fDmWq+dNr6qad9W13I74+9Mgd+XEkwXoVJZNLd0mLGaiI
        7UxGpGMux6eZrDTSlK9Bbx4I9k04KfU+uH4NEY1FUYOxAIotjzFMBTiPcJnNIkNLATLF9f7/E+63b
        gKuu1tpmKbDxJiwW1ozgWfO4w+p0fbRroMuiLLhg0sNGBM3wujx8Rx7iJT8zHbm7yszcXtwr8GW4M
        7Pu4VagkcXYb1HWMl8yKiitQcc+QC3un5LwHHT4fehOT13lMaKB73U1/QLNPgrnHa4xLg5CNk32K1
        8TVBylVz2y6kwzSSyhSvNuVWd5Kz8kKB8Ri6pMZ+/7YBwrA7uhDUgF8qbeN4TpxhIpaFdjL75Ogm0
        NL1imK+7P2ZLfGrtir5h1XjhuAOlf087jQLdAWK94PURx7tJoAhofmihZ7I+lOCgOwMv/uH3NJNZO
        6HvrNkb+U9nmFKqygzMJ+WaV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1leFJn-0000nS-4i; Wed, 05 May 2021 11:03:51 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH v2] io_thread/x86: setup io_threads more like normal user space threads
Date:   Wed,  5 May 2021 13:03:10 +0200
Message-Id: <20210505110310.237537-1-metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210411152705.2448053-1-metze@samba.org>
References: <20210411152705.2448053-1-metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As io_threads are fully set up USER threads it's clearer to
separate the code path from the KTHREAD logic.

The only remaining difference to user space threads is that
io_threads never return to user space again.
Instead they loop within the given worker function.

The fact that they never return to user space means they
don't have an user space thread stack. In order to
indicate that to tools like gdb we reset the stack and instruction
pointers to 0.

This allows gdb attach to user space processes using io-uring,
which like means that they have io_threads, without printing worrying
message like this:

  warning: Selected architecture i386:x86-64 is not compatible with reported target architecture i386

  warning: Architecture rejected target-supplied description

The output will be something like this:

  (gdb) info threads
    Id   Target Id                  Frame
  * 1    LWP 4863 "io_uring-cp-for" syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
    2    LWP 4864 "iou-mgr-4863"    0x0000000000000000 in ?? ()
    3    LWP 4865 "iou-wrk-4863"    0x0000000000000000 in ?? ()
  (gdb) thread 3
  [Switching to thread 3 (LWP 4865)]
  #0  0x0000000000000000 in ?? ()
  (gdb) bt
  #0  0x0000000000000000 in ?? ()
  Backtrace stopped: Cannot access memory at address 0x0

Fixes: 4727dc20e04 ("arch: setup PF_IO_WORKER threads like PF_KTHREAD")
Link: https://lore.kernel.org/io-uring/044d0bad-6888-a211-e1d3-159a4aeed52d@polymtl.ca/T/#m1bbf5727e3d4e839603f6ec7ed79c7eebfba6267
Signed-off-by: Stefan Metzmacher <metze@samba.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: Thomas Gleixner <tglx@linutronix.de>
cc: Andy Lutomirski <luto@kernel.org>
cc: linux-kernel@vger.kernel.org
cc: io-uring@vger.kernel.org
cc: x86@kernel.org
---
 arch/x86/kernel/process.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 9c214d7085a4..6a64ee204897 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -161,7 +161,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
 #endif
 
 	/* Kernel thread ? */
-	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
+	if (unlikely(p->flags & PF_KTHREAD)) {
 		memset(childregs, 0, sizeof(struct pt_regs));
 		kthread_frame_init(frame, sp, arg);
 		return 0;
@@ -177,6 +177,23 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
 	task_user_gs(p) = get_user_gs(current_pt_regs());
 #endif
 
+	if (unlikely(p->flags & PF_IO_WORKER)) {
+		/*
+		 * An IO thread is a user space thread, but it doesn't
+		 * return to ret_after_fork().
+		 *
+		 * In order to indicate that to tools like gdb,
+		 * we reset the stack and instruction pointers.
+		 *
+		 * It does the same kernel frame setup to return to a kernel
+		 * function that a kernel thread does.
+		 */
+		childregs->sp = 0;
+		childregs->ip = 0;
+		kthread_frame_init(frame, sp, arg);
+		return 0;
+	}
+
 	/* Set a new TLS for the child thread? */
 	if (clone_flags & CLONE_SETTLS)
 		ret = set_new_tls(p, tls);
-- 
2.25.1

