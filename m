Return-Path: <io-uring+bounces-4429-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C0B29BBA6F
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 17:38:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BBAE1C213EB
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D4E61C07F1;
	Mon,  4 Nov 2024 16:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SUjvwnkb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC49820326;
	Mon,  4 Nov 2024 16:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730738287; cv=none; b=I/UHe6VZlb6iS4c+8scJ1gEJSdHYRZPAeQgjSixoYZAP8zolzF7Rvj/uccppTbQ3I0vCZHZmY+PWdB2n6z3SDxJtnN8lExemzwKzzW3Pt3S6Qobo1JcxoCiGvTNRCBPWapEZV+4NyaFFmKFikmwYuv49F3VT1wmvOEkmoLfgCjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730738287; c=relaxed/simple;
	bh=8pX11qNfWYxJfjipQQ48vfCsg1LLtSOf23BJJFU9rLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kk3dTl6NXIm8jminflLXjgtwO4BCLxbPYJ+sdx4Qgjw1QVWxedDXvdivQ1N+WkzJ55xnxyI702Vl/nhwAoo2VtBEz/n7gDhmrYuTeguBMnQ8aZh1giT5yJrn2BYmTyqqp/VnZDB1p19N9QW3WXRsxwze0tt+rGrJa/xZdK4tzuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SUjvwnkb; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5cec93719ccso2779595a12.2;
        Mon, 04 Nov 2024 08:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730738284; x=1731343084; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aG7p/v+GZb8kUzbIL7r3HcUkBQkE1tJdxNXPjnP871c=;
        b=SUjvwnkbtcjB5cUWSQ0z10SBvMcjYYfRQ3IGdPbbxGCiJpy/oP4ojGQQOeIt/S/lTK
         8pW0ZTozLSE4Qd8Rv9fNMSRP/mkbZGopbgQKaZkAevALMuWmv4s372qa/hiuaocupl9A
         G0g2UcRMKcOVHGNN8f7W/UnSAUVLsjyTabvcu/V+Gcsuy/So8YioruvInY0JuzWz9WNm
         jQmeDj50j7L5Oa0yroYG4vWSdiSzD16JrYrSJj35yuw1yoDXCapd31jB7oP5YZS0j8bZ
         jtwUe2EeGfRECwfZAw/70+LtAfydSwkrUOImqkl+52wKSxgzDx30YrhLC5oTofQmYBWj
         URUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730738284; x=1731343084;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aG7p/v+GZb8kUzbIL7r3HcUkBQkE1tJdxNXPjnP871c=;
        b=gxJQgSSR1JZ1ihLbXG76lH3bnRQQjxyt7KvvoIdYkkT+JW9jhOlusw9Kj/sJEQGtD0
         q2B2Y2xnw/CSXvjLxrMA760CvO4rxSCgSUfNk+5r9m0nyNI2YDZUa4rdg6lgSOTTsXYb
         u7Llns0GeXdnzOO6QXEDUujaCK8siI/+79KVTbnxUVFFhuL9SdDC0Uhykm1bmRClGZjw
         ZLHqxl6l29/NJ6uKjO5gasEFWEQCGbmG2ygqE53rWAfulcSqk5fELYSCezi2YQCYcHkt
         I06kUmmUYn2CD5oD2Nr/ojRwA+C0m+P7cgDfDNeZBnnQTclYd8SbbkP+yl91KOTGBXNN
         mNxw==
X-Forwarded-Encrypted: i=1; AJvYcCX8A1Yy4Z9eJHffVd2fjJMuCcpdU0ryhMPg/orXp8Q9HC+v6ZpxEApvk8jPGMUis7pWtzTJoGTsCT5cCVw=@vger.kernel.org, AJvYcCXsKdf35qpJ5TRFzfqeZsGPb+ws0DEqUEU2/C5vuQRm/AQN41QQJ+DiIFVAmmCIYFOXkWDxPqgOmQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyPM5bg+SrA3fl1d4bshx4hlsKYmBDRUs1g4rD2BgMWJTjX9V3r
	idvdmy+LHWba96jjrAs18YASewsdKadGAqTZ/J9+3Rb2IA4tl9ul
X-Google-Smtp-Source: AGHT+IFDt7hOTdk9sS+VlYN+AKPR3L7iFyEPeziAofYDvfU4KtFjjdIljT8FpR9H4cWsxjRSbmJGag==
X-Received: by 2002:a05:6402:518a:b0:5c9:76ca:705b with SMTP id 4fb4d7f45d1cf-5cd54afde73mr15176013a12.34.1730738283805;
        Mon, 04 Nov 2024 08:38:03 -0800 (PST)
Received: from [192.168.42.71] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cee6afe451sm26846a12.67.2024.11.04.08.38.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 08:38:03 -0800 (PST)
Message-ID: <0e4d8bda-459c-41f0-af8d-30c9d81bfb80@gmail.com>
Date: Mon, 4 Nov 2024 16:38:08 +0000
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
References: <ZyGURQ-LgIY9DOmh@fedora>
 <40107636-651f-47ea-8086-58953351c462@gmail.com> <ZyQpH8ttWAhS9C5G@fedora>
 <4802ef4c-84ca-4588-aa34-6f1ffa31ac49@gmail.com> <ZygSWB08t1PPyPyv@fedora>
 <0cd7e62b-3e5d-46f2-926b-5e3c3f65c7dd@gmail.com> <ZyghmwcI1U4WizyX@fedora>
 <74d8d323-789c-4b4d-8ce6-ada6a567b552@gmail.com> <ZyjHQN9VITpOlyPA@fedora>
 <8fc4d419-5d16-4f58-ae66-8267edaff6ef@gmail.com> <ZyjNq92M8qhJFEKm@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZyjNq92M8qhJFEKm@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 13:35, Ming Lei wrote:
> On Mon, Nov 04, 2024 at 01:24:09PM +0000, Pavel Begunkov wrote:
...
>>>>>> any private data, then the buffer should've already been initialised by
>>>>>> the time it was lease. Initialised is in the sense that it contains no
>>>>>
>>>>> For block IO the practice is to zero the remainder after short read, please
>>>>> see example of loop, lo_complete_rq() & lo_read_simple().
>>>>
>>>> It's more important for me to understand what it tries to fix, whether
>>>> we can leak kernel data without the patch, and whether it can be exploited
>>>> even with the change. We can then decide if it's nicer to zero or not.
>>>>
>>>> I can also ask it in a different way, can you tell is there some security
>>>> concern if there is no zeroing? And if so, can you describe what's the exact
>>>> way it can be triggered?
>>>
>>> Firstly the zeroing follows loop's handling for short read
>>
>>> Secondly, if the remainder part of one page cache buffer isn't zeroed, it might
>>> be leaked to userspace via another read() or mmap() on same page.
>>
>> What kind of data this leaked buffer can contain? Is it uninitialised
>> kernel memory like a freshly kmalloc'ed chunk would have? Or is it private
>> data of some user process?
> 
> Yes, the page may be uninitialized, and might contain random kernel data.

I see now, the user is obviously untrusted, but you're saying the ublk
server user space is trusted enough to see that kind of kernel data.
Sounds like a security concern, is there a precedent allowing such? Is
it what ublk normally does even without this zero copy proposal?

-- 
Pavel Begunkov

