Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C4F2F8B0E
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 04:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbhAPD6L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 22:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAPD6K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 22:58:10 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0D8C061757
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 19:57:30 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id b8so5733616plx.0
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 19:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=jQ3yqKgWKEXGksUd1qpAAJhVySFQxQ6ga7/Z/aUAzJQ=;
        b=ReyAvYmnt/Xp38facMCPrjVcuyHFIq1WkTQXodZ7+BIJ/AU5E3Qn1yiLGBsCsMwbCq
         4ONXfU3/oMNjrrJ0CN+ko6YF7wFgkhVtmQAUOgStHsQQrRp59R/fod8FE6ocS3VKYLn9
         BTvTvw4hK3ivZ5WFLwCow8snsJe/fmbm6CbkDlVlJM0cqVX2iwKtafsbOtkJxtPqnnPv
         PweqeFXgujkRJgpiPifZpz4jlZPXe36U+RizAdDAnh7mThLWfXm1UFMEfzmxaEQ4DLS6
         yBT2WqN/hPfvUUz6u5PReyYtE9FJMHmF/5eJYgp8d9B4s5H1wBdJy/wbPQ++FSaxdDRZ
         LyAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=jQ3yqKgWKEXGksUd1qpAAJhVySFQxQ6ga7/Z/aUAzJQ=;
        b=LGj2Yb+BJG3qjnBV4n6q6Pnh7g+6AbiToqMmrieauheYHZFNhQuTI994lFP7GrKrev
         iTd0nIc2ZzYxpl4DAgBpr/vNONOPLQ/NIChHOXcJwKqJRrDa2unTxZWBnF9cVdQF4xtJ
         No4ain+3KaQyb2fRf9uyxI/x863k4s2tyuhjvkS82KQVRGaW/XxEhdtecwNVrK4v7mbb
         34XmNFPaE394d9Ez9mvGQKJGbQb2f5t7Wgq0zTER4eSU5cKRcpKn9fx+mep6svhrVJvf
         b7a/D6liSKScbVAvBwhZMj9LXhxzSve69iOLHacS4oEa3GZA8ISwE449RTnob0QCSS2e
         JHMw==
X-Gm-Message-State: AOAM533+qqKUy3zz1GXrKkMrz3qCLpTIXKnsifCRFVMswPxf2Bkdr0jU
        LwpWX8rX0ovT7Htzzk3Gb7jubyDZ/qnaeg==
X-Google-Smtp-Source: ABdhPJzN5dUaj1j6HjSg1/Zk38Hnl8EjZzm9q7udfwopx3DTRw1bw+Y5s36P9DafZTnUX92wvmltcQ==
X-Received: by 2002:a17:90a:6587:: with SMTP id k7mr14290343pjj.154.1610769449887;
        Fri, 15 Jan 2021 19:57:29 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 8sm8971122pfz.93.2021.01.15.19.57.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 19:57:29 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: ensure finish_wait() is always called in
 __io_uring_task_cancel()
Message-ID: <1a0d0f6f-e357-0b07-2754-98a309d01872@kernel.dk>
Date:   Fri, 15 Jan 2021 20:57:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we enter with requests pending and performm cancelations, we'll have
a different inflight count before and after calling prepare_to_wait().
This causes the loop to restart. If we actually ended up canceling
everything, or everything completed in-between, then we'll break out
of the loop without calling finish_wait() on the waitqueue. This can
trigger a warning on exit_signals(), as we leave the task state in
TASK_UNINTERRUPTIBLE.

Put a finish_wait() after the loop to catch that case.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 06cc79d39586..985a9e3f976d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9101,6 +9101,7 @@ void __io_uring_task_cancel(void)
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
 
+	finish_wait(&tctx->wait, &wait);
 	atomic_dec(&tctx->in_idle);
 
 	io_uring_remove_task_files(tctx);
-- 
Jens Axboe

