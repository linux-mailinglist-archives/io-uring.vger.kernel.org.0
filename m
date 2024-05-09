Return-Path: <io-uring+bounces-1847-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69A688C147D
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 20:07:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 079041F2120E
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 18:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7087D07D;
	Thu,  9 May 2024 18:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NtGb5EZV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E55F79945
	for <io-uring@vger.kernel.org>; Thu,  9 May 2024 18:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715277997; cv=none; b=VdRuk8X5vIl3uzTE1Kd2t/5Sil+LZmWrfFquMmQNwv1HTHzs3X4Nkj9ptmlmSVMTMYKJ9GT7po31dXMjVQ9/6mOMzfPXnuveUhjvrgqK5MJJRhhXYO5LXf6yKjCzOnij7atkldVmxZwaiMtd9P4yc9VhXx2wOUGi1SZBzgm1xAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715277997; c=relaxed/simple;
	bh=mI2DXhRy+LzwZaVX3tUqLGuGMOzxYes5GXyAfXEo5t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NeDuqydjaKzp0V3TN38R/Tq95wZMXBoawhpk/zTt+yFa7XVZpO2wEWfAueO8l4LwhvStzb6vMlnpFK+z54RD1w9ArhQg8+RrcZEXBO8byR/SPRFQ2RyDOQg5dxlpz+VdeIhisVDiHqwjY8zf5iTfqEs0Z9ekjMzebL+vUiqAnRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NtGb5EZV; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-36c0d2b0fdeso992555ab.1
        for <io-uring@vger.kernel.org>; Thu, 09 May 2024 11:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715277995; x=1715882795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=woNeZ/GAdNm5Q3tFonAdPP3oRXvlWSqAWe77jsuw0ho=;
        b=NtGb5EZVmL5fgie0+Auiq8h+XqPxweMdqlycDhlZeGqD/UHGbdvXxTdYS58pBpwTO9
         JaQDrcDj6cWHSWVoQi0/S06vdy+jrv4MOe4FnUeqrz4Uiqgur8R2ssMFLMFU5kpUzipr
         jxdgAMa2zll4t6VLAnrBRdkKembPGmD6CyD6feehvfOKEF3HU9WagNeGqntLteUR/o8g
         3A8MROaGbjS0+/PUPDdxCd5s9hE7ueaQlNz7azlwi/4etnf58Bvbdq4Fm6J/pTJVH5YA
         ZA/oUWcf/iz+3eGocxRRXpHhwQDCrN2UVcVbPrE9sb3pu6AHEZwIOeLD9C5qS+hCMsbC
         dcYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715277995; x=1715882795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=woNeZ/GAdNm5Q3tFonAdPP3oRXvlWSqAWe77jsuw0ho=;
        b=aWfDCNkcGnh19JTGdx4iBQmjzh8RkGlydwdQMZeXIjNbd0oYR7dAek3HbNKvyLpBft
         4dv2As7PJqjSLCKXox9yTz64WhjARjpIgk97FTsIx/yO3tPrjviPEOKMItPbMCCusbbZ
         PWyDpaK97QOjVS+uM9xoqUboqUfdtd22ImHysP/T1oxeCEZmdkz/dmKsbcLKFQl7fFel
         L2v3S7OPdzfMxEQlCD5gZn75oJMWNVYZ5yRYGSf6K9jJ6CxMIuG5aBHmX/nbPI2gXEiK
         vgtZ3CfZlMOPzTNbnF7dmqHvQhu+r3KnCdvSvaiXq2XNvBdh86L4VOMazanq61YAlnN/
         0VQw==
X-Gm-Message-State: AOJu0Yx0gGtOgPlJGFj6UuipBBc9Wy/7cSQWgfwmEdOkj26zwnGxGvqv
	7/ZrIWv1BV5cnNu67XqRgJWwKX49m++K6LQ1GsVaAwyxicpe1bYExWiOKJ95n03kaWx8aGDOaQN
	3
X-Google-Smtp-Source: AGHT+IGtEFIZoN+P/68u1ejqC1yJS/4MN5eomDTbwrNfqvBRAv/QgjRoJ+mL9ZoMCqL4cSpBBsGo1Q==
X-Received: by 2002:a5d:8c8e:0:b0:7de:f48e:36c3 with SMTP id ca18e2360f4ac-7e1b500fbb0mr59902339f.0.1715277994988;
        Thu, 09 May 2024 11:06:34 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7e1b23ab4f6sm19468739f.50.2024.05.09.11.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 11:06:34 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: kuba@kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Norman Maurer <norman_maurer@apple.com>
Subject: [PATCH 4/4] io_uring/net: wire up IORING_CQE_F_SOCK_NONEMPTY for accept
Date: Thu,  9 May 2024 12:00:29 -0600
Message-ID: <20240509180627.204155-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240509180627.204155-1-axboe@kernel.dk>
References: <20240509180627.204155-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the given protocol supports passing back whether or not we had more
pending accept post this one, pass back this information to userspace.
This is done by setting IORING_CQE_F_SOCK_NONEMPTY in the CQE flags,
just like we do for recv/recvmsg if there's more data available post
a receive operation.

We can also use this information to be smarter about multishot retry,
as we don't need to do a pointless retry if we know for a fact that
there aren't any more connections to accept.

Suggested-by: Norman Maurer <norman_maurer@apple.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index d4d1fc93635c..0a48596429d9 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1533,6 +1533,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		.flags = force_nonblock ? O_NONBLOCK : 0,
 	};
 	struct file *file;
+	unsigned cflags;
 	int ret, fd;
 
 	if (!(req->flags & REQ_F_POLLED) &&
@@ -1545,6 +1546,8 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		if (unlikely(fd < 0))
 			return fd;
 	}
+	arg.err = 0;
+	arg.is_empty = -1;
 	file = do_accept(req->file, &arg, accept->addr, accept->addr_len,
 			 accept->flags);
 	if (IS_ERR(file)) {
@@ -1573,17 +1576,26 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 						accept->file_slot);
 	}
 
+	cflags = 0;
+	if (!arg.is_empty)
+		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
+
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
-		io_req_set_res(req, ret, 0);
+		io_req_set_res(req, ret, cflags);
 		return IOU_OK;
 	}
 
 	if (ret < 0)
 		return ret;
-	if (io_req_post_cqe(req, ret, IORING_CQE_F_MORE))
-		goto retry;
+	if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE)) {
+		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || arg.is_empty == -1)
+			goto retry;
+		if (issue_flags & IO_URING_F_MULTISHOT)
+			return IOU_ISSUE_SKIP_COMPLETE;
+		return -EAGAIN;
+	}
 
-	io_req_set_res(req, ret, 0);
+	io_req_set_res(req, ret, cflags);
 	return IOU_STOP_MULTISHOT;
 }
 
-- 
2.43.0


