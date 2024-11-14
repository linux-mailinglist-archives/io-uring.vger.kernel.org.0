Return-Path: <io-uring+bounces-4676-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AD6B9C81D5
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 05:14:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C61D01F23305
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 04:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C6F21E8826;
	Thu, 14 Nov 2024 04:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X/3tAWrr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECDF1E764D
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 04:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731557650; cv=none; b=HnkXVnM1FRkCw8/R4W1EGC0wB5WDdC1lQAHOk4dPYZRTHoMFRVaYViCMQFNQIiC6GDNOOq0+juJse9hFs/cg4tR2YQfFSggyXKEf03mAQAltw2TX1hQOMM07/Fz5tQAVlB/EW72Xa9fqMuRQAskd3OqJywqoeIDlMTcLaUWkyvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731557650; c=relaxed/simple;
	bh=u3Wc0/xVaiErX3YVMXm4hPEwS5V4DhAIBRegPiFdKGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRnEE9zbI6dR4OszKNWZMjrrQev6Dj/9IZWD54r3kSTA/nf72B2/OyrJbf/xYhZfyvneKIdZJraNAfW35nwsuXsktVS+VG5ASInon8gnKWmNuU5CQYuTANZx3PCP2gkRV6cOY/q+Yg97V0hHQMPMsU/x0Ki4jmi4XGs0wnAj5Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X/3tAWrr; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3821a905dbcso100451f8f.0
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 20:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731557647; x=1732162447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tWEpMmG2R8KKbjhtSOySdI1WYY5PGi2mDcfqLVFJT8Y=;
        b=X/3tAWrrQMiCMQVbjlggijH/m+jFfN/eoIvOQBXi6UU9mhvpleMKxRoBfW+lqCbzzV
         kyjbIuMlTYVB9Tw0EjMpxTd/BgsmcJdQ4OL/wr2rOaUy4efJTzoX3Vt75srLJpkFmXnZ
         FUj7xUX8SqSwv7osOFzIuOAcr/lYZQ1K4abzCUw8z2KOkZ0bs1iqXN2Qz+UjsYc2jMVj
         Mya8QCrd4JTKZHmYgCWhXv5msmosPywTFCLr8kVcXezp4JPbi3znIu+ZHv4pk1khPcu9
         Ww46sw2dxzdlUw4Xl1wDL7Xlo/YntKpKTm0vtK1Tj4s3bhVMiRcf5CbL/x6FLe44hUZV
         xiJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731557647; x=1732162447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tWEpMmG2R8KKbjhtSOySdI1WYY5PGi2mDcfqLVFJT8Y=;
        b=puAXJ3Vh3xwGN6NaaniPNXrFx/Eqpt2APnJ5c04wz6ZgQ/QzNVMYNfIiZ+vHdPlC7F
         sQuBAE8fWNuY+o2dVwHep3IRiihb4yBwK3JWs+odzxQYVbN7fu4JOO8alq8D8Bu84B0b
         mvYu/EpdvyE8CmsyeRHBD7koDdXYNrQn2QqjQVrMrho+D1F9bBTh02zEQAbSLI5S+ghu
         zGeiBFvps2GhlXNm3PytFI/SpLwwm4zvNFHJJwfcz7DTPFpP2Bq0Ri7NIavXPSaTzGLR
         Eq5Nbgq9Ftn+iAT+RHTRw2X3L9IKLHjyUff/5gQ4dmH4BYP9VckS0iIgKP2NEK5ZY/6V
         yxgA==
X-Gm-Message-State: AOJu0YwYuSP1nhw6cn7AV/DvOW3M6dOmjw8e/ZLlxo24rTbL7x+i8ZbY
	NpHzXbLzI5mw6hUjN95/BI2YpUbFwLtJJej3HMIzmqzfA0HhiL9xwFfYpw==
X-Google-Smtp-Source: AGHT+IFLI0PFWBdtVeYmAZVvdqnP3jTnyclk8AYwqd/aQLzq6fMCSmZgCMnnqODsNsqWS1dfCq/ozg==
X-Received: by 2002:a05:6000:1845:b0:374:c4e2:3ca7 with SMTP id ffacd0b85a97d-381f1865142mr19540743f8f.5.1731557646560;
        Wed, 13 Nov 2024 20:14:06 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821ae311fbsm251936f8f.95.2024.11.13.20.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 20:14:06 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 6/6] io_uring: enable IORING_ENTER_EXT_ARG_REG back
Date: Thu, 14 Nov 2024 04:14:25 +0000
Message-ID: <25f44bd38403f2a87fa1defe2dac84b3b04b2659.1731556844.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731556844.git.asml.silence@gmail.com>
References: <cover.1731556844.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We can reenable IORING_ENTER_EXT_ARG_REG, which is now backed by
parameter regions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c640b8a4ceee..8b4b866b7761 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3195,7 +3195,16 @@ void __io_uring_cancel(bool cancel_all)
 static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
 			const struct io_uring_getevents_arg __user *uarg)
 {
-	return ERR_PTR(-EFAULT);
+	unsigned long size = sizeof(struct io_uring_reg_wait);
+	unsigned long offset = (uintptr_t)uarg;
+	unsigned long end;
+
+	/* also protects from NULL ->cq_wait_arg as the size would be 0 */
+	if (unlikely(check_add_overflow(offset, size, &end) ||
+		     end >= ctx->cq_wait_size))
+		return ERR_PTR(-EFAULT);
+
+	return ctx->cq_wait_arg + offset;
 }
 
 static int io_validate_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
-- 
2.46.0


