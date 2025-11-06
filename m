Return-Path: <io-uring+bounces-10402-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 969B7C3AE66
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 13:32:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CFEB44E1701
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 12:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83264309EF4;
	Thu,  6 Nov 2025 12:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dmmn02Rs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A0430EF62
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 12:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762432323; cv=none; b=eUrA0P1IdeRSkX+KGoL1hCjLTWIUnEp6+vqQioCda5xjGXq15fpI+n1sUImSPGPRAW2w5GU4GWNuNOG0c9c7SMVBRqEu7OT8GIR30daHKuK8+/wKhzD5orLIGNvC16I1ekqbeQ6nkuhhSvx5J+7dPA0yG69WQ47Mu+DlMoB4XvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762432323; c=relaxed/simple;
	bh=3GDTE9cqdeSgsNUJ0uJuzgsh+fAVgM8MV+7RAdDPHSg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XImpp86SbpKX35owfQ2BeIosohsAssbauBp3iovvFeSWRqD7yGmBxPL1oZEWFxX5IRzeOb4AfPXjemsqJq+IflM750RsutOzbx91MvKlRx7qvQtuoHe7jX1/h9kp5csGxv6rondcSizWxJRnQFF0FIy2tbxGA7TMuGf1y1fpN7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dmmn02Rs; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47721743fd0so4240675e9.2
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 04:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762432320; x=1763037120; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ryrJTyV3BiBNpc/Xqof1daYP9wnmws9NKZ1gFhM+lqE=;
        b=dmmn02Rs4f19kBwiiIlB8YJuAYiIwFUCoA3ESQN5QgXokL0Sq4Xt2B3Hl5Z6457bRg
         wItwQS5VrY5jBTX+1Ih9YWzG54i1b+h9ztNEsP8D8/zCO8voT3d+51IsFEV571AoXUnb
         2GVwCWQsCx6C/Q60crZSpoCXafqYT1H2GqBcJP6/y8rvhH+htg35s8RaYP0aAyv+wjZ/
         Jyy3w6J/c7efcSceguUdYG7LHm140U7p4OFFxPEpiLcevr1zbfedLCAJBHkJalv5AurE
         TS7tisYtnHQ+rivbTcNRJHtcz7rrb1IHrEe6U5pQ9XFYtT9103AbwOCF3BoXtSdG8Lyt
         gTDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762432320; x=1763037120;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ryrJTyV3BiBNpc/Xqof1daYP9wnmws9NKZ1gFhM+lqE=;
        b=cmDKr/cSUBXlMwVxalcFUh7fh9Hw72bPpSfIStyQeYt97I8DChaFlZCQhNuYJ1sjde
         utVVZI8cIPtUaTxoVhJnN+3QdvQwPOiUnLSNZjJ2sjPGS+iCUfQD3UPN5uVYd8S/lZZ1
         Z2g046c3NhkhOFfuTgC+HQV2CGa1SwP2linQI5/mpOn1fFt/AyJNfwrJcC4jPns6TjwA
         SoggPBqz3GlMuswSZkdxKh6k8SFtF89WhFcMvLaXAqAaiFAEXkfD4Nx/8s4nPwwuWZQ2
         Yx7CUVqXFy8uq+jg/rXQd1lu/HHE9aOsDcCkM6Cc1iH8nDb9wDiOpHyHA9hZXWk/P1EN
         OPFw==
X-Gm-Message-State: AOJu0YwK45qa7oaUQx1bz8sFJF98oZx/0ZvadD3t2Gh7hVTpNLgyk1+T
	r1skQYt5YxAL1TwTqwGC/ed08D4BEr3xPeZTkj0dqnfGaOgV2RqDojUF1cnNyg==
X-Gm-Gg: ASbGncsWNzfBZf+6/2kOjpkq3fNJfpzF5oJyWVMMQaaLqfmOwJxY6sFQF58zKAu4zMb
	T3mOHIyY8e3bq6/M0dJxTd8CrlCsVfJlrFBhuGu6D0sZhNogfuiDCAW8vx/5cAVvbeGeXomUmiE
	TAA4W0RGNGVl8r62SX+WJKHZkGZuiO0WIDTLuiaW62jbgVHtb3duL8VVjnfqW86GJkRHY/TP6at
	qSKOp6WOhJB6jGUW3XM1RSP5aYM/jOeQI/YrONxrEEoWZwK4JB9WqME5kVzVCC/8r3OJuFiSLAd
	2ku6cVtZJX0xL7ESJ8Hf6/yW/gU7pvN4B5xhOJcqM0pxSudyG+PYWwi2+0TWrpabQrXNrCjGU7x
	xpNbnoGPpaDbN01UplkKhWgPiBp8jgfxSzueVHQ0yKzKbohagtvCiNtshb68867TSeeIZXAUb94
	e6fyY=
X-Google-Smtp-Source: AGHT+IE2+VleCRVhXHr0nmL/dOJZR6bMWZ+JBMEchwEb7F+d9UFbcYLCkxHbljYyV2HthucHnhjn5g==
X-Received: by 2002:a05:600c:1e1d:b0:477:a9e:859a with SMTP id 5b1f17b1804b1-4775cdf54e7mr61710355e9.22.1762432319456;
        Thu, 06 Nov 2025 04:31:59 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47763dd53ecsm16502345e9.1.2025.11.06.04.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 04:31:58 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/query: buffer size calculations with a union
Date: Thu,  6 Nov 2025 12:31:56 +0000
Message-ID: <669d1e9701194fe86c69d12bb629b21242adaec7.1762432299.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of having an array of a calculated size as a buffer, put all
query uapi structures into a union and pass that around. That way
everything is well typed, and the compiler will prevent opcode handling
using a structure not accounted into the buffer size.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/query.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/io_uring/query.c b/io_uring/query.c
index 645301bd2c82..6cf732936b3d 100644
--- a/io_uring/query.c
+++ b/io_uring/query.c
@@ -5,14 +5,16 @@
 #include "query.h"
 #include "io_uring.h"
 
-#define IO_MAX_QUERY_SIZE		(sizeof(struct io_uring_query_opcode))
+union io_query_data {
+	struct io_uring_query_opcode opcodes;
+};
+
+#define IO_MAX_QUERY_SIZE		sizeof(union io_query_data)
 #define IO_MAX_QUERY_ENTRIES		1000
 
-static ssize_t io_query_ops(void *data)
+static ssize_t io_query_ops(union io_query_data *data)
 {
-	struct io_uring_query_opcode *e = data;
-
-	BUILD_BUG_ON(sizeof(*e) > IO_MAX_QUERY_SIZE);
+	struct io_uring_query_opcode *e = &data->opcodes;
 
 	e->nr_request_opcodes = IORING_OP_LAST;
 	e->nr_register_opcodes = IORING_REGISTER_LAST;
@@ -24,7 +26,7 @@ static ssize_t io_query_ops(void *data)
 }
 
 static int io_handle_query_entry(struct io_ring_ctx *ctx,
-				 void *data, void __user *uhdr,
+				 union io_query_data *data, void __user *uhdr,
 				 u64 *next_entry)
 {
 	struct io_uring_query_hdr hdr;
@@ -73,11 +75,11 @@ static int io_handle_query_entry(struct io_ring_ctx *ctx,
 
 int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 {
-	char entry_buffer[IO_MAX_QUERY_SIZE];
+	union io_query_data entry_buffer;
 	void __user *uhdr = arg;
 	int ret, nr = 0;
 
-	memset(entry_buffer, 0, sizeof(entry_buffer));
+	memset(&entry_buffer, 0, sizeof(entry_buffer));
 
 	if (nr_args)
 		return -EINVAL;
@@ -85,7 +87,7 @@ int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 	while (uhdr) {
 		u64 next_hdr;
 
-		ret = io_handle_query_entry(ctx, entry_buffer, uhdr, &next_hdr);
+		ret = io_handle_query_entry(ctx, &entry_buffer, uhdr, &next_hdr);
 		if (ret)
 			return ret;
 		uhdr = u64_to_user_ptr(next_hdr);
-- 
2.49.0


