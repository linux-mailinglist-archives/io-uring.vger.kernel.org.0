Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C2835B5E3
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 17:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbhDKP1i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Apr 2021 11:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235202AbhDKP1i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Apr 2021 11:27:38 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CDEC061574;
        Sun, 11 Apr 2021 08:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=ebf1CAV3KUSk9FUTqmssCnCWaxfYoafLGeA6On/g0AU=; b=utMbbmy4YvVqOiYZZqk1VAdfkt
        lX/1faVsdbv3JeLGeRcS10t+UjdoDtMRKt3zSGCrCidB7WZU9U80Rb+5reFKa0/orOU6oNpEISqUn
        YPIWGp8xvUUJhcYoEbv5AwSU8AvbPw9f7BH6ArP1hJGjNybzoaD/5aHeCTsdHzOVSEwTjaiIi9lal
        cKC5F+GL9kp8oHxyDmzXdxIHN+LFlNQ8DZLCgOqXSoPuIATfzWtM+irm9YuTLMrGCKVs93HCA8GNV
        jppNAxVcUdOhn1kqchrB91ZhkZ/FZUWWNgP0Xbg2tlX7SXtWvdzt21gSG9dM2kfS5aKryMqMkwGoq
        dp/HdnHWKsSP4oqqAm3hNpXuEbu+dRwaMdXJschxRAyC+iuM6EQPXUVyMOh3a55WTuMsJmt5s8zpZ
        eePFsi5t5JNlwCyjc2ExDYiGCRucleTL1lRzb9MV5fJtTKmnteR358EILvIdMuQJLNI+jvRQnKqyz
        TFRymHJZ0SQRU9dYUimD1xIt;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lVbza-0005ZF-4X; Sun, 11 Apr 2021 15:27:18 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es' registers for io_threads
Date:   Sun, 11 Apr 2021 17:27:05 +0200
Message-Id: <20210411152705.2448053-1-metze@samba.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This allows gdb attach to userspace processes using io-uring,
which means that they have io_threads (PF_IO_WORKER), which appear
just like normal as userspace threads.

See the code comment for more details.

Fixes: 4727dc20e04 ("arch: setup PF_IO_WORKER threads like PF_KTHREAD")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: linux-kernel@vger.kernel.org
cc: io-uring@vger.kernel.org
---
 arch/x86/kernel/process.c | 49 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 9c214d7085a4..72120c4b7618 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -163,6 +163,55 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
 	/* Kernel thread ? */
 	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		memset(childregs, 0, sizeof(struct pt_regs));
+		/*
+		 * gdb sees all userspace threads,
+		 * including io threads (PF_IO_WORKER)!
+		 *
+		 * gdb uses:
+		 * PTRACE_PEEKUSR, offsetof (struct user_regs_struct, cs)
+		 *  returning with 0x33 (51) to detect 64 bit
+		 * and:
+		 * PTRACE_PEEKUSR, offsetof (struct user_regs_struct, ds)
+		 *  returning 0x2b (43) to detect 32 bit.
+		 *
+		 * GDB relies on that the kernel returns the
+		 * same values for all threads, which means
+		 * we don't zero these out.
+		 *
+		 * Note that CONFIG_X86_64 handles 'es' and 'ds'
+		 * differently, see the following above:
+		 *   savesegment(es, p->thread.es);
+		 *   savesegment(ds, p->thread.ds);
+		 * and the CONFIG_X86_64 version of get_segment_reg().
+		 *
+		 * Linus proposed something like this:
+		 * (https://lore.kernel.org/io-uring/CAHk-=whEObPkZBe4766DmR46-=5QTUiatWbSOaD468eTgYc1tg@mail.gmail.com/)
+		 *
+		 *   childregs->cs = __USER_CS;
+		 *   childregs->ss = __USER_DS;
+		 *   childregs->ds = __USER_DS;
+		 *   childregs->es = __USER_DS;
+		 *
+		 * might make sense (just do it unconditionally, rather than making it
+		 * special to PF_IO_WORKER).
+		 *
+		 * But that doesn't make gdb happy in all cases.
+		 *
+		 * While 32bit userspace on a 64bit kernel is legacy,
+		 * it's still useful to allow 32bit libraries or nss modules
+		 * use the same code as the 64bit version of that library, which
+		 * can use io-uring just fine.
+		 *
+		 * So we better just inherit the values from
+		 * the originating process instead of hardcoding
+		 * values, which would imply 64bit userspace.
+		 */
+		childregs->cs = current_pt_regs()->cs;
+		childregs->ss = current_pt_regs()->ss;
+#ifdef CONFIG_X86_32
+		childregs->ds = current_pt_regs()->ds;
+		childregs->es = current_pt_regs()->es;
+#endif
 		kthread_frame_init(frame, sp, arg);
 		return 0;
 	}
-- 
2.25.1

