Return-Path: <io-uring+bounces-7973-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46B85AB6541
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 10:06:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 886A73A792F
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 08:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B663E21ABD2;
	Wed, 14 May 2025 08:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CdjQn84c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8F820B7EE
	for <io-uring@vger.kernel.org>; Wed, 14 May 2025 08:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747209982; cv=none; b=YP95mfBhrUtvbn/8TszP6L7spA2Py0euEd7izbTppzMLBmzz4yxXfdDApJNeJC2ELbSaheMLj5WRwu4fnkiLqdJ60U0S+29MRhaQNzIQiRn7UauarRc5kmpfYeIP3s1XqEebif6zbrjbCx6PKZIxEVtzieFaDPNIpGBxz5laWqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747209982; c=relaxed/simple;
	bh=2k+hEysu5k1s7P5NjzJkjEb1CmbOUsZOr+XCFzFQTzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhokAphyoFFAV4xzV7u7Q9B4T3vusTbra+D7O1QefhJ1NjDz3otQvOlsA06akhv9htP/lXfi3L+vr0ZIFAh6lbQ7cbcVxo4GYWdXf5S+u8tCFIQu2581CdAlYYF745DakjZG/cQH35JLe+lzytIqBoxSnJt2baxhr90F5t90r9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CdjQn84c; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5feb22e7d84so4280438a12.3
        for <io-uring@vger.kernel.org>; Wed, 14 May 2025 01:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747209979; x=1747814779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oItU02zh1aVbjvMDQUYhwBHON5n9CitHGx/S1hZ22eM=;
        b=CdjQn84c4dKve3WxaE1bMC0KKHQBlv/Xa1zRTbaGbbcA/8aD/snDeydDWwcUa65WKl
         1XY86/lA7QnfZMIVl1R43NyDcXWUIcgLTMR8Nyps98QA9IiJkKXZJflYxRHMul/loMn2
         zb1OMqBIs4mkVvvlAJzPAEK8RKQIv28Aq4jpOZ5vSVslN5m1vv+E9qW3NDCgDUGdXtWZ
         dfwI3oyFtfjpFC2jF8IlZZJGLuoU8wyZ3D97Mi/GWBc95dCQHM70oIlT7scafjdJf+YO
         GYqEPeIQZDQbkLMUBb8vmx2a5PeDHA3Lw3JzDWP+MUK8hCUYsD/TtLkTP/ioTR6rDNYX
         rv3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747209979; x=1747814779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oItU02zh1aVbjvMDQUYhwBHON5n9CitHGx/S1hZ22eM=;
        b=ttq4G4+naHt96K6hyQ9FtTVoEsoGVSD4VTk0IlUoni9vm6qzDDUQe2YEq5q5z3Af/8
         MUqc8pB0uzSNlrwNYthUPpwQ8/EWpdRuWQEzPA2m96xKiy+vLAhhSLZ5XV+Gx3h7ci9O
         6eHqWC6bBJ7VnXJE+Xs2aCjJj3TYS06iUTlb5I0wKN86S2DfINJYWgQJzjP91bxM6Ues
         YKpJYT92HjXpo39YewGRY5+CwHMmhI2MaVgyhlLuQQyABPRSSKPlyjRGtLHglXIw942M
         0fXkj06gb/4VRwmDxwIdtm/YUSR3SRUfrfNOVcRO4rNg92HNkcZplgnaeuDk4VWlA+St
         jZag==
X-Gm-Message-State: AOJu0Yxj0S7OgeYCkWt+Zacty7bIZ1Ibk2yeVovEbxaomTI2EKCCwNSI
	b5pzBmaNOJa6b0ZAwy93Zo3BwRW9VRKqztdwrdnV2HGpm2v5EUQSS8Ng8w==
X-Gm-Gg: ASbGncuOC32Ibgl+y++XDd+ZU9cIo5suZohq6Epnw3duxknh5MnZXHWCPf5eIiwoEUc
	nt4HkGe01y2Sk3Is6CTPYAk7TgAWypiTPiW4vJWbyUmE0HHt73vyWNdLlg6sejcCZkDGvLAqcF2
	9GeNL6Sx0ZZRbgT78iRaWIrCK3i5rQtNoyMAK1sTvDxXGY3fUMn+CHcW93rKbgZsSn3RyUJCJGC
	ZEqkagkrb/xutJjV6t8Iw3e0Tpi4IFtlg8Nuh8QBK7D273/kFSpGG39vi0du5vQe+iI9VivbVtF
	q9dK+GpR8ciZnXOk8HqrA5cuRDswWEF6jsQvBXxt//rMPw==
X-Google-Smtp-Source: AGHT+IHzmIxn/iuD6U+PpCH+LkVgnu2YELxX2lv6J/Fi79sSOIAxNC7lZFiASchkrIOQrEVwAylGBg==
X-Received: by 2002:a05:6402:d0d:b0:5fb:1c08:d8f7 with SMTP id 4fb4d7f45d1cf-5ff988a6036mr1654348a12.12.1747209978419;
        Wed, 14 May 2025 01:06:18 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:ee61])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fd29adb7absm4969579a12.32.2025.05.14.01.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 01:06:17 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/4] io_uring: open code io_req_cqe_overflow()
Date: Wed, 14 May 2025 09:07:20 +0100
Message-ID: <ad959f0172688456bb3e4bf6a8a0bf46d8893475.1747209332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747209332.git.asml.silence@gmail.com>
References: <cover.1747209332.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A preparation patch, just open code io_req_cqe_overflow().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9a9b8d35349b..068e140b6bd8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -760,14 +760,6 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	return true;
 }
 
-static void io_req_cqe_overflow(struct io_kiocb *req)
-{
-	io_cqring_event_overflow(req->ctx, req->cqe.user_data,
-				req->cqe.res, req->cqe.flags,
-				req->big_cqe.extra1, req->big_cqe.extra2);
-	memset(&req->big_cqe, 0, sizeof(req->big_cqe));
-}
-
 /*
  * writes to the cq entry need to come after reading head; the
  * control dependency is enough as we're using WRITE_ONCE to
@@ -1442,11 +1434,19 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		    unlikely(!io_fill_cqe_req(ctx, req))) {
 			if (ctx->lockless_cq) {
 				spin_lock(&ctx->completion_lock);
-				io_req_cqe_overflow(req);
+				io_cqring_event_overflow(req->ctx, req->cqe.user_data,
+							req->cqe.res, req->cqe.flags,
+							req->big_cqe.extra1,
+							req->big_cqe.extra2);
 				spin_unlock(&ctx->completion_lock);
 			} else {
-				io_req_cqe_overflow(req);
+				io_cqring_event_overflow(req->ctx, req->cqe.user_data,
+							req->cqe.res, req->cqe.flags,
+							req->big_cqe.extra1,
+							req->big_cqe.extra2);
 			}
+
+			memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 		}
 	}
 	__io_cq_unlock_post(ctx);
-- 
2.49.0


