Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34BF5EFF52
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 23:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiI2Vde (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 17:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiI2Vdd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 17:33:33 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4961D3590
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 14:33:32 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id 64so1923316iov.13
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 14:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=EyLcgnmL1EkcoqNlTjqZoeiNMkAtJ3BQiAg6t0Vh9M4=;
        b=Iu3OmmQMEWTpkH6MChAqkPNPbQ+qPmd4Jqhbho1kXk12ExMRjbESXvDeaOMeslL0hF
         +nBUIkFk/vQLZXBHFJQzs9f75CsFUxGjjvRdRTHN6uqZgBvU4RjW94/lVvwipIDyjETK
         sR4RNGmOhoOacPLJa5qXVXMedzTPPXsyysf9XThz4APhyHKXFdaC0WRr5nXEB1UIgQLF
         Jf4OouAIz8mAXd7f83jsOh7ISWJSVhnUppaNpgVc1CxEImwhj8WCtz6DUajnX+UAImbL
         mE85XrzJoZqqVV+a8/p88sgV+0LU5lr2x8lbiDti5k8Y0L/eEj5ezTLsfg+rN8JkWm+O
         hNeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=EyLcgnmL1EkcoqNlTjqZoeiNMkAtJ3BQiAg6t0Vh9M4=;
        b=egNef8rLTC3J7aJ+Mv8Dh9FpIUNccGXaixhgPDFxGEARuO50zmUIGLm2feBLdZ5S+J
         Z+HueDXSRSxuMMUSaoCc+NQKndGaALjz0sC2nBFs1m619Z+F9foMJIfdqcVGtVS2mNif
         s9oULzscSDp8nk+9As7wf1H/ZUY8QZjI5hImUOozSAigR1s2b+ZB15Few6q486b+wCzs
         CCJnz58Ee9qLMMfl/ZgoaqI5NYqSrZr55vSXlzygdRQcUBaBNWyUxMzS2c0IXH21rScl
         8RKBsItGIvpDQD9FUik2BVwSBJucGzkE8uIUGw5Z8OY+4SP25nT1bRUydkWaaW5L/5/e
         gr+g==
X-Gm-Message-State: ACrzQf3+I42kkfzMGDT5b/16HNIxlsdAaF9dbJCQv2QcBpbuEEAmJ3w+
        V7ZWMwDqWWaeL/IlzPyLuO9HHA237owB0w==
X-Google-Smtp-Source: AMsMyM6QYO8bLF2l6PAydoyAiPafUSF3h4KtRgj/uzhEfPqe1WYNDtNz5DufSMDTyGAFp4x30gUhZw==
X-Received: by 2002:a05:6638:120b:b0:35a:98f1:7a22 with SMTP id n11-20020a056638120b00b0035a98f17a22mr3046226jas.271.1664487211209;
        Thu, 29 Sep 2022 14:33:31 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y25-20020a056638229900b00346b4b25252sm208183jas.13.2022.09.29.14.33.30
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 14:33:30 -0700 (PDT)
Message-ID: <ce1aca33-0f68-07be-1d22-cfcbb5792a99@kernel.dk>
Date:   Thu, 29 Sep 2022 15:33:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't gate task_work run on TIF_NOTIFY_SIGNAL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This isn't a reliable mechanism to tell if we have task_work pending, we
really should be looking at whether we have any items queued. This is
problematic if forward progress is gated on running said task_work. One
such example is reading from a pipe, where the write side has been closed
right before the read is started. The fput() of the file queues TWA_RESUME
task_work, and we need that task_work to be run before ->release() is
called for the pipe. If ->release() isn't called, then the read will sit
forever waiting on data that will never arise.

Fix this by io_run_task_work() so it checks if we have task_work pending
rather than rely on TIF_NOTIFY_SIGNAL for that. The latter obviously
doesn't work for task_work that is queued without TWA_SIGNAL.

Cc: stable@vger.kernel.org
Link: https://github.com/axboe/liburing/issues/665
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 177bd55357d7..48ce2348c8c1 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -231,11 +231,11 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 
 static inline int io_run_task_work(void)
 {
-	if (test_thread_flag(TIF_NOTIFY_SIGNAL)) {
+	if (task_work_pending(current)) {
+		if (test_thread_flag(TIF_NOTIFY_SIGNAL))
+			clear_notify_signal();
 		__set_current_state(TASK_RUNNING);
-		clear_notify_signal();
-		if (task_work_pending(current))
-			task_work_run();
+		task_work_run();
 		return 1;
 	}
 
-- 
Jens Axboe
