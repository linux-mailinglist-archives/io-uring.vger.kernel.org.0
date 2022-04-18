Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAE0505EC0
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 21:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbiDRT4U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 15:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347775AbiDRT4U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 15:56:20 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4975A2C66A
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 12:53:40 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id y20so8601366eju.7
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 12:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8oUBP2573KGcKfmYGv4PyBxy1OXJ3dbbyhiWIov58rM=;
        b=SRnamzRE/P/tvNQtp5xMJ60rvRR4rRxOXVTMTf9sxZjjw9Wmp1y0+xsTw3QUZ4IIa0
         nXF18ls8z8BUC1FSmnqQw4et2w7S4YxnTgW33sB9ei3q1lEYyquTzdJ7FJdOF2cMhBcT
         QWd+zywXKKHfcv9O3Lk4rINRUGYU3Vma3UmYWZDtQzkSyyJ4pg57Heop5xUVlv1AGwbg
         VWIS0/j3GLCvB3QgVfHBYI5KIfj//gLjJvc/azApEmq1V03TAKIiw9lnevJtaBOHTxh2
         n+aWJHLzOIGp9aSI3k2yYzPatLt0FMu2AhYRxLuPenPf3TBPrxuDo1S/u1Wj1cbTwJoI
         mlhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8oUBP2573KGcKfmYGv4PyBxy1OXJ3dbbyhiWIov58rM=;
        b=H+s198vcR+Ywd/9hLMwwF3gaUrwGteuaJtaWDEzi6a4igKUEpuQsW81kYueZ3AW1As
         p9gpN+kotww6wUlO743QuyhDgVhxxV9896TEkrk2OLcI9zG0QO0lG6dza3LV1mNi8Rms
         pIVI7E0/HYQnh4iGFF5EE+uc/t4IGC0QFirSItx9tvsTlslfZMi9eAv29Y8jxM3VuaAD
         QN/E3y/EVP0oIZpgKLUIEyYwWsRF+4InWRr3Nce+ZCcD6e2uT+NXhadHKT4bwLZG1sWw
         BdLLOJ4hbje71DELB15m0/ZgVR07xxb2dW8ibS0Avjzt+XasgpxJHcA/ammJEfbngWdR
         LXtg==
X-Gm-Message-State: AOAM532OUEoeft5Ynp5F8RfkEHH2JFtsZch5jMcgZLb4kQ1ltrIuU1vf
        ZnCAb5IlClgqvs7z+l7/VssU7skx2Z8=
X-Google-Smtp-Source: ABdhPJwn5M9Gd2CLAFaYjliUm7pd8TfrnoT+CCAei465cvEsBL7961HlTOpZftiXyP4CdR+PSSYirQ==
X-Received: by 2002:a17:907:94c9:b0:6e8:ab67:829e with SMTP id dn9-20020a17090794c900b006e8ab67829emr10120857ejc.313.1650311618612;
        Mon, 18 Apr 2022 12:53:38 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.70])
        by smtp.gmail.com with ESMTPSA id bf11-20020a0564021a4b00b00423e997a3ccsm1629143edb.19.2022.04.18.12.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 12:53:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/5] io_uring: refactor io_assign_file error path
Date:   Mon, 18 Apr 2022 20:51:12 +0100
Message-Id: <eff77fb1eac2b6a90cca5223813e6a396ffedec0.1650311386.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650311386.git.asml.silence@gmail.com>
References: <cover.1650311386.git.asml.silence@gmail.com>
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

All io_assign_file() callers do error handling themselves,
req_set_fail() in the io_assign_file()'s fail path needlessly bloats the
kernel and is not the best abstraction to have. Simplify the error path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 423427e2203f..9626bc1cb0a0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7117,12 +7117,8 @@ static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
 		req->file = io_file_get_fixed(req, req->cqe.fd, issue_flags);
 	else
 		req->file = io_file_get_normal(req, req->cqe.fd);
-	if (req->file)
-		return true;
 
-	req_set_fail(req);
-	req->cqe.res = -EBADF;
-	return false;
+	return !!req->file;
 }
 
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
-- 
2.35.2

