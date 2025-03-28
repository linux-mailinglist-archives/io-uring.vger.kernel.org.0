Return-Path: <io-uring+bounces-7289-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC84A752C9
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 00:10:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70C06188FF88
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 23:10:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6FC51F4282;
	Fri, 28 Mar 2025 23:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Af4tsUHL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69461F180C
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 23:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743203426; cv=none; b=Iozd+ctUDpnrn+UPezPUKYYBi+nbdEYORt0anvNN3+TMFzcatXAstAoMWoh49g5ospyxLu5AuLKLpyAKt6RCuoLzI5JHFOKI5p+gVzBY25BZX3Qa5uMQArarjkGRliDJZcvxtnTzWl0KJuql7bacfcsIBqHriuSuqS6SN/yQh5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743203426; c=relaxed/simple;
	bh=pfohiY3gLhmEF6mm//S5JjS//jtAAN9DLtVTTe1wM1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7vMPoKwkJFAAjJ7lXhsrjE3LCBvvSLGGniyVhevpTAaHeyz0k1YlpHMfIK85yGtFy/jTndwgXLYfeeHlq+ZVc0oomED48NTwjMibCD/wnJdTu40xNK9qGKmlYKBJkExUTDqktRVAfIztAFxEJ4Q8lCep8vaucWKFv+SubozihU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Af4tsUHL; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5e61d91a087so4354418a12.0
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 16:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743203423; x=1743808223; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d2/Vq2XFEWyYZ9UT//dodrp0lMZ5Xmzy/2U4EiSVBGM=;
        b=Af4tsUHLNVKUCzdvchQWISmRBhkpdrjVqEPf804bli9uH/R130IrE78/kXuVIW1am5
         ywsICObMa680XlAIbX2rSoYW4NvMt2APAIbzPBu4+7AHmnI/fP/kGkqitTUhOKYUmFit
         gWQkfZKliwN+OJVr6kltuwRzNxDTuiVjsGZbVzcDdN5IcUNSazCKjethQwKuFKPKbwb8
         ejpkqVy1pf9rBIZoP5pzdZUS1GTke9tAD4ja/wn95SbDsDNQJxjenDlfklQV3Ie8xlwZ
         i4LrScNa60Yj0ac3H1lgAz+tXkW2UlQMrbSjZ2jWqyV6T/eE+2/Dui8PHvmcGhh0aSuD
         H0Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743203423; x=1743808223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d2/Vq2XFEWyYZ9UT//dodrp0lMZ5Xmzy/2U4EiSVBGM=;
        b=VwLzemJSE47biB3/iSwDBeJIUBcpQULgpYs2V6rFkdxVLYJjte1LNHWvtYpo6sU7di
         jMDjvh0a2CI8w0B3jHeymxpkDUJ/ZznIyHdlHOv7aQ17sG21EE0KelEifONBodH9pr3h
         R48gK1+V8dv5XQUbeaPEvIc/nFGSxoXLtc+p8LmX2ushQs0lKuiCVGcnaNNYOXFo1eg0
         Owr0jvQoRP0AtlE8NpjBrOQ3vQASu56n4rYb3Brk+SKYzf9C1eMJY7hqSMQnpe+Wowew
         rQI2sfhdwjMCn4RXfTCLpshn7CvmbVsBmBm1EGyobx4gQLzfsVUkRpxGxN8EKNlvbbHq
         Q6jg==
X-Gm-Message-State: AOJu0YwAXYxou/m5u2cTE95ctxfHxkXa+fFNEH73ALYwEvek1me4kdaU
	8EmKI3/s3L7a6ctjAF/GglGe7z3rI8/MvcStiiLuMPwG6HngB103OmEgSA==
X-Gm-Gg: ASbGncsSym4nZivEmdzXmtj+hjWLP8fMVdDCj8amOYkFVmYiJV2AIQLk9bWGbpcRLVN
	77vXIQ/8s9UHzo+ujypdnD7G5JJ6wtdvSWPOVYAqYBTRKPnjvPS+cksi5gDIckAbHbHRPFG0He2
	2efkscerJ9irbfUnCH9dV1vVQ6QJqKQXxKKdKeaOLS2YnJuXnDR0vyPKF0acEVeC368qk2M49H+
	WLF1knbr0PjTojNdG/xVWKT2ZMXY0T8xWPlsl0p0X+fvU21uYSpLVs7VuBCk7ZYU2ArgI02BluH
	2a7LnThP2jNL5ccr63KrbBAYk2ejaHmZ9JF9mVIJtQ9jUnjA768yYRJ0Ph/Z3lpdGt8D8Q==
X-Google-Smtp-Source: AGHT+IFUu3d3A0oLU7SFZWIJGMCKOXnJ1dsT7gYa+nV+FHNz7sQ7XhSDXfh3daBWa+z4b9A8uEpMMg==
X-Received: by 2002:a17:907:6d27:b0:abf:e7c1:b3bf with SMTP id a640c23a62f3a-ac738932c5bmr75341066b.11.1743203422609;
        Fri, 28 Mar 2025 16:10:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71961f04dsm228915966b.91.2025.03.28.16.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 16:10:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/7] io_uring/net: open code io_net_vec_assign()
Date: Fri, 28 Mar 2025 23:10:55 +0000
Message-ID: <19191c34b5cfe1161f7eeefa6e785418ea9ad56d.1743202294.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743202294.git.asml.silence@gmail.com>
References: <cover.1743202294.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Get rid of io_net_vec_assign() by open coding it into its only caller.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index fefe66c2f029..78c72806d697 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -176,16 +176,6 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req)
 	return hdr;
 }
 
-/* assign new iovec to kmsg, if we need to */
-static void io_net_vec_assign(struct io_kiocb *req, struct io_async_msghdr *kmsg,
-			     struct iovec *iov)
-{
-	if (iov) {
-		req->flags |= REQ_F_NEED_CLEANUP;
-		io_vec_reset_iovec(&kmsg->vec, iov, kmsg->msg.msg_iter.nr_segs);
-	}
-}
-
 static inline void io_mshot_prep_retry(struct io_kiocb *req,
 				       struct io_async_msghdr *kmsg)
 {
@@ -217,7 +207,11 @@ static int io_net_import_vec(struct io_kiocb *req, struct io_async_msghdr *iomsg
 			     &iomsg->msg.msg_iter, io_is_compat(req->ctx));
 	if (unlikely(ret < 0))
 		return ret;
-	io_net_vec_assign(req, iomsg, iov);
+
+	if (iov) {
+		req->flags |= REQ_F_NEED_CLEANUP;
+		io_vec_reset_iovec(&iomsg->vec, iov, iomsg->msg.msg_iter.nr_segs);
+	}
 	return 0;
 }
 
-- 
2.48.1


