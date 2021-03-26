Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B69349E2A
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 01:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCZAlT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 20:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhCZAkv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 20:40:51 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060DCC06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:40:51 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so4783515pjb.0
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3RrQjdii+9GTdxPaONZzqHC3ARJF5t/OnNTbRKIfjxA=;
        b=cPq6NYuPcWiz1YnkqI4+j23jl0NuBpWjEyTnhetuFJ8mXdXmK/d9CKD//StV7GmBLH
         KNIPEDDjbT2Vtvo8ru6daG1AfiDVBTPnPuVjgvWCCcYYugdzQwaZcF9anuf5VCGI5Khp
         lx7YtkdEKhZc2Vzz3fObwnGwIRfuhLzrxl/DYt3WZJe7MNObMH6/8TYK9xDVRZ182vxn
         aF2w73crzdFOh841SPwVkWjBv30MRWHufE+DPZ4b/7IPijMNiKHsgRZaBZ3UanjRi5eO
         cAXQze1Le1A8s+eaTOHR51GPl6xDOYAMYUPmaoS9swmk5EP3ZPHJMimCapNJKzchyFNS
         zdHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3RrQjdii+9GTdxPaONZzqHC3ARJF5t/OnNTbRKIfjxA=;
        b=XZbeMn6uBRwmr1kp8K7uDwt0X3266v4LLeOdIjjZVi2ZiJ+pCFhCwuHvd44GZ2Vaej
         dyZGTogzEvPYRkJqDnx5HTlAt+xYBRhgzbC2GRCnkDmnrbSoVTVYSvSZ67AE9PfKX/Im
         MxykooC4xLpI1RIxH6NT4PAduRNf20lDlVg1BZxtmuWOZOBAkW/mqA1ySc0gVhL0CFrn
         c1GvxDFb7IMF/hASG+C1ceW44+N9e/pqEsYZDlsVL7+AFIAOx9T4xGfquxiE31z3ysZq
         68fvy/kUqD8tY3vfMiTUSMlP6KVM9/R8nhMVUMiwgjfjdc5PhZ5me2jkgOahknmbOjTT
         +wyQ==
X-Gm-Message-State: AOAM53213+7CXesB5WQRI9VG7WwatiaxksEDHR/IU9PTujROXMJF5fq+
        EV/0HmhFLnlypDCnVh1T/eWqPFibqQ4hGw==
X-Google-Smtp-Source: ABdhPJyzp1FhvuYSapeL5MI+i2oJfZ44GcrdxL3hN5HJlgr1NvktY2XOtc3Sf0XaJsSFMa+TM05gxA==
X-Received: by 2002:a17:90b:3449:: with SMTP id lj9mr11545275pjb.55.1616719250367;
        Thu, 25 Mar 2021 17:40:50 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c128sm6899448pfc.76.2021.03.25.17.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 17:40:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/8] Revert "kernel: treat PF_IO_WORKER like PF_KTHREAD for ptrace/signals"
Date:   Thu, 25 Mar 2021 18:39:27 -0600
Message-Id: <20210326003928.978750-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326003928.978750-1-axboe@kernel.dk>
References: <20210326003928.978750-1-axboe@kernel.dk>
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
index cb9acdfb32fa..8ce96078cb76 100644
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

