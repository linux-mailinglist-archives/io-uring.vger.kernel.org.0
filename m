Return-Path: <io-uring+bounces-4400-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E1249BB41D
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 13:02:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FC621C20E68
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 12:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A02F7C0BE;
	Mon,  4 Nov 2024 12:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Em4wj8Gn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFA91AF0B3
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 12:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730721774; cv=none; b=DYqIhifnKrUhcyAReIVAGUUACkVmiti0b99f96t03+UyhgQT1AkCwXRR2DxC4bxqtYz8LxgORJrr7J2oMCxt+AmEBRteEsnPUj9BIhzfnTbL/qWjDwAPjIlbcWSCmI2iK4lGcMqx5qAjjkacOIK7MfdufA4ZpTUrQLd1jNFywAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730721774; c=relaxed/simple;
	bh=Z5chtCEy/K52Xx78sfWDQ1oAcDatwVCW3dywb3WbDGI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LJSI0lRxZ1K+5fDnfKZyu/ioiKtMosXZS464V5X5r8KKvFUU0L1T/kLgw4fjsmqwhD39G1WqSiVS9+Y89PbbBMCAN8Yf/+M6SWsB/2XfJA4CFAtazLxFbUGJxfq2OHayusK6+TvHJV0pjlVYUvFjokXUujvZ3by+zdQ5zExX9QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Em4wj8Gn; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9a68480164so652131066b.3
        for <io-uring@vger.kernel.org>; Mon, 04 Nov 2024 04:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730721771; x=1731326571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xugJ/9yOS7+V1YDXDPiEE2wNQ+MkObOppIYl3Zt9jNw=;
        b=Em4wj8GnYz3XSzJVrzEtIAkr3BrjEQ2zV4ll5ojGp3QGmIsUpblggfgbH+ssuKlld8
         FUjafbrQVd8EbGhot0kPS7vupVB2bOZfIgYuDROZGuAovaJgqalhM0PfOi5dj3+vE7Tx
         C6f+L4ac8/bBcyAhxT4pmqJvjiKyEkoEoMnDkzgjqHnRFkY1Y7zqKW1NNTC7PD5WrMek
         ZGxmXfUp6kNWx3oMbpqWaC6QXxHnz1MTEu7paMR+dVSK4LEWS2rc1F3kIMXXzzsofi8x
         /WbCqHiwALgSGhOqZemhIZcAGoFkLc8v9FpjoLzGYfMT/UcIXVLluQObcmK7enGt2vLs
         QB5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730721771; x=1731326571;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xugJ/9yOS7+V1YDXDPiEE2wNQ+MkObOppIYl3Zt9jNw=;
        b=kxoN4iU013g2sxcuchpiWLiaognJir6koQP2+lz7XyPMT9E9U/kGwheuUTjOKLFjcr
         TbQgce4qtzPEz7rGuW2+apwKArKWCZULYXqmCmZ+NLbHT3NIqE97+pWTjGVPBhHz3osB
         zZbIyZN86h9Hv8yEUh1SG714p6CFDuxFmgkk9WYeYMgiCc14GlzOWVGU4y0CEqo80L9X
         iLGbOUxxMWD40/lcBC5SoKfADRxXF8lYHpe5e8PHIOoefRoAFFXRZYnFiRM55va64fIR
         i/mGYiuKtKOhkf3SCFazuE7D/AS325ooLuV8ty2C8We/9akV9imARytcWtMtb0WRwZ/K
         RJfw==
X-Gm-Message-State: AOJu0YxNQ00epmys6e4Qr44u3cwSdFGtYeQ5o+gd4o1/gsdXrRdliyDs
	p2zZNcZogJaz+wMWOQoOnB4C6yc3+mfU+b20UdAYuwNYjz3rD366V9I76Q==
X-Google-Smtp-Source: AGHT+IHi9ikW/hsW1rEjZj6Ecg25hMOo39KP3V342Ys3Y2pm0gu67RGKCVPpKqVszGqVTUlX5B/tsA==
X-Received: by 2002:a17:907:1c22:b0:a99:f1aa:a71f with SMTP id a640c23a62f3a-a9de5c90d49mr3274960566b.11.1730721770792;
        Mon, 04 Nov 2024 04:02:50 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e565e5516sm544382666b.107.2024.11.04.04.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 04:02:50 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH] io_uring: prevent speculating sq_array indexing
Date: Mon,  4 Nov 2024 12:02:47 +0000
Message-ID: <c6c7a25962924a55869e317e4fdb682dfdc6b279.1730687889.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SQ index array consists of user provided indexes, which io_uring
then uses to index the SQ, and so it's susceptible to speculation. For
all other queues io_uring tracks heads and tails in kernel, and they
shouldn't need any special care.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f34fa1ead2cf..406825d000eb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2544,6 +2544,7 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 				   READ_ONCE(ctx->rings->sq_dropped) + 1);
 			return false;
 		}
+		head = array_index_nospec(head, ctx->sq_entries);
 	}
 
 	/*
-- 
2.46.0


