Return-Path: <io-uring+bounces-761-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F4F18680F0
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 20:25:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9B7728D399
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 19:25:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25DFC12FF76;
	Mon, 26 Feb 2024 19:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f7N/KZAP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E08312F5A4
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 19:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708975518; cv=none; b=iXsEPvk0wDc3fdgO7tZxz/sIP7he6zPtDZJdKJxK0KxyLJJCnK0pAHoQ6XPoJRzSTqO3lQWELT11Lh5RZJ/Lp7vWY+yjCoSS3n0Nc58DaqB4jaR1ffw3qTNLus9AqOw9O9QIqQrSL9tLfcW/DC574lBZmwpOUNaYi9eZynpYIZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708975518; c=relaxed/simple;
	bh=SJj4iMt8345K336hGQW61NIJ2oZAfuUExnbC6B2sJG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmWvCSuOkcjc+qd+FopuJJvQ8ixDP7tuNQ/JlklHuMex3KzYaSGZoLxQg2Fz/WmNvU8qv0nOqxjLqXxFI3U8v9iXSBD/8mAL+1k7FKO8ahNVFl8lGwWlZbJWoJ+imV4ISTFhgRnisw/6LGp83f3KHNu2GeVrW0zf9H4sR2jdXLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f7N/KZAP; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7c495be1924so52267339f.1
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 11:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708975515; x=1709580315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y0eR1eNEDBGH7MxRpFv9waoCL0rfS8tfLNM5reazrhE=;
        b=f7N/KZAPyvcERa8cwUzETLZcfViSZ5ByMrmo1fmNSOtnjf8k8Pcrayc2aG62nv+vm+
         8HW6szZue1qLAhPlc8wqSHFk52vyMNuJuXyL0W90xil1kQjbrMi3I6ZavLQbaAuaOOUx
         H+mCfIvBzt9oblm2Zv1fXgAXrOkHYZ6LRiYKVUjekqARXReWVnHfKfbT65Zn3DoWXZr4
         Kff1WTUOd15Uqfpz1/nuQ5U6dHbnCJVbkoxZ9WSaZSaH9meDJdjfDBIGLgPCtrrLezlt
         JyXx4ubOJ2W8dtX8/v/sX3DLp+Tr8pBzry2F7Y4uJ4snSl18VR345nDWB0ML/zX3m6oL
         DVSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708975515; x=1709580315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y0eR1eNEDBGH7MxRpFv9waoCL0rfS8tfLNM5reazrhE=;
        b=vSgHMLbbHS/XHbwWDHrt2coVl3whodmmVzjqiJlzO6PaO15H2YCrZ/J+E7VfuA70vf
         Vwqal3xAxfcz6RULgcCisjy8xvPKK5EERqPJGThQvegdF4j0YFU0UENCV+acKHoGfteJ
         6Ji+NI4bymDcH4uWi9Wb+2FtxHrj/eiF87CiFGyKpU1pR6ra5eHOMD2qIZfrwW7zp+Or
         zfaL0yGXRF3ycvKGPRp563KBHVydmzJNvF+OMzyTR1cZr2G1DDJthf+KB8VKZzRSBzmX
         NoJ58Emc3w/NvKzNj69vUXALP5sIBB7u0vNT0EKWgzuw626AnAukibL7bL9FwEB+ogM/
         pTVw==
X-Gm-Message-State: AOJu0YwQPZFhstPfPsmWIhNV6pGOHyoE46opBEhhPzmianzQa28SLBWG
	dM/l7ZYhRf3QUCbBcUz1ZozvA++yOWGDvHB1frqE/RVygu/Fasgf78vloJ4VMswm74935gUG0sP
	t
X-Google-Smtp-Source: AGHT+IEV1FCkkOdVKqHo5zik2qi6cvoMB+zTODXhLgxQoigGsL/LkvlgKRbDZcorSLRG5CJJyKIEYg==
X-Received: by 2002:a05:6602:38d:b0:7c7:8933:2fec with SMTP id f13-20020a056602038d00b007c789332fecmr7386801iov.2.1708975515391;
        Mon, 26 Feb 2024 11:25:15 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id eh3-20020a056638298300b0047466fd3b1dsm1370484jab.22.2024.02.26.11.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 11:25:13 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/9] io_uring/net: move recv/recvmsg flags out of retry loop
Date: Mon, 26 Feb 2024 12:21:18 -0700
Message-ID: <20240226192458.396832-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240226192458.396832-1-axboe@kernel.dk>
References: <20240226192458.396832-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The flags don't change, just intialize them once rather than every loop
for multishot.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index aaab4f121b7f..c73e4cd246ab 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -843,6 +843,10 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (!io_check_multishot(req, issue_flags))
 		return io_setup_async_msg(req, kmsg, issue_flags);
 
+	flags = sr->msg_flags;
+	if (force_nonblock)
+		flags |= MSG_DONTWAIT;
+
 retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
@@ -863,10 +867,6 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		iov_iter_ubuf(&kmsg->msg.msg_iter, ITER_DEST, buf, len);
 	}
 
-	flags = sr->msg_flags;
-	if (force_nonblock)
-		flags |= MSG_DONTWAIT;
-
 	kmsg->msg.msg_get_inq = 1;
 	kmsg->msg.msg_inq = -1;
 	if (req->flags & REQ_F_APOLL_MULTISHOT) {
@@ -952,6 +952,10 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_iocb = NULL;
 	msg.msg_ubuf = NULL;
 
+	flags = sr->msg_flags;
+	if (force_nonblock)
+		flags |= MSG_DONTWAIT;
+
 retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
@@ -970,9 +974,6 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_inq = -1;
 	msg.msg_flags = 0;
 
-	flags = sr->msg_flags;
-	if (force_nonblock)
-		flags |= MSG_DONTWAIT;
 	if (flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
-- 
2.43.0


