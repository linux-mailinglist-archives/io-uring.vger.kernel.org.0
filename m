Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D5D74F938
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 22:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjGKUoJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 16:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjGKUoH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 16:44:07 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBBE1717
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:44:04 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-6831a5caf75so127113b3a.0
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689108244; x=1689713044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C9zc53z+/V9/ECV3tKzh/T4s2rLLXca0QnmcU/Zn8AM=;
        b=4stpGtuZn7oMLOlDScS37tR4LbmPlFNAC023tmFK1/0CFyIBw0w4A5dau++EKDbUcT
         ujMsJ7PJofZSUz6kakzpmFt4T3MOOWrdKDgumuKIa0qo29UaJCdMBPCqUKMjBbnuPbMy
         1kUratjfGG5pFsUfdUNIUKYG0s/yyYkSr1sIOWjZ0usCzVaBaf4/jXnyrtb0n7dxfUU2
         LdnpD/cMhpPlEsp23nUsqMDSNEkkHz5GFPnKGCvwaZFOT31WMZaXOykDMf5keT6EtMF6
         FYA59OuZmBp8EN/8e6xd0w747SZ4CksKsINtcvUbHcnrAG7m2vKKPcWbhPBOVhFbxq09
         e3zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689108244; x=1689713044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C9zc53z+/V9/ECV3tKzh/T4s2rLLXca0QnmcU/Zn8AM=;
        b=Z/NNZMRuShDZTdofOWum9+xC6LhOWT9SuyxxVWrJ2J2FQqFF0m3GdYEx9VlqQ+XSBR
         tQTo276O8KO59LL4RdVWTi1J4pzUE1TwEFgCJ+5kV0FE0p3eYYMipxqCdiXQ3Npa/L6d
         dUNzPvAUvvHp6Qt43gQ0U761zJdo/lMVYyohX52S7p7zgUJn5h0dBUnpxLCki9YBO8YZ
         eEc58lswHZ2ymFveS/OvnhAFtQohs45nWFxRjpTWbTfJ5cqLQA7fFYvD8ZIdvqAoq6Xl
         Ckzbw6fC6coSSLpb8axGfiTyJjCBuxf02x4iAUE/Fi05fyd8qDbdX9aWMpTuMRs/HgG0
         hVew==
X-Gm-Message-State: ABy/qLbPTnAaVYsQPgaQos/Qu8xPfz46neJb/mt7+nTf/yZ4i5RrcGg+
        05rPyPZETZErCMUf/e4Pwd7cqAwZx9Flwl8SkEw=
X-Google-Smtp-Source: APBJJlG5T4xTBJELUr9n8GVlsKOccKtebMyEWZXZh35g0q8hofWjgCQqVZ49aKNw+R/H+/Vi+AwiLA==
X-Received: by 2002:aa7:91c9:0:b0:668:834d:4bd with SMTP id z9-20020aa791c9000000b00668834d04bdmr17735349pfa.0.1689108243811;
        Tue, 11 Jul 2023 13:44:03 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f7-20020aa78b07000000b00640ddad2e0dsm2124461pfd.47.2023.07.11.13.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 13:44:03 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] exit: add internal include file with helpers
Date:   Tue, 11 Jul 2023 14:43:51 -0600
Message-Id: <20230711204352.214086-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230711204352.214086-1-axboe@kernel.dk>
References: <20230711204352.214086-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move struct wait_opts and waitid_info into kernel/exit.h, and include
function declarations for the recently added helpers. Make them
non-static as well.

This is in preparation for adding a waitid operation through io_uring.
With the abtracted helpers, this is now possible.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/exit.c | 32 +++++++-------------------------
 kernel/exit.h | 30 ++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 25 deletions(-)
 create mode 100644 kernel/exit.h

diff --git a/kernel/exit.c b/kernel/exit.c
index 8934c91a9fe1..1c9d1cbadcd0 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -74,6 +74,8 @@
 #include <asm/unistd.h>
 #include <asm/mmu_context.h>
 
+#include "exit.h"
+
 /*
  * The default value should be high enough to not crash a system that randomly
  * crashes its kernel from time to time, but low enough to at least not permit
@@ -1037,26 +1039,6 @@ SYSCALL_DEFINE1(exit_group, int, error_code)
 	return 0;
 }
 
-struct waitid_info {
-	pid_t pid;
-	uid_t uid;
-	int status;
-	int cause;
-};
-
-struct wait_opts {
-	enum pid_type		wo_type;
-	int			wo_flags;
-	struct pid		*wo_pid;
-
-	struct waitid_info	*wo_info;
-	int			wo_stat;
-	struct rusage		*wo_rusage;
-
-	wait_queue_entry_t		child_wait;
-	int			notask_error;
-};
-
 static int eligible_pid(struct wait_opts *wo, struct task_struct *p)
 {
 	return	wo->wo_type == PIDTYPE_MAX ||
@@ -1520,7 +1502,7 @@ static int ptrace_do_wait(struct wait_opts *wo, struct task_struct *tsk)
 	return 0;
 }
 
-static bool pid_child_should_wake(struct wait_opts *wo, struct task_struct *p)
+bool pid_child_should_wake(struct wait_opts *wo, struct task_struct *p)
 {
 	if (!eligible_pid(wo, p))
 		return false;
@@ -1590,7 +1572,7 @@ static int do_wait_pid(struct wait_opts *wo)
 	return 0;
 }
 
-static long __do_wait(struct wait_opts *wo)
+long __do_wait(struct wait_opts *wo)
 {
 	long retval;
 
@@ -1662,9 +1644,9 @@ static long do_wait(struct wait_opts *wo)
 	return retval;
 }
 
-static int kernel_waitid_prepare(struct wait_opts *wo, int which, pid_t upid,
-				 struct waitid_info *infop, int options,
-				 struct rusage *ru, unsigned int *f_flags)
+int kernel_waitid_prepare(struct wait_opts *wo, int which, pid_t upid,
+			  struct waitid_info *infop, int options,
+			  struct rusage *ru, unsigned int *f_flags)
 {
 	struct pid *pid = NULL;
 	enum pid_type type;
diff --git a/kernel/exit.h b/kernel/exit.h
new file mode 100644
index 000000000000..f10207ba1341
--- /dev/null
+++ b/kernel/exit.h
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#ifndef LINUX_WAITID_H
+#define LINUX_WAITID_H
+
+struct waitid_info {
+	pid_t pid;
+	uid_t uid;
+	int status;
+	int cause;
+};
+
+struct wait_opts {
+	enum pid_type		wo_type;
+	int			wo_flags;
+	struct pid		*wo_pid;
+
+	struct waitid_info	*wo_info;
+	int			wo_stat;
+	struct rusage		*wo_rusage;
+
+	wait_queue_entry_t		child_wait;
+	int			notask_error;
+};
+
+bool pid_child_should_wake(struct wait_opts *wo, struct task_struct *p);
+long __do_wait(struct wait_opts *wo);
+int kernel_waitid_prepare(struct wait_opts *wo, int which, pid_t upid,
+			  struct waitid_info *infop, int options,
+			  struct rusage *ru, unsigned int *f_flags);
+#endif
-- 
2.40.1

