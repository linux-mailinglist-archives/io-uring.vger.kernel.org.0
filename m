Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADD64342DB
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 03:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhJTB2r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Oct 2021 21:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhJTB2r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Oct 2021 21:28:47 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DDFC06161C
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 18:26:33 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 67-20020a1c1946000000b0030d4c90fa87so6520781wmz.2
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 18:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WRD3jVmAaQp3SToC1iCNztj2R09JR8kwaLTZOk+xd0c=;
        b=D6kzFBNI3MoHz/rh7+3xHG6uX0DSW0U3bjDVmPWNWv725hDfqthriOzrYoyMjenEU1
         o+LujsKKda3Fd4FN1N3ul5aeAzz6hvX/AKFg0xHJ8Bak6TQ2VCkZB4E8cs5OYhxV9+UZ
         BJSvi3OgVZHlpqvKaTBL/VMcQgiSlF8cWWIAMF41a/WbfSP5rgK/VNf9TdOwZwUGod9o
         EOT2R5Edaj33l3NLSRr20CBEB6CMBXirv4JS5gMH2V1oxvP4QhAihLBv3+4aaJ0ADzf9
         lz8NMaj8j9JWEMB03zXWi7OxrpZwOd1SzC0uhOBe8FFYKYZNIdPEzDhkbdQEgZSIXPmA
         UUaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WRD3jVmAaQp3SToC1iCNztj2R09JR8kwaLTZOk+xd0c=;
        b=z7cWHEcQrUCL/7HO5VN1aTAL7Og+3LnZxbt1a+ZTsaLA3jsYD7IQA5PClxNOK9KbpV
         eLzGvp7M9/nQsOJAXV1uEpGz0h8Qub/aV0nJb2lH9c39Q+TnNN3+U3mjv3Sl9VOksv+r
         gd01WDCrxbFo8D7dbka+7ITUqpK1ufCgk2YyutZk5uvvbEIXsSVfRTHHen+W9Rjxx9xX
         pD0v03nVixR97efqeN1orC7C9VSe2LqSUcic2BT8NEodbye7pq6Jx8EZzxMLzsXWAEk/
         /wMEt/Rx3QcFkQiwmQLFobdBlCK4ATJNZ/ZyD/sRKnCljdUsLQmSaytZElbNTK84c6PZ
         qhmw==
X-Gm-Message-State: AOAM533VCSvlpB/1qYMeG0CWh1zWtwS9HoZMrnionbi2ha9/bwz+PSmj
        QAx3wdUUmmYUMZMpJdTQblnKItj85fMiCw==
X-Google-Smtp-Source: ABdhPJySfcTB+8Rg4kQ02Rtpiv60XxytDY66VCgDBdTrnrHWAlCrGQ6mwudfAJeN/lrVLq7TIWLEGQ==
X-Received: by 2002:a1c:5417:: with SMTP id i23mr9959111wmb.17.1634693192141;
        Tue, 19 Oct 2021 18:26:32 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.194])
        by smtp.gmail.com with ESMTPSA id t12sm606979wmq.44.2021.10.19.18.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 18:26:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Beld Zhang <beldzhang@gmail.com>
Subject: [PATCH 5.15] io_uring: fix ltimeout unprep
Date:   Wed, 20 Oct 2021 02:26:23 +0100
Message-Id: <902042fd54ccefaa79e6e9ebf7d4bba9a6d5bfaa.1634692926.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_unprep_linked_timeout() is broken, first it needs to return back
REQ_F_ARM_LTIMEOUT, so the linked timeout is enqueued and disarmed. But
now we refcounted it, and linked timeouts may get not executed at all,
leaking a request.

Just kill the unprep optimisation.

Fixes: 906c6caaf5861 ("io_uring: optimise io_prep_linked_timeout()")
Reported-by: Beld Zhang <beldzhang@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c87931d8b503..18de14a9e7a4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1406,11 +1406,6 @@ static inline void io_req_track_inflight(struct io_kiocb *req)
 	}
 }
 
-static inline void io_unprep_linked_timeout(struct io_kiocb *req)
-{
-	req->flags &= ~REQ_F_LINK_TIMEOUT;
-}
-
 static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 {
 	if (WARN_ON_ONCE(!req->link))
@@ -6892,10 +6887,6 @@ static void io_queue_sqe_arm_apoll(struct io_kiocb *req)
 
 	switch (io_arm_poll_handler(req)) {
 	case IO_APOLL_READY:
-		if (linked_timeout) {
-			io_unprep_linked_timeout(req);
-			linked_timeout = NULL;
-		}
 		io_req_task_queue(req);
 		break;
 	case IO_APOLL_ABORTED:
-- 
2.33.1

