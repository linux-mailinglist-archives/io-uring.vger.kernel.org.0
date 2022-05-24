Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C76533303
	for <lists+io-uring@lfdr.de>; Tue, 24 May 2022 23:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241934AbiEXVhl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 May 2022 17:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241933AbiEXVhh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 May 2022 17:37:37 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBBA7C173
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 14:37:36 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id a13so6427264plh.6
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 14:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ph/WGOZONVdcjHqgTL9D/tGOhRzea7cIQH6mVWqydo8=;
        b=xy3mYHsL1dqcx8FBLuNKKV0mHqOwHXhMKZLC7hXb7tgqADMhEJyxgVgrVG/1rjsN5t
         4ZtV5B+iVGMva/LTa75Ha6c5Xk6hr9EW16If4CPJ1bolQxtharcRIRyX8WWlRv7KmD85
         u1G+d5wE96GvsKhII5Ufb7i4DO5sptEJiDoygRx0CqU/pmSiK8w92FQJC4DrWjkSNPXB
         jTTf9XKcXvZ7qQB3KHfIQxwh4yrW8LTBiWyMYOUKDwRmbw3SREiMUPxDUMfNyNXjQtks
         tvI8any3vVxpr1Pwm8ZbJJcUDmdEX+D3+XjZzc3TAnekhTEF/SLa0ftdkRzSuhpwOxg2
         f24Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ph/WGOZONVdcjHqgTL9D/tGOhRzea7cIQH6mVWqydo8=;
        b=gJQuxymWsAIV8fou8s9m2mDz1xkRg/cSaUxSGKQXB9ovtxns18Rt00p/tkmnN023pN
         5K2E4xJqSWQH0xlKdgDj11DgaF5p/blSa2XjuO/fG7WoZeEHMJuhLZlqPaWWIsLeRd7N
         lFFInrrKGHC5mMkWk1ntU5lJTcHyhd8B74DBNKjq4lnDdrb5XR2UB6CjthS5B8qh475m
         unY5k1L7iAjZzn/7OlsxQV+qcTniEMGo7sXLsgtm5KMqPgopOb5Fz7YCSa4L5oQ+BdW5
         54laYkSCD8oroG/9vmIVCR5LgBNjDpzcS48lGS6VYj8Aq/woJb6rXbCRadOS+60+jWIy
         rgOw==
X-Gm-Message-State: AOAM533KNJ2TvhnRcxl2DSEiV8ujEEuaiSPejm+KPnKibwNLnvaTZLHW
        835UDx+mXhVNQJFK+hsTsk+ol4GkljUENQ==
X-Google-Smtp-Source: ABdhPJw67HrZxvH7U+54uGxJF1XdB9aMjTAcxwhCy+RZeOyZ98vc74CwU47O+CC4R5o6nwfQzLiMhQ==
X-Received: by 2002:a17:903:22d0:b0:162:bc1c:d700 with SMTP id y16-20020a17090322d000b00162bc1cd700mr2225193plg.105.1653428256191;
        Tue, 24 May 2022 14:37:36 -0700 (PDT)
Received: from localhost.localdomain ([2600:380:4a61:523:72ca:65a5:f684:5e4])
        by smtp.gmail.com with ESMTPSA id k21-20020a170902761500b0015e8d4eb1easm7834327pll.52.2022.05.24.14.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 14:37:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring: unify calling convention for async prep handling
Date:   Tue, 24 May 2022 15:37:25 -0600
Message-Id: <20220524213727.409630-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524213727.409630-1-axboe@kernel.dk>
References: <20220524213727.409630-1-axboe@kernel.dk>
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

Make them consistent in preparation for defining a req async prep
handler. The readv/writev requests share a prep handler, move it one
level down so the initial one is consistent with the others.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d2c99176b11a..408265a03563 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4176,6 +4176,16 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 	return 0;
 }
 
+static int io_readv_prep_async(struct io_kiocb *req)
+{
+	return io_rw_prep_async(req, READ);
+}
+
+static int io_writev_prep_async(struct io_kiocb *req)
+{
+	return io_rw_prep_async(req, READ);
+}
+
 /*
  * This is our waitqueue callback handler, registered through __folio_lock_async()
  * when we initially tried to do the IO with the iocb armed our waitqueue.
@@ -8136,9 +8146,9 @@ static int io_req_prep_async(struct io_kiocb *req)
 
 	switch (req->opcode) {
 	case IORING_OP_READV:
-		return io_rw_prep_async(req, READ);
+		return io_readv_prep_async(req);
 	case IORING_OP_WRITEV:
-		return io_rw_prep_async(req, WRITE);
+		return io_writev_prep_async(req);
 	case IORING_OP_SENDMSG:
 		return io_sendmsg_prep_async(req);
 	case IORING_OP_RECVMSG:
-- 
2.35.1

