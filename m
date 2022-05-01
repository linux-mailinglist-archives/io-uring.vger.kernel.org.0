Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D595167EE
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 22:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354851AbiEAVAh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 17:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354821AbiEAVAf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 17:00:35 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3613F2B257
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 13:57:09 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id g3so10371972pgg.3
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 13:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PdTyUdrAZFBULfyLT4yrnFB4kj/sTAlzuaLFKuZ79Lo=;
        b=fr9ig34BEWnkaYM8fnSLMr8BwXaWtQmRVv60+hXnvuIa83JZyHUS3cKz+R5IYn6V+5
         IO6dTKot6rRW7SI8iN05bRTxqW01BNJ8iDq7MyBdEvbDjY+I4c+wSDVdz/hPQ1Rm2ibw
         Q748bSrT0PLJuirtN3Ca42+QI19TkOOHL+jKBZ3Q1FcWLFsISz5nf8dZIY/ywlSoh3Cx
         bsgTpPfqXLM7UGTHuav9Akt+fnDvKBGqcfD7tSC4lJtkJ/bKUVrrLd5LNQh7+EjjftOl
         5KHrZQe92lfIyPcjy1QZ2F6IVxAFUNs+zWBVhGyrqh2o9cEhZAOhblCO7g+J9S/owzcL
         cepw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PdTyUdrAZFBULfyLT4yrnFB4kj/sTAlzuaLFKuZ79Lo=;
        b=IjqpX60MIP+pfNS3gmM+93IJMRuGnCgCTgsl4lKwu5v5IbnS4EXuCG9OOWoRYjRpmq
         JDowGMe0R2X6MlHTDPP50HkHu4O3Dwt3CHXE/oqyaTYxUKAEHxT1+u512nWKJkrnFmOJ
         MndzxwwBZKCe2QkpXZkvxdu+v84SKSbXJnzgysTxJELQiAY8G95TlUeunrRQMNxji2Nv
         yep0W9fad7y1BtoezRd7yLV0IiyaeZOKm833p8NW1Lob+vQZPyhpzG2UyFU/MAyjNH14
         /WSwKyXAF14V47aE08O20wxpJ1kgmjNIo/abRDuiG07tsahXeY/4+uUC2eHo1KAzrXGT
         fM2g==
X-Gm-Message-State: AOAM533Pnb/LvyQ/3GrP0hAgYJPtU3RI9EJKvr1UOQuvYSBcAondAI2/
        aVhJVONMDcHOrcUpiBDx++/W32wzgyyl5A==
X-Google-Smtp-Source: ABdhPJzFo6xfzIX/9gvViDYhg+nuY/auTlgYYnZH7Nhg5o0XoGaHFX9C+BiPM0icZ2vfW/9EHBjh9A==
X-Received: by 2002:a05:6a00:ad0:b0:4e1:2d96:2ab0 with SMTP id c16-20020a056a000ad000b004e12d962ab0mr8123608pfl.3.1651438628464;
        Sun, 01 May 2022 13:57:08 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090270c800b0015e8d4eb1e9sm1894013plt.51.2022.05.01.13.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:57:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/16] io_uring: eliminate the need to track provided buffer ID separately
Date:   Sun,  1 May 2022 14:56:49 -0600
Message-Id: <20220501205653.15775-13-axboe@kernel.dk>
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

We have io_kiocb->buf_index which is used for either fixed buffers, or
for provided buffers. For the latter, it's used to hold the buffer group
ID for buffer selection. Post selection, req->kbuf->bid is used to get
the buffer ID.

Store the buffer ID, when selected, in req->buf_index. If we do end up
recycling the buffer, reset it back to the buffer group ID.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 23de92f5934f..ff3b803cf749 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -968,6 +968,11 @@ struct io_kiocb {
 	u8				opcode;
 	/* polled IO has completed */
 	u8				iopoll_completed;
+	/*
+	 * Can be either a fixed buffer index, or used with provided buffers.
+	 * For the latter, before issue it points to the buffer group ID,
+	 * and after selection it points to the buffer ID itself.
+	 */
 	u16				buf_index;
 	unsigned int			flags;
 
@@ -1562,14 +1567,11 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 
 static unsigned int __io_put_kbuf(struct io_kiocb *req, struct list_head *list)
 {
-	struct io_buffer *kbuf = req->kbuf;
-	unsigned int cflags;
-
-	cflags = IORING_CQE_F_BUFFER | (kbuf->bid << IORING_CQE_BUFFER_SHIFT);
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
-	list_add(&kbuf->list, list);
+	list_add(&req->kbuf->list, list);
 	req->kbuf = NULL;
-	return cflags;
+
+	return IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
 }
 
 static inline unsigned int io_put_kbuf_comp(struct io_kiocb *req)
@@ -1643,6 +1645,7 @@ static void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	bl = io_buffer_get_list(ctx, buf->bgid);
 	list_add(&buf->list, &bl->buf_list);
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
+	req->buf_index = buf->bgid;
 	req->kbuf = NULL;
 
 	io_ring_submit_unlock(ctx, issue_flags);
@@ -3582,6 +3585,7 @@ static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 		*len = kbuf->len;
 	req->flags |= REQ_F_BUFFER_SELECTED;
 	req->kbuf = kbuf;
+	req->buf_index = kbuf->bid;
 	io_ring_submit_unlock(req->ctx, issue_flags);
 	return u64_to_user_ptr(kbuf->addr);
 }
-- 
2.35.1

