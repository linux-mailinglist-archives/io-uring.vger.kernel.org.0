Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B437430D18
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 02:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242859AbhJRAbg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Oct 2021 20:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344857AbhJRAbf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Oct 2021 20:31:35 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DE4C06161C
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 17:29:24 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z20so63995074edc.13
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 17:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EapSq0O06WYM3qgkWA5r8iGtKC4R9bTeU1pZ8CVrxA4=;
        b=UBUU9pzHKZUoU9ovVxxFSOs+a7nLYbQ9R4kRHQDyWxjXcVcZrPNgr09U9ml//PDu3h
         AbsEgwpwpwXn9Po7e7WCyfr6gUHX4h1Of7PKLtJk37Gszi+GHI3v0r1F3UELeho9g46x
         1QKNS9fZUT2u+WLDL2w41G2yJHERRsYdRRr7IlLnFbhSSi15RuLFDu5PTumaR6MWrd/i
         I4ZyUU0dQbe8aq+nGQbwoWCEorevdSD8VmMYL8vqhvPKSrcHxnmPm9cd9M6e0IUUUQ4Q
         WdU95F1Intl/GEjNxzRfyS36N0KeBZFTueCp7CUctu6bUUYWeLi3MO0mMIYmJQUGRLPk
         Pebg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EapSq0O06WYM3qgkWA5r8iGtKC4R9bTeU1pZ8CVrxA4=;
        b=ZO8AKHR9Q3BegZ5ojB9XAzYX/UskM7Xod/h3BD3FqJLQFZXD9zc6uUq+Hs2f6hIwCl
         18rYWmgIdskbfO5sQkdcOOOLLZNp7Ion1uNcFwiU2UXh+HcIoD68soNjiZAckAFiJz6g
         puVmZguplTabrpWuoSSmAtLwm6OtR0x7lPNLgRoouVhy28V85eOPYrWKr9N/gQAw+pzC
         ksj6mCrlZbv3LDwpzo3+4zIBcqJ7SPlDw2t2treR1w3avQyL1Wn/uZQr4g0MlgOvPYxf
         zvcaqd/yRy58VSRXEJUaoCdLfbmKDphCVJTtG3qAP+SofmpOvvvIEf3/rY+Fe7UUl8s/
         pV0Q==
X-Gm-Message-State: AOAM533+w+mOldGYT8fn20xVFD1kWMgO46phsIDqXb4sPXXPfWqtp+ML
        YOHWP2C6dUDZioNsxvSXVFY0pz4Mj54aUw==
X-Google-Smtp-Source: ABdhPJzjGBpUoJ+mPJaAVYB2OY1s8bEqC301fRQDDEoDiWx2F+aBKclDFHa+o5eKLubGK8jAlhKAeA==
X-Received: by 2002:a17:906:354a:: with SMTP id s10mr26998639eja.475.1634516963256;
        Sun, 17 Oct 2021 17:29:23 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.195])
        by smtp.gmail.com with ESMTPSA id q11sm8881489edv.80.2021.10.17.17.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 17:29:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 3/4] io_uring: clusterise ki_flags access in rw_prep
Date:   Mon, 18 Oct 2021 00:29:35 +0000
Message-Id: <6b5cadc21f4124f037861d12af6aa99066016fe7.1634516914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634516914.git.asml.silence@gmail.com>
References: <cover.1634516914.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ioprio setup doesn't depend on other fields that are modified in
io_prep_rw() and we can move it down in the function without worrying
about performance. It's useful as it makes iocb->ki_flags
accesses/modifications closer together, so it's more likely the compiler
will cache it in a register and avoid extra reloads.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d7f38074211b..4507b711a688 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2845,16 +2845,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req)))
 		req->flags |= REQ_F_NOWAIT;
 
-	ioprio = READ_ONCE(sqe->ioprio);
-	if (ioprio) {
-		ret = ioprio_check_cap(ioprio);
-		if (ret)
-			return ret;
-
-		kiocb->ki_ioprio = ioprio;
-	} else
-		kiocb->ki_ioprio = get_current_ioprio();
-
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
 			return -EOPNOTSUPP;
@@ -2868,6 +2858,17 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		kiocb->ki_complete = io_complete_rw;
 	}
 
+	ioprio = READ_ONCE(sqe->ioprio);
+	if (ioprio) {
+		ret = ioprio_check_cap(ioprio);
+		if (ret)
+			return ret;
+
+		kiocb->ki_ioprio = ioprio;
+	} else {
+		kiocb->ki_ioprio = get_current_ioprio();
+	}
+
 	req->imu = NULL;
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
-- 
2.33.1

