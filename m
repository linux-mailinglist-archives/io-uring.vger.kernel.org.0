Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05F854B382
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236475AbiFNOho (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238080AbiFNOhm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:42 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B75CE22
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:41 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id o8so11589460wro.3
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ORixVfQAPkrUEdbPULkgFBU4hdADQl3LSugR9FT2k0U=;
        b=qzWm0g5k1+Lp3SK0gLG+mGrPvOZWCa4HtZgLT9oN2eVm1W7ir3q9AwVT29ypOow4vn
         Mwsk45+VnZ/2Ow9I0fimSye+9FM8HumrJp3DaHEuz3EyMlXeBWzSnSoDdIbvVBjjl0I5
         hUHpNcbWdg0HunoNBsMeKNyhlQmOTd+ch3ZWj14IciCYELc8Z+D0hI1U/YmvkYPpLEVK
         DTgn+xdR39DK08E2Y3h7mE11jmmhxI904iGlamn6VAlR0zD75km+5HJfOPzbao3K0vDq
         vSYIsvZptmQjFPpPKaKdEhPIhNJOFTpVXgpEVsf/bYKv7a6kSZLu0EsPr7ritD0O416h
         9AEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ORixVfQAPkrUEdbPULkgFBU4hdADQl3LSugR9FT2k0U=;
        b=Ya7bmeds5P9gf4uLekWTs+2nyaLD8Y8Ra5MKJzx50r+8RcolpTTpXlRk0TP1glgpHL
         u4ZuVEsuVjVUg1H+iWjTwZdvWMsGvNYSm1TugfSGo0jVXHnT2vj3DSOXxX5GivXUZMVo
         xQe6l6CPfsvFtTWPvDLx29pOP8emifnaEzaJX4yAqv/kPttntsuJW2P7oyimSyh7+YJ0
         UUMmWo9gyZ5zTQZ3O5N8Y23KJO7LbCaVSC/rsC4S4kdko7UIFTE8DxN43UAW7GvIHBmi
         enp+Ih21KzrIPtEp/4u3gviQCG15X5cuGMznfbmz28xHvO4PRGzbJMKo/qh5w+G9dr3S
         LkbA==
X-Gm-Message-State: AJIora8KhG23MSpz5amuaOOlEpCZ19CbLUNCzfKLS6upQXlwSpbVZzD2
        4UvcZsn2EUxh99EaoCc5EwnEAPECj5t0OQ==
X-Google-Smtp-Source: AGRyM1vXyzScAKkIhSa37u2dY357/CDwB46xMHCFkAKy5GxIqyd2LZgJmGzeLB3R4HTIYGTis3NpVQ==
X-Received: by 2002:a05:6000:988:b0:219:cb95:79c4 with SMTP id by8-20020a056000098800b00219cb9579c4mr5299454wrb.587.1655217459589;
        Tue, 14 Jun 2022 07:37:39 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 01/25] io_uring: make reg buf init consistent
Date:   Tue, 14 Jun 2022 15:36:51 +0100
Message-Id: <1835f8612fd77ed79712f566778cad6691d41c06.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
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

The default (i.e. empty) state of register buffer is dummy_ubuf, so set
it to dummy on init instead of NULL.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index fef46972c327..fd1323482030 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -567,7 +567,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 				io_buffer_unmap(ctx, &imu);
 				break;
 			}
-			ctx->user_bufs[i] = NULL;
+			ctx->user_bufs[i] = ctx->dummy_ubuf;
 			needs_switch = true;
 		}
 
@@ -1200,14 +1200,11 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	size_t size;
 	int ret, nr_pages, i;
 
-	if (!iov->iov_base) {
-		*pimu = ctx->dummy_ubuf;
+	*pimu = ctx->dummy_ubuf;
+	if (!iov->iov_base)
 		return 0;
-	}
 
-	*pimu = NULL;
 	ret = -ENOMEM;
-
 	pages = io_pin_pages((unsigned long) iov->iov_base, iov->iov_len,
 				&nr_pages);
 	if (IS_ERR(pages)) {
-- 
2.36.1

