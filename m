Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226733608FC
	for <lists+io-uring@lfdr.de>; Thu, 15 Apr 2021 14:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbhDOMMY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 08:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbhDOMMX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Apr 2021 08:12:23 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50976C061756
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 05:11:59 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id w4so19343739wrt.5
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 05:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7/m2ZBBaRkm1HUknunA5WxYgW4qU30rcHxz45mCYf8o=;
        b=h3Iwhw/AIpmoAw/ZWZTH/2fAgeLlN9mGiJo42qj9IiQ7oP18yh//kvxMlLIjEyaclw
         ZmTqP81HDZ6zVuJnUotgmg1XmGDIT2X41JmX7mHH0JwMT9hL2i9wVOQLtT5vE8zahIng
         5K6gVu0HARzMk6JZ52HoBgYKoCa6x42UAmTBKtWNEDHjswI3VH+rrjgk6lCkv/tdHFkb
         sBgfeSZX9aaa3iMraJNGdKu+ZYERQiU8dWqIJJLIyXIRuJBq1Ig9UncYNQJidRwU2XAk
         nYsmjehkAR4dR4Jb7gkBh1Ir3vUFHfrLw2C4F1MYRkoqA2l++mG0s2JGKCJ7Js5skQGA
         Mysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/m2ZBBaRkm1HUknunA5WxYgW4qU30rcHxz45mCYf8o=;
        b=TtxzPzXZTLlCegm42wJ3aX5Nxeed1lv/C5BJimBRZATP4tntV1932Bbx3uBAv6cqPb
         xu0omAwu/qFjE9FN2TNL1XyTYqUgVE5Mv/+kyZwKtx0WdjwADa1tSGu/93Q4UvmgtIp5
         fCo7hxENk3WkRGMBPP4acKlAXkk8/fyNOfPvAF4r2hzoqzJtlVo/6K0D0Jurj4c7dWVb
         7s4o3hPve5jVATLqj1M3DPm4vi62uDjvKaDhibAzz6Ajm/8+r3W9nw7820Vde1dNjCQj
         gMkiAtPV9KColsMYX3k8IWQV+UHXLkqQfI55HBRsr4bkFZdckwi5wr0jKU3y4JzIVLXV
         SGow==
X-Gm-Message-State: AOAM533Vaffy0efnnXDNWFgoyPZqrfzVFIih+6tVvY8AjI5vq5QGV0SY
        NJkvffEeTVvlE/vtngqhyRmVppRl60UHUQ==
X-Google-Smtp-Source: ABdhPJwnir+tmXtwQxYBKiwMJMYImR3iuVuCIZqdrOGXw5UUaqiTWhx5pwXMLd+Kpvl/IQrDjCiQjQ==
X-Received: by 2002:adf:c70b:: with SMTP id k11mr3195553wrg.165.1618488718170;
        Thu, 15 Apr 2021 05:11:58 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.21])
        by smtp.gmail.com with ESMTPSA id j30sm3015275wrj.62.2021.04.15.05.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 05:11:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: check register restriction afore quiesce
Date:   Thu, 15 Apr 2021 13:07:40 +0100
Message-Id: <88d7913c9280ee848fdb7b584eea37a465391cee.1618488258.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618488258.git.asml.silence@gmail.com>
References: <cover.1618488258.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move restriction checks of __io_uring_register() before quiesce, saves
from waiting for requests in fail case and simplifies the code a bit.
Also add array_index_nospec() for safety

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b57994443b2c..357993e3e0d2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9764,6 +9764,14 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	if (percpu_ref_is_dying(&ctx->refs))
 		return -ENXIO;
 
+	if (ctx->restricted) {
+		if (opcode >= IORING_REGISTER_LAST)
+			return -EINVAL;
+		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
+		if (!test_bit(opcode, ctx->restrictions.register_op))
+			return -EACCES;
+	}
+
 	if (io_register_op_must_quiesce(opcode)) {
 		percpu_ref_kill(&ctx->refs);
 
@@ -9792,18 +9800,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		}
 	}
 
-	if (ctx->restricted) {
-		if (opcode >= IORING_REGISTER_LAST) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		if (!test_bit(opcode, ctx->restrictions.register_op)) {
-			ret = -EACCES;
-			goto out;
-		}
-	}
-
 	switch (opcode) {
 	case IORING_REGISTER_BUFFERS:
 		ret = io_sqe_buffers_register(ctx, arg, nr_args);
@@ -9877,7 +9873,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		break;
 	}
 
-out:
 	if (io_register_op_must_quiesce(opcode)) {
 		/* bring the ctx back to life */
 		percpu_ref_reinit(&ctx->refs);
-- 
2.24.0

