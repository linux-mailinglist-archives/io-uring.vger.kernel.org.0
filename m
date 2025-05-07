Return-Path: <io-uring+bounces-7895-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ED207AAEF15
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 01:12:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 183407B5592
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 23:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627CB28E59F;
	Wed,  7 May 2025 23:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NbIGvU6G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A87A1ACEC8
	for <io-uring@vger.kernel.org>; Wed,  7 May 2025 23:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746659515; cv=none; b=JKpbZW9CpVWY3mm+as7RVoYq0QdD1dkSEwCF67LsyfdJFRsuerpsEJClKTjU9vv0kaLu4cpITJYynkv/ELJHaFRDaK7YtunzuCJGPARsfgxQ0QjE0b8VZUBGQAGa+dwdwUe1dpEwZLEy7Xk0PD1dR5TU5FKEfxRaEqc9iUlQd3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746659515; c=relaxed/simple;
	bh=tBTdQPXRWExatOhyyjqYAT1RNWeoQuo3hLZB/ndQyC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cviFxw7E2Ajohjg4+1mbA31FTIZYwi1lpLthkIftaDBNDxED3r9GgybR9RkIwIDYZdDhg1KkCvvwcELomhCF6x34bL/e4Foj/m2506X+PFchzw+1Y+iGu2kQuh6g6eblcuvUrablCv8rjhaDUtad0aGWa6RlwULJgtvVn9iLsyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NbIGvU6G; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3d81768268dso2413925ab.3
        for <io-uring@vger.kernel.org>; Wed, 07 May 2025 16:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746659510; x=1747264310; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MTSY7PSc8f3g/I/A4eqTacoY2ArUlG1NaNX/chZl2g0=;
        b=NbIGvU6G5RnZwBa4zI/LYAupsHQFQfRF9nCadzLXuMVv/3HecjbEtAVU2Ew1MqHzfb
         XlfL9FIfKOgxQPWo8bvQR+tAq/jhJUNmao1SVshF6DLIKWcnt5F81oVmS5PS2XNZSLrC
         dJm+DjA6H6QFLHGf8IPHidg1NV78YKICJDJQR9zVu5LTweUzUVtpQE4FY6ySeEbF+NQg
         8pKAWEtdbQ4IJ9O4G/LU08dibcL91VOgbAr9t+IRzc7YOYlsGKcOk5EwtJ+6W4dXHexe
         rcylbtpd7Zb9a3Gtku9UxP+7XXK1TkA4X1K2aaim5riN9acNLZPXzNXvzLMfvVqMccvG
         14Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746659510; x=1747264310;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MTSY7PSc8f3g/I/A4eqTacoY2ArUlG1NaNX/chZl2g0=;
        b=pyvp/gOjcruCSEgfum0s03O4JM3ONIFCE08l2FwZe68sAy/Hpey5dHLpFvtSaSEyvh
         miG9ZcUWREZvJFxJjoCugEeALsVaBTJmcb0nCH+QY0o9xFXYb1BP8IxHiQEfTETIkfKb
         RQ4uzlr3k5mLSNGDCCcOOaJriwQ2bDKCgJYiJVVPOFIos+g7kyok1nT+iRtWZ9b1JyIh
         8hXlQL6FJ2izb9+EDL/k/H1aN/zs+VSeipIn/Rej28+V6jwPpN5/BX+7usisfodi2yKm
         xASnLqAHUU9wKgsyV8N+KEXO5O1l2IwGfUW7nwlvMANoCTLBz+BqBxQLqjkCJ8yvMGtX
         5STA==
X-Forwarded-Encrypted: i=1; AJvYcCVZaNm/UmU/803qpyBNpNQpiAlBC34D2tGL4q8PJ5x7+sGqvHvNtMNqdMfZ296fNR2CJdyllcZtUA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw58iJSKh49PAGsU0pfJw+rHFxN8KjsK+zEek+dQ4yTHNRKNQ/o
	C2ssiK6lKCJJIxsNDWWQm7ZUaRdBbQVHVO3vu5PRUPv5bZMD6M6V05DwTMUpqN4=
X-Gm-Gg: ASbGnctnwImC003cYLxSbp8Ja47WKooOTM7TaOBa8n3jQaCinyDy5bFUGPHdNf8L9Ss
	7bAUohq4RfDz4oS1sFfulm/k1ysU09vHdq3PVBduqJ5/XloPQKLonfU/1QUbeuxSHn5e0FTTmI/
	HMYV6wV+E2NtZahZx/4DM47DhzK0NutMZEXxDdYK/HCLlIb0+BXkSCPXhMYr5Tweke1JwFYwSG+
	1VvRVNzz0N8QUxmi3tWh7l++1/EtKq6WApyio9+R36FnCxYzIoKsZN+2fjZ5rbc4KknKe9NRRWx
	bgU2tHNGBLIsyG4Bm6ygLd6NAuGw0aw96RA93A==
X-Google-Smtp-Source: AGHT+IHgQfUTYmYSQGkNI0F+1Siw2hVCAwbDp4AlEW03RxkVetSd0bHGu7zqMdyUx2/8MSsxZav/Jg==
X-Received: by 2002:a05:6e02:220b:b0:3d9:66ba:1ad2 with SMTP id e9e14a558f8ab-3da7388855cmr64360245ab.0.1746659510118;
        Wed, 07 May 2025 16:11:50 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88a8d1998sm2894380173.4.2025.05.07.16.11.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 16:11:49 -0700 (PDT)
Message-ID: <d0c88f28-3915-4860-93d7-3a383aff8061@kernel.dk>
Date: Wed, 7 May 2025 17:11:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/poll: use regular CQE posting for multishot
 termination
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <e837d840-4ff7-423a-a7a9-2196a7d44d26@kernel.dk>
 <1711744d-1dd1-4efc-87e2-6ddc1124a95e@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <1711744d-1dd1-4efc-87e2-6ddc1124a95e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/7/25 2:53 PM, Pavel Begunkov wrote:
> On 5/7/25 19:08, Jens Axboe wrote:
>> A previous patch avoided reordering of multiple multishot requests
>> getting their CQEs potentiall reordered when one of them terminates, as
>> that last termination CQE is posted as a deferred completion rather than
>> directly as a CQE. This can reduce the efficiency of the batched
>> posting, hence was not ideal.
>>
>> Provide a basic helper that poll can use for this kind of termination,
>> which does a normal CQE posting rather than a deferred one. With that,
>> the work-around where io_req_post_cqe() needs to flush deferred
>> completions can be removed.
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> This removes the io_req_post_cqe() flushing, and instead puts the honus
>> on the poll side to provide the ordering. I've verified that this also
>> fixes the reported issue. The previous patch can be easily backported to
>> stable, so makes sense to keep that one.
> 
> It still gives a bad feeling tbh, it's not a polling problem,
> we're working around shortcomings of the incremental / bundled
> uapi and/or design. Patching it in semi unrelated places will
> defitely bite back.

I don't think that's fair, we should always strive to have as close to
ordered completions as we can. The fact that multishot ends up using a
mix of both methods to fill CQEs is problematic.

> Can it be fixed in relevant opcodes? So it stays close to
> those who actually use it. And let me ask since I'm lost in
> new features, can the uapi be fixed so that it doesn't
> depend on request ordering?

The API absolutely relies on ordering within a buffer group ID.

It can certainly be fixed at the opcode sites, but there'd be 3 spots in
net and one in rw.c, and for each spot it'd be more involved to fix it.

>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 541e65a1eebf..505959fc2de0 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -848,14 +848,6 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
>>       struct io_ring_ctx *ctx = req->ctx;
>>       bool posted;
>>   -    /*
>> -     * If multishot has already posted deferred completions, ensure that
>> -     * those are flushed first before posting this one. If not, CQEs
>> -     * could get reordered.
>> -     */
>> -    if (!wq_list_empty(&ctx->submit_state.compl_reqs))
>> -        __io_submit_flush_completions(ctx);
>> -
>>       lockdep_assert(!io_wq_current_is_worker());
>>       lockdep_assert_held(&ctx->uring_lock);
>>   @@ -871,6 +863,23 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
>>       return posted;
>>   }
>>   +bool io_req_post_cqe_overflow(struct io_kiocb *req)
> 
> "overflow" here is rather confusing, it could mean lots of things.
> Maybe some *_post_poll_complete for now?

Yeah it's not a great name, just didn't have any better ideas at the
time. I'll ponder a bit, __complete() isn't terrible.

>> +{
>> +    bool filled;
>> +
>> +    filled = io_req_post_cqe(req, req->cqe.res, req->cqe.flags);
> 
> posting and overflow must be under the same CQ critical section,
> like io_cq_lock(). Just copy io_post_aux_cqe() and add
> ctx->cq_extra--? Hopefully we'll remove the cq_extra ugliness
> later and combine them after.

Would be great to combine those, as it stands there's a mix of them, and
io_add_aux_cqe() for example does split locking. I'll update the
locking.

>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>> index 8eb744eb9f4c..af8e3d4f6f1f 100644
>> --- a/io_uring/poll.c
>> +++ b/io_uring/poll.c
>> @@ -312,6 +312,13 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
>>       return IOU_POLL_NO_ACTION;
>>   }
>>   +static void io_poll_req_complete(struct io_kiocb *req, io_tw_token_t tw)
>> +{
>> +    if (io_req_post_cqe_overflow(req))
>> +        req->flags |= REQ_F_CQE_SKIP;
> 
> Unconditional would be better. It'd still end up in attempting
> to post, likely failing and reattemptng allocation just one
> extra time, not like it gives any reliability. And if I'd be
> choosing b/w dropping a completion or potentially getting a
> botched completion as per the problem you tried, I say the
> former is better.

Not sure I follow, unconditional what? SKIP? Yes that probably makes
sense, if we don't overflow post, it'll get logged as such anyway.

-- 
Jens Axboe

