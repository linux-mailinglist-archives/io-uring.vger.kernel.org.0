Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F50F777E23
	for <lists+io-uring@lfdr.de>; Thu, 10 Aug 2023 18:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbjHJQXz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Aug 2023 12:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbjHJQXx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Aug 2023 12:23:53 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFA2213F
        for <io-uring@vger.kernel.org>; Thu, 10 Aug 2023 09:23:51 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-790af3bfa5cso14087139f.1
        for <io-uring@vger.kernel.org>; Thu, 10 Aug 2023 09:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691684631; x=1692289431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iYBIDFS2cG7ajDUc70+r1XOh2p55BEGaXo35Fa744ik=;
        b=AOqr8NM/23o432Z8XK3tCFcG0gEXCYDjicmlb5TSIGQBgjqWp/IwD0tPqVRds5hMQK
         yvd/cCOyxWy2N8SqgEGSi4lxKjzFWaoNmDewoCh5Zio/8J4LzI3r94OUwft5Jiea7YsU
         oU5fCWLTKwWwsmhNXueGTJQhilzC4Pr5/KhyXf67f5ZdLVphuRRpRS2Rlgg8qnXWotds
         MT4QbH6uJBy9cSQ+38ae62VxSXs5plgVkMhETXEOZJ9EOvInUuLj6mDs5AzB7+HiGWZG
         El+ZMNal3NA2enpPJF1TGreXSVySXTheaJkGLB8vfyhLgwZIyAnx+AfiUhieg7lVbD6B
         KDkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691684631; x=1692289431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iYBIDFS2cG7ajDUc70+r1XOh2p55BEGaXo35Fa744ik=;
        b=jqfa3BkpQqUyFXWii+r5vXlBznDm0E7vz6dBxGfzLFx7hIKhCO0ve1JO+1KJvDY0FB
         SHaqfLibNtMpJ1olzdxwvSXerZ6vY6TuWHW9RlmYnp0ok6574C5pvnu4QSGwyUsRjzhc
         0w7WT0oPWx7TRfmVlKEeevmjsk/0K38PRubzCEfaPccYEWwivuhh6fSJvH4MJmUgHdAM
         GQmNvMYv79iAGQSuAF9HduDBhjJwm5F5ZZ7XZBZ5KDradqsRBSn7WS8nqsVMSHcDZ8pf
         jOEugkOnJrTEghLQFbic6PQ1dNXxstVgCXfAN2/4B12zcxPX+7i912rBoWhw6jrKtmTW
         0cuA==
X-Gm-Message-State: AOJu0YyFs41qUBpb88hL9ZepdoLtJYRoRbW9Hnl8gTbkoX6mA7uTiFWY
        F/wpVNRHxE9HG7SwWjMxKDcTKU+hZPor8P/4kx0=
X-Google-Smtp-Source: AGHT+IFEes5P2t5cJudItfWN/YUFnOmuwPdna+Bz/W3PlbQ03YIqOHCJmhr8p6ze0q68GQWu6GAJDQ==
X-Received: by 2002:a05:6602:81c:b0:788:2d78:813c with SMTP id z28-20020a056602081c00b007882d78813cmr3849008iow.0.1691684631181;
        Thu, 10 Aug 2023 09:23:51 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j5-20020a02cb05000000b0042ad887f705sm491941jap.143.2023.08.10.09.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 09:23:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/fdinfo: get rid of ref tryget
Date:   Thu, 10 Aug 2023 10:23:44 -0600
Message-Id: <20230810162346.54872-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230810162346.54872-1-axboe@kernel.dk>
References: <20230810162346.54872-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The caller holds a reference to the ring itself, so by definition
the ring cannot go away. There's no need to play games with tryget
for the reference, as we don't need an extra reference at all.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/fdinfo.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 76c279b13aee..300455b4bc12 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -46,9 +46,13 @@ static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
 	return 0;
 }
 
-static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
-					  struct seq_file *m)
+/*
+ * Caller holds a reference to the file already, we don't need to do
+ * anything else to get an extra reference.
+ */
+__cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 {
+	struct io_ring_ctx *ctx = f->private_data;
 	struct io_sq_data *sq = NULL;
 	struct io_overflow_cqe *ocqe;
 	struct io_rings *r = ctx->rings;
@@ -203,14 +207,4 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 
 	spin_unlock(&ctx->completion_lock);
 }
-
-__cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
-{
-	struct io_ring_ctx *ctx = f->private_data;
-
-	if (percpu_ref_tryget(&ctx->refs)) {
-		__io_uring_show_fdinfo(ctx, m);
-		percpu_ref_put(&ctx->refs);
-	}
-}
 #endif
-- 
2.40.1

