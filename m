Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C93D65E9BA
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 12:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbjAELXp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Jan 2023 06:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbjAELXd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Jan 2023 06:23:33 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D705F559C5
        for <io-uring@vger.kernel.org>; Thu,  5 Jan 2023 03:23:30 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id g10so13981296wmo.1
        for <io-uring@vger.kernel.org>; Thu, 05 Jan 2023 03:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xtm4V31HUmHjoi9kdkK6HkEdkWruS4iTPrxd+tvk8sA=;
        b=MfVjbD7fZpTrDIYFeERq0mEPEDiyKPYJC1ctKuXtXQRQ+qvBOfb24fhOb9X+1GaWIy
         sHPlOq+VcRZ5krz8a6nrZzK9+7B3pAalZhZGd2PFxvWrtzYCvFi6CC1+vFD8rF3Bw42T
         VIYfYSHhPyiOV0fhDQEFx4zPYgmAZs8Z235Cjy94Mr5smrTU8lXUThsOTSJAxBSyp2sA
         dUarXfRwaURCwyib2GMCilTQe8MS/TOQ6G60PWuuunGQPzxThrGaK20djIzWirpziakY
         xmiXcJzquKOdgWOzatd5RKA0JS68IxcRiD9BrG9ZigC6St7a4Z+7K3RTPanD+XjYaHsc
         bZWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xtm4V31HUmHjoi9kdkK6HkEdkWruS4iTPrxd+tvk8sA=;
        b=T0Q1HaFBpHGBZY4zmk+qB//+aUMD3GT3EHd+jmzUONkq7scC6RI5qqPn3fyxs5eLGQ
         kOLxqBTpn5p0WgrcZd/gejHD+oTz7wtDJx6XMMDhg/1f/LlvB2B7eC+mGEjtNIhfiWex
         /5u3NiUdRPVT7R56rSqXTrCZYCAqgpyHsPA78qABzju9t2emo1N832fhVumvrF826rOe
         4PHcQHVWFYm+zwvjFMZVvtLZb0drJ6lacFfWJUkt7Ggb35XVjAyZzELRTydhlm5YVn1i
         Gl4f1BqoUkUJS6EH774cXzd+6MFViiU1y4fAX94KwIulrLFdRBbcmYb0XOb3ZiAY9xbM
         +PyQ==
X-Gm-Message-State: AFqh2koVe36ekjMGMRIo0erR6L8ODyvR/dYzVrvMTJnqc9tBMSWWTkpb
        CElg5p6tDiPTZPyM73LiBkxDH3W3TMw=
X-Google-Smtp-Source: AMrXdXv+tiOWK0cJbN1d1NEaEQSJAG1vy0Fmo3NKecTpKYrYipekoqPLnKVVKDhLCzTBvTP4OaHFcQ==
X-Received: by 2002:a05:600c:c8a:b0:3d9:7062:e0b7 with SMTP id fj10-20020a05600c0c8a00b003d97062e0b7mr30233810wmb.33.1672917809058;
        Thu, 05 Jan 2023 03:23:29 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:5c5f])
        by smtp.gmail.com with ESMTPSA id u13-20020a05600c19cd00b003c6f1732f65sm2220688wmq.38.2023.01.05.03.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 03:23:28 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCHSET REBASE 01/10] io_uring: rearrange defer list checks
Date:   Thu,  5 Jan 2023 11:22:20 +0000
Message-Id: <331d63fd15ca79b35b95c82a82d9246110686392.1672916894.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672916894.git.asml.silence@gmail.com>
References: <cover.1672916894.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There should be nothing in the ->work_llist for non DEFER_TASKRUN rings,
so we can skip flag checks and test the list emptiness directly. Also
move it out of io_run_local_work() for inlining.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 3 ---
 io_uring/io_uring.h | 2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fefffb02e6b0..cddfcfddcb52 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1338,9 +1338,6 @@ int io_run_local_work(struct io_ring_ctx *ctx)
 	bool locked;
 	int ret;
 
-	if (llist_empty(&ctx->work_llist))
-		return 0;
-
 	__set_current_state(TASK_RUNNING);
 	locked = mutex_trylock(&ctx->uring_lock);
 	ret = __io_run_local_work(ctx, &locked);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e9f0d41ebb99..46c0f765a77a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -274,7 +274,7 @@ static inline int io_run_task_work_ctx(struct io_ring_ctx *ctx)
 	int ret = 0;
 	int ret2;
 
-	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+	if (!llist_empty(&ctx->work_llist))
 		ret = io_run_local_work(ctx);
 
 	/* want to run this after in case more is added */
-- 
2.38.1

