Return-Path: <io-uring+bounces-4263-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B706D9B7B7D
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 14:15:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D67A81C20A3E
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 13:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65B58335C7;
	Thu, 31 Oct 2024 13:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I/P3I8Ek"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DE32110E;
	Thu, 31 Oct 2024 13:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730380555; cv=none; b=BTMWMWQdTs5E/YfTTah9zmbX449XkLQEhwCDgdGgW4eLFNBfToA9V6dvPT5tGJpcB5bFiSEYsxpPBioD2tZTbZhZcJzZYiW6Goj/VipgZavKa+Y3Go8i5ooTK+YI/i4uvVvOYMmyU+x2B4qnWL6uRrf6Y8XS2V0bbKwD4pAIV5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730380555; c=relaxed/simple;
	bh=QB1dVRAjPUEP46AgiFMsdRLzFiNY29a/v0t1LgeESSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LuYQunYYWzC5H6mlgF0JManZIAtSatXN/vN3I4JhOgkloNDlcfjAADueph+SSduRB3AneHjcpkrpfF87GjwgfkMXxJw+6rqGl07kTURl2KgihptobNbxfhD3mOYmuZCAKh7e2j1K9zj/MCRt/Mzxa/h+E7ntxoh8hc2fYdMGXaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I/P3I8Ek; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a9a6acac4c3so156706866b.0;
        Thu, 31 Oct 2024 06:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730380551; x=1730985351; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x5Rp171ur2qBp6R+ZP9fqVxwfqxuN4wh6/5DBCZdG0E=;
        b=I/P3I8EkBOPspqKd8/n+kyI6dG+quZzHbrKbhF8f54AAdftUdmgEkUQhzu2IF/zTRI
         z1z9NfojTcaD6jKx2RTD5eI1fd4XuPKca/Dj6RWvyYqGjr9untKVZa18laf1CsulECIQ
         a8id/hcfc3Ky9VZmAfzSkOV/ZiPeMEz8w9hBIllwSKs8OjYQRWvjyMTJhL0Yjcv2JE8D
         uo6gX5+v2PRrR0sqURu9KwTYvX0owEsF6b7AwmJCOD1HsSD5LdG5LrL4sSKHxrjY+lpO
         pUyc40nJGtqepJ4Suz+4R/viEoBYb/ci8GLvUyWucfFDuarmQr39UUYhQjL3ckayZaz+
         JDQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730380551; x=1730985351;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x5Rp171ur2qBp6R+ZP9fqVxwfqxuN4wh6/5DBCZdG0E=;
        b=qfPSPh5HwzIADIikOHexjrnZGWJ7thh0MRi8GX/UeE8b9Tn5unErQRIvCt26RQGWzB
         rc9Sls/yCjfOmDzKs4o8tod6C7OPLU6NLw8NWhcuGmXqiRvT2QYEIwAzgqBFtNl4Ql8G
         EAxcf6B9CENLflROv8FEnMjLmlOflsdFpChCEZAOqjG+mIkoPHYxjTteYzDHdxt9+hVc
         1gpkuqIeppatpl+yRblKALg/2mwayAtBXeRQ7JVFcmDA9IS3aCi16UJpJgnecFGlBzKl
         FOcjNDbeZvR4sR3yAjHg4S7MeYV8iyLcDY63W02LFs6mQg0oP7IJeDNImksICjat6Thn
         sWrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUiR6wq+mJbqZnJpT+IZysv/g5erU0kD2EhH1Wc+ioHt1bW2uCneQj5AxPP4PqnuZftyuN+NsgQwg==@vger.kernel.org, AJvYcCViNteNcuCKnk3FF1bn6Qs3eCmJWIzeXZWrIXCaM4ZpIz+CQ1C2XNKaWZK0Je/2B1L+HuFxwqhT43T5ppA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMQW9e6Pwr4HhKVHJSSuBqfxnuxdK9Rt4S16W924DxeZg5Zr4B
	DpXIwa8kaUEhhX3X6O5pvsO5KiZ8Wks6s4akq3fKj4Bb/PaIlDhl
X-Google-Smtp-Source: AGHT+IGD1+GYCdz+upgTCOKu7pby1kpTJ8wNK4thqJJXsV8HBr4bK/sWIc5PYax6B4WIBydZZMhAOg==
X-Received: by 2002:a17:907:e88:b0:a99:7676:ceb7 with SMTP id a640c23a62f3a-a9de5f49bf7mr1862329566b.26.1730380551164;
        Thu, 31 Oct 2024 06:15:51 -0700 (PDT)
Received: from [192.168.42.141] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e5649454csm68357566b.8.2024.10.31.06.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 06:15:50 -0700 (PDT)
Message-ID: <40107636-651f-47ea-8086-58953351c462@gmail.com>
Date: Thu, 31 Oct 2024 13:16:07 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 5/7] io_uring: support leased group buffer with
 REQ_F_GROUP_KBUF
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <20241025122247.3709133-6-ming.lei@redhat.com>
 <4576f723-5694-40b5-a656-abd1c8d05d62@gmail.com> <ZyGBlWUt02xJRQii@fedora>
 <bbf2612e-e029-460f-91cf-e1b00de3e656@gmail.com> <ZyGURQ-LgIY9DOmh@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZyGURQ-LgIY9DOmh@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/24 02:04, Ming Lei wrote:
> On Wed, Oct 30, 2024 at 01:25:33AM +0000, Pavel Begunkov wrote:
>> On 10/30/24 00:45, Ming Lei wrote:
>>> On Tue, Oct 29, 2024 at 04:47:59PM +0000, Pavel Begunkov wrote:
>>>> On 10/25/24 13:22, Ming Lei wrote:
>>>> ...
>>>>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>>>>> index 4bc0d762627d..5a2025d48804 100644
>>>>> --- a/io_uring/rw.c
>>>>> +++ b/io_uring/rw.c
>>>>> @@ -245,7 +245,8 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
>>>>>     	if (io_rw_alloc_async(req))
>>>>>     		return -ENOMEM;
>>>>> -	if (!do_import || io_do_buffer_select(req))
>>>>> +	if (!do_import || io_do_buffer_select(req) ||
>>>>> +	    io_use_leased_grp_kbuf(req))
>>>>>     		return 0;
>>>>>     	rw = req->async_data;
>>>>> @@ -489,6 +490,11 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
>>>>>     		}
>>>>>     		req_set_fail(req);
>>>>>     		req->cqe.res = res;
>>>>> +		if (io_use_leased_grp_kbuf(req)) {
>>>>
>>>> That's what I'm talking about, we're pushing more and
>>>> into the generic paths (or patching every single hot opcode
>>>> there is). You said it's fine for ublk the way it was, i.e.
>>>> without tracking, so let's then pretend it's a ublk specific
>>>> feature, kill that addition and settle at that if that's the
>>>> way to go.
>>>
>>> As I mentioned before, it isn't ublk specific, zeroing is required
>>> because the buffer is kernel buffer, that is all. Any other approach
>>> needs this kind of handling too. The coming fuse zc need it.
>>>
>>> And it can't be done in driver side, because driver has no idea how
>>> to consume the kernel buffer.
>>>
>>> Also it is only required in case of short read/recv, and it isn't
>>> hot path, not mention it is just one check on request flag.
>>
>> I agree, it's not hot, it's a failure path, and the recv side
>> is of medium hotness, but the main concern is that the feature
>> is too actively leaking into other requests.
>   
> The point is that if you'd like to support kernel buffer. If yes, this
> kind of change can't be avoided.

There is no guarantee with the patchset that there will be any IO done
with that buffer, e.g. place a nop into the group, and even then you
have offsets and length, so it's not clear what the zeroying is supposed
to achieve. Either the buffer comes fully "initialised", i.e. free of
kernel private data, or we need to track what parts of the buffer were
used.

-- 
Pavel Begunkov

