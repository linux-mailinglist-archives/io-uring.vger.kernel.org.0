Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D47B7999C9
	for <lists+io-uring@lfdr.de>; Sat,  9 Sep 2023 18:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbjIIQZj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Sep 2023 12:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346565AbjIIPLk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Sep 2023 11:11:40 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B221AA
        for <io-uring@vger.kernel.org>; Sat,  9 Sep 2023 08:11:36 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-68a3d2ff211so545578b3a.0
        for <io-uring@vger.kernel.org>; Sat, 09 Sep 2023 08:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694272295; x=1694877095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0W4hkYYGlPKafnFtIfHw3u5JfmMzy8zkW1KZ07xxWOU=;
        b=zmu7XiE++F79u79Hx6tQ5kudd20FLek+pZHCSkcH8ynAn4b9VSYXLcC99kBDQeo4/P
         ixwG+sA+wRwLD3MnSKwHZ0WlxeJEDvikmgoo174fBUk6tIspqYgvu0qFqqbQ6HXQFLIK
         2Rjbn35tS0G9LuvO4XIn4Lp6nxnpBRhRjg+mxFpLOK+5qILLFuXojZq47mZi4Ae/TFb+
         xZl4I0W7vugwkSH+LsjZvB47appU1iqpQSputcWCl8Fv0GggwHdeRCJSylYTEQXGMzZC
         +CbG3neAQNrNIPVkHKTha6n7gJ/Iq531DiQDhz8jpOM75nOGzELK8NdixgrFTjUnFzJ+
         fNYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694272295; x=1694877095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0W4hkYYGlPKafnFtIfHw3u5JfmMzy8zkW1KZ07xxWOU=;
        b=Eqn4lUEPRPUB1f2cHCYuYnbr9C4sR/srIX2hfSyColYM1Gwdu43HFBYkTret2M4exe
         +HSSBOthab6R4wtjBQYK00AdfhxY96lT0iVtAiVRZj4BXzjIX+s3s3yxRwGpvS1zEVkB
         Mk2rfqxm2BH/mLETrxpUomXx/WiSrF0wJ2NLjb3GNOGnsxUyIO4nnlCsN4lIqLLtC8Fx
         +VwYrybIVX/6WYmEIcgpAdazO3fS3IqqQlcC5YMMk3qQIzea5AozM5/TJs/5QzHXcDfc
         vVP1ailLQDRbmPrj3kPDJjzcHTY/QJPNXfi+ZKsMoFKr7ioGrJTZE5FKCWsCPe5HOo/R
         WnBg==
X-Gm-Message-State: AOJu0YxcL9BdeOMIxFAUskfpvUbKTnEWpAlL9Gg90e+fJ8lAR/Zj/ex9
        CVVysJSpV7KtH+gvPrvF6pVOWiOy02Xk5mbyZotlNw==
X-Google-Smtp-Source: AGHT+IGaRQUv+mjCHoZ5kL7O3SNlpCByHUddNlYoxc4A7yZk0W+8cLKxNAci6nqxnolshxJU1dc7PQ==
X-Received: by 2002:a17:902:d48d:b0:1c2:c60:8387 with SMTP id c13-20020a170902d48d00b001c20c608387mr6565145plg.0.1694272295604;
        Sat, 09 Sep 2023 08:11:35 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902ff0f00b001bdb0483e65sm3371450plj.265.2023.09.09.08.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Sep 2023 08:11:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] exit: abstract out should_wake helper for child_wait_callback()
Date:   Sat,  9 Sep 2023 09:11:20 -0600
Message-Id: <20230909151124.1229695-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230909151124.1229695-1-axboe@kernel.dk>
References: <20230909151124.1229695-1-axboe@kernel.dk>
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

Abstract out the helper that decides if we should wake up following
a wake_up() callback on our internal waitqueue.

No functional changes intended in this patch.

Acked-by: Christian Brauner <brauner@kernel.org>
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

