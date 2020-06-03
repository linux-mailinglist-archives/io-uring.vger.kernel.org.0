Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C991ED2F0
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 17:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgFCPE7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 11:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgFCPE6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 11:04:58 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE92C08C5C0;
        Wed,  3 Jun 2020 08:04:58 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id k26so2446073wmi.4;
        Wed, 03 Jun 2020 08:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=CQNjlpqZXaTAQwDtY6Cs+PqAcVnrG7XerCH5kJph2Hw=;
        b=asQmWpCckqhFkkfyMXh7svskO7984rwLqQL4BjE/HSrECGu4hnUsA91EqHoKFTYMk+
         egHmRGAsOdErbRq6pO04OKGKatR3UeDWooCTnOdVriXEBGXqbjaxqsDCnWVldYjRfDT6
         Jy2BmzD4OA5RsBGHXvnUyW/yZ4xKdfzrm4rvak9/z5gqcgBM4G+cECM0chnAMw+1Nwzj
         zAvOpECv0zXd/UpDli8JgRvfvYYRUalZMkTYO6nWd8k5IC7jCvQNio0cWCePj6E4K5sw
         H6f6uRFacyoVe15ImtHvGrC6AN3s+TU/99Znik3bxGhxSrH2a9GPwJVPJn2tpdravHea
         R0gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CQNjlpqZXaTAQwDtY6Cs+PqAcVnrG7XerCH5kJph2Hw=;
        b=RczJAQGPd+EBRzj9xTXCqoit4EHFMOCJa2eC33uGSqOdMIpVM4uvK/M77K+iwNTXYA
         XLE62ZL/XEW5Trz6YJvNXViXcCQSKp7ehr/uVgO+LebHquRWmT6FVxSA9N4yXQq30oc4
         dRcYSSZJozOe667z4FsLztisOST4xXxmANc8/15R7xkwOm1o3u/2LmxXQQECFnsSNVs0
         rrClLJ1d7yN7jZdCpi6p9bgvib9eKNxMrqzRH6u2sEKQTqDUgwWuv1lspS1EXCXFZhIy
         tQj+ROXbu9lpDXk6lwfqWJP0ftaw0e6yLWVSGMYmd5/Da/r1X/4Y9z7JfaeJKswrBK6e
         gWtw==
X-Gm-Message-State: AOAM5303Nd4N+CUuLE6iI56xsnH0+Fs6KnGyuLRSyEXQxDYv6COOQOxn
        F1p02ndBZ1lecFBNTstdYrLPqJQv
X-Google-Smtp-Source: ABdhPJwyRdrGGUWaqwGhyfB0uIkexaVq+MInBkB+P0pmgV5RjhsGvIAvf+3AgEgI6GTMix7RhTk7fw==
X-Received: by 2002:a05:600c:2945:: with SMTP id n5mr9884484wmd.189.1591196696897;
        Wed, 03 Jun 2020 08:04:56 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id f71sm3074808wmf.22.2020.06.03.08.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 08:04:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] io_uring: do build_open_how() only once
Date:   Wed,  3 Jun 2020 18:03:23 +0300
Message-Id: <792a5db759dc99e42aefa3719a4d2779294f8240.1591196426.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591196426.git.asml.silence@gmail.com>
References: <cover.1591196426.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

build_open_how() is just adjusting open_flags/mode. Do it once during
prep. It looks better than storing raw values for the future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fc55c44dcafe..e3cd914557ae 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2992,6 +2992,7 @@ static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
 static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	const char __user *fname;
+	u64 flags, mode;
 	int ret;
 
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
@@ -3003,13 +3004,14 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 
-	req->open.dfd = READ_ONCE(sqe->fd);
-	req->open.how.mode = READ_ONCE(sqe->len);
-	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	req->open.how.flags = READ_ONCE(sqe->open_flags);
+	mode = READ_ONCE(sqe->len);
+	flags = READ_ONCE(sqe->open_flags);
 	if (force_o_largefile())
-		req->open.how.flags |= O_LARGEFILE;
+		flags |= O_LARGEFILE;
+	req->open.how = build_open_how(flags, mode);
 
+	req->open.dfd = READ_ONCE(sqe->fd);
+	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	req->open.filename = getname(fname);
 	if (IS_ERR(req->open.filename)) {
 		ret = PTR_ERR(req->open.filename);
@@ -3103,7 +3105,6 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 
 static int io_openat(struct io_kiocb *req, bool force_nonblock)
 {
-	req->open.how = build_open_how(req->open.how.flags, req->open.how.mode);
 	return io_openat2(req, force_nonblock);
 }
 
-- 
2.24.0

