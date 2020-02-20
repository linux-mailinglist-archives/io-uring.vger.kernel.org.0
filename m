Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7B6016685A
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 21:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgBTUb7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 15:31:59 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43676 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgBTUb6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 15:31:58 -0500
Received: by mail-pf1-f196.google.com with SMTP id s1so2467586pfh.10
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 12:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qYb1pTSxvCmtivq53vZqNobwoobHQyWd7lP0oir6RbA=;
        b=AhBVccYWIWqDArBfwPaJuXwKQLFLjD+8qrkxopsGMrVTW6gVsntAcY9Tjt40A35W19
         hPSm0b2PMzKFvm23twk5zeFjpf5s/jtH+KqQWR25+epN54pBHMH6dzAt4X3kGL9qa4G0
         UL1ZbzaUrHTnsny+b80YkGpyvTwGsmQBkFeX4RdEORayaNIpE4WgUsk0/KoaW7+iBoRA
         nlunARLKt24BoUER1aO+vHvMU8zBNZ1CGZcpQ+auzi5mmt03zokWt51o1G7GsuSOk7oa
         mQHZg+mTgZHAiBX0vB6tWbc6n1Kc+NCAAoJOgyPXNceQYWhj09XpVQU+Ncy2al5pL7ZE
         nxHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qYb1pTSxvCmtivq53vZqNobwoobHQyWd7lP0oir6RbA=;
        b=jxQld7icGrXT3srchaeeCXP1b6BnEjR/YFaSoq4KB0m5/8B2TgEYY6xurKkO0k9tSd
         qH+cYIqUjgUXDLc3HjqXuKPRTD9EAK5mTcPbhApaisfMY704G9DN69WCkMB7w+asvBoU
         sumWt7KmyZKU43E8lYNlBNtYhcJfsGyAKevpFUpCn9GOoH2vrxaraUYEyV5cGiCj6tH4
         ZqGYPUl/+jXkXiQp7g3Jl9VwWaXuCvUWaRd5tHMJMgUFwkMprgECZ8uQTyfBdaxbMKob
         ZlOYqQX65d1PyYZcnF5EEVRBhpeLfpSPbWOG5wefDvF0R9018pyf2VEJ+AaIZKpE1GCZ
         lsDg==
X-Gm-Message-State: APjAAAWHC0uHO1umVR4IL7U78LLtZv1oSGVU1GQCY/vRBQmkb4BBI+sN
        R9FUper7OlBM14UXpuHCRBwWi11UQSs=
X-Google-Smtp-Source: APXvYqz5ZkyY6ea+QXaztOOLcPTFVfUuQYg8W5ZQVnsU7sZ7wDDHhnapntQYi7SS+qB45uERSWdRIQ==
X-Received: by 2002:aa7:8101:: with SMTP id b1mr34238180pfi.105.1582230717337;
        Thu, 20 Feb 2020 12:31:57 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id z10sm169672pgj.73.2020.02.20.12.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 12:31:56 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/9] io_uring: io_accept() should hold on to submit reference on retry
Date:   Thu, 20 Feb 2020 13:31:44 -0700
Message-Id: <20200220203151.18709-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200220203151.18709-1-axboe@kernel.dk>
References: <20200220203151.18709-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't drop an early reference, hang on to it and let the caller drop
it. This makes it behave more like "regular" requests.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bd3a39b0f4ee..c3fe2022e343 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3353,6 +3353,8 @@ static void io_accept_finish(struct io_wq_work **workptr)
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
 	struct io_kiocb *nxt = NULL;
 
+	io_put_req(req);
+
 	if (io_req_cancelled(req))
 		return;
 	__io_accept(req, &nxt, false);
@@ -3370,7 +3372,6 @@ static int io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
 	ret = __io_accept(req, nxt, force_nonblock);
 	if (ret == -EAGAIN && force_nonblock) {
 		req->work.func = io_accept_finish;
-		io_put_req(req);
 		return -EAGAIN;
 	}
 	return 0;
-- 
2.25.1

