Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912A734ABED
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhCZPwn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhCZPwK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:52:10 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A74CC0613B1
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:10 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id d2so5381291ilm.10
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eWockdchS3a6xMrRD9YKnwNe5zKy6c1daS8+Rygs/lk=;
        b=R42fq/+9lDuL+wMbd/sssUFIMSXGRt+fjtOBbKXMCwCS3DDeNQVOYF5DJRK9yLkCj9
         MD8DButgJIgOkfSLnisMTIlvr1cWuVWqPxPz/ulbDe5O9qL+ivQhxu5pG30SWC6YZJ/E
         9c95cxMOzBvYq7+rDIvruWjqb2RwAMhokGpW9Ic8nOGK0FgUsWe/4eBXZCz/G69dr8Ge
         TEHOZU89naTSZcfJCyqXCtVg59iRh+Tm6efEMr8rapRBEc2FeLtLxRMuIFKw1ZgpS8TX
         IzWZCMsOgFli/vTBNBZBt9SeR+KLskA7qMtaGHEZ/n5GTVzPsIUpU9Khs+ZH4d6UThxc
         +9Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eWockdchS3a6xMrRD9YKnwNe5zKy6c1daS8+Rygs/lk=;
        b=QrMFJFTQsKLESwb4ObQ5KvRS5tJOVfQE3F65PH4H/e0jXx2tpk/zD3Hv8+BP+h5y3t
         DRuKHkp7WgcnoTqcki+RhV28Dvt2ke3qNsyhCIdueRn08jVH9LgnqBn0ZdOUzVBZWSOS
         LqRoP8isY0Z38Af770sX07j3a1csUUlxCI57WG5d2r9P9db4yhFxoHgu3zeAED31xm+O
         dF3IXRsNkaJ01+wCxpCmOOeZAWpkMGPN/Mh5vB0sE2MUQWthJ7IuqxgGs04XBAxjKxFZ
         jPf/Y4Q6I2FR6i8/K0sCWZQwtzQc9WVKUJf1NCTiQXUUBkGqjMQoLuthAdzXr4SQ7LRN
         Vqwg==
X-Gm-Message-State: AOAM531kGsgT4zSg8DeF1CcQF/fl8JVJ7zahe0WGLTZwVPByX+RjRmuU
        sJNp6YaYsYmYnI5mP6P1boqGhDtqVX8+Rg==
X-Google-Smtp-Source: ABdhPJx4THgfpKvWmoGJ8AmeFfR3pvKwo9OFzPs4dxu7sh6i/S05d+2jiGETrlHuQXdI7CrFJxJthg==
X-Received: by 2002:a05:6e02:f41:: with SMTP id y1mr10402687ilj.259.1616773929733;
        Fri, 26 Mar 2021 08:52:09 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a7sm4456337ilj.64.2021.03.26.08.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:52:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/7] Revert "kernel: treat PF_IO_WORKER like PF_KTHREAD for ptrace/signals"
Date:   Fri, 26 Mar 2021 09:51:21 -0600
Message-Id: <20210326155128.1057078-9-axboe@kernel.dk>
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

