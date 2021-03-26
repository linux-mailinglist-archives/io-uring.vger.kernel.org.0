Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69EA34ABE9
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhCZPwl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbhCZPwI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:52:08 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC89C0613B1
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:07 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id c17so5406952ilj.7
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eWockdchS3a6xMrRD9YKnwNe5zKy6c1daS8+Rygs/lk=;
        b=XLQmazPLSIb9A4I0635PmtqGMQbnRr09ORmcybh+A9uGUq0VPeTwCy6jn5ixA6nLed
         PZoW14GS7h0TJWxD0tu39NvaBiE3RZbZ5psiOyzTfGmEL/p7T0IKc+U8GRCL/W/oR3IF
         gF2tot9WXgA++i2bT4kAF44KxYXIx0XP0lofcA1RKpyYeXzud4RAdZN0K6K7yrfiRbP0
         wq1J6bEBOm43Qito+DKWgDQyRb59MVES59NXIELPUtGfz6iH3xAE9gX/rGxp6aeLUem6
         CKe8jkzabkUT5TwXslp94cGawy0uVXNDVNUMU2wehw6MzhW36NtO8KxbyCBy76r14Q8g
         LcDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eWockdchS3a6xMrRD9YKnwNe5zKy6c1daS8+Rygs/lk=;
        b=EG9qLt6FXYj0xSHxNg+Ufya6kJh7JAF5Y8yjdBtn+ar0qByWc7oTxc7EHqpgWKIun2
         byQKNEo+84Z+sIiGoRhdaQibo/dvHI2QdAdYBj2wy0outrsiwpBVqWemGh0b7Xj9v+mC
         ql058uxZatUei4C9j8kNkiSWTBF2doe/XsR/OohA5SNfaY0+w5gAECzvPVc02b2Q3VRT
         hqfc6+pMA2zqQOiJDmvnG6pGDTBU8o+OSiXWxReVJyPL6ZBnOE71cevSTMG0six8d2L7
         Xkx8w5l8koRI63p7ecSWYDkEBzh2Ri93YHyYxybM+IhVNUZcIScOedhO0wHa5k190EFR
         wyrw==
X-Gm-Message-State: AOAM533FKQOvCl9yKWvpktz7SSQX6v/+CquopuVtRd4jHqg5njcEZ0mR
        sX6SZQm3bQ3cCBa9WREa2kecJoLOXkW5xg==
X-Google-Smtp-Source: ABdhPJwZCT0+zs6TUK7b3YTT1LKTP4iuoK5r6PcgPUkJ/Cr1PTJvX1Pp8cjYWiiG99j+rx7XNsuNXA==
X-Received: by 2002:a05:6e02:1183:: with SMTP id y3mr9573639ili.147.1616773927126;
        Fri, 26 Mar 2021 08:52:07 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a7sm4456337ilj.64.2021.03.26.08.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:52:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/10] Revert "kernel: treat PF_IO_WORKER like PF_KTHREAD for ptrace/signals"
Date:   Fri, 26 Mar 2021 09:51:18 -0600
Message-Id: <20210326155128.1057078-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326155128.1057078-1-axboe@kernel.dk>
References: <20210326155128.1057078-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This reverts commit 6fb8f43cede0e4bd3ead847de78d531424a96be9.

The IO threads do allow signals now, including SIGSTOP, and we can allow
ptrace attach. Attaching won't reveal anything interesting for the IO
threads, but it will allow eg gdb to attach to a task with io_urings
and IO threads without complaining. And once attached, it will allow
the usual introspection into regular threads.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/ptrace.c | 2 +-
 kernel/signal.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 821cf1723814..61db50f7ca86 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -375,7 +375,7 @@ static int ptrace_attach(struct task_struct *task, long request,
 	audit_ptrace(task);
 
 	retval = -EPERM;
-	if (unlikely(task->flags & (PF_KTHREAD | PF_IO_WORKER)))
+	if (unlikely(task->flags & PF_KTHREAD))
 		goto out;
 	if (same_thread_group(task, current))
 		goto out;
diff --git a/kernel/signal.c b/kernel/signal.c
index af890479921a..76d85830d4fa 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -91,7 +91,7 @@ static bool sig_task_ignored(struct task_struct *t, int sig, bool force)
 		return true;
 
 	/* Only allow kernel generated signals to this kthread */
-	if (unlikely((t->flags & (PF_KTHREAD | PF_IO_WORKER)) &&
+	if (unlikely((t->flags & PF_KTHREAD) &&
 		     (handler == SIG_KTHREAD_KERNEL) && !force))
 		return true;
 
@@ -1097,7 +1097,7 @@ static int __send_signal(int sig, struct kernel_siginfo *info, struct task_struc
 	/*
 	 * Skip useless siginfo allocation for SIGKILL and kernel threads.
 	 */
-	if ((sig == SIGKILL) || (t->flags & (PF_KTHREAD | PF_IO_WORKER)))
+	if ((sig == SIGKILL) || (t->flags & PF_KTHREAD))
 		goto out_set;
 
 	/*
-- 
2.31.0

