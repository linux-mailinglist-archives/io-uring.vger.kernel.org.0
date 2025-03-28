Return-Path: <io-uring+bounces-7288-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E23B3A752C8
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 00:10:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED9E81890278
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 23:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F0B1F4199;
	Fri, 28 Mar 2025 23:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eOenYfFn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C1B1F4170
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 23:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743203425; cv=none; b=JqoLZYnRlyxEI9MVjxG34YyonIMrGCmU5K32E4jGLYNKWFU3L0iNormm0iAJo1EYh6AOxZxIMgyPGtuOwc6Ue1p/TWw5THhrf4tvy2bYomjx3tQKAMbha4o4soVcVpCaugklJWE6qYvQZd7/LNLHXvyePO8HEDX1QXq+ZHNVKdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743203425; c=relaxed/simple;
	bh=Y/fiP1v+FsUuVLuzHz7CU2h58F31zxI8C1H002mhp64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAnsOCg/zQq/+/4qBkvGInUXuEaJy9acttMtp5pTqTVOMU480QJ0jQ7JERo8Si6GKuhCmwK+SIE/BYS7vQasa6IhOIXy70Omo96J1B2Htc3kQ33PPAQp4QVLCS0gVpKV8SSA5fJn8P7NNeJwUNP9B6OjxvbDSOsT69ZYRl8bi+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eOenYfFn; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ac2bb7ca40bso520250466b.3
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 16:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743203421; x=1743808221; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=56KfdtGJFtkzbDr6PNEAPYr+/QVEqxl0tvfDOuXU6/w=;
        b=eOenYfFnXWsD/0BAfuJ+d/Bk1HHg5cjVDizqnAm2EEMMGNRC/WFn7EX5I96/6nct+S
         xAzbIkCEWMV/i7BQFqEgUAVWhLDKuBBM0Vl27UyZXcnPpPDkw1kmcdMFnEKLUj2xPQ47
         hI9fNp0MIFRv1Ku1q//szaiR6WspapM7MeP+UBgJaY9yRfB/6caugi3lH+Gu2tdd+sqI
         ebthdV7dSvF6vt4cvRJRLp1z/rm1tNdmmxy4wDlRYNwJ4rjCeEs22mnRVdg5tMyLoc4Y
         HxFzxYr4CacKCtHagRJLspF0zltHD6zVdqoCFvkJHY279dNhHQqqCAFhVjW+fid3Ep1R
         ofHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743203421; x=1743808221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=56KfdtGJFtkzbDr6PNEAPYr+/QVEqxl0tvfDOuXU6/w=;
        b=E4QOMmXPYTOq4zA+/W3+CtADL9Z/NJTOiSW3wUKOIqaMX3oVnfyzw/Iq0funHBF6Hc
         UJvBheNfSOXEsBjCy8rgUr+XyazChblEsohCjH7t+5ZYQiwzno1d8EKovTQgclY9Vkn+
         McweD+z/wes61dI9AgiM7jPBBQEQ55oAM+NTG5xcYH/SC6qOdukAYu3vrdCTWI4VCcxs
         uw+YXeXnQ1LOhhBBlklbu7x/06sHqHAy5GgASRa8uwY9EW5BdsHJ01VjavX2iR7NV+NH
         5B09lmWwLm68ZbYXzaxZz7PLikGwe380CuqgdQBnA804AQwK4LR30NypcCZE9tJgCmzL
         W22Q==
X-Gm-Message-State: AOJu0YxSowsuKL8BZ0vqbVP8FQrgF2YEHON5Mjc5pwTRqMG45Lkm7v73
	I9hxTDiKtlRtSwtfIb2jDaXjQLt50B7QECBwzpWIc4RlU0z+GnFHRTuYFQ==
X-Gm-Gg: ASbGnct2uV9Dns6Fmc3iXkJdUyKVZg5MM+dMiSndydRCuqagIJPyrJEqYLgW/CTmvVx
	exY1Tf5iC+sjSb+PL7F1Gf7MKQ6uIoyUazHeBFJy9cU+luOLVtcSEjk3CwZzvifbzygsHNSV6b7
	HqxI5vdpjJxpHXQ2TXaL6amLSo3oGs8SPHUB7BU5ebcF+NgbvzA/aPVZt4wvASDEmYttO7ET/+V
	wZnFBAOlEhSoOVEpMcG8CTNqN3tUF/1L9gg11hXW2cJOxASdHY0r0cq6pi21VUCqTPcuo/Vky1q
	eLIRKecnmbMp5bKxVJ7isMx4OEEaXWHBzVVitOETScLagjn3ZKMuPWTB9B4=
X-Google-Smtp-Source: AGHT+IGPo1ceVUMl81lftza+0DqjxWdR1paJSOBvzhzxMVnL9jQa4ixuev85lZ1QAej92QvQDRJlzA==
X-Received: by 2002:a17:907:9484:b0:abf:7a26:c47b with SMTP id a640c23a62f3a-ac738c1c598mr84169366b.39.1743203421225;
        Fri, 28 Mar 2025 16:10:21 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71961f04dsm228915966b.91.2025.03.28.16.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 16:10:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/7] io_uring/net: open code io_sendmsg_copy_hdr()
Date: Fri, 28 Mar 2025 23:10:54 +0000
Message-ID: <565318ce585665e88053663eeee5178d2c15692f.1743202294.git.asml.silence@gmail.com>
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

io_sendmsg_setup() is trivial and io_sendmsg_copy_hdr() doesn't add
any good abstraction, open code one into another.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index a1d32555fe6a..fefe66c2f029 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -325,25 +325,6 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 	return 0;
 }
 
-static int io_sendmsg_copy_hdr(struct io_kiocb *req,
-			       struct io_async_msghdr *iomsg)
-{
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct user_msghdr msg;
-	int ret;
-
-	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_SOURCE, NULL);
-	if (unlikely(ret))
-		return ret;
-
-	if (!(req->flags & REQ_F_BUFFER_SELECT))
-		ret = io_net_import_vec(req, iomsg, msg.msg_iov, msg.msg_iovlen,
-					ITER_SOURCE);
-	/* save msg_control as sys_sendmsg() overwrites it */
-	sr->msg_control = iomsg->msg.msg_control_user;
-	return ret;
-}
-
 void io_sendmsg_recvmsg_cleanup(struct io_kiocb *req)
 {
 	struct io_async_msghdr *io = req->async_data;
@@ -392,10 +373,19 @@ static int io_sendmsg_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
+	struct user_msghdr msg;
+	int ret;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	ret = io_msg_copy_hdr(req, kmsg, &msg, ITER_SOURCE, NULL);
+	if (unlikely(ret))
+		return ret;
+	/* save msg_control as sys_sendmsg() overwrites it */
+	sr->msg_control = kmsg->msg.msg_control_user;
 
-	return io_sendmsg_copy_hdr(req, kmsg);
+	if (req->flags & REQ_F_BUFFER_SELECT)
+		return 0;
+	return io_net_import_vec(req, kmsg, msg.msg_iov, msg.msg_iovlen, ITER_SOURCE);
 }
 
 static int io_sendmsg_zc_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-- 
2.48.1


