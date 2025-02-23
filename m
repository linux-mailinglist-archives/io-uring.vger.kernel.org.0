Return-Path: <io-uring+bounces-6641-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B67C1A41060
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 18:21:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10A843B8019
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 17:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73DBE82890;
	Sun, 23 Feb 2025 17:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VdfxX+Zu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92E3CA4B
	for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 17:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740331308; cv=none; b=I/4dikOoVKvhBQVCUqo9jIWgH+r5ZEAXhiJ0lf8Zpk/y0n66pTyk1rWcUoHXqmoQVvZ3Zg+whfEVC9vfHq+DftoAP3K/ZiCDzmi2AOqRvAlpQj7aNUgcjnrti5Tp3qFQDSl8zCv0Dz05qnl4MozDO7zCUqr9gq2FT6u/9NrPV9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740331308; c=relaxed/simple;
	bh=C+zEs6nVdyhTtF2XN0jArsqKWLnJ+vrSrTevSH/0Tsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0f4FCnOSjExlYPF0xwyktAbbOTXaTnI8cbNqhz8ANjvuSxHL6hAuPl2gbS9t2g/Jr77RthtIAFJxpUeizBQiTeVHMWUm62PqOdAx7tiomJsuUw85z3Ga5Cil9tu8lDwuGxdYpy5/QTaSFVYiQtOLANL7YEAbPe3JpaIN6nMndk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VdfxX+Zu; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-38f5fc33602so1981968f8f.0
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 09:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740331304; x=1740936104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lDXQBSAm0udiXjcaiwUj+OYuOs1KauBHUR0fNdOsnFg=;
        b=VdfxX+ZuOobilbs/TeOeVT8jqngBLaq6XyS9FSG3Q8OeRkAg4J/Y7FxpDY41L4N76e
         8dMRXteMJRQyBYHj8A4MAYFC77mN0dZBEm2naTIjNUnZXAfjFO7pt7/w3x+9OCjVIkhq
         Fr0YhMp9FLuhr/5ukMYxoahkXMWrUkWhR478UZeklgXSsb/AtFrMGDf+3QFxrSjZs0+H
         5gHB8kBXvgJYAmdw7PbkCM2KkHo7cZPj7AvyiNwEvBN85wkgswaopZ/utMAnNNYTdPto
         8nGsM0MwDYAYXY5MSjupOhaoY2puGCoUk+ccwr6DjuMkzD5JIhSeV33N7G7B1RCo+XbP
         6TXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740331304; x=1740936104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lDXQBSAm0udiXjcaiwUj+OYuOs1KauBHUR0fNdOsnFg=;
        b=mnvVZcjmpPtCQhBFXgmXhFCW463oF0QIbmqVNPy7rW8JmlwD/dEEJp6LpF+ypJXoGh
         aMBBfbl8H0H1mLfA/8edz1Petfe2tw0hIbk56eelaxOKxAh5s1zCfOqe7cSikxlLhSB3
         nUpxx9+4iAYL/yBe/1y+fGmSuBfVYybccFGKtS+bi753NrK6JucmkNjZWLdbEk4btcOO
         4glIkSN54CTuDgzp/BZQgYexAXJDvV/QxgkRGJqLkwoYSlkfd5YFOWGcPvCAG7zy2S+5
         8rg3r746ThHmoYBqxGZbRkXM/0aVKLXVsL3v7bEyHeEYKfvMgD61PN/qAdeztpdulgBR
         GhCw==
X-Gm-Message-State: AOJu0YxxEsM6a9+jhBmVOjNbPPbZ6SEoZouqDEUf3Sz1s0F/wMAdoUtk
	vK2m/x0Bd7TbNdyMjLylVIAGSDTbLJGgjtZaDRbVJG2U7KbA2wrQz3gvJA==
X-Gm-Gg: ASbGncvvGeaNZ91vcT78YYWyyzBAE9N8Rm2EnAOhYZO1SmYs60Cg/h1/p5RpWFpd5Qh
	qAZiQkv38KgDviiLqsrVA+T1hxBKHkz9czaMhN9pOXLSPDRxsUDLwC5dYxsvbdZuEayBnoJs7bP
	MHfa+iZSUxfQEyCMSqfpmKt/v5JJEEYOKgp8Axwzco9pKP/5NPqZy81Ay88LEXjYj5hd2Z+xLFH
	XjCaH4uyO00RXZB97HNCM6ws3vvRjzo7aq8bIG5wHqHlf2Caqusq0cjbtEYrVpWOdz1K1bWfh9O
	Qi9fN9A3s4iqht2s3Wp8JX3xjeLqQ0elgRMhYH4=
X-Google-Smtp-Source: AGHT+IEedfsNCD5AcCZxXZL4gRebDptd71koP9+W/quLDaOFrpyoO4QG3K30I2PhJFBK/JRoMm87Bw==
X-Received: by 2002:a05:6000:401e:b0:38d:d414:124d with SMTP id ffacd0b85a97d-38f6160faedmr11565615f8f.19.1740331304418;
        Sun, 23 Feb 2025 09:21:44 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439b02d684dsm82117765e9.16.2025.02.23.09.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2025 09:21:43 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/3] io_uring/net: fix accept multishot handling
Date: Sun, 23 Feb 2025 17:22:29 +0000
Message-ID: <51c6deb01feaa78b08565ca8f24843c017f5bc80.1740331076.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740331076.git.asml.silence@gmail.com>
References: <cover.1740331076.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

REQ_F_APOLL_MULTISHOT doesn't guarantee it's executed from the multishot
context, so a multishot accept may get executed inline, fail
io_req_post_cqe(), and ask the core code to kill the request with
-ECANCELED by returning IOU_STOP_MULTISHOT even when a socket has been
accepted and installed.

Cc: stable@vger.kernel.org
Fixes: 390ed29b5e425 ("io_uring: add IORING_ACCEPT_MULTISHOT for accept")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 000dc70d08d0..657b8f5341cf 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1718,6 +1718,8 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	io_req_set_res(req, ret, cflags);
+	if (!(issue_flags & IO_URING_F_MULTISHOT))
+		return IOU_OK;
 	return IOU_STOP_MULTISHOT;
 }
 
-- 
2.48.1


