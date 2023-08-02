Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D580E76DB5B
	for <lists+io-uring@lfdr.de>; Thu,  3 Aug 2023 01:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbjHBXPO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Aug 2023 19:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbjHBXPN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Aug 2023 19:15:13 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43FA30D1
        for <io-uring@vger.kernel.org>; Wed,  2 Aug 2023 16:14:51 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6862d4a1376so57518b3a.0
        for <io-uring@vger.kernel.org>; Wed, 02 Aug 2023 16:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691018091; x=1691622891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WYDIyeoAajuf9ZWE7uQTqbgmYwdh8IUMjMetvGRNy4k=;
        b=j/TOQbbGU9Y515OgPvP1VwT9KdHRrb9ZDbEFT0J9+QwQPRL96cGPPaAJbKHcolCg/v
         itATAWdxTMiqX3Zkqg1wadUnLchhbL6hXdOtbXCGVe2v3V4z8Nt0T/y81lotBAxPNuFS
         3jQhHAaOLb63IEUn9WrcCVk4CiP6j51lN5RIN8jWDUznmFcpRC0hHBxbV/CvEYlaB9t9
         VsKqVb2kgmdSxFvDCGyvQXAfDtKM6QuKUyBID07WNA6SlVltqxVQSndTDhhEBd1K3IG5
         VmMZiaqMTLTyG+f4FleKE8FQKsdnp/uKHb4rblU9yxmqwjG9IEtCcxXKW9yhHclmyFLw
         7tVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691018091; x=1691622891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WYDIyeoAajuf9ZWE7uQTqbgmYwdh8IUMjMetvGRNy4k=;
        b=hTlCqHoeCBEJGKOF44gj4kzdwJnhTSVfZiImpY0jBX7aF/npDAEhpHFlZDBfN0NFui
         nR3UHOBhUUABiSGwTOQaoEW3cBw+Oytt7AIiVVqXfyYWKS9s13P9l7x2q1lZJSMlDd09
         /0RgNu1rYJLYa0cGkfofd2Vh0Na+asrFd46Bh0PZnIKgVWZsabEVOM9CP780R8pjhGoc
         2BskPwR+8mU1QQ0KJmuN4AlJjW0L0aVo5CEEAxcbtOc9zySYriCE694Y18Mr7L0yMzKT
         xO3aif0GuGSLo9IVsyWBI2eNeWd1VfY6pgzdv9gC0iKLa8tHhHbDO5GP93lj5v2MCiVg
         3U9Q==
X-Gm-Message-State: ABy/qLYUbfd97VCH8+9xKfuetIIYhUqGdSQ2FV+DHw38mce/M6y3vyFq
        mr+ha4lhfukwwiIWdNp9i/kkwSaFh8ulsAHCPTc=
X-Google-Smtp-Source: APBJJlGdM6gRP1P4XGulUJDhuH7Jw0mcgkA8A9sfisfj2ANPB9MegnrkdNc7aQa91Pqhf9KpHsi/Wg==
X-Received: by 2002:a05:6a21:33a6:b0:134:1671:6191 with SMTP id yy38-20020a056a2133a600b0013416716191mr17934352pzb.0.1691018090915;
        Wed, 02 Aug 2023 16:14:50 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s6-20020aa78d46000000b006871859d9a1sm8588086pfe.7.2023.08.02.16.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 16:14:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] exit: add kernel_waitid_prepare() helper
Date:   Wed,  2 Aug 2023 17:14:40 -0600
Message-Id: <20230802231442.275558-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230802231442.275558-1-axboe@kernel.dk>
References: <20230802231442.275558-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move the setup logic out of kernel_waitid(), and into a separate helper.

No functional changes intended in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/exit.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index d8fb124cc038..8934c91a9fe1 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1662,14 +1662,12 @@ static long do_wait(struct wait_opts *wo)
 	return retval;
 }
 
-static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
-			  int options, struct rusage *ru)
+static int kernel_waitid_prepare(struct wait_opts *wo, int which, pid_t upid,
+				 struct waitid_info *infop, int options,
+				 struct rusage *ru, unsigned int *f_flags)
 {
-	struct wait_opts wo;
 	struct pid *pid = NULL;
 	enum pid_type type;
-	long ret;
-	unsigned int f_flags = 0;
 
 	if (options & ~(WNOHANG|WNOWAIT|WEXITED|WSTOPPED|WCONTINUED|
 			__WNOTHREAD|__WCLONE|__WALL))
@@ -1703,7 +1701,7 @@ static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
 		if (upid < 0)
 			return -EINVAL;
 
-		pid = pidfd_get_pid(upid, &f_flags);
+		pid = pidfd_get_pid(upid, f_flags);
 		if (IS_ERR(pid))
 			return PTR_ERR(pid);
 
@@ -1712,19 +1710,34 @@ static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
 		return -EINVAL;
 	}
 
-	wo.wo_type	= type;
-	wo.wo_pid	= pid;
-	wo.wo_flags	= options;
-	wo.wo_info	= infop;
-	wo.wo_rusage	= ru;
-	if (f_flags & O_NONBLOCK)
-		wo.wo_flags |= WNOHANG;
+	wo->wo_type	= type;
+	wo->wo_pid	= pid;
+	wo->wo_flags	= options;
+	wo->wo_info	= infop;
+	wo->wo_rusage	= ru;
+	if (*f_flags & O_NONBLOCK)
+		wo->wo_flags |= WNOHANG;
+
+	return 0;
+}
+
+static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
+			  int options, struct rusage *ru)
+{
+	struct wait_opts wo;
+	long ret;
+	unsigned int f_flags = 0;
+
+	ret = kernel_waitid_prepare(&wo, which, upid, infop, options, ru,
+					&f_flags);
+	if (ret)
+		return ret;
 
 	ret = do_wait(&wo);
 	if (!ret && !(options & WNOHANG) && (f_flags & O_NONBLOCK))
 		ret = -EAGAIN;
 
-	put_pid(pid);
+	put_pid(wo.wo_pid);
 	return ret;
 }
 
-- 
2.40.1

