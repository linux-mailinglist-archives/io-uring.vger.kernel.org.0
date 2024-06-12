Return-Path: <io-uring+bounces-2181-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0540905430
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 15:52:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 399A0285435
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 13:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB98517D896;
	Wed, 12 Jun 2024 13:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GfKfh0B1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCF317DE34;
	Wed, 12 Jun 2024 13:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718200349; cv=none; b=GCdf6RXvQKn4dRzVGRIVUGzueL/3BK4tJMrRtnGM4KjsYRj+tr7jJ9+584+m9J4926B/0dRlCZjCg35x6deIObpq1d7gUnMxZKwc+oZeNoiFr/GxkxJJYAupdTzJPpVZsEkPDIHivivEAmC7hFuoh85m6ZdGv/0AyYvcxN147qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718200349; c=relaxed/simple;
	bh=UqMzqbXKOkO76fD/Q0Ho9aIFw47zcnwUeK/a7nuXcys=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=bBlXBX1OblPMh7FMjunwaLXt1KCNdUIEPNSkxyD6StZlookqS8pirPVXOlJHZQXPb9DS6nVTktxoevKL9hlVm+lll5XD37ORnJOUj7MjjjS184ru4nJS1sxHoRKm7HqsYO7WnhZFRjqGHjcVcYTGMsjcNWRgZWPg+6yDkzFNXLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GfKfh0B1; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a6e349c0f2bso685678566b.2;
        Wed, 12 Jun 2024 06:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718200346; x=1718805146; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2bc6XZQC+pu8/aGiFTyN2/kmoeF3F+5LCRlKYM1dDFw=;
        b=GfKfh0B1RI9idRtXh/NWHf5qqx43k14hmVSO92Ai928hkYrXN7Qm5Rg/kEJZU2kCe+
         4paKLy5A4dDPG1nZqMhdy+U5560l1ibGFNKa9OJZuab2vmpWWVj7TChk0nyXItSb+oQR
         HSg415xweozuWB27+GMHMMhq1BMk0VTPtg2WvgqrsMPmqC8ADs2XzZphoTxtlNQ/vR2I
         oBiZVi54hq1txaKIAZBAaaovgL2gi8bILUuBVFu/D8L0viT/ijP3RmQApyCHiHyySGsN
         bsGjl8UeMp7FuLPRXigAetnRWIdPH72hw9oZhTawBKnp9T2fkixLoMv06t92a3X9umMo
         0LAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718200346; x=1718805146;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2bc6XZQC+pu8/aGiFTyN2/kmoeF3F+5LCRlKYM1dDFw=;
        b=HeZBKoCmNFYQZWjeChXvM7WhbO+QL9QSlnpYb+ENvV1B8uoHqPRjJqi2D9GeF5xwf4
         PzC22zG9tcIL7xXNMOz7IIF61T4rh2yLiWyliotUd36xp7scv8QgZYWhzGePIswLp+Pu
         b3LnNeDKBfhU84561/tT2sWOasiDynEXN+hTUW3i6t5QcJjb01ydXTpNy49kZ8nlKqYy
         2W2aZuX0GJxWSCvZXBHX8uvgz2WaJFqGuj4GMc721aDAoHRyH6eJvNsNjkapB9jYEecS
         XGTnFpXwd1AQTxGT3vQ1D8DsxBXm+jgcdbT4ABA2psZ6XP7YxaWtcdyY7CrGM3hG60R8
         ppCw==
X-Forwarded-Encrypted: i=1; AJvYcCVFS6c0LFOT73p+asa2F7BIY6CT/P3efBlEXmcA2L9sc5YQtvCLkMm7jIBbtiMWGGt6Ca+Q7f/pJwNGOncKHBk/1nV/SMPdjwaw6epzvefifR9bkzzNt3X5nKMwKLYCM9VZOsrV+Os=
X-Gm-Message-State: AOJu0YxGXVQ388FMKTUYjg2KrUKS98WHdA4311WNohq/2EWEU0BgEWZl
	D0OaWeDnuP26Ld0YUQxxC5WAytXEgT0zf8Bssd7P+AHAVLtHYMHX
X-Google-Smtp-Source: AGHT+IH4+PnjnbHt0mgvZsrG7K9UPD2r6mRESXcYAmGipdFzcoLKhlQxEtiFTEiuyrSjX5dge4cgog==
X-Received: by 2002:a17:907:2d21:b0:a6f:147f:7d06 with SMTP id a640c23a62f3a-a6f480288d6mr123721566b.77.1718200346217;
        Wed, 12 Jun 2024 06:52:26 -0700 (PDT)
Received: from [192.168.42.148] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f0b5371d2sm574318766b.39.2024.06.12.06.52.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 06:52:25 -0700 (PDT)
Message-ID: <8431d920-ab84-447d-84fc-eb7904b1c733@gmail.com>
Date: Wed, 12 Jun 2024 14:52:34 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [io-uring] WARNING in io_fill_cqe_req_aux
From: Pavel Begunkov <asml.silence@gmail.com>
To: chase xd <sl1589472800@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CADZouDQx4tqCfCfmCHjUp9nhAJ8_qTX=cCYOFzMYiQQwtsNuag@mail.gmail.com>
 <4fd9cd27-487d-4a23-b17a-aa9dcb09075f@gmail.com>
 <CADZouDSyJVR=WX-X46QCUZeUz=7DHg_9=e5y=N7Wb+zMQ_dGtQ@mail.gmail.com>
 <6213cf3d-b114-4c27-b9c5-6339b9f363aa@gmail.com>
Content-Language: en-US
In-Reply-To: <6213cf3d-b114-4c27-b9c5-6339b9f363aa@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/24 13:35, Pavel Begunkov wrote:
> On 6/12/24 08:10, chase xd wrote:
>> Sorry now I'm also a bit confused by the branch choosing. I checked
>> out branch "for-6.9/io_uring" and started testing on that branch. I
>> assume that was the latest version of io_uring at that time, even now
>> I check out that branch and the bug still exists. How should I know
>> whether the branch will be merged, and which branch do you think I
>> should test on? Thanks.
> 
> # git show a69d20885494:io_uring/io_uring.c | grep -A 13 io_fill_cqe_req_aux
> bool io_fill_cqe_req_aux(struct io_kiocb *req, bool defer, s32 res, u32 cflags)
> {
>          struct io_ring_ctx *ctx = req->ctx;
>          u64 user_data = req->cqe.user_data;
> 
>          if (!defer)
>                  return __io_post_aux_cqe(ctx, user_data, res, cflags, false);
> 
>          lockdep_assert_held(&ctx->uring_lock);
>          io_lockdep_assert_cq_locked(ctx);
> 
>          ctx->submit_state.flush_cqes = true;
>          return io_fill_cqe_aux(ctx, user_data, res, cflags);
> }
> 
> That's the buggy version from the hash you're testing, IIRC it
> was in the tree for longer than necessary, presumably which is
> why you found it, but it was never sent to Linus. Below is
> current state of for-6.9 and what it was replaced with
> respectively. Let me separately check for-6.9/io_uring if you're
> concerned about it.

In other words, it happens that bugs appear in the branches
but get rooted out before it gets anywhere. The main confusion
is that the version you're looking at was fixed up back somewhere
in March. That's fine, I'd just recommend fetch the repo and
update your base.

I can't hit the problem with for-6.9/io_uring, which make sense
because it's lacking the patch I'd blame it to. I'm confused
how you see it there.


> # git show for-6.9/io_uring:io_uring/io_uring.c | grep -A 30 io_fill_cqe_req_aux
> bool io_fill_cqe_req_aux(struct io_kiocb *req, bool defer, s32 res, u32 cflags)
> {
>          struct io_ring_ctx *ctx = req->ctx;
>          u64 user_data = req->cqe.user_data;
>          struct io_uring_cqe *cqe;
> 
>          lockdep_assert(!io_wq_current_is_worker());
> 
>          if (!defer)
>                  return __io_post_aux_cqe(ctx, user_data, res, cflags, false);
> 
>          lockdep_assert_held(&ctx->uring_lock);
> 
>          if (ctx->submit_state.cqes_count == ARRAY_SIZE(ctx->completion_cqes)) {
> ...
> 
> # git show origin/for-6.10/io_uring:io_uring/io_uring.c | grep -A 13 io_req_post_cqe
> bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
> {
>          struct io_ring_ctx *ctx = req->ctx;
>          bool posted;
> 
>          lockdep_assert(!io_wq_current_is_worker());
>          lockdep_assert_held(&ctx->uring_lock);
> 
>          __io_cq_lock(ctx);
>          posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
>          ctx->submit_state.cq_flush = true;
>          __io_cq_unlock_post(ctx);
>          return posted;
> }
> 

-- 
Pavel Begunkov

