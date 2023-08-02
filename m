Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1895376DB5D
	for <lists+io-uring@lfdr.de>; Thu,  3 Aug 2023 01:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbjHBXPU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Aug 2023 19:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbjHBXPS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Aug 2023 19:15:18 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30C530E0
        for <io-uring@vger.kernel.org>; Wed,  2 Aug 2023 16:14:52 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-682b1768a0bso77702b3a.0
        for <io-uring@vger.kernel.org>; Wed, 02 Aug 2023 16:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691018092; x=1691622892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C9zc53z+/V9/ECV3tKzh/T4s2rLLXca0QnmcU/Zn8AM=;
        b=ev+WS3qaydOlkCo+QeWAPNPNHOvDvLz5rDIt+FcjMulT+GD53Eu9fsndQPFqHbDgXJ
         mw283KDuVisSntJFefGF8SIPSxPd9f442R6XxDH0n6hi23KGuugxfAfcEvTbF/HIC+Vu
         Sn5dWrcPzQ4zKVjPfWEOtZEfB48Fdg+a1WihE30oh/hjsk5vtGYpTIvBwXeqY8X8qquI
         NmD183MSlVg2qxSIgViiM76fbjawy/rg+taIIGQiTF6zpLCcZQIQQhxTJDzVXBnNAxmv
         wyE928xlSO/4VQ51BL5c5b99xLg3hcgEfOJ6ZOtOnvVTX7CoRTSbqCjJSfiksRbnuIzG
         lX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691018092; x=1691622892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C9zc53z+/V9/ECV3tKzh/T4s2rLLXca0QnmcU/Zn8AM=;
        b=WzrkZ1j9X+c9S3ySfR3fVYjPFbBOB8i5jQ1raXcHeeo5Ds7DQppE7Ib831CPFrOef2
         QW7v2quN5N94/eSmiO5MRv8ktxI9AoTy9kSZ7HXyW0OmCKtzqyx1s5LM37Zy7ktry12/
         U9QjlQI8unsIm5VZsbmTNGBs9+Gm0nGCqid2p9wvCVFTQi+QPi4Tv5EV5nj1dU9/MYrd
         vDC5XddmzG3xYCD9ec+kXcpG4I/P3gsflVYP0KzTIocuzatqMBdpd0bV3PBTUQ0u0n6i
         zvtEr98GHbWBeu+5H07i/FXy2stK63T2LWtjpJdvzGrBcnek8Dbtatnbc2RGkwFUDcoV
         YXoA==
X-Gm-Message-State: ABy/qLakTXCnc7NKFF+IQpurIfz7RYYi4F9gBqcj6GhYnNBcYn0TXL7z
        E2y9zqGeDoqyQR3a4O6uCFrBry2y6LpWnuc8+I4=
X-Google-Smtp-Source: APBJJlGUqQ+qTaXSEtlwh5o1pfV320sYyAnSpYOgky4uk/JsdIT9uBf/n/RVnVCQucnczLldHQGZcQ==
X-Received: by 2002:a05:6a00:32c8:b0:67f:7403:1fe8 with SMTP id cl8-20020a056a0032c800b0067f74031fe8mr14821176pfb.3.1691018092005;
        Wed, 02 Aug 2023 16:14:52 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s6-20020aa78d46000000b006871859d9a1sm8588086pfe.7.2023.08.02.16.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 16:14:51 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] exit: add internal include file with helpers
Date:   Wed,  2 Aug 2023 17:14:41 -0600
Message-Id: <20230802231442.275558-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230802231442.275558-1-axboe@kernel.dk>
References: <20230802231442.275558-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
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

