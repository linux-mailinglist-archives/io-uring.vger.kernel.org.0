Return-Path: <io-uring+bounces-789-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15CBB869F8B
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 19:52:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D2CE289FD2
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 18:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E9ED3D988;
	Tue, 27 Feb 2024 18:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aGfuQig9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205A951009
	for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 18:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059938; cv=none; b=T1BletVmH6Qb1U4q63XCZZAj+Qvb/PDko8WCma/eAV5aAU8YHkKdz/+f27IDqjh4ND8xhNrqSls865RJkFQ9ROsLvYM8t+TWzETR+2A92jO92ekMU2YvuNVJO/Pcv1mEPhpGjXAE0L/qbmPwcG+TX5nLLhJUgnEdzxWUfJ7Lh2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059938; c=relaxed/simple;
	bh=eWMmgurVnS74plEJEDBqQPt2hR21lu/HCwoFIqDp578=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYfcMaB6w8Z2IZt0xg1A3VoIwSf3NUV1M2/7X7/PmynZ7+4FhmtgUvrjgmxk3kkTQZW0oyXxlf6ax4sXUzZ95vpLKIh+pthaYcF7PfaaB4Gcy/H56T+vCn/INrUmY4v6IKjywYoSR7HCVYDYOwqAIVbfyOHEVQuikGYyrj/FUiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aGfuQig9; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dcbf3e4598so503545ad.1
        for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 10:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709059936; x=1709664736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SJNK4P6oCRaJOCSI5a5JNdJbt4izWo8cRTeTXrAp1EQ=;
        b=aGfuQig9/rBJ6gYH90pHeNYF66DjVouEp04df9Xj/KDEV4gJbEejqcX3vuJ/OPxowQ
         JxTECQBmL+Zn3nHPs73uyC1g5/Cm7HglKv8aCfxRJcwaAh9ZaMFkJ+nu4yY1HpC1Zsdk
         lVgOF9Bbyk8vGCwJcv4u2qrY5hGwV6sxytJWwUaYoPt1jtnvaW8UvjWKbLVqpzBbYNww
         f01XiL4E+pmaTC2uFRa5W6aJyCPW1b7CkerYXh85VY7GjC7oHamIcvwWega0iD5q4j1A
         xdzL52/8CA3mgj5lx3FLt7gFe/LYYps5SKgWhdigUaE7EHl/AuboHvwdlpBBQGHQWpRI
         p4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709059936; x=1709664736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SJNK4P6oCRaJOCSI5a5JNdJbt4izWo8cRTeTXrAp1EQ=;
        b=Qt6mE5Hkl9MmTl3hd/E/cNr+GSfqavWxhJDRGIRu3X/nR9+9puSQA+sCjxsyNMkfml
         qR82j3JZktevIiG7Ebm8r5UPuq/EN+MlhWLUWlSRvVHPJ7zN87C/ZyeonWUhKE+Uo5+l
         iFypX0jpGSKu8eUz2WRostvJHRN9unRXdRvNIWuBIoX6UOeks9f/c6bjCQpeghrKkIEs
         gK/LMsdzaO+cyIOOQc3FvTYRYJHi+rhLi652xN7spW90KkkqeRGF6w0x8w2iNMI9qmNR
         JhfA3YEAuRLP1U+Gkwi3XvigWN692m4k+s49LCFGQQvYgdsx75XhpJ+YNpEh6u7eTqBh
         DhXw==
X-Gm-Message-State: AOJu0YzaflzXXvX5Ys7riNMA/PVoZFDPV0f96CkQ+2FoIzpq1bL27sGm
	J0aN069g8agjOmvhTY5vliblP0wYnR1tOjYDZYWCw1jdCHmX46xjn1LHU0FaMg+Z1A/cMvVyMUM
	7
X-Google-Smtp-Source: AGHT+IHrjheqDuX6NYP1kmQKmUJdh73z9leqV3/S2oHzGDpVqPaMVkv6VhXwb3y3+ZYmSVnJW1iLgQ==
X-Received: by 2002:a17:902:eec6:b0:1dc:83b3:99a5 with SMTP id h6-20020a170902eec600b001dc83b399a5mr10123760plb.0.1709059936016;
        Tue, 27 Feb 2024 10:52:16 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id l5-20020a170902eb0500b001dc1e53ca32sm1860721plb.38.2024.02.27.10.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 10:52:14 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/net: move recv/recvmsg flags out of retry loop
Date: Tue, 27 Feb 2024 11:51:11 -0700
Message-ID: <20240227185208.986844-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240227185208.986844-1-axboe@kernel.dk>
References: <20240227185208.986844-1-axboe@kernel.dk>
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
index ef91a1af6ba6..926d1fb0335d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -861,6 +861,10 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (!io_check_multishot(req, issue_flags))
 		return io_setup_async_msg(req, kmsg, issue_flags);
 
+	flags = sr->msg_flags;
+	if (force_nonblock)
+		flags |= MSG_DONTWAIT;
+
 retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
@@ -881,10 +885,6 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		iov_iter_ubuf(&kmsg->msg.msg_iter, ITER_DEST, buf, len);
 	}
 
-	flags = sr->msg_flags;
-	if (force_nonblock)
-		flags |= MSG_DONTWAIT;
-
 	kmsg->msg.msg_get_inq = 1;
 	kmsg->msg.msg_inq = -1;
 	if (req->flags & REQ_F_APOLL_MULTISHOT) {
@@ -970,6 +970,10 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_iocb = NULL;
 	msg.msg_ubuf = NULL;
 
+	flags = sr->msg_flags;
+	if (force_nonblock)
+		flags |= MSG_DONTWAIT;
+
 retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
@@ -988,9 +992,6 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_inq = -1;
 	msg.msg_flags = 0;
 
-	flags = sr->msg_flags;
-	if (force_nonblock)
-		flags |= MSG_DONTWAIT;
 	if (flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
-- 
2.43.0


