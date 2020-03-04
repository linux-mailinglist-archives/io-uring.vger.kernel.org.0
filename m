Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2035017975D
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 19:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgCDSA1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 13:00:27 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:40895 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbgCDSA1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 13:00:27 -0500
Received: by mail-il1-f196.google.com with SMTP id g6so2591870ilc.7
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 10:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gsT6xXPdmJoIPhLFodbm1h62fukiGbrBa4i8JjG659A=;
        b=eXwEEVyvN9ltL5Hlfu6EKSA+q/kV+emcl9EP+ZWBL1VVq5+WzpKoqfN1i53AnJV+z+
         dnGqkmg0ZOpmf1QE4JRage2Mb+7AvtUSz78qD/o6yNLBNmkN9FFmzwHkY5IBhZeydOZA
         WHpWlV+6kH6uk2b9XSMvA51yigrkLo2Yv3kZCKy49EZyFtKepRT+G0kKjBZtmn2Pf6Sn
         iVTfYcVS0viNS54Egy6qO0Rer2aXhiJu7mTjpB3YJDExJzSyUP6vHVAz17xdJma0JQ73
         zMmWmhQYQ4RqkAh/tQjhk3KptQBnXIzBZVtx5RULuf45BHDiPYsdl06uDLEoIlNHQUAn
         vugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gsT6xXPdmJoIPhLFodbm1h62fukiGbrBa4i8JjG659A=;
        b=hP/7oIvis0bs43+YPXVxTjvMP0NZeF1yw2z+2TwjdFhy9dxwSPGmyxrGL0xt2odN0d
         jLmecXDbl3MLypregPIiOavNDuxFJU0vPm3V3uCmdymFZG6EELiIf3EAFzefcBOzBxnG
         NYbZfJmpwKbtsRclT3FsJw0EQRMfhIcyPmUX1Ueft0NIXhGm3tUkz5G1yYkaka/s+yaR
         ulfCrojEiq+Y/kzrLgMsHOm+6/LO/lyjrfAzdnk2TYgdyR2IDjEXJhm8G7W+qTTy/bwD
         45EmXgUfWcapTvedmjLig4pV/1P25Rz4Bd089RGj0Y+NYVLpolOh5b5bGxKzk4lbO42L
         QLZQ==
X-Gm-Message-State: ANhLgQ0KkFZ9fr4o7i0yjVGdehhfa4zhv9b7J79G5ToMLhbaNfNoPjYi
        O+ZnLGAaaUwBx9/0DLZXX3UOshyVadI=
X-Google-Smtp-Source: ADFU+vsfIZFzZiOSnARWlHVinzN/OgvDykBLbTWzrx7pGgw1Wld620hASM8HPg9meWIIYy0IwjhwPw==
X-Received: by 2002:a92:de04:: with SMTP id x4mr3792345ilm.98.1583344825263;
        Wed, 04 Mar 2020 10:00:25 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p23sm6715187ioo.54.2020.03.04.10.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 10:00:24 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     jlayton@kernel.org, josh@joshtriplett.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring: allow specific fd for IORING_OP_ACCEPT
Date:   Wed,  4 Mar 2020 11:00:16 -0700
Message-Id: <20200304180016.28212-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200304180016.28212-1-axboe@kernel.dk>
References: <20200304180016.28212-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

sqe->len can be set to a specific fd we want to use for accept4(), so
it uses that one instead of just assigning a free unused one.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a1fc0d2acf91..11bd143847ad 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -354,6 +354,7 @@ struct io_accept {
 	struct sockaddr __user		*addr;
 	int __user			*addr_len;
 	int				flags;
+	int				open_fd;
 };
 
 struct io_sync {
@@ -3943,12 +3944,15 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
 
 	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	accept->flags = READ_ONCE(sqe->accept_flags);
+	accept->open_fd = READ_ONCE(sqe->len);
+	if (!accept->open_fd)
+		accept->open_fd = -1;
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3964,7 +3968,8 @@ static int __io_accept(struct io_kiocb *req, bool force_nonblock)
 
 	file_flags = force_nonblock ? O_NONBLOCK : 0;
 	ret = __sys_accept4_file(req->file, file_flags, accept->addr,
-					accept->addr_len, accept->flags);
+					accept->addr_len, accept->flags,
+					accept->open_fd);
 	if (ret == -EAGAIN && force_nonblock)
 		return -EAGAIN;
 	if (ret == -ERESTARTSYS)
-- 
2.25.1

