Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CB8514945
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 14:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359145AbiD2Mbf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 08:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359133AbiD2Mbd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 08:31:33 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690C8852FA
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:12 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id r9so6974367pjo.5
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ir1zQDZM6EBwJtIyTARxfUt8cxorOdhcKE02hweV0WQ=;
        b=L7d/F+quifFMCpC7VSQzy2l60Z+u3ad0zgnkCXEgPjwqjTwylilqzjGGNAS+lkWRph
         qGZgh7y29EBuFHZcaf5OI3MMjSTFVZy7xWF9NCQ3fuTIPFhpwm5vvGIAbeyL9JECEeYg
         hISHChqhL7PdSoJZbFz/XFEwYmhnY5PLWXTqq7coDetq4oepjOVQBXGaOdk7WZSubKwS
         rU06hmVvpzh+6AuVSQOnAFSijPyHN7iP0KsukjJWli1z7mvqUp+ABnEyodoRoCfxSpI4
         9Y0dBZFSTeDLD+6d/iKTMGTlBSOi7GHdIg0lfD1Cz0zJy/DXp2z3P07u04QAuDLcX8K9
         vgkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ir1zQDZM6EBwJtIyTARxfUt8cxorOdhcKE02hweV0WQ=;
        b=q7l6GiPGxLTkyfYhmytkNSEiuQMjrXVYrgOUcVh2raIaNfekGvTaDXZOs6KnU67JKw
         qx8d7S2duQ9yAyqvnIJ1VXtvb4Mdx19hzTldU4xvuRpdxMLolvCJMDs82IO3XldLvXyI
         AxdjGtSOTPCojal4v4POPasvtpuTTUtyjpnFaLrPlqOdOWukYlK0gZS5KNEb//0mz8M7
         EBZ7CicUNC4C2umS9JcDWv9dQeR1tfAGhwuunSap/cYrdxTKQxpWoCgRNZQAO9MWasBG
         HKDcp+PjnSURCPBNkKT4BpBp5uKlEYmMTYpUSxN+6Y75EQh8+Mn0wZqNBaogp8gQBCK9
         HnlA==
X-Gm-Message-State: AOAM531+GtENhI148g9qakPSPrLTdAfGWNUEBzTvn2QWQtvmIkDk1hQ6
        Z6pMJRnonR1y7PCnK/+b2FmJWJvPeXyyAaVu
X-Google-Smtp-Source: ABdhPJwuLhnJda/J7DELWelMREtbtGJXVHu+SC/XRCgVlI31EA3eJWHGmCa+sZBahjUCTseWqowGxA==
X-Received: by 2002:a17:902:7795:b0:157:c50:53a6 with SMTP id o21-20020a170902779500b001570c5053a6mr37686204pll.40.1651235291480;
        Fri, 29 Apr 2022 05:28:11 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o26-20020a629a1a000000b0050d5d7a02b8sm2895837pfe.192.2022.04.29.05.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 05:28:11 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/10] io_uring: kill io_rw_buffer_select() wrapper
Date:   Fri, 29 Apr 2022 06:27:56 -0600
Message-Id: <20220429122803.41101-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429122803.41101-1-axboe@kernel.dk>
References: <20220429122803.41101-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After the recent changes, this is direct call to io_buffer_select()
anyway. With this change, there are no wrappers left for provided
buffer selection.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 19dfa974ebcf..cdb23f9861c5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3599,12 +3599,6 @@ static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 	return ERR_PTR(-ENOBUFS);
 }
 
-static void __user *io_rw_buffer_select(struct io_kiocb *req, size_t *len,
-					unsigned int issue_flags)
-{
-	return io_buffer_select(req, len, req->buf_index, issue_flags);
-}
-
 #ifdef CONFIG_COMPAT
 static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 				unsigned int issue_flags)
@@ -3612,7 +3606,7 @@ static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 	struct compat_iovec __user *uiov;
 	compat_ssize_t clen;
 	void __user *buf;
-	ssize_t len;
+	size_t len;
 
 	uiov = u64_to_user_ptr(req->rw.addr);
 	if (!access_ok(uiov, sizeof(*uiov)))
@@ -3623,7 +3617,7 @@ static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 		return -EINVAL;
 
 	len = clen;
-	buf = io_rw_buffer_select(req, &len, issue_flags);
+	buf = io_buffer_select(req, &len, req->buf_index, issue_flags);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 	iov[0].iov_base = buf;
@@ -3645,7 +3639,7 @@ static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	len = iov[0].iov_len;
 	if (len < 0)
 		return -EINVAL;
-	buf = io_rw_buffer_select(req, &len, issue_flags);
+	buf = io_buffer_select(req, &len, req->buf_index, issue_flags);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 	iov[0].iov_base = buf;
@@ -3701,7 +3695,8 @@ static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 
 	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
 		if (req->flags & REQ_F_BUFFER_SELECT) {
-			buf = io_rw_buffer_select(req, &sqe_len, issue_flags);
+			buf = io_buffer_select(req, &sqe_len, req->buf_index,
+						issue_flags);
 			if (IS_ERR(buf))
 				return ERR_CAST(buf);
 			req->rw.len = sqe_len;
-- 
2.35.1

