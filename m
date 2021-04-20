Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F340B36570D
	for <lists+io-uring@lfdr.de>; Tue, 20 Apr 2021 13:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhDTLEQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Apr 2021 07:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhDTLEQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Apr 2021 07:04:16 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1052BC06174A
        for <io-uring@vger.kernel.org>; Tue, 20 Apr 2021 04:03:45 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id k26so20721866wrc.8
        for <io-uring@vger.kernel.org>; Tue, 20 Apr 2021 04:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=XpXMZ6rUm8S4yDZXHNTzE9Jh0bHOPTkuCY3hhHjda8Y=;
        b=AZGyWLcqFSay9AoBqkBaTXb6aNivd+SeGuB05Xna1NIKX6Vr8G8qGu1+QYGO27xkst
         Z1PAZvLSZjnlIAVARURCr0paLvcCY42viD3CtGwDNRCje+MQXOsQNKv2MIgKy0gIHAQ8
         +yRXGZOWA7EMuGMjBB9I79V8cS3YWYtEN4eQN01F8qpCTmeydxlQO3aMfcPfljfbFOcv
         wNJHH1oJ0U2Ina+0qaydmKaluAcb7F4ZvfVU/gUy1T5zvqALFFBTJGcQOl7VHVnmB4GV
         tiN5iRYFIUZJFKqSPsYwcg9Inhf2hcnCPheuYK4Bd/I+VWym7nvfihNdzZELCUfgtmmU
         vVBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XpXMZ6rUm8S4yDZXHNTzE9Jh0bHOPTkuCY3hhHjda8Y=;
        b=H33q+RGEZnHohLVoRWIyQtEaosF38NdemIN7GUYv1enYx82337twwn4fKnnC89rpIx
         gk7KKY2YBe1Lv5X2mgc5ZGqs72S/3hgdqT15ap0rWyeILFEm5yAyihMTqU7a7qscOQWy
         tTIZAYo9Ru8M+j4aZe4l9ycuJgU8XTEPu1GfrXL2Wwq19uYtlP7rW1qjCzki41polKWW
         CXiHkCRAI7rjjBE/STdCiMAgKxU1BbW0Fx4A4GAxQc50yZsmgmDVT8WSB/IInuMGbkS4
         vtHCKcudZIolbD9R/JNqcYl0arKfMKyQe6LIpzV0lkqAuH36VBLjxKvjicbe9dni8mI/
         zUvg==
X-Gm-Message-State: AOAM532HWEovtolHDc0xk7lwqVJ6tfiV92qSzEzfFWZS/Cx1sHWRSlgt
        mfl+ZWP06rawRV+N4/cDRqcb85qkMMSAkg==
X-Google-Smtp-Source: ABdhPJwNAM6BWuce1mTdoszI5+2kz13VbURfHp3lL3XMcEBzz8itDTfgpcx0qyFAvNYDAuWg/eP6PQ==
X-Received: by 2002:a05:6000:1786:: with SMTP id e6mr20129655wrg.243.1618916623907;
        Tue, 20 Apr 2021 04:03:43 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.116])
        by smtp.gmail.com with ESMTPSA id y8sm12899486wru.27.2021.04.20.04.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 04:03:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: safer sq_creds putting
Date:   Tue, 20 Apr 2021 12:03:32 +0100
Message-Id: <3becb1866467a1de82a97345a0a90d7fb8ff875e.1618916549.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1618916549.git.asml.silence@gmail.com>
References: <cover.1618916549.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Put sq_creds as a part of io_ring_ctx_free(), it's easy to miss doing it
in io_sq_thread_finish(), especially considering past mistakes related
to ring creation failures.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f8b2fb553410..482c77d57219 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7226,8 +7226,6 @@ static void io_sq_thread_finish(struct io_ring_ctx *ctx)
 
 		io_put_sq_data(sqd);
 		ctx->sq_data = NULL;
-		if (ctx->sq_creds)
-			put_cred(ctx->sq_creds);
 	}
 }
 
@@ -8422,6 +8420,8 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
+	if (ctx->sq_creds)
+		put_cred(ctx->sq_creds);
 
 	/* there are no registered resources left, nobody uses it */
 	if (ctx->rsrc_node)
-- 
2.31.1

