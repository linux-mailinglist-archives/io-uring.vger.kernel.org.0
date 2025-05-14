Return-Path: <io-uring+bounces-7981-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EFDAAB7663
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 22:06:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05D8A8C3E09
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 20:05:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BABB19D09C;
	Wed, 14 May 2025 20:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bjayanlj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66591295DAD
	for <io-uring@vger.kernel.org>; Wed, 14 May 2025 20:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747253153; cv=none; b=hD0RiDhRIpC0BD+646wufFczTaFJu8Zs0FfqxKDCWk9QuoA9bQUmqyut3DiItrQ8OOI+WlQAxq/xfJ3/pk+FL2XdI9McP6qN/EbeOelPq11oQ5g+05MpUdi8LrSqzxI3jDvSUde5Wqu+9NogQypUUQuUHsocpzqBV9gCFELbBf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747253153; c=relaxed/simple;
	bh=6omcH8Uw9qbrlHhZ38JLKKTX6DwZknk+HnUhSxEGNqA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GQuI4B2b6mhann/4ziBJJHpXaQHwhKV7s7tlLT2qltDA+LOIT7zPdLDJjNQldUUbrOxZmLOFq9//d7gQApeSTSfbKjfcoDTsHSvIUF8u5BRNYgcHLkC9qqgsYpRwNlSnYCdb34qLs7/r398axQHrEiFc0fPePVt+3C47s4OFryM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bjayanlj; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-6065251725bso133817eaf.1
        for <io-uring@vger.kernel.org>; Wed, 14 May 2025 13:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747253149; x=1747857949; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I1zL7Xe34SjIqP2ctZv2lbLumsbH6SZKvNZj7unmH/g=;
        b=bjayanljP4nlUcO4HHtiJRRWjw4pQgLF95+j7JrDbDAMJZQF8FetZ5mkjm6diuAgqu
         pW+vDaRTJdzZJjK42oilOk3B74kNYVUhzG/dVw4zUatuUMn2MC/41GcABNMQkDt9ClSL
         5J7SdpDEO8Xuuff7CWLs7V1KJKROhsOqK9JU1j8tsD6puBk02HOF7uEhL365lL/47NS/
         dz6UZO23bGymz7pz9JZ9w8erTK3WLGQNi4d1g6g5HiLQSN4sAs6ksaSx3h+PP5QTeck1
         uPZXXQm5/apkzbUJeIXsGfkAPYWlkmZLgk1V1+oTNGOshg9dThMHO0mBbDor7alyWYZI
         9h+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747253149; x=1747857949;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I1zL7Xe34SjIqP2ctZv2lbLumsbH6SZKvNZj7unmH/g=;
        b=Cql2OP5wWtdi7kbsfzHU6OYLHkGRzZxVohYGUvHPY+qPv9o8MD+CkGoDKU8UF/g5+C
         axIxG3ZHZ1Jkvc8L84LZyeSW8rlc7cblDx1D62wbCXK30mnWA4P+l4vM3q4lSBdEo0uQ
         u2M6+GrjO5RbC8YF9OinGP956kDeFLZe/Rv1Ew6nFM9392K26SZmrJeMtFYr5o1C0s2E
         ZUVI4COyM143OKWuipajrNDWLje79x2VE32fUe7fP+TEbY/VybrhAeT9FtDnFSiIRIGm
         8wxsxNB+l7ele2NfdFJ9zB5YMX70ZCqEwobx+WgJXDps5pvR68qyvZBXCznVuWhaKnC9
         4UIA==
X-Forwarded-Encrypted: i=1; AJvYcCX14yVU1kLfCPkqIi4I0pkIvCsr06oAc+PhFcJAXNcZjpEc9AnyveogM8KrJswDQIo8UbKiDwPxKw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzN0ZLEV/5tjNaYce5CPqp+2yj5FY411YVaXR/Li8s64xe5Uilt
	9jtMdFVEowLrIMM/G1atExVRPO0j31vrca9HNRbhs7h9R1nZUkyw3t9mEGPdvy0=
X-Gm-Gg: ASbGncvBUp/h6CsVktjhK5zEcLTb9M0K9WIrGaZA53d8XdskSyUIiBA0zCPjN/di9et
	EZByMOGcpYvb4gPYfVZPT8VIiVQklOIp77+e4V60yy/uuykNd98Nfz/EYBnuzzP7bFYcSng54Vm
	G81TcQ+OrQCWyrHGSHW/IBtE5KO/XYKZ0vBuCbfj/fsOqZaGl0L2Ih7ySTetucl0kqgnlV+pooR
	RbgtYboi+wPwy18hCL4aPwUh1FoMHYKtf5FQM61f3GlP2ivNGRjf320VsIm+lj69HrOZcisOJI3
	+8k1N4Gh55gqtJZMI4D2q55WRIC1UEtHbNQp6m+jfzGVShs=
X-Google-Smtp-Source: AGHT+IH2VFzjlbuPWUFo47Ynro/gHi2mLKALZOePoTKfqm8N6wMkA+l7SPv/ODKN+ses3exDbvaT+w==
X-Received: by 2002:a05:6870:d69e:b0:2c1:ade0:2699 with SMTP id 586e51a60fabf-2e30e382c98mr2640612fac.0.1747253149106;
        Wed, 14 May 2025 13:05:49 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa225250e0sm2689046173.66.2025.05.14.13.05.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 13:05:48 -0700 (PDT)
Message-ID: <1644225f-36c9-4abf-8da3-cc853cdab0e8@kernel.dk>
Date: Wed, 14 May 2025 14:05:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring: move locking inside overflow posting
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1747209332.git.asml.silence@gmail.com>
 <56fb1f1b3977ae5eec732bd5d39635b69a056b3e.1747209332.git.asml.silence@gmail.com>
 <d6634082-86c0-4393-b270-ede60397695e@kernel.dk>
 <d63f55e8-7453-46fb-a85a-03e6de14402f@gmail.com>
 <6097e834-29a4-4e49-9c62-758e5b1a3884@kernel.dk>
 <a788a22f-0efd-4b78-94b5-c096b38c0e6c@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a788a22f-0efd-4b78-94b5-c096b38c0e6c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/14/25 2:00 PM, Pavel Begunkov wrote:
> On 5/14/25 20:25, Jens Axboe wrote:
>> On 5/14/25 11:18 AM, Pavel Begunkov wrote:
>>> On 5/14/25 17:42, Jens Axboe wrote:
>>>> On 5/14/25 2:07 AM, Pavel Begunkov wrote:
>>> ...>> +static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, bool locked,
>>>>> +                     u64 user_data, s32 res, u32 cflags,
>>>>> +                     u64 extra1, u64 extra2)
>>>>> +{
>>>>> +    bool queued;
>>>>> +
>>>>> +    if (locked) {
>>>>> +        queued = __io_cqring_event_overflow(ctx, user_data, res, cflags,
>>>>> +                            extra1, extra2);
>>>>> +    } else {
>>>>> +        spin_lock(&ctx->completion_lock);
>>>>> +        queued = __io_cqring_event_overflow(ctx, user_data, res, cflags,
>>>>> +                            extra1, extra2);
>>>>> +        spin_unlock(&ctx->completion_lock);
>>>>> +    }
>>>>> +    return queued;
>>>>> +}
>>>>
>>>> Really not a fan of passing in locking state and having a split helper
>>>> like that.
>>>
>>> I'd agree in general, but it's the same thing that's already in
>>> __io_submit_flush_completions(), just with a named argument
>>> instead of backflipping on ctx->lockless_cq.
>>
>> And I honestly _greatly_ prefer that to passing in some random bool
>> where you have to go find the function to even see what it does...
> 
> I see, it's much worse than having it somewhat abstracted,
> trying to be more reliable and self checking to prevent bugs,
> I give up on trying to do anything with it.

I'm just saying that I don't like 'bool locked' kind of arguments. We do
have some of them, but I always find it confusing. I do think the
__io_submit_flush_completions() approach is more robust.

Maybe have an alloc helper for the cqe and pass that in instead? Then we
could get rid of adding 'locked' AND 5 other arguments?

>>>> It's also pretty unwieldy with 7 arguments.
>>>
>>> It's 6 vs 7, not much difference, and the real problem here is
>>> passing all cqe parts as separate arguments, which this series
>>> doesn't touch.
>>
>> It's 6 you're passing on, it's 7 for the overflow helper.
> 
> I don't get what you're saying.

The helper you add, io_cqring_event_overflow(), takes 7 arguments. And
yes most of that is cqe arguments, the bool locked means we're now at 7
rather than 7 arguments. Not the end of the world, but both of them are
pretty horrid in that sense.

>>>> Overall, why do we care about atomic vs non-atomic allocations for
>>>> overflows? If you're hitting overflow, you've messed up... And if it's
>>>
>>> Not really, it's not far fetched to overflow with multishots unless
>>> you're overallocating CQ quite a bit, especially if traffic is not so
>>> homogeneous and has spikes. Expensive and should be minimised b/c of
>>> that, but it's still reasonably possible in a well structured app.
>>
>> It's still possible, but it should be a fairly rare occurence after all.
> 
> That's what I'm saying. And handling that "rare" well is the difference
> between having reliable software and terminally screwing userspace.

As I wrote just a bit below, I don't disagree on getting rid of
GFP_ATOMIC at all, just stating that it'll be a bit more jitter. But
that's still better than a potentially less reliable allocation for
overflow. And the jitter part should hopefully be rare, as overflows
should not be a common occurence.

>>>> about cost, gfp atomic alloc will be predictable, vs GFP_KERNEL which
>>>> can be a lot more involved.
>>>
>>> Not the cost but reliability. If overflowing fails, the userspace can't
>>> reasonably do anything to recover, so either terminate or leak. And
>>> it's taking the atomic reserves from those who actually need it
>>> like irq.
>>
>> I don't really disagree on that part, GFP_ATOMIC is only really used
>> because of the locking, as this series deals with. Just saying that
>> it'll make overflow jitter more pronounced, potentially, though not
> 
> It's like saying that the allocation makes heavier so let's just
> drop the CQE on the floor. It should do reclaim only when the
> situation with memory is already bad enough and you're risking
> failing atomic allocations (even if not exactly that).

Right, like I said I agree on that part...

-- 
Jens Axboe

