Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7EE54CEC1
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 18:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348606AbiFOQeb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 12:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356543AbiFOQe3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 12:34:29 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996312D1E5
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:27 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id x6-20020a1c7c06000000b003972dfca96cso1425376wmc.4
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ORixVfQAPkrUEdbPULkgFBU4hdADQl3LSugR9FT2k0U=;
        b=HvpG75mBDhy9kjQBf/6pqYSgY/ysh09pVsz0Y6iP4GPtBuzNrTBG37+8XrYPb2XbA5
         mGWMHaE94TP/CgDI4yn6bQMmWU6XRqagyZ1MSpVv1F+6rqh/KOKwxdPnRzc/yxzkmMTk
         7mVY+fkyA5FalFYIqGjoY/GgRHNQxdIvaZ1jWI3ndUanBleEhlY2vtHZKtbCSNdCdgJQ
         pEaX/EC6Mi//iH7qHjYxiLuOb2kaJgT3IPyVUFVYndZeyCGu9Hgnm37Mw6KqHBPfe1y2
         Z5h6a2GGDnjjNouBgdXpsGHYN2yTDcLorHUmmL9Sx7DUA0BUhGPJvV6WznpT1zt4BR31
         VmHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ORixVfQAPkrUEdbPULkgFBU4hdADQl3LSugR9FT2k0U=;
        b=Z+Brpcm8A0cX95cIS1HdPRT/9XuVdeXuKzaVzInpPamg8T8kKPoa5A3RS3P/XhIXF1
         nuZg/Rpr/MalA1km2/LBqpVmL0K+DBRNBb738FO7cVs9kAISHGoD4bFy+okeXH3TWQdv
         Tt4dz1JD+yZZ2oW/PuBQ3XcSEpRJv5526KPf1/XXgnxuqI0+cWjWsMZP8aajU6mw5Vrx
         TRuKHmea1DhYg1NfZlkoO2GhwyNH0WiPEuCUXA3suj9lEHagD1ItkKn5ZENi52njvpvT
         iEQnu1R8j6xbwXwr3PEmv6UNxE6+T21caSRyABzSQVuA7VQe9czU/Mv/GzVYU5g7WKp2
         JmKw==
X-Gm-Message-State: AOAM532tEzcnkLxh6U2/HGflPwk0dYqV+kgvnEytHn4aZ9fsS7lMbck7
        d78P50FK+f40U6WEUdLoETjmu729dKv3Ew==
X-Google-Smtp-Source: ABdhPJw2Gv3GCHZh8JyBXaUGEHqNnKBFcA/nW8dZrw+2zGgYbMB6Xv0M7ZrQn/uSUmQ+uZt4H6GEiw==
X-Received: by 2002:a05:600c:4e04:b0:39c:66bc:46d2 with SMTP id b4-20020a05600c4e0400b0039c66bc46d2mr10964450wmq.71.1655310865774;
        Wed, 15 Jun 2022 09:34:25 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a056000038200b0020ff3a2a925sm17894953wrf.63.2022.06.15.09.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:34:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 01/10] io_uring: make reg buf init consistent
Date:   Wed, 15 Jun 2022 17:33:47 +0100
Message-Id: <c5456aecf03d9627fbd6e65e100e2b5293a6151e.1655310733.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655310733.git.asml.silence@gmail.com>
References: <cover.1655310733.git.asml.silence@gmail.com>
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

