Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C31F503149
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352042AbiDOVLy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 17:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350280AbiDOVLy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 17:11:54 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D802BE5
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:23 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id v15so11048757edb.12
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oA5JbrMKfCntZv509jVFWI/Lg2uRtPGkNyPufamMCAY=;
        b=hQmMZrhIZuzaOJPxeAExA16c9PltGhNBEfb/D5qejzwYpU/qTLR3Y6d2lzsnHk0DLk
         Rcz/JJvjWPcpOZLxwb4YwpIaLZ0W6Rvv7FxoBfx8qSqPDK1XapGULij9iY6KSg7Kk1dN
         TjzpIXuf6+dr90cyR9rxVEi+XdSvjnU/EbcHhPnsTqMDd45boyeErLVsDkfmgxFNn/rf
         ihYXcu/ibZIWUlGeCqhz4ypCwfI33eDSNSUhmz1w9CDVeRWFfRp515WNT+avbKe5IL0e
         aDVS2UtM8dpiZKzl3EViQtL3Gs3t/5ssYZkOxQnp53eaBA2W6ShXmY8TBzhkGO5T6MhD
         XCJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oA5JbrMKfCntZv509jVFWI/Lg2uRtPGkNyPufamMCAY=;
        b=UhKJ5H1AzlCMtAteiso7RnfmpNXRjj+mpU/xlDctRzJf9mm42TgiBjA5Fsyk7KTSPm
         5SiiFZWS3o69rk90SXn2VTponZT++AzExrXTL8ZaAQuKWkuWfj9JWmuAhRhaiq9iVeOp
         FhaU61hvla9WmzCOfwOK8PNrumekCGafKm4hj1PMsKRDRQrFPFN/7sNCwEiuhVo86jsa
         5p1N1axDFOSbEBgGJvcTv3cvjG69rS0hiwAsNuFLHxWrJLUhx9pM9qqlt1YB5skznNHU
         YG1Hwbj8v9z0KSbjYVSbgU/3/MOFA7Y6qQn8j7Psgkp2HlVITwh5+8KbK3YVERfKOTrm
         5v4g==
X-Gm-Message-State: AOAM5319F+qJKOa05HhecXh7vWWRFo/95b0stxLeyYR6yUHUuuY8AhLy
        K6jiF+NBJyGSwaICNkecFO6EG0P+cXU=
X-Google-Smtp-Source: ABdhPJyXRMbUzLKA5Vdrf5YVY6ihs0JzREVkucdZ/yxvTRTU8dEx0flBwvmTG6jeblq0mdHXkwG0Vg==
X-Received: by 2002:a05:6402:2812:b0:418:fc32:be18 with SMTP id h18-20020a056402281200b00418fc32be18mr960439ede.357.1650056962034;
        Fri, 15 Apr 2022 14:09:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id j10-20020aa7de8a000000b004215209b077sm2602938edv.37.2022.04.15.14.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:09:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 09/14] io_uring: refactor io_queue_sqe()
Date:   Fri, 15 Apr 2022 22:08:28 +0100
Message-Id: <9b79edd246336decfaca79b949a15ac69123490d.1650056133.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650056133.git.asml.silence@gmail.com>
References: <cover.1650056133.git.asml.silence@gmail.com>
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

io_queue_sqe() is a part of the submission path and we try hard to keep
it inlined, so shed some extra bytes from it by moving the error
checking part into io_queue_sqe_arm_apoll() and renaming it accordingly.

note: io_queue_sqe_arm_apoll() is not inlined, thus the patch doesn't
change the number of function calls for the apoll path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 71d79442d52a..ef7bee562fa2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7488,10 +7488,17 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
 	io_put_req(req);
 }
 
-static void io_queue_sqe_arm_apoll(struct io_kiocb *req)
+static void io_queue_async(struct io_kiocb *req, int ret)
 	__must_hold(&req->ctx->uring_lock)
 {
-	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
+	struct io_kiocb *linked_timeout;
+
+	if (ret != -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
+		io_req_complete_failed(req, ret);
+		return;
+	}
+
+	linked_timeout = io_prep_linked_timeout(req);
 
 	switch (io_arm_poll_handler(req, 0)) {
 	case IO_APOLL_READY:
@@ -7527,13 +7534,10 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
 	 */
-	if (likely(!ret)) {
+	if (likely(!ret))
 		io_arm_ltimeout(req);
-	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
-		io_queue_sqe_arm_apoll(req);
-	} else {
-		io_req_complete_failed(req, ret);
-	}
+	else
+		io_queue_async(req, ret);
 }
 
 static void io_queue_sqe_fallback(struct io_kiocb *req)
-- 
2.35.2

