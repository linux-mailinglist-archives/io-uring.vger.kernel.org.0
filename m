Return-Path: <io-uring+bounces-6987-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7675CA56C89
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:48:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88D5F1890D0C
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 15:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D1E21D3CC;
	Fri,  7 Mar 2025 15:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VRPB4vXm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24A521D3D5
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741362499; cv=none; b=oV1rlhzUkryttj/YqXQpUUOTdOazVKdo1sAyw39BRu0E9KeSycExrZ3AwOkZVCncRoy7XO3TB50wkl3b3EsnlR63Kk2MFIyUmrs/nXcB6HWxAwzsKEuA9UATPl1FELvmxIKc6YROIXbrMy4mUj6b+uQDmNX/FuANv2CnFZaj584=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741362499; c=relaxed/simple;
	bh=q/FZLY6NX7KPIL9q2sRYyOUjPSfSZOW4huImrRHQGAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8qgN28nA73YqnCC5xAaA0moeVq4eeNyy122yo57hY1yNR8IzAP5lI6ydysbiYbA2LNR2VvP1QUECLVFZ7JI+wJI6Bjbz3Klbvkxc1y5dnhzOPFzvQlZbsJKZ4qlD6K0Nzp/zw+jyr94TXoDDKti/271r0XwYfa5phNDUdZiHXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VRPB4vXm; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5e04064af07so3771453a12.0
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741362496; x=1741967296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VMFfmh910ijk2bF3gt2GcETiZRuBH9+UmQ8at+7H2ws=;
        b=VRPB4vXmxLdFycOWknF4RJA6jk/DfKOF8+sP7my/XUsqSlZ/jYyWP0qc+mmAzbZoIK
         KcDm5wIDoOMR9dIADXDtcqCWGLtAuxz1pKp8Agy388zwXH74GaOAHPdQlgPXRabBelBA
         t0BRk96D3DxGQJVkJGA4GOK2s4S8CZSnyQhc7J9vlFuiBO5K58WDdQ7mCJ0T2S+0qwpl
         EtvByEq4kjMj4a58xOq4fjRIY8Tx0sHkS9QwVTerzDjMqNiJieb5P5QloR9qkyofBy3j
         8czbF23jyfvY0UPMJ6xicSIKmNPKBtbCCaTcOSzGj+sQow8bbVtwxrPYpesbyNXcztwK
         XS4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741362496; x=1741967296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VMFfmh910ijk2bF3gt2GcETiZRuBH9+UmQ8at+7H2ws=;
        b=P9lXc4nL9yBiPLGy7AB11DSoGpO37gtv4EDoF+rozUYu+QDKPXxDf1aNJKy26HCF82
         8wYEorNJp+fFmpyYnr9nqnJmsSyha/DLw0K7zPr3uhaFGyYRcUCHodD3l80yDu4ol+MI
         kGfQPlv+1/fQrfrZtLTpatuKTkwewDNZVHHIWK4FjLM9Tj7h2w1Ba+pCnLUgZkgyAwGb
         8pAPxqOPYiuB/uDV+9Jmbc3IduA8Yuo6FtD8FvVvXhYxHr9/3HzcsCVQrK3Lbq1H6ASQ
         wF8b9X6VXbdfXXpPiPZFneLyMFl+hrziwP6kJ7C0trnh/ocZUmx6dgwDr7Nwvs/Vtmb3
         uV4A==
X-Gm-Message-State: AOJu0YxmSpvRGCC4mRPZXKnQ3AJjJSsouB+67NFBojoUqOY9PwCV3Clh
	2jn+kI2hVtHAABjfyhOTjkkn4xXAscaqdCwuG7a8dz1BSdbSC3ieje0Ftg==
X-Gm-Gg: ASbGnctFF/hQ3fLLRFBLLoj5TfLsse8kdKRWTsi6N0uBVR8bELnuri2ZEieBf4PRQt2
	HI6cz7ZkHfW999bDy8rkmiddSz08kz+beR3dr1X6ltlWn6SoJvzuwvPSVkORf4bhH3Vblu3H6IH
	zQyagxVzAnv3yburE6HVqLK7+SScFOrQDDNvPE+JNrWS1DndLFvtuzzR1raCRzNFGYVVw5UvILA
	wdT1Cuq57TEuZZVGL+LMRkMvx7d8tZs+wvWKX3qMXLNh05GkwZyLsZvaft0xbsHfwWgoyRpdAxQ
	hYOnQ/EQZ1/A7M7gh7DIoHmUsXed
X-Google-Smtp-Source: AGHT+IGFSV9ZSbOz3IWTyLUIM7qtuI6iq6wAEVZ8fN/ZSNPOSM3gyokHk8UPblCgR2yVlUUbJRMg6A==
X-Received: by 2002:a05:6402:84a:b0:5e0:36c0:7b00 with SMTP id 4fb4d7f45d1cf-5e5e24d402cmr4225999a12.31.1741362495836;
        Fri, 07 Mar 2025 07:48:15 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:1422])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c766a033sm2665591a12.56.2025.03.07.07.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:48:15 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 5/9] io_uring/net: combine msghdr copy
Date: Fri,  7 Mar 2025 15:49:06 +0000
Message-ID: <c88b637b51e147f30d33cdb20663ee9013b9662a.1741361926.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741361926.git.asml.silence@gmail.com>
References: <cover.1741361926.git.asml.silence@gmail.com>
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


