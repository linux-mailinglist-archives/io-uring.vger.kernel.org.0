Return-Path: <io-uring+bounces-32-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9FD87E27A0
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 15:50:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05F971C20C04
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 14:50:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 881CF28DB5;
	Mon,  6 Nov 2023 14:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kz3WMSrx"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B81A28DB0
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 14:50:11 +0000 (UTC)
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A980F4
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 06:50:09 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-35950819c97so2509795ab.0
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 06:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699282208; x=1699887008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AFcyNMJewhQz4VOTCpiQ0Xlz5TSUcp+/nFCX7qJUqNA=;
        b=kz3WMSrxUzhXqucizP/rcx7P5jOdd/GfrxwmoKzzqTLeR0r9RPpDAlWqxLhG1IN9FJ
         YSBCaAVQwq3O414SvbNCuEtnb/c/IJuBzG7Wo1/rReWfb+3og92300yVrL4oGi+MRCfp
         tGzuLsEGpwLpsPZNqv37TFniyJ/Uoba2o5RnS2l6+mlr6lkzxodRW5vl4vCx/DZkddHF
         6tMSfmYyCGNFWjyXzIiQUdGzzHES8ZuNHdBjBD/jxv6Qf9fTM0m8ciI8PzQa1NbY4cWE
         4bJfjNeiSCbsZl2r53eoZgXy3oEUhEwblBcAe6sKSRgT8L5Wby/Y8yibxerjzi57uJcj
         Z4qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699282208; x=1699887008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AFcyNMJewhQz4VOTCpiQ0Xlz5TSUcp+/nFCX7qJUqNA=;
        b=o6G+glvYVEWtSWaEdp2bIwaXYb15FXVabDA0fNZGzNnB1XGWN4lZyoHoQ9YHb6NyZ5
         nowzBGx6ugTrvENDc9E1kiJbVXZ2lrc9Brr6Rfu4FrlvVXXxWSjFbGZODJlGmeQK7G2Z
         tHZ4ZQbCwdiyWMiH9OFthPIGlQeoeqoa2gJh+M0v9niG2hPJ2XpNtxL+L20P0oKfkjni
         ZfmVSNWm/jWx+2knGkXgTuVfl4/3cLe8u50uTpA7uv5GCCiL+hg6lmSetPp9wSDxdypH
         uHf9rU7P+98HDJ43/OJ9hnw0hberOfrUqAskSWlZclGtkWdhXBhACOrXo+SJa786iRdQ
         izgw==
X-Gm-Message-State: AOJu0Yxx++QVNf+8jGA5mD6expVcv1npCf41lrf3tnmTw4z3cv0okEpE
	n4Qyau3ontVQy5eP/K/FKngQwxkfuXPF5B5IvnVF+w==
X-Google-Smtp-Source: AGHT+IG3JoLRfuXa1moTOG/DVAbzdRUNXiqGNslODXkJBzfpPn3dkH5hKw7ngPWmThcvtNlzDgTgXQ==
X-Received: by 2002:a5e:8614:0:b0:7ad:3ee0:86fc with SMTP id z20-20020a5e8614000000b007ad3ee086fcmr6426885ioj.1.1699282208280;
        Mon, 06 Nov 2023 06:50:08 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t2-20020a6b0902000000b0079fdbe2be51sm2378375ioi.2.2023.11.06.06.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 06:50:07 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dyudaken@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/rw: add separate prep handler for readv/writev
Date: Mon,  6 Nov 2023 07:47:49 -0700
Message-ID: <20231106144844.71910-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106144844.71910-1-axboe@kernel.dk>
References: <20231106144844.71910-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than sprinkle opcode checks in the generic read/write prep handler,
have a separate prep handler for the vectored readv/writev operation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/opdef.c |  4 ++--
 io_uring/rw.c    | 22 +++++++++++++++-------
 io_uring/rw.h    |  1 +
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 25a3515a177c..0521a26bc6cd 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -66,7 +66,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
 		.vectored		= 1,
-		.prep			= io_prep_rw,
+		.prep			= io_prep_rwv,
 		.issue			= io_read,
 	},
 	[IORING_OP_WRITEV] = {
@@ -80,7 +80,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
 		.vectored		= 1,
-		.prep			= io_prep_rw,
+		.prep			= io_prep_rwv,
 		.issue			= io_write,
 	},
 	[IORING_OP_FSYNC] = {
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1c76de483ef6..63d343bae762 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -110,15 +110,23 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
 	rw->flags = READ_ONCE(sqe->rw_flags);
+	return 0;
+}
 
-	/* Have to do this validation here, as this is in io_read() rw->len might
-	 * have chanaged due to buffer selection
+int io_prep_rwv(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	int ret;
+
+	ret = io_prep_rw(req, sqe);
+	if (unlikely(ret))
+		return ret;
+
+	/*
+	 * Have to do this validation here, as this is in io_read() rw->len
+	 * might have chanaged due to buffer selection
 	 */
-	if (req->opcode == IORING_OP_READV && req->flags & REQ_F_BUFFER_SELECT) {
-		ret = io_iov_buffer_select_prep(req);
-		if (ret)
-			return ret;
-	}
+	if (req->flags & REQ_F_BUFFER_SELECT)
+		return io_iov_buffer_select_prep(req);
 
 	return 0;
 }
diff --git a/io_uring/rw.h b/io_uring/rw.h
index c5aed03d42a4..32aa7937513a 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -16,6 +16,7 @@ struct io_async_rw {
 };
 
 int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_prep_rwv(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_read(struct io_kiocb *req, unsigned int issue_flags);
 int io_readv_prep_async(struct io_kiocb *req);
 int io_write(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.42.0


