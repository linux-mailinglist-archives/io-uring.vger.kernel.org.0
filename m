Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1305577919E
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 16:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbjHKOQl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 10:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233485AbjHKOQj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 10:16:39 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8242706
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 07:16:34 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1bda3d0f0f1so2272565ad.0
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 07:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691763393; x=1692368193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V8yRFdlpefOfywdA2XDRJ2uYVWVe52WNVP5jsRYSyGo=;
        b=ZDotbKvYQpcsRvEvVcLhD9yzgNFRHqGHIk/JGuRkq9Uz0HhmBUEb+HOJhsR25jxre+
         FU2Hn0XtaQxsP9c08ZJuE2L51GhiD2m38JIowgriCNuZI3MX3IZo1F9OqF1rGp/s+QGp
         Pwxs4cCSTf0fywZR3wgbgxvNdO/2D3h4Ua6t8YcBxG68VPzr6vLYHkBZMRY7GE7QnQKw
         4RPcD3/lT6xvQLHagl9FqPvwa9P0r8gOC0N07CuZhWyo/po5NCzs+Q4pK0RWjIJi8GTt
         pvlmAVmo1soP9YPkqgP2YXur88r9Ue613rtG2g7bTPl0Cxjo4K9vRpLJlyLG0qh6LAsI
         Qgog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691763393; x=1692368193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V8yRFdlpefOfywdA2XDRJ2uYVWVe52WNVP5jsRYSyGo=;
        b=I+/6Z/ClEoL/D87dnUayl+mL3vE9HQlXQFniNCTj7ugXtUsdMkso8DuzyICzLdjoY/
         MOMjYlT9VZDCVpgpMvFsXrIX1wrCgzZHMkoL3cduQnHmjP/rnGjzJGJw8BLQNXYOUkpj
         cn7IHIc+rfN6MLOqKyUQGk+hw/YVnhqlZUDckrh8BaKUzZAE5srtPk/vafirHh5FoIeP
         ggVO5m8qlDSuSz+4R5ms/PRVFBelLqh/wfO+C29nlnssnymwGj4k8sr/n8hJx2Hm5G0V
         ayqAcVsQhnf+oD6UIyzFtfPsBSMS/65bCOpXeNT/0DBCWO98S9xLtOBr+bevp/vJNQPV
         Veig==
X-Gm-Message-State: AOJu0YxeuCgDkss7e7D0KFN3QaHro9Z7yMtlXKYOx8dVbtDpED2y5xvO
        rQUo4FJE5AKdU/tLz5ebhQwENstM32nZ5eWOzJw=
X-Google-Smtp-Source: AGHT+IHXlyQj1e0b/jZO9z97NIXu6hkk5Z5Nu2mNmtlCclUPrG6Ooyww9j1gNnwmuyd6DvOAYVd5LA==
X-Received: by 2002:a17:902:e745:b0:1bb:ac37:384b with SMTP id p5-20020a170902e74500b001bbac37384bmr2247979plf.6.1691763393370;
        Fri, 11 Aug 2023 07:16:33 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s21-20020a639255000000b00564ca424f79sm3422311pgn.48.2023.08.11.07.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 07:16:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] exit: add internal include file with helpers
Date:   Fri, 11 Aug 2023 08:16:25 -0600
Message-Id: <20230811141626.161210-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230811141626.161210-1-axboe@kernel.dk>
References: <20230811141626.161210-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 5c4cd1769641..2e39468823e7 100644
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
-				 struct rusage *ru)
+int kernel_waitid_prepare(struct wait_opts *wo, int which, pid_t upid,
+			  struct waitid_info *infop, int options,
+			  struct rusage *ru)
 {
 	unsigned int f_flags = 0;
 	struct pid *pid = NULL;
diff --git a/kernel/exit.h b/kernel/exit.h
new file mode 100644
index 000000000000..278faa26a653
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
+			  struct rusage *ru);
+#endif
-- 
2.40.1

