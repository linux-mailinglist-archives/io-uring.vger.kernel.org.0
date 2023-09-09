Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B72A7999B7
	for <lists+io-uring@lfdr.de>; Sat,  9 Sep 2023 18:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbjIIQZh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Sep 2023 12:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346571AbjIIPLo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Sep 2023 11:11:44 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EF91A8
        for <io-uring@vger.kernel.org>; Sat,  9 Sep 2023 08:11:41 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1bf1876ef69so7337315ad.1
        for <io-uring@vger.kernel.org>; Sat, 09 Sep 2023 08:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694272300; x=1694877100; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r4BasFQ/oKOrzWOWITneaMiE6eoGK9Ito9WmrYw5u4M=;
        b=Qlafks1Es75m71iztSeIbZygekfxxLcp5cnAt4zgjycN+vkvffiwcF1rFfstEDjYPF
         Z+DFc38TyDquoigurXSIHPL2kwbvxfQCGZzw7A40ByLLazoUaTTYEUmjXiASj0xSL10I
         yfukiQPpiPydhzYf4gomYyyYzz6dqkJBDco8hL3fU9hvrWnNzfC2/vlbMITsJkQdxclw
         5mNJBQQOSmWf3jkcMaS9N86G8FKqVpSGy+y/kqhaLNVGvfTIOvGPyjIdtJ1ZIKgzLqKl
         mGBRn3TCxwBRrgKS/Vs1vT5vJj9zm+Dv1x32oIP9+VgpyH+kROG0krtrUzPsHqy6NMok
         YGWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694272300; x=1694877100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r4BasFQ/oKOrzWOWITneaMiE6eoGK9Ito9WmrYw5u4M=;
        b=q4ftr3XHEmdDyZ5KWZ6NFbdwYCi8NVV53Kbm7kv0TkonY5yftpcsm09NlgHQQGtUHo
         BlxLCCoM1jZWMF6kcBzsoM3dOB9aW5THg57uyWwmZ+vQvauDWNoXdn9S5dz3+2kLB7gd
         TvhKXvYRO6AblWGHahO4hfv2ueSD1oTqszv+twvWKB9uMHRSRezLOcohnJ9wbvFMwS41
         PiMLK0XCByRLOnig/A3w3wxlKJRCcV/GCl5iX1x1bAjfhxJNL7B58XH2ZNiJLosm7OHZ
         DngaxKkH+vnKLgCSyQKzJuIB5gIvcOyT70uz7Jbh41CJB6iigyTBXXeRT+NQF3r9A9Gi
         t67g==
X-Gm-Message-State: AOJu0Yz1v9oALdZaSh2TI1bmQ+UEqnJrGTXT3RRhSxDseZkLpyehMX5E
        EMFGXL1aARlizPMvncf145RhHXJ/jAOKWAOyi8O6xg==
X-Google-Smtp-Source: AGHT+IExsYeYY5q4vPtFuUKMM+SSTnhtWeBsBuGWwj2PgLW6AvN6CnAdjeP3vcnCl8nhFiFbDI7ikQ==
X-Received: by 2002:a17:903:3386:b0:1c3:8dbe:aecb with SMTP id kb6-20020a170903338600b001c38dbeaecbmr4360424plb.2.1694272300039;
        Sat, 09 Sep 2023 08:11:40 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902ff0f00b001bdb0483e65sm3371450plj.265.2023.09.09.08.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Sep 2023 08:11:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] exit: add internal include file with helpers
Date:   Sat,  9 Sep 2023 09:11:23 -0600
Message-Id: <20230909151124.1229695-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230909151124.1229695-1-axboe@kernel.dk>
References: <20230909151124.1229695-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 817c22bd7ae0..2b4a232f2f68 100644
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

