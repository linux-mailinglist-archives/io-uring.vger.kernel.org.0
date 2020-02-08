Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0BF1563D1
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 11:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgBHK3I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 05:29:08 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45972 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727195AbgBHK3G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 05:29:06 -0500
Received: by mail-ed1-f65.google.com with SMTP id v28so2385043edw.12;
        Sat, 08 Feb 2020 02:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zZANyoUtLJgO2X0P6+mGDVLO8WvlROP6oDHUPiBS41o=;
        b=Z5V55QYHJ6M0QOchakaJ+C95zcPvNTMHdQRnK5IJfwrrjnh0xE+3wvt4lgeeTt4BDm
         iRA74+Lqbg2SrUv0rQDmDg4NiLIKk9NChuNLWPY9dFlQLkfUrOKcBe4bYgPlpv8v5CnL
         T/Z2KlE24xXGBPMP3MNb37w3wkOx8E30P6zV7A03saLKqJsyetTew1+D5+FgiZenQop1
         2ccVWoZ2PsSnCD30UWelnz9eyyW6RMt0e4SZ5sEZsv57clPEiyNXsdxb3mt/25rkgTDS
         WzFT995rh2GElti69ZmnYTUcYrjvkvF4Ea7NwncVCXinnu4eJMAWKAGfgLt++iBFk7lD
         Dtjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zZANyoUtLJgO2X0P6+mGDVLO8WvlROP6oDHUPiBS41o=;
        b=DxSvD79Snj7/rql1Ef8EtgofB5KV73lU5gqhpQTi7+wWXrXS5N+UBVtc7R/B0DbeeG
         6hQbAOsWiZJGMJQHhyV7z0rLOpiQnI88Kpnfq/H2E7I6eSp2uQwTqckG0ilWoF6hiRcb
         +kdVlOb9G1EyJi7rQqUDj/L1BcKchOjW7dZLKyBPe/R04tCGpJjB1KCdjREyPbCiROAo
         z5mp5g9PpcQDm8Tl59UpUBbCQVdkj/v93+Kns2cknjEF7k41WLCWaERi/t1dCECghLn5
         zpNgfb9TQoBWmzJ5oywiFqleFiFULAPy24wCYcVoxUlUXV02gHZwHdqUP1Uv0FI5zDt6
         YnAg==
X-Gm-Message-State: APjAAAXMTE5RhP6qgi+fX4GjyUUAreqfm9tnCUWIVXsYnsypez+Y+Ku7
        N1FS9f5zilXUe0tKthbU2ZU=
X-Google-Smtp-Source: APXvYqzAyJtG0w+5SrLqkpfET0wQjyfRnGbRniypN3xH00arCjp3js9BeMdpSLeLRKK1cq2EeSAipA==
X-Received: by 2002:a50:fb82:: with SMTP id e2mr2936983edq.359.1581157744209;
        Sat, 08 Feb 2020 02:29:04 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id f13sm257742edq.26.2020.02.08.02.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2020 02:29:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] io_uring: fix openat/statx's filename leak
Date:   Sat,  8 Feb 2020 13:28:03 +0300
Message-Id: <14f45901fa84b4f9f46e7cf9afa20ac1324f6ebd.1581157341.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581157341.git.asml.silence@gmail.com>
References: <cover.1581157341.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As in the previous patch, make openat*_prep() and statx_prep() to
handle double prepartion to avoid resource leakage.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f5aa2fdccf7a..c3bac9d850a5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2536,6 +2536,8 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 	if (sqe->flags & IOSQE_FIXED_FILE)
 		return -EINVAL;
+	if (req->flags & REQ_F_NEED_CLEANUP)
+		return 0;
 
 	req->open.dfd = READ_ONCE(sqe->fd);
 	req->open.how.mode = READ_ONCE(sqe->len);
@@ -2564,6 +2566,8 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 	if (sqe->flags & IOSQE_FIXED_FILE)
 		return -EINVAL;
+	if (req->flags & REQ_F_NEED_CLEANUP)
+		return 0;
 
 	req->open.dfd = READ_ONCE(sqe->fd);
 	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -2763,6 +2767,8 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 	if (sqe->flags & IOSQE_FIXED_FILE)
 		return -EINVAL;
+	if (req->flags & REQ_F_NEED_CLEANUP)
+		return 0;
 
 	req->open.dfd = READ_ONCE(sqe->fd);
 	req->open.mask = READ_ONCE(sqe->len);
-- 
2.24.0

