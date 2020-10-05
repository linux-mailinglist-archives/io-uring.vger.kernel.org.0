Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF0F2838F2
	for <lists+io-uring@lfdr.de>; Mon,  5 Oct 2020 17:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgJEPEu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Oct 2020 11:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgJEPEr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Oct 2020 11:04:47 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B97C0613CE
        for <io-uring@vger.kernel.org>; Mon,  5 Oct 2020 08:04:45 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t7so2871794ilf.10
        for <io-uring@vger.kernel.org>; Mon, 05 Oct 2020 08:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=45nHIG2A5suDPCfGmV4agcbVU36LBf7sDoqavCw/HAY=;
        b=If9TzdThiBAGrCQw2ywxFBKZ/Mt6a9i0dLSfYGaPbPrBnkbfQ+TsPpDutEIKeaaWqi
         xLrr3dKvpSjcB3uyL8zsbICxANw5ZlAhj1trDLFR2+ZmYrfW5cTQ0Bc/IBi87ospv1Rn
         ztSJPQUQwQ3Q3RP1miN4MFwzYUeA6/bHXfOtAW+BXapNTA3yqQ0HzJWI5o1llMSuhS8X
         itQFnAp3PjR4k+7F4K+Zdtlgke5R8BbpoKVR7AOUFlzmrtm08gpl3pFo1tVTz+WqYxXa
         CD1rIOA5iLp1F1qDvJqdVC2GzIXaB7c+YCsOtRjXQve5WxZONzd3NygVFStPznO4snB3
         O/3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=45nHIG2A5suDPCfGmV4agcbVU36LBf7sDoqavCw/HAY=;
        b=oY3vFXC+MpweLXUUXUW6SvzM3R74r3APPgzBOBbjz45MV2dhBBxA00LwhW3qziE5Ys
         Ogqf3zJqmGsy/TYjCY2+HKyFfCIuMXicVZVNt0h4FTWfxt9bw59wvMXUdHMTva4ayLNX
         SjZ2exzt3ihKIwCFn6N81t62USz0DtC5zbwqPVvOd++zvtZZUAyZZzV7f+Vuy55/lcCX
         5/wJVgrT1m+TnFLedGBWGlcfpWF4I/7PbENJpmKOcFLK6/igLd2X9wlwyXxjXvryHb8f
         n2qvKmBwKxu34L3cce9H3WQj84bUjSyfyZcrDOiFv/D3TIQiTFRA2wglkH6PYlEh4lvZ
         IX5w==
X-Gm-Message-State: AOAM5332UU48QWU/RdgkxRLxgonTY0Ll8O/wLYx8fYIi2D+6vqIj1B/a
        THa8aGqt/fnb/HPu8AK35snpBg==
X-Google-Smtp-Source: ABdhPJxH52hkeLF0Q9ETUBDe1fiYzoLiW1avWll1wBWkWwPf0BPAQQtoVhb1/eSEHSkmNCZ8opiXXA==
X-Received: by 2002:a92:58da:: with SMTP id z87mr12391808ilf.166.1601910284736;
        Mon, 05 Oct 2020 08:04:44 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 15sm33140ilz.66.2020.10.05.08.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 08:04:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] tracehook: clear TIF_NOTIFY_RESUME in tracehook_notify_resume()
Date:   Mon,  5 Oct 2020 09:04:33 -0600
Message-Id: <20201005150438.6628-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005150438.6628-1-axboe@kernel.dk>
References: <20201005150438.6628-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

All the callers currently do this, clean it up and move the clearing
into tracehook_notify_resume() instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 arch/alpha/kernel/signal.c      | 1 -
 arch/arc/kernel/signal.c        | 2 +-
 arch/arm/kernel/signal.c        | 1 -
 arch/arm64/kernel/signal.c      | 1 -
 arch/c6x/kernel/signal.c        | 4 +---
 arch/csky/kernel/signal.c       | 1 -
 arch/h8300/kernel/signal.c      | 4 +---
 arch/hexagon/kernel/process.c   | 1 -
 arch/ia64/kernel/process.c      | 2 +-
 arch/m68k/kernel/signal.c       | 2 +-
 arch/microblaze/kernel/signal.c | 2 +-
 arch/mips/kernel/signal.c       | 1 -
 arch/nds32/kernel/signal.c      | 4 +---
 arch/nios2/kernel/signal.c      | 2 +-
 arch/openrisc/kernel/signal.c   | 1 -
 arch/parisc/kernel/signal.c     | 4 +---
 arch/powerpc/kernel/signal.c    | 1 -
 arch/riscv/kernel/signal.c      | 4 +---
 arch/s390/kernel/signal.c       | 1 -
 arch/sh/kernel/signal_32.c      | 4 +---
 arch/sparc/kernel/signal_32.c   | 4 +---
 arch/sparc/kernel/signal_64.c   | 4 +---
 arch/um/kernel/process.c        | 2 +-
 arch/xtensa/kernel/signal.c     | 2 +-
 include/linux/tracehook.h       | 4 ++--
 kernel/entry/common.c           | 1 -
 kernel/entry/kvm.c              | 4 +---
 27 files changed, 18 insertions(+), 46 deletions(-)

diff --git a/arch/alpha/kernel/signal.c b/arch/alpha/kernel/signal.c
index 15bc9d1e79f4..3739efce1ec0 100644
--- a/arch/alpha/kernel/signal.c
+++ b/arch/alpha/kernel/signal.c
@@ -531,7 +531,6 @@ do_work_pending(struct pt_regs *regs, unsigned long thread_flags,
 				do_signal(regs, r0, r19);
 				r0 = 0;
 			} else {
-				clear_thread_flag(TIF_NOTIFY_RESUME);
 				tracehook_notify_resume(regs);
 			}
 		}
diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
index 8222f8c54690..2be55fb96d87 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -394,6 +394,6 @@ void do_notify_resume(struct pt_regs *regs)
 	 * ASM glue gaurantees that this is only called when returning to
 	 * user mode
 	 */
-	if (test_and_clear_thread_flag(TIF_NOTIFY_RESUME))
+	if (test_thread_flag(TIF_NOTIFY_RESUME))
 		tracehook_notify_resume(regs);
 }
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index c1892f733f20..585edbfccf6d 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -669,7 +669,6 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
 			} else if (thread_flags & _TIF_UPROBE) {
 				uprobe_notify_resume(regs);
 			} else {
-				clear_thread_flag(TIF_NOTIFY_RESUME);
 				tracehook_notify_resume(regs);
 				rseq_handle_notify_resume(NULL, regs);
 			}
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 3b4f31f35e45..4a6e1dc480c1 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -936,7 +936,6 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
 				do_signal(regs);
 
 			if (thread_flags & _TIF_NOTIFY_RESUME) {
-				clear_thread_flag(TIF_NOTIFY_RESUME);
 				tracehook_notify_resume(regs);
 				rseq_handle_notify_resume(NULL, regs);
 			}
diff --git a/arch/c6x/kernel/signal.c b/arch/c6x/kernel/signal.c
index d05c78eace1b..a3f15b9a79da 100644
--- a/arch/c6x/kernel/signal.c
+++ b/arch/c6x/kernel/signal.c
@@ -316,8 +316,6 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, u32 thread_info_flags,
 	if (thread_info_flags & (1 << TIF_SIGPENDING))
 		do_signal(regs, syscall);
 
-	if (thread_info_flags & (1 << TIF_NOTIFY_RESUME)) {
-		clear_thread_flag(TIF_NOTIFY_RESUME);
+	if (thread_info_flags & (1 << TIF_NOTIFY_RESUME))
 		tracehook_notify_resume(regs);
-	}
 }
diff --git a/arch/csky/kernel/signal.c b/arch/csky/kernel/signal.c
index 970895df75ec..8b068cf37447 100644
--- a/arch/csky/kernel/signal.c
+++ b/arch/csky/kernel/signal.c
@@ -261,7 +261,6 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
 		do_signal(regs);
 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
-		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
 		rseq_handle_notify_resume(NULL, regs);
 	}
diff --git a/arch/h8300/kernel/signal.c b/arch/h8300/kernel/signal.c
index 69e68949787f..75d9b7e626b2 100644
--- a/arch/h8300/kernel/signal.c
+++ b/arch/h8300/kernel/signal.c
@@ -282,8 +282,6 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, u32 thread_info_flags)
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
-	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
-		clear_thread_flag(TIF_NOTIFY_RESUME);
+	if (thread_info_flags & _TIF_NOTIFY_RESUME)
 		tracehook_notify_resume(regs);
-	}
 }
diff --git a/arch/hexagon/kernel/process.c b/arch/hexagon/kernel/process.c
index dfd322c5ce83..5a0a95d93ddb 100644
--- a/arch/hexagon/kernel/process.c
+++ b/arch/hexagon/kernel/process.c
@@ -180,7 +180,6 @@ int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
 	}
 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
-		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
 		return 1;
 	}
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index f19cb97c0098..8f96cdda2f09 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -189,7 +189,7 @@ do_notify_resume_user(sigset_t *unused, struct sigscratch *scr, long in_syscall)
 		ia64_do_signal(scr, in_syscall);
 	}
 
-	if (test_and_clear_thread_flag(TIF_NOTIFY_RESUME)) {
+	if (test_thread_flag(TIF_NOTIFY_RESUME)) {
 		local_irq_enable();	/* force interrupt enable */
 		tracehook_notify_resume(&scr->pt);
 	}
diff --git a/arch/m68k/kernel/signal.c b/arch/m68k/kernel/signal.c
index a98fca977073..29e174a80bf6 100644
--- a/arch/m68k/kernel/signal.c
+++ b/arch/m68k/kernel/signal.c
@@ -1134,6 +1134,6 @@ void do_notify_resume(struct pt_regs *regs)
 	if (test_thread_flag(TIF_SIGPENDING))
 		do_signal(regs);
 
-	if (test_and_clear_thread_flag(TIF_NOTIFY_RESUME))
+	if (test_thread_flag(TIF_NOTIFY_RESUME))
 		tracehook_notify_resume(regs);
 }
diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signal.c
index 4a96b59f0bee..f11a0ccccabc 100644
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -316,6 +316,6 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, int in_syscall)
 	if (test_thread_flag(TIF_SIGPENDING))
 		do_signal(regs, in_syscall);
 
-	if (test_and_clear_thread_flag(TIF_NOTIFY_RESUME))
+	if (test_thread_flag(TIF_NOTIFY_RESUME))
 		tracehook_notify_resume(regs);
 }
diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index a0262729cd4c..77d40126b8a9 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -901,7 +901,6 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, void *unused,
 		do_signal(regs);
 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
-		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
 		rseq_handle_notify_resume(NULL, regs);
 	}
diff --git a/arch/nds32/kernel/signal.c b/arch/nds32/kernel/signal.c
index 36e25a410bb0..2acb94812af9 100644
--- a/arch/nds32/kernel/signal.c
+++ b/arch/nds32/kernel/signal.c
@@ -379,8 +379,6 @@ do_notify_resume(struct pt_regs *regs, unsigned int thread_flags)
 	if (thread_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
-	if (thread_flags & _TIF_NOTIFY_RESUME) {
-		clear_thread_flag(TIF_NOTIFY_RESUME);
+	if (thread_flags & _TIF_NOTIFY_RESUME)
 		tracehook_notify_resume(regs);
-	}
 }
diff --git a/arch/nios2/kernel/signal.c b/arch/nios2/kernel/signal.c
index d8a087cf2b42..cf2dca2ac7c3 100644
--- a/arch/nios2/kernel/signal.c
+++ b/arch/nios2/kernel/signal.c
@@ -317,7 +317,7 @@ asmlinkage int do_notify_resume(struct pt_regs *regs)
 			 */
 			return restart;
 		}
-	} else if (test_and_clear_thread_flag(TIF_NOTIFY_RESUME))
+	} else if (test_thread_flag(TIF_NOTIFY_RESUME))
 		tracehook_notify_resume(regs);
 
 	return 0;
diff --git a/arch/openrisc/kernel/signal.c b/arch/openrisc/kernel/signal.c
index c779364f0cd0..af66f968dd45 100644
--- a/arch/openrisc/kernel/signal.c
+++ b/arch/openrisc/kernel/signal.c
@@ -311,7 +311,6 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
 				}
 				syscall = 0;
 			} else {
-				clear_thread_flag(TIF_NOTIFY_RESUME);
 				tracehook_notify_resume(regs);
 			}
 		}
diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 3c037fc96038..9f43eaeb0b0a 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -606,8 +606,6 @@ void do_notify_resume(struct pt_regs *regs, long in_syscall)
 	if (test_thread_flag(TIF_SIGPENDING))
 		do_signal(regs, in_syscall);
 
-	if (test_thread_flag(TIF_NOTIFY_RESUME)) {
-		clear_thread_flag(TIF_NOTIFY_RESUME);
+	if (test_thread_flag(TIF_NOTIFY_RESUME))
 		tracehook_notify_resume(regs);
-	}
 }
diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index d15a98c758b8..74a94a125f0d 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -327,7 +327,6 @@ void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
 	}
 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
-		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
 		rseq_handle_notify_resume(NULL, regs);
 	}
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index e996e08f1061..bc6841867b51 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -313,8 +313,6 @@ asmlinkage __visible void do_notify_resume(struct pt_regs *regs,
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
-	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
-		clear_thread_flag(TIF_NOTIFY_RESUME);
+	if (thread_info_flags & _TIF_NOTIFY_RESUME)
 		tracehook_notify_resume(regs);
-	}
 }
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index b295090e2ce6..9e900a8977bd 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -535,7 +535,6 @@ void do_signal(struct pt_regs *regs)
 
 void do_notify_resume(struct pt_regs *regs)
 {
-	clear_thread_flag(TIF_NOTIFY_RESUME);
 	tracehook_notify_resume(regs);
 	rseq_handle_notify_resume(NULL, regs);
 }
diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 4fe3f00137bc..1add47fd31f6 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -502,8 +502,6 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, unsigned int save_r0,
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs, save_r0);
 
-	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
-		clear_thread_flag(TIF_NOTIFY_RESUME);
+	if (thread_info_flags & _TIF_NOTIFY_RESUME)
 		tracehook_notify_resume(regs);
-	}
 }
diff --git a/arch/sparc/kernel/signal_32.c b/arch/sparc/kernel/signal_32.c
index d0e0025ee3ba..741d0701003a 100644
--- a/arch/sparc/kernel/signal_32.c
+++ b/arch/sparc/kernel/signal_32.c
@@ -523,10 +523,8 @@ void do_notify_resume(struct pt_regs *regs, unsigned long orig_i0,
 {
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs, orig_i0);
-	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
-		clear_thread_flag(TIF_NOTIFY_RESUME);
+	if (thread_info_flags & _TIF_NOTIFY_RESUME)
 		tracehook_notify_resume(regs);
-	}
 }
 
 asmlinkage int do_sys_sigstack(struct sigstack __user *ssptr,
diff --git a/arch/sparc/kernel/signal_64.c b/arch/sparc/kernel/signal_64.c
index 255264bcb46a..f7ef7edcd5c1 100644
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -551,10 +551,8 @@ void do_notify_resume(struct pt_regs *regs, unsigned long orig_i0, unsigned long
 		uprobe_notify_resume(regs);
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs, orig_i0);
-	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
-		clear_thread_flag(TIF_NOTIFY_RESUME);
+	if (thread_info_flags & _TIF_NOTIFY_RESUME)
 		tracehook_notify_resume(regs);
-	}
 	user_enter();
 }
 
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 26b5e243d3fc..3bed09538dd9 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -101,7 +101,7 @@ void interrupt_end(void)
 		schedule();
 	if (test_thread_flag(TIF_SIGPENDING))
 		do_signal(regs);
-	if (test_and_clear_thread_flag(TIF_NOTIFY_RESUME))
+	if (test_thread_flag(TIF_NOTIFY_RESUME))
 		tracehook_notify_resume(regs);
 }
 
diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
index b3b17d6c50f0..1fb1047f905c 100644
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -501,6 +501,6 @@ void do_notify_resume(struct pt_regs *regs)
 	if (test_thread_flag(TIF_SIGPENDING))
 		do_signal(regs);
 
-	if (test_and_clear_thread_flag(TIF_NOTIFY_RESUME))
+	if (test_thread_flag(TIF_NOTIFY_RESUME))
 		tracehook_notify_resume(regs);
 }
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 36fb3bbed6b2..b480e1a07ed8 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -178,9 +178,9 @@ static inline void set_notify_resume(struct task_struct *task)
  */
 static inline void tracehook_notify_resume(struct pt_regs *regs)
 {
+	clear_thread_flag(TIF_NOTIFY_RESUME);
 	/*
-	 * The caller just cleared TIF_NOTIFY_RESUME. This barrier
-	 * pairs with task_work_add()->set_notify_resume() after
+	 * This barrier pairs with task_work_add()->set_notify_resume() after
 	 * hlist_add_head(task->task_works);
 	 */
 	smp_mb__after_atomic();
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index 6fdb6105e6d6..d20ab4ac7183 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -161,7 +161,6 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 			arch_do_signal(regs);
 
 		if (ti_work & _TIF_NOTIFY_RESUME) {
-			clear_thread_flag(TIF_NOTIFY_RESUME);
 			tracehook_notify_resume(regs);
 			rseq_handle_notify_resume(NULL, regs);
 		}
diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
index eb1a8a4c867c..b6678a5e3cf6 100644
--- a/kernel/entry/kvm.c
+++ b/kernel/entry/kvm.c
@@ -16,10 +16,8 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
 		if (ti_work & _TIF_NEED_RESCHED)
 			schedule();
 
-		if (ti_work & _TIF_NOTIFY_RESUME) {
-			clear_thread_flag(TIF_NOTIFY_RESUME);
+		if (ti_work & _TIF_NOTIFY_RESUME)
 			tracehook_notify_resume(NULL);
-		}
 
 		ret = arch_xfer_to_guest_mode_handle_work(vcpu, ti_work);
 		if (ret)
-- 
2.28.0

