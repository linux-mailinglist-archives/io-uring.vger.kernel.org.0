Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E843FEFB3
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 16:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236020AbhIBOvn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 10:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhIBOvn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 10:51:43 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FECC061575
        for <io-uring@vger.kernel.org>; Thu,  2 Sep 2021 07:50:44 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id b7so2798821iob.4
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 07:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=GISva7QnY8v6ilNZQ30D3w1jUkxtrz0OqcWzusP7lNw=;
        b=DA1dN8htKQslI7ZByczG7y/gsBSiiUpSTFdhLithqhZdeCnwMJYeKEeUVJQnXy1qO0
         UPRkoAONnTddrqWW739IeNAirYX0I6k6WiIr+IQiBMAPv+UL0mAz87BSceC8GFxf3MmJ
         dzfLUi9ingYeHeMLSi4fseh9VF5F2LMSKfC1TuyQtLP/ZYj+ZnA6bO0hnTQSwoGyb1lV
         4mud06WGQgTFJRKxVxHWkQHMR3Q5ej2hbT9DzPU0tVI4ZlzE5INdncxbKr2EkSmU++lu
         ZseBmkHA0MCJeA0gnU7nzDdnwKe+qFIuWTwBHjY7xZRt4+BpkYHGgCJ8ZICLjGwbs2rR
         lZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=GISva7QnY8v6ilNZQ30D3w1jUkxtrz0OqcWzusP7lNw=;
        b=PbzKv2TTExZKRD9TMAM6E9ArdddpJmGbeU6VshHcNw7WzaDoyLRB0BIjHFM/afiBBM
         AGWwrASAiwyMBut24bJ9D7HPggSRsdcNoUQHWjQSaIf3eyU7enGhIxN3ZLs/ekcNdC8y
         WkCpH2T4dYbMBdc378pHBnDkSXoulJWU6M3vCfsSXUUyXQr5wKsDae6AIWJckPc+zUfO
         Wpa2ZwJ9VFJN9z3oGTHuTZVHQj0/qiuR2NWS4knNxyz2Xu5YRtwdl0uIWwcRSmjkCm+j
         CPWzoA6yoSSMMCYAaPqUQDo2gJjG+SSjTNke2OmZkxhIeURBpGbZC2n5NtE+BBfaN14J
         pvOQ==
X-Gm-Message-State: AOAM530bzG3iVCKt8R4wvR4iaUN2YMC5lg2cBJED5A28laVb3zlu1Cpo
        Dt4Q1wM7LnAUT+hbbS9F72KgiGvbV8QThg==
X-Google-Smtp-Source: ABdhPJzsgjhTQTp7ltO5pUb84onBEmS3R5D8wI/BXbBpVPC07WfCfGK0AgCBU0qCXUfvQ/TwwELAeg==
X-Received: by 2002:a02:c6c3:: with SMTP id r3mr3160238jan.69.1630594243771;
        Thu, 02 Sep 2021 07:50:43 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m10sm1079672ilg.20.2021.09.02.07.50.43
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 07:50:43 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: ensure IORING_REGISTER_IOWQ_MAX_WORKERS works with
 SQPOLL
Message-ID: <46f983de-aa67-fe80-71b8-157766098952@kernel.dk>
Date:   Thu, 2 Sep 2021 08:50:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SQPOLL has a different thread doing submissions, we need to check for
that and use the right task context when updating the worker values.
Just hold the sqd->lock across the operation, this ensures that the
thread cannot go away while we poke at ->io_uring.

Link: https://github.com/axboe/liburing/issues/420
Fixes: 2e480058ddc2 ("io-wq: provide a way to limit max number of workers")
Reported-by: Johannes Lundberg <johalun0@gmail.com>
Tested-by: Johannes Lundberg <johalun0@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4a5eb9e856f0..ef0c7ecc03a0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10323,26 +10323,46 @@ static int io_unregister_iowq_aff(struct io_ring_ctx *ctx)
 static int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 					void __user *arg)
 {
-	struct io_uring_task *tctx = current->io_uring;
+	struct io_sq_data *sqd = NULL;
+	struct io_uring_task *tctx;
 	__u32 new_count[2];
 	int i, ret;
 
-	if (!tctx || !tctx->io_wq)
-		return -EINVAL;
 	if (copy_from_user(new_count, arg, sizeof(new_count)))
 		return -EFAULT;
 	for (i = 0; i < ARRAY_SIZE(new_count); i++)
 		if (new_count[i] > INT_MAX)
 			return -EINVAL;
 
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		sqd = ctx->sq_data;
+		if (sqd) {
+			mutex_lock(&sqd->lock);
+			tctx = sqd->thread->io_uring;
+		}
+	} else {
+		tctx = current->io_uring;
+	}
+
+	ret = -EINVAL;
+	if (!tctx || !tctx->io_wq)
+		goto err;
+
 	ret = io_wq_max_workers(tctx->io_wq, new_count);
 	if (ret)
-		return ret;
+		goto err;
+
+	if (sqd)
+		mutex_unlock(&sqd->lock);
 
 	if (copy_to_user(arg, new_count, sizeof(new_count)))
 		return -EFAULT;
 
 	return 0;
+err:
+	if (sqd)
+		mutex_unlock(&sqd->lock);
+	return ret;
 }
 
 static bool io_register_op_must_quiesce(int op)

-- 
Jens Axboe

