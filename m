Return-Path: <io-uring+bounces-6165-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41B50A2134F
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 21:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F702161109
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 20:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF2411E0489;
	Tue, 28 Jan 2025 20:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EAISXVAJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2234A1E0B86
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 20:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097766; cv=none; b=N1gE2HcztELtX/ywEjLC1ymPlqsWAvHbfDd/7AmyeYVnOvBn5k+9uGEEIu0jlfBvxMmYIHOKyTzBqhildeSseK9wnkynCGDKyZrYEa9bTpvfGnheYJqQ/3m4HxB+gUbub5053echAuygvZGscAPVVH/XnMetwLre0dWLfXesQjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097766; c=relaxed/simple;
	bh=lJMsX7fwcXCs3pGvHw0xLW1w/NHfT5TXSttUAoPniRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d70F9LZK8sf5FF+C2y2EtFoRJvO498NnYcnAsmWDVl+8dzhFzVTOGOmbmNs1TgDqMwzhkJi6b7pxlNHcJcULLC13B6WPZrQg8c1Hrbqxzg0mmwiLTHcpJ1K1n83tQCmI3ZJv5ZzKE5TYtm5W4nLOlr8oBJiGtN61/9HRtz2fqoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EAISXVAJ; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d3ecae02beso8361848a12.0
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 12:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738097763; x=1738702563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dwu43/+agNeXzNqAHNIvMyn7pi826l4I7z/JOZ0Hto0=;
        b=EAISXVAJvsDnEHgeYkvQF6Vx1mu1FkXc86U1tgPd+y82WUNlZtS5yEWfj/VtP3Miqg
         asCn2eHclGzQrZO60atdO538uSr60Wq6N5UKlBXdYElpjqn/t6IwzHLwaNtXiPFGgIrE
         eeHUkduBInlFJGEyJ2vH8ENKViJyPhXeW56W2C9uAdykigiakLKK3ptRbrdQyGdMT8lf
         VnS3TMx87TYCe0Ddnw84awYAF9AMFdGK4dW7/LGrxEFQKeCOZ5xbqNOUGX6xC59U7KUj
         mOe6/3kQfV7/dVmQ79h/aQrFYY8SdWiA5TTSDbYCFcHZZ8c0wD7rM7S/NX1EiFxB45yX
         8wUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738097763; x=1738702563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dwu43/+agNeXzNqAHNIvMyn7pi826l4I7z/JOZ0Hto0=;
        b=a2OOiJcX52HDAZGQFuRv35IygK1iZAjeN+0jaWE0jDtJxpTIp5DoC4oJcY8wvDhQlb
         6+wLdQAuVrrWEVANCOJ7SdlR2Xlpec89I9j0lIvQyYdCzzYxNTnN03IPfLokOSkJ0w25
         etoNOREjol7gu12cSzHIxjbOmP/+rcTsErPv6XS/XXRlOp45ff/1NN2bnPGblV2hcwW4
         PHWzyCK/xI/3rfRbTZenaBf8uCErlAGQBawI2DSAcBiq4V+87x2lytpP3yVXVvTDltfS
         BaU/IM9plEhg34wyOvsi50aI5USWQoBxfD3JK8ekn3XrfKZSmbZ7+c0wbB6Et/I7/gjs
         L8yQ==
X-Gm-Message-State: AOJu0YxRRdfDZbHwzH/umWZZ99J9933oV7tqN301IliBbOGIRVMRGJoZ
	uJC7xBVYPimsGx1zCFDFJbuQRrDgXfsPFyVUhrzG+LoZE/csgwNqs1syNQ==
X-Gm-Gg: ASbGnctVEfAeuDr8WZPcI4i9X41PRQUa8Hd5qUF9vGBrx8uRFIm9eMqp9YyVdxlJwjv
	jTorpbtoQNPB2To4MfzoKWlPD4ztROsH0189TqPCMvlCuImAw88isPUWjBl2EeYej8MVyY86i43
	kmo+fdMNao+uE9O1lrBAZhCtyYKWjoAJNRJiARFbyjizyjzIoq5ZyZUTbLJF5OxxctlgW7giYo0
	f0YdK2XtCH9TAPlzMrn6+JmyTBf0zx/O5ipBSQnMT5I2wi3nkGMsksken14UDFFTyQlJ4HMn9L/
	z4cfrqnW4JHeeUNPRcx2WahFHxOg
X-Google-Smtp-Source: AGHT+IG2vZVotXpxXRQ0ragVBPE3DOXbSRewQs+70/rUAXXbP42SEA7GCsh9w90K3vDygKzL0ALVZw==
X-Received: by 2002:a05:6402:358f:b0:5d2:729f:995f with SMTP id 4fb4d7f45d1cf-5dc5f01a8b1mr378580a12.29.1738097762903;
        Tue, 28 Jan 2025 12:56:02 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.145.92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc18619351sm7736949a12.5.2025.01.28.12.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 12:56:02 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 4/8] io_uring/net: make io_net_vec_assign() return void
Date: Tue, 28 Jan 2025 20:56:12 +0000
Message-ID: <7c1a2390c99e17d3ae4e8562063e572d3cdeb164.1738087204.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1738087204.git.asml.silence@gmail.com>
References: <cover.1738087204.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_net_vec_assign() can only return 0 and it doesn't make sense for it
to fail, so make it return void.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 41eef286f8b9a..e72205802055f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -168,7 +168,7 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req)
 }
 
 /* assign new iovec to kmsg, if we need to */
-static int io_net_vec_assign(struct io_kiocb *req, struct io_async_msghdr *kmsg,
+static void io_net_vec_assign(struct io_kiocb *req, struct io_async_msghdr *kmsg,
 			     struct iovec *iov)
 {
 	if (iov) {
@@ -178,7 +178,6 @@ static int io_net_vec_assign(struct io_kiocb *req, struct io_async_msghdr *kmsg,
 			kfree(kmsg->free_iov);
 		kmsg->free_iov = iov;
 	}
-	return 0;
 }
 
 static inline void io_mshot_prep_retry(struct io_kiocb *req,
@@ -240,7 +239,8 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 	if (unlikely(ret < 0))
 		return ret;
 
-	return io_net_vec_assign(req, iomsg, iov);
+	io_net_vec_assign(req, iomsg, iov);
+	return 0;
 }
 #endif
 
@@ -299,7 +299,8 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 	if (unlikely(ret < 0))
 		return ret;
 
-	return io_net_vec_assign(req, iomsg, iov);
+	io_net_vec_assign(req, iomsg, iov);
+	return 0;
 }
 
 static int io_sendmsg_copy_hdr(struct io_kiocb *req,
-- 
2.47.1


