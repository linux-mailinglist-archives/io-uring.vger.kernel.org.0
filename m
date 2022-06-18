Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5942B55046D
	for <lists+io-uring@lfdr.de>; Sat, 18 Jun 2022 14:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiFRM1x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 08:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbiFRM1w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 08:27:52 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BC414D3F
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 05:27:51 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id x5so9360095edi.2
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 05:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rPbDMmU1UGYHYl+q2IBIBpk2ynlpuEq9WJoKlAhIFFM=;
        b=Zx2j9qVE0CuXsmY9OYWr7UmgFrCCx2eAUbPDWxKCeEwVIg5itxq3UZmZRVmcl8QKdB
         jhIhZSabOLTDS+ZR2O+mWHlTQksRoykI2G9vtXp0+tvNGFnyLD2iwrExaz3i8avtyeKc
         CDEjA9Hg4DyJZ/FjvRXwS/LCjucBjxZ4W9FAlGZ8c5UqTi4nK4MFY3apheRbYKPXCJig
         Idyg52MC98y/x0vV56B0dfNWgXChSO72Ipgew6ZAh9SNHpWtRap/fSLVrx6kf/1zZaK8
         3PM8f70tBySMvsQBGU4nHy7YyUl3211XXhO3KWsvhuMQgaNWu00ElN1beXrDXBdJ7zsF
         VGmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rPbDMmU1UGYHYl+q2IBIBpk2ynlpuEq9WJoKlAhIFFM=;
        b=4AOEFg8tbTjpHTDpEbtZxQNbdH5q2hgugk6RIfKMXLqJhFFdiB4ZHlo15QNI4Lxzx3
         c7lMupEtPqVQTL5lpExpN+bq0FUGGMBsJEfrRRNOB7IkPnKvbPZXYpPzIwi34FARKUp5
         ZgvchR7JN6AjZRRw/JCxpujWdT1nx956QoaxeJ9RGB3iF13w2AwS3gsLRbmtIKfXJmQL
         /FS5CmzgV7o6AtJgF05DygHcmcu7QsJ6uR7kQvyaWRgKpAv/DbNX2Usrm5yiPUnM9Z62
         y4+rQdTWMKA/1S3veAIqZ5w7Bu/0tjJR2+iqyKmic/Z4L9O3b/tkjUvYhGYyZ5rDj8zd
         h1ow==
X-Gm-Message-State: AJIora9OHj0Z3lOuimH3p7y0ugTlv0ryqWsVOPJmRDd+Mr7hTRcsya5n
        FBvTYhsOjUZMQ9GN5Ys0To1cQ0YSR2Uc9Q==
X-Google-Smtp-Source: AGRyM1v/xo6P1jEglW565d5w+UwN3jQaB+1zLB6qgQOkIUsYbfFw6yWtLSLcUXFxci3kCEndc6QawQ==
X-Received: by 2002:a05:6402:1f02:b0:435:4a90:ec8e with SMTP id b2-20020a0564021f0200b004354a90ec8emr13632556edb.131.1655555270197;
        Sat, 18 Jun 2022 05:27:50 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u23-20020a056402111700b0042dd792b3e8sm5771523edv.50.2022.06.18.05.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 05:27:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/4] io_uring: opcode independent fixed buf import
Date:   Sat, 18 Jun 2022 13:27:24 +0100
Message-Id: <91c8eee9239cdb54f29ea5c7b09de985ad4e9f71.1655553990.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655553990.git.asml.silence@gmail.com>
References: <cover.1655553990.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fixed buffers are generic infrastructure, make io_import_fixed() opcode
agnostic.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index f5567d52d2af..70d474954e20 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -273,14 +273,15 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
 
-static int __io_import_fixed(struct io_kiocb *req, int ddir,
-			     struct iov_iter *iter, struct io_mapped_ubuf *imu)
+static int io_import_fixed(int ddir, struct iov_iter *iter,
+			   struct io_mapped_ubuf *imu,
+			   u64 buf_addr, size_t len)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req);
-	size_t len = rw->len;
-	u64 buf_end, buf_addr = rw->addr;
+	u64 buf_end;
 	size_t offset;
 
+	if (WARN_ON_ONCE(!imu))
+		return -EFAULT;
 	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
 		return -EFAULT;
 	/* not inside the mapped region */
@@ -332,14 +333,6 @@ static int __io_import_fixed(struct io_kiocb *req, int ddir,
 	return 0;
 }
 
-static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter,
-			   unsigned int issue_flags)
-{
-	if (WARN_ON_ONCE(!req->imu))
-		return -EFAULT;
-	return __io_import_fixed(req, rw, iter, req->imu);
-}
-
 #ifdef CONFIG_COMPAT
 static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 				unsigned int issue_flags)
@@ -426,7 +419,7 @@ static struct iovec *__io_import_iovec(int ddir, struct io_kiocb *req,
 	ssize_t ret;
 
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
-		ret = io_import_fixed(req, ddir, iter, issue_flags);
+		ret = io_import_fixed(ddir, iter, req->imu, rw->addr, rw->len);
 		if (ret)
 			return ERR_PTR(ret);
 		return NULL;
-- 
2.36.1

