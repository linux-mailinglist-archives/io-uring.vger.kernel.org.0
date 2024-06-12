Return-Path: <io-uring+bounces-2175-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A4424905295
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 14:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 507461F21B18
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 12:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8123C16FF55;
	Wed, 12 Jun 2024 12:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UZggQePO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA1F16D4F6;
	Wed, 12 Jun 2024 12:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718195746; cv=none; b=Qfe9cwXYoEagCSjv5YA1mphPw+Cm4G7bIBLVfu9zlivVztc13xRZv+9gOs8exSAzHLHzNJW3HRXv5DtImUvlLWVwH/lGWYdEkSoJOKaJksSpj+Efot0Ni+lkBTuCGLv3BqY7zH1Y319wd9VZqcgWcvACD1mXDY/y93EkHtrTm3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718195746; c=relaxed/simple;
	bh=75aY26XuMuHZAMH1H77DDXsruluFV5/Q1HkpU9UlInU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WlxjkKPb1Zznz0/5GlmXrvOgwjjK0WSt+O/LyS+lwVkgigfcx5J7drK1DUSvbdu76UiaCDoY7pUXXLNQXiWWSVp25pM7rEmupl0lACn5386K6NzU7fxyDEXSTi3EYBUvCJabAJ9AxlPNpO1YOoGejVgSIPKmzzVn1ze/dAiowGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UZggQePO; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-57c72d6d5f3so5267067a12.1;
        Wed, 12 Jun 2024 05:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718195743; x=1718800543; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KRmihzRKsZKPXkmImPA2PJdwqrzPV0j1SUb1OGAaqoc=;
        b=UZggQePODzwNyl/i3peyhVVQa8LCk5pnQ+TK46s5ck7aHiM7g/Do3msJrhS3pKtO3E
         79lGyPQxLUjj3YrNcgT9vcTaA8vpJloTWPSlmN37mRGgSOwsXdU45XETcPsn+9wys5NV
         oyQV8C74Qlk2VfgNO/omr8pBgEYUYgiVjWMQvz4uHTt7EoE+ATUnIR2o5w5WE3b5uQTi
         9Tqn06t1g31slmlDPiXEjlDxY1yuzgoYSGm4b9F2SLrK5Fm90/xqXEA00cKZBKyvr51R
         xb+CljHeZNnq+erIZVjHZAbW5o2sD7jJx1QTuAwbN5L1YhQQnLCkdD0euc7kmlsKt1hX
         Y5vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718195743; x=1718800543;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KRmihzRKsZKPXkmImPA2PJdwqrzPV0j1SUb1OGAaqoc=;
        b=ZOJe2vJVgNTxzETN5WHzNoEMCfgeXMeYqqZldYkIcIQqa97sMAEVoptsemHJXF5x4T
         hIzjtUC45vdDX9l/LmQATO93U/tMxqv2chYQbiGIP9pWdWxmg/a3Qrckc0gGR/cEmPMW
         P9puwze6hIK2sSAhtIPMZe5nMcV1PNT49VLUZDmE+bNcpvNHlLNe4htt2T5PmqSABtV3
         ZSJmdyqJ8sZ7NbqvqVhpkhIDXiNcyYsDnhhDRZ33iiDzzjQpqJIazRaLgvqWNlpdE7FC
         yKC+BXHMew3OrdwgSwYpA7WT3unkqEOJTCqMXmaMHMoehNljcMVuqG08IJeGwx52j324
         dzXA==
X-Forwarded-Encrypted: i=1; AJvYcCWm5VJXA1Y+7lj78ak71ZzvCSmyhS7bzxXkFLGTwDg/kjds08pDZBPhQSPOiiWAK462XwO5CC4z6cWD3PcvYRZ2IshFZ8YdQR5MJEEDirmnhyLVUyM6xmIG2ITgkXFMyKdn15puqaM=
X-Gm-Message-State: AOJu0YxYVcXw2RKAWF6Oyo8UUEnXhf63YGwZ/jEhBwUcgIfRWa6RpzKU
	/KGYMSbfwAzE7a9sW1lqqVgIQocjMT1WtDGc9MmNYB5vHL2Vx+9qPF1iCg==
X-Google-Smtp-Source: AGHT+IGD0yDtfu7JBxBoQrITgVlvHEvwGIrCaQ0jIW2iRXWNcl1eNmoadDqoSgoNRaVbxiE6xRrYPg==
X-Received: by 2002:a17:906:355b:b0:a6f:4e02:ce55 with SMTP id a640c23a62f3a-a6f4e0323e1mr31088866b.53.1718195742741;
        Wed, 12 Jun 2024 05:35:42 -0700 (PDT)
Received: from [192.168.42.244] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6c8072a101sm879776266b.201.2024.06.12.05.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 05:35:42 -0700 (PDT)
Message-ID: <6213cf3d-b114-4c27-b9c5-6339b9f363aa@gmail.com>
Date: Wed, 12 Jun 2024 13:35:50 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [io-uring] WARNING in io_fill_cqe_req_aux
To: chase xd <sl1589472800@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CADZouDQx4tqCfCfmCHjUp9nhAJ8_qTX=cCYOFzMYiQQwtsNuag@mail.gmail.com>
 <4fd9cd27-487d-4a23-b17a-aa9dcb09075f@gmail.com>
 <CADZouDSyJVR=WX-X46QCUZeUz=7DHg_9=e5y=N7Wb+zMQ_dGtQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADZouDSyJVR=WX-X46QCUZeUz=7DHg_9=e5y=N7Wb+zMQ_dGtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/24 08:10, chase xd wrote:
> Sorry now I'm also a bit confused by the branch choosing. I checked
> out branch "for-6.9/io_uring" and started testing on that branch. I
> assume that was the latest version of io_uring at that time, even now
> I check out that branch and the bug still exists. How should I know
> whether the branch will be merged, and which branch do you think I
> should test on? Thanks.

# git show a69d20885494:io_uring/io_uring.c | grep -A 13 io_fill_cqe_req_aux
bool io_fill_cqe_req_aux(struct io_kiocb *req, bool defer, s32 res, u32 cflags)
{
         struct io_ring_ctx *ctx = req->ctx;
         u64 user_data = req->cqe.user_data;

         if (!defer)
                 return __io_post_aux_cqe(ctx, user_data, res, cflags, false);

         lockdep_assert_held(&ctx->uring_lock);
         io_lockdep_assert_cq_locked(ctx);

         ctx->submit_state.flush_cqes = true;
         return io_fill_cqe_aux(ctx, user_data, res, cflags);
}

That's the buggy version from the hash you're testing, IIRC it
was in the tree for longer than necessary, presumably which is
why you found it, but it was never sent to Linus. Below is
current state of for-6.9 and what it was replaced with
respectively. Let me separately check for-6.9/io_uring if you're
concerned about it.




# git show for-6.9/io_uring:io_uring/io_uring.c | grep -A 30 io_fill_cqe_req_aux
bool io_fill_cqe_req_aux(struct io_kiocb *req, bool defer, s32 res, u32 cflags)
{
         struct io_ring_ctx *ctx = req->ctx;
         u64 user_data = req->cqe.user_data;
         struct io_uring_cqe *cqe;

         lockdep_assert(!io_wq_current_is_worker());

         if (!defer)
                 return __io_post_aux_cqe(ctx, user_data, res, cflags, false);

         lockdep_assert_held(&ctx->uring_lock);

         if (ctx->submit_state.cqes_count == ARRAY_SIZE(ctx->completion_cqes)) {
...

# git show origin/for-6.10/io_uring:io_uring/io_uring.c | grep -A 13 io_req_post_cqe
bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
{
         struct io_ring_ctx *ctx = req->ctx;
         bool posted;

         lockdep_assert(!io_wq_current_is_worker());
         lockdep_assert_held(&ctx->uring_lock);

         __io_cq_lock(ctx);
         posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
         ctx->submit_state.cq_flush = true;
         __io_cq_unlock_post(ctx);
         return posted;
}

-- 
Pavel Begunkov

