Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4677791A2
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 16:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbjHKOQk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 10:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbjHKOQc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 10:16:32 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14296E65
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 07:16:32 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-6879986a436so418564b3a.0
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 07:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691763391; x=1692368191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qOKoMn5bZK+SN77CCIJEeYWpwJKTharQ/mIzkTPuUOw=;
        b=Fr5qDzmrAy1xDvekdT2iNkrexabX/hs5iQLUXxadawHbBbzk+RSE46f718kVopldKR
         MImJ/7himOqEyn8S1veUmdA7+ou5itO5weo/m20hLMFIRnwxvfaAmOzRY0zB9vs/5sD8
         kwRe6HJJPhmMTVvj+xMytfw/99DO4JJq82w02ZzCfr9ZvnB57t/IH5nO+nJ3BUFOUvUV
         sJ32FRfSuafhtEu8GTvH0wTm5B2uLXEFHneJht4Thm6LOo4PwW+55ylkELretTuQ+JY9
         D63zYdzkqz9n4OYQonmnzjLHdNxfFsEoPiiJhUfMfHTa7ApGtKueR+CBBe63bdgIo0wj
         fFag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691763391; x=1692368191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qOKoMn5bZK+SN77CCIJEeYWpwJKTharQ/mIzkTPuUOw=;
        b=h/QmOKkDltstdhf+E+dlkBQz9DP2UYqnIbVNhGSoP/eBIv3v5XuH5q5uJSVLFtl18Y
         TncNypA+Wu3/pkXwi8vq5tK/1eO6zTGumgoACQEZhZVvXkV2dvxu/QnyXOV2P7Q5Zgae
         1XhuMos0mKHJOQxE09anpzt3RgOdY2vHVm/p997V/fzR/yyUga6o9nPuTAcxsKIe+nuU
         +kJ3V/NRrao+wGRmnQZtVWkbg8vgjDT5pShrHg2J9hkGN6en4/ZdxsOjRtR+XB8jl668
         VqKsSRYYrz7wIWkHR7TaGkyATeWj47NNowXsK6yFh2jN+bQmAsXoKlai4bGjIQ3a/SHn
         DYDg==
X-Gm-Message-State: AOJu0Ywo7DWV7IUJD24hNUcsMskubfd6qv0ejeTLMNPt3f2FjDImmjAs
        XGtvl4MOZbm+lPpdLPVjoupg4RFhfVC1arKvP5A=
X-Google-Smtp-Source: AGHT+IFKb4nK6L4pfbXD8s+oAeugIVWLNV2VUIguXqP0tMo1tRMVsmLjAPrIJHC8r/MZu7rRVGJBWw==
X-Received: by 2002:a05:6a21:6d92:b0:13e:1d49:7249 with SMTP id wl18-20020a056a216d9200b0013e1d497249mr3188783pzb.2.1691763390888;
        Fri, 11 Aug 2023 07:16:30 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s21-20020a639255000000b00564ca424f79sm3422311pgn.48.2023.08.11.07.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 07:16:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] exit: move core of do_wait() into helper
Date:   Fri, 11 Aug 2023 08:16:23 -0600
Message-Id: <20230811141626.161210-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230811141626.161210-1-axboe@kernel.dk>
References: <20230811141626.161210-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

