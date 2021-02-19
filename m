Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA3631FDA7
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhBSRLL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:11:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbhBSRLF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:11:05 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB71EC0617A9
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:24 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id a7so6323353iok.12
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0Nuy6DGNVyeU/ob27XmuAMzQKnXoxMp8mmTUNN0gjKQ=;
        b=qAgrns30dyvU3LmabqxdZ1bAgLrPoM43yVSFJB4zmm9B6HjsHcZqCaTXYvrXssYZcH
         WvAtfuyQcd8xKItCCpEeSvRHDPLOzljjlEPwRvQY6upV+ckKrPcnD9nfKEEzGvIbOqjh
         4kgWkHJINU2veLQhKd9AD0ZgARJ+FdNK2ui4sq05NRYRH/Z8twmSnNf/B5rFWB3iu+Ay
         u547tKgvmu0Oagxd47QEfX7CBvF4y6pn13q+1sn3D888XBiGNsbyreafJVGOmnW789g0
         rAhIJ2YbtuD6wV3wXs1t1pCVOlruaFW3PxvreLG6iJ3O6PNFQDyw3WVCCJnp7mRFqrcn
         HoQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Nuy6DGNVyeU/ob27XmuAMzQKnXoxMp8mmTUNN0gjKQ=;
        b=PWJfLx5qhwfFXrSX004N2OI1VeQzJ+aZ9cSfXFBgvQM862LsFg82nbtFCtWhTAH6UH
         IM+xxTwcxkAt4/MPXnQU0EoYsiBM68BmYGoUqMbGPA75a++RvGKWgFHry++FmljxNTD+
         0RDJ4Lk0tLg2f7MPmOuX6bUndcMA7JicGdZ0qeQFW7n3aWZUxQtVMfgNJRUy28KR5aNp
         pycsOqv66u8PrcgJwArjKeYxqTx7dQLjSmoTzT3Gz8gqQxesf0DOZ8uWBwhAjXFIrMFS
         9YD/SzySbfeGGCTNMbg/zVyxEo9FYhgdlYXFZ8cKj/Z1+iTF+1XoA649KdKdd5lGlUs5
         redg==
X-Gm-Message-State: AOAM532nElZRGu+832FCV/iOLK5JArazL7e4+8Nf+VS8v0CV03s5/P2S
        qi6RlblWphYNvMgHtdWPNCM/Cad6AmegPUPa
X-Google-Smtp-Source: ABdhPJzjwYNl4HORkcgaXRBi5gO7rtY3SzEB9j2vStyxSNkrCZOjXC4cd+BB0q6ud5gjZaC3LfXjtA==
X-Received: by 2002:a5e:9612:: with SMTP id a18mr4747674ioq.13.1613754623981;
        Fri, 19 Feb 2021 09:10:23 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:23 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/18] kernel: treat PF_IO_WORKER like PF_KTHREAD for ptrace/signals
Date:   Fri, 19 Feb 2021 10:10:00 -0700
Message-Id: <20210219171010.281878-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/ptrace.c | 2 +-
 kernel/signal.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 61db50f7ca86..821cf1723814 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -375,7 +375,7 @@ static int ptrace_attach(struct task_struct *task, long request,
 	audit_ptrace(task);
 
 	retval = -EPERM;
-	if (unlikely(task->flags & PF_KTHREAD))
+	if (unlikely(task->flags & (PF_KTHREAD | PF_IO_WORKER)))
 		goto out;
 	if (same_thread_group(task, current))
 		goto out;
diff --git a/kernel/signal.c b/kernel/signal.c
index 5ad8566534e7..ba4d1ef39a9e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -91,7 +91,7 @@ static bool sig_task_ignored(struct task_struct *t, int sig, bool force)
 		return true;
 
 	/* Only allow kernel generated signals to this kthread */
-	if (unlikely((t->flags & PF_KTHREAD) &&
+	if (unlikely((t->flags & (PF_KTHREAD | PF_IO_WORKER)) &&
 		     (handler == SIG_KTHREAD_KERNEL) && !force))
 		return true;
 
@@ -1096,7 +1096,7 @@ static int __send_signal(int sig, struct kernel_siginfo *info, struct task_struc
 	/*
 	 * Skip useless siginfo allocation for SIGKILL and kernel threads.
 	 */
-	if ((sig == SIGKILL) || (t->flags & PF_KTHREAD))
+	if ((sig == SIGKILL) || (t->flags & (PF_KTHREAD | PF_IO_WORKER)))
 		goto out_set;
 
 	/*
-- 
2.30.0

