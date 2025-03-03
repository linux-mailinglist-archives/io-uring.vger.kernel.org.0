Return-Path: <io-uring+bounces-6910-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DB61A4C5AA
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 16:50:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 060B2188D907
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 15:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E42A214A7F;
	Mon,  3 Mar 2025 15:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G35oYLmb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4C3214A73
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 15:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741017011; cv=none; b=UnuTfxy7NWzBJMZi5oQiDsiCgKhTEJdUtiINwzVGUyZN+bqYIQ0QMjzh38niWU6Ar0FerUighy8g7iLypU8NH5vmXkqPhZy5g7jrVBb0G308/M10gXZG8TO5iBgSD9SD9k44oU8KipBabX1SfvqyDfFpNZ1LEM3ZjbsCGTmw51o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741017011; c=relaxed/simple;
	bh=q/FZLY6NX7KPIL9q2sRYyOUjPSfSZOW4huImrRHQGAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/jWYobc2SLopYk8fLPgiob7fiD5kOJPZk9nZ60/n/8UWcrX2RQtpMpv2Mu6zOlH3J0ftsmgmGqE+Tv3UXkVyquw80fWA9O5o5dc0J6/UUnzPmbPR1NE3jkvqHkLfslPt5+0Umnk9UJCAw01T3pOAM6haKovc9TK5ftwznng124=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G35oYLmb; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-abf3cf3d142so358064166b.2
        for <io-uring@vger.kernel.org>; Mon, 03 Mar 2025 07:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741017007; x=1741621807; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VMFfmh910ijk2bF3gt2GcETiZRuBH9+UmQ8at+7H2ws=;
        b=G35oYLmbAWuADJQvHRHmOHcTz3QXsjyHxcxyqWmP9EVuLRK2Uc13o7rBQB+s1U8G1D
         fyAQPz0PXTdFhI4xoOr1/RQjQubQDab2LArdo3fYJn5SGyb3bnZNeqcFMG31kZSvqZ9S
         2XpT91VKAFlLz7FOk+TBDJQQLFxPrWbmMeFY1jb7B/IJ0u5crfwRJzZa2S6tTHNekIP3
         M4k3ONnHu4RCs8/AWjo0U1sOw9i9Qb9AuvGI8SQFU8MApw5rVMOe0BHmsEutmIG1t4i0
         FPTvZsRwUGCDbOT4pxW4HSDadObbt2PFR5Dhl7QHObGvAdmn383z3uvCPBKebs2K7JpT
         HDSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741017007; x=1741621807;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VMFfmh910ijk2bF3gt2GcETiZRuBH9+UmQ8at+7H2ws=;
        b=cdY0nINAc53EST3wnfF1AzX7nBtc8/5GiK/dRvRs+x4IYL3w7HaPE7nDkaFlj5gUM2
         IpmE4itJTYS6hPwiF0tUb3hC2Qq4vqxwwkQkH9yAIHeRCm+3t2J5/uTWRTGBzZWE7nZ1
         NyeLACmuXzTf3N03w7Cpsx6RnO5z1B8tVpMHzi5puUYFQnTAOH30l2ySQZlb14RKRfBz
         l2WxG/dReY9JTZtYrLsjpWTDrlRScRnman2zsa+RIC65GS286dWY8Zb9XjB7bs2KFN8M
         2KWFIgiZ59oSim2UZtWVBYUy+EcWJ/LIk2msdTe3ZGCEf+0j1O0Y4f1UAxcVV2fqXcqY
         FuQA==
X-Gm-Message-State: AOJu0YwGHG2/bzr2cTa6AEwEPCddzjXwCZA7FAY+f7LGnPAihu6R14bi
	KrrjYaLjCEK+11YhHLk9vQYhvT1ceXXloEmZhnunrs15EAur0j8fe0a2RQ==
X-Gm-Gg: ASbGncuaszHm/hdnV2/ZPeC6D+Zdigj6vlwm/s4hZYXG0mWZR+rouQy9aH951mthJlH
	ZPoxxgyo0YHIqxWFbyf/Fi6R1dXHm2jNuBF6BG4on3kOuLmmVXx0VP5SmalqiHVgqv6Wi+8DQyf
	JXaISzSCeE0/hoQLWQUnIWxmJI0LvBqW5JpYrD2yDtm/1RaJNhnIw3AYkSdVVVleMA/jRTfWSlL
	niSzQ/y0rb+Lu9A9j4Zd1mXiUbVfMltNckdXbJyqkGhP2IuXC8pbBoVr7mMtMGLswR1eGfPGwmQ
	LFVYx4G8dL8rcrFrUwu0+m+c2vf2
X-Google-Smtp-Source: AGHT+IEsKn4k5lnP374tskqgJJg/1CcMvM9epqoq78NM4lyJNlpbcHIH2nnr2krLQDpXbZ7/AhOBmA==
X-Received: by 2002:a05:6402:4316:b0:5dc:9589:9f64 with SMTP id 4fb4d7f45d1cf-5e4d6ad8c0dmr37532194a12.13.1741017007219;
        Mon, 03 Mar 2025 07:50:07 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:299a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf4e50c80esm492335266b.61.2025.03.03.07.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 07:50:06 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH 5/8] io_uring/net: combine msghdr copy
Date: Mon,  3 Mar 2025 15:51:00 +0000
Message-ID: <569c679f6eb96a976021db2618aa0a3566b1ebef.1741014186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741014186.git.asml.silence@gmail.com>
References: <cover.1741014186.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Call the compat version from inside of io_msg_copy_hdr() and don't
duplicate it in callers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 46 +++++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 905d1ee01201..33076bd22c16 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -287,6 +287,24 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 	struct user_msghdr __user *umsg = sr->umsg;
 	int ret;
 
+	iomsg->msg.msg_name = &iomsg->addr;
+	iomsg->msg.msg_iter.nr_segs = 0;
+
+	if (io_is_compat(req->ctx)) {
+		struct compat_msghdr cmsg;
+
+		ret = io_compat_msg_copy_hdr(req, iomsg, &cmsg, ddir, save_addr);
+		if (ret)
+			return ret;
+
+		memset(&msg, 0, sizeof(msg));
+		msg->msg_namelen = cmsg.msg_namelen;
+		msg->msg_controllen = cmsg.msg_controllen;
+		msg->msg_iov = compat_ptr(cmsg.msg_iov);
+		msg->msg_iovlen = cmsg.msg_iovlen;
+		return 0;
+	}
+
 	ret = io_copy_msghdr_from_user(msg, umsg);
 	if (unlikely(ret))
 		return ret;
@@ -323,18 +341,6 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 	struct user_msghdr msg;
 	int ret;
 
-	iomsg->msg.msg_name = &iomsg->addr;
-	iomsg->msg.msg_iter.nr_segs = 0;
-
-	if (io_is_compat(req->ctx)) {
-		struct compat_msghdr cmsg;
-
-		ret = io_compat_msg_copy_hdr(req, iomsg, &cmsg, ITER_SOURCE,
-					     NULL);
-		sr->msg_control = iomsg->msg.msg_control_user;
-		return ret;
-	}
-
 	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_SOURCE, NULL);
 	/* save msg_control as sys_sendmsg() overwrites it */
 	sr->msg_control = iomsg->msg.msg_control_user;
@@ -710,21 +716,7 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 	struct user_msghdr msg;
 	int ret;
 
-	iomsg->msg.msg_name = &iomsg->addr;
-	iomsg->msg.msg_iter.nr_segs = 0;
-
-	if (io_is_compat(req->ctx)) {
-		struct compat_msghdr cmsg;
-
-		ret = io_compat_msg_copy_hdr(req, iomsg, &cmsg, ITER_DEST,
-					     &iomsg->uaddr);
-		memset(&msg, 0, sizeof(msg));
-		msg.msg_namelen = cmsg.msg_namelen;
-		msg.msg_controllen = cmsg.msg_controllen;
-	} else {
-		ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_DEST, &iomsg->uaddr);
-	}
-
+	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_DEST, &iomsg->uaddr);
 	if (unlikely(ret))
 		return ret;
 	return io_recvmsg_mshot_prep(req, iomsg, msg.msg_namelen,
-- 
2.48.1


