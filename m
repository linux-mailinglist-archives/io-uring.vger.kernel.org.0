Return-Path: <io-uring+bounces-6785-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22F78A45D63
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 12:40:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2868B3AADF8
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 11:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC5C21576D;
	Wed, 26 Feb 2025 11:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YUKHf85G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35CD17BB35
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 11:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740570045; cv=none; b=sI8LORov4OEHI6aECVLUXLD6ypfRMUZqUiguck1Lvcwq3C4Hr7ErVvRAk+Au+NCE7zFDeVhFKDdMowqezjSMY1U6OOPJBWCJEhCPkvbJ6k6U3bmYpoqnPWrj+wsTGOshON5EHBOAj1Qfd2Jxj4SWO/npcw0QW4mn7+ValNZvQeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740570045; c=relaxed/simple;
	bh=kdqId0mP8jeHPu8z0z587kbx+n+rMncOGELARTQSY08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuIujDCxEkh51R1wnaSvuCoRphP1+SNIhxM9UO3fb8frnszcCNgsKjT39LRFtgWo++Vko+3KPifXf1QEWTE2DgprA3TJkbP7qj/WfyqH0gZ5VFd7VRq227KzDBVbPBA2RYs72O4l7vPSh6gimxU3jdnzzFkizcLjiKdUv/0NN0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YUKHf85G; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5debbced002so1473000a12.1
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 03:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740570041; x=1741174841; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z8uwK6v+DsppZ0r8tWopdQYtvh9gO1Hb9aYAqj3+BIw=;
        b=YUKHf85G/TGI6IjJZjBsqhZ3GrvlFwxQjidRbxxA6nXHUPfVq3bV/MP5QPS8v/xe0C
         oEK631xJT9LRciR1YIH0PQ1+8kqBrH5R2KpnYzGujApi1SVzKJpFcGdAcCrsAjwQl7Ni
         VvCzMCnASKQMYGIlbuljwc/SugQ4NQSoIWJPKyslLPZgpAEjf97B0K0anjnsxY37aTfj
         pS6HObjIeT76BPYMpQQfzfJwYmXA7v4vsBJewrIByCx7rjrmIi9fuv0koQtDgbvCsbhw
         kcmc9gnkn1VlGmonRSSh0kLTyB4stU9JdvssVMrf9S3adT/tl9XvxVhZR8JsHNqV0WEd
         734Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740570041; x=1741174841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z8uwK6v+DsppZ0r8tWopdQYtvh9gO1Hb9aYAqj3+BIw=;
        b=cQ0bsM/9ScsyQNnemSZX8dbx0Agkgmg6rz7oAVe3/44gUIkEEq8nMuhVc0pavITxJG
         89/409jrs9OSiA5cr3XXiR2aY5NpAAihNAQC0RSDIj+4KKQaKD5iCgYEpgyyR6+HBies
         6HePFqO+PDCLqgVp4YOLH2iG4sGG9Nl9nFk7snzjd+LDovXUlg0XvlNu7yYVQBEUXSco
         Lvbtuhzhl4szW1qJifBkO48YYkTmj9IJ5SPb01qlQk040gIiF9Vn0hYZlACx+c1aW7Dp
         bLHdseeuwpM/ocHVNNPljqwT6fHOttD4ezNpWUpyYjH7QxW9z+meagaw5UltF31zy5l+
         ZpJg==
X-Gm-Message-State: AOJu0Yxe4dSwGsDZayjDUOP/5Hzx7vAQzel5D4WmlnP1TKNfarz3ytGc
	VCu6DvDovYO5Of+eYxJC4rSHCs4vunUV3yJgSM1DkSEmL8P5nJWeqg7EQA==
X-Gm-Gg: ASbGnctcv1MDZ7ELBYCXpAzFbryFkOKY2N8mdvc3es/PTqEge8j0vLzGwvadiF9wg6D
	fHmzIQJC3f1AGa+pRpmnn1XN/XGsnRhqdLVjaRGmw+HmcZE4F91V5wVqdtkSBpwM7MkeubgvzCo
	bMNCcMtZzMcwooXSfhqH4IxItl2WFJKwD1A36YjP04330R9lbtFCLdohWECv2Rd+a+e1EQ9Vv35
	Kil6tAQO/iJkD5dl/bJwO6gNOjTF81KyXDYr40+u8TjKlsUIgBvM84ix6Orx234+72wliXbQNPT
	YcF3exjOdQ==
X-Google-Smtp-Source: AGHT+IGW6DIYt+ms97jTAtciWBDJO30HBhTQKoSe1Oz0P5hRVPrREsT7yfJUwwlqYl0/sIZQG7cvjQ==
X-Received: by 2002:a05:6402:42c7:b0:5e0:8840:5032 with SMTP id 4fb4d7f45d1cf-5e0a11ffb02mr25271336a12.3.1740570041271;
        Wed, 26 Feb 2025 03:40:41 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7b07])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e45b80b935sm2692418a12.41.2025.02.26.03.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 03:40:40 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 6/7] io_uring/net: unify *mshot_prep calls with compat
Date: Wed, 26 Feb 2025 11:41:20 +0000
Message-ID: <94e62386dec570f83b4a4270a46ac60bc415fb71.1740569495.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740569495.git.asml.silence@gmail.com>
References: <cover.1740569495.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of duplicating a io_recvmsg_mshot_prep() call in the compat
path, let the common code handle it. For that, copy necessary compat
fields into struct user_msghdr. Note, it zeroes user_msghdr to be on the
safe side as compat is not that interesting and overhead shouldn't be
high.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 8a9ec4783a2b..de2d6bd44ef0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -716,20 +716,20 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 	iomsg->msg.msg_name = &iomsg->addr;
 	iomsg->msg.msg_iter.nr_segs = 0;
 
-#ifdef CONFIG_COMPAT
 	if (io_is_compat(req->ctx)) {
+#ifdef CONFIG_COMPAT
 		struct compat_msghdr cmsg;
 
 		ret = io_compat_msg_copy_hdr(req, iomsg, &cmsg, ITER_DEST,
 					     &iomsg->uaddr);
-		if (unlikely(ret))
-			return ret;
-		return io_recvmsg_mshot_prep(req, iomsg, cmsg.msg_namelen,
-						cmsg.msg_controllen);
-	}
+		memset(&msg, 0, sizeof(msg));
+		msg.msg_namelen = cmsg.msg_namelen;
+		msg.msg_controllen = cmsg.msg_controllen;
 #endif
+	} else {
+		ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_DEST, &iomsg->uaddr);
+	}
 
-	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_DEST, &iomsg->uaddr);
 	if (unlikely(ret))
 		return ret;
 	return io_recvmsg_mshot_prep(req, iomsg, msg.msg_namelen,
-- 
2.48.1


