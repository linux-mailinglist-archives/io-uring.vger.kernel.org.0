Return-Path: <io-uring+bounces-709-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B99A86289C
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 01:40:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D35F5281B53
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 00:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C6577FD;
	Sun, 25 Feb 2024 00:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ja6c1Zqf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CA410F4
	for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 00:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708821601; cv=none; b=uizVzAMyf6GYzEK2irlho6unqUQBCypv42qS5+YGn9luL5M5Os1GRbraJuCcx0AnTzcOlhgUgNI/WWjq02r9CpiwH5P4nJSEbrsmwsRs7Yhq6P/8Eu1twsLn6yV4Xr6BxNY6Dby9x47lTyxfzp2m0a/QlQP/OdaVSXNrtRXCa8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708821601; c=relaxed/simple;
	bh=peO494qYRoBM2DluyJlzyCy7oFDWhquPo33wmiwRUlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrSKuaUIpwvmqMHs5rmPVO0X0ruq8s39t90ynmxnC2PJWqO0nzJJMqmp7jTuKbadXEHKDIn9vXtbkzegxRsBOPcqQkhQChk7ghs1iRaRN9JZP5iP/dPziJtjbsSPI1STO5sLbB+8SKqHySOEG1mFIlnd2SSXmKDLoZMF7Ju0RO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ja6c1Zqf; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-5cdbc42f5efso864009a12.0
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 16:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708821599; x=1709426399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZqgkzRD5fxa2R5gbrgNqkGIM72hLGfqmZT6jWLnrvH8=;
        b=ja6c1ZqfXizpihLvyd7K+zRMda0fyxKSrvv4SbNcdm38lEklCK/I2vbK9vt00xlC/z
         5YI96q5zMe2X9mVKgpZfGPq6VMJ0kdkM8dENDFJ5qVZfecIBSpVZuqTIuz/ivdttQWt7
         RnUqjKYGOwxkytFUHv9DbZnj2Gg9S+1F+2PK3RQ4ghoGlIttciFcdqEb5X2PguKAyin3
         tQrC0DLfitkIEs1B1es057tlecplMRFAfhnY2hRii7j/P4OQao+cbracSw7jBuXXKDq+
         /5OsH6fEhigY7bUTDAKS98YIDO1HT+pP/aPQP00zJ79FLrlKT9ZLqT/D+IAolVubCACo
         RjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708821599; x=1709426399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZqgkzRD5fxa2R5gbrgNqkGIM72hLGfqmZT6jWLnrvH8=;
        b=cZ1ujDi2+GNgdJ+oEKFNf/rlTAM8so4ShWoXc8ygEBwK0lzdrnaMCRJxi9m/M8FXl5
         lX0glrPFHPODrLBE/HTUHSY4TF6gFBXCVDeBkAXtrmFCeZwJOmiQ5RTSwoa63rkZqh+O
         DKqDTp+lZdGfWGqsuHoDgqwIum1O1Om2US27xtdFaGkfN3x6+PGiemXLUocmLYJbCdFL
         n/4x3OE7P+JsWXMoAqZqDxbV90NMcwPH9zsfuhDUUbqG3+DN/FUDSeA9Ux8ksPrPCoQs
         PkFevfOOWy2rlYB9RG09uk0EtaBvCO5xQBHkvysWr28aqhoNGZQdyNnlu3IA9LU0Axt8
         xO/A==
X-Gm-Message-State: AOJu0YzIdhM9XNSGNW7fth9bTtAwfYJYxixiR1zugr7OgdMtVKD6MCGK
	H9V1IbYuFrGrXK+Gv/ZOBBIYGoabkLakrID0DnDR4jwH+r/eetoA1toeGsRgxID46bVpOd5eywy
	i
X-Google-Smtp-Source: AGHT+IElM3CLEysaVY4HXkVtCTWJMxzeNVK2W+wCpCRyfIrvHo+uxy5XIbjCGyOd19Jr1iKosDRl9Q==
X-Received: by 2002:a05:6a20:938f:b0:1a0:f897:738a with SMTP id x15-20020a056a20938f00b001a0f897738amr138488pzh.0.1708821599135;
        Sat, 24 Feb 2024 16:39:59 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u3-20020a62d443000000b006e24991dd5bsm1716170pfl.98.2024.02.24.16.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Feb 2024 16:39:57 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/8] io_uring/net: set MSG_MORE if we're doing multishot send and have more
Date: Sat, 24 Feb 2024 17:35:54 -0700
Message-ID: <20240225003941.129030-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240225003941.129030-1-axboe@kernel.dk>
References: <20240225003941.129030-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we have more data pending, we know we're going to do one more loop.
If that's the case, then set MSG_MORE to inform the networking stack
that there's more data coming shortly for this socket.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 240b8eff1a78..07307dd5a077 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -519,6 +519,10 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (!io_check_multishot(req, issue_flags))
 		return io_setup_async_msg(req, kmsg, issue_flags);
 
+	flags = sr->msg_flags;
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+
 retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
@@ -528,12 +532,12 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		if (!buf)
 			return -ENOBUFS;
 
+		if ((req->flags & (REQ_F_BL_EMPTY|REQ_F_APOLL_MULTISHOT)) ==
+				   REQ_F_APOLL_MULTISHOT)
+			flags |= MSG_MORE;
 		iov_iter_ubuf(&kmsg->msg.msg_iter, ITER_SOURCE, buf, len);
 	}
 
-	flags = sr->msg_flags;
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		flags |= MSG_DONTWAIT;
 	if (flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
-- 
2.43.0


