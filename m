Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D618550DDB
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 02:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237275AbiFTA0k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 20:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237232AbiFTA0i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 20:26:38 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCA0AE4C
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:37 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id z9so4950554wmf.3
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FZbSkQcF8WKaKzAWuyvvIgaKpdT68ONaojO6bijpIdg=;
        b=KGGCMpBN+ZRwFco3VwRKsdOKuicU3IHbMFnvuVxqcV3XiDVtGPbeslUMiy/jvBKt25
         KmgXQSompYgdCkNMq2MnpvnTPDO/MjEKAtaGyXAKm0zbNK0Gf/jDLLalYvYutE4+F1oN
         z+Bpf/qWbxhM/4NAoNPv1d8h1pemJpSeVK1nnL0i3Wd8J9heq2pfPXY4Zf0jslHQGqSr
         +45bYtdUhOxeXhNTOTx0bXFPv4+S7eQRw5t3+f27SZDlKmPgxz0li4aW2lHHq6ClEuKB
         3jm9qZVwNMaBUXM4hYIxje6Yvsu3ghZbCOyNmeGgEK8waT5cWFWRWWCex59KFLbsDgWJ
         3K/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FZbSkQcF8WKaKzAWuyvvIgaKpdT68ONaojO6bijpIdg=;
        b=EyOFWznRZ95Fz7MxsI2C9PWun5DY7yZTGQ7uKQSnsv2e6T2HcUpqX+Ne5PLt9m0hlv
         ObrLU9cxtcoK8m+A75d3ik8gFB6PITYPeNf3i8NqQyuNeOk7qyNcP/smmjuUT26er8ie
         yruO9d47IXL51NC+7sP+ldRkft0MFlcNcz3notJdHPlYnWmIgM5nfKxbeCoQZFo4B1lH
         cCElJp19CTBWpAQYu3vTRS4jzYqEfkxHOfr6FoapzThlfhpGYpvCb7ieYROWCuD1GiHm
         wVqTf8uphHC6TjoKOB6+v7t8fiQIyEQiENwAdJdz2+k4CT5GKTE3NLQX6FyfuNdYWCf+
         hAGA==
X-Gm-Message-State: AJIora9vl5jpa6GSB0cgpkeIgneLBdEJFtbSuScUU17KsOLWSudpiKzG
        4U1rFe60usn5ZIsLj9fl21a5h2eZUM8OKA==
X-Google-Smtp-Source: AGRyM1us/50M9rJOXTqsU0sHOnb/z9M610fSQW3PFmOTTX4jKZjmAQrjidURsXHAmqeyDsIgP/gELg==
X-Received: by 2002:a7b:c856:0:b0:39c:3b44:7ab0 with SMTP id c22-20020a7bc856000000b0039c3b447ab0mr22190582wml.117.1655684796844;
        Sun, 19 Jun 2022 17:26:36 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d4312000000b002167efdd549sm11543807wrq.38.2022.06.19.17.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 17:26:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 06/10] io_uring: add io_commit_cqring_flush()
Date:   Mon, 20 Jun 2022 01:25:57 +0100
Message-Id: <0da03887435dd9869ffe46dcd3962bf104afcca3.1655684496.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655684496.git.asml.silence@gmail.com>
References: <cover.1655684496.git.asml.silence@gmail.com>
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

Since __io_commit_cqring_flush users moved to different files, introduce
io_commit_cqring_flush() helper and encapsulate all flags testing details
inside.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 5 +----
 io_uring/io_uring.h | 6 ++++++
 io_uring/rw.c       | 5 +----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 82a9e4e2a3e2..0be942ca91c4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -529,10 +529,7 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 
 static inline void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
-	if (unlikely(ctx->off_timeout_used || ctx->drain_active ||
-		     ctx->has_evfd))
-		__io_commit_cqring_flush(ctx);
-
+	io_commit_cqring_flush(ctx);
 	io_cqring_wake(ctx);
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 738fb96575ab..afca7ff8956c 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -229,4 +229,10 @@ static inline void io_req_add_compl_list(struct io_kiocb *req)
 	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
+static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
+{
+	if (unlikely(ctx->off_timeout_used || ctx->drain_active || ctx->has_evfd))
+		__io_commit_cqring_flush(ctx);
+}
+
 #endif
diff --git a/io_uring/rw.c b/io_uring/rw.c
index f5567d52d2af..5660b1c95641 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1015,10 +1015,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 {
-	if (unlikely(ctx->off_timeout_used || ctx->drain_active ||
-		     ctx->has_evfd))
-		__io_commit_cqring_flush(ctx);
-
+	io_commit_cqring_flush(ctx);
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		io_cqring_wake(ctx);
 }
-- 
2.36.1

