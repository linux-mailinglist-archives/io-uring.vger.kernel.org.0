Return-Path: <io-uring+bounces-10413-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FFE5C3CB8D
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:09:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32C4E625B80
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4E2C145B3E;
	Thu,  6 Nov 2025 17:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VIYigxR+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F8F2BEFFD
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448528; cv=none; b=IM/gc3qEaXhU0Jc3VxpZ7Nzye9Cj5FbEr7zVwhnHT4izG8LJX1Axt5K12M3rpvuiIYgf1gQQCdkXgbzYcvK8LPfhuODgMLxsGONmQJD+KjjE0nO0pW7x1oydR+axlOdx680D9y+Tq4yq/uy9s1Z45lJvU+RcWrSWol8uUQBLV5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448528; c=relaxed/simple;
	bh=aFPh4O481jgeanTJt6a3sCvXZ6x50MDFA7jLOlf+InY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUwgz8amTlKMJ9UsRTJStEF8UdpeiYoy4onKIiAphrovrP4V1vbg09zwSCmKm78KHCwf+IEckgk3ElkegTzKzYzgbE7i8mwmoYeMz+z+6jufd2O3e2aYLWMlAhpCkgTpaVivv0mlvA/OMpZJ5UKYmzXs09zFnG/sUxRAhcDGrPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VIYigxR+; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-427007b1fe5so775128f8f.1
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448525; x=1763053325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9oSRHAA6+aZG/GXMuX1whqsmcgS+XiX2LNKzzIUWZLo=;
        b=VIYigxR+g1g6B37gqby81BmU7wCERDfSZLPbvutEo2dhOX/QQz6NdpSMTMim5SUCii
         kVj09wENsROJiJoVF9jBthTYShBqJwEHKNYt0JDGFqOaEAleL9/93m5pCvant+BPKyi+
         z7irZKNhEQwWXo5Th+QdpQsmLJRwOJHU5vCog3pM/+XemaINXy41RZw9CY90HRB3WiOh
         MdM0TLb4OCFzNcQz7yJvSL6Q+QC5XPzakgFJLPuFD13ryB/6rg+So8XYMq/PN/bEVLnU
         WNduUGPGmd3vzmCd9RXPNg2YsWQwUcQnshl74KOfBnp0FPQURGNwGtxLJaho/7taE6iO
         nZgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448525; x=1763053325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9oSRHAA6+aZG/GXMuX1whqsmcgS+XiX2LNKzzIUWZLo=;
        b=j5fJzq3+z3netm7NfI26f5Ro3CtxhTJemWvZK8sQr3wPJmtDrM1A9xFZCXqn/sxjiC
         79tI2LOdJue4RMY50jYnVozjdt+2qhDGKEQgRAA+Gz5C5E8ORErNiXIJF3AkNblyEhcN
         Xsx+pRs/yhAmfipv8xftBzltjWxPTUjboiZ4o/1ebSzyldswG2BoMiSQzdS9zghv666O
         wVjCQ9x/6UAUV2G+hYW5phFuy/s9p4zVpxz/R/6ySO/tvQqkLJZ9IkLTzGLqZW3zYN4B
         6w2g4IEOPiyvuotDFlbai7wtePXWajkWi58sAqFjB1/C/NeYk2rtHHAn0fvnqtYKpom+
         AOrg==
X-Gm-Message-State: AOJu0Ywkg5NTwXZRJLMz0q2dR7h6tVM4C+eXUwKMbo6ITKLMTkt3HupC
	5VmNhwKFy5SZIHta4+ZCXfjf2ay+VPqVgAcvxoZCpBwkcsj6tO3AeCLwm2SD1g==
X-Gm-Gg: ASbGncuB2lHl0OAzkd9DeE1jZvOWdvAuwIjsLlelD8nZ4b8xXU5Xly5jB+pxXx0ihwc
	FeiLeBTnEfteyx1v58ssnnLJ83DNMbF8Pdnz3SbE1dRQVkuSl1fCqhsFRFmdnmU5OvMMIOd9C7U
	2jppUVh1/Bngu32dZb8lOZUN9+x6ycxpQFmaEoWvAYvzF5Ng/Jdzu3gQ0GaK4aOtH9KljoptSSn
	DXh1CEgElNaBagXqdAkN3+Fsarz7oEtDAAjHyNT7UWVuE49Fvel0mqmWJxg5CfSDaxWfmVJdAjC
	zrSdhXUUNU4drC0JWX2vAE20T+jdAY2Z4Uc4nwkHC0dFKypglevcqh0W+XkkLfZKy+4ozHsOQvl
	cZ4nH2jG0t4uagoWukJzHIMlsFG/P0CX9vXp3CXhfJjQYeqmCf/W3zvou2EyELqOghAbuIVhEKn
	rYr/OyHV7yCzWtBA==
X-Google-Smtp-Source: AGHT+IHUilOm6ZNeu1C1zMRAn9vi+TWK7hyq+KuAKbF8ymvu0oIuZjVwJVZ+f4Kl4NEnDTQwoEAlbw==
X-Received: by 2002:a05:6000:2481:b0:429:c2fb:48cd with SMTP id ffacd0b85a97d-429e3313336mr6213007f8f.51.1762448524800;
        Thu, 06 Nov 2025 09:02:04 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:02:04 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 05/16] io_uring: introduce struct io_ctx_config
Date: Thu,  6 Nov 2025 17:01:44 +0000
Message-ID: <3fa3760056e2c4297e8b2d92a0a1b66e261a13b1.1762447538.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762447538.git.asml.silence@gmail.com>
References: <cover.1762447538.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There will be more information needed during ctx setup, so instead of
passing a handful of pointers around, wrap them all into a new
structure.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 19 +++++++++++--------
 io_uring/io_uring.h |  5 +++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ef1b75c5a4d2..142811c7a4f5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3552,9 +3552,9 @@ int io_uring_fill_params(struct io_uring_params *p)
 	return 0;
 }
 
-static __cold int io_uring_create(struct io_uring_params *p,
-				  struct io_uring_params __user *params)
+static __cold int io_uring_create(struct io_ctx_config *config)
 {
+	struct io_uring_params *p = &config->p;
 	struct io_ring_ctx *ctx;
 	struct io_uring_task *tctx;
 	struct file *file;
@@ -3638,7 +3638,7 @@ static __cold int io_uring_create(struct io_uring_params *p,
 
 	p->features = IORING_FEAT_FLAGS;
 
-	if (copy_to_user(params, p, sizeof(*p))) {
+	if (copy_to_user(config->uptr, p, sizeof(*p))) {
 		ret = -EFAULT;
 		goto err;
 	}
@@ -3691,16 +3691,19 @@ static __cold int io_uring_create(struct io_uring_params *p,
  */
 static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 {
-	struct io_uring_params p;
+	struct io_ctx_config config;
 
-	if (copy_from_user(&p, params, sizeof(p)))
+	memset(&config, 0, sizeof(config));
+
+	if (copy_from_user(&config.p, params, sizeof(config.p)))
 		return -EFAULT;
 
-	if (!mem_is_zero(&p.resv, sizeof(p.resv)))
+	if (!mem_is_zero(&config.p.resv, sizeof(config.p.resv)))
 		return -EINVAL;
 
-	p.sq_entries = entries;
-	return io_uring_create(&p, params);
+	config.p.sq_entries = entries;
+	config.uptr = params;
+	return io_uring_create(&config);
 }
 
 static inline int io_uring_allowed(void)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index b2251446497a..c4d47ad7777c 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -17,6 +17,11 @@
 #include <trace/events/io_uring.h>
 #endif
 
+struct io_ctx_config {
+	struct io_uring_params p;
+	struct io_uring_params __user *uptr;
+};
+
 #define IORING_FEAT_FLAGS (IORING_FEAT_SINGLE_MMAP |\
 			IORING_FEAT_NODROP |\
 			IORING_FEAT_SUBMIT_STABLE |\
-- 
2.49.0


