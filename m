Return-Path: <io-uring+bounces-10497-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 43328C46C23
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 14:05:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0035D4EA4DE
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 13:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 183542FB970;
	Mon, 10 Nov 2025 13:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dc6jJTs6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4268C1AF4D5
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 13:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762779903; cv=none; b=eKnfi9ExDgrK6crYtGiZX7+DD4v1FbjhJKlZ80BwttvB+BTuxbPuH/8aSiuX5eXEqh883y1hSsAdIRUVrFP1xVx4bfEcIbOqxn2S2etw4vYDuIa25pZ4rb5FOgyYaW8gJqaOmjD+T+rVlrHMemBhmLFSIpU3x9KFtEz628NL2ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762779903; c=relaxed/simple;
	bh=gwPlO+Iiy+dzcFTjtscRm1QuuKJSlK3dgiLPSZKndX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9H0ajsjdnMlSB2Sg3nDRkNfmVJCo6tEQqeqGse+xi34LVEn72uUKwF0W/sEc4y+qwCAEKp6cW7laCjoxc3M86WxPJdASgUqPl+358vSwqFm641CA0CHt9XzAhxuMdvacOQMzMl/GhrkkPaG26fwNsh/dy+WOLcLKU5gZ+F8IG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dc6jJTs6; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42b32900c8bso782279f8f.0
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 05:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762779899; x=1763384699; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=78fGCfNvi/9pJzVU6RfgCIoGQiPEeAmHNWtFVeT6GpU=;
        b=dc6jJTs6Q9oqP84sv3IZPe8mcf5qgrWgEWPK8sm33m7eRPBeqGdpk5JVyVJxVtsiz9
         MfRBw8c7hue5t2WSaJZDz0AlVzQeVwF9s8xreiC0RBStroIWkvrhsvjJJ+LrQN7Bgiby
         jsHgLUbWvwLiR+Lf9tPCCkAJUiDDrQlphfbRXQwwMrSaAg1GDuxHaBfhREGUTnEBogkg
         dGPWJrscx7POmb64VLfmdXuavoRWQiJcdKP5107jwwQtAK4Ix9p+eg/RfkcNI0cb2cfX
         nPH3oU1G7buto5oKP4U2O0kZlWDDzw4hU/Mloxr0gn30fIWpNpmxMvjSrusKlX882g6I
         b+xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762779899; x=1763384699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=78fGCfNvi/9pJzVU6RfgCIoGQiPEeAmHNWtFVeT6GpU=;
        b=scYQKFxRuh5H6OoG5fkwkYI7IfkKPYVa4pT8bjLk6vFmJlAulEN8iNu31MQv3IALmE
         ubDndr+TrgwZZMtfmlWSYIwm6+pwk/y/UCZhDvFzDDsqy3YCnuenCQUZpzhPARAJ3nWf
         FaXNQG/pvDzLU14H2mTD61rlKic7kegaHKAERb3frlQgj5mtfJLELwUe6j4Irk2oLiRy
         M9ya5e82h38ELyXa22a7ekcOLAQvepYRT3ipPk+NPsyFam4G39yNO6knPTN7SFiMthkL
         nSl1fCBVN7Sr/rtVAEnXCnN1v2lRehzFft/T1MgsTjcgErBWOLaLnvl+ZiEkuUlYQOFj
         nqMQ==
X-Gm-Message-State: AOJu0Yw9uuICCi4SI8b+qTSFMnb5xicuRcDu4gIGheRVN1j7IBSevtQk
	TJNWsK+teacoLWypAe06GNmSpJYYMjPTK2ZJHwgkvaoC+nJSFJPc4SLZIM1C8Q==
X-Gm-Gg: ASbGncu0Q/rzqP/kvVF49R2x+Gyh61jDSyXHYApnF7Gpe1P6s8e+zVLzIFODNYc0J/m
	hae8+rHN6xmwOzS5IpZ/At4l9HGvl0zcllQPuOI0u4tlYJM8mjLtz9GSn/l5xeBHg04dyrpHJl5
	xeTaav90I2ElQ3mZyDwbQ2WE55hFn/ch5tG5FGEpC/hhw++/84mDNTo4wkGhSkyiWQN2mz4AGzR
	H0Mn8VEJkcnZ5/SKK9rDoKFPWRsJC7aN9f9xniCMBCcNcvz7Lp160x94XqhphnuR/o+yxK8EBdq
	j+KQ16TOY9UyfF8dLrxgSLWpWknCWW1Mx/59kqMbaY7oqzrrJ+vBWYXI2bZneC4pMrQEFxCPtIR
	3GsTZ7QMd1WFwRe4kTkZMOWiobEmNFP5vrrlOluo52aZJ5RRe26ONzINfaHpSNxnY2iGuZETFnE
	/pc0D3xyVF5Xfj1A==
X-Google-Smtp-Source: AGHT+IHOmOTFh0ZRB4BTwEJUDCo4nnbfEoEDB5EZDaCtw9ehNClRVK8c9nYEXVZhrZEG9xePQ3LGcA==
X-Received: by 2002:a05:6000:3109:b0:42b:3dbe:3a55 with SMTP id ffacd0b85a97d-42b3dbe4204mr1726554f8f.14.1762779898711;
        Mon, 10 Nov 2025 05:04:58 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b330f6899sm10584648f8f.21.2025.11.10.05.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 05:04:57 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/4] io_uring: pass sq entires in the params struct
Date: Mon, 10 Nov 2025 13:04:50 +0000
Message-ID: <ed5300a555e99ffef63713b8aa1a5a0fe9491d80.1762701490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762701490.git.asml.silence@gmail.com>
References: <cover.1762701490.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no need to pass the user requested number of SQ entries
separately from the main parameter structure io_uring_params. Initialise
it at the beginning and stop passing it in favour of struct
io_uring_params::sq_entries.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 11 +++++++----
 io_uring/io_uring.h |  2 +-
 io_uring/register.c |  2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d11d0e9723a1..023b0e3a829c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3479,8 +3479,10 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
 	return 0;
 }
 
-int io_uring_fill_params(unsigned entries, struct io_uring_params *p)
+int io_uring_fill_params(struct io_uring_params *p)
 {
+	unsigned entries = p->sq_entries;
+
 	if (!entries)
 		return -EINVAL;
 	if (entries > IORING_MAX_ENTRIES) {
@@ -3542,7 +3544,7 @@ int io_uring_fill_params(unsigned entries, struct io_uring_params *p)
 	return 0;
 }
 
-static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
+static __cold int io_uring_create(struct io_uring_params *p,
 				  struct io_uring_params __user *params)
 {
 	struct io_ring_ctx *ctx;
@@ -3554,7 +3556,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		return ret;
 
-	ret = io_uring_fill_params(entries, p);
+	ret = io_uring_fill_params(p);
 	if (unlikely(ret))
 		return ret;
 
@@ -3693,7 +3695,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 
 	if (p.flags & ~IORING_SETUP_FLAGS)
 		return -EINVAL;
-	return io_uring_create(entries, &p, params);
+	p.sq_entries = entries;
+	return io_uring_create(&p, params);
 }
 
 static inline int io_uring_allowed(void)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 23c268ab1c8f..b2251446497a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -136,7 +136,7 @@ static inline bool io_should_wake(struct io_wait_queue *iowq)
 
 unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
 			 unsigned int cq_entries, size_t *sq_offset);
-int io_uring_fill_params(unsigned entries, struct io_uring_params *p);
+int io_uring_fill_params(struct io_uring_params *p);
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 int io_run_local_work(struct io_ring_ctx *ctx, int min_events, int max_events);
diff --git a/io_uring/register.c b/io_uring/register.c
index 023f5e7a18da..afb924ceb9b6 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -416,7 +416,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	/* properties that are always inherited */
 	p.flags |= (ctx->flags & COPY_FLAGS);
 
-	ret = io_uring_fill_params(p.sq_entries, &p);
+	ret = io_uring_fill_params(&p);
 	if (unlikely(ret))
 		return ret;
 
-- 
2.49.0


