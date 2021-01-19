Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BDB2FBA74
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732409AbhASOzD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394355AbhASNhW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:37:22 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E94FC0613CF
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:37 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id u14so12532707wmq.4
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0tKxlt57/ZdOLpHXDj7tUhK1bHGRoROTbR78zRIDZKw=;
        b=W1rurioM9X9xhktuTBUMBbFBn4nAZT1CP/1e0ZWK5YM9TutFz6GdsI8y28s67s8zHT
         n+pKBHEuVxsqdF7VhWi9bWGY3rlpLzmbQ5ngMeZRX5MhZ8fbIi7m0dEYQp2cmtHL7HSE
         fW9OTbZXgJcvCqnF3qukBlmtLAZMOQiG4x8dcIM/5PuuTGkSO72pmgItoIg9QQSls13a
         oUCOeE2DSBAYtueL4x2ywGLoYuVv3xp4HSNivLvRJ/vFZdM/61JcVjHkr0t4hBLPJ25e
         PNr9OJQ0a/4MTf4XSLVvcj/eC0LT+PP3BcMcfHwyCrHjHXy9z+qeLEgO/vruwrfvUlqo
         +vRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0tKxlt57/ZdOLpHXDj7tUhK1bHGRoROTbR78zRIDZKw=;
        b=A9/CAuey/3c/EZvvZ9aFFB0OaxV7t9GN907kTeHC8rRup8DnLT1DE4orBEGbW1RW+f
         nIuLm2ruozGADO/Cp1IODYlSbnC87uRAukdSuFzFcYQg1fyXZLOfHSRLkXxXghcEiwaf
         p5SnCHhLQ1dzFlQE/bZ0iZqo9lz92e5fSrWCs/R4rayoF73kemF07+G4Iwzbkrt0xCdn
         o+cYaNrDPEyqjZ+Ar9LAAUkPYY6ip1RA4qe54tCDJXjbpoBobxt954ShZKUsL1akSff3
         vJAHTx5ABzYbPTBTG0QYKRCF2UsCqJTfukbMapu012fixWHz3tnYDfPf4oBIUoN4U+dx
         CmDw==
X-Gm-Message-State: AOAM530yB6hByLPYBiEoOp+0M9fzCWrFGl+hJNMqvd9sEtNsSEIZdkiX
        HsLNvPrtQ99DRBI/1JYjGRjVYa63f3FCKw==
X-Google-Smtp-Source: ABdhPJxlwIYjvGqZBmZCH+l7FtGla7iu9gCEGkEmB2JAfevCPSweYgTQGZeGNeK7tynm8iAQdy19jw==
X-Received: by 2002:a1c:2586:: with SMTP id l128mr4177424wml.78.1611063396253;
        Tue, 19 Jan 2021 05:36:36 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id f68sm4988443wmf.6.2021.01.19.05.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 05:36:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/14] io_uring: inline io_async_submit()
Date:   Tue, 19 Jan 2021 13:32:37 +0000
Message-Id: <4ab0f1fa7606dccf2f7edc0c2f4a89da6d489061.1611062505.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611062505.git.asml.silence@gmail.com>
References: <cover.1611062505.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The name is confusing and it's used only in one place.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 88786b649ade..36be2b2e0570 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1257,11 +1257,6 @@ static inline void io_req_init_async(struct io_kiocb *req)
 		refcount_inc(&req->work.identity->count);
 }
 
-static inline bool io_async_submit(struct io_ring_ctx *ctx)
-{
-	return ctx->flags & IORING_SETUP_SQPOLL;
-}
-
 static void io_ring_ctx_ref_free(struct percpu_ref *ref)
 {
 	struct io_ring_ctx *ctx = container_of(ref, struct io_ring_ctx, refs);
@@ -6923,7 +6918,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		}
 
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
-						true, io_async_submit(ctx));
+					true, ctx->flags & IORING_SETUP_SQPOLL);
 		err = io_submit_sqe(req, sqe, &link, &state.comp);
 		if (err)
 			goto fail_req;
-- 
2.24.0

