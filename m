Return-Path: <io-uring+bounces-7573-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14DFEA94754
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 11:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF9DA188DB5B
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 09:30:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96958192D96;
	Sun, 20 Apr 2025 09:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mpWufVG2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B51155327
	for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 09:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745141421; cv=none; b=muYV8+eO3qvGRt+wuw7PSNu5o8MAHYw5qYcp4rEl52NaS6saJcaLvEELuP8/HxR/GhRFpYYMBg0VBQHq3dTUIIbxndFI7XKgZ5LEnldFPw4IsQkVEb3zNBy+63JpZkUbMi1ll7wSBQyFEnj88inuW3Gz8v+GeRsD3qJ21+M9EyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745141421; c=relaxed/simple;
	bh=JGEsP80NRkvoSFJvoC/KB+Jll3KrBjZ+Ha6T5T+WCIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3XfOBIzjFvaDvKiEQ7kVgSjHvaqpBJZekn+Qo21YgnWJa4M2AmrmVIvu6OlZEV3RBpgIQykrUnUxMHGmrQFFNK3fEetzKCdle+G5aYiKwsK80mTGxp9vX9+aGXZ8DfyPylqmcmVIXtKFOGRf06+UZapP82VCzB1/AJSghM0umc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mpWufVG2; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-39c0dfad22aso2074090f8f.2
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 02:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745141417; x=1745746217; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gjb97cg3nJTuOpUtchoWKelUalPRamTuJLvoNQC2fEY=;
        b=mpWufVG2yRNF+/AfSevFA5Q6nVZJltEeWwYe7DVNNxad565ypnqg/AmmxixCauS67F
         XlZyTI55FhOdzeQm9ZHfCgzUe/hhSQg8AEOJGdPi+dKgNpxpkGDqXhhmfw6iZOd6sxD8
         1Y72QPML3uwV/8ncECY6TLkadZMr5x5Kmx989LpFdIwdV3KfxiFNJjVJkkohRi37dth9
         UhU8/lrE644bIn9n6P7vYlPSbyZRjz3XIwRANFptIcs5THTAh23Doe5UABT7dwjcEJqh
         mVRuF631IVGEPwcCsMLfahc+IlvmHWJSe2YeXwG16xrhV0X8CbRkS0xH5RM+fIYt7fcO
         yZkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745141417; x=1745746217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gjb97cg3nJTuOpUtchoWKelUalPRamTuJLvoNQC2fEY=;
        b=Zhou+6S71HMNWRQB7xjKcuzjozVPPNj4/510PEUqRlpj18r24hpMvtbH2Ktoldrc9w
         NjnYiTH44tw3nofGWinuo5boEGP9In2v09305Ar6knM/4sEPVf3hrFs0hGpGPNHysppX
         8C6mC3VgmA79XlXsffe7hHH4+plhovpRboOODMt/qyJAp8Ql30tjbVFy7xxsC6KiCpAz
         DG8CWPCzL3JRi/gO8jGdE9C0hEf3priJfFjHfukdOK71r8onmrmAhMZk6eEjgU5gN16X
         LwY5VmfzUKAxSUpmrpJqyqp3iBiwpUqTrGyRVXvVF0omeX/qtA/HE7td0CCxCfDO4gG1
         fcKQ==
X-Gm-Message-State: AOJu0YxwIKiAg/6XcelW07CiTgbkAjwR7kl5Q6usrqRBh6lEIIlcpO9P
	yaBaMUzXQeELvxjLN61AEfbF4HxOXTUHpOEdkHDTr8YqKzFLQuoJjR7Iqw==
X-Gm-Gg: ASbGncvOZIc4og6ogbTRKDkZR7dP9JOwipI8JZqDT00DiiZneWJMGnKgUHPW5TwTn+X
	awOmTCVvfB1Qlev4MQ8cR4dVj7pedE8BLceQAXpa1iNicfceGRRN9JLbx/rCnxmh0qfQ+Tkq9+D
	0MWVwwjQQ2rL4/ObWZAxncrKOQgbLDrQ2WTFKFM9x+PYFxmFoOPhvGdLZVnKNiilk4Qpm0h1Kg9
	ck5boT++qxYWMer1uO/x8HLS9Vt3UeAwf3GcFS4GQmZ7FiN7XPrFdlT7XmLCZKQ/KWJ8YIsY5mw
	H8eOrx/zf7zp0J7w82BTglIjRm10YH8twhyzS90es4S148SrgnHqOP9+DMa99gpl
X-Google-Smtp-Source: AGHT+IFHc7TCmGKnQ9DssK1rLvfhzR3x5PIPS4tER9rRn5SIafvo79vlWg6fVRxDTZIleVBqK9ukUQ==
X-Received: by 2002:a5d:5c84:0:b0:397:8ef9:9963 with SMTP id ffacd0b85a97d-39efbb092e4mr6625027f8f.55.1745141416723;
        Sun, 20 Apr 2025 02:30:16 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5ccd43sm91188675e9.26.2025.04.20.02.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Apr 2025 02:30:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH v2 1/6] io_uring/zcrx: remove duplicated freelist init
Date: Sun, 20 Apr 2025 10:31:15 +0100
Message-ID: <71b07c4e00d1db65899d1ed8d603d961fe7d1c28.1745141261.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745141261.git.asml.silence@gmail.com>
References: <cover.1745141261.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several lines below we already initialise the freelist, don't do it
twice.

Reviewed-by: David Wei <dw@davidwei.uk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 5defbe8f95f9..659438f4cfcf 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -238,9 +238,6 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	if (!area->freelist)
 		goto err;
 
-	for (i = 0; i < nr_iovs; i++)
-		area->freelist[i] = i;
-
 	area->user_refs = kvmalloc_array(nr_iovs, sizeof(area->user_refs[0]),
 					GFP_KERNEL | __GFP_ZERO);
 	if (!area->user_refs)
-- 
2.48.1


