Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9CB2961E3
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 17:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368792AbgJVPuY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 11:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368790AbgJVPuX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 11:50:23 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D54C0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:50:23 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id a72so2636850wme.5
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VepszvSI548H01WCFP8XKeZ3DwaaSCDPJ4OGVqV5PBM=;
        b=gZf+NwMvle+1Qi+RZ8Dwd1grkGh4NSlY/RcwXNIekECH16HvFPilB/fLv2jpVVaWLT
         Ph4rF50WNoTOc48FBbvtNJPRzY5TPSMjBGTF8/3BDGaeIDthTSkdWhX2YtV1FPOc40BK
         d2NHy8dd1xNSRVrv2n2vxL7xOALtqe/B5n/fIs7u85wfwIQzLkKB5JRdXE+Hin0AzNtl
         +t82Xlwy9a1D93/vG/E+6yne/vncU03yWT/DAaEQUVET1R5yrZEr4o4xlUuJPAnqVwrS
         kw7XbfwqPY5vfb3+THZiubBy+7gYBb60xEgPR0B4eQuQIqDK5VzuQOiWp4wYA2NvVKjJ
         sn+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VepszvSI548H01WCFP8XKeZ3DwaaSCDPJ4OGVqV5PBM=;
        b=NZtxGson4JtAK0DUFc4a8uIM0KOIf1NZSgjcc4C7tTfcgB45HQe9dHdL+iwMu4tt+Z
         2SHqIXhxTj/1f+7TSvtxRQPC001/fgaFZdVqJAMRjdpurTKLcq+Z98fjK2v0ACDZ5sw/
         mCWpBHdSERenTgIvZPgZauqSsVe+7IXuB8ogjY7tzRNaV3Skckej/yyO4dZnS6YO0cNF
         CFS99m3XlbY5sXnLzq4O2se43wDLrmuCYswDDW59p2yCw0lUowJVTCUFpSNGZ2Zdz8fM
         gbeQCuRAzBHlqaT2Kr+iWkuXhB/0L3gu3XcrGmFP2cR3zTOnsl6Cye1S/2z5vELg6RZ1
         /RQA==
X-Gm-Message-State: AOAM5307fJX+wQfDhYiczByBNNizNlcyUvREOG0cAeT2T4g7h3P6vvoW
        hE5+iF1bpE6KezT+MIqmcQE=
X-Google-Smtp-Source: ABdhPJwJYDWZRoACLIYWGIaIjPrrBEky0+mWfVdBHAAx8UVfO5xJU46UpDIgu5iYEiTvnGYxCyev1A==
X-Received: by 2002:a1c:4c05:: with SMTP id z5mr3113143wmf.122.1603381822229;
        Thu, 22 Oct 2020 08:50:22 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id m12sm4448653wrs.92.2020.10.22.08.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 08:50:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: don't miss setting IO_WQ_WORK_CONCURRENT
Date:   Thu, 22 Oct 2020 16:47:16 +0100
Message-Id: <30ce59cbaab4da30a7df6af0034d7b1791993058.1603381526.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1603381526.git.asml.silence@gmail.com>
References: <cover.1603381526.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Set IO_WQ_WORK_CONCURRENT for all REQ_F_FORCE_ASYNC requests, do that in
that is also looks better.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8e48e47906ba..9aeaa6f4a593 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1362,6 +1362,9 @@ static void io_prep_async_work(struct io_kiocb *req)
 	io_req_init_async(req);
 	id = req->work.identity;
 
+	if (req->flags & REQ_F_FORCE_ASYNC)
+		req->work.flags |= IO_WQ_WORK_CONCURRENT;
+
 	if (req->flags & REQ_F_ISREG) {
 		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
 			io_wq_hash_work(&req->work, file_inode(req->file));
@@ -6265,13 +6268,6 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (unlikely(ret))
 				goto fail_req;
 		}
-
-		/*
-		 * Never try inline submit of IOSQE_ASYNC is set, go straight
-		 * to async execution.
-		 */
-		io_req_init_async(req);
-		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 		io_queue_async_work(req);
 	} else {
 		if (sqe) {
-- 
2.24.0

