Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D567342354
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhCSR1g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhCSR1F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:27:05 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729CCC06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:27:05 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo5644456wmq.4
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sJTozzqcOzl7PM3qCNKJxFBbc/qoQ25JjRUMPeSA9Lg=;
        b=bUDHb6wIMD8l0k1z6NP7yWxa7Zk7V88DbUHGltUUY8mEPuxW7pIeaQa2+Lo6pEDM9O
         UXb5vWEhCjCGKTKQCdpTEtcRr90YblpZftB7Id/3AM4NWmV6qp3YlbAKSCXPkFupkXSO
         4DwpCRkZr59d0zYS/RszwDVKH1ijjpQm6pKzYP4nMFZPJyXPr+jEfVJRpYz/ecSDEhMU
         w0Ui4AuuOTppOYmkJVbJjnI7TwANWg7rXMoyUNSGoDWNYteij3h31pR4h0JzBfARiiGm
         NQREihORftnQyc7ynBabmByMsleajLAjlN/rkPQnW3DS2sRqajCy2Y7bPkd8oUXDAU5+
         pL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sJTozzqcOzl7PM3qCNKJxFBbc/qoQ25JjRUMPeSA9Lg=;
        b=kbJV5AAUD0J7zO+RyApkQ/NJxnykJ5PuDV3WCOGLGhrUFs9egPDhw+uUi63mIjMO+u
         MjA+z96Q/grUXAQ+4dT4Af97NtRhpz+/r5K/Vq8N77FHAlkK1S4552bjDw5yaeXS2muG
         ocaO2DXdMi5YV9sWpQqHcWe3wIsYF4Bti2c2/SUleXZ08EYZd/7vZ5TSWcgyw+9HbeYo
         34VacFAgvWiNVwxnqZ2Gs9ip/v3j/Q+SuXfuQfZtbhSr2nTncv1HBYFT6DPIRXGroLdm
         wv/54vTGMN0BO5md5TDPcZ+Xp2hlykM/4VXILjpaghtlESpB+1n64bWxBrCO3bXVRVwD
         vvGA==
X-Gm-Message-State: AOAM5316cp8rKnR5oxgnU5sGekDqkcITZZWUukKYuSfcnLpHUjw6vwfg
        znBY+mGygVTvEHGlOltKPeU=
X-Google-Smtp-Source: ABdhPJyioZ61jgmyOy7B91XCvkge6cSfspIaHwxUV0Neh2a8T0GMCY+u+8x4E1GPk3OHrp1x7qojbg==
X-Received: by 2002:a05:600c:19d1:: with SMTP id u17mr4662410wmq.141.1616174824297;
        Fri, 19 Mar 2021 10:27:04 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:27:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 14/16] io_uring: optimise io_dismantle_req() fast path
Date:   Fri, 19 Mar 2021 17:22:42 +0000
Message-Id: <1dc3b3ad67f9c7899d8c70b4c3673c0c1c8ffbeb.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
References: <cover.1616167719.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Reshuffle io_dismantle_req() checks to put most of slow path stuff under
a single if.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index afc08ec2bc6e..b3484cedf1f1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1725,28 +1725,32 @@ static inline void io_put_file(struct io_kiocb *req, struct file *file,
 
 static void io_dismantle_req(struct io_kiocb *req)
 {
-	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
-		io_clean_op(req);
-	if (req->async_data)
-		kfree(req->async_data);
+	unsigned int flags = req->flags;
+
 	if (req->file)
-		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
+		io_put_file(req, req->file, (flags & REQ_F_FIXED_FILE));
+	if (flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
+		     REQ_F_INFLIGHT)) {
+		io_clean_op(req);
+
+		if (req->flags & REQ_F_INFLIGHT) {
+			struct io_ring_ctx *ctx = req->ctx;
+			unsigned long flags;
+
+			spin_lock_irqsave(&ctx->inflight_lock, flags);
+			list_del(&req->inflight_entry);
+			spin_unlock_irqrestore(&ctx->inflight_lock, flags);
+			req->flags &= ~REQ_F_INFLIGHT;
+		}
+	}
 	if (req->fixed_rsrc_refs)
 		percpu_ref_put(req->fixed_rsrc_refs);
+	if (req->async_data)
+		kfree(req->async_data);
 	if (req->work.creds) {
 		put_cred(req->work.creds);
 		req->work.creds = NULL;
 	}
-
-	if (req->flags & REQ_F_INFLIGHT) {
-		struct io_ring_ctx *ctx = req->ctx;
-		unsigned long flags;
-
-		spin_lock_irqsave(&ctx->inflight_lock, flags);
-		list_del(&req->inflight_entry);
-		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
-		req->flags &= ~REQ_F_INFLIGHT;
-	}
 }
 
 /* must to be called somewhat shortly after putting a request */
-- 
2.24.0

