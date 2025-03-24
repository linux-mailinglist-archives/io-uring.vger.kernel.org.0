Return-Path: <io-uring+bounces-7219-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9744BA6DEBB
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 16:32:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4D89167AB8
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 15:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F24D25DB0B;
	Mon, 24 Mar 2025 15:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nJL9q58S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5519261394
	for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 15:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742830316; cv=none; b=CCzDx23J8kAUFWXMke0ty2F4Da6jEj7LiA4GAW0O6oOLTazKSzG85POvLs2hwWvXUB+ka5hzS16qXh6p6LfjNSRL6A4T6V2r30AioFbCtDJDk9MpBBHueNJsBMJAzUSEUqvp/VM/aUBrdsGrChc8YtsA+8kdSIy1c+as14h6vpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742830316; c=relaxed/simple;
	bh=11Vyn+Zswmowq8YEh5TDuw09U4H+JPp8lZnGLGGXAqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJxUbm1pOD6Yz1lcIunG7Hu3Cud/ufBedLk1uPkBFcADAaVK9/LHXVz5t6yrjRwPrDwcWjhb7DQEaTYumZ0pxyNcjd7b4M+0/t9O2gMI8mq30zRxS5w4T4NY/Uny8fX1a61mxN1TMtz/Y/3T2Ik6sScfqHXMTlM+AkBRrXSDOI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nJL9q58S; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac2dfdf3c38so634645366b.3
        for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 08:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742830312; x=1743435112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+eFKdomXBrTCRBE2uUxENTQR+vgscBeerSyN+AvZ32I=;
        b=nJL9q58SiCcwySeC/+wj5gBcHFZZG2rXEhFsgaPgmGQ80tTCRfrwnaP18n+qOU0taV
         cDge79NTDWPG464z0TGfGOgmK5sYIU7FRFfR+hCXw8m2v2hHzHu6XttWuGweeNnk5maY
         8nx1YND6n7CvKFlksWg86MHVBdaIBQ7+esecMl/VPW4MygwAp7SFrZWW52a/mUZ15NZv
         A6YyY5uJAWdVcgdCItbty/pNDdZQGK8QB++zkD6+8+Fh8lb7mttzwFN5d8ZrUZTh+RvJ
         prG8zXb4YDSIVBGYT0u1kOFlgNJV87HbVH7OH4VR5k1rC1Gzwrc1HU/kcxqldmiWXyMB
         YBNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742830312; x=1743435112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+eFKdomXBrTCRBE2uUxENTQR+vgscBeerSyN+AvZ32I=;
        b=GXRg8/KHPG6VNVVKihuwkqtlCQiRB78+l2Vw/6QhAz1Y56Tvq8ykDjkeebO+kfPz/i
         OBff25jSDiryZWOacsUIx2yN1bP1vlQDdiL121RFjpAwfE5Ac1mBu1KM9QPvuOrA37GH
         A85wi+Zumhta0R/hblJoeaRdbY28ilwz4r8pomwx6wR3tZ6tOgT0c9ik+fHGEFtq8ZiZ
         T/sQrHHnJUi0D9SIiAc6bytZMdi83/eLLqpOCSLo6Xh4THt7PBpy+AqwViMHOiJoWbdu
         DppeGNx/AZvjyLTmB6WKaAjgPtt4m+B1aB4NLOwrp1FSb8kkcegXnMiQ0b/LjLiiRGbW
         qNvA==
X-Gm-Message-State: AOJu0Yyf39uKCZacbXHYxHyNv5KcBJi0MosFnQ/IZ1FuotDAc63/zf9x
	s2giisdhQQ/gFIk9Gh6HycFvZNNn4WHYWOMbq3KJohAeI57LyTX9yw3Osw==
X-Gm-Gg: ASbGnct/7VYNVxfKSNtPoiV/Yo6iI6th2b4ceKNKPE3bhhARe0IKwLWWB2fBEFVuBE7
	PDHGsQpFtwoDhHP8UwBoz0EOpiUfpjUX6VjdMfEMGqNSWtakguVD/wHAlsoSvcKZ20g+B+i/I7H
	430UK15Gt4jf4aum8C+4YIIwx+bQW9KiJpJxwf5C2kES0YcGCK2AG2CgNMDZqMuisnt2UCU+C97
	4B7tn1MKxThFSKbuqvR2a/lhz4U5a4XlAui54cmjTrqvETUXrBRILaR5PQan6HxsRL1DnRSYX8J
	1rHoidkzv1XOwI4bmNYFNxKPzyt8
X-Google-Smtp-Source: AGHT+IE4NPCllRlxeD+TArdmB1iSXq4ldwYwxqCDcjQltyPBFxErx3KlsrqgZ9wFIZEmPQnDgTUIPw==
X-Received: by 2002:a17:907:3eaa:b0:ac1:fb27:d3a2 with SMTP id a640c23a62f3a-ac3f20b8790mr1355365466b.5.1742830311541;
        Mon, 24 Mar 2025 08:31:51 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8aa1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef86e514sm688103866b.35.2025.03.24.08.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 08:31:51 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/5] io_uring: open code __io_post_aux_cqe()
Date: Mon, 24 Mar 2025 15:32:34 +0000
Message-ID: <2c4c1f68d694deea25a212fc09bbb11f330cd82e.1742829388.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1742829388.git.asml.silence@gmail.com>
References: <cover.1742829388.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no reason to keep __io_post_aux_cqe() separately from
io_post_aux_cqe().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1fcfe62cecd9..df3685803ef7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -834,24 +834,14 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 	return false;
 }
 
-static bool __io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res,
-			      u32 cflags)
+bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 {
 	bool filled;
 
+	io_cq_lock(ctx);
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
 	if (!filled)
 		filled = io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
-
-	return filled;
-}
-
-bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
-{
-	bool filled;
-
-	io_cq_lock(ctx);
-	filled = __io_post_aux_cqe(ctx, user_data, res, cflags);
 	io_cq_unlock_post(ctx);
 	return filled;
 }
-- 
2.48.1


