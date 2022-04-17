Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF08504755
	for <lists+io-uring@lfdr.de>; Sun, 17 Apr 2022 11:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbiDQJMh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 05:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbiDQJMh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 05:12:37 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD24328E1E
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 02:10:01 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id k23so22333755ejd.3
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 02:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WF0bsr2cAMuZyRE0ehmqwvGMdxmbVv0vamWqpGLfem4=;
        b=csU81K1LbLLQKFQklu6jLwsRHSkFp7AWqsY1te1v28t8/uUtr/M8TNEHx1p0LVOJ8t
         v59J75QDntWR1FTwfS5VrtqLr/sITSilHOwxBOrMicaLTmZKS7+1OWQQnIsM8zoaHuJJ
         YhynwBj8RqLm34nISVKARpzAMCW1RFezrcBattpSjBgIq5T2CAq3egCDq3+HkRwh0OYk
         9uXazopAZuNdR2oYIQ5tiL3F7G9F7rRexiVIyZFbh6BUHIqozs2KdheAYfIUj+Wi8/D8
         b6F4uUjRX8W/3mKd+OBxf3tm/jFOk1JyKG8Requkzjwq3EmsYypiWEZN/+fv03rLSQ9H
         A24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WF0bsr2cAMuZyRE0ehmqwvGMdxmbVv0vamWqpGLfem4=;
        b=ntR+7XWPafhrLRx8NKLxCJw63XBjQ7MblAj5W5dVL62QHbiG7gRxdKPbxDj8pNAH76
         h5rtcv8g5gGaT5AOBRkHitqMU9fddsEe5K+Pgf9mvWVSa2xWSeO89OZR/u7wykJ4hYV1
         4SayJUi7nXRX/JYWKe9lRF38CQA5mxeEeosqdVaTJ5lJSyHTMB6yK42aaG5X7U53Z7VQ
         XDdtOjUSJQaIk+o3kXr+XRysqVa+lOycIbAcspXOmWun7We8ZrjbTVzf2oZXsG+u1eUB
         Ee31K7Fx2T8VGPCzLZ7tlWuRgX2lhgyEoZrncu30NcQa6yM3IP7QZ8luZti/dKHCWYKH
         E38A==
X-Gm-Message-State: AOAM531Wu3wCuKmvthbcZsB+gg4cxn97zNj7cvG9TvrtNX4jbDx4AtIv
        l3f6qaJ3+D013ML9d71HBO3v8aag5XU=
X-Google-Smtp-Source: ABdhPJztwRHiQJUZLN4FObgCKQbVouCS//46AOFVxYElCugdM1WOgov3OJJgSxXis2LPbHS5mW4WQg==
X-Received: by 2002:a17:907:961a:b0:6ef:568a:21e2 with SMTP id gb26-20020a170907961a00b006ef568a21e2mr5029885ejc.182.1650186600162;
        Sun, 17 Apr 2022 02:10:00 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id bw3-20020a170906c1c300b006e88cdfbc32sm3423746ejb.45.2022.04.17.02.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 02:09:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/3] tests: reduce multicqe_drain waiting time
Date:   Sun, 17 Apr 2022 10:09:23 +0100
Message-Id: <5f2ddf9fb44d4b746c12654dad649db1470c2748.1650186365.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650186365.git.asml.silence@gmail.com>
References: <cover.1650186365.git.asml.silence@gmail.com>
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

sleep(4) is too long and not needed, wait just for one second, should be
good enough.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/multicqes_drain.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/multicqes_drain.c b/test/multicqes_drain.c
index ff6fa7d..b16dc52 100644
--- a/test/multicqes_drain.c
+++ b/test/multicqes_drain.c
@@ -224,7 +224,7 @@ static int test_generic_drain(struct io_uring *ring)
 		goto err;
 	}
 
-	sleep(4);
+	sleep(1);
 	// TODO: randomize event triggerring order
 	for (i = 0; i < max_entry; i++) {
 		if (si[i].op != multi && si[i].op != single)
@@ -233,7 +233,7 @@ static int test_generic_drain(struct io_uring *ring)
 		if (trigger_event(pipes[i]))
 			goto err;
 	}
-	sleep(5);
+	sleep(1);
 	i = 0;
 	while (!io_uring_peek_cqe(ring, &cqe)) {
 		cqe_data[i] = cqe->user_data;
-- 
2.35.2

