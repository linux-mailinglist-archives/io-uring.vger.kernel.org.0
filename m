Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BBD4EB277
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 19:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbiC2RJc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 13:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240040AbiC2RJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 13:09:31 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9D3258FCF
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 10:07:48 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id r11so12822087ila.1
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 10:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T2ZVI8YVzreNGFZ6tgzzlJcmjt+NOXgf4E0tnpNmnbY=;
        b=B2AxmiIPndRbbzsTMrWPTmSG0r4M94uUXcO2k7SYFUdRDG7AKUM094QQlF44KQA38m
         Uen2KgKcNRfMWJWz319P/DfQhpOy0+sUPi8HVBo4jiUFe/83ZBOQ9f83hiBth0ZLQKqO
         u3Z71U70qPrtZWxhewopugxx7HFsjCLURr5BdCpboLhxNzREik0AcD9s5wYbAwh25T1E
         fmzZWVLA+CsAgNvJw9K767wYJ7adoBGOj6u2G/cWQVqgtnl951j5fCfK8NihYJ63RoS+
         +HTsNDMY3Ba3iqSH5W4r+s3LfGqw7roORipDVhZLluY8E7oqQDtNeZppK0Czc+owDW8V
         ogbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T2ZVI8YVzreNGFZ6tgzzlJcmjt+NOXgf4E0tnpNmnbY=;
        b=TeNUt0ChnE5qc62fyYu4gmyVdRz5VxsV/J9S9VPSUd7kB7Dmi7rBxd7WxUl2iUapIe
         WwgUc0WyBXVaDzYr1pPbguxhj1M5JCXtUi5hQ0fAgryDE22aaHQz+HwZy+KVtGr8mOAt
         7ggQ37PtzvbsKX+ytlLxJtRNmuO4aa5J4xRyUD6+ksEHp7LLyz+ZfpSlmajHvt67j+lw
         s6sk+YmsulZzeuMB/4oPEdf5T2vsYAXiPwJkWOGQzWMOhv3EddeqXEYx9UMF0sqexK8O
         HMHk+RuWPXuxcJ5JdkuOzODyN5Iy7kr65iwFoFBzJK78QloAsAloyVcrGW9ARkLpp1Hv
         j/UQ==
X-Gm-Message-State: AOAM5302zsTMBWRk8ibB5frE1p9zMw5C9s02O603u17Qb/RYWs5fF+fE
        wEBIyymB78sk0vsAX7ytTxKlswf8LZ/4yEnD
X-Google-Smtp-Source: ABdhPJwtyNx3RGJrXEEz77bTRjRp9j+3p16dFawXdmeL/+9Uuw+dWgjNobmHRKdOqaOSzAXoM7Z8sQ==
X-Received: by 2002:a05:6e02:1685:b0:2c9:a9e9:846 with SMTP id f5-20020a056e02168500b002c9a9e90846mr7722624ila.273.1648573667596;
        Tue, 29 Mar 2022 10:07:47 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v3-20020a5d9483000000b00640d3d4acabsm9383069ioj.44.2022.03.29.10.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 10:07:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: defer msg-ring file validity check until command issue
Date:   Tue, 29 Mar 2022 11:07:39 -0600
Message-Id: <20220329170742.164434-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220329170742.164434-1-axboe@kernel.dk>
References: <20220329170742.164434-1-axboe@kernel.dk>
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
index 923410937dc7..072a31400e6a 100644
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
 
+	ret = -EBADF;
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

