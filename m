Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0FC45167E7
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 22:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354820AbiEAVAa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 17:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354816AbiEAVA2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 17:00:28 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6785518B01
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 13:57:02 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id v10so10344643pgl.11
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 13:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LsjuFjAivER5w2OU/cJBZZA82Ov2iE2AmD3V5ZWRSy0=;
        b=w6YtnsYgX319cAn8DZNaAASsdzIrRXjbrIPbkRDaMIjnG8aVy8iChJdKLIQfs6/mU1
         evhtoK8++grW2ylOARsWp2RjEytUIiSuD2XiqSjy5IdWUnWfGuo4f93EJf6i5q94Ymgy
         ZHnEGFC2maX4N3EjKAWKLfh8PqkJNWURFYHFCtI0ZagjnqzqEtz12t6ikPZhTLN6sk2S
         i2T5WG46OFIsAf2pKpxUy7Ap/we9XTme/+20rffO4zWQpKsUxLTsMBezDembtHBOLuql
         V5RBwmGIMQkv6IxYiRUiPQmxmsaRkZ+2TWFKEy3Cnh1uz3ELpoNjBIN+pZNkrXDexcJ2
         iCfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LsjuFjAivER5w2OU/cJBZZA82Ov2iE2AmD3V5ZWRSy0=;
        b=1Oblc9sWFFw/uTuJYLC/sekCwJCSyO4jlVEeeOscHcFZZEqkbdFMhfsMN1cktMhv/g
         fJPICqUw9ciuPcD0OdUVQtAOIvtmNNLN0rWvzpT/41QmmYOi/UScD9BI51BIx5jZ38Kn
         zJS7/Ts6L6e6mcR1WAaKIEpVG0t7lQNouWvliwqnaowCv7eAMcmxnmHlFHCOlRO9BtLa
         oYVgbmrdQXvrGaXfwOLY4qsG4mm2r7MVztKkxMe4pkQkdSuIycGRhaQoAg1ZYJX0hvWW
         K7RH4yTJRrTJqXEyv1I+IpZOfvj40ZfHdccJADfH/U3uUUdBV4fOFE/hWDNuk3VGJIN8
         ONIQ==
X-Gm-Message-State: AOAM533dwmVUMUlMTi2wAz1rq5gRj6QMaVZTnboSBNYuOZlwhMOkpjGW
        DbyylpY2D89VG/JPg5KEITgDA1iies2wNw==
X-Google-Smtp-Source: ABdhPJxKrfqfwWyoWWRL3IGoV9C8YPxT9rBCH6Hp7RrrQLMFX23kyxStiiSW9qHRn+s7GnmrTiX+wA==
X-Received: by 2002:a63:2a02:0:b0:3aa:c641:cd86 with SMTP id q2-20020a632a02000000b003aac641cd86mr7022633pgq.614.1651438621668;
        Sun, 01 May 2022 13:57:01 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090270c800b0015e8d4eb1e9sm1894013plt.51.2022.05.01.13.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:57:01 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/16] io_uring: ignore ->buf_index if REQ_F_BUFFER_SELECT isn't set
Date:   Sun,  1 May 2022 14:56:42 -0600
Message-Id: <20220501205653.15775-6-axboe@kernel.dk>
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

There's no point in validity checking buf_index if the request doesn't
have REQ_F_BUFFER_SELECT set, as we will never use it for that case.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fc8755f5ff86..baa1b5426bfc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3686,10 +3686,6 @@ static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 		return NULL;
 	}
 
-	/* buffer index only valid with fixed read/write, or buffer select  */
-	if (unlikely(req->buf_index && !(req->flags & REQ_F_BUFFER_SELECT)))
-		return ERR_PTR(-EINVAL);
-
 	buf = u64_to_user_ptr(req->rw.addr);
 	sqe_len = req->rw.len;
 
-- 
2.35.1

