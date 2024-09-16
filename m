Return-Path: <io-uring+bounces-3208-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F28B397A3C6
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 16:09:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 318051C27FAB
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 14:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 936CB158208;
	Mon, 16 Sep 2024 14:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dYc0C88A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DED2157493
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 14:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726495639; cv=none; b=XFXxckfDDxfxBH0qLVtXkO9ukWGV64KAEBEoa+cN+GnQryyb2XcXVqw6/4qMADzoBtyBlme6YEhVdrrGL3gWesYFdjtSqvD6owcMaFo1FJjVWsbJum19FwOuFeAzwXwzgoZD5slpeQB/q4QsuoQ5+HE4AQwqZUVuh5spbcXrBRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726495639; c=relaxed/simple;
	bh=9fpsYcPjxb1uoqdMEAieb7ZKGURnWGooE/R/MtJt0rg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Mkz9i//uzv6Vdm6CIW7Mu+ywSGYx6DgW7k0TTC4ra4cLcjWGkiQwApYS4XtrNLbrPA6Yfce+XJ2P7xgSzapIS8Y9Z5ZGTRQuvtck7k6S+qA3d91dtROuhzsAZEO/RGuIj6ma/qIyESEjf+PAazII2wunsXHpmC8iYtGXqAkKGYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dYc0C88A; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c413cf5de5so6289285a12.0
        for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 07:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726495635; x=1727100435; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+urhfmX0gEPcBzlVcIkRBv+Xc6c9XpUnmfqcLpG9k84=;
        b=dYc0C88A+tEy+30aRTkY7qMmd66B2c1Ar0kzxevi+fe2LgQdGPO1SipDj+fbsYWyKR
         WiKz8hYL71wMO6bKD1gqBvkhzv/Du3Vc0YZ3y84Jgon+OM+lSpXsuFDa0m4P8DNBxRDi
         4D1BG+1/pHbvjinLPj6UM2BJIzjydAX9qkhfN+kGCCLx0jVLN1vvVRQ6uWKI7Q6IrobP
         7S0TMFEMAy/6LmVun6Tmtj3Nl/gqLbvnALvJq2OEebcB5pnwDvO9PG9dG3trYTF3UKqR
         PG0hMVIzgeHLOrjN2t6PNzHzsL0POwWpeIndbeQUx7b3g4aZ7S//BwM0R4gdZzbxvhRh
         b/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726495635; x=1727100435;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+urhfmX0gEPcBzlVcIkRBv+Xc6c9XpUnmfqcLpG9k84=;
        b=UxzJkQI813CRhVUKnA6AcJ0UXfOVkvMAHJvxBPN9TTj1UT1Lza397W2DXa9EP5DkoS
         8kekfUFgqgBHrOZFPMog3HHFmkfGv+PerJyRDvpnZGJfgCv42AqdPxqyyS/mNDg8x7JY
         RJ38Zcwhg+Ym5BRZfPZqjfCxOVoCxzVWIVXJzO/Skb8rQU5SMf7RRRzuQwctyu+QshBK
         +vrKXzdrV/yUacIENcTozVdqvItKa/RYCVbweYZMYxQNxsnlzZSIB39wVzPDKlQgumEp
         KmfMvh2PV039Cahce3CMXPmbQo60H1GToWaTzi5Ep9atTslrYCTZ9Sr+FQItogLJIu2Y
         BlTA==
X-Forwarded-Encrypted: i=1; AJvYcCUFFZR/jV7TIFVi36T/ugD4+D2+EsA3cOCF9mmeYT7x0HLWEAHIoVpG6EpLjiqdxl28+wG30DAlsw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwXzhCm0yqvT77bHx5sVtaqXVfe3WSfSnn1lnZgcLeXfFRgjar2
	JyurHkIwbGdbWApjV6eVgqYYaY1kZuBX/8hh0J3MdwrmTFjSFKZSmb2GTenlmiE=
X-Google-Smtp-Source: AGHT+IGpdf/bVgk6BGObyyM95jOqlzvTJMhqTClXF6aSu3Wdslx9j/hss0XI+Ji9ZIWoH1+SkeVxYg==
X-Received: by 2002:a05:6402:500c:b0:5c0:bba5:60d2 with SMTP id 4fb4d7f45d1cf-5c413e2cf48mr13620216a12.21.1726495635262;
        Mon, 16 Sep 2024 07:07:15 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c42bb89c4esm2608985a12.61.2024.09.16.07.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2024 07:07:14 -0700 (PDT)
Date: Mon, 16 Sep 2024 17:07:10 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] io_uring: clean up a type in io_uring_register_get_file()
Message-ID: <6f6cb630-079f-4fdf-bf95-1082e0a3fc6e@stanley.mountain>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

Originally "fd" was unsigned int but it was changed to int when we pulled
this code into a separate function in commit 0b6d253e084a
("io_uring/register: provide helper to get io_ring_ctx from 'fd'").  This
doesn't really cause a runtime problem because the call to
array_index_nospec() will clamp negative fds to 0 and nothing else uses
the negative values.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 io_uring/register.c | 2 +-
 io_uring/register.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index dab0f8024ddf..165f8661c12b 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -561,7 +561,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
  * true, then the registered index is used. Otherwise, the normal fd table.
  * Caller must call fput() on the returned file, unless it's an ERR_PTR.
  */
-struct file *io_uring_register_get_file(int fd, bool registered)
+struct file *io_uring_register_get_file(unsigned int fd, bool registered)
 {
 	struct file *file;
 
diff --git a/io_uring/register.h b/io_uring/register.h
index cc69b88338fe..a5f39d5ef9e0 100644
--- a/io_uring/register.h
+++ b/io_uring/register.h
@@ -4,6 +4,6 @@
 
 int io_eventfd_unregister(struct io_ring_ctx *ctx);
 int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id);
-struct file *io_uring_register_get_file(int fd, bool registered);
+struct file *io_uring_register_get_file(unsigned int fd, bool registered);
 
 #endif
-- 
2.45.2


