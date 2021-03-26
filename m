Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC2334ABE4
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhCZPwP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhCZPwH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:52:07 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0485FC0613B3
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:07 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id d10so5410291ils.5
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2t6iLdXAU1r3Y7JBXozM9Cp3Dd1oQr2SnOThQgSbPl4=;
        b=YnXWk5kppJoJPBxYw/wYd53PK+lfddAN4D5PRi0Pm5WAt5hvcjz8UpopfIyG70/uVe
         6bb/oizXQVSqHhM4Q40g3esoiAscXjao3G82z5rC/efYtkRijnhRpun9Q96LJpr1pSHJ
         JnwugMdZIYuXGTiO8+zAJ5aCPa8jbeN+5O++ZOjbGX9rVDwfWtZC/04rzawQDAz4hrp0
         Cy6/6xMRLGe2Gc3uuXDklT+E3aTS9zA6qXgFxu4LA9Lvi38pgaPQh8yrDwVF5455ITr9
         Lnx/D6Eu7YmKoI6BZNzfRFa3MQIFmE5CglEXgpThc4ega6l1o/71Q4Cw+AUAw9A/Ww69
         iRUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2t6iLdXAU1r3Y7JBXozM9Cp3Dd1oQr2SnOThQgSbPl4=;
        b=db/g06EV0yEOMZYNYncea29bKL/jIeTX2Psxtnscjggyt71F63TIr60I11NDMY10nX
         4+UioNrfvUGVIMYamRY7qRhkudCEN2Qg7II40EM5Zyj4VUvWv9SZb+oVhZZ45l8qToNo
         e0Q/7AsoYKWYT4l1miWcvwbH9urYgCP1s+li3OkQ4/JgbnOOgS3nRxQ8CyGhPy6z6z2/
         X3HmvFGhOdjeDvLT/3SeusJxSeKV1bcu57w1aqSP9yeKoOOJs0tnM/Vj6EIA5PVuewqs
         jiE0nXwW5fGx/b89fHcogeEX5ppSBZMuIjiICySZVwReiEMaAdxiS1bvUHYB7NjApRqO
         +YpA==
X-Gm-Message-State: AOAM530izcNC6taEE07f1hgGPUNNP06GnUm3JLI+UhJNJdpHFidgQ34W
        Mi6baVkrgEWFIxocl81ZkySE0qY1+mSlNA==
X-Google-Smtp-Source: ABdhPJytbzRF5CIaGho+RCmG38IXLE3SJ+K+2XyZVuWVDHLEwXvSz5mUHkofTKmlFhgVDHgsF3P6CQ==
X-Received: by 2002:a92:cd51:: with SMTP id v17mr11377639ilq.146.1616773926253;
        Fri, 26 Mar 2021 08:52:06 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a7sm4456337ilj.64.2021.03.26.08.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:52:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/7] kernel: stop masking signals in create_io_thread()
Date:   Fri, 26 Mar 2021 09:51:17 -0600
Message-Id: <20210326155128.1057078-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326155128.1057078-1-axboe@kernel.dk>
References: <20210326155128.1057078-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is racy - move the blocking into when the task is created and
we're marking it as PF_IO_WORKER anyway. The IO threads are now
prepared to handle signals like SIGSTOP as well, so clear that from
the mask to allow proper stopping of IO threads.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/fork.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index d3171e8e88e5..ddaa15227071 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1940,8 +1940,14 @@ static __latent_entropy struct task_struct *copy_process(
 	p = dup_task_struct(current, node);
 	if (!p)
 		goto fork_out;
-	if (args->io_thread)
+	if (args->io_thread) {
+		/*
+		 * Mark us an IO worker, and block any signal that isn't
+		 * fatal or STOP
+		 */
 		p->flags |= PF_IO_WORKER;
+		siginitsetinv(&p->blocked, sigmask(SIGKILL)|sigmask(SIGSTOP));
+	}
 
 	/*
 	 * This _must_ happen before we call free_task(), i.e. before we jump
@@ -2430,14 +2436,8 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
 		.stack_size	= (unsigned long)arg,
 		.io_thread	= 1,
 	};
-	struct task_struct *tsk;
 
-	tsk = copy_process(NULL, 0, node, &args);
-	if (!IS_ERR(tsk)) {
-		sigfillset(&tsk->blocked);
-		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL));
-	}
-	return tsk;
+	return copy_process(NULL, 0, node, &args);
 }
 
 /*
-- 
2.31.0

