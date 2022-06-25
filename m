Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9599955A915
	for <lists+io-uring@lfdr.de>; Sat, 25 Jun 2022 12:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbiFYKxa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jun 2022 06:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbiFYKx3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jun 2022 06:53:29 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D7B183A2
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 03:53:28 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id f190so2317153wma.5
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 03:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k++j3jMCmembuoHqzW2/+fFXcAGOMbv7QAh6X6Q/plI=;
        b=EKBHbL2sqARHtkKWkBgE/6FuqGinJzOO+V2A69Kqggicie8T+PdfZIQEb+iHUrvjGs
         fOJIiVAeOg5zdMzpWgsq+dWRrqW1Vq1IOWkHjf/HoVMRFVLQ1ccV4sLY5DZyNSKY3Ros
         vz2i8y4WYRXSmcT0ggZzamMS4Vq4i5iUQ9i+HPYs4/bCAfNZmhYVHjTrGKro72eI5+N9
         Stku7G1EAkFli7VoyfwAuJUPdafiCiWabCHR+sU9fZvFaB6Ui9HZBKjXEgGLctoS8eT0
         MmQi2bNXT3AC0igd3gtC8Gu8m2eIQemm2rWk0JSAzIaBRHywT6XLbLhXB3gRE3389cG7
         CBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k++j3jMCmembuoHqzW2/+fFXcAGOMbv7QAh6X6Q/plI=;
        b=0KO3+P/lNDdc7knn+1Sbi/HvYR8lLoYTx+VUyBDC7SPRwg8Th8TJNDVU7z/KCm/b9x
         QmhnTwts+1wJIMlrgpiHPjJaVWbIYs9QzftaGQsijmZFeVyAJDRMVHNLyRAbtBUF9gEA
         1otD41da9aGl6sPYo8NXaHrKQ18a9GKIqEiLXHT2lLSjsLJ129hZsVj/acL6KRS0d9oS
         5143vMmdXa6mAvKRk9CxEcH52L9+qHql7lx10vWBbE01YwTwA/0ZwMcu4qAPei1eL7us
         sf32Ozz2dwwsgjtGme1yoby1AuddvyqqOFIbyshvnlWblhJMWiOAL1kb3Zaxo0Mz2Wee
         Bn+g==
X-Gm-Message-State: AJIora/WaEwSQR7/sFKR3MKISECjKKZTM48xx2bmv0TFt9Q3ImbAW+Lw
        M2oQwZMEc9hRlM6sVmeLJsWKDDXcw0aHCw==
X-Google-Smtp-Source: AGRyM1vk17GcpyhQoAWgUglYUEvLYnf+erOVVN9e1uBT/vLmHMysnA2jiouKKnnE7JJqr0kmWkF5Gw==
X-Received: by 2002:a7b:c921:0:b0:3a0:41c3:f44a with SMTP id h1-20020a7bc921000000b003a041c3f44amr2344078wml.122.1656154407088;
        Sat, 25 Jun 2022 03:53:27 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id m17-20020a05600c3b1100b0039c5497deccsm15810144wms.1.2022.06.25.03.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 03:53:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/5] io_uring: remove extra TIF_NOTIFY_SIGNAL check
Date:   Sat, 25 Jun 2022 11:53:00 +0100
Message-Id: <52ce41a592ad904511697f432141e5690fd4b968.1656153285.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656153285.git.asml.silence@gmail.com>
References: <cover.1656153285.git.asml.silence@gmail.com>
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

io_run_task_work() accounts for TIF_NOTIFY_SIGNAL, so no need to have an
second check in io_run_task_work_sig().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 86a0b0c6f5bf..f40526426db8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2205,8 +2205,6 @@ int io_run_task_work_sig(void)
 {
 	if (io_run_task_work())
 		return 1;
-	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
-		return -ERESTARTSYS;
 	if (task_sigpending(current))
 		return -EINTR;
 	return 0;
-- 
2.36.1

