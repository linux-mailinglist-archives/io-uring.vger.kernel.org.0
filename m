Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DDF51E7A9
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 16:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbiEGOKN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 10:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446503AbiEGOKH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 10:10:07 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DFB3BBFF;
        Sat,  7 May 2022 07:06:21 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so13219373pjb.5;
        Sat, 07 May 2022 07:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LghMChCA6247tbh6MDRf5RHBI49qXWAjYTUP73PzTY0=;
        b=PMlb+b+z8EtTJiEGG9q1zWLnr/nPpBRSLUNGlHHkCLmreKVI5kYqZ6kwkRtmIAeEiW
         N6J5RHWX7sFaCNau4/O7yu6tn5azWEnaR8i+3XRLlLaXI1KWg+fUQufV38PKSMvD4hKX
         Iv+bx5WDcHnXpHOLnvZyjR4Hde8UaYkpx/ROlQEHNfUXO2IcKIRF+/HVO3bsJN0VicT6
         9quw+zjeN7+nCpQmXDS6XBlVwTnSJtoaJlS8zXbvJNMmnalc5yVFh8AdAF+O4iGEW2BS
         Qya6zmJagZSIRjcMVaoUAIGNIgxl86gigWR3a+4VN3NQIgyy5NCwnszGBxqc3g+mTROd
         LQGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LghMChCA6247tbh6MDRf5RHBI49qXWAjYTUP73PzTY0=;
        b=qakSemx06PjUCy+c1+GPCAzcfnyurIuZS465gYtkOoJiHfpzRRTMaEHwfPTA0uFwpZ
         64IUUMRq/p9XltRWbOsrgi2yqZBYoxXv7X3jcVxu6yH57uOu4T4cNV5UD3KqtQU/A9DE
         Nofc0YAN8N4VBRqY7li/8rh0n8JRDvA/c1t8ZctabHIgVAqrj3voldL1rJvNMuQZ2OOC
         UEwA21yxNhvcAldSRUnQ8cKL7y7WWpc/FqRJVbLZ6wVCsvyaJ8GYrseBsCfAhvmWhPQI
         I2QXpxx01K7bXa4ZnQ/kbv8swLQqAsb2Xo1EDe0hGuq6e8MtAoYrF4aZKHKaJuoFPKjY
         sVDg==
X-Gm-Message-State: AOAM5316Pqvi/JQ1JDjfY0Tk5C4TICjc9w62Mg7TzcImw9qFAXDLO77q
        WcHj0d98JBUVw+ByLh/OlFr5+kWYjgaBZA==
X-Google-Smtp-Source: ABdhPJw4KTNKNSvJysJZj8CUN46U3h+sDp3pVvlYlSf27K5hR5Uzz/TjG52rZgleLfLpiGs1nvDgtw==
X-Received: by 2002:a17:90a:1509:b0:1d8:c22b:4d61 with SMTP id l9-20020a17090a150900b001d8c22b4d61mr17532701pja.78.1651932380443;
        Sat, 07 May 2022 07:06:20 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902c3cd00b0015e8d4eb2acsm3674813plj.246.2022.05.07.07.06.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 May 2022 07:06:20 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] io_uring: add REQ_F_APOLL_MULTISHOT for requests
Date:   Sat,  7 May 2022 22:06:18 +0800
Message-Id: <20220507140620.85871-3-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220507140620.85871-1-haoxu.linux@gmail.com>
References: <20220507140620.85871-1-haoxu.linux@gmail.com>
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

From: Hao Xu <howeyxu@tencent.com>

Add a flag to indicate multishot mode for fast poll. currently only
accept use it, but there may be more operations leveraging it in the
future. Also add a mask IO_APOLL_MULTI_POLLED which stands for
REQ_F_APOLL_MULTI | REQ_F_POLLED, to make the code short and cleaner.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b6d491c9a25f..c2ee184ac693 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -116,6 +116,8 @@
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
 				 IO_REQ_CLEAN_FLAGS)
 
+#define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
+
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
 struct io_uring {
@@ -810,6 +812,7 @@ enum {
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
 	REQ_F_PARTIAL_IO_BIT,
+	REQ_F_APOLL_MULTISHOT_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -874,6 +877,8 @@ enum {
 	REQ_F_DOUBLE_POLL	= BIT(REQ_F_DOUBLE_POLL_BIT),
 	/* request has already done partial IO */
 	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
+	/* fast poll multishot mode */
+	REQ_F_APOLL_MULTISHOT	= BIT(REQ_F_APOLL_MULTISHOT_BIT),
 };
 
 struct async_poll {
-- 
2.36.0

