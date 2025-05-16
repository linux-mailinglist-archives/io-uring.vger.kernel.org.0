Return-Path: <io-uring+bounces-8009-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD8BBABA32B
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 20:50:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52ECD169F31
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B1927875A;
	Fri, 16 May 2025 18:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fYWD9F91"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B0E1C07C4
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 18:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747421428; cv=none; b=BxaJksZ6M7Ss38orWErDO+17SV8c5rQt6rH3PVXGQOrl5G2XCvYAjX8CAKF8/ucJmxY6hdERA70KGhlk1gMwF0tNcsOgyez45N9hvPo7gU6zH+Oo+tloCoDhvpG8GsG98ojbJ1Oi8CuPIMmoxYL5ieWHs9/Xio1jrwSIohen3Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747421428; c=relaxed/simple;
	bh=GOtZEIEXUmx1RCRwMtn5oHRyBl1Vm5HQ3BUp1bUnWRc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=UNyIJGqVjYwINytsbfoUQ8EuPSe7qQl6weRWk0yI5dLeUqgqa6VVIyalaM3UhfMebZ7IZBEMwL/07A7wjLZ/IT3nGznJ2nBXeC4h9x5IbJzady/0qlL1tIeyI6pxl64j7MBn2pIkVo9ypoLcP6yhjU2W2Li7yXTIzZa82xStwas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fYWD9F91; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d948ce7d9dso8326075ab.2
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 11:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747421424; x=1748026224; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jN+rYPV1x2beF3kDpMeSEXJiGC5a2elfzgl0Lbpi1Pg=;
        b=fYWD9F91HfZu4MTmLcS0LyywLbapu/5dFAn7sbgHuTiH31wInpOffIMaTVohaAuk05
         WiXYYKIrscLSvSGZcyHl0PLUI3DbUEUnsfw5c3Rmy7RudmhL60vJ4skfcDf3p/V+5zgz
         vi7bnEbIPSIalxFMsZsiREr/ydwauzDpqgzZCCwimdHbvpU7QDHX1U6Une7GcD2wXy19
         1tLh9V2skridT94Wo5fJtXNT/xsoAyT7ekIl5IpvcoV432SRhAJjqp63V1s/9LKlorms
         Lzn5v16h5q4nMXrFoNQKQfsXMpd4/+S7FBCjzp5Msfxhnb10vn7MgTwd0k8k4uM6luC8
         ZH0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747421424; x=1748026224;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jN+rYPV1x2beF3kDpMeSEXJiGC5a2elfzgl0Lbpi1Pg=;
        b=YtrzskL/FSIeCS6L2Bn7Ep8iMI7uWdZaBXnFKcB3lUo0xfWmmF1eajh7JkZbjPA/rf
         hSyuCGTFcwfLqmKdW+B0rcKWryX8wl83wXkKvaebHMwuB2/xGCCqtBFNBR7/ZgQO3Zip
         HXfLXxDdEDsDcY692dK/Pjwa5evAVVDyszCYiE/VrqZ8yT1EyHKSTQ2TPi+TmvY86Evh
         N9Mt29YKSHMAhG0NCIdPJ/usDIpXbgDReFaIH06NAK7TJrFe5WMtL4HfzpPzaIFeU14i
         PH4y5g+Dpq2uOeleVa6LtxJzLswAnrZMVAF9/h9+Y8QHLzVyeoaj1y2f778l9qFIuOqF
         1WrQ==
X-Gm-Message-State: AOJu0YwH8L/pDVMEdw866OaB3pE9B35pjUkOQDRKXiURtgiHtHIW3kIo
	cG0pyBcsMgahJNV4qMREfacdApKqYN7tUCe5MlDVIdZEL+xJf1GL9naq0bANUnkF/SKLnmOsP3Q
	vd8Ys
X-Gm-Gg: ASbGncv662QPOLJ65tbZu3AN0Fc+5dTVynuR5fYRJv9ISs/5pFDFURRfmhYiauNIyVt
	TiKWLBCqXZKXrvQugDwC9sPg2nx2hcAxSfwwpk6LIWquLQgdO3MwrdcZxyG9Yq8LLD1Wx4LMlxg
	LeLDbKurFf/31lvizzsUY3rE8iMaY9CYUtQuERKrQFQHLrJOeKey1ING5jJtZ0pebFsorwx7DJT
	k3plLpTWwSGo8Uy+QJQj/tEgwno8RQHhWLU/epGjhAqUfMM3EKlBKpAByimKqnqYg1pwxMwoA0m
	obieIbrNV/nFkRRU/eNOp4DhX1IDg8wtZYykGcbZJn2e82jU
X-Google-Smtp-Source: AGHT+IHx2TYMAZfPzc4CYSgKaftj7C+ivuDIGwEjkPDyg5bhdrE08teBR2XJeLdRL2TfAj17kpjNDQ==
X-Received: by 2002:a05:6e02:2592:b0:3d4:2a4e:1272 with SMTP id e9e14a558f8ab-3db8435667amr57224375ab.19.1747421424579;
        Fri, 16 May 2025 11:50:24 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3db8443a3b8sm6114085ab.48.2025.05.16.11.50.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 11:50:24 -0700 (PDT)
Message-ID: <b7836adc-5ddf-46a1-bb39-6c27338e7b51@kernel.dk>
Date: Fri, 16 May 2025 12:50:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 4/3] io_uring: add __io_cqring_add_overflow() helper
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com, csander@purestorage.com
References: <20250516165518.429979-1-axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250516165518.429979-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This splits the overflow addition into the typical two helpers, one that
already holds ->completion_lock, if it needs it, and one that grabs it.

Also mark both of them as __cold, as this should be mostly out of line
invocations, and ditto for the ocqe allocation helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b50c2d434e74..d14a9b5eeb59 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -697,8 +697,8 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 	}
 }
 
-static bool io_cqring_add_overflow(struct io_ring_ctx *ctx,
-				   struct io_overflow_cqe *ocqe)
+static __cold bool __io_cqring_add_overflow(struct io_ring_ctx *ctx,
+					    struct io_overflow_cqe *ocqe)
 {
 	lockdep_assert_held(&ctx->completion_lock);
 
@@ -723,9 +723,19 @@ static bool io_cqring_add_overflow(struct io_ring_ctx *ctx,
 	return true;
 }
 
-static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
-					     struct io_cqe *cqe, u64 extra1,
-					     u64 extra2, gfp_t gfp)
+
+static __cold void io_cqring_add_overflow(struct io_ring_ctx *ctx,
+					  struct io_overflow_cqe *ocqe)
+{
+	spin_lock(&ctx->completion_lock);
+	__io_cqring_add_overflow(ctx, ocqe);
+	spin_unlock(&ctx->completion_lock);
+}
+
+static __cold struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
+						    struct io_cqe *cqe,
+						    u64 extra1, u64 extra2,
+						    gfp_t gfp)
 {
 	struct io_overflow_cqe *ocqe;
 	size_t ocq_size = sizeof(struct io_overflow_cqe);
@@ -820,7 +830,7 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
 		ocqe = io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_ATOMIC);
-		filled = io_cqring_add_overflow(ctx, ocqe);
+		filled = __io_cqring_add_overflow(ctx, ocqe);
 	}
 	io_cq_unlock_post(ctx);
 	return filled;
@@ -840,9 +850,7 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
 		ocqe = io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_KERNEL);
-		spin_lock(&ctx->completion_lock);
 		io_cqring_add_overflow(ctx, ocqe);
-		spin_unlock(&ctx->completion_lock);
 	}
 	ctx->submit_state.cq_flush = true;
 }
@@ -1451,13 +1459,10 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 
 			ocqe = io_alloc_ocqe(ctx, &req->cqe, req->big_cqe.extra1,
 					     req->big_cqe.extra2, gfp);
-			if (ctx->lockless_cq) {
-				spin_lock(&ctx->completion_lock);
+			if (ctx->lockless_cq)
 				io_cqring_add_overflow(ctx, ocqe);
-				spin_unlock(&ctx->completion_lock);
-			} else {
-				io_cqring_add_overflow(ctx, ocqe);
-			}
+			else
+				__io_cqring_add_overflow(ctx, ocqe);
 			memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 		}
 	}


