Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30237349E27
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 01:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhCZAlU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 20:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhCZAkx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 20:40:53 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3B6C06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:40:53 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id h3so3699413pfr.12
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5VFZ5F0P95MRNgw+SRJmF8MhV5XYlr1esTCnEdLFx4o=;
        b=qVdGD1kJFYnAUL/8agkIHKHlk1DUiRz/niBuNGe2UQqFQxOaqLAmr4dB+ZfmgViGhj
         6BdzWJQvFrBv0zBVncmzEtVO6+ntgLQNq/e6opxduxqeOV3F/BkYCCu3UY0JnIgNdXm/
         003pMD1vav2qydRplabfZtOyW27RspJXnw0e9Jahwhaw0DxUmz9YSk06kdr+IWYolcfi
         Sph+LTQAm/wa5UXt+EbeCdh+SEhIBmlsASSBe8c5pocCfQUfYxuHjQGtHGZpTRtvPnIc
         WHFOXTk3pHhxJUGI+1rHlBvH4BD5aHn2nojKPVT9p2mTaZkl4SYJlWhxyybf34Jte5xv
         i+wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5VFZ5F0P95MRNgw+SRJmF8MhV5XYlr1esTCnEdLFx4o=;
        b=i7x4CBIR/UgLemvd4nC5yYOVXETPRBOCpKTX6zT0KX3z4tDMklq2hEjmkvwe3lmJY7
         Cc1SPeCAFSTCvkXQAF4GodGsyYdUmaB+CCr4W0hs2R7V3tPbwTNp1rcE7OxfsCXLwG+C
         ssZQVVkLTLHt0yG/T/iwwBxf080pkq+X03FF1eqi0wS3t2kcb2WtvH34/VKKgl1SoJme
         DiqQo7CAeDHqQRqQQK8982qxOULbf51fnhBy58Gsl56QUylPGYQTxA5ZxDXLv+P9GuaS
         ukhIZA8dsHKh051kxzPdvVUUT3cHikv+S1v5rS08ea3auqfPew+l5NLi0NLLcDtVaEyz
         9aqg==
X-Gm-Message-State: AOAM530CNAWRqrYKb37j30TVKA6Zg5lk93qQwY+QYa8f3z7e2q2u7Hwk
        GsK45uOK/l6+f+NEHxuw1+RNsOcEMnBXLA==
X-Google-Smtp-Source: ABdhPJxFVacuwBUxGD4VWOgd1yUZQMHk67UTiQd7TPnQ2Ns3/JLb81YEYG2HgwV/He+GCLmRfaOJ2Q==
X-Received: by 2002:a63:e511:: with SMTP id r17mr9835094pgh.163.1616719252790;
        Thu, 25 Mar 2021 17:40:52 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c128sm6899448pfc.76.2021.03.25.17.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 17:40:52 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/8] Revert "signal: don't allow STOP on PF_IO_WORKER threads"
Date:   Thu, 25 Mar 2021 18:39:29 -0600
Message-Id: <20210326003928.978750-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326003928.978750-1-axboe@kernel.dk>
References: <20210326003928.978750-1-axboe@kernel.dk>
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
index 8ce96078cb76..5ad8566534e7 100644
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

