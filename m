Return-Path: <io-uring+bounces-6997-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD47A56CF3
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:02:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F42E3B9148
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D06DB22170F;
	Fri,  7 Mar 2025 15:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bufB9Tsj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0111E221700
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741363193; cv=none; b=XsWTj/kJPEuk0GSLOQnlb1BqrXuMCaachqLuC29zpE8f2rsqSqiu6Quy/EULXU/V3NylVym5QKGLJ1np/CIsSbp4SwrLhwt1vcSI3a3fB/8Yy6Xr+aiCl1LG5rd8D6RyvNVaUCWfngyCFSEbauIhU0p81RJQv2CR9ooO4B80rAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741363193; c=relaxed/simple;
	bh=q/FZLY6NX7KPIL9q2sRYyOUjPSfSZOW4huImrRHQGAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKxa1cJFI2EM6/A6KVMO2iBBKzHKU5rubxeG6CsmKjsG+pumefOpFS+ULZi1+Cguw947hMlr8w24gkZmyla373fvvTD8bRr3WVAHmjV4GTs+dzfVPFSqyB2NjlO+2t+Khe8qyehiCmDqr8/phaXfwx8gGhF0C2uqrvDOEiHJt1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bufB9Tsj; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5e4ebc78da5so3783903a12.2
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741363190; x=1741967990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VMFfmh910ijk2bF3gt2GcETiZRuBH9+UmQ8at+7H2ws=;
        b=bufB9TsjEUcNygk9ED7RNbWJTPvkuRC80AIVWXAVX9P47HgnTd4HVS61GWfudUvUjW
         95+i3Ea5Tljdth0NJdi2hR2882EKRWr8ohPfkiYs877VBI+piyD2cqqlVy8rfq/EkREW
         nZcU78SeS0ZwAdrMMponUCAmG+t93W8IW3Pv9Bfd3qq+TQOSQkvRjqceMzrshv4RRjyF
         MBiTivr073aPWEmGsO6zmGqWnAUWsF9qyOBXkerp7GQbLhEoCqCfuJ0qGs828BnMmeYg
         kUGeLFB/onoWOTZmrbTB/md/LNy5KHvoBZfoSeyZEMUnhuOmNTJ2ZXLBLDlpZ0YZItSS
         K9cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741363190; x=1741967990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VMFfmh910ijk2bF3gt2GcETiZRuBH9+UmQ8at+7H2ws=;
        b=NAMGwdpjVFUGJEhKZ7ZCpJ5AQhS9d/krw2PKrwOpSJOPJnheovczmeiIUSB5U+Q3Js
         uYPH6gbc2enhqKceBLTc+IJ6LpZIrLmcg9smw5bq8mJvRCpsGPUtymafAeloaf0bPklT
         P+kcDqhfvySfjltZEsvo15oJT/PvAz7Xb2TdqnmEvGO016BUg/O3kMr8z2h6mxa1gce3
         Ltuxc5tN832BZ2RnXVweexiwiOq2FlOaQMJFUmbhuIjKZ8EtQk8AmEzK/twR/dg3EGyg
         eTpK5qTGhk3x/X1Xcs9VREiS5FW4oFGsYkAOsHDLGEO4WcRqrLJ8pWl/9LCaX69XezwC
         CU9w==
X-Gm-Message-State: AOJu0YwkIvHe0VMyjBa3R96r7bdRBhuk71vZuIzpT4ye4ziEi33MPNHY
	9zUta2OmCoM+SJcb+BIv28SC+RqgdjIznoAfXkNng3ADsB3z5OjPvz23XQ==
X-Gm-Gg: ASbGncun5efxW4i+vyglAI/Jh9XKOSYgrUSrxQClptDzN5ve0fMz7LErbL26jSSo2G2
	Xc0+Xa4By8cvYMDkdvPPBnU8ziJ34Dq/Ffd8KwK72Qmf6CbKdt/9UA7xTxBdaLNrroJwSLvSyZH
	xJY7XWyj+D1icENBobc7MI52KL6YCUpM04FAoRh/ZBn7O6D+ef5czayomlUCEO06sNRmGpEXsTn
	voX/2CAZf1JHVi6eRy/Pc7jeLfMtuo3Bao6uCKF2RxqDLchdiImrGsVTLySbAVVL7/+5ntiFu/L
	J6T6cMGGCVMMh8VBYGUqECAX80Ht
X-Google-Smtp-Source: AGHT+IESAV9FwjXI0vCPxaqBaKD+zN4bGui3c5TxUArk14HeoW1pYdOWE40jQPjX3kFQViZzelhinQ==
X-Received: by 2002:a17:907:1c1f:b0:abf:72c1:6e6c with SMTP id a640c23a62f3a-ac252ba1906mr475468066b.45.1741363189458;
        Fri, 07 Mar 2025 07:59:49 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:a068])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac2399d7a17sm297369166b.179.2025.03.07.07.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:59:48 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 5/9] io_uring/net: combine msghdr copy
Date: Fri,  7 Mar 2025 16:00:33 +0000
Message-ID: <25795660f7b31f9273911c99f495d9c2b169ecda.1741362889.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741362889.git.asml.silence@gmail.com>
References: <cover.1741362889.git.asml.silence@gmail.com>
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


