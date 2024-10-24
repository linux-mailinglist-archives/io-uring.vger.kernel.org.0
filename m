Return-Path: <io-uring+bounces-3997-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47FE09AEEBD
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 19:55:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F35351F2222C
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1D831FAF1F;
	Thu, 24 Oct 2024 17:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZpFHU2W8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB791F76A3
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 17:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729792544; cv=none; b=TA6aZssn64g+bX5UgM87ZS9wuEwyfr4Jc5uSgnCVaqADa1/GXq0lf6XSXECeq/DAe5PqIumc1q/0aiAs8nJHyd7orp+qhjazGAhlxbYZFwDMwRr4u5gf2WpDtyd5gQjoUNy3fv93ot2ysDoqra41yCslqC7CK/0TUvYFVSHGkXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729792544; c=relaxed/simple;
	bh=cz/pYcAHAPexZZkfy0zvAU1DV5xWOrRwqkj+uRojDI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NIC/le+Cic8az9VI5eSJnXUHLvSVQqvShd8ZJg7O+mjJnTGHtKkz2nr08Z/Op5mLqfxOsjDqXdMiFdeu/7OOsFKTfeXm/n2H36rgT9D4wTZX9Z80h5Oz+sc20mcvQdYJoFVGyd+MdVr2trZZmyQi12/7gu8ipOgZeHFzypaOv2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZpFHU2W8; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9a0ec0a94fso157245966b.1
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 10:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729792541; x=1730397341; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c5ts2ptvVNJaSj4l9ggGVxmCGhjYFM+v4LaXtH55kQs=;
        b=ZpFHU2W8aW44vrTVW4qD5TLoQ/MT932l5Ji1gFx3PI0G5CC4Iav+kQuhXNSrzU4fN0
         nJAoiWWp5SYZvOnFX2T8q44/qdEcEk0gegE9ZN16JMfWbvlaoKJAPax+E2xP9Z1/HYZd
         zyW9XND1i8/WIu3sI7ZzsU+nIFW8Xd+w8d5KVsssJsoYuo4Ralk9SoBSHSm2m8NUHLSB
         z3UZTaQN8iXDk47RCypIFJIf9yxW0YjHUnPqDnhqiipqBUYxPR42Jr3xieTgUM0ljhwx
         6qDXUQrqyc+gH/dSFIRLyqB5e1NrOIRVvbljZ1BV7QzvdShkRpJ0J1obpsxwU6f1qJQp
         kkzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729792541; x=1730397341;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c5ts2ptvVNJaSj4l9ggGVxmCGhjYFM+v4LaXtH55kQs=;
        b=TJjCucG6qKlGgMYNf27HlQ7sVNNBkZiTIAfQw4vp8hqrqXjl+uxAEUQmA4BPZGE8zv
         i0gx/UEq0d+hcXtmTAwTnQ540XuskqXR/kbKIN60EELNhqPr91cVG/29+OGO+Fl7Umck
         QLlfsM1r0Da8GkbY9LnzPiLl9PTdMROnEUsyLJ6l0quutEeGxaArbNrRdG9ssHnlrOG0
         4gcY+jAtAOuXmfXQlmk6T6QD5aj4c+3lR5ew3a6lOquz0HeIUQ32EB+qdaMj4/4dIFbQ
         vc38ZA7mH1XgRN+RPhaNLsQWqXTxBDiLFcDClbXGCoFEi9mReeYHbhR8LRBdrPQF7Y4h
         /0Fw==
X-Forwarded-Encrypted: i=1; AJvYcCVoIsoxejJ6J7zLAXk1NHjQXovM3IXZxoWUxUVIXBrV2A6xrsxHWQpq8TK6ygJGiYlzhH+9BA5kZA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOFvblmqRN0PjnjegZMtbdGXyEJ5mWC4GgwxD8A004FGNvs/a6
	IqKUUGaT6TaySKG/QKHpr/n9LwBK8aSiTwiGxOTrMgr1vj5NfHsD3p5bJQ==
X-Google-Smtp-Source: AGHT+IH2Ww1AGM4UXL7lcYkgV7uuLoCSQLXHUJbw4eRFlvvbEZYbfVZevQloLp4roLJgoC2NlGnJHg==
X-Received: by 2002:a17:907:3fa6:b0:a9a:7f84:941d with SMTP id a640c23a62f3a-a9ad2711806mr259108966b.6.1729792540547;
        Thu, 24 Oct 2024 10:55:40 -0700 (PDT)
Received: from [192.168.8.113] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ac564995esm245310366b.77.2024.10.24.10.55.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 10:55:40 -0700 (PDT)
Message-ID: <3376be3e-e5c4-4fbb-95bb-b3bcd0e9bd8b@gmail.com>
Date: Thu, 24 Oct 2024 18:56:15 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] implement vectored registered buffers for sendzc
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1729650350.git.asml.silence@gmail.com>
 <b15e136f-3dbd-4d4e-92c5-103ecffe3965@kernel.dk>
 <bfbe577b-1092-47a2-ab6c-d358f55003dc@gmail.com>
 <28964ec6-34a7-49b8-88f5-7aaf0e1e4e3f@kernel.dk>
 <3e28f0bb-4739-40de-93c7-9b207d90d7c5@gmail.com>
 <3e6c3ff5-9116-4d50-9fa8-aae85ad24abc@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3e6c3ff5-9116-4d50-9fa8-aae85ad24abc@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 18:19, Jens Axboe wrote:
> On 10/24/24 10:06 AM, Pavel Begunkov wrote:
>> On 10/24/24 16:45, Jens Axboe wrote:
...
>>> bv = kmsg->bvec;
>>> for_each_iov {
>>>      struct iovec iov;
>>>
>>>      unsafe_get_user(iov.iov_base, &user_iovec->iov_base, foo);
>>>      unsafe_get_user(iov.iov_len, &user_iovec->iov_len, foo);
>>>
>>>      import_to_bvec(bv, &iov);
>>>
>>>      user_iovec++;
>>>      bv++;
>>> }
>>>
>>> if it can be done at prep time, because then there's no need to store
>>> the iovec at all, it's already stable, just in bvecs. And this avoids
>>> overlapping iovec/bvec memory, and it avoids doing two iterations for
>>> import. Purely a poc, just tossing out ideas.
>>>
>>> But I haven't looked too closely at your series yet. In any case,
>>> whatever ends up working for you, will most likely be find for the
>>> bundled zerocopy send (non-vectored) as well, and I can just put it on
>>> top of that.
>>>
>>>> And you just made one towards delaying the imu resolution, which
>>>> is conceptually the right thing to do because of the mess with
>>>> links, just like it is with fixed files. That's why it need to
>>>> copy the iovec at the prep stage and resolve at the issue time.
>>>
>>> Indeed, prep time is certainly the place to do it. And the above
>>> incremental import should work fine then, as we won't care abot
>>> user_iovec being stable being prep.
>>
>> Seems like you're agreeing but then stating the opposite, there
>> is some confusion. I'm saying that IMHO the right API wise way
>> is resolving an imu at issue time, just like it's done for fixed
>> files, and what your recent series did for send zc.
> 
> Yeah early morning confusion I guess. And I do agree in principle,
> though for registered buffers, those have to be registered upfront
> anyway, so no confusion possible with prep vs issue there. For provided
> buffers, it only matters for the legacy ones, which generally should not
> be used. Doesn't change the fact that you're technically correct, the
> right time to resolve them would be at issue time.

I'm talking about sendmsg with iovec. Registered buffers should
be registered upfront, that's right, but iovec should be copied
at prep, and finally resolved into bvecs incl the imu/buffer lookup
at the issue time. And those are two different points in time,
maybe because of links, draining or anything else. And if they
should be at different moments, there is no way to do it while
copying iovec.

-- 
Pavel Begunkov

