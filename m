Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDF4779195
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 16:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbjHKOQb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 10:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233485AbjHKOQa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 10:16:30 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B843E65
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 07:16:30 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-686f74a8992so348959b3a.1
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 07:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691763390; x=1692368190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0W4hkYYGlPKafnFtIfHw3u5JfmMzy8zkW1KZ07xxWOU=;
        b=KzQycaVbeQFqn6gTdLfSsgzYGwAkhqL6P3muxw2AlRiyuWbnNPG8OuNJ/N0p6RPBUc
         fuIkGlIMxfVAsZ505aZKk+mLHx4KhxGZQ5AdYJqQ2MnuQL3oJZ6ILW3TRl+uUH6vhtOJ
         wPcvXOp/Bi5hwk6simuX6VR0kBwYBAt6Cqos2/VeKV6N4OXymfd3kHtP5QcP003+Pwcs
         Z6oGoKjL4NQZqXadRpaTOsnO0dZfcAH58YrOSWdIUEqY+Ba5yRH1Q2BsUAIu1CV+l2W+
         QMOcOzTC7K9nGnxDbB3LtBDOznBzg6+wrSYlZMZDEpi3qmKsu1C4ts3UI8nGvkNM61Bp
         FASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691763390; x=1692368190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0W4hkYYGlPKafnFtIfHw3u5JfmMzy8zkW1KZ07xxWOU=;
        b=Vhegp7Bm6YlJEW+On9QkUX8/8L3ms4B1jvugB4s7S/kTmbs1s6q6G9IhVXj9JQg5Sv
         RamcgCqis/ft/tcnb6NQkKw1pnxTbsX3a2EijoyBtdvfsExBr347F/ZaLBJoBN9YdpzJ
         mxcbFqs7eXKqTxOEIqhz4R+g6MIUd8PpFsqpGLF/kqIhihNjjdcQYESNrYl+QAMoO37v
         IeKHKRrRqIxOPpTc2FkQsj9MS3/Sw5lNbxcIXiemYplS5DwZiXDbJq4Jcbbr+yKGdsKE
         GGd50o3wRRzksAIPiTYfI8HHgUYLdIFSHf7A5VuSscSDZKQgagOEf0C41u11JE2VRR42
         1oiQ==
X-Gm-Message-State: AOJu0YyHt29mW4bFEpSqLKNYudOm8qKZ5H1pyoymdpZ0BBTEX/KLrS1l
        siVb1GOFfsLBgrXHKWVMA9s3uj62wnvMGck1gGQ=
X-Google-Smtp-Source: AGHT+IHSkv0PL2a1sVUwPWXe1LW0hXCkpajSBnP11X8doEP7Ry3d69QTmEVWK60/q90RfYEy3kdIlg==
X-Received: by 2002:a05:6a00:4986:b0:67d:308b:97ef with SMTP id dn6-20020a056a00498600b0067d308b97efmr2489718pfb.2.1691763389670;
        Fri, 11 Aug 2023 07:16:29 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s21-20020a639255000000b00564ca424f79sm3422311pgn.48.2023.08.11.07.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 07:16:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] exit: abstract out should_wake helper for child_wait_callback()
Date:   Fri, 11 Aug 2023 08:16:22 -0600
Message-Id: <20230811141626.161210-2-axboe@kernel.dk>
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

