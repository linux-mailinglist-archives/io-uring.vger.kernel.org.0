Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B223426FB
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 21:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhCSUfi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 16:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhCSUf1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 16:35:27 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05B5C06175F
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 13:35:27 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id u19so4469041pgh.10
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 13:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WxdLyLm5sqDpXTObn1HR9iPHkHeS22MdNf6BXbeu34Y=;
        b=PVc0Jh1NsIYuJelBMu2zH1UcuTeqIx7NoSebPepZV4xTxlLB4ZHSKZDbZIwJDzDJSL
         sxKMvOmMVAaVaKAh+oFQjlfZGL+lfXcJOtBzZw9aNpKo5QoHZ102uiiIN87jvoxd7HKS
         98cu+NTHNkfeap51wEQEhoe6obX56CSTrhdb4NFWK/h+E+ntKR/CQVuRmSF3mhUFd8fB
         HP3dAQSVSN3jMrxqDlvvzuyntGlgJXWi4WIzYmS4z+dB+3ip3XkBzF1E417jasMtWP1q
         E1kBK3VYUoHsLQ2UJt9JdTIgUi+6jARt/AwaAJ/dBohl6V1hHbC/Mz/1v+HrZtHH5q+3
         V5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WxdLyLm5sqDpXTObn1HR9iPHkHeS22MdNf6BXbeu34Y=;
        b=tuyqY0yPlw6d7V2T7+Pr6dYXIo1oDiRMwvCVP4u8bW2R+RohwMhtr/FK0mrLxJiInR
         FJtJ4GwxvxDc6kUMtn/hnyOupw5K/6gwWsbjEK/ES26CzwBp4TTtCyOrDLLq7dYNK4al
         8xvS8PKd3B1RhiRO7TgLRfPVTI8xh2b7Y8goW7iGTTCCglxbS9D2bVLcZDflUdhS8l1E
         Y3mXFvaDyfBn+DASz+BUUO3IxRavJfnCkn1E+lsxZDT4iXPfk78aqj3OFxg/lw/QQ9+c
         yNWcvncV27GtImlLMQOZ9DL4ls4yjfs/goBr7pzyMvwbv7p8ret0I38ibVpaQV+kpANb
         QHOw==
X-Gm-Message-State: AOAM532befqj+7OVyMwHAo5zMhoWYpKhVYk7ysj1fwNTn6KiIwdq1LXn
        myowo9OulyvVnjiqDbp3kb6NdVAeE9FLWQ==
X-Google-Smtp-Source: ABdhPJyeC0FvDgVGFfXrvxcmqFkvmznDVds+yLBnlOpRcSjA1KR1hX2cyJfwQxj+jO/U/zNfDtZKXw==
X-Received: by 2002:a63:b1c:: with SMTP id 28mr13000356pgl.165.1616186127132;
        Fri, 19 Mar 2021 13:35:27 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b17sm6253498pfp.136.2021.03.19.13.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 13:35:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/8] io_uring: abstract out helper for removing poll waitqs/hashes
Date:   Fri, 19 Mar 2021 14:35:13 -0600
Message-Id: <20210319203516.790984-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319203516.790984-1-axboe@kernel.dk>
References: <20210319203516.790984-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No functional changes in this patch, just preparation for kill multishot
poll on CQ overflow.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ede66f620941..53378003bd3b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5214,7 +5214,7 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 	return do_complete;
 }
 
-static bool io_poll_remove_one(struct io_kiocb *req)
+static bool io_poll_remove_waitqs(struct io_kiocb *req)
 {
 	bool do_complete;
 
@@ -5234,6 +5234,14 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 		}
 	}
 
+	return do_complete;
+}
+
+static bool io_poll_remove_one(struct io_kiocb *req)
+{
+	bool do_complete;
+
+	do_complete = io_poll_remove_waitqs(req);
 	if (do_complete) {
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(req->ctx);
-- 
2.31.0

