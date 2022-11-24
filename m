Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04681637FC6
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 20:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiKXTr0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 14:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKXTrZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 14:47:25 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA058A155
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 11:47:24 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id q7so2964623wrr.8
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 11:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K/4hLmm7PqCGAlBYh4AA1z6HpKQFqzCjOinzKI4y+ow=;
        b=WBLjM5fu2jxT52vJM68sPOdVrzme+gV1p4YjL8Eih/U4LCK3j7FwFRkLroLqx34pwH
         tNL4vI0YNbBOZMWg/1Z3vzV3u7VbSaHEzlbTDXTvF2OpeUYw+eRws9aHL2Bc2JMYGNmd
         RIw01EhvwkuyPQQ0TSMymGSA+I2vylO6RnvF+KxcUC7m5WPTjaw+Nqo3pYF8gjSaGDLe
         ZxIj828rUEEWse47dMa7mw2Hap46snUjOH0/I+FRfgU0rLdQtWrU4k+XskPhnC90LexU
         a7tFFeM57oqbq/aB4SUV2MuF6cc5d4jBPdLuVj/dJ5JC7s8AjKvHTtQSmYGjEs3c+TBZ
         JEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K/4hLmm7PqCGAlBYh4AA1z6HpKQFqzCjOinzKI4y+ow=;
        b=Dcy1/yEg20DoPGhJZ4VTrIVatxCNeh0pTn+4J4t9JiNs0gcyJBlwuAfQhA0P73Xyae
         vEpPp9qUuZbxEP1GyXzCtvrOa93biqxY2GXsiaRT4npuTAz+hW+4eI5za+qZdDtmAUoF
         NOMJMjcjUbO1cF2f1Ap1S61MZm8mAMPUFU2QM2rsAPjJlpLJgYdlUcnj2tPwNNwscZWC
         ZKyhuAXjq27STriuUOqBLp+9mf7wUR53YifUj2PeL+IvDkp8DJvqHWnxlbFBvtbAfptU
         O3/2dUQTwWRNFQIXJIKo7pRBUWGYgNXFGCQlsYxyYiwU/ItWtMh7JiyHlnViaq0vNGe0
         k5BQ==
X-Gm-Message-State: ANoB5pmwbtLNc6v7hKDAVXxW2mRLc33m+57gSsxuA0ydS8s5mqQIe2C2
        aKteeJnU+CAP2ZDF/IuMsmb07FEduuc=
X-Google-Smtp-Source: AA0mqf63w4L21XnZS3QwYbIh1qbSoRkop9kBtBX8XTMbOJaiarVaMxU8FupxY0aNhFzeiYzRmrxKYQ==
X-Received: by 2002:a5d:5286:0:b0:241:eba6:7d83 with SMTP id c6-20020a5d5286000000b00241eba67d83mr6017355wrv.691.1669319242980;
        Thu, 24 Nov 2022 11:47:22 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.226.30.threembb.co.uk. [188.28.226.30])
        by smtp.gmail.com with ESMTPSA id fn27-20020a05600c689b00b003cf75213bb9sm6999308wmb.8.2022.11.24.11.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 11:47:22 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/2] io_uring: don't use complete_post in kbuf
Date:   Thu, 24 Nov 2022 19:46:40 +0000
Message-Id: <4deded706587f55b006dc33adf0c13cfc3b2319f.1669310258.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669310258.git.asml.silence@gmail.com>
References: <cover.1669310258.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now we're handling IOPOLL completions more generically, get rid uses of
_post() and send requests through the normal path. It may have some
extra mertis performance wise, but we don't care much as there is a
better interface for selected buffers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index e8150ed637d8..4a6401080c1f 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -306,14 +306,11 @@ int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 		if (!bl->buf_nr_pages)
 			ret = __io_remove_buffers(ctx, bl, p->nbufs);
 	}
+	io_ring_submit_unlock(ctx, issue_flags);
 	if (ret < 0)
 		req_set_fail(req);
-
-	/* complete before unlock, IOPOLL may need the lock */
 	io_req_set_res(req, ret, 0);
-	io_req_complete_post(req, 0);
-	io_ring_submit_unlock(ctx, issue_flags);
-	return IOU_ISSUE_SKIP_COMPLETE;
+	return IOU_OK;
 }
 
 int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -458,13 +455,12 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = io_add_buffers(ctx, p, bl);
 err:
+	io_ring_submit_unlock(ctx, issue_flags);
+
 	if (ret < 0)
 		req_set_fail(req);
-	/* complete before unlock, IOPOLL may need the lock */
 	io_req_set_res(req, ret, 0);
-	io_req_complete_post(req, 0);
-	io_ring_submit_unlock(ctx, issue_flags);
-	return IOU_ISSUE_SKIP_COMPLETE;
+	return IOU_OK;
 }
 
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
-- 
2.38.1

