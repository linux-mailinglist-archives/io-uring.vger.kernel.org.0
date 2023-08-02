Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B1876DB58
	for <lists+io-uring@lfdr.de>; Thu,  3 Aug 2023 01:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjHBXPM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Aug 2023 19:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbjHBXPL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Aug 2023 19:15:11 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39D330CA
        for <io-uring@vger.kernel.org>; Wed,  2 Aug 2023 16:14:50 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-686f74a8992so59281b3a.1
        for <io-uring@vger.kernel.org>; Wed, 02 Aug 2023 16:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691018090; x=1691622890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qOKoMn5bZK+SN77CCIJEeYWpwJKTharQ/mIzkTPuUOw=;
        b=fW/ZRQer1agPI61N0YIVyKetq1QNjGBCi7YCG1B4WYW19AOZNDS01zZ/Gskbn10aQv
         zPL0Gm9sWpm/+j9NGMFN9h0w454eLFh0MroSEEZFdj/piNjbc+BVIIq/SGXmFihPWFDD
         IolSyAxo0zr/0bHyo5nOgMNrX9dj/i+tZ9Ri5p3emb24cxEjrptIIM/88boLDwSglNux
         x9CeZr4wOQ/1DPRO3IwpLWxrFw7mfVV1C/+m9RduIA8VF4yWJUL2lXfxEQLxvSNXcy8N
         bsZ9AwBf9lAaRobv/k0nOZ9H9rDxbF/4B1fsJfRUxzwvFyI0AgxZkYKDFNMdIrT5yHsC
         NWJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691018090; x=1691622890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qOKoMn5bZK+SN77CCIJEeYWpwJKTharQ/mIzkTPuUOw=;
        b=Lx5STHx8gX+ozZRw9Q4OWTa2nHDXXiLieaHsagDZqctyyxpcBr3J65kh1TjmsMhACm
         h1i4pycyOfWTmDrYQ7nZUR+M/AvbJMz2PVAbrYgICZ6eDbIdZ1lyRYEx0a9ShiThKshV
         e5NnEYSZC2wGklPuKZri/A59PjJq0cCs8ciI24+AApztrNbiG+u2YFNnkSL80ndSQ9I3
         1c+kb/+MoTPhHXBvoduVMxgMKvM0oKVDZ6xEXZLBu9J5DCF0edShPrnm7Pzrvkni1UWl
         31d2YzRJHOc/w5JA8FTS4Y2t7yssQv0iR2eUJpxymRxSbdlCu6jmFO+ymVi5ysWAk/Nv
         72Ug==
X-Gm-Message-State: ABy/qLYj4Jzsm/uW2wDrj5B7DEr0HbEbDD4/fwTdjS4lWUZyit9APIzE
        IolJuJLRUVwKXFfs5w+pWZQkPywLKqplzwfCUHo=
X-Google-Smtp-Source: APBJJlGe3ZRhMg9l5R8gPWjUlGBoOJ2auq3mit8ovrgS5vSzLRQLYKv+qFgNbLi3plR1ptN0jaTELQ==
X-Received: by 2002:a05:6a21:9989:b0:111:a0e5:d2b7 with SMTP id ve9-20020a056a21998900b00111a0e5d2b7mr18562254pzb.4.1691018089962;
        Wed, 02 Aug 2023 16:14:49 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s6-20020aa78d46000000b006871859d9a1sm8588086pfe.7.2023.08.02.16.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 16:14:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] exit: move core of do_wait() into helper
Date:   Wed,  2 Aug 2023 17:14:39 -0600
Message-Id: <20230802231442.275558-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230802231442.275558-1-axboe@kernel.dk>
References: <20230802231442.275558-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rather than have a maze of gotos, put the actual logic in __do_wait()
and have do_wait() loop deal with waitqueue setup/teardown and whether
to call __do_wait() again.

No functional changes intended in this patch.

Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/exit.c | 49 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 2809dad69492..d8fb124cc038 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1590,16 +1590,10 @@ static int do_wait_pid(struct wait_opts *wo)
 	return 0;
 }
 
-static long do_wait(struct wait_opts *wo)
+static long __do_wait(struct wait_opts *wo)
 {
-	int retval;
-
-	trace_sched_process_wait(wo->wo_pid);
+	long retval;
 
-	init_waitqueue_func_entry(&wo->child_wait, child_wait_callback);
-	wo->child_wait.private = current;
-	add_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
-repeat:
 	/*
 	 * If there is nothing that can match our criteria, just get out.
 	 * We will clear ->notask_error to zero if we see any child that
@@ -1617,18 +1611,18 @@ static long do_wait(struct wait_opts *wo)
 	if (wo->wo_type == PIDTYPE_PID) {
 		retval = do_wait_pid(wo);
 		if (retval)
-			goto end;
+			return retval;
 	} else {
 		struct task_struct *tsk = current;
 
 		do {
 			retval = do_wait_thread(wo, tsk);
 			if (retval)
-				goto end;
+				return retval;
 
 			retval = ptrace_do_wait(wo, tsk);
 			if (retval)
-				goto end;
+				return retval;
 
 			if (wo->wo_flags & __WNOTHREAD)
 				break;
@@ -1638,14 +1632,31 @@ static long do_wait(struct wait_opts *wo)
 
 notask:
 	retval = wo->notask_error;
-	if (!retval && !(wo->wo_flags & WNOHANG)) {
-		retval = -ERESTARTSYS;
-		if (!signal_pending(current)) {
-			schedule();
-			goto repeat;
-		}
-	}
-end:
+	if (!retval && !(wo->wo_flags & WNOHANG))
+		return -ERESTARTSYS;
+
+	return retval;
+}
+
+static long do_wait(struct wait_opts *wo)
+{
+	int retval;
+
+	trace_sched_process_wait(wo->wo_pid);
+
+	init_waitqueue_func_entry(&wo->child_wait, child_wait_callback);
+	wo->child_wait.private = current;
+	add_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
+
+	do {
+		retval = __do_wait(wo);
+		if (retval != -ERESTARTSYS)
+			break;
+		if (signal_pending(current))
+			break;
+		schedule();
+	} while (1);
+
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
 	return retval;
-- 
2.40.1

