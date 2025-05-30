Return-Path: <io-uring+bounces-8166-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F2F4AC9291
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 17:34:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D28871705DD
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B670522D9F2;
	Fri, 30 May 2025 15:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="L7F9cq3S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FF019DF41
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 15:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748619259; cv=none; b=k+bprA5RVLUQ9qBmisdOGkTvpXM402O+LoAW3HHIIds51LCAmC2dhadQR4CdpsBjyKiAaCNV2j5E1XDfUmG/iZgqpMgS+C1P6pRWfiSl9gSbLRyu4IfFq2FMWolhOhw07KG1X1HdmqFuTx9piOUlSylxIoQjodbekBGyxESqTS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748619259; c=relaxed/simple;
	bh=HP7hmBj0ViK+rZxZ6n7NsCGeJzrscp76CqWtCaPNov0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=epS81RWNQ9+tbMEaQp7m6mSGrk9DBIIgmfHavMcYU9TwFh6ABysIfYxQdhjZv4Bw4vOlTtt/uh2TjiUVY3JycYeUG2F+GWCmb+QvXUOP1mR6mhFDYah5dYhxnCCbAsvIGGmmdR83o8DHtTe42sq6RWooKNc5ddNLaCGnTNBRl9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=L7F9cq3S; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-86a52889f45so67695839f.3
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 08:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748619256; x=1749224056; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=imw6dbF+IgbvWedPtLsMS66JnIG99dTL77w2sO7Yz38=;
        b=L7F9cq3SefDLArR1GLXUIY7XOBHDoWKqmZsOUkYlLfh6VHhA2C0rlmF8Y+ucuOeM5E
         oV+CtFHPZ+6N9xfssZRgaVbgSAb8EWcZS0ZQ00xDRgHbmZNfH9MILsGyOIPxYU3Jqtrc
         spBnpa/G1gstTZLNnqXuh8CU8EEHzh73ypneVAiGeoPaSXXq625Z2CyYgI/e7ewUZhIv
         CMq6WTsA7dr6txEDBJ60CNJgxEZN8oJshsTuFXIVuiFvG9rP9Yg6VKWVyRGvGOAhibRA
         Vg7mRY6//idp9ATCD5odtW8de1StpvCl0ETPg+a3Z8IDXdGPbEE2b5lipM5fRrGG85SR
         ES6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748619256; x=1749224056;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=imw6dbF+IgbvWedPtLsMS66JnIG99dTL77w2sO7Yz38=;
        b=e2JMffa5zlEhS3JniThhiNVMTkAWRYxjK/XZ+nCP/Tb850l7Exql6afcsvv8L3Jfrg
         GyGctXGrO47S5oAfUikryfyP/unWUChcGaIOg7B5xtXeNYWkJwlZaM4dZXw+KI9gNqeb
         5EjEWLLh9aJFUQo96M7H1u5OOk5arsT7RF+jmXIkz1ZmRo/5fGo811vdlLpxuCHM4+Tv
         GFey9VtBOUfiD7RYrUCS5LPzCMqdBuxB1wbQs9xwkNCkpnzNzwqYX1EssM9pLDH674BE
         b4mNEl2lKD+lrw4mVbbi9+d7R/LGYBAkpAwLa4/xsDyuj4MCDZ3cU5aZM3Y1Cs3r4KbX
         /xMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVX3HVwShhkk4JIDs9N3bO5iAZm8UTN2YlvVorfkFfqI14CqXa3/vgXvEi+7pw9h+y/EZo+4Ngag==@vger.kernel.org
X-Gm-Message-State: AOJu0YyxfMUr2dE8npw4NbcwRWVYC/m0/yyqSCv9MJdvre4JNXyQArZe
	MvijqZVW0SpVD38N/jI4OnPyMFUS2F4nTyaCSKVtAGi9isoEMp2JMRDAJUTzRDkWPt0H7PzybYi
	w1mnk
X-Gm-Gg: ASbGncvf7QpSEf9IDkyC9wIsMKzN0WSiz1HKKF7OzC1xf9AE4/2gu0fQ5xRuYrVxyxr
	ubutrzyRAFnAnTiIv2a0a1P2OvB5X8djc1h38s7azmBQL8W2Ey4Ww5S0tJJLNJCHJbkcfG8xTYn
	JNI+4Rmyw/DGvDyVkyk3yTT8TXvkuAgjj6sbkjG2YD2q/gDUos3X8hkG7ToWCxxVV+meHrWn7OU
	bc0mf424o0XO7FOgDT4ZEt2+wOllp7dXnN0jne+qxyv2MnkIc2z+YQ3bRJlB6EqAqusJSm9gyrN
	+jQ5XwlBeUqYvJa2E87niqR6K++gwgMtI1SKFUyMBJX/rVg=
X-Google-Smtp-Source: AGHT+IG2BEawG9RBzz41tnjwh4ze9/fhoalZXnOVZhTmma3cp3jWzIBQjyVl/I50rp9Wt9zKjizqAA==
X-Received: by 2002:a05:6e02:168c:b0:3d8:2023:d048 with SMTP id e9e14a558f8ab-3dd99c43493mr48969885ab.22.1748619256251;
        Fri, 30 May 2025 08:34:16 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dd935a7ba3sm8165165ab.69.2025.05.30.08.34.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 08:34:15 -0700 (PDT)
Message-ID: <0742c127-9991-4181-af67-1efaab9e12b3@kernel.dk>
Date: Fri, 30 May 2025 09:34:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/6] io_uring/mock: add cmd using vectored regbufs
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <a515c20227be445012e7a5fc776fb32fcb72bcbb.1748609413.git.asml.silence@gmail.com>
 <bd72b25d-b809-4743-a857-7744a3586bea@kernel.dk>
 <4207774d-5f78-46d6-9829-4feb24c81799@gmail.com>
 <341c18d0-dce2-451d-86a6-ad4c05267388@kernel.dk>
 <4e5e0207-9749-4d49-8d55-9710c972b673@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4e5e0207-9749-4d49-8d55-9710c972b673@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/25 8:53 AM, Pavel Begunkov wrote:
> On 5/30/25 15:37, Jens Axboe wrote:
>> On 5/30/25 7:40 AM, Pavel Begunkov wrote:
>>> On 5/30/25 14:25, Jens Axboe wrote:
>>>> On 5/30/25 6:51 AM, Pavel Begunkov wrote:
>>>>> +static int io_copy_regbuf(struct iov_iter *reg_iter, void __user *ubuf)
>>>>> +{
>>>>> +    size_t ret, copied = 0;
>>>>> +    size_t buflen = PAGE_SIZE;
>>>>> +    void *tmp_buf;
>>>>> +
>>>>> +    tmp_buf = kzalloc(buflen, GFP_KERNEL);
>>>>> +    if (!tmp_buf)
>>>>> +        return -ENOMEM;
>>>>> +
>>>>> +    while (iov_iter_count(reg_iter)) {
>>>>> +        size_t len = min(iov_iter_count(reg_iter), buflen);
>>>>> +
>>>>> +        if (iov_iter_rw(reg_iter) == ITER_SOURCE) {
>>>>> +            ret = copy_from_iter(tmp_buf, len, reg_iter);
>>>>> +            if (ret <= 0)
>>>>> +                break;
>>>>> +            if (copy_to_user(ubuf, tmp_buf, ret))
>>>>> +                break;
>>>>> +        } else {
>>>>> +            if (copy_from_user(tmp_buf, ubuf, len))
>>>>> +                break;
>>>>> +            ret = copy_to_iter(tmp_buf, len, reg_iter);
>>>>> +            if (ret <= 0)
>>>>> +                break;
>>>>> +        }
>>>>
>>>> Do copy_{to,from}_iter() not follow the same "bytes not copied" return
>>>> value that the copy_{to,from}_user() do? From a quick look, looks like
>>>> they do.
>>>>
>>>> Minor thing, no need for a respin just for that.
>>>
>>> One returns 0 on success the other the number of processed bytes.
>>
>> copy_{to,from}_user() returns bytes NOT processed, and I guess the iter
> 
> Sure, it doesn't contradict it, they follow different semantics.
> 
>> versions return bytes processed. Guess the code is fine, it's more so
>> the API that's a bit wonky on the copy/iter side.
> 
> Which API? This command or copy helpers? copy_{to,from}_user are used
> here in the way they're always used in the kernel, and that's fine,
> they're not supposed to fail for valid input. That's unlike iter
> helpers, which may return a partial result.

Not this command, the copy helpers in the kernel.

-- 
Jens Axboe

