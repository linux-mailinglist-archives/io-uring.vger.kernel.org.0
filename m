Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0E1515315
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 19:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379836AbiD2SAL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 14:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379839AbiD2SAJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 14:00:09 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51944D4C48
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:51 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id e15so10574286iob.3
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rm1EhmlNZaJr+xRojzmbaLwHS/IM7f7L9eE5rFV4nBQ=;
        b=rtKhioeqLl6gRG29Yk23ZQEYQhqh1VM/k7JVe2DA9kxdaZajeH6C+MjO3CR8LYxTk6
         UvOcIoyWw2/2FL+A4+P2Msm7XX8s1NU4ZPsHA9nGO/rxToiv6+R5oL4qXAs30v3AWrhs
         c2miyF3mgOfV55h+oTDhTq+kIV2OnrhnRorPlRDKpXUwxneQLvW7g8BYsysW9npl2a8g
         81/0aGMpotzOuLtoxlRPI0ZxXRe8kQupihZfBg3fcQikVcdtktsT+KxUJ8p3ZY9tsBfL
         jYzo0fhwopItc2Y/M5zxoqXVSA05jEmIKVd3j1fgkOSwvKpJifCkhjnS8aK04a5C7Yjs
         Y1hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rm1EhmlNZaJr+xRojzmbaLwHS/IM7f7L9eE5rFV4nBQ=;
        b=GRoG7Lt59TfSeXLWowaHVTc/3rrj1idTDvMEH2330fa7ObJWfJBk/MsQGZz908Oom+
         47bR5OwmdmPT9actIUejDjLRZ9BpME3D6A69+AcpEZKFMAH1vMOKAdjkR14RDv/jCQ9d
         NWiHvYeD2C0LaKM9Y17R+E2wWz+9G6pLTlhN67M0d9FVf+2CigrffN+JVcObDNX85hZW
         azK95NW5MGm2sDnP1urAX/mrl6bWBkaFBcGLOXTWvU3Pk2MvRj10XRWwxf42gFwxzZlK
         ImqK5cmq/5sFFO6NNva7G58Y5c4KAFQ/U6sUvRdsQSBatRGa/UxoxMpHGfC5buT9Ubun
         J0PQ==
X-Gm-Message-State: AOAM533DrwH/oxMmPcIGskjx6SPq4C1gBM8zGPU7qvytHIAYgJkvwlWL
        5M5c3HvxN71TQVrZkho+ULCOI/HVCVjc1w==
X-Google-Smtp-Source: ABdhPJzH/X1mlsqVZBjtBjfLVCexF6CSatiooh689nZPo8KbWNbZhhuZlUb3cpzezcfKU07gJqFjjQ==
X-Received: by 2002:a05:6638:62d:b0:32a:ef65:fc85 with SMTP id h13-20020a056638062d00b0032aef65fc85mr225244jar.176.1651255008995;
        Fri, 29 Apr 2022 10:56:48 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o9-20020a02cc29000000b0032b3a78179dsm744082jap.97.2022.04.29.10.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 10:56:48 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/11] io_uring: abstract out provided buffer list selection
Date:   Fri, 29 Apr 2022 11:56:33 -0600
Message-Id: <20220429175635.230192-10-axboe@kernel.dk>
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

In preparation for providing another way to select a buffer, move the
existing logic into a helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 67465cf3700a..9e1dd33980d8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3583,32 +3583,41 @@ static void io_buffer_add_list(struct io_ring_ctx *ctx,
 	list_add(&bl->list, list);
 }
 
+static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
+					      struct io_buffer_list *bl,
+					      unsigned int issue_flags)
+{
+	struct io_buffer *kbuf;
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
 
 	if (req->flags & REQ_F_BUFFER_SELECTED)
-		return u64_to_user_ptr(kbuf->addr);
+		return u64_to_user_ptr(req->kbuf->addr);
 
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

