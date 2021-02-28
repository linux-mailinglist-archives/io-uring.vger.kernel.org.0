Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B863274EE
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhB1Wkn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbhB1Wkm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:40:42 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D73C061793
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:26 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id o7-20020a05600c4fc7b029010a0247d5f0so2130952wmq.1
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pLUQ3S58RPtJQqueaRWhq0vyEXBqA2EPtQpjuW3BPug=;
        b=rdmlA1kAsow961pV/Tajsgvh6+2I6ipmxgI1ywRGSxtr+BuynvVW06uGeQCnSJr9Wg
         HfPwRf2EbCgSKwu0X57Z8TbUBdCMVtGy/EF4fbvEkqj2YhaVPs+DsTQ6IhxPSj17ElM3
         TngMzUMs00vG/z/AoA5foMNQM7yq7kj/mg1asGwWmXApNdqAF3EY0a59opRYQgrQMAJT
         U7lqIK1vk8L6jM+0igFDiMEVO9CoGrbrPx67o66/wqrOBYFUoZ+nEPhuAi9Q+ExNZGWP
         dTAwp2aBP+Jgyj8y5Id5dCyqphmVZQX8qS8pOMFj2BRIBJOgfB8bmEXgCYk91RuWGS4Y
         sFLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pLUQ3S58RPtJQqueaRWhq0vyEXBqA2EPtQpjuW3BPug=;
        b=q6CANxhAaIIZCfBAccsZK7ihsJeOseq0yA3YA26WaTwGNL5sE22rIISsObAoLIZ0Py
         sHbV4V534Z+/XYZfNAHeijecxIhSgcFECKBcCoMkY+nkNfLbAnTjptfLolNGrfOBdG+9
         FoZASDf9/J7s7n8nHzvOPPWjDFZyVQZMmAfzdPhNalQPZvE+jLEBGIftb4DBAtW+9O59
         LjdJBf1orupttruoeYzXzpN/5imOE5pcqNT+lMsLfmhMiDMI43kXSAFYVntYo2Itpi6l
         CO5JAq4RTWxijZPT9NvrhQteewKV8G9bttNFkvGjh6p5RstrS/8oAQUkkQOppuQE4KYK
         bDVg==
X-Gm-Message-State: AOAM530GRjUGSekVk5a+2Ef/vrtgaLXtCSNBrzqTCodM5C41ms0sv8WY
        LQOHs9eQqY48fQ7Lg6cYcBPg7GYjsjsK5g==
X-Google-Smtp-Source: ABdhPJwZnSOHli4jaSGcLeTd55rAcVJf4yBTWaMEb5UsZdjrj+z3f5Zi5ZhGPO1Dnm56rSdU2HvYnQ==
X-Received: by 2002:a1c:b687:: with SMTP id g129mr12941485wmf.165.1614551965067;
        Sun, 28 Feb 2021 14:39:25 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id y62sm22832576wmy.9.2021.02.28.14.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:39:24 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/12] io_uring: use better types for cflags
Date:   Sun, 28 Feb 2021 22:35:15 +0000
Message-Id: <7faf8f279f47355614d6c23b847568cc2bc075e1.1614551467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614551467.git.asml.silence@gmail.com>
References: <cover.1614551467.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_cqring_fill_event() takes cflags as long to squeeze it into u32 in
an CQE, awhile all users pass int or unsigned. Replace it with unsigned
int and store it as u32 in struct io_completion to match CQE.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5b1b43c091c8..049a8fbd7792 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -646,7 +646,7 @@ struct io_unlink {
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
-	int				cflags;
+	u32				cflags;
 };
 
 struct io_async_connect {
@@ -1498,7 +1498,8 @@ static void io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	}
 }
 
-static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
+static void __io_cqring_fill_event(struct io_kiocb *req, long res,
+				   unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_cqe *cqe;
-- 
2.24.0

