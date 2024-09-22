Return-Path: <io-uring+bounces-3260-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E988E97E0F4
	for <lists+io-uring@lfdr.de>; Sun, 22 Sep 2024 12:42:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 766B7B20C40
	for <lists+io-uring@lfdr.de>; Sun, 22 Sep 2024 10:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FBF2175D2E;
	Sun, 22 Sep 2024 10:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gVWV/nac"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88C81EB46;
	Sun, 22 Sep 2024 10:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727001719; cv=none; b=Wto7SaphK2f0omOFDDBFtA4zqFSoiQ8Yycu9Dm26LUKgz+6JdAn3gZ93yZ7Kpn4XkcVfwRJhXkKERNy7yAyKyUCnx6HX+XGube1hLJa51idquSMxpfO3EkBHh+aLgLNcr1oRt6t+7fPfmEwJw2sdMP9kEjs0KSyXlMu/+pF8SEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727001719; c=relaxed/simple;
	bh=wjx6+xVn5mdg5sTT0DYT0o/Aex7vYb10Yy0thhjDOek=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oSwqzlybgX2YqlcI3zMesqcz2RIagzI520F549uXTV6WNsP8a7XM4y7Og5F6jHKfu6iL37PGGD09GY0dhqz9VjlS6BHJL/J7qiUMjqMDqONA8ll/q4BmllmZqCxbQekFjYMJO5AiIYL9Pq8dfaxBnEb4OrIRgyrWDR65yJGnFNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gVWV/nac; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2054e22ce3fso33613875ad.2;
        Sun, 22 Sep 2024 03:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727001717; x=1727606517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Tukwu3tNqGNdoVafScVP4RRpfclWlu/vI0rId3io5rU=;
        b=gVWV/nacgIhagAhScNDIFzJpTfDYnjPcTvp/D45kqo8HAGAf3aHNqPv0E+fMhHcVgb
         QMnljJUu2OV1bU6yHL6XEcrEp0viWNOPqBIGYeKBQ4xowuXVZfc5AdNKigm3PZGQm5PX
         xBgm5JFIHSW6Hn96bj6BMz6aYB3yRhEaAVbVnYtFPjAbtGsPtBYGs3ti6DOJoR5Elaxg
         +ZuEz4a/pZ2L2YaXrx/onHlnEIgA/W5D46y7EmvCpA2tf3Oa+aQGwlLDH3FQwLW8Nvq3
         NvLPdD8VfEoxbGrRWbU1EZt5yBG3zKgxyOlJHR1CTTxxmR261DmSYgYRFP6kBKkSasxw
         N4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727001717; x=1727606517;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tukwu3tNqGNdoVafScVP4RRpfclWlu/vI0rId3io5rU=;
        b=kitxbKtuWTQzKbej02a93V9ira3XHBbgfygsKM4VvAVHyy3cm8BGNmhEwKOx+0d7nr
         f2dPj9YTMgifB+4ba6k2sYCeytKiEElQVgHHGRLsMEP5y1kD5XwnMKPV2PU2LJbyjRJE
         3BAW3PkjnEvj0YGsJu1lnDUyA2qDYtKzDqGBBwZL3IZihNHtJvMeOv1cYv9HWVhlSjFZ
         Q2S8VaE6xjVd+rG8WZ9TgUiFGVWLMuVj76SZPGTiwrXpGB+Lz8OlaR/DqcrNcNHvRlCO
         hkuB5r4HB+2gEn54F9645mGDlRWEpdKwm6IyyAac2I52o42FBSE8IYG18eR0Ox3ZsO2I
         eL7w==
X-Forwarded-Encrypted: i=1; AJvYcCUJOJIFeeyaEOiEd69CeEPlwPD6c+bNqWWTpFRP3My/Oi5TAO44yAddet7MQgMC0AB5Mw6+WVDKqY/bEv97@vger.kernel.org, AJvYcCV6SlaVMPtwQdZ36+LxJMcHbYLP3Aa98P3y/usK7ls799wZjk62D0mzqjIevj7Wa2nwxkGImqtleQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxavmLdt5CfIF3sMjoDFCXs9euvs1GvYSL5pbb9MyEE+fyGfwXO
	N0vPPZmKlO9+vU1dDKSreatipbTaM6CdtyLoYZ/hp2wxZFfVphgO
X-Google-Smtp-Source: AGHT+IEbIxcVwXEeZlIV1uMfpqdevkA9Mu2nhSfdssgTyN9BpJB0sSuBrii81CEmkdI+0o9cZdk/qA==
X-Received: by 2002:a17:903:1cb:b0:206:96ad:e824 with SMTP id d9443c01a7336-208d83f003fmr120874735ad.45.1727001717028;
        Sun, 22 Sep 2024 03:41:57 -0700 (PDT)
Received: from localhost.localdomain (111-240-85-119.dynamic-ip.hinet.net. [111.240.85.119])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207945da57bsm118732465ad.43.2024.09.22.03.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2024 03:41:56 -0700 (PDT)
From: Min-Hua Chen <minhuadotchen@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Min-Hua Chen <minhuadotchen@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: fix casts to io_req_flags_t
Date: Sun, 22 Sep 2024 18:41:29 +0800
Message-ID: <20240922104132.157055-1-minhuadotchen@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Apply __force cast to restricted io_req_flags_t type to fix
the following sparse warning:

io_uring/io_uring.c:2026:23: sparse: warning: cast to restricted io_req_flags_t

No functional changes intended.

Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f3570e81ecb4..de79fa259d56 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2023,7 +2023,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->opcode = opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	sqe_flags = READ_ONCE(sqe->flags);
-	req->flags = (io_req_flags_t) sqe_flags;
+	req->flags = (__force io_req_flags_t) sqe_flags;
 	req->cqe.user_data = READ_ONCE(sqe->user_data);
 	req->file = NULL;
 	req->rsrc_node = NULL;
-- 
2.43.0


