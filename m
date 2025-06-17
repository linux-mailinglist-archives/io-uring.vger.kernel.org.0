Return-Path: <io-uring+bounces-8402-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D4934ADDA3B
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 19:15:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A421319E215F
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 16:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEFAC2FA624;
	Tue, 17 Jun 2025 16:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmB9yKf/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A8DCA4B;
	Tue, 17 Jun 2025 16:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179412; cv=none; b=n4FVheJ7QjF4Ux3To6WDlnM9T1KPVwCgNTWg1Q7dtaJqC8IJ/uFCl7uonIkAVK1vgerkU93Il4YZOMaZB1RgZA9D0BDHET1Ilm9uaja9eIeZHtNs1pKo37Jq+CkTyItrtW9XZqUUlfNjsdi08JLBoGsPFJJFHRPc673JvAEsF9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179412; c=relaxed/simple;
	bh=1X9J575bsA/M3lhhiMZs+Qug6rCcZfs22ONcFB4KFO0=;
	h=From:To:Cc:Subject:Date:Message-Id; b=U2hKl7Rzw9zYd7figcrFZTHY47aZDpG6MK8B501Vv8Gy6TZjWoBYAAb6LuJ+2hYZpTeyfOuU03s2T9b9y1U3gjNlJ6ffLTI7RAqF79BFV+K7+Q56MN6/IdNbloShYlMdKACIdAejMxozOUDdA2DktcT4YNmDVFpyUOcBNKNuGG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jmB9yKf/; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7406c6dd2b1so6137351b3a.0;
        Tue, 17 Jun 2025 09:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750179410; x=1750784210; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rfqJXOOAhVmt+VS3Cb4LjHhD8OPCGhOR65y9ZK23DO4=;
        b=jmB9yKf/FMhLu2ch81Nn1Mx7rjT/8qiGw4CyWMaCi9VtYphAwxVyFery8KuRhr8bvZ
         ieY0Enb//0sW7pcXsArMewZNa7FFpIpwqs7QCGfhPzQpVn5CjwYi9jzvUXpYF7i8ki7X
         l98vBQBSKpZHBw6ajtc8lBPWbvFxdNFChpxcC+C54DsAQ11rkxLwWZ3QOl6fsgBuLn1V
         S1RLKwrozBJNiem3kKp9WQrvfOnuFYqtMYiZGz8O1S0BFAhz/wxtAtiugWuSdhsjp869
         uHSYj6rO2JJsuLGw9AVlLPnazjzpC1oyTxsV0iK2K068m7BDns5JuHzJo7uuY1VcUJAx
         mEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750179410; x=1750784210;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rfqJXOOAhVmt+VS3Cb4LjHhD8OPCGhOR65y9ZK23DO4=;
        b=NnldNHI4aALilEyVVowepLYWrjLkdE+loas22g6iLcaWvu9ne2L7hyh4ER9cFJLoqf
         D/QNVN4TEiYGUiYnDId1A4g9RqnfiZnBwweSqGw/EqEfE39chmJIuPjTVPlTgaStVaS9
         YHtps3SqWEo+ELyBN27MrptTt2MTabi5wp1ZVQQnbQqkoRF5jnfhci0TJyvU62dNP+Kh
         puC3aHLPCm3Vkbi+YoZyU3jIh7W6bXuvpfU4MzYOpF6HO0FzxIxIrKA4ViZJTfj7FiAR
         Cd9oB/t2zQo57VYA2MLADZIc7xY9tTLAL5ahM419xZ41YntOWsEoRbKsd627la0ctncF
         6kPQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6NS8fhrDbpn9i/NBsxVMbqnql8iA1pRyDCLaYK/u4hUA96wFh1Hmk3cv/6K4qSF+YeEOeant/SzoYQrA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0SxLeg4vXWjOTixiaZPAx/aP0YNVL+ln3AAk4+xMswxj4dy87
	okG+mz6HiOBSGse4ZPZHmatVnDQCBIGeDBIF4NaIpPrSSgAVLHQ9De9f
X-Gm-Gg: ASbGncseYv5PcW1PvWa3vIdy4dHJuAu0UN1P7QV2g97rryI3iQR1oMWqxbIfl0jbtd2
	gWplNgBAEYZkH4ITZLHT+Br1gBNOH+LIlyspo2vBt44isUPxb/HXLRgwi5zoSXmDZeoXO+JUqs7
	PoERIViLInTyaUfGoz/J+gvqIexJeyJEBwaaR5ryoFTj+NTCTRFcanNpQZnX8JrK4Cwowr16zFq
	TtnT6QB3U3w15tjXZlxXrTw4tRdYCSpfSmWLIzFU78pgSPwl6zn8Jw0PDmJYRMw/UHolJH8ktnI
	xs0SzagiCT37BH+Gua+0LMcYEeQ6lYTNHVibZ/RTlUKjDR0bgo570yLTwxRCTC4xdmFIvwu2qrW
	9aDaxnZQ=
X-Google-Smtp-Source: AGHT+IE8eATALDiBwavUwsItsSkvKaAK1mUDal+oxVTeRl2/VodG7+TH19xRgSh3ElbJAw5r+Trarw==
X-Received: by 2002:a05:6a00:21d6:b0:742:ae7e:7da1 with SMTP id d2e1a72fcca58-7489c2efd1bmr18296152b3a.0.1750179410514;
        Tue, 17 Jun 2025 09:56:50 -0700 (PDT)
Received: from ubuntu.localdomain ([39.86.156.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900d0d90sm9038598b3a.155.2025.06.17.09.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 09:56:50 -0700 (PDT)
From: Penglei Jiang <superman.xpt@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Penglei Jiang <superman.xpt@gmail.com>
Subject: [PATCH v2] io_uring: fix page leak in io_sqe_buffer_register()
Date: Tue, 17 Jun 2025 09:56:44 -0700
Message-Id: <20250617165644.79165-1-superman.xpt@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

Move unpin_user_pages() to unified error handling to fix the
page leak issue.

Fixes: d8c2237d0aa9 ("io_uring: add io_pin_pages() helper")
Signed-off-by: Penglei Jiang <superman.xpt@gmail.com>
---
V1 -> V2: Optimized the error handling

 io_uring/rsrc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index c592ceace97d..0cc21c1f7146 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -809,10 +809,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 
 	imu->nr_bvecs = nr_pages;
 	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
-	if (ret) {
-		unpin_user_pages(pages, nr_pages);
+	if (ret)
 		goto done;
-	}
 
 	size = iov->iov_len;
 	/* store original address for later verification */
@@ -842,6 +840,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	if (ret) {
 		if (imu)
 			io_free_imu(ctx, imu);
+		if (pages)
+			unpin_user_pages(pages, nr_pages);
 		io_cache_free(&ctx->node_cache, node);
 		node = ERR_PTR(ret);
 	}
-- 
2.17.1


