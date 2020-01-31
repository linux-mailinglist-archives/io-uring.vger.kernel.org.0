Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03C5114F4AA
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 23:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgAaWW6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 17:22:58 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36434 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgAaWW6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 17:22:58 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so10480277wru.3;
        Fri, 31 Jan 2020 14:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6YW2lBCoKgOsrfSohMX0v2q7APytYZCatXkac5w4d9U=;
        b=Qc8wxFe09FqegQ+WDFuYg5q/pY1HugyRaVjC0ElRry3Gx3rw2h0A0oAtRxcYDnD24R
         xOnJQvLOvX9nueqI8gxIHoFd6DGqEJ2oLdYEuO39TX7RzQN+hd9i8tG0U5xU7XFCh47h
         UVpB91/4eTtXN2COLb89H+Muqs/6xIzFOmyf8gNxAJPoMEFvNl6uQSuBTlzA+H3OIg4t
         rp9gq24rBxxGWPu2hLYpOGDYVPEg02IhFJ4K9GuDz/qFtN498g45w5ksyrPiQ792grCS
         ZNIclPPABa6pazAmyYD3NYW3wpvm4ihuXWQknO29RG451QRe7zeQRU2B2wbpOtRNWpiv
         4WvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6YW2lBCoKgOsrfSohMX0v2q7APytYZCatXkac5w4d9U=;
        b=k3TK1wmpqRBrVYPY/Jkz3SydQ8qkkwd1xs5E5PgWXuyG6lscHbz5bFkekvxY3VrnG2
         /vjzqLIU0wBHGyGA2lmyKSNRqwmq9CJ//5bZQ+9TqiHtOAzb1KIHpbmk4doYo2tlFIoN
         iQrucIqKrGFgz8wp3m6lI7Tp4HjgMog2fUC+8sCXhMCbVUNCI/u5QwNFVanA5uBUaanM
         dFqccyhlQSSCw2oUT1Ca5PSKnmZr7bOcAgSNPqz2PjJ/UjKc9m9+2nVzP7ldUHlsL2b0
         bD0g8eNxJMxWlpnBEoVaoHUEWKEXnGpbloV3V8LBOYokGdLlWCb1W6Rrhu9VL2SiwqIa
         Sd5Q==
X-Gm-Message-State: APjAAAXUve7wbqO6D5miYgYl9CmIPsKxhJD61QgoTb6MpI7d5GfY+xxv
        sOIHDorfOBvBLoXveG6tFvl2uvP/
X-Google-Smtp-Source: APXvYqwUYXtLFGlM5rdV7JEMokq/c3cNqakr1Yd52pUgexie7tp4V7m2tae+VnXuUEYkl2KW+iUKJg==
X-Received: by 2002:adf:f10b:: with SMTP id r11mr496125wro.307.1580509375799;
        Fri, 31 Jan 2020 14:22:55 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id k8sm6071084wrq.67.2020.01.31.14.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 14:22:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] io_uring: remove extra ->file check
Date:   Sat,  1 Feb 2020 01:22:08 +0300
Message-Id: <e21d4c192e0fb12af00cbb4c1ed7d517385ec160.1580509300.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It won't ever get into io_prep_rw() when req->file haven't been set in
io_req_set_file(), hence remove the check.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 799e80e85027..426b0dd81cca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1868,9 +1868,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	unsigned ioprio;
 	int ret;
 
-	if (!req->file)
-		return -EBADF;
-
 	if (S_ISREG(file_inode(req->file)->i_mode))
 		req->flags |= REQ_F_ISREG;
 
-- 
2.24.0

