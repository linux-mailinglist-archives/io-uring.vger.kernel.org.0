Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E86C552DFC
	for <lists+io-uring@lfdr.de>; Tue, 21 Jun 2022 11:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348475AbiFUJKb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 05:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347543AbiFUJK3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 05:10:29 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305F19FEE
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 02:10:28 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id es26so16751344edb.4
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 02:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2+/IQbvGcCO4lowWT+mbffBPXgLbyfXTC8rtYBdsV74=;
        b=fOQGrOTUFOKi+cBGrlvZlx8DS48N0LGywfd7V8FV9w0DQ/7h4INSitiTRDFAzH7OAC
         IYiiURQVlFZBvnyM8Z9hxz3b759/lapGMEflNdZmhzPeZ03gzDji7EQCdqYmRLeBIKZT
         b+KDimIGdZrxU3LUKstWbJJ1eTyS7BC8dumf7xaT1sJ2Wz8aURA5XBeMlUkUFXZ+SB9i
         b6f/Ab3dWpepqmq37wgbLDqVNJNZ9yodQ3AaIhNedHeOtQTSqqFkjrv9262ewJU8xz/o
         cWyygfuwUxFH1KZc6OROMj3eVzJdmPpGLsZ7opiK6Ktf7u9vVaRdLjghh7bBWZV7E82z
         easw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2+/IQbvGcCO4lowWT+mbffBPXgLbyfXTC8rtYBdsV74=;
        b=Zz7UYfNkFvDVx1kHA0KmBjOJta4FMId9HEg9k0d1TSfei5WbRwkXOcxYudsss7ACLF
         C2YRbqOlw9dVhzxIwYJkyW5Wedh/IAcptxgVyFG9TEeaPtz5jqEu9qzptMy62KeI15V0
         SgShfO/q2bIdk9sb+SuK47djhxYjOoEA0yfOdPHSD3pvWdbh1Fm+JW4q2fvkog77mqAt
         ok1HTt3LiRMOzn5gfxdO7EK+5akZNauVg5bxCLsEAI5/EE9A3YCtd7SnxV9JMI1q6SbV
         tXUpXSZsULAN6wxCieetG2GUwtOwNgcP1udaTLoxAJMcCMfgr6BfkHKuFK3282IkCveB
         8Rhw==
X-Gm-Message-State: AJIora/sSKnc7wTHRQO31BkEiLOgRrEs3+twm/KR4CY6uS0K2Ieots6D
        1A9OdmATNBlGE+PgjY8q6qqYWoJWEqh2/A==
X-Google-Smtp-Source: AGRyM1uhr926JpOUkUOfqQ2fuwvdjupMfesIOMkBIjA1EvtsdMvTDQpwwNqlT3xCUen1V9VMAUwckw==
X-Received: by 2002:a05:6402:3514:b0:42f:dd01:922 with SMTP id b20-20020a056402351400b0042fdd010922mr34562557edd.324.1655802626458;
        Tue, 21 Jun 2022 02:10:26 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:d61a])
        by smtp.gmail.com with ESMTPSA id cq18-20020a056402221200b00435651c4a01sm9194420edb.56.2022.06.21.02.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 02:10:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/4] io_uring: improve io_run_task_work()
Date:   Tue, 21 Jun 2022 10:09:00 +0100
Message-Id: <75d4f34b0c671075892821a409e28da6cb1d64fe.1655802465.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655802465.git.asml.silence@gmail.com>
References: <cover.1655802465.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since SQPOLL now uses TWA_SIGNAL_NO_IPI, there won't be task work items
without TIF_NOTIFY_SIGNAL. Simplify io_run_task_work() by removing
task->task_works check. Even though looks it doesn't cause extra cache
bouncing, it's still nice to not touch it an extra time when it might be
not cached.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 7a00bbe85d35..4c4d38ffc5ec 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -203,7 +203,7 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 
 static inline bool io_run_task_work(void)
 {
-	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || task_work_pending(current)) {
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL)) {
 		__set_current_state(TASK_RUNNING);
 		clear_notify_signal();
 		if (task_work_pending(current))
-- 
2.36.1

