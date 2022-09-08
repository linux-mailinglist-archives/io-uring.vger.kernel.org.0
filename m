Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3695C5B22EB
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 17:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiIHP7D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 11:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiIHP7C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 11:59:02 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26E2BE4F0
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 08:59:01 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z21so15031332edi.1
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 08:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=nr75665rJFL8Ua9ObjrNRpWClJ7LBHcrJfr1KI7QgOk=;
        b=DpswcvcQCna07+V8SeOEGFHTO+V3uX4j8HzOMRGehlaAvtEQyEUKNL0vhiTVxbXdwT
         lX3p4pSdVmhB8UUr07QT84oZDGKF1B/CYcuT6NsnR+/d/+khpnp6LGOomn0oqE+lLIhF
         fpYei9bWrBDmCKhnXLnU/kGSYtz4LDWHV/NKzX7sWDSaP896wdNCpaTiAVTtHSPJjcO6
         x+TjJfWvcsi+8vcpEH2tD5OtIA+4FiUbMQvC7GJJhCSVh34X4Qz0O5v2BkANOEGZhoLP
         2f3L+YenPhYQxAkis0ycYm19InUqZ2yEDtD5AqTi5OROFfH4od0N4E7SWgPXs+V2lrTq
         QrVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=nr75665rJFL8Ua9ObjrNRpWClJ7LBHcrJfr1KI7QgOk=;
        b=JUy5Gj2d82zCAh7IyN+X/wxwgOzmG36bvwCn2jS8oB7AYL8rV1cGKttSbuJ18J/Vwl
         0SfaDPNaPiACQZLQtV6xwEGNR/eyFvN/hP4HTAyGa4gxMkZLRvbvwWELwsuFe7Qsra/D
         E47rLuDQ+dUqhHUxVxO2LreIkZLEazhv8kzhNs/fyt2FX7ZexR3Lu99kuRUQZKrc3a+7
         OUuaO66Jd38HQ8zvMopCmbGgxeS9BSBXoOy0HNyciU3JiUojLiTDP8zxjYFiAeUe3q3z
         xvYGeMLKfAymIavIwtF0UxDXSYEl6zIrcm8YzLv4Gm1aPTXhE1Drv4g7qRg8bFMRUNql
         +qIg==
X-Gm-Message-State: ACgBeo0oruIJ1mjW0fMoV/fKB7kwoE39FUHvvrYXU96xn2DcXnI4Xg6u
        PjJisOVMRDhLuxj/AMlFbg0zPfxb000=
X-Google-Smtp-Source: AA6agR5tPKIsTcCVCSEGaNxoRqSQ4p6NG7v2exfVrXx8ub5RkE/AsH6KALf2KYIHeKA1J7Rjv9u75A==
X-Received: by 2002:a05:6402:510e:b0:448:9d4b:c760 with SMTP id m14-20020a056402510e00b004489d4bc760mr7831528edd.156.1662652739897;
        Thu, 08 Sep 2022 08:58:59 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id q26-20020a1709060e5a00b0073872f367cesm1392503eji.112.2022.09.08.08.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:58:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 1/6] io_uring: further limit non-owner defer-tw cq waiting
Date:   Thu,  8 Sep 2022 16:56:52 +0100
Message-Id: <94c83c0a7fe468260ee2ec31bdb0095d6e874ba2.1662652536.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662652536.git.asml.silence@gmail.com>
References: <cover.1662652536.git.asml.silence@gmail.com>
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

In case of DEFER_TASK_WORK we try to restrict waiters to only one task,
which is also the only submitter; however, we don't do it reliably,
which might be very confusing and backfire in the future. E.g. we
currently allow multiple tasks in io_iopoll_check().

Fixes: dacbb30102689 ("io_uring: add IORING_SETUP_DEFER_TASKRUN")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  6 ++++++
 io_uring/io_uring.h | 11 +++++++++++
 2 files changed, 17 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0482087b7c64..dc6f64ecd926 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1398,6 +1398,9 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 	int ret = 0;
 	unsigned long check_cq;
 
+	if (!io_allowed_run_tw(ctx))
+		return -EEXIST;
+
 	check_cq = READ_ONCE(ctx->check_cq);
 	if (unlikely(check_cq)) {
 		if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
@@ -2386,6 +2389,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	ktime_t timeout = KTIME_MAX;
 	int ret;
 
+	if (!io_allowed_run_tw(ctx))
+		return -EEXIST;
+
 	do {
 		/* always run at least 1 task work to process local work */
 		ret = io_run_task_work_ctx(ctx);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 9d89425292b7..4eea0836170e 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -329,4 +329,15 @@ static inline struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 	return container_of(node, struct io_kiocb, comp_list);
 }
 
+static inline bool io_allowed_run_tw(struct io_ring_ctx *ctx)
+{
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+		return true;
+	if (unlikely(ctx->submitter_task != current)) {
+		/* maybe this is before any submissions */
+		return !ctx->submitter_task;
+	}
+	return true;
+}
+
 #endif
-- 
2.37.2

