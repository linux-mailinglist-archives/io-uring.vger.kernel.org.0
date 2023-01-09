Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F473662900
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 15:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbjAIOvY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 09:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbjAIOvB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 09:51:01 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39223E0F3
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 06:47:27 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id u9so20765610ejo.0
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 06:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g0YL0CbM08Co0Kl3ZAc24/DI1DzRJeHVzkmvnIupDg8=;
        b=Zu0i+qW4S7SD8ORjsK69ZLS6AM/JikIphqfsk0/IR9K1XNH07Ru23Eu/1D7c56P3Dw
         +J85y5h7+VbiIp4UanPfuzuXACBV0HM+hQrzZ+NhlZcscTg64Ae/Z6wziNjIdChRhM8P
         FpXnvunRlYxuHUT6UIyS1uOgxWsNRFLpwFlLl54aTITyJTGSEdy1w9czRhe4QraNyLeL
         z7Xy+2Ndl+Dj3ipktxxEUoJgWWfjE3LurLv/3BhlweaZJOB785qF6vLY8DaddTtBu6Yz
         cPsUNnSd0ThIqlSU8eMbSvJmPauXQSDggBWbG3n6Kczv62Ql533cW8DkXgUryAjZ/CA4
         Jksg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g0YL0CbM08Co0Kl3ZAc24/DI1DzRJeHVzkmvnIupDg8=;
        b=W79VFsVqQe+iMtoqK5nDSgEvydNoMP3f1YfY3gnBvUN+QhBcj4lG32Zqno5MzgJY+s
         NUat6JtBA28dd2KAj0wwSRRWvRhR9EhRi018OaLHRztwmiPdaEIWeIN2bZ+PayttbnlA
         iXkyuZSP9Mwmu+WnGauRDPrkJWxOu1Howv8cvcLExFfBEYZ78kBM6vyfwWMamVB3+HVz
         dF7U+SC6SrWD2/IKRZQ60hBKgGCcHuHPvZhhAAvC52comphrz0mJqTUiotiQReYifzCz
         eqlao6biSSuQH8gHXu+ftJQCqBEACDEcPVBZW4LdetsbAiPdYTk4X1Luh5HrBt2c+FWJ
         CVaQ==
X-Gm-Message-State: AFqh2kpz/jrL+bJMT1tFjJgWkH6rj2Dx1mWLtydQSI4WZbW9pSy8+kaP
        BEv/IxUNAkXRokAurctKDop8TOwEMaE=
X-Google-Smtp-Source: AMrXdXsCYIf3HgiI2be2VbABBDbEsaNLdHX8u4VPdAlejXJZmO6/Oiro8tTQgmma6O9Ae0Lox7qhNw==
X-Received: by 2002:a17:907:b026:b0:7c0:e7a8:bc41 with SMTP id fu38-20020a170907b02600b007c0e7a8bc41mr49948833ejc.74.1673275646313;
        Mon, 09 Jan 2023 06:47:26 -0800 (PST)
Received: from 127.0.0.1localhost (188.29.102.7.threembb.co.uk. [188.29.102.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a170906b08b00b0084c62b7b7d8sm3839578ejy.187.2023.01.09.06.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 06:47:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v3 02/11] io_uring: refactor io_wake_function
Date:   Mon,  9 Jan 2023 14:46:04 +0000
Message-Id: <e60eb1008aebe286aab7d34c772ed01c447bddb1.1673274244.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1673274244.git.asml.silence@gmail.com>
References: <cover.1673274244.git.asml.silence@gmail.com>
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

Remove a local variable ctx in io_wake_function(), we don't need it if
io_should_wake() triggers it to wake up.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 89dd2827a977..157e6ef6da7c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2441,15 +2441,13 @@ static inline bool io_should_wake(struct io_wait_queue *iowq)
 static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 			    int wake_flags, void *key)
 {
-	struct io_wait_queue *iowq = container_of(curr, struct io_wait_queue,
-							wq);
-	struct io_ring_ctx *ctx = iowq->ctx;
+	struct io_wait_queue *iowq = container_of(curr, struct io_wait_queue, wq);
 
 	/*
 	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
 	 * the task, and the next invocation will do it.
 	 */
-	if (io_should_wake(iowq) || io_has_work(ctx))
+	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
 		return autoremove_wake_function(curr, mode, wake_flags, key);
 	return -1;
 }
-- 
2.38.1

