Return-Path: <io-uring+bounces-8758-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5BA1B0C0BE
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 11:55:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E22A43AF263
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 09:54:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D07828D82E;
	Mon, 21 Jul 2025 09:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m7xD6yEs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB3A20E71C
	for <io-uring@vger.kernel.org>; Mon, 21 Jul 2025 09:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753091701; cv=none; b=GItGdepXidftodOZ1JSS9lXChsctI82cgGUi8nbdUrivL2j8czNPi7wOfThCQsBCa7/+disxgpl45YnSUInhbqV5wuHw/+rVUJbCWPvNpNqHhSJxyMpUEeLsc8Dk1KqGxY8iIlbmmwwkwEZE/H2Z0M/QHES/Ki5fP2FKU9zN2VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753091701; c=relaxed/simple;
	bh=VPf9m64+3rRSk1GKQe6xvZl//SpZ2KhcGsdlEMPqL7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSTuUc8PT3BbEhRnzltuHetV8z9CZZmS5w2P+83pAuVoyJERgikRPPJ87VIDuJK9xVOPZmK7zz0B9zFz5AQ0FDh3W3CU6/WsIUPJ2rYum9mcjVU/LWFOMGBw7tUcTtaXvW95RUanhoPNqUa6QWNtu52R3SDbjFBD26UKr+2pXoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m7xD6yEs; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ae36dc91dc7so665160666b.2
        for <io-uring@vger.kernel.org>; Mon, 21 Jul 2025 02:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753091697; x=1753696497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XQ7C6S7JTwubHBGhR56yOAGtw+yYafWgjpbPFHELm7M=;
        b=m7xD6yEso6r7AB0pzbFCviY/8M5qd8+/Dgh1Xfa0PQV0GywWZyQ7elK27bekTaqHEy
         E5jWsBe8kUIQgyJlSdxp2LgAnOdLsH+aVVE1MIAuupvlKbUVuVuIg+IlbwltVFrivRZt
         vdMaf9BQkOJ3H6HxJYOhNMBc59C7MUV0T6FA50l9CqbfgSHIzEiPV4EBnrOqLQ5nzDIm
         +lSBCsBAkrI3y7Mmw+EIi9lM0krdWZ6iE7nqvcqD+2wnhNvmBYTOHw0i9DKYxbH+sxw4
         3ajh2w4B4eNhgjwTUyKoNudTKWfI0WAaBuwWQOiEOJWO2MYknH5/UguL1zM2t1oRnSTW
         dxzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753091697; x=1753696497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQ7C6S7JTwubHBGhR56yOAGtw+yYafWgjpbPFHELm7M=;
        b=m59kQQVEiOtYUKhJMWTBHMZO2dgEw8MDKo8YE9u57POAX4XKi2K6NEB0MVjZFWvTfI
         EZObBQz+EW5RBAqbrWMPt3J9YtDBWSEftyNn0NRxLc69k7GxCWkRq9Ibk3Axs6oAN31h
         CjeG7hiHKBtPQ7JXU1Qkh29Wo5Vq7fdzK3NUlqonQgv28Dl7G0eQUI6RFCJjXdqRXHu/
         hJ0PTavTj7Qc5Vdz0Xy1Iaz9zNfmUYbOP4a1UruSj6C22zPVvb2AwzXzEvqTGSqGAua/
         w2CJ/7JriDzvUc5ODxHzKXKJJ1i/1ZfFogd/B66xvAZ5U9HsDwA3k30W0PoReKOC8LVQ
         ixCQ==
X-Gm-Message-State: AOJu0YxNl1yIL/lNTR1u1HauUEmbm3b2lwvm2kk/FVOhBduviylesJTj
	HIj4ERchdpWCzf+DRXIfOX+0iJKJjTwZkbtrvg4hW737OjxVfdspYeCvobIgsA==
X-Gm-Gg: ASbGncsJ6IxIl4+iyhSvOtt/LrkF/J19EDu/uEDEkXIZfhWzhsQNSqrtXAn6vpeP0gx
	OZkj8WXBvre+HvQMwXZjUkDEqGdpjeFdGYxb2wbZl8GUdCHZjoCyIqsLa2kXMK+qbGrm1E8pvnK
	U3Tqvsn45aA7xU6UrdkRL37NuyKgJ6dHomMmfhPhctdUnukM27bycIoQ0zOaOnlz98yOyiGzpBk
	bqesWAIX3G4Qq3n6G5U2y82RLM1e9ZmHlpPo238y/+HTghfm1qM4Q9HUIXq43UwyPDFG3JIMp0F
	lNfeUXueC0WUJoxK/n4x/qbXo2kLtwERbY8Ks63NRQECAWfcKOMAiOzstzwptHNGVXRjON5ouOO
	GnSDL5Q==
X-Google-Smtp-Source: AGHT+IESgQj8qdv9f8sQ0fcyH4eOWe4DQHDoPtDDTV38DUcMEalIzmnyh5pncyUYZhwu4RzV+gELdA==
X-Received: by 2002:a17:907:9404:b0:ad8:a935:b8e8 with SMTP id a640c23a62f3a-ae9cddac0afmr1878769866b.5.1753091697259;
        Mon, 21 Jul 2025 02:54:57 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:23d3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6caf6c00sm647506466b.157.2025.07.21.02.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 02:54:56 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dw@davidwei.uk
Subject: [PATCH 2/3] io_uring/zcrx: don't leak pages on account failure
Date: Mon, 21 Jul 2025 10:56:21 +0100
Message-ID: <e19f283a912f200c0d427e376cb789fc3f3d69bc.1753091564.git.asml.silence@gmail.com>
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

Someone needs to release pinned pages in io_import_umem() if accounting
fails. Assign them to the area but return an error, the following
io_zcrx_free_area() will clean them up.

Fixes: 262ab205180d2 ("io_uring/zcrx: account area memory")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 6b4bdefb40c4..6a983f1ab592 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -199,15 +199,13 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 
 	mem->account_pages = io_count_account_pages(pages, nr_pages);
 	ret = io_account_mem(ifq->ctx, mem->account_pages);
-	if (ret < 0) {
+	if (ret < 0)
 		mem->account_pages = 0;
-		return ret;
-	}
 
 	mem->pages = pages;
 	mem->nr_folios = nr_pages;
 	mem->size = area_reg->len;
-	return 0;
+	return ret;
 }
 
 static void io_release_area_mem(struct io_zcrx_mem *mem)
-- 
2.49.0


