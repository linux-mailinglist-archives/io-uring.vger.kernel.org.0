Return-Path: <io-uring+bounces-4741-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9C1F9CF90C
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 23:06:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50D902819E3
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 22:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA5131FDF93;
	Fri, 15 Nov 2024 21:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tno4B8PJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DAF18DF6D
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 21:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731706395; cv=none; b=ZEFO9VtVPVVF2UXr0Zt42pn7O4yzsipGd6wAQc1PsUghSm2ZSZ+t5is9q8o3aLgvsOsGK4OMSdU6CCMMRgRok1LzlG8TmxNcOVAsbolhRAI6nlGijiqKGk4g37Y5P5ewzM5gn8e98fd5rvP80QsN4ptzu+3jNQo75Fq6ZAw4wt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731706395; c=relaxed/simple;
	bh=4Wi69DKVB39pFl8/D1pSzFc34pxnEHe1sKDwZtEo2+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeoV++hdbEAwJsyQtfqWqUkvAFy7nN/iq364oTVHgusz549nDZ88yWb1N2IFxB+KgjmWOH+wrZdJdfj4S+CjKY2XhdI5fUK3HIP06L1gPXMj1RNSFnet9gBf+Dmw14Xttcl5ZZ42mFTlvib2Q/J2Z0qrZMA0HkHytrJIuhQO+fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tno4B8PJ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4315baa51d8so9472045e9.0
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 13:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731706392; x=1732311192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yRJvpXkonpZLFq2sXYvgesC2fqUsJ/OFGmvyeGbZlGA=;
        b=Tno4B8PJ7rqBeP84MeV5W8Eny2H6l02KrDrVthM2pjzSIWIsfoahpjkOOAsKp4EoVr
         8o5R+ZJAwxQLJXoK0XMJgfzf8vnXn2ZdDtwyNbAiHxzitwB9G38jyOdV68GIn4pKN8cF
         qprG+uHj1c26e1qHYZvD6Ms83iuSNf83JC1Qp1eYYqusUBYZ2cql6meOIId+fwnxbEMJ
         aOErMq2bUzqv0CgJUWLySOQVP6ZxrWuwIPKD+DSkY6gI2rtay1/2oiXX1u+ghdWxmNKL
         7foGZPMRifuOH9e8irs3dLrKkRqbwEwx2IfrYgu1QAlATv8MKPs3ghvOYDvayTXoY/5e
         uLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731706392; x=1732311192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yRJvpXkonpZLFq2sXYvgesC2fqUsJ/OFGmvyeGbZlGA=;
        b=lc+Jxk3x9069XwLvB4dhCJWt1M31a7zeyxQcn0zMBfFsT7fvH109bbi144fIdzeVbS
         HcwP8etZcp517Oy3m1SdQaNS0T7oyjxhGRBTCqpydLN+txTn/6QXii10oecKMc1/9rnw
         WYfllyQS+ft55PDV16cXfuySYw3dunPwpN+Q3O7IGU6f6div9feeOhLkeEmicjS0Ii5I
         kIMayhVB834dlGaAkbHkVxk+ETOoIsUhI1+V1/AU5pYKmb3qfVMMushL+fEy8XYNmuv4
         G+BYPhZ12qZHGDiBM6qy4/NItZys/BD5fzwJI3TQNXeyI0crYeutZlkMgU35caxbBdru
         YMBQ==
X-Gm-Message-State: AOJu0YxcOdpynCML9kn8fntQtx/SkJ5RSMfWfWAcbtgXFrKfxLQaZM0I
	h5/x8HawWMo6l5TVQcvCgZEfoJZzAC5fwfHSTIjygWyIOLkU3hqAWBtoSw==
X-Google-Smtp-Source: AGHT+IEp2CFwu1PD2Qt9LONRFFHcmRPoYa156F4cu7RVc5RwgnWninX1jYq85pf0fAd4bMMxnYdZCw==
X-Received: by 2002:a05:6000:1fa3:b0:37c:cbd4:ec9 with SMTP id ffacd0b85a97d-382259023f1mr3666410f8f.5.1731706391475;
        Fri, 15 Nov 2024 13:33:11 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-382247849b0sm3397258f8f.97.2024.11.15.13.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 13:33:10 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 1/8] queue: break reg wait setup
Date: Fri, 15 Nov 2024 21:33:48 +0000
Message-ID: <ddc75fc65ec8dc7ef0e8a681888266d2d8e9669f.1731705935.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731705935.git.asml.silence@gmail.com>
References: <cover.1731705935.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We're changing the registration and kernel api, kill reg wait
registration but leave definitions so that tests build.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/register.c |  9 +--------
 src/setup.c    | 19 -------------------
 2 files changed, 1 insertion(+), 27 deletions(-)

diff --git a/src/register.c b/src/register.c
index aef5baf..d566f5c 100644
--- a/src/register.c
+++ b/src/register.c
@@ -468,12 +468,5 @@ out:
 int io_uring_register_wait_reg(struct io_uring *ring,
 			       struct io_uring_reg_wait *reg, int nr)
 {
-	struct io_uring_cqwait_reg_arg arg = {
-		.flags		= 0,
-		.struct_size	= sizeof(*reg),
-		.nr_entries	= nr,
-		.user_addr	= (unsigned long) (uintptr_t) reg,
-	};
-
-	return do_register(ring, IORING_REGISTER_CQWAIT_REG, &arg, 1);
+	return -EINVAL;
 }
diff --git a/src/setup.c b/src/setup.c
index 073de50..7c0cfab 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -689,29 +689,10 @@ int io_uring_free_buf_ring(struct io_uring *ring, struct io_uring_buf_ring *br,
 
 void io_uring_free_reg_wait(struct io_uring_reg_wait *reg, unsigned nentries)
 {
-	__sys_munmap(reg, nentries * sizeof(struct io_uring_reg_wait));
 }
 
 struct io_uring_reg_wait *io_uring_setup_reg_wait(struct io_uring *ring,
 						  unsigned nentries, int *err)
 {
-	struct io_uring_reg_wait *reg;
-	size_t size = nentries * sizeof(*reg);
-	int ret;
-
-	reg = __sys_mmap(NULL, size, PROT_READ | PROT_WRITE,
-			MAP_SHARED|MAP_POPULATE|MAP_ANONYMOUS, -1, 0);
-	if (IS_ERR(reg)) {
-		*err = PTR_ERR(reg);
-		return NULL;
-	}
-
-	memset(reg, 0, size);
-	ret = io_uring_register_wait_reg(ring, reg, nentries);
-	if (!ret)
-		return reg;
-
-	__sys_munmap(reg, size);
-	*err = ret;
 	return NULL;
 }
-- 
2.46.0


