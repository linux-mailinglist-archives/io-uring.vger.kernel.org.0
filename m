Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6BD34ABEE
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhCZPwp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbhCZPwN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:52:13 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A51C0613B8
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:12 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id r8so5402838ilo.8
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+6iLfraAukd5qWxrNJ/xAJfYelrvhrIxjGSLD09SOtQ=;
        b=lEGjnfc69W1L+LMtYZPdBxMiyGPHbGHmI+aw5ba765zV+A7M/rcEHYGtc4deKHG2Ed
         Bq+fmHj7q5sQjobGL5AkxyamMv/2NN/2NnFPB0MvgoHoehW/IlCTqBk6BCw2dXfAwW/F
         dedhSJluonJRhXzuBC+1tHDtjnWoSdMcK0hxcuboCo4szksh31tkq23glXRI56VYrbqh
         dZI4Dzj5kONMnBc6xVDdgqjxmWU0eZcElg1EB9V61vSsiLFhm6ocfYO7cYi1f/UUNEaK
         KaKTseGA1SnUurnktyfAE7s5LO8BZkBoSklN5TQLK7Q4IC/SQF0MVbVTrDbcOpT6okcr
         0WgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+6iLfraAukd5qWxrNJ/xAJfYelrvhrIxjGSLD09SOtQ=;
        b=M4h5P0DhZLt0mK+Kmmn29i9ZEeE4rE/HY3rRo/Fdkhjgrv5JvW1g4FqRTA8uevD11D
         ewBPZgic0J/uQ0iuKaPsZSLDjfuCGYFbBLCtRLlXw7vjU4KwQ6Pi9UVc7jQsyuMRPDmF
         0aU2KnneeLsXS3sGc8AiuFbcyL3k0/pqeOgeC2HQN/nZ7sAz9bPuDKCyfVIdv5uKXK3a
         P7xQEZNNm6FZYu+kEyXqtPDyTcVO1ePUuBQCp0FSr7M9HYDpLomu9ajpioLCGJXlk7gd
         3UHzUgL4j1Gci6fUE18Sp02VIrEINb/NJZETVyfviicERCJLFZazpvGCpk6uwwELIa9B
         rckA==
X-Gm-Message-State: AOAM532d7n82AcAVwTeGInYZU0kmuc/AS0gZo6BQxapS5N+fQYHKwxf8
        mtULzfho3p/m9aBLULs3ucB/DTGETIHWQA==
X-Google-Smtp-Source: ABdhPJxvI7RVZyct3nVnbx3/b/z6XxzhZwIkzkpFrzebvKdDXFvOmXQJqUPz5VXS6O9L+l2AqdeVXA==
X-Received: by 2002:a05:6e02:f07:: with SMTP id x7mr5740553ilj.242.1616773931339;
        Fri, 26 Mar 2021 08:52:11 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a7sm4456337ilj.64.2021.03.26.08.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:52:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/10] Revert "signal: don't allow STOP on PF_IO_WORKER threads"
Date:   Fri, 26 Mar 2021 09:51:23 -0600
Message-Id: <20210326155128.1057078-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326155128.1057078-1-axboe@kernel.dk>
References: <20210326155128.1057078-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This reverts commit 4db4b1a0d1779dc159f7b87feb97030ec0b12597.

The IO threads allow and handle SIGSTOP now, so don't special case them
anymore in task_set_jobctl_pending().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/signal.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 76d85830d4fa..5b75fbe3d2d6 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -288,8 +288,7 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask)
 			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
 	BUG_ON((mask & JOBCTL_TRAPPING) && !(mask & JOBCTL_PENDING_MASK));
 
-	if (unlikely(fatal_signal_pending(task) ||
-		     (task->flags & (PF_EXITING | PF_IO_WORKER))))
+	if (unlikely(fatal_signal_pending(task) || (task->flags & PF_EXITING)))
 		return false;
 
 	if (mask & JOBCTL_STOP_SIGMASK)
-- 
2.31.0

