Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E375167EB
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 22:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354891AbiEAVAe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 17:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354837AbiEAVAc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 17:00:32 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C681CB0F
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 13:57:06 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id v11so1469689pff.6
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 13:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TPBLEcBqF4Buwq/0pCegq3AAVZbUk3tP9a3xWwyvkZc=;
        b=XsVVp2dz8+NqgRRrg8M0hIhwsP64ZPVoAL05/uINnt7nNWBB6Ts0Ohd6lpKdCScwGQ
         eYunRRo08drLAzCCZxrsUhGDvdJTVWy1QJyT3njLCjMBXY6aCG7nhR+UgIW3dl5I+Kik
         tj+JM35XnoEW87yAWP4x6goQQ7Ij7mldyeMVir+f0FXLKJ7Ys9LpTRxopNkBiNBxmAyu
         9PTuRus8gC6WmF4wNPRdacbWjdRRCW7Z0ZL8qauXeQqNNPnVNocZruZoLAFxQv7kfjbE
         yjvihBGUzVNTciavKjOJSS1EAxduIGhHEUbYDR7X+MYbSIgyoFZAhSR41t2b25QHXh/T
         IVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TPBLEcBqF4Buwq/0pCegq3AAVZbUk3tP9a3xWwyvkZc=;
        b=jFwwO4ycrDeC0rVteNl3Rr01JAqu7wlZj0rN/jaVHRDTNb1eX+K3LuOIP8y4HlSgVx
         OXiqCCKmT51ysiAJ6PeP26nFUZWzV1mXvDxycmlv+vhrfGsYja7IGj3exLw8hZpcVT8Y
         /6/JTp15HZWlaQV5BxSnvhxoRVmkGXFkTgoZ3RmcHPmaxUW4ArCUsCCuNr1Kig1BlXon
         gtHttH/jOnNe/P9VoWqtfSKdH83TibKFEyfJW3/NHyuvHzHC5YPof3wyAQgwza0e3Bge
         cr7A5P68W/D6UYNfU+G5uSjQMNrbcOuNTcuPfdg4+1TdjnWPJ0kOvt0nL1EMTIRV0sY1
         q/Sg==
X-Gm-Message-State: AOAM532tenbNwQLhTHcH+Uja8dCyeZWAp/5NwsuUPVyFNz/syXJCEbzO
        +NtJ4OWcKHR1YHZ6c8jM4wWWlVPeVPZ5IQ==
X-Google-Smtp-Source: ABdhPJwjsBciIUe/h52mnJbva0MBgHwjnchr4kObLmtnQtvF4qbhTvRrQ5SM4oMCi6dCAe9Ee5RiSw==
X-Received: by 2002:a63:5011:0:b0:3c1:e24a:e5ea with SMTP id e17-20020a635011000000b003c1e24ae5eamr5170190pgb.359.1651438625579;
        Sun, 01 May 2022 13:57:05 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090270c800b0015e8d4eb1e9sm1894013plt.51.2022.05.01.13.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:57:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/16] io_uring: abstract out provided buffer list selection
Date:   Sun,  1 May 2022 14:56:46 -0600
Message-Id: <20220501205653.15775-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220501205653.15775-1-axboe@kernel.dk>
References: <20220501205653.15775-1-axboe@kernel.dk>
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

In preparation for providing another way to select a buffer, move the
existing logic into a helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b4bcfd5c4c3d..2f83c366e35b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3561,29 +3561,41 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
+static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
+					      struct io_buffer_list *bl,
+					      unsigned int issue_flags)
+{
+	struct io_buffer *kbuf;
+
+	if (list_empty(&bl->buf_list))
+		return ERR_PTR(-ENOBUFS);
+
+	kbuf = list_first_entry(&bl->buf_list, struct io_buffer, list);
+	list_del(&kbuf->list);
+	if (*len > kbuf->len)
+		*len = kbuf->len;
+	req->flags |= REQ_F_BUFFER_SELECTED;
+	req->kbuf = kbuf;
+	io_ring_submit_unlock(req->ctx, issue_flags);
+	return u64_to_user_ptr(kbuf->addr);
+}
+
 static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 				     unsigned int issue_flags)
 {
-	struct io_buffer *kbuf = req->kbuf;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
 
 	io_ring_submit_lock(req->ctx, issue_flags);
 
 	bl = io_buffer_get_list(ctx, req->buf_index);
-	if (bl && !list_empty(&bl->buf_list)) {
-		kbuf = list_first_entry(&bl->buf_list, struct io_buffer, list);
-		list_del(&kbuf->list);
-		if (*len > kbuf->len)
-			*len = kbuf->len;
-		req->flags |= REQ_F_BUFFER_SELECTED;
-		req->kbuf = kbuf;
+	if (unlikely(!bl)) {
 		io_ring_submit_unlock(req->ctx, issue_flags);
-		return u64_to_user_ptr(kbuf->addr);
+		return ERR_PTR(-ENOBUFS);
 	}
 
-	io_ring_submit_unlock(req->ctx, issue_flags);
-	return ERR_PTR(-ENOBUFS);
+	/* selection helpers drop the submit lock again, if needed */
+	return io_provided_buffer_select(req, len, bl, issue_flags);
 }
 
 #ifdef CONFIG_COMPAT
-- 
2.35.1

