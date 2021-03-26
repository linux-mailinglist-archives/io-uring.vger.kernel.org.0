Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084C8349E22
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 01:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhCZAlS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 20:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhCZAks (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 20:40:48 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FFAC06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:40:48 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id v10so3444719pgs.12
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZraEtUCV2acD7fBa5SEhKvc6Elb2YkSsHkkh6DBvMcc=;
        b=T1YT7oGi1AvvOihv+fkm5Z3HTE537IbIn217/FrN0x7/LGHF5Dn6QWaTmKqj0R1j3l
         vYD3ksC9siVkzR5BmNeCTzIOlM3I0Pqte0ZgpyiMhqx2aCx8ZpK527NlQe/4rHOxrx6i
         XoPm/iERq5TKQHJXpgsn5GV+m2HUtT6PFSuz8XuqgZ75LaPQR1Z9D9jsvc5s21FpYNAH
         feVeoA645Y928amgIXqEadVFe6ARcC+rqyakm2lKiO5IX90lTi4wkjE6rxHzSbH0FO2B
         3lpjxUMaP7laG/qxUOwdp1XahHq1rxvoTkeZ6abPN006MZX7ghrqWdPuY62TOTPoHqc/
         eTmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZraEtUCV2acD7fBa5SEhKvc6Elb2YkSsHkkh6DBvMcc=;
        b=QsXjRSSTKakQ04v1SW2H9Ydf/r5jrJN2zkewsuJXUuq2zCwFOR7M90nR1SAJWNQOfN
         LMEe1I7polzjB8JFz2WIUS3A5A6QURrhZQqSzYVK4XjWC3ANCAqgt0KfRgVHbQg0hhSt
         oV9xZNL+bEn5DcR2mCo1/VlM0eCjHYaeqLSEC72B6MDfm3dvM8Qkpa0VmfZuqP4KOU3z
         WuBxLb6IWumP80UvTLB+8diMiPzyGhFKCu0shmDMrLnM42zP3vK5AJFgysPtgRkHU9jB
         ZWfIF3gm1bCPh9aOz0ILCY+K4DQQhqb0avVkGQ83ADRCg8oyiEACemaI+q7r+efAjIbG
         HcTA==
X-Gm-Message-State: AOAM531aLLJR3m0W7WX/jODcDMTECFXFf16u0dFrQ/Bu0JQX7k2SUZeG
        U0sr5hTVvKh3BeVK0O3DngxJWJRX14c6IQ==
X-Google-Smtp-Source: ABdhPJykhUgOKxnJVjT2PMV4oTuTaxVVA45s05E/Ss0z7un6NKFgyWb9/ADHGfOFLNsXtt8XvpNu2A==
X-Received: by 2002:a63:1b5f:: with SMTP id b31mr9986812pgm.194.1616719247924;
        Thu, 25 Mar 2021 17:40:47 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c128sm6899448pfc.76.2021.03.25.17.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 17:40:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/8] kernel: unmask SIGSTOP for IO threads
Date:   Thu, 25 Mar 2021 18:39:25 -0600
Message-Id: <20210326003928.978750-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326003928.978750-1-axboe@kernel.dk>
References: <20210326003928.978750-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With IO threads accepting signals, including SIGSTOP, unmask the
SIGSTOP signal from the default blocked mask.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index d3171e8e88e5..d5a40552910f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2435,7 +2435,7 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
 	tsk = copy_process(NULL, 0, node, &args);
 	if (!IS_ERR(tsk)) {
 		sigfillset(&tsk->blocked);
-		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL));
+		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL)|sigmask(SIGSTOP));
 	}
 	return tsk;
 }
-- 
2.31.0

