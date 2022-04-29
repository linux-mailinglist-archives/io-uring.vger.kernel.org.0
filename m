Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25F051530D
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 19:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356565AbiD2SAD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 14:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376402AbiD2SAA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 14:00:00 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB7CC3EB1
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:41 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id g10so4461363ilf.6
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i7TIG4NztsbSAuiosqi2uXAolv1e4wOynyZFPMuUeV8=;
        b=KCOua9XAaM/pZcgrqufvGs3PHFhpoYQYO3rgRUfuQgl24ZaYnG8IYPrnRXJC8vhexs
         sKJ4OASSO3Ur210RRWdCrSNDl1G+09pLgHiPKK2SWvUdOufdsb5pYRp/sHVpC1yRnSxk
         PBo8Oby2RpAayoCuQWYiNcrnDcnRnb/LjC15xFbD1cTtUB8D3lZ5ehWVmUcU1PrXtEPy
         8LOp7ps2lvKCscmHrD++rHkLwwZWPeK0a3e38Ni9faiNGo4kyhHVjjTUfswGd5K8LiKZ
         LQFhUvq2Mk+ZPanKiV5kzG6yYUgBwL+UHYVyMETCpQHG5GZCe6NP8HBJOoBU6xvSaDm7
         k3+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i7TIG4NztsbSAuiosqi2uXAolv1e4wOynyZFPMuUeV8=;
        b=Y+s8sBHP7TtobOa/4/eQyjLoeO8vKl+cUtSbmur31Njyyyl70FJWS7DBYOOzpzj0S1
         ToifdcOx7LBEhC4DRTjt4HFzZ7GcNpcB2gHMXy6ZVuKf7hXOwZa5eWWDF4+VHoPZo1n2
         04grCFGEKPIhED2pNZSWX13+F/cj4pGGxDadiBj2kYy+S6tWGfy/Jig/rzCoKQqbs38k
         hfc1MeV7l6JR2f42L463wR2yLC6jXiL+wc1LYXmtjU7t7J+mvty1CewZDubY5mypqSUM
         6QnN2TeJFRyJMYQeA0t3shWLzvMTDDQYHmToTZC0I5WzYbSHI677jGbnodKovg0JDYNV
         nCfA==
X-Gm-Message-State: AOAM531fG8xO15EKcSY2fJClXYpkNde3/445BEk2vGj6amksp24gm1HB
        SgfuIY9+ybpC4f3FQJDVn+WZ3ooE3zkvLQ==
X-Google-Smtp-Source: ABdhPJzWYXkCRxZsEV7WnF/58pQpjGVRSE6Iuof5bKtC0I4eQ9t4lUfK8bWbqkOsx++EB/DsKgKoKA==
X-Received: by 2002:a05:6e02:1be9:b0:2cd:a11f:49fb with SMTP id y9-20020a056e021be900b002cda11f49fbmr204359ilv.190.1651255000169;
        Fri, 29 Apr 2022 10:56:40 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o9-20020a02cc29000000b0032b3a78179dsm744082jap.97.2022.04.29.10.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 10:56:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/11] io_uring: kill io_recv_buffer_select() wrapper
Date:   Fri, 29 Apr 2022 11:56:25 -0600
Message-Id: <20220429175635.230192-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429175635.230192-1-axboe@kernel.dk>
References: <20220429175635.230192-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's just a thin wrapper around io_buffer_select(), get rid of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dfebbf3a272a..12f61ce429dc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5897,14 +5897,6 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 	return __io_recvmsg_copy_hdr(req, iomsg);
 }
 
-static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
-					       unsigned int issue_flags)
-{
-	struct io_sr_msg *sr = &req->sr_msg;
-
-	return io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
-}
-
 static int io_recvmsg_prep_async(struct io_kiocb *req)
 {
 	int ret;
@@ -5961,7 +5953,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		kbuf = io_recv_buffer_select(req, issue_flags);
+		kbuf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
 		if (IS_ERR(kbuf))
 			return PTR_ERR(kbuf);
 		kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
@@ -6022,7 +6014,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		return -ENOTSOCK;
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		kbuf = io_recv_buffer_select(req, issue_flags);
+		kbuf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
 		if (IS_ERR(kbuf))
 			return PTR_ERR(kbuf);
 		buf = u64_to_user_ptr(kbuf->addr);
-- 
2.35.1

