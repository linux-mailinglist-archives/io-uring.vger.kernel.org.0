Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D474E4039
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 15:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234849AbiCVOKk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 10:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbiCVOKj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 10:10:39 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43A15DE6E
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 07:09:11 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id p184-20020a1c29c1000000b0037f76d8b484so1872387wmp.5
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 07:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0eurFXS9X4YlZxA1c+DHt8WRFuRRFcm0WU7OEUB0uNI=;
        b=j6lW3lEAKXfjf1c+02fFHaevJYcbuKhYzP4Xxv8npwGMkEW2jNh9OcyDsd/maS/MkE
         q33/bCHcRaCF8IGfSqFHIzMWD7BKrvDflqjTWRBg/XJrH6xF/XJXRg+5anMPH5ksNCV7
         lUYNPkWWIyzmzmmBV8wvNHf+syUxGQcBdVHyzvyDkFSRnPW2UQoSb9otTsDMYYuPLUdT
         Xk/j5qvJ0PEgNhlPCxjbZ1yhQHk+xaHD2aWsXY9+elMTPq5nM8igie871BFMRqQ5+J/J
         xkHvCwSv29TSlPSttqy+/LU6dDzfkrCzorL6yJvIMDh42bkDR6CJPnuRVttnQTtvULLI
         2OTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0eurFXS9X4YlZxA1c+DHt8WRFuRRFcm0WU7OEUB0uNI=;
        b=qAQ/9au4l037g72WesBcU7sG03wCKMzw8IX74RFuYhsxrcsljNPAHNgK6DFEdGejfq
         NKtmmh0at+BlS4ABqzs+9pXelOjcCmUdykbZiG3IxT/nCRUD1pyf6dd7qw8ZWWE5ss5p
         CSynCz14iFV0zL4tq1zf3VtOayaUrKIZXGMKwNZR31n92EcnOekYouxc4z8qR34Cc5l2
         Q22WVONDM6d99JiF1jO95BeVIsWaqKhcacrEysg7KtWNqIsZtxxtw/mj2u+b/Yi+w33P
         Bf7/JnOghNDupqXIR6A5BQ6h1nTr8VawCTO7b9IdsB/OenDCDu5qun0utYria5cy6bUj
         qONg==
X-Gm-Message-State: AOAM533kiPK/Uj4QW1buHyWLwCKjxVsrSYtcOXiNu/a/s1wlnIgmtMAt
        CwnPq5ZRWSj39avZNP9v3i0xZvb5fynNJA==
X-Google-Smtp-Source: ABdhPJxMHyaPBV+Xt6+qNt9pukFBFyjh/DM/sRHX5pWpftMVdAZXbayl87Vubnm8toMJRetaJrBzKQ==
X-Received: by 2002:adf:e10e:0:b0:1f1:d9e2:a9d8 with SMTP id t14-20020adfe10e000000b001f1d9e2a9d8mr22588088wrz.708.1647958150137;
        Tue, 22 Mar 2022 07:09:10 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-32.dab.02.net. [82.132.222.32])
        by smtp.gmail.com with ESMTPSA id m3-20020a5d64a3000000b00203ed35b0aesm21987733wrp.108.2022.03.22.07.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 07:09:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/3] io_uring: split off IOPOLL argument verifiction
Date:   Tue, 22 Mar 2022 14:07:56 +0000
Message-Id: <71b23fca412e3374b74be7711cfd42a3d9d5dfe0.1647957378.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647957378.git.asml.silence@gmail.com>
References: <cover.1647957378.git.asml.silence@gmail.com>
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

IOPOLL doesn't use additional arguments like sigsets, but it still
needs some basic verification, which is currently done by
io_get_ext_arg(). This patch adds a separate function for the IOPOLL
path, which is a bit simpler and doesn't do extra. This prepares us for
further patches, which would have hurt inlining in the hot path otherwise.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9baa120a96f9..8d29ef2e552a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10810,6 +10810,19 @@ static int io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 	return 0;
 }
 
+static int io_validate_ext_arg(unsigned flags, const void __user *argp, size_t argsz)
+{
+	if (flags & IORING_ENTER_EXT_ARG) {
+		struct io_uring_getevents_arg arg;
+
+		if (argsz != sizeof(arg))
+			return -EINVAL;
+		if (copy_from_user(&arg, argp, sizeof(arg)))
+			return -EFAULT;
+	}
+	return 0;
+}
+
 static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz,
 			  struct __kernel_timespec __user **ts,
 			  const sigset_t __user **sig)
@@ -10921,13 +10934,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			goto out;
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
-		const sigset_t __user *sig;
-		struct __kernel_timespec __user *ts;
-
-		ret = io_get_ext_arg(flags, argp, &argsz, &ts, &sig);
-		if (unlikely(ret))
-			goto out;
-
 		min_complete = min(min_complete, ctx->cq_entries);
 
 		/*
@@ -10938,8 +10944,17 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		 */
 		if (ctx->flags & IORING_SETUP_IOPOLL &&
 		    !(ctx->flags & IORING_SETUP_SQPOLL)) {
+			ret = io_validate_ext_arg(flags, argp, argsz);
+			if (unlikely(ret))
+				goto out;
 			ret = io_iopoll_check(ctx, min_complete);
 		} else {
+			const sigset_t __user *sig;
+			struct __kernel_timespec __user *ts;
+
+			ret = io_get_ext_arg(flags, argp, &argsz, &ts, &sig);
+			if (unlikely(ret))
+				goto out;
 			ret = io_cqring_wait(ctx, min_complete, sig, argsz, ts);
 		}
 	}
-- 
2.35.1

