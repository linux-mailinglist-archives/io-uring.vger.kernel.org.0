Return-Path: <io-uring+bounces-7980-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48C40AB7641
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 21:59:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D14891B66D85
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 19:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7035829372F;
	Wed, 14 May 2025 19:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UOWLpu9f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9735B29346F
	for <io-uring@vger.kernel.org>; Wed, 14 May 2025 19:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747252769; cv=none; b=H65sD8W7xdwIlhJflbnLXl85Bl+7MbB70haS4oCfFwRygW2efiaPHAzSxzzubtpYyfyW/ZQG31G3KZ3vu4FBEsL3zGoQVpv4+QGReJS2Pfv0QhIR6qmdth2QrV5tH0JXtPepE5DHnOmPIjPGVjNy1xw7PNZEYfL62fW6kbBmuQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747252769; c=relaxed/simple;
	bh=jUv8NFbedWc2oMjnlE6kq4hgoHjZD0iw9lFpAO4UByo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dfOHMC3gO0ednFpPIBNkiOakCoTA2P0sePWSjyECZVzAK5zfuH9vqTyM6I257gi/NMuy5X8OrsBDK/4OkSuJyag77hg+a96dVCnsHHOfxYyruaOoCO883g9M8laH9ac6DJBQUsvarY3e7iL8wRV4ezBPH9xtTR06BYHVB0jHAxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UOWLpu9f; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ad23c20f977so27274866b.2
        for <io-uring@vger.kernel.org>; Wed, 14 May 2025 12:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747252766; x=1747857566; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pyL4PMWOO21tzrlE0aLEOZoztbjSgifsq909PDJub6g=;
        b=UOWLpu9fyy78DC1g5BJhq6Z3Fkkypse8GqrU9Npw6Nb0CJGXU+K59776P02UE8yuRl
         Ym87i7dkTodx1fZqCdNFRXYMHESwEBzhZFmSF28iuCR0lqG/+LvAvalYd2OqffhZ2S2+
         YshQUgPHu2VIP7oU239esRQ9h+NUzJUHFZsARfG0yVakotT0io2G4SOyZxiEx1LUHETi
         dkdphfVMRmMP0EMCguPmK86424rGQUMnLTdL/6/Pr7waqxTGghuOE6gOrdGlSgWX5oW0
         v2A9unLGg3/JVs/xBow/suup26KY49zIm4Cpe/UmG4pcQKsdH9aNUr65uNQyeXp7nQTH
         GPOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747252766; x=1747857566;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pyL4PMWOO21tzrlE0aLEOZoztbjSgifsq909PDJub6g=;
        b=OE652Rnv2+Dz9P9kxHS6Wn4zakuIXme+PJ8/fdJIePcwt/BIVq9Bpf1OynqZvtihjD
         1yeiYWvWIHnh8eAbxREVBaAxpoVw1+TqStuQ3mcPaDkDpDrPsQ2Q4IHS2g7k/YRWoa3c
         Ht1JfWvpjgk8xrBJJmuWC5ie3HC50t7Wr+H8oIcpsiRrkENNQ08HhWgD1iaMN8EPbv3R
         f5kr1b3e8Dpa2BqrhJ5QIwdyCIGCpgrhSfXedT47RZcDs4arK9jaLDFULh2bO5c9Lqle
         k0ltDXRZkibo24MZTYaQxoK9/f2c1QOQ27nUVeMw2nxKp8RV3ONIJeoN6bjIBUYk+Io8
         lchQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1FQ9ke8tCEQ4Krw/Fqz/eevd0IKrbkqgmoFMvU1oqFBgBcuZQTwO64rJE+zWPEtds2/dPpEds4A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+Wm7sucfuOz/u7JotQPzr+n0GoMvujDd8KqB+Egqs0Cf3XRXY
	1SA79+egOZruXSq3VtKvLRGLMIcFkwgBp0Je6w9wjHid2sOzIDM2DEWqoA==
X-Gm-Gg: ASbGncvPX5bBdHNscBefvOXKBoqFTc3GA8mc++TnMuXbwFlNatICXPanrCSdgUv3tsS
	htWblm79msyvU6rLNVpxX970Z6Ij5tKY4YRcDvEuhzgB2fSy/dXQziZQXsnl0qeyM/guQkHawPN
	zbJ/QeY2rsXHwyb6+y1HicD2tdYF/GuZsZkBgRjeJYXCIW3b0chylSapZetsRizlUyci2NVEcc+
	JJlENf/ykaBdmfIGgzNGw+ntkfKYTT8QsLCbojJ8hGxFc5G5rXMWZqaymwd/ZXqdpWakyeGDfP/
	NfE1vN7HNf+kF+tQ3TXXZh9zP5+RnNGr3CSoMC/p+yfuxrdwnC0wZsiZN1o=
X-Google-Smtp-Source: AGHT+IHDmw2rznwjFmtODutjloWBNcY/glj9vDZTDgz8ExuhYrrUfYNeXxfejvfCOy0JEeiZsbXcSQ==
X-Received: by 2002:a17:907:c003:b0:ad2:31ce:6cfe with SMTP id a640c23a62f3a-ad4f71cf952mr420237466b.30.1747252765453;
        Wed, 14 May 2025 12:59:25 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.234.72])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad2197be6d7sm975861666b.157.2025.05.14.12.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 12:59:24 -0700 (PDT)
Message-ID: <a788a22f-0efd-4b78-94b5-c096b38c0e6c@gmail.com>
Date: Wed, 14 May 2025 21:00:44 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring: move locking inside overflow posting
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1747209332.git.asml.silence@gmail.com>
 <56fb1f1b3977ae5eec732bd5d39635b69a056b3e.1747209332.git.asml.silence@gmail.com>
 <d6634082-86c0-4393-b270-ede60397695e@kernel.dk>
 <d63f55e8-7453-46fb-a85a-03e6de14402f@gmail.com>
 <6097e834-29a4-4e49-9c62-758e5b1a3884@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6097e834-29a4-4e49-9c62-758e5b1a3884@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/25 20:25, Jens Axboe wrote:
> On 5/14/25 11:18 AM, Pavel Begunkov wrote:
>> On 5/14/25 17:42, Jens Axboe wrote:
>>> On 5/14/25 2:07 AM, Pavel Begunkov wrote:
>> ...>> +static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, bool locked,
>>>> +                     u64 user_data, s32 res, u32 cflags,
>>>> +                     u64 extra1, u64 extra2)
>>>> +{
>>>> +    bool queued;
>>>> +
>>>> +    if (locked) {
>>>> +        queued = __io_cqring_event_overflow(ctx, user_data, res, cflags,
>>>> +                            extra1, extra2);
>>>> +    } else {
>>>> +        spin_lock(&ctx->completion_lock);
>>>> +        queued = __io_cqring_event_overflow(ctx, user_data, res, cflags,
>>>> +                            extra1, extra2);
>>>> +        spin_unlock(&ctx->completion_lock);
>>>> +    }
>>>> +    return queued;
>>>> +}
>>>
>>> Really not a fan of passing in locking state and having a split helper
>>> like that.
>>
>> I'd agree in general, but it's the same thing that's already in
>> __io_submit_flush_completions(), just with a named argument
>> instead of backflipping on ctx->lockless_cq.
> 
> And I honestly _greatly_ prefer that to passing in some random bool
> where you have to go find the function to even see what it does...

I see, it's much worse than having it somewhat abstracted,
trying to be more reliable and self checking to prevent bugs,
I give up on trying to do anything with it.

>>> It's also pretty unwieldy with 7 arguments.
>>
>> It's 6 vs 7, not much difference, and the real problem here is
>> passing all cqe parts as separate arguments, which this series
>> doesn't touch.
> 
> It's 6 you're passing on, it's 7 for the overflow helper.

I don't get what you're saying.

>>> Overall, why do we care about atomic vs non-atomic allocations for
>>> overflows? If you're hitting overflow, you've messed up... And if it's
>>
>> Not really, it's not far fetched to overflow with multishots unless
>> you're overallocating CQ quite a bit, especially if traffic is not so
>> homogeneous and has spikes. Expensive and should be minimised b/c of
>> that, but it's still reasonably possible in a well structured app.
> 
> It's still possible, but it should be a fairly rare occurence after all.

That's what I'm saying. And handling that "rare" well is the difference
between having reliable software and terminally screwing userspace.

>>> about cost, gfp atomic alloc will be predictable, vs GFP_KERNEL which
>>> can be a lot more involved.
>>
>> Not the cost but reliability. If overflowing fails, the userspace can't
>> reasonably do anything to recover, so either terminate or leak. And
>> it's taking the atomic reserves from those who actually need it
>> like irq.
> 
> I don't really disagree on that part, GFP_ATOMIC is only really used
> because of the locking, as this series deals with. Just saying that
> it'll make overflow jitter more pronounced, potentially, though not

It's like saying that the allocation makes heavier so let's just
drop the CQE on the floor. It should do reclaim only when the
situation with memory is already bad enough and you're risking
failing atomic allocations (even if not exactly that).

> something I'm worried about. I'd much rather handle that sanely instead
> of passing in locking state. At least a gfp_t argument is immediately
> apparent what it does.

-- 
Pavel Begunkov


