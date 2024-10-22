Return-Path: <io-uring+bounces-3912-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6A199AB117
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 16:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DDCD1F241BD
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 14:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DD6A1A0BFD;
	Tue, 22 Oct 2024 14:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cpzbxFx8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDD219F49C
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 14:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608168; cv=none; b=HMUIxlCmEn+UrigCN/JnQ+C/iKXZEDIa3sXTMVp53aiRV69fuU6HH9zkD2y7xI+5ms8G5BpiWMhwqsmZoVqT1oq6reg4bx2VjtcRLTdHU2jg++IilyKGJhYLNNIXdTAgG6QsNX0WHgxPt1DCc45TNbNrR5ehnHtLV1G9UM3mdPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608168; c=relaxed/simple;
	bh=LLMAyzjVzCHC0lMplM/PxfHLu1sviICy98QmeAIpg24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5tu5GpjuaKPJzvpRNdBbkWslBAWqZWkXnGiCzxfOgHcez0BpVrgu6m2mdVhaQvVefO6vd9FKGGDwa/vbqEBX4wcsflRAAyLEPKsliXZDP7MmXg8Vq+5NA137n053Rw2xcFL7mmYDHVKyW0aIug30e1TWUX50LdssdFjQU3BvQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cpzbxFx8; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c9634c9160so6225110a12.2
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 07:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729608164; x=1730212964; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TKQdQvaaPOZjv5rywWtr97sd8FUzNk7jVmtMShyoNp0=;
        b=cpzbxFx8OCpqjInXsigyFMoZqQY/G+jL5Y0Wi8MfeqqSYGz4/BOUasLNvb08HSl4qk
         axlmQHWI+HVPGoeVvmLfDi7uIQRdOltN6pHZ3F3Us4QB5/BTtpDx6cKn0xZHCCVVel3H
         1CVO8BBIlh+sjvVhh/9RmZuP/65IRZuqso5RRHbtAlSK0/OaBBLTTKC3H0Q450xnsiNo
         4HG0b2Dh6L+5k1uE9orqUz1Da+x7fF5Qnk1jlpkypjUAQl0+DVCiisllIbIcRFunjHVW
         NNiY9ZSSbkcOijhPzdrVQ/MZgMEh69OTRlU/0RM5m+k8QQjSktcsT7XV7tC6Os46Cay4
         uhhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729608164; x=1730212964;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TKQdQvaaPOZjv5rywWtr97sd8FUzNk7jVmtMShyoNp0=;
        b=iGQhrJffXpcpX9QF9/llLvx2cT3oRBNRAu+XJLy0+Ov01x7JaQKIPC3NKGnsBxq1NQ
         Mkau1ImIB5dzqsyuozz8G02EtniWX4Rw4dcmJiXjdJ4t5eIhnfOmZCAiFxiuemMBLz/L
         aEUnI0vvxGa+ezk4af6DPv3YNDfDDKAfx/EWR5Sx0m7wI30YNd/lJfxLAAfkuiGsrMjC
         VTcogeKVXWjg7xJl+yZl07Sr/ZTws3kMlpurikccYkj2oUt7L7FfRtx1GtQhKks7ReCS
         ELwsQguO+dojkGPyp3XOv4iloUU+mZb09ToD5Jyxaql7Cc5NoMOxAfiFfAbA8VNtlI5w
         1QQw==
X-Gm-Message-State: AOJu0YxWqSez6rWdJB+IXBj+8tvc7jImhk7F9KwU2SjILOfBtx/2hBoH
	9b42WZqEIq4vW6/eWOVZ7FUnj+ZNEfwBigChOw3z9Lz0CePtOKoe/zIcxA==
X-Google-Smtp-Source: AGHT+IFx9pf8yOBp3HQQwuHjmz3PhO1Bm9mdbK5WB3a880lq8qt/qNWEGfr7w5oKbhQVuf05akhgNg==
X-Received: by 2002:a05:6402:1d4a:b0:5cb:69a2:7ad0 with SMTP id 4fb4d7f45d1cf-5cb69a27df0mr7344626a12.32.1729608163202;
        Tue, 22 Oct 2024 07:42:43 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.112])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb6696b631sm3244434a12.9.2024.10.22.07.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 07:42:42 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 4/4] io_uring/net: clean up io_msg_copy_hdr
Date: Tue, 22 Oct 2024 15:43:15 +0100
Message-ID: <26c2f30b491ea7998bfdb5bb290662572a61064d.1729607201.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1729607201.git.asml.silence@gmail.com>
References: <cover.1729607201.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Put sr->umsg into a local variable, so it doesn't repeat "sr->umsg->"
for every field. It looks nicer, and likely without the patch it
compiles into a bunch of umsg memory reads.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 7ff2cb771e1f..ccdbb3c42ac0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -261,6 +261,7 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 			   struct user_msghdr *msg, int ddir)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct user_msghdr __user *umsg = sr->umsg;
 	struct iovec *iov;
 	int ret, nr_segs;
 
@@ -272,16 +273,16 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 		nr_segs = 1;
 	}
 
-	if (!user_access_begin(sr->umsg, sizeof(*sr->umsg)))
+	if (!user_access_begin(umsg, sizeof(*umsg)))
 		return -EFAULT;
 
 	ret = -EFAULT;
-	unsafe_get_user(msg->msg_name, &sr->umsg->msg_name, ua_end);
-	unsafe_get_user(msg->msg_namelen, &sr->umsg->msg_namelen, ua_end);
-	unsafe_get_user(msg->msg_iov, &sr->umsg->msg_iov, ua_end);
-	unsafe_get_user(msg->msg_iovlen, &sr->umsg->msg_iovlen, ua_end);
-	unsafe_get_user(msg->msg_control, &sr->umsg->msg_control, ua_end);
-	unsafe_get_user(msg->msg_controllen, &sr->umsg->msg_controllen, ua_end);
+	unsafe_get_user(msg->msg_name, &umsg->msg_name, ua_end);
+	unsafe_get_user(msg->msg_namelen, &umsg->msg_namelen, ua_end);
+	unsafe_get_user(msg->msg_iov, &umsg->msg_iov, ua_end);
+	unsafe_get_user(msg->msg_iovlen, &umsg->msg_iovlen, ua_end);
+	unsafe_get_user(msg->msg_control, &umsg->msg_control, ua_end);
+	unsafe_get_user(msg->msg_controllen, &umsg->msg_controllen, ua_end);
 	msg->msg_flags = 0;
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-- 
2.46.0


