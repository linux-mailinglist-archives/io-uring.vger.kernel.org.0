Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08917153488
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2020 16:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgBEPrG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Feb 2020 10:47:06 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43854 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbgBEPrG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Feb 2020 10:47:06 -0500
Received: by mail-ed1-f65.google.com with SMTP id dc19so2615648edb.10;
        Wed, 05 Feb 2020 07:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KgaeS+7rmTlJ5xBZJmjQaeCEgvc91R6bTRPhHEIIuQE=;
        b=IEDDoY7iQXTFrEOnjy9qG3FT5eTai71n3X5c27NsnKrcOd/0iCb/Iu6Ycgz+5N5fCx
         ZHDXY0IkPJBmNKcT5aHxsmIJrLByDeZrj8689psYAWTdzOqYidY16b2QC7fcVl1OkpBl
         4CXl10Nmw2TOISrPIF8bbrtQafOmgikU/jxT9wrOKDWZgsApR/HK9HbioCEjSntbPKhl
         HvTB1dYQ/IO1vQYKliNein/KDG1OTHTr7wqVUbf9WFNAJgCGvhSUVtsd10AIte1aNM5S
         w/VBCaKrUPZr+xLfL3RRI6BTIoew+vPnXFhzq0JMk+HesDOB1LcZwNTdoVeWkA1IDf/N
         QrsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KgaeS+7rmTlJ5xBZJmjQaeCEgvc91R6bTRPhHEIIuQE=;
        b=mlkRVgAVNkAnEUEY0bMOMUvMyauiIQeACTwSuSXdnX3Lz/6hr38+YEa87syGd4L/1d
         0GLqWo7dMqHgr5UGJOxbcAOdsuQId9QRTtZB53RhzZUc5bcoTackhvdvIgng1mHvNxd4
         c7E7SSjYehLRCw6QD3iV9hdb62a6SN6JyJ5q19EDXYbavxOBFk0S4Ror8+IFMoYN1lA7
         PeSEEI/8KAOAyUFddQFfUwJYyGY5KgD1/V++LokRz2JaLOCL2uN2PUevcZvBFby+dJTg
         s6bjJj2yMAJXgQS5FcmgT/uDrwRNUe4eJkzGrb+KOtE3tNIAvyet34GfpkADW55h5zoG
         ORhA==
X-Gm-Message-State: APjAAAWCreBhVIuCvQYEigZ8QhwqF+q9NsK5FyJaQ5s9JKIZWynzE8yc
        k/LgDq8SiZwaQHPiSj9LxOsqruxf
X-Google-Smtp-Source: APXvYqxK/k4x9dOtLVovXc62fQdEF6nNhVbK3NXGguJqVT/U9jf+QqC3kLE9G7hFkPbcMqYXFqpotA==
X-Received: by 2002:a17:906:c302:: with SMTP id s2mr31005902ejz.275.1580917623630;
        Wed, 05 Feb 2020 07:47:03 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id q3sm8069eju.88.2020.02.05.07.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 07:47:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: fix mm use with IORING_OP_{READ,WRITE}
Date:   Wed,  5 Feb 2020 18:46:14 +0300
Message-Id: <951bb84c8337aaac7654261a21b03506b2b8a001.1580914723.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_{READ,WRITE} need mm to access user buffers, hence
req->has_user check should go for them as well. Move the corresponding
imports past the check.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index edb00ae2619b..f00c2c9c67c0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2038,13 +2038,6 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	if (req->rw.kiocb.private)
 		return -EINVAL;
 
-	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
-		ssize_t ret;
-		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
-		*iovec = NULL;
-		return ret;
-	}
-
 	if (req->io) {
 		struct io_async_rw *iorw = &req->io->rw;
 
@@ -2058,6 +2051,13 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	if (!req->has_user)
 		return -EFAULT;
 
+	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
+		ssize_t ret;
+		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
+		*iovec = NULL;
+		return ret;
+	}
+
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		return compat_import_iovec(rw, buf, sqe_len, UIO_FASTIOV,
-- 
2.24.0

