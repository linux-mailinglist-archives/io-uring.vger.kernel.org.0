Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D374ECA5B
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 19:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347438AbiC3RQI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 13:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244733AbiC3RQH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 13:16:07 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E6B2ED78
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 10:14:21 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id z10so1947815iln.0
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 10:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9xW2RAozY9Oerpo5uMPbcRGMc0PrWwrCZHc0hIsSNXM=;
        b=nGjWKNdditVC3xvZG7hLmvnvHlkDlYmUXxQAVwEB+DVrJMYNa/UPdBHKWOW4OcKU5m
         U02EATXgkbTLd+MfT0A3jn0CF34na2ROoBgHOtBRFuVjQxPXvB2aiFOShoF8FlQS8i86
         QdULvS7aJfp5V7eH8s1t4mIXxNahZ3iAKZm9aVST+rNQ0W8861nSNs5KZxDoSQXqMDgc
         /6DNrA99QNMW4pjG6zlRH5JhoFKGEvCVWHmDC/riM24l/Qs1SoYuC6GfLyuWNIhAFIcf
         TLzZ5UmK4Al2TQ8kLQ+wLJKZD/K++M8DtBhBA0XvM1GQGeApraVLnaO1AJFNc3JXvTa1
         6QTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9xW2RAozY9Oerpo5uMPbcRGMc0PrWwrCZHc0hIsSNXM=;
        b=FMI+ABupjR5eQpELTSvT//dlvmPf4uRD1x6L0KoSj+hPG5DKHxxdsBtJ/aKvsSvItl
         xog4e5qXhjVPQPArMAJoMTdPcqulClaPN61yj+ktMT5V7C/31xHiIHQlhoA64iRi6ZQr
         SxQvQjeZoKW6a6F84+EUJWANoPVWRPZ8/GclaNr/szubSsXqxKGQQxzWqRqyB8Eao/oh
         rrT1sELVG38gY+dwowkIrsxnaOIs6CEQdFIyVJSyZf4v3Jh9kI2Lpol2xlNGXYPYbEkE
         1b7bXSle9bWHBK11HwmBgdmYzeU45d6B/b1qqUkIyz5akD6cjMCHT6K1tQbjJQQawcOK
         /uCA==
X-Gm-Message-State: AOAM5336oxmAOmo/IOthAFgi28nnCgL6EWm2it/i+SnrKHYIXSM1wGba
        w+YV0nfLcUBcvZoypxZIP8LlDCj7hhTtNErP
X-Google-Smtp-Source: ABdhPJzh1l830/uLPfxBTxlRQ7AXKTnNCl7y3bixhH5u9cl2HXf+d6+hMf3VU/bQPG9t3UnuFoxUDw==
X-Received: by 2002:a92:2e07:0:b0:2c7:e54a:949 with SMTP id v7-20020a922e07000000b002c7e54a0949mr11870067ile.172.1648660461010;
        Wed, 30 Mar 2022 10:14:21 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b24-20020a5d8d98000000b006409ad493fbsm11588920ioj.21.2022.03.30.10.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 10:14:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring: defer msg-ring file validity check until command issue
Date:   Wed, 30 Mar 2022 11:14:12 -0600
Message-Id: <20220330171416.152538-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220330171416.152538-1-axboe@kernel.dk>
References: <20220330171416.152538-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for not using the file at prep time, defer checking if this
file refers to a valid io_uring instance until issue time.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 923410937dc7..3d0dbcd2f69c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4473,9 +4473,6 @@ static int io_msg_ring_prep(struct io_kiocb *req,
 		     sqe->splice_fd_in || sqe->buf_index || sqe->personality))
 		return -EINVAL;
 
-	if (req->file->f_op != &io_uring_fops)
-		return -EBADFD;
-
 	req->msg.user_data = READ_ONCE(sqe->off);
 	req->msg.len = READ_ONCE(sqe->len);
 	return 0;
@@ -4485,9 +4482,14 @@ static int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *target_ctx;
 	struct io_msg *msg = &req->msg;
-	int ret = -EOVERFLOW;
 	bool filled;
+	int ret;
 
+	ret = -EBADFD;
+	if (req->file->f_op != &io_uring_fops)
+		goto done;
+
+	ret = -EOVERFLOW;
 	target_ctx = req->file->private_data;
 
 	spin_lock(&target_ctx->completion_lock);
@@ -4500,6 +4502,7 @@ static int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 		ret = 0;
 	}
 
+done:
 	if (ret < 0)
 		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, 0);
-- 
2.35.1

