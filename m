Return-Path: <io-uring+bounces-7982-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F38DAB7836
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 23:52:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 243DD7B72A7
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 21:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68EF1215067;
	Wed, 14 May 2025 21:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="j8HhRyUE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B176B21C198
	for <io-uring@vger.kernel.org>; Wed, 14 May 2025 21:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747259548; cv=none; b=e/r9fousODSy7kSt27dw3ZYfnihw5YX19D45zIl30/Fsr0XuHfMyG8BQ4oMgpyfNsNvCxr7QqpSMCWNR/nQgHGujCRUgyAklSAgsRK8dxJ3m145fEi6fyC1Fix7mzncl8mXoYWo3ikt3fFr7memMcZ4BKmNG96WzIqbcK2pij/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747259548; c=relaxed/simple;
	bh=AiphOa83E9uYpFP0Y1DjkovhWSMgyuAVkojFIINlics=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=CQy3O2MYMm7bxQIVmgZ4vKD1uILNWBsnNDLwFhgL/+MwvOBlaHVNIiYFtOp0rByUZzTOhyAi07O8qKGMxeyYBgq1n515TQhyNlgTKgzFzOVMCO/FcZyUHJmAuO53RqJQxKO57BeLkirmpHfM+86OmR7eW4HE/pXdfV7LBctjdYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=j8HhRyUE; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-86135af1045so27122739f.1
        for <io-uring@vger.kernel.org>; Wed, 14 May 2025 14:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747259543; x=1747864343; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TWkENYUuaCWWreHryfXUYq9XHcGb11gTeFkdsUA3IM0=;
        b=j8HhRyUE3a1yoiNV2hn0sc9F78317FbgvMIi5AZF9nJaWwcGF/jGACGr3x3TSo6y3J
         WI8Ome+Eex+X3BuXVdi+ysVStLwuByXFwpa/M9/FQIh2OixyujMOmf1JE9r6Br+m2rfp
         iDd1huDTMn+Mq+cM45YErM2YqxHQvjhmXPjhh/s1pGlS/l5m/IeHP+Dh14xOBe0Auiyw
         WDNEO+801aZfaxNilkW5neeX+ZZHnR5kCYG+YItTtBbHaSwbkodOT2CHztap6p01vCmc
         rPK4eV8wKMupq5frc13hUIdnOroLdyAZTl18ZL/GlFQ3alrFqHs640iPMhaiCjsnfYL2
         3WMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747259543; x=1747864343;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TWkENYUuaCWWreHryfXUYq9XHcGb11gTeFkdsUA3IM0=;
        b=Dynf4yOnz5Oh2dkiAzhr0TFNyHRVL/nerAafLGTgBpFxPjqVIjRu7t2x7mGSJnvjqd
         QJUwNki66G8bCoZpWi9iOkuUd77U2p2qYbGg1d27TX+MfgyEffBHLJK0Md0JF7LYPmw8
         USwgpu90cDPDMHe1dNKALAkXyG06iWU8LUL46TYsvTmyUtjOKV5D1XC5CLri1j5RzejI
         h/ChZXQ61mPWV249FCmLW51C2EaZZAS5hstQawYcKxBZinyftbiDD8xqP+Xis+SnlBPn
         HjJ2GTKZj9u8ndiUewniKjfd6Gg987vN6nF/GDXsTFc1jeAEzX3PliO8b2VWuDRBZ3mI
         ygow==
X-Forwarded-Encrypted: i=1; AJvYcCXHDZpNTlEHuMzsz9xJCzTGkw4n+yiO7OYN94FOCEzP9XCWleCrPK0AZmuWmZDhnj2pby1v8z3Xgw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLGgcc0ZL/0/gRZMaMl9gdCeoSGUuIemdVycvvqQtgj1muUboY
	98OsaektZ8ccUnm68PL2QUUPzWaJ8rJVKP7vcsEZ0YXbB8SLLNbjSD2zbh2WaPo=
X-Gm-Gg: ASbGncuFfTq0PZNOxDwsvsNRtyjKGl4ASdz38sscZIutdR6KyGDg0MK8CmffgxQtljH
	s2+TVpAY1LVlTu4jyVVk2aVy/7xMOSO7NkOAutH3ct99w0s08FTvfBsf8mKgJjDVLMyaa30/QkL
	eoFn+sSZpAc+6H6Uyg+axABaYVDEzfLCPNOkJMqERTk8W1G/bbHfSl4OsW5CmbUEHpXDKepixe/
	NhQrlnEej/V8EYUpDLWxOqljLoMmSaIQA786CAYJ/khasE+FdvzPCdCIRAQD1v1J9CDkNi4jqX5
	PVGRaL+c5N3Ztxjg0066nx+ZQzm2jVHnJ8sIVVDRsDpfkWkk
X-Google-Smtp-Source: AGHT+IGVZrdHtmN3imeO0cx5tz30aOjZahKG91K+HTbrPrK2moeiq4tyuly9hHgwAGYXpEq3Q5AMtA==
X-Received: by 2002:a05:6602:381b:b0:85b:3c49:8811 with SMTP id ca18e2360f4ac-86a08ddbbcfmr713104939f.4.1747259543277;
        Wed, 14 May 2025 14:52:23 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-867636de74fsm291730739f.31.2025.05.14.14.52.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 14:52:22 -0700 (PDT)
Message-ID: <a645a6a2-d722-4ef1-bdfd-3701ab315584@kernel.dk>
Date: Wed, 14 May 2025 15:52:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring: move locking inside overflow posting
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1747209332.git.asml.silence@gmail.com>
 <56fb1f1b3977ae5eec732bd5d39635b69a056b3e.1747209332.git.asml.silence@gmail.com>
 <d6634082-86c0-4393-b270-ede60397695e@kernel.dk>
 <d63f55e8-7453-46fb-a85a-03e6de14402f@gmail.com>
 <6097e834-29a4-4e49-9c62-758e5b1a3884@kernel.dk>
 <a788a22f-0efd-4b78-94b5-c096b38c0e6c@gmail.com>
 <1644225f-36c9-4abf-8da3-cc853cdab0e8@kernel.dk>
Content-Language: en-US
In-Reply-To: <1644225f-36c9-4abf-8da3-cc853cdab0e8@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Since sometimes it's easier to talk in code that in English, something
like the below (just applied on top, and utterly untested) I think is
much cleaner. Didn't spend a lot of time on it, I'm sure it could get
condensed down some more with a helper or something. But it keeps the
locking in the caller, while still allowing GFP_KERNEL alloc for
lockless_cq.

Somewhat unrelated, but also fills in an io_cqe and passes in for the
non-cqe32 parts, just for readability's sake.


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index da1075b66a87..9b6d09633a29 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -744,44 +744,12 @@ static bool __io_cqring_event_overflow(struct io_ring_ctx *ctx,
 	return true;
 }
 
-static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, bool locked,
-				     u64 user_data, s32 res, u32 cflags,
-				     u64 extra1, u64 extra2)
+static void io_cqring_event_overflow(struct io_ring_ctx *ctx,
+				     struct io_overflow_cqe *ocqe)
 {
-	struct io_overflow_cqe *ocqe;
-	size_t ocq_size = sizeof(struct io_overflow_cqe);
-	bool is_cqe32 = (ctx->flags & IORING_SETUP_CQE32);
-	gfp_t gfp = GFP_KERNEL_ACCOUNT;
-	bool queued;
-
-	io_lockdep_assert_cq_locked(ctx);
-
-	if (is_cqe32)
-		ocq_size += sizeof(struct io_uring_cqe);
-	if (locked)
-		gfp = GFP_ATOMIC | __GFP_ACCOUNT;
-
-	ocqe = kmalloc(ocq_size, gfp);
-	trace_io_uring_cqe_overflow(ctx, user_data, res, cflags, ocqe);
-
-	if (ocqe) {
-		ocqe->cqe.user_data = user_data;
-		ocqe->cqe.res = res;
-		ocqe->cqe.flags = cflags;
-		if (is_cqe32) {
-			ocqe->cqe.big_cqe[0] = extra1;
-			ocqe->cqe.big_cqe[1] = extra2;
-		}
-	}
-
-	if (locked) {
-		queued = __io_cqring_event_overflow(ctx, ocqe);
-	} else {
-		spin_lock(&ctx->completion_lock);
-		queued = __io_cqring_event_overflow(ctx, ocqe);
-		spin_unlock(&ctx->completion_lock);
-	}
-	return queued;
+	spin_lock(&ctx->completion_lock);
+	__io_cqring_event_overflow(ctx, ocqe);
+	spin_unlock(&ctx->completion_lock);
 }
 
 /*
@@ -842,15 +810,49 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 	return false;
 }
 
+static struct io_overflow_cqe *io_get_ocqe(struct io_ring_ctx *ctx,
+					   struct io_cqe *cqe, u64 extra1,
+					   u64 extra2, gfp_t gfp)
+{
+	size_t ocq_size = sizeof(struct io_overflow_cqe);
+	bool is_cqe32 = ctx->flags & IORING_SETUP_CQE32;
+	struct io_overflow_cqe *ocqe;
+
+	if (is_cqe32)
+		ocq_size += sizeof(struct io_uring_cqe);
+
+	ocqe = kmalloc(ocq_size, gfp);
+	trace_io_uring_cqe_overflow(ctx, cqe->user_data, cqe->res, cqe->flags, ocqe);
+	if (ocqe) {
+		ocqe->cqe.user_data = cqe->user_data;
+		ocqe->cqe.res = cqe->res;
+		ocqe->cqe.flags = cqe->flags;
+		if (is_cqe32) {
+			ocqe->cqe.big_cqe[0] = extra1;
+			ocqe->cqe.big_cqe[1] = extra2;
+		}
+	}
+
+	return ocqe;
+}
+
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 {
 	bool filled;
 
 	io_cq_lock(ctx);
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
-	if (!filled)
-		filled = io_cqring_event_overflow(ctx, true,
-						  user_data, res, cflags, 0, 0);
+	if (unlikely(!filled)) {
+		struct io_cqe cqe = {
+			.user_data	= user_data,
+			.res		= res,
+			.flags		= cflags
+		};
+		struct io_overflow_cqe *ocqe;
+
+		ocqe = io_get_ocqe(ctx, &cqe, 0, 0, GFP_ATOMIC);
+		filled = __io_cqring_event_overflow(ctx, ocqe);
+	}
 	io_cq_unlock_post(ctx);
 	return filled;
 }
@@ -864,8 +866,17 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 	lockdep_assert_held(&ctx->uring_lock);
 	lockdep_assert(ctx->lockless_cq);
 
-	if (!io_fill_cqe_aux(ctx, user_data, res, cflags))
-		io_cqring_event_overflow(ctx, false, user_data, res, cflags, 0, 0);
+	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
+		struct io_cqe cqe = {
+			.user_data	= user_data,
+			.res		= res,
+			.flags		= cflags
+		};
+		struct io_overflow_cqe *ocqe;
+
+		ocqe = io_get_ocqe(ctx, &cqe, 0, 0, GFP_KERNEL);
+		io_cqring_event_overflow(ctx, ocqe);
+	}
 
 	ctx->submit_state.cq_flush = true;
 }
@@ -1437,6 +1448,20 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 	} while (node);
 }
 
+static __cold void io_cqe_overflow_fill(struct io_ring_ctx *ctx,
+					struct io_kiocb *req)
+{
+	gfp_t gfp = ctx->lockless_cq ? GFP_KERNEL : GFP_ATOMIC;
+	struct io_overflow_cqe *ocqe;
+
+	ocqe = io_get_ocqe(ctx, &req->cqe, req->big_cqe.extra1, req->big_cqe.extra2, gfp);
+	if (ctx->lockless_cq)
+		io_cqring_event_overflow(ctx, ocqe);
+	else
+		__io_cqring_event_overflow(ctx, ocqe);
+	memset(&req->big_cqe, 0, sizeof(req->big_cqe));
+}
+
 void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
@@ -1453,17 +1478,10 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		 * will go through the io-wq retry machinery and post one
 		 * later.
 		 */
-		if (!(req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE)) &&
-		    unlikely(!io_fill_cqe_req(ctx, req))) {
-			bool locked = !ctx->lockless_cq;
-
-			io_cqring_event_overflow(req->ctx, locked,
-						req->cqe.user_data,
-						req->cqe.res, req->cqe.flags,
-						req->big_cqe.extra1,
-						req->big_cqe.extra2);
-			memset(&req->big_cqe, 0, sizeof(req->big_cqe));
-		}
+		if (req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE))
+			continue;
+		if (unlikely(!io_fill_cqe_req(ctx, req)))
+			io_cqe_overflow_fill(ctx, req);
 	}
 	__io_cq_unlock_post(ctx);
 

-- 
Jens Axboe

