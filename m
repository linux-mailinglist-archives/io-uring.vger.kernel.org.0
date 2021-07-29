Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7F63DA719
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237640AbhG2PGi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbhG2PGh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:37 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2B6C061765
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:34 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id b7so7357079wri.8
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=WZUSbbOF/FC2ouOE0MYWtzocErTrVoLjBs5Nsshkk3Y=;
        b=ZuytFk5/e52EBdDu4H7O95qXZnIwnNs8oos+cWZcvM5ma/gADe+l1w7zb6oCnBxiVh
         gHs/7p4Ta3vPtswrgYti83qBF1bXgFTEcZ+unMtQZxywgWuFv9wwHbdX3zXDa90Qy5uS
         m/tMzMF939PXkF8YglFHFsDVj/SWvc/nzUnVd2O+qKqJMfsYyXQi2e6Hm//GzxcYrZa6
         ydzPyQqxy+2V4v6twU4MDrUraoFtIgZdNSOisD7Dt8jXpNtwe7t1ReY2olxzAcJG3ZdN
         0sEdBNi4jPTs9QlhVC/PtCdfI1Zdz/Vsx4UAeEgkOgwS46mJSz/YlAS2nxwWX/5T1JjE
         lnzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WZUSbbOF/FC2ouOE0MYWtzocErTrVoLjBs5Nsshkk3Y=;
        b=mBU1Sgi0W27uKhaktNqS0UbCRpBZGrkZiA6eAGVovvslae51uoQ6yjA6r25L8ewCc8
         8WmpcAE7Ttl73+dKLyFHMuPzR16o7Tdc5eZJMFRwhescMf3cK1RfQ9c+p3XMV3+UAnfQ
         eW7auHvbasounSoS4iC515Fv7I3VSUiwMq/cF2IRPE0Hcbq9MRP8qFt27e3t1biEhMzL
         6JS5YoJqbeOmOGRG0S9Dk9AxzhtQGmMJ/CKyf25J1t7Ao28VhDuGY36Zj8Bb53EKXxoB
         IPO7OBnR+hCOxRDYWLdHGJPudzmKnPUe3hkneX9VjQlM/axNYQLhen+0NM6F4/W2rhEt
         0HUw==
X-Gm-Message-State: AOAM532CVnHAnggdwS74FkboT85saH2jiKBae6xABmPn98uE5hnoJNPv
        mrMpnKRYLS8rA09qJuZ/vaY=
X-Google-Smtp-Source: ABdhPJwzwuooZrKzT9YZZpEHbX4MWP2Qe1NzIybPsqNzhtkDYtD+slziTNfgEOkBRCaefeRs8MTAog==
X-Received: by 2002:a05:6000:10c6:: with SMTP id b6mr5512718wrx.110.1627571192936;
        Thu, 29 Jul 2021 08:06:32 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 11/23] io_uring: deduplicate open iopoll check
Date:   Thu, 29 Jul 2021 16:05:38 +0100
Message-Id: <aaedfca7e469805ac3a6de646577be1e4b611494.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move IORING_SETUP_IOPOLL check into __io_openat_prep(), so both openat
and openat2 reuse it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 04b78b449e9d..2ee5ba115cfc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3774,6 +3774,8 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	const char __user *fname;
 	int ret;
 
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 	if (unlikely(sqe->ioprio || sqe->buf_index))
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
@@ -3798,12 +3800,9 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 
 static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	u64 flags, mode;
+	u64 mode = READ_ONCE(sqe->len);
+	u64 flags = READ_ONCE(sqe->open_flags);
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	mode = READ_ONCE(sqe->len);
-	flags = READ_ONCE(sqe->open_flags);
 	req->open.how = build_open_how(flags, mode);
 	return __io_openat_prep(req, sqe);
 }
@@ -3814,8 +3813,6 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	size_t len;
 	int ret;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
 	how = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	len = READ_ONCE(sqe->len);
 	if (len < OPEN_HOW_SIZE_VER0)
-- 
2.32.0

