Return-Path: <io-uring+bounces-8757-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AAB6B0C0BC
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 11:55:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87DCD189C808
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 09:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A779628C86C;
	Mon, 21 Jul 2025 09:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IvjGIL9I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B2628D82E
	for <io-uring@vger.kernel.org>; Mon, 21 Jul 2025 09:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753091700; cv=none; b=FONZD1wN/ILeD582Mztt6QdAinRgobGFPxmYj8DxPFzlGicFizJnQfYL+EQ3rkxpKMcX+2TccIticRg/VbGcj2nGLm91zD6NGKZMeUIJj8nUGRIz0rxgu47fMxSvAK7TUJYxXxdtxXr2Gilk2SqEZzSkWEB41G+XrzcIgiI/D1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753091700; c=relaxed/simple;
	bh=/GFGJLAYGNpIAY2O9LhFgVyTtaBi8AHDGanne0ZYSzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZ4Q4anTG7E617ohXAv/0Yy+qx5s1nRlQyz499dscWEENCWjL4NinmZh7X33XAn9mtIr8yQwfxxgUOTe3Kk0MlOCbYkR5nhnn4BYZ6pOFonlib14hc9kT2svBapag3NTatwsN99DRcs609cvowLRrWKYK81wxB0YnGChr6z2vfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IvjGIL9I; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ae0bc7aa21bso809650666b.2
        for <io-uring@vger.kernel.org>; Mon, 21 Jul 2025 02:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753091696; x=1753696496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bexgHqC7PMsWLqNa2ZPzu6nc1ssqYoENkGWctAv/rB4=;
        b=IvjGIL9Iz3AtkI1fkUzLffvz5pWzhAwcAagPqDQB2MVa0AXgaA2Xro6eCcFHE4ujrp
         2xk8xPvHImwP2CVgI0QyZba5/A8Nqz8fm8yXR83QEoClJl++J7xNC0KxEk/7Kf5ryt3R
         w2Umq9XvIeFSg93vmc1jFno7tFLtv/qKA+Zw85mPos0C2ei44KG9MITn3X64UdDdC/PR
         uBL+V/CveTUKpQXPmfF08WjyHp0egvFGyvbjG4v2kfHhKJb8szWKdGOQx/mHNJcad5Cn
         6oRDTT55fXHLu71/Cm2h+WfjWJs90YArr/GrKbUekzVwuTLsxUNY4Bi/OHB6eEmzqga5
         xMXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753091696; x=1753696496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bexgHqC7PMsWLqNa2ZPzu6nc1ssqYoENkGWctAv/rB4=;
        b=GrJ76eDMkGqfA1guF+hVfQRvRQWMGOq4hq85Z1sIGev6nqHTHq3fTvjbKGAsVY7JDM
         OIvLz/q0MNZNjyjtOORI+uETIbYQFUi7JwvM5I5wK99Z78TOfMcv2LtowuOAdJWmm+Oo
         /WCuqDoI785A+8xyCZUB1q9cbqysquOWOwet2+Bts6IWfg9FdsJsBqJ5spU0HYhSEM5v
         qo+zt/JELXoDti5bjdVpaJoPdm1sd8+wvfYsAuhI1AE3ToZEfR8qEtvBGn2ifwg/szWA
         htnA/+Tgd0WV7At5f3y4ytl5zt3r31FxegWnfcJg8CFijDSEy1KnrZ95crBFwJygUscz
         iqhg==
X-Gm-Message-State: AOJu0YzQ1urVdMbovLYzsixOjkW5CzU8et0pwYiNPLDzFgEJZiKb4uh6
	teN8E9y1Ig350/MAqC3hky9NRtpkY0iRwoGEi1h9jbafKfwriQcgxUZv2xMVVA==
X-Gm-Gg: ASbGnctb3hawd5Uo+vuWbRQGFZ7nLdajw38zOa+kGhg0vdSth7J6+JOgKSfBD/f37tz
	MMKO5ZyhE4NpYs7Z8ML+vwK4QPSvHct7EPRxdnQ9maddWg39EfhztKtoh8NxIccnxMyKnJfkM/V
	fcSpSGMelH0Hf3Lt6TsQjd+nxN08t6CZyYxdRPQ/2gFopv7XOT3kFOUm5dK9FXdicgFtcDy2jme
	7t6F39RIAgLK1/U+1+9NS8j4RHdoEAHQn41z3RBriEPeka/wEI2yEuK6GnNObGU7CuLa7PTLgcf
	x+UjndBY3Sd4dcndvDXEsak34O50i5yyC0M6IA2u95KmSBylIzDVldu5z2v1CGiFFSAjsMAchd9
	5bMfS+2L7Rlq1CDl6
X-Google-Smtp-Source: AGHT+IHtCbR5wafsE2/Lq5+8BzmgJfpUJm4pIIyBZTvGnhH2dEKpqCe1cAu4twjsjDNupKrgfLVsnw==
X-Received: by 2002:a17:906:9fc9:b0:ae3:5e2d:a8bf with SMTP id a640c23a62f3a-ae9cddd7bb8mr1967464366b.14.1753091696201;
        Mon, 21 Jul 2025 02:54:56 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:23d3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6caf6c00sm647506466b.157.2025.07.21.02.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 02:54:55 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dw@davidwei.uk
Subject: [PATCH 1/3] io_uring/zcrx: fix null ifq on area destruction
Date: Mon, 21 Jul 2025 10:56:20 +0100
Message-ID: <20670d163bb90dba2a81a4150f1125603cefb101.1753091564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1753091564.git.asml.silence@gmail.com>
References: <cover.1753091564.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Dan reports that ifq can be null when infering arguments for
io_unaccount_mem() from io_zcrx_free_area(). Fix it by always setting a
correct ifq.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202507180628.gBxrOgqr-lkp@intel.com/
Fixes: 262ab205180d2 ("io_uring/zcrx: account area memory")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index dabce3ee0e8b..6b4bdefb40c4 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -377,8 +377,7 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 
 static void io_zcrx_free_area(struct io_zcrx_area *area)
 {
-	if (area->ifq)
-		io_zcrx_unmap_area(area->ifq, area);
+	io_zcrx_unmap_area(area->ifq, area);
 	io_release_area_mem(&area->mem);
 
 	if (area->mem.account_pages)
@@ -411,6 +410,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (!area)
 		goto err;
+	area->ifq = ifq;
 
 	ret = io_import_area(ifq, &area->mem, area_reg);
 	if (ret)
@@ -445,7 +445,6 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	}
 
 	area->free_count = nr_iovs;
-	area->ifq = ifq;
 	/* we're only supporting one area per ifq for now */
 	area->area_id = 0;
 	area_reg->rq_area_token = (u64)area->area_id << IORING_ZCRX_AREA_SHIFT;
-- 
2.49.0


