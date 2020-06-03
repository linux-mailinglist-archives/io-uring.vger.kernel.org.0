Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2181ED0D4
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 15:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgFCNbF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 09:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgFCNbC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 09:31:02 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC00C08C5C0;
        Wed,  3 Jun 2020 06:31:02 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h5so2378388wrc.7;
        Wed, 03 Jun 2020 06:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=6DeANnLjiSW0znJDykOcLPqmbcIhYiUF4rSUTO8iKzs=;
        b=pFDWP2+ThST5Vud658mlWk0/LJ+DJYaI36swbTPRbxBSH1qk/+rC9arsmrbi/rhxGf
         x/7ZkllJOt4bl3/vVorqGf/IZI4gwN25FsY+Q8VIMW+LbArifdwJYStBacQJGZj+dhCr
         Zcl/GZFDR+b09lHGRlLWQgrOPkrvWLZqLgGrEUAS7g+KaR8/Gzxl92eAYegK5uFdycEZ
         1j0OJqV9rwUfpQnd+Eiya25duRntWE2l48qWsC/aHtM32kMlQ/Icn5nu3i5MzhTKXde1
         u8XGsF6A9rzXt5LGX9hsrcC8pTi1NpCZ+4UGDAgg5LQgFIq3o1UupvOxRV1g+SgayM8G
         nyjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6DeANnLjiSW0znJDykOcLPqmbcIhYiUF4rSUTO8iKzs=;
        b=jT15/04pJq8XakGxqwzcSRNR6VnmVJQMLeTVyn5CtNa5ZTlDZE8Es9mw+H6LwhXydL
         tY81iUYBwiqcIiYGJxlYW2AMynYAj4AqA/z/O2kWpKs8tawvvxVDEq7Rp8sRl1lfitbF
         fG1a85xJbePHuG3jB3asqL/HVnGH7li0OXYpzIfoYhmE9snmNEcIop7qyxcV7EomqOsY
         QKhQGVh0F/j5KGvEK2nHK6xmT22PuFAYRW0M9IatsZifain9r6j9ONRYBf+UNU5uILeF
         6XezRcFz8QJl5n+nRKoCq+HVjLEYP2LO9YrrFra+3OIIYl8C8/7nS0zBttr+uggnS0pd
         pksQ==
X-Gm-Message-State: AOAM532Owpow3GHJClWHKbNAqEtGKxmsiPBCprQ0ibIlafMBlGVbapHk
        TRsxjyySKxkhBs1+t6T1nlY=
X-Google-Smtp-Source: ABdhPJzp1fC2yApIvcUHwb5Hx0aEOmHHT/I2TPJv3g5wtwF84QztEj774po++U9iqbrrlhfphMPnSw==
X-Received: by 2002:adf:e592:: with SMTP id l18mr24285131wrm.175.1591191061183;
        Wed, 03 Jun 2020 06:31:01 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id a1sm3189716wmd.28.2020.06.03.06.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 06:31:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] io_uring: do build_open_how() only once
Date:   Wed,  3 Jun 2020 16:29:30 +0300
Message-Id: <2f7d3bb00740c9fde183d72f5c0e196771df243a.1591190471.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591190471.git.asml.silence@gmail.com>
References: <cover.1591190471.git.asml.silence@gmail.com>
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
index 2463aaca3172..75ff635bb30e 100644
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

