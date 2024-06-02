Return-Path: <io-uring+bounces-2072-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83B888D766F
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 16:49:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2709B2826DB
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 14:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A0B219E7;
	Sun,  2 Jun 2024 14:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="H+ixJDwD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3247543AA3
	for <io-uring@vger.kernel.org>; Sun,  2 Jun 2024 14:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717339763; cv=none; b=dKEcm11Ct69bqFNtbMV/Iqbln5jnYF1L/1KVJZ5thceHnyvGpnf7g4vjbhmvpZTw07roOiPP3D7I1pMpcAqzSB7Nz3bcI1QEJ7J45B7DyashFrWhmoK36TXSsrI4pHQ9BhLyQWOZB64OaKaO3JmxeM04zKXNZKZ1mLDZCmkk1mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717339763; c=relaxed/simple;
	bh=X1ysY1fl8w4n8UIyGUfHP3/8dLqgH/REqLKL8d2iEBw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YWM5BtjfxPxnJ4rKoPLCxJtmOeUE7rcsMfHuhf1r145swCnhoZ9NUH2FkSpDbc/52/7+BcClMMFB5I7d+cmMUjHoeOiuP/13x4l09QXKl+u/qa30Vo/LmdmsmCdDNotNU8jhQzDlvWkdu+lNA70bTLqcc4e8BqfGtT3XjLitITk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=H+ixJDwD; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5b3364995b4so586778eaf.0
        for <io-uring@vger.kernel.org>; Sun, 02 Jun 2024 07:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717339758; x=1717944558; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yr2qvHkl2o9C/hV5YcATVDSeA3UBC+4aN42jXOFySR4=;
        b=H+ixJDwDQbcaxcaGAVNH+tUjfZmNjmpCe/C8vD+g2LWGPAARrsrTGgnUiOuoEMLthF
         pUaFIaVBdhnESOY58W7NmgHdfapb475kI6h99xAXDGDT7I+/lVTV2MpXPHl5kYMpuQFC
         G6FHiyj/DZS8brtMgSDDfAlK8qan57j75ucrooQmkjyxx2i4U1oi4VSaWv+8c1rtSwmS
         zeRDQp0oQwnELWgBhjlba693HhZZbv6Ys4UsFt6PAOUf33JOpcjiDtQXymwlWyUNDYl6
         0oN8/s6r7aZKJDc720UwAoOG1E6ND9Unh6+L3HjOJF+fsm53SfWsKFmF5azu8SoC12ir
         3SZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717339758; x=1717944558;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yr2qvHkl2o9C/hV5YcATVDSeA3UBC+4aN42jXOFySR4=;
        b=WUc9FrKZGVWhFY6oU769vPMJkxjczsF20OZhsodlSrzAp53i60x/Mmge99CxW8efYH
         M4j4BIRXD1xb9l291yowlGncjlE31uK/uaSKXBm/yNMBSsLhz4D/TjJRGmfM/faIZ2uQ
         qA9Tzl+sDzFgg+vAVinm+kQBpEjgAJeOOUpoGGldM6lNkuzdwSbTeffmFnWFedCtuR1O
         YodTslJn5fd7KnTBTJaZRfbUFtvA7yVZRCIS3MPFPENZZuX6gdM2NcrgPoZuUzaCAwYr
         cHYIEFHHA8t89w3p+0E3tHfwGBxu6mXNZqqBycDA5Utsns6hWg1RvQdIINhrHBfbiHbY
         JNJw==
X-Forwarded-Encrypted: i=1; AJvYcCWgGK6QfXkOHoBl+WwncoCWl/RAjeSZEDGjQm5gnBKVcocR+wptoHe65mjjIhpKgkjo1V1/V8vM+nlqXqSXwJoUU8MOK3vrhFo=
X-Gm-Message-State: AOJu0YyCE869bboY7g+j3wbcYWj1nbkU8Ea6oLY2l2FulRHh1K5WXg/T
	wT+INq7yxFIu6C8qow+wbzoDF/fcoq9zTmzi/3zwwOpSPgBE3Y8VGkqPRafcL0K/nHAuIXFqV5c
	L
X-Google-Smtp-Source: AGHT+IHEEXfAqWoSqXAdAvad/TfRqy26ImxjVlmyCodZKLobq0TxFXXUsw0bw+GTF4KIacuX5d33Ag==
X-Received: by 2002:a05:6358:5284:b0:199:2ca6:a10f with SMTP id e5c5f4694b2df-19b48d50182mr774878855d.1.1717339757601;
        Sun, 02 Jun 2024 07:49:17 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6cb90510a45sm753800a12.29.2024.06.02.07.49.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jun 2024 07:49:16 -0700 (PDT)
Message-ID: <70ac49de-f753-486f-b68e-60f08c652195@kernel.dk>
Date: Sun, 2 Jun 2024 08:49:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: madvise/fadvise 32-bit length
To: Stefan <source@s.muenzel.net>, io-uring@vger.kernel.org
References: <bc92a2fa-4400-4c3a-8766-c2e346113ea7@s.muenzel.net>
 <db4d32d6-cc71-4903-92cf-b1867b8c7d12@kernel.dk>
 <2d4d3434-401c-42c2-b450-40dec4689797@kernel.dk>
 <c9059b69-96d0-45e6-8d05-e44298d7548e@s.muenzel.net>
 <d6e2f493-87ca-4203-8d23-2ced10d47d02@kernel.dk>
 <8b08398d-a66d-42ad-a776-78b52d5231c4@s.muenzel.net>
 <c6c149ac-ce0e-4c21-b235-03b5d8250d86@kernel.dk>
 <b7fd035e-6ec2-4482-93e9-acb7436ca07e@s.muenzel.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b7fd035e-6ec2-4482-93e9-acb7436ca07e@s.muenzel.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/2/24 2:58 AM, Stefan wrote:
> On 1/6/2024 20:33, Jens Axboe wrote:
>> On 6/1/24 9:51 AM, Stefan wrote:
>>> On 1/6/2024 17:35, Jens Axboe wrote:
>>>> On 6/1/24 9:22 AM, Stefan wrote:
>>>>> On 1/6/2024 17:05, Jens Axboe wrote:
>>>>>> On 6/1/24 8:19 AM, Jens Axboe wrote:
>>>>>>> On 6/1/24 3:43 AM, Stefan wrote:
>>>>>>>> io_uring uses the __u32 len field in order to pass the length to
>>>>>>>> madvise and fadvise, but these calls use an off_t, which is 64bit on
>>>>>>>> 64bit platforms.
>>>>>>>>
>>>>>>>> When using liburing, the length is silently truncated to 32bits (so
>>>>>>>> 8GB length would become zero, which has a different meaning of "until
>>>>>>>> the end of the file" for fadvise).
>>>>>>>>
>>>>>>>> If my understanding is correct, we could fix this by introducing new
>>>>>>>> operations MADVISE64 and FADVISE64, which use the addr3 field instead
>>>>>>>> of the length field for length.
>>>>>>>
>>>>>>> We probably just want to introduce a flag and ensure that older stable
>>>>>>> kernels check it, and then use a 64-bit field for it when the flag is
>>>>>>> set.
>>>>>>
>>>>>> I think this should do it on the kernel side, as we already check these
>>>>>> fields and return -EINVAL as needed. Should also be trivial to backport.
>>>>>> Totally untested... Might want a FEAT flag for this, or something where
>>>>>> it's detectable, to make the liburing change straight forward.
>>>>>>
>>>>>>
>>>>>> diff --git a/io_uring/advise.c b/io_uring/advise.c
>>>>>> index 7085804c513c..cb7b881665e5 100644
>>>>>> --- a/io_uring/advise.c
>>>>>> +++ b/io_uring/advise.c
>>>>>> @@ -17,14 +17,14 @@
>>>>>>     struct io_fadvise {
>>>>>>         struct file            *file;
>>>>>>         u64                offset;
>>>>>> -    u32                len;
>>>>>> +    u64                len;
>>>>>>         u32                advice;
>>>>>>     };
>>>>>>       struct io_madvise {
>>>>>>         struct file            *file;
>>>>>>         u64                addr;
>>>>>> -    u32                len;
>>>>>> +    u64                len;
>>>>>>         u32                advice;
>>>>>>     };
>>>>>>     @@ -33,11 +33,13 @@ int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>     #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
>>>>>>         struct io_madvise *ma = io_kiocb_to_cmd(req, struct io_madvise);
>>>>>>     -    if (sqe->buf_index || sqe->off || sqe->splice_fd_in)
>>>>>> +    if (sqe->buf_index || sqe->splice_fd_in)
>>>>>>             return -EINVAL;
>>>>>>           ma->addr = READ_ONCE(sqe->addr);
>>>>>> -    ma->len = READ_ONCE(sqe->len);
>>>>>> +    ma->len = READ_ONCE(sqe->off);
>>>>>> +    if (!ma->len)
>>>>>> +        ma->len = READ_ONCE(sqe->len);
>>>>>>         ma->advice = READ_ONCE(sqe->fadvise_advice);
>>>>>>         req->flags |= REQ_F_FORCE_ASYNC;
>>>>>>         return 0;
>>>>>> @@ -78,11 +80,13 @@ int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>     {
>>>>>>         struct io_fadvise *fa = io_kiocb_to_cmd(req, struct io_fadvise);
>>>>>>     -    if (sqe->buf_index || sqe->addr || sqe->splice_fd_in)
>>>>>> +    if (sqe->buf_index || sqe->splice_fd_in)
>>>>>>             return -EINVAL;
>>>>>>           fa->offset = READ_ONCE(sqe->off);
>>>>>> -    fa->len = READ_ONCE(sqe->len);
>>>>>> +    fa->len = READ_ONCE(sqe->addr);
>>>>>> +    if (!fa->len)
>>>>>> +        fa->len = READ_ONCE(sqe->len);
>>>>>>         fa->advice = READ_ONCE(sqe->fadvise_advice);
>>>>>>         if (io_fadvise_force_async(fa))
>>>>>>             req->flags |= REQ_F_FORCE_ASYNC;
>>>>>>
>>>>>
>>>>>
>>>>> If we want to have the length in the same field in both *ADVISE
>>>>> operations, we can put a flag in splice_fd_in/optlen.
>>>>
>>>> I don't think that part matters that much.
>>>>
>>>>> Maybe the explicit flag is a bit clearer for users of the API
>>>>> compared to the implicit flag when setting sqe->len to zero?
>>>>
>>>> We could go either way. The unused fields returning -EINVAL if set right
>>>> now can serve as the flag field - if you have it set, then that is your
>>>> length. If not, then the old style is the length. That's the approach I
>>>> took, rather than add an explicit flag to it. Existing users that would
>>>> set the 64-bit length fields would get -EINVAL already. And since the
>>>> normal flags field is already used for advice flags, I'd prefer just
>>>> using the existing 64-bit zero fields for it rather than add a flag in
>>>> an odd location. Would also make for an easier backport to stable.
>>>>
>>>> But don't feel that strongly about that part.
>>>>
>>>> Attached kernel patch with FEAT added, and liburing patch with 64
>>>> versions added.
>>>>
>>>
>>> Sounds good!
>>> Do we want to do anything about the current (32-bit) functions in
>>> liburing? They silently truncate the user's values, so either marking
>>> them deprecated or changing the type of length in the arguments to a
>>> __u32 could help.
>>
>> I like changing it to an __u32, and then we'll add a note to the man
>> page for them as well (with references to the 64-bit variants).
>>
>> I still need to write a test and actually test the patches, but I'll get
>> to that Monday. If you want to write a test case that checks the 64-bit
>> range, then please do!
>>
> 
> Maybe something like the following for madvise?
> Create an 8GB file initialized with 0xaa, punch a (8GB - page_size)
> hole using MADV_REMOVE, and check the contents. It requires support
> for FALLOC_FL_PUNCH_HOLE in the filesystem.

I think that looks very reasonable, and it's better than the DONTNEED
and timings, it was always a pretty shitty test. We just need to ensure
that we return T_EXIT_SKIP if the fs it's being run on doesn't support
punching holes.

FWIW, I did put the liburing changes in an 'advise' branch, so you could
generate a patch against that. Once we're happy with it, it can get
pulled into master.

-- 
Jens Axboe


