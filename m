Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241C34EB487
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 22:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiC2UQD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 16:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiC2UQA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 16:16:00 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6E2E542B
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 13:14:17 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id q11so22368238iod.6
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 13:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9xW2RAozY9Oerpo5uMPbcRGMc0PrWwrCZHc0hIsSNXM=;
        b=Dn+Xb9fVeY7SrsUAHfZmO7D3L6xM7pmEBA6oBMQuhj2QgcxRE+IjUbOSS6DZITkE4p
         4HUqMDyYgtx1dTJa9Hv7GBZpf1jPypjgE9Qvz4A59EBq+wxxLw8kjJX3etbNn2tKv1js
         Yk2jXM4XfwqmgAZrRYyCQ7sI2jaA6sgmsYR8Zn79zkumTcLMo0yWlB9w2xkHl+n9nYpO
         ZENVRf2zaPngjhxJTxD6RMEVoqNZwQgOa3xU30nUkjlXALnWSlAUukCHJi3VBMGrwCiv
         XxnrOTXgdzPMYicOnZ8Fb80NIwRXov9Kj0PYj1jzbgIv3+a8uucIufUzND2YLQyWYE6Z
         jSdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9xW2RAozY9Oerpo5uMPbcRGMc0PrWwrCZHc0hIsSNXM=;
        b=sw6nrfBCxgaj+MKB/uTDWVFMiDT97pn1vRf4Z+GOrx+m+OyngQ3natc2DfOSLc/41E
         NYbthBoSQav9ManZ8ctzznDeGlHFj86PigjVuGDP4Hn5W8U4rdbYmBhceWod8CQXQLj3
         +Utd87c2PlZJpLtwHmI3ojZnPrZcrUuCaYpOR4Ekas8wt0nS3qcb+oUTqGeAT7OqxG0a
         E0OF1zQMa57lKc4/f5BO1bSM7/DRGMRHW/yNLx4kQUgYeN2bI3h3rpzDs5FR0w9KMNAa
         q5/a2kZawT6vqgOt7eSCxYwg1MihxSwzgJgE1zFLq8bRhwiCwqm2So7E+yLDxXJcb1JE
         /dKQ==
X-Gm-Message-State: AOAM531n/rigioTGD/nTz1b01lLnCJl19ifeuHqg42AmrOCWDRWbwV8X
        Ow2zWepCUU8+KVJ7Ij8H+v+kC2XLv7w25RYP
X-Google-Smtp-Source: ABdhPJzQXqHq/K63cV5mSvlbNVklkm9t+DbmjlB7ce00fG9WJB5TDHS12sNv8LNUc/9i+TLDWh0y+A==
X-Received: by 2002:a05:6638:3729:b0:31a:1376:5226 with SMTP id k41-20020a056638372900b0031a13765226mr16982562jav.279.1648584856375;
        Tue, 29 Mar 2022 13:14:16 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v3-20020a5d9483000000b00640d3d4acabsm9606316ioj.44.2022.03.29.13.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 13:14:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: defer msg-ring file validity check until command issue
Date:   Tue, 29 Mar 2022 14:14:10 -0600
Message-Id: <20220329201413.73871-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220329201413.73871-1-axboe@kernel.dk>
References: <20220329201413.73871-1-axboe@kernel.dk>
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

