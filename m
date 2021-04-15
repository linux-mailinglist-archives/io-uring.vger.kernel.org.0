Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1629A3608FB
	for <lists+io-uring@lfdr.de>; Thu, 15 Apr 2021 14:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbhDOMMW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 08:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbhDOMMV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Apr 2021 08:12:21 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929ECC061574
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 05:11:58 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id w4so19343703wrt.5
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 05:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7GYVqYJKGoSZlGm5qKQ86FL0yHmaZPez2sn4K+Dk5u8=;
        b=hDFJxsCTlucAVQy4ooElIh5zL6dVEUAT3OQhf/hAQcINIPEoLLikoRZ5oVjTDX90P5
         7EzJdNt9jWZ2FtRjArl7fwGogRK4AuVFLamSfXt3BQNV5miq45uiKDQ9ilNcB6hir2EJ
         6i6hbQAifq9qEVEWAU8bKWOVDUbCB8EnmJeXkSXRcb6JKaTJ/TuXhEnSMqE+nxc/6Tkr
         sJ72TK7A3dxcxMgi3HubpNKu4K5pcqqPVjJp9O1Kv4jg7+qlS1hzuJiYnSz/8VU/We94
         O9HALb1tcaYL2FOSNBDjK6kRobZcUiaOvEeZ68WSB/Hmz4Stzv0eXZ0yzguNV/dxGXs6
         KFWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7GYVqYJKGoSZlGm5qKQ86FL0yHmaZPez2sn4K+Dk5u8=;
        b=eb++gbR8VvrB2kod/s3WARPv3Yfydx4ePSGjqplImzKk5Ul8HpF+wFkQFahYl7/w6v
         0EzrMN3F9HZRjWoSLNMRWtcjZqRhBbMf45GZTFSCrSrxRLIZ90d0ggkZDcxVpQqBYrTO
         EkaGq/MAwG1GKfft+7WPSHnc7ZQx9dNdedORu+LVcTKpoN/g9o3AZgUgEWda4s1gm310
         /5JlLZrbpapeu1fiPwhY77rimYo3cVqidJNCLmO3QHD6rbZkxUSD5aqaoXSIqvUF1vEi
         UVpYOC1xPybN1uENdgVio7MdluRi5WKW9Ej/rSIqRV/E7QeXb8RQ3H+bCcanKEZ7it/1
         G5xg==
X-Gm-Message-State: AOAM531w65Lkq3nTsvchOiF6cPrJAVqmMdx4x0b6UW9HwPZz5lIyI7kn
        cDWBV9XcfBlLSupnNHd3Mh0=
X-Google-Smtp-Source: ABdhPJz+axXcd/QiJTBU/cY5jUr/kETuQyMAcrXLEidfh3vPEKFJNlSFPv8ySAxutis4PB5ZZJEfUA==
X-Received: by 2002:adf:efca:: with SMTP id i10mr3113621wrp.316.1618488717347;
        Thu, 15 Apr 2021 05:11:57 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.21])
        by smtp.gmail.com with ESMTPSA id j30sm3015275wrj.62.2021.04.15.05.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 05:11:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 1/2] io_uring: fix overflows checks in provide buffers
Date:   Thu, 15 Apr 2021 13:07:39 +0100
Message-Id: <46538827e70fce5f6cdb50897cff4cacc490f380.1618488258.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618488258.git.asml.silence@gmail.com>
References: <cover.1618488258.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Colin reported before possible overflow and sign extension problems in
io_provide_buffers_prep(). As Linus pointed out previous attempt did nothing
useful, see d81269fecb8ce ("io_uring: fix provide_buffers sign extension").

Do that with help of check_<op>_overflow helpers. And fix struct
io_provide_buf::len type, as it doesn't make much sense to keep it
signed.

Reported-by: Colin Ian King <colin.king@canonical.com>
Fixes: efe68c1ca8f49 ("io_uring: validate the full range of provided buffers for access")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e9d60dee075e..b57994443b2c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -627,7 +627,7 @@ struct io_splice {
 struct io_provide_buf {
 	struct file			*file;
 	__u64				addr;
-	__s32				len;
+	__u32				len;
 	__u32				bgid;
 	__u16				nbufs;
 	__u16				bid;
@@ -3923,7 +3923,7 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 static int io_provide_buffers_prep(struct io_kiocb *req,
 				   const struct io_uring_sqe *sqe)
 {
-	unsigned long size;
+	unsigned long size, tmp_check;
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
@@ -3937,6 +3937,12 @@ static int io_provide_buffers_prep(struct io_kiocb *req,
 	p->addr = READ_ONCE(sqe->addr);
 	p->len = READ_ONCE(sqe->len);
 
+	if (check_mul_overflow((unsigned long)p->len, (unsigned long)p->nbufs,
+				&size))
+		return -EOVERFLOW;
+	if (check_add_overflow((unsigned long)p->addr, size, &tmp_check))
+		return -EOVERFLOW;
+
 	size = (unsigned long)p->len * p->nbufs;
 	if (!access_ok(u64_to_user_ptr(p->addr), size))
 		return -EFAULT;
-- 
2.24.0

