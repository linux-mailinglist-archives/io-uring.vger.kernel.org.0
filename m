Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF6F74F935
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 22:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjGKUoC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 16:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjGKUoB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 16:44:01 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB7F1AE
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:44:01 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-676cc97ca74so1392635b3a.1
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689108240; x=1689713040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RhnrJF2dPLoBWUU12VjDOt5vBH0HKwmnbELH9GE6Oiw=;
        b=3aCbceAwkgWqnj5/9VsREWCy67MDdUmA90tFIDvfByUxgd6lufiCgfQow5eLzCwAOr
         OLtIvB7uwtRtb1XARNCwQorqqwefVLZdlTcfKN4W86BdzonS5yVEStw9AymGna+7pgvL
         TW5QaH09WQy3ojKNx1oXs/4Tj++BorYbtHoiKFrbgHToLx4dBRJmLxmu5IfK8DhLkKws
         pGjaec3mdL5+FLZmFB+eXR80DAWnROaRF3etC8mAR080NZ+HMp0JC6RU9y0Du2/33ouz
         3/DF3L9z0Xd6uO6G3gnuOKchAW5UcCnwcSByavl1FZ6JGnOqI2jahJ8OTMPQSutH2mXP
         IZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689108240; x=1689713040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RhnrJF2dPLoBWUU12VjDOt5vBH0HKwmnbELH9GE6Oiw=;
        b=Hd8IFZa4XxbjRMSVGhIcVVcl1ZQ67b9bR0C8n91MOfm8R2CmcvGE4eRE6XI/6pZqi5
         zhbuLn6xa7275oGqpx6sERmz0UqHTt2PM7TQFoyhcZugiQ+4g9AaPF2kAxRAOoHs2OKC
         FXURuzYhu3QYetAyhZWiZGxagrnhdAgunsJYGYRULmKjY5+mdJhr1CXy2c0X25C+bM0d
         sqWo8q7ggjjKzzFlbK5AwCPmhQlb4vdybkI9fW4vpsRq3A1HMXFI4no3u/ez2aWK9JLx
         CThrSLLSA/JcHQbc65Rf4EZPyOoI2mMMS8KB5eiYsDWqOgzwVyw5XfLhOTZ3bnK4Wq/B
         0KyA==
X-Gm-Message-State: ABy/qLZUIKxBwpD8jvtV4JYzD3PTUcnVA3IRG6kp4qOJOFKA0UBqkRDb
        8wm0xXPDBjdxwTlO8BI3wfu7Tz8DMYqxvUJPNUk=
X-Google-Smtp-Source: APBJJlH1WI4NxORv1Syze1cWnO86O3fT/I1N2IycCPN6Q6rYEkYelyb+zzWE/YFlXO5xjXQ/JgdcGA==
X-Received: by 2002:a05:6a00:39a1:b0:67f:8ef5:2643 with SMTP id fi33-20020a056a0039a100b0067f8ef52643mr18904466pfb.2.1689108240070;
        Tue, 11 Jul 2023 13:44:00 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f7-20020aa78b07000000b00640ddad2e0dsm2124461pfd.47.2023.07.11.13.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 13:43:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] exit: abtract out should_wake helper for child_wait_callback()
Date:   Tue, 11 Jul 2023 14:43:48 -0600
Message-Id: <20230711204352.214086-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230711204352.214086-1-axboe@kernel.dk>
References: <20230711204352.214086-1-axboe@kernel.dk>
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

Abstract out the helper that decides if we should wake up following
a wake_up() callback on our internal waitqueue.

No functional changes intended in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/exit.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index edb50b4c9972..2809dad69492 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1520,6 +1520,17 @@ static int ptrace_do_wait(struct wait_opts *wo, struct task_struct *tsk)
 	return 0;
 }
 
+static bool pid_child_should_wake(struct wait_opts *wo, struct task_struct *p)
+{
+	if (!eligible_pid(wo, p))
+		return false;
+
+	if ((wo->wo_flags & __WNOTHREAD) && wo->child_wait.private != p->parent)
+		return false;
+
+	return true;
+}
+
 static int child_wait_callback(wait_queue_entry_t *wait, unsigned mode,
 				int sync, void *key)
 {
@@ -1527,13 +1538,10 @@ static int child_wait_callback(wait_queue_entry_t *wait, unsigned mode,
 						child_wait);
 	struct task_struct *p = key;
 
-	if (!eligible_pid(wo, p))
-		return 0;
+	if (pid_child_should_wake(wo, p))
+		return default_wake_function(wait, mode, sync, key);
 
-	if ((wo->wo_flags & __WNOTHREAD) && wait->private != p->parent)
-		return 0;
-
-	return default_wake_function(wait, mode, sync, key);
+	return 0;
 }
 
 void __wake_up_parent(struct task_struct *p, struct task_struct *parent)
-- 
2.40.1

