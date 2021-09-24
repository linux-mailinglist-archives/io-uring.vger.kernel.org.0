Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C3541771E
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 16:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346908AbhIXO5V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 10:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346805AbhIXO5U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 10:57:20 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4682C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 07:55:47 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id d11so10645768ilc.8
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 07:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=vJtfays0zj2ZNiUUFC0rOLQt+mqf57djr3z5UQHDV9Q=;
        b=LS/gkvGhRmJoT3gZX/PRBbJUOkVkJ/lpnOARNVcP3jihFt/PtI0G2CLY8OnQlnrcY+
         xS3RViEGym1UyWs1zNx8zVz9kohN9trgIuVKCGvkbW+K6sG3sLHeYz8VEhJHNJ2nI6BA
         syBpbfHDjyKzQLsgJK+rtA8yiMYqBGg+6eqhCdb6IUUuNGKDWHsjA+Jju6ex5wfZ9BHa
         1KbNObdBA6NK0KPXhepTJcqritGo50AlcLgRs7YdzI9aSyHLKC+x1uPpUYlu+14udEkt
         VWxmQDtZQqzkwpatcXnC2ReAj3do63geUZ7QdWCniMwt2LObk4JvtWiXfS07GJY9NUoU
         EaNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=vJtfays0zj2ZNiUUFC0rOLQt+mqf57djr3z5UQHDV9Q=;
        b=7VTeFaUN24zIO9sUmK2sZ5JMiZIBW2kAMboIgpORamFukKAco9fm+6r5Ee969nVy/3
         zYUj8FVoXYfVLg2hN95mKcnzEIyTYI2/TO6EjSCS1doBoHyxBWHSn0YkpM6lUdA0pyT0
         TCwSP2G5kqcfEnbpP+bWGN1A0PI6LoTe/0pRZmubfWrieMvE38VjCVU5B6U3ab/cjmqL
         Idzo785G6PzanBCHxoLTohCZYenQBMiW6IWtPuwdIWmCfPIYuoRWI5IPdmuEcOc1nFc7
         aixacygff9CpDRhbUNZzqxnojv/UfdvaC5PNUkMJqSwoFE4MaIb2jTcyDEeMXsIyOo5f
         uhJA==
X-Gm-Message-State: AOAM533CiO7kk2qlA7ptyXddwqg5TWf+dGLfB+Z8Dokj0Ym7knmGPmBa
        Uut4QZQC/y3sBcZHvrgaAwBeaqKKF2LFiNp+A44=
X-Google-Smtp-Source: ABdhPJxNoYuDv6uj1TNZma4NKU2LLQHNPT/VtDv0EngpVQjVRhVwGENmPy5XvtCAAJ64mXMPx805uw==
X-Received: by 2002:a05:6e02:1bc2:: with SMTP id x2mr8653001ilv.98.1632495346881;
        Fri, 24 Sep 2021 07:55:46 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w4sm3997090iox.25.2021.09.24.07.55.45
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 07:55:46 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't punt files update to io-wq unconditionally
Message-ID: <2da00bc9-2fb3-711b-28b1-7ab53b9fea0b@kernel.dk>
Date:   Fri, 24 Sep 2021 08:55:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There's no reason to punt it unconditionally, we just need to ensure that
the submit lock grabbing is conditional.

Fixes: 05f3fb3c5397 ("io_uring: avoid ring quiesce for fixed file set unregister and update")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b967be3df1e2..1fce231b4a9d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6304,19 +6304,16 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_uring_rsrc_update2 up;
 	int ret;
 
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-
 	up.offset = req->rsrc_update.offset;
 	up.data = req->rsrc_update.arg;
 	up.nr = 0;
 	up.tags = 0;
 	up.resv = 0;
 
-	mutex_lock(&ctx->uring_lock);
+	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
 	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
 					&up, req->rsrc_update.nr_args);
-	mutex_unlock(&ctx->uring_lock);
+	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
 
 	if (ret < 0)
 		req_set_fail(req);

-- 
Jens Axboe

