Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3A62838FB
	for <lists+io-uring@lfdr.de>; Mon,  5 Oct 2020 17:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgJEPFG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Oct 2020 11:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgJEPEr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Oct 2020 11:04:47 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C72C0613A7
        for <io-uring@vger.kernel.org>; Mon,  5 Oct 2020 08:04:47 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id k25so9469824ioh.7
        for <io-uring@vger.kernel.org>; Mon, 05 Oct 2020 08:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nckRBTGeDDjcz+ETZlQhgF2+vU8phSO5Wlot907KKh8=;
        b=NI0qHIG+x+V105yV6CIY8r8q2789zfyV4oFmCNEh9maLUBvgR9B3ZKhXJ41Q70Zt5e
         Zjv/7gVzToXI9DKvjXunWz33dtTwPPzeGhJVk03x5aQjQwuTNCMxCAfVJnenWUHtYYWI
         7UfbwmZFCdvhv+X7Wlm7lmv4DD/K5m+OufvFqlhezwuKosX4myrihrIDqcskwuIMOOB1
         0oIbQZNXRR5EtiULeLUkVQ2GfxXthOQDjMU4YuarwiE8l5JzUxjG9yVm4dYR0KohCcAj
         9OQ3L8fOfErn1UnnWBkSjEFa/o+1oxHN+77xdMHn/MdVzcsZSvJD2logAcm6oxii/wk2
         /Iyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nckRBTGeDDjcz+ETZlQhgF2+vU8phSO5Wlot907KKh8=;
        b=VCinXfkOJ2hMJwF5+dcRS5LRhrm70AjeMt3VvMYvnn8T2vyyAEkhdvM4j6QjjfV7xp
         sabstRtsGQ8NCqepB4Oc2CTDXdnnalSbW9QlJ32QrRuATkLVSgyHRHgjXzpP6eaXNnxL
         xloqWjdTtggYthYHDpBTlJbMV58k+8x3sljOqAi2ZY+23QbiKr/oVJG3aC4gOlb0A1L1
         UoOZAoPuUQCXT2f6LKc7t5YYqOUwIrOTbvtzLIc2/mSUmrdpkMoQS0s48sY7NIRPE2aA
         ALV/uneDaOpDEj9rAvvikO8Se2wkbSEemC56H1PYiH1J2bCJb14j/2PWPNRTmWKaK9Fx
         h7Wg==
X-Gm-Message-State: AOAM531w9yVVdGrxUeHJfLUba+iiuUNzcJHk6fWoCzdk1TT36v6+rKDu
        vVLe9xVRxmn4kJ9h29SwXTg9cw==
X-Google-Smtp-Source: ABdhPJwJkJ1C1akV4PeShn9PnVfu2A8L8gSmo4iJvYHZcyTzMT7bsKDXHcAOFE1szHMNz7ChGvuRqw==
X-Received: by 2002:a5e:d606:: with SMTP id w6mr200118iom.67.1601910286760;
        Mon, 05 Oct 2020 08:04:46 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 15sm33140ilz.66.2020.10.05.08.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 08:04:46 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] kernel: split syscall restart from signal handling
Date:   Mon,  5 Oct 2020 09:04:35 -0600
Message-Id: <20201005150438.6628-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005150438.6628-1-axboe@kernel.dk>
References: <20201005150438.6628-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move the restart syscall logic into a separate generic entry helper,
and handle that part separately from signal checking and delivery.

This is in preparation for being able to do syscall restarting
independently from handling signals.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 arch/x86/kernel/signal.c     | 32 ++++++++++++++++++--------------
 include/linux/entry-common.h | 14 ++++++++++++--
 kernel/entry/common.c        | 11 ++++++++---
 3 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index be0d7d4152ec..5dc1eeaf0866 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -799,21 +799,8 @@ static inline unsigned long get_nr_restart_syscall(const struct pt_regs *regs)
 #endif
 }
 
-/*
- * Note that 'init' is a special process: it doesn't get signals it doesn't
- * want to handle. Thus you cannot kill init even with a SIGKILL even by
- * mistake.
- */
-void arch_do_signal(struct pt_regs *regs)
+void arch_restart_syscall(struct pt_regs *regs)
 {
-	struct ksignal ksig;
-
-	if (get_signal(&ksig)) {
-		/* Whee! Actually deliver the signal.  */
-		handle_signal(&ksig, regs);
-		return;
-	}
-
 	/* Did we come from a system call? */
 	if (syscall_get_nr(current, regs) >= 0) {
 		/* Restart the system call - no handlers present */
@@ -831,12 +818,29 @@ void arch_do_signal(struct pt_regs *regs)
 			break;
 		}
 	}
+}
+
+/*
+ * Note that 'init' is a special process: it doesn't get signals it doesn't
+ * want to handle. Thus you cannot kill init even with a SIGKILL even by
+ * mistake.
+ */
+bool arch_do_signal(struct pt_regs *regs)
+{
+	struct ksignal ksig;
+
+	if (get_signal(&ksig)) {
+		/* Whee! Actually deliver the signal.  */
+		handle_signal(&ksig, regs);
+		return true;
+	}
 
 	/*
 	 * If there's no signal to deliver, we just put the saved sigmask
 	 * back.
 	 */
 	restore_saved_sigmask();
+	return false;
 }
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
index 159c7476b11b..ccfcc4769925 100644
--- a/include/linux/entry-common.h
+++ b/include/linux/entry-common.h
@@ -262,9 +262,19 @@ static __always_inline void arch_exit_to_user_mode(void) { }
  * arch_do_signal -  Architecture specific signal delivery function
  * @regs:	Pointer to currents pt_regs
  *
- * Invoked from exit_to_user_mode_loop().
+ * Invoked from exit_to_user_mode_loop(). Returns true if a signal was
+ * handled.
  */
-void arch_do_signal(struct pt_regs *regs);
+bool arch_do_signal(struct pt_regs *regs);
+
+/**
+ * arch_restart_syscall -  Architecture specific syscall restarting
+ * @regs:	Pointer to currents pt_regs
+ *
+ * Invoked from exit_to_user_mode_loop(), if we need to restart the current
+ * system call.
+ */
+void arch_restart_syscall(struct pt_regs *regs);
 
 /**
  * arch_syscall_exit_tracehook - Wrapper around tracehook_report_syscall_exit()
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index d20ab4ac7183..0c0cc3cf3eba 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -135,11 +135,13 @@ static __always_inline void exit_to_user_mode(void)
 }
 
 /* Workaround to allow gradual conversion of architecture code */
-void __weak arch_do_signal(struct pt_regs *regs) { }
+bool __weak arch_do_signal(struct pt_regs *regs) { return true; }
 
 static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 					    unsigned long ti_work)
 {
+	bool restart_sys = ti_work & _TIF_SIGPENDING;
+
 	/*
 	 * Before returning to user space ensure that all pending work
 	 * items have been completed.
@@ -157,8 +159,8 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 		if (ti_work & _TIF_PATCH_PENDING)
 			klp_update_patch_state(current);
 
-		if (ti_work & _TIF_SIGPENDING)
-			arch_do_signal(regs);
+		if ((ti_work & _TIF_SIGPENDING) && arch_do_signal(regs))
+			restart_sys = false;
 
 		if (ti_work & _TIF_NOTIFY_RESUME) {
 			tracehook_notify_resume(regs);
@@ -177,6 +179,9 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 		ti_work = READ_ONCE(current_thread_info()->flags);
 	}
 
+	if (restart_sys)
+		arch_restart_syscall(regs);
+
 	/* Return the latest work state for arch_exit_to_user_mode() */
 	return ti_work;
 }
-- 
2.28.0

