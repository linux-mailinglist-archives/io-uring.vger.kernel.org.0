Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAC425EB14
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 23:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgIEVs3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 17:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728647AbgIEVsY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 17:48:24 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACC3C061247
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 14:48:23 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id j11so13127067ejk.0
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 14:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=DYBzKs+tjeN1qZ6+Mf5LCNqQaCahpZmYn7vGp1+TLBM=;
        b=L921zxqo70R+rOUdE4YCwLoK0ML08oC8B5pRmn81XEinJXf9KmIq4XwxHoYMXq6WDC
         hk9IpnbpEFFLG9k8TTSDjSQJJ3GHNoYHMLGdhqFq2KQHiZssap+JRpX9/QvsRrCqufp7
         FgF4vYRXoZbIbIroLLrdldBNtg3sVtRVldyVSRjp2LzhQnQELXK6pWgbvx4IJJnMv9vk
         fO1ubODrxZ8UighdMehCYh0AsepqXJAHZ4+CBrZAtuzH7YM6qhQ6TF2jA++FFP5N3Zp1
         PEPj4fb/Bf7YrRGDqmC4CLio91H3wh4DXDkKIJ/Z9/vLRINwz/xlYfTYMsjrXwVINYDL
         c2Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DYBzKs+tjeN1qZ6+Mf5LCNqQaCahpZmYn7vGp1+TLBM=;
        b=RZA9rHwRE4uoTeYo+Sukcz4h+egCDYh1ksmuwie0U9LvgXKAlHKJgprlPXgEY8NEn8
         4Psu5iLgd5JHe2cQeDi/EW/HlF6YVtMwA6a1KQqOskyZI6sG/9xYqXcFauW73WXlprTo
         P5MFAbrPChrOWkFb5WCCXCpCE8vqa4RLQrneJ0WZqz7wqja6aSFxYNS2ZaujJOnscciH
         WUVaMWy5kZYsalET0Rs/tTsbmFM+nXzhcPuXKUXrbX2FcQmvsNe5uhT1ME2nYkbBmmBN
         1nIm8/MTL67gpL/+za3VBp9j4mWEweveusW7uEMyLMDkgQPotnySWk9WMJTdMCWG+rF7
         bE6g==
X-Gm-Message-State: AOAM533NjnXQFoSBw/CFUQqTeHpwDhNW7WLr5wKKL/B+Vkh4QjRJUbHz
        +8XnW+2XUEjqh9ywtRQUZWwNII7zqko=
X-Google-Smtp-Source: ABdhPJyXgvsqBvNwSmV7nhUg91KWoWqGXlDQOO2Fa2WNHUMH4JoNpUFobaMF27P9SPFxawoTqLQarg==
X-Received: by 2002:a17:906:76c7:: with SMTP id q7mr14531388ejn.541.1599342502589;
        Sat, 05 Sep 2020 14:48:22 -0700 (PDT)
Received: from localhost.localdomain ([5.100.192.56])
        by smtp.gmail.com with ESMTPSA id g25sm7965603edu.53.2020.09.05.14.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 14:48:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring: kill extra user_bufs check
Date:   Sun,  6 Sep 2020 00:45:48 +0300
Message-Id: <bf649f4931ad406bfa4b4f1730d7de120fbd0a06.1599341028.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1599341028.git.asml.silence@gmail.com>
References: <cover.1599341028.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Testing ctx->user_bufs for NULL in io_import_fixed() is not neccessary,
because in that case ctx->nr_user_bufs would be zero, and the following
check would fail.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fc2aaaaca908..2e3adf9d17dd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2587,18 +2587,12 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
 	struct io_ring_ctx *ctx = req->ctx;
 	size_t len = req->rw.len;
 	struct io_mapped_ubuf *imu;
-	u16 index, buf_index;
+	u16 index, buf_index = req->buf_index;
 	size_t offset;
 	u64 buf_addr;
 
-	/* attempt to use fixed buffers without having provided iovecs */
-	if (unlikely(!ctx->user_bufs))
-		return -EFAULT;
-
-	buf_index = req->buf_index;
 	if (unlikely(buf_index >= ctx->nr_user_bufs))
 		return -EFAULT;
-
 	index = array_index_nospec(buf_index, ctx->nr_user_bufs);
 	imu = &ctx->user_bufs[index];
 	buf_addr = req->rw.addr;
-- 
2.24.0

