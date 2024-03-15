Return-Path: <io-uring+bounces-972-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 91A9087D130
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 17:30:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B14731C21BBC
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE14828FC;
	Fri, 15 Mar 2024 16:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jqAvqwKZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAE11865A;
	Fri, 15 Mar 2024 16:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710520223; cv=none; b=OxXawOq7bqHritwK1aq0fXeGSzQA6D8cB0uuy4STFRpMx2WvlpIxatoC3ZQApYizy/+34kDojbtBy+DVpDyMfQat9u2FZfulO3CSfn7v+fGdw6vGQAUDrRuLI8vwJMcwy+HcBca0NvbpTpwusWGA/tLuaqRj4bVnZ31ccLlXDxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710520223; c=relaxed/simple;
	bh=8zFwwNvLRi3d7W7ftPH6WvVpf9EfitpdXKfu7tJWuGc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tGwo9jPNLBqX8hjGv/vb4ELWXVJKlLCi2PbpZWM4Wmln+1VnhHusIhAId6bq8TedTie8gsjCSLLx7nmqAS/pJDmxydXFZ7PmdMOvsepJptNDzCeMOqf1XnROpy/TQGrLoSopk+wBgSwqko9HvhYlshvVmFJiPygwEEUbCGATMIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jqAvqwKZ; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5687e7662a5so3134319a12.0;
        Fri, 15 Mar 2024 09:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710520220; x=1711125020; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f0P5Cr4dffFYD4S6Iz4Brsjxj+AMHrfMlDU3NGLK6PY=;
        b=jqAvqwKZ1qXaAgxQfqzsGf1Huj04ufDBpkqtxuDHeLSrY1m2RP9I7MIT9PIW4BJ5xa
         hs3p/ra/ycLV47+5SxiTXh/wS83aYPNakO3lYtuFu7cMZMkpqUkwcDIJ+pBoTQHscGuE
         imJotc8qrTe6lY2WCfiD50y8CHdb7K+3E8PK2c2iiNw8bXu8bN/hCmU8EFvV4UzTTiRg
         h5WTVCk8R13pzySp2h6rfnrR08WgZWX2gm986Zi3CNARt683uaJ6/5/cAbfJzQuuObpV
         XAsCfI6K+cnANCPfyckeRTZUrNvPpJt+78ZA4yzC9GPphWGqM8/ZFmG4dnCYVF/KbySr
         aJ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710520220; x=1711125020;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f0P5Cr4dffFYD4S6Iz4Brsjxj+AMHrfMlDU3NGLK6PY=;
        b=uGJrCuhIHq07DnB9G7e66GhXgyHJOb1NfOOeRQJP3IQaXajfU9AMDsma767xii8oeT
         QZOiS8344P7hwXjyvKj9jOoqLbVRke7z3jlH6+rDULakPrLf/iZjqHOzwuTkti/bBPYR
         l8SrMl0JspbRttZDIM0qt7pN1S8MEEyVYvyJprS7sfj0041/t3J2YZS/8O6o1/Fb9Dqa
         o9NrZvYUQWK6kPX2qRQMldK5SqMF2Oe8YJaulxJqhJoYcBVqfGEOsa+PPKXIzp0ls5jp
         wtcUEv6KCobzaBdP6dFLtusp+wguapxqERB8QVjGhfxdZ5iboaRerOWLWrOvTGLKARa+
         xhfg==
X-Forwarded-Encrypted: i=1; AJvYcCUtoiHcZ4pIDCsS0+h+W9xxTC2MabRz/iihF7Ma0FFWnffUbAe3PZ0MLLBKoHdeTD8RzpmnjDZZm0cfVbabXx+81OE2bC/rMV0=
X-Gm-Message-State: AOJu0YzQ4I4j8Ns7mIzbhuTQuNd3NDG6FmkhdgC8eyNuiX4pYRVK5nS1
	AXZATOHvjott9purb6L1CF+gAc3n5sXDaN0Dp8s+uHIwlz2F6M51
X-Google-Smtp-Source: AGHT+IE96AQXtagaY64MfO5Zd11DF31wJGvFJ2Sa8cgZfOpF52Qy+3pmg0eCbUUCW8Z467MY7Rf6LA==
X-Received: by 2002:a05:6402:c43:b0:565:59a:a103 with SMTP id cs3-20020a0564020c4300b00565059aa103mr4173648edb.33.1710520220196;
        Fri, 15 Mar 2024 09:30:20 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id p8-20020aa7c888000000b00567fa27e75fsm1820762eds.32.2024.03.15.09.30.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 09:30:19 -0700 (PDT)
Message-ID: <62daf66f-39b9-4458-a233-2db2553c784f@gmail.com>
Date: Fri, 15 Mar 2024 16:29:14 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] io_uring: get rid of intermediate aux cqe caches
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
 Ming Lei <ming.lei@redhat.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <0eb3f55722540a11b036d3c90771220eb082d65e.1710514702.git.asml.silence@gmail.com>
 <6e5d55a8-1860-468f-97f4-0bd355be369a@kernel.dk>
 <7a6b4d7f-8bbd-4259-b1f1-e026b5183350@gmail.com>
 <70e18e4c-6722-475d-818b-dc739d67f7e7@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <70e18e4c-6722-475d-818b-dc739d67f7e7@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/24 16:25, Jens Axboe wrote:
> On 3/15/24 10:23 AM, Pavel Begunkov wrote:
>> On 3/15/24 16:20, Jens Axboe wrote:
>>> On 3/15/24 9:30 AM, Pavel Begunkov wrote:
>>>> io_post_aux_cqe(), which is used for multishot requests, delays
>>>> completions by putting CQEs into a temporary array for the purpose
>>>> completion lock/flush batching.
>>>>
>>>> DEFER_TASKRUN doesn't need any locking, so for it we can put completions
>>>> directly into the CQ and defer post completion handling with a flag.
>>>> That leaves !DEFER_TASKRUN, which is not that interesting / hot for
>>>> multishot requests, so have conditional locking with deferred flush
>>>> for them.
>>>
>>> This breaks the read-mshot test case, looking into what is going on
>>> there.
>>
>> I forgot to mention, yes it does, the test makes odd assumptions about
>> overflows, IIRC it expects that the kernel allows one and only one aux
>> CQE to be overflown. Let me double check
> 
> Yeah this is very possible, the overflow checking could be broken in
> there. I'll poke at it and report back.

test() {
	if (!(cqe->flags & IORING_CQE_F_MORE)) {
		/* we expect this on overflow */
		if (overflow && (i - 1 == NR_OVERFLOW))
			break;
		fprintf(stderr, "no more cqes\n");
		return 1;
	}
	...
}

It's this chunk. I think I silenced it with

s/i - 1 == NR_OVERFLOW/i == NR_OVERFLOW/

but it should probably be i >= NR_OVERFLOW or so

-- 
Pavel Begunkov

