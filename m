Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5051654DE1C
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 11:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376618AbiFPJW5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 05:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376658AbiFPJW4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 05:22:56 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CF218B22
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:55 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id a10so422660wmj.5
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ROudprvWUcWfvZ4cZzMiGRRFxKziH9KPUlRbWRK/uOQ=;
        b=k5zKmDzuu1oD7DtPkEmYzle27J8WXkk4X8Q/FZKoXLTsKw+FmC9+62jQ/Z47ZOzOzJ
         fbWgF9g6NNyi2kc7FygAxwseyuXzymGnBR1KFo7ZEOsEkYO4vx82RMXiL/g0ljGpzb6x
         wKw1E2uZJEcamOlKdumzAj3FrbatOJDuz2ln5gC9ILAXjFTn9tgJo8uJZQVlWDEc6Y0r
         hYN4p4MNzKYEgn8wZe6zfvS43GRGA1HuPFiMc5ZSVKHS2N+ggNd4j7baiQwD7NA8Q8Vt
         Thi+SdThj0puZqtwUsn1+bArS/AXXmGe2U6oJEUg+KCFJ53RPWstYax5EYbQVWWcKr+I
         MDeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ROudprvWUcWfvZ4cZzMiGRRFxKziH9KPUlRbWRK/uOQ=;
        b=3HHpixPIcPOUC4a6v+/9LehrOonuKuPwghTj4acnKc5hKJ3IergvE6bXcUbLLtOy6k
         Y0gCN5wRHNI19hag+OnQ6QvA/YU1auDmaaH7BjFQHQKwZqxQQM+P4u/6wFKJSDoVd2i5
         OSNDX6BsZ2KskJ1V1kCZEQnwt9P7XV3WUFU0dglGxqG+D0mBllIoZeuUKcierJ7qFN0I
         IS8j/f3Sk5qSKR4osigOA7d/FrstGd6rz6A5DP4CpMMb1SMpu1rwjB/kUuaGaEiHPj3f
         hQ2B7liGCd6IJlLuh2Hir3doKyXim+NLTV8alPNPBxlTXklWz82F1Tv43mMtIjTQ4r+b
         Zzhw==
X-Gm-Message-State: AJIora9KiN5FY13tRChqCiJqMSsfSEPYdfHnPucVndRmvBOVicNnrM2a
        D+H3DE0IQkhNFqivHzyGp2766CYSQ4priw==
X-Google-Smtp-Source: AGRyM1vOn+u+U4Pz/ZWUx54MJ1ZLVXc8b4NB3NumBNUkf5inJnC3LZlx0B4n6B4yo6LNajeYEj1Y8A==
X-Received: by 2002:a05:600c:3d8e:b0:39c:573b:3079 with SMTP id bi14-20020a05600c3d8e00b0039c573b3079mr3957780wmb.131.1655371374881;
        Thu, 16 Jun 2022 02:22:54 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id s6-20020a1cf206000000b0039c975aa553sm1695221wmc.25.2022.06.16.02.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 02:22:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v3 11/16] io_uring: use state completion infra for poll reqs
Date:   Thu, 16 Jun 2022 10:22:07 +0100
Message-Id: <ced94cb5a728d8e386c640d052fd3da3f5d6891a.1655371007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655371007.git.asml.silence@gmail.com>
References: <cover.1655371007.git.asml.silence@gmail.com>
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

Use io_req_task_complete() for poll request completions, so it can
utilise state completions and save lots of unnecessary locking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 7fc4aafcca95..c4ce98504986 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -234,12 +234,8 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 
 	io_poll_remove_entries(req);
 	io_poll_req_delete(req, ctx);
-	spin_lock(&ctx->completion_lock);
-	req->cqe.flags = 0;
-	__io_req_complete_post(req);
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
+	io_req_set_res(req, req->cqe.res, 0);
+	io_req_task_complete(req, locked);
 }
 
 static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
-- 
2.36.1

