Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37AE76DB57
	for <lists+io-uring@lfdr.de>; Thu,  3 Aug 2023 01:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbjHBXPL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Aug 2023 19:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbjHBXPJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Aug 2023 19:15:09 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA632D74
        for <io-uring@vger.kernel.org>; Wed,  2 Aug 2023 16:14:49 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-68781a69befso62593b3a.0
        for <io-uring@vger.kernel.org>; Wed, 02 Aug 2023 16:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691018089; x=1691622889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0W4hkYYGlPKafnFtIfHw3u5JfmMzy8zkW1KZ07xxWOU=;
        b=VvLqsRm2OJJU+D1M0rQbLPXxUftobv7dOQuACj7+lEUWYSbCpZrRdum9arEJRpP6ZV
         foTPkMFYT2P2s+xHw4MltELp2HXcKx/0V3ic1d23NgGVFndvLNP9oY87foFS2DBiLedT
         oeChmSpVCBUhO/fCH0jp5bVYp2cMM2tVlEomNUshrTP3pSwQS2A1zyhseuKV+d3+A183
         njGjTCTc7Sw6rGyupEfH/N2kT02i3JaGSKpzP2PMWbFzbaU5Wj+mOVGAlegiNhTjpuN8
         eh+WJhobV2o8TeVm+5GNvWY/IZceK7XasS5NiIamNk/fe/HrS8d+ddNgDB4p8nM6OoNF
         YnEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691018089; x=1691622889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0W4hkYYGlPKafnFtIfHw3u5JfmMzy8zkW1KZ07xxWOU=;
        b=bGDsWkvVbKl/m+X14gr8BCnoNEv36bDykm/KsTIfZKKjygjc/SNR32ZDej4dOCYCi3
         VNI5mgCU05vsaKhSm1meAg1Hj4OjcoxvT8ne64HzxwWCW90gpV41/RctMf1tfWzmCpzA
         7UGQ7+apkH2O612hyyu3AfV1UvYXrqohH9fv5uvALX+OZVxaQsQg7JaWxt3pJEWjvzeG
         5ZYr15pFSovJl6OUxuiJvYR8n7c+vHRA96XDGdg3QJtELVku9ItzJthGpZpCZp9moAOu
         alIcve6z/qCS4uB3Gu9NbzgefKMKIvDi8mDtHgpQG/HStotdqVoF5OZ5A6Ga/9VHIrgD
         Z9lQ==
X-Gm-Message-State: ABy/qLbmfVzAY8C0cQvLeapf/2M334L26R9Qq/ZynET3m20v9iNNKF2f
        7903nCA/twwhl7iuv1CMKPMAs3qDqyMWF5mc7OY=
X-Google-Smtp-Source: APBJJlFWfqJks+puA+oYt8sz1mYxIZGLjje5JV/wWcHAEYiXtFO8HwA94nfQb5MYFeCA4JVXZG15yw==
X-Received: by 2002:a05:6a00:419a:b0:67d:308b:97ef with SMTP id ca26-20020a056a00419a00b0067d308b97efmr16742452pfb.2.1691018088830;
        Wed, 02 Aug 2023 16:14:48 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s6-20020aa78d46000000b006871859d9a1sm8588086pfe.7.2023.08.02.16.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 16:14:48 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] exit: abtract out should_wake helper for child_wait_callback()
Date:   Wed,  2 Aug 2023 17:14:38 -0600
Message-Id: <20230802231442.275558-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230802231442.275558-1-axboe@kernel.dk>
References: <20230802231442.275558-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

