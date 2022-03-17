Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2496B4DBCD7
	for <lists+io-uring@lfdr.de>; Thu, 17 Mar 2022 03:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358451AbiCQCGV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 22:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350319AbiCQCGO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 22:06:14 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548C31EAD7
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:04:59 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id a17so3839085edm.9
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jHjGvmKzuX1Y5843SgTTSYbOkmlpTRMUqOEUGkvwHRc=;
        b=eHpJNasHkZeqvO7ZhcUoZ5y96gmJhhMwPgmRhuQLlSmmR9dXfKwzwQrhj4g/bzBsKB
         iigVTZI1pshOTVmbGtOkDKMqt/cjEpTHydLNdsOhf+4y3xsaN4+6BoOv3kyHxno1gTBL
         wwXXAH4hgUquF2a1g3y/FPUelnvMfN67qrB1YtliYs3hw0/s9qNcByFq7xk9KBrGtg0/
         yHCAe5zU/XjJrSW+/hayXwaCcIn2XaETFezFAU220b5mqreBo9kewaf94XACYFkYjQ2h
         1vK+k+oinLz5I8hc+mBYRv2hIfOT5LGd8l0t1/sSzrq59iSOEJPyegMImdRESx7QOsyl
         wt0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jHjGvmKzuX1Y5843SgTTSYbOkmlpTRMUqOEUGkvwHRc=;
        b=XXL7F5Q8uDzdOk1zQSjMZI3Fzgf7AdG/p91WmUxok7+YedbD3mH9B6g+g9hGulmNLo
         j/lS4CYzpIFNtXuWRRocYbdpaiX5jhL8L1h4Yb3QJrmQKoOTYv8XYWjafCaE6bmwNm5y
         2VIx0WSCJ9Lw21whgFReyOHB3sDM7BDz31EE3IJNpGp4dJMskmJyFACWNXoGAZdReRhW
         s3wcBOITQmHMjFGvXNQmKSyYb1ikywJRTnkxu7Uqp5ZA/MELe7hmWSuzl5b5n3Ohjbd7
         Ol7VpknQ26R4/lvUsA7NjEQTYqwEe0jQUwGPaRKjRcRcbnNlAiWE30ZH7NPL9elotiCG
         ZqVA==
X-Gm-Message-State: AOAM532k+VCwJ94I6XJ2hkjasIi0Mc/seS7czePVqvfENRg+dFVjq4VH
        Z+SULg3yQf45b0/56EMt+r0msy1a8GwXjA==
X-Google-Smtp-Source: ABdhPJx+yBDi3SopeGGGGf+cPzyNhJNnD7hvCQ75nTO5Ehbh6BedxW92kGo1pFUOfMC9zDJcTcU6cQ==
X-Received: by 2002:a05:6402:d7:b0:413:673:ba2f with SMTP id i23-20020a05640200d700b004130673ba2fmr2111496edu.29.1647482697792;
        Wed, 16 Mar 2022 19:04:57 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.67])
        by smtp.gmail.com with ESMTPSA id b26-20020aa7df9a000000b00416b3005c4bsm1876048edy.46.2022.03.16.19.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 19:04:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/7] io_uring: refactor timeout cancellation cqe posting
Date:   Thu, 17 Mar 2022 02:03:37 +0000
Message-Id: <46113ec4345764b4aef3b384ce38cceabaeedcbb.1647481208.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647481208.git.asml.silence@gmail.com>
References: <cover.1647481208.git.asml.silence@gmail.com>
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

io_fill_cqe*() is not always the best way to post CQEs just because
there is enough of infrastructure on top. Replace a raw call to a
variant of it inside of io_timeout_cancel(), which also saves us some
bloating and might help with batching later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 10fb82f1c8ca..b4b12aa7d107 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6432,10 +6432,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 
 	if (IS_ERR(req))
 		return PTR_ERR(req);
-
-	req_set_fail(req);
-	io_fill_cqe_req(req, -ECANCELED, 0);
-	io_put_req_deferred(req);
+	io_req_task_queue_fail(req, -ECANCELED);
 	return 0;
 }
 
-- 
2.35.1

