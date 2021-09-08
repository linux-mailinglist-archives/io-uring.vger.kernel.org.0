Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB734404002
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 21:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbhIHTvH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 15:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbhIHTvH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 15:51:07 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026D8C061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 12:49:58 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id n7-20020a05600c3b8700b002f8ca941d89so2384624wms.2
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 12:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NpKU+J0ddPeFpOZqnVHJHzq7e8KG4lH/tgzt/hXJT3c=;
        b=Mg57URcniNZD+QWoUS3Uf84AB2m6cMGin7DY1E9JDA4vtsQtkkGjWo7UyEhXcKF+X8
         F9VV+cAOsiXxMRGsN3jrWgwKy3Wsa9NNgyH/TfUqfxXGbbtXtvYzBE6w7Xg9vNauU872
         yNR3QVtqnWNHAxVBeyO2DqC96AE5PPvnaTQip1aHW2a0jOg0XzDOX2oXOj7hGo36O7Bt
         0xOJg/04KU6/2l1pAEYDehjqJc2BpyP3FlIEVtDLvLqvdfAwj5WDpH658dOOWaCxyeyi
         8YMVZQ0I09vTYLjEy37aroBKlf0ZppIlRfsdaS92SwLJR1Fa7grOSxUq4ECkSEoAnfHg
         RgEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NpKU+J0ddPeFpOZqnVHJHzq7e8KG4lH/tgzt/hXJT3c=;
        b=DqTaxwczMXFTrcgt2BG8/jOBfDYfAprYFsjdk4uL3MiPdxrhI3YEUliPqDj8UelGYD
         ouCI9zeL1lCqVNyn8vQ/tjPe2dk/CL7H+9d7+QSMypv+PqDSBUOEJGbm2qr/5IJbo0Zd
         1w27xRwFnZ4mrPFps3FUr1Dn08P+w4jBUS3fZrv6lKeXdCBv3mo0maomNR0Vifxg9Sky
         Ml08RZ7lwU+2PGgZY+Ro24Jzd1kEimL7mNbP1+XfXiI90oxjcWJMVHtd2+jN/2aIDtv8
         t+oYetz0eNqGYNVXMtWZLPElIugaBaYfJOGSyUrYdIr9yiQNrOA1jOKXQ8oJZ7FLYmsZ
         T9Nw==
X-Gm-Message-State: AOAM533pG6JfygoeyIcWvEWeMNJF90xTeTLu6ph7LWqfxdjRcR3dD+0x
        4Z2wX5Yl2+UXmYf697zIIxSFtqTZ+ag=
X-Google-Smtp-Source: ABdhPJyIRI8ZqRHsvvS1mbMco65x1mnpHcAtD06qPOb5iTV+WwtWNeviiCsVrGHOy1gy9WVXh9sd4Q==
X-Received: by 2002:a1c:f414:: with SMTP id z20mr5328963wma.94.1631130597588;
        Wed, 08 Sep 2021 12:49:57 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id x21sm2999825wmc.14.2021.09.08.12.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 12:49:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: fix missing mb() before waitqueue_active
Date:   Wed,  8 Sep 2021 20:49:17 +0100
Message-Id: <2982e53bcea2274006ed435ee2a77197107d8a29.1631130542.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In case of !SQPOLL, io_cqring_ev_posted_iopoll() doesn't provide a
memory barrier required by waitqueue_active(&ctx->poll_wait). There is
a wq_has_sleeper(), which does smb_mb() inside, but it's called only for
SQPOLL.

Fixes: 5fd4617840596 ("io_uring: be smarter about waking multiple CQ ring waiters")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d816c09c88a5..d80d8359501f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1619,8 +1619,11 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 {
+	/* see waitqueue_active() comment */
+	smp_mb();
+
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		if (wq_has_sleeper(&ctx->cq_wait))
+		if (waitqueue_active(&ctx->cq_wait))
 			wake_up_all(&ctx->cq_wait);
 	}
 	if (io_should_trigger_evfd(ctx))
-- 
2.33.0

