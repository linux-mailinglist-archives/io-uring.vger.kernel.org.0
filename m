Return-Path: <io-uring+bounces-3909-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BDA399AB115
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 16:42:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3BBB0B22255
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 14:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A5221A0B16;
	Tue, 22 Oct 2024 14:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gV/wlwMC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975E219F49C
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 14:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608163; cv=none; b=Lw8xxQphnsvDS5c3o1BCP/G/vKrpTbOLOuSm4yTjn43qpGNhlvIRu6dwSXo8BB4BiSy47v+dF6lV5NUxFUNpWsYq0EfhAi2L4siTtuOG8m1IpGyi8ko55OsugRhSPnyCwPzNz4vpGayUMc56GnN0pveQ86tSCr3E/gsZ4TssJ1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608163; c=relaxed/simple;
	bh=zo67mh1Ly5UEzDhVcNMP+SHJydfD6O6ctYKMF36dCQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izL+CG4zee3zMbP11bEZJor4zIrpnC11aZc8yIP+sF9pYRdNvPpr94jJj1G7Lskel9GFGFPDUlOtrf07/R1O8QEKoyvaItWzlGQ9UgEdqAtbfNEeuLldJC3GPQDJ6ZFA/t8VEkG/LZ/J7ltHtlyxqbbg7AynytS74J9/+nrXMxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gV/wlwMC; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539f6e1f756so6718266e87.0
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 07:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729608159; x=1730212959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FzZHrLjrLlvB9EEo5Dak1GHSP1+/EWxQ9nQuugpqVf0=;
        b=gV/wlwMC95lR1x1JTE54PenbHJbyXXQ/blzBRc6wE+Gyl8mjos+QMiRICYFESFxjb7
         3eQaKNQyZfSG3F5OT2v5l+dEI+pFRpuY1P4W/xoMWYo/rL14RWd0El+iSelREdOKYyq9
         7m89mJRkB1eEyZ4HJP0xynccIRUi6Yj0xO13u4i56KRjo0PT0oJQHuIylIPxU9rRUUVn
         tz++QoojOIdRH+Urfxy2JI2jLx/vE7P/ypxN7e/53S24q0V6V3FYonyJ+bFiNYP857rd
         wwTqRAbX6VCbuMYcDKc/em+O799TnWpvhpb01z3XXW8vflJ4UcPynIs15SdNBftbUsAg
         9VWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729608159; x=1730212959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FzZHrLjrLlvB9EEo5Dak1GHSP1+/EWxQ9nQuugpqVf0=;
        b=AcNmDKLjM7t1+xEWDs0LswCtXYhu8L8auaZkA0Tjls3440QtzbQu6XZIUdLjQpbhZ1
         41EWXGeil2rlXUyL9NSamP3zrfThBe0HJfLQNei0Aa5INO+eLF90yOLTluYm7RJCnS6O
         V8BFZj0C9KWAjaugnzy1cyDoU5EsGctjcCVqBxv1tMGIPGc5LKO3lJy3qAz1IWqgOAPP
         h4YUkSEWews0VTXUpAYNm6VrhU+rn+msu1JfIRstFh4MN7eWFwthnvctv+fjHXinzNj4
         C9ZjEmI6sTawEqzIPxlkhnZKwYV6l8yEeCsvjkGjbOsZWU3mCBDS6B+5OrwA04JD1+DS
         o8+w==
X-Gm-Message-State: AOJu0Yyk4uT9lH6HDiZ2c98XmTaBRUkP7GeWVis4kFIlT3dgCyoWViXg
	A+tHI5n8jD8kIzg9YEoH66tSkWZJcNkDbkYpTK3GJHl1ovWV1/SaRADRFw==
X-Google-Smtp-Source: AGHT+IGvfavFHKpFawj3zMe/2+N1uJHK4LuyzEBFO+BTWGKck6DNboONspGJLDEgLqcbt5WbkrOwmg==
X-Received: by 2002:a05:6512:1304:b0:539:fa43:fc36 with SMTP id 2adb3069b0e04-53a1520b1d2mr8144089e87.12.1729608159120;
        Tue, 22 Oct 2024 07:42:39 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.112])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb6696b631sm3244434a12.9.2024.10.22.07.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 07:42:38 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 1/4] io_uring/net: split send and sendmsg prep helpers
Date: Tue, 22 Oct 2024 15:43:12 +0100
Message-ID: <1a2319471ba040e053b7f1d22f4af510d1118eca.1729607201.git.asml.silence@gmail.com>
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

A preparation patch splitting io_sendmsg_prep_setup into two separate
helpers for send and sendmsg variants.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 18507658a921..cfe467f9e19f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -384,16 +384,11 @@ static int io_send_setup(struct io_kiocb *req)
 	return 0;
 }
 
-static int io_sendmsg_prep_setup(struct io_kiocb *req, int is_msg)
+static int io_sendmsg_setup(struct io_kiocb *req)
 {
-	struct io_async_msghdr *kmsg;
+	struct io_async_msghdr *kmsg = req->async_data;
 	int ret;
 
-	kmsg = io_msg_alloc_async(req);
-	if (unlikely(!kmsg))
-		return -ENOMEM;
-	if (!is_msg)
-		return io_send_setup(req);
 	ret = io_sendmsg_copy_hdr(req, kmsg);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
@@ -439,7 +434,11 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
-	return io_sendmsg_prep_setup(req, req->opcode == IORING_OP_SENDMSG);
+	if (unlikely(!io_msg_alloc_async(req)))
+		return -ENOMEM;
+	if (req->opcode != IORING_OP_SENDMSG)
+		return io_send_setup(req);
+	return io_sendmsg_setup(req);
 }
 
 static void io_req_msg_cleanup(struct io_kiocb *req,
@@ -1286,7 +1285,11 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		zc->msg_flags |= MSG_CMSG_COMPAT;
 #endif
-	return io_sendmsg_prep_setup(req, req->opcode == IORING_OP_SENDMSG_ZC);
+	if (unlikely(!io_msg_alloc_async(req)))
+		return -ENOMEM;
+	if (req->opcode != IORING_OP_SENDMSG_ZC)
+		return io_send_setup(req);
+	return io_sendmsg_setup(req);
 }
 
 static int io_sg_from_iter_iovec(struct sk_buff *skb,
-- 
2.46.0


