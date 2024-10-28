Return-Path: <io-uring+bounces-4071-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 68BCF9B344F
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 16:04:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14D571F22534
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 15:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F05921DD864;
	Mon, 28 Oct 2024 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qAfKAvfo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52EE1DE2C6
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730127889; cv=none; b=FkW6UAMsDu89iV4keUirYV9ohmwO1YWA+bFECgL6NE+mjKkQq3PYe1TC5F0tkn74Bz6wXN7xeslqYv2MzSaRYrrVHsZkUHW+XBPD4a2t04VevUFF3KUeqKqoAL+iH9o9IPzzDt1HSXjPelLD4mBUQs4+ybbD5c+XWgxU+CAOfSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730127889; c=relaxed/simple;
	bh=SYpQSxC5Dp9fLpjQdEWdmbvundwGSG12kF2zAC1HBac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RP9frZS8r6xiqH6gEiLlZnaBqji57LKHbC01ZINJohXlOGLCzZiPU90q60Xf9M3XHwCNw4TxcUdRWcmknul16DxY3TkoNm8PjjnILc0w+FV1ArF1IqwrgOrhbvoz5IzGYbZI3rDcgDon2z/8uUdazEEQCd6/3yDEIdmmdCQWcos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qAfKAvfo; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-83ace760016so157744439f.1
        for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 08:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730127886; x=1730732686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yp+EnMS7ATl15usRfPUg+8nUDFsAhh02UXOXNhYJd0A=;
        b=qAfKAvfo8FtbVrktofBt13AMrXqVAMKSaCam3EhPfKhXLUSGlZVjwmhPwfJAqAfo91
         JcWq2n9/sfxL8/wbotN2Y22b15GOCRtu7kQSfUI24NhFCMlLvA1WkZ8ecppx35y2NlNa
         zYo5+3LkTPj9zhRh+/wfKfvivML3GS1ymj+NOVjxJNIapcA44wYHbhZL0FMGV5PshHId
         pis6CKaPwbbz4wsfTTbC6xwB1KM09QandpERGisEgcesFvj/QejtyUDtv43h8WxwEj+h
         Y2At8cVGbT5Rye7HBY8FnoO65GBlHmFYyEeZPdkad9//MDoQSZ3LE+HxLNdQvKgyUPy0
         Hm7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730127886; x=1730732686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yp+EnMS7ATl15usRfPUg+8nUDFsAhh02UXOXNhYJd0A=;
        b=IN28OFljrU1Pc3WI95O1GRl6dSDaNkkIl/5/csn3zvn1EhfNErr6XcrXPOGv10hxw2
         jh0FrVHMK6SsxaR5FMpherZbf1AcQOL5cAQgxIxnOCha2Pujrt29oFGM1DY9VyubtaPG
         j7myCef5+80TZwBxEzwaRbcdw05twxHH5v8bVx8rrfgiEjQWccWhToGes95LVS7k/koc
         9Dh9YI8OYu8QqE76BHgWz2U/D9oTpUQMl7XZ5SUwGMT7E7/iLH3xTC3noR0bgOYpU2Lo
         Dee8aT6scxicjNrIL+1jap9hle8xTBQYrM+rjEnsvFtZTnbHrAnVkv2FzuHVm76elUKF
         Gt3w==
X-Gm-Message-State: AOJu0Ywh5/kFb4bGg8o0bP+/KnmGeNtYI7Lk/QnInOAD4lhuW19X0muT
	IkhYbXjAHWQwfv+xQ38cyBPvn+DKo498rQR7o8CmmvPKR+GK/bPT6yunkqjQpBUudNxZqNxOGP4
	s
X-Google-Smtp-Source: AGHT+IFPCVJRr0o8bfaLXcln47vxsWTNjV+fyNh4dc9tz72yFUVwk9sRjZssZ6go0BfeofQuCk45IQ==
X-Received: by 2002:a05:6e02:198f:b0:39d:3c87:1435 with SMTP id e9e14a558f8ab-3a50896d7cemr1204655ab.1.1730127886634;
        Mon, 28 Oct 2024 08:04:46 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc7261c7e3sm1721616173.72.2024.10.28.08.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 08:04:45 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/13] io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU io_kiocb cache
Date: Mon, 28 Oct 2024 08:52:33 -0600
Message-ID: <20241028150437.387667-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241028150437.387667-1-axboe@kernel.dk>
References: <20241028150437.387667-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Doesn't matter right now as there's still some bytes left for it, but
let's prepare for the io_kiocb potentially growing and add a specific
freeptr offset for it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2863b957e373..a09c67b38c1b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3846,6 +3846,8 @@ static int __init io_uring_init(void)
 	struct kmem_cache_args kmem_args = {
 		.useroffset = offsetof(struct io_kiocb, cmd.data),
 		.usersize = sizeof_field(struct io_kiocb, cmd.data),
+		.freeptr_offset = offsetof(struct io_kiocb, work),
+		.use_freeptr_offset = true,
 	};
 
 #define __BUILD_BUG_VERIFY_OFFSET_SIZE(stype, eoffset, esize, ename) do { \
-- 
2.45.2


