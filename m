Return-Path: <io-uring+bounces-11713-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F6F1D20193
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 17:11:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DB744307C37D
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 16:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 226783A1D15;
	Wed, 14 Jan 2026 16:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CdR2i2cX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE013A1D1E
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 16:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768406705; cv=none; b=HxWGq6mOMpCpaxaEJI9t1du5AiUmZTe2ZCgEWJUiEslONppMwe7avlBJ9vRVQIBKDFdXqQ4PvjEWycp+dQW/yN4o17kGYBaL82n/JmblX5S5plxt4uFLCHgr1qWPR2YRBF+nGLShwufTRg5vjd1scOGeQErGHxfF6BIQpE1b4Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768406705; c=relaxed/simple;
	bh=qQDmUR4P9TvaZzWziSK5hVVtn0Z12bE9Y/rKtgOhbto=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=KnpZYnPvR8+wQCFv+5CZ8QgVyVYE/+Yh75p0OrOX/HFHRaY8dRqipvdaRjW7i91IVc4VVvcMp0KBs1cnuYf27/sS9+7Ei2Dm082H2vyv/v61gL09N4pRPniyeLcChhbpOqDwFQbEfrZ6vFng0NhZm/L/yDYUnWL0cXvn+91zXvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CdR2i2cX; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-477ba2c1ca2so97657315e9.2
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 08:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768406701; x=1769011501; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nx4cso8JKXz4+IkdqytKL9xo1PB9+mVGs/GL7KoflBE=;
        b=CdR2i2cXXXI5TwhRR9KppjzVyxBUD9+8EwHyANVJjdt5tbmQPrhHsYiU7GNWSyOA4R
         fYZ9hb9eBbecRRaPtIGLPz7257ObH8FNCprC9F3dXlL3HzdPTF8dvDucKhnb34gOXbiQ
         q04KBK2rA+V9zJIUL2UdPuCJmvVcs0V/an/Aj9teUK8TXvASuhPEvoBgnGlsSgcMU7G8
         EP3vomgjKHEv1UJJE/qiUW40Tk+LWHx7rD3gtPiNa70fvyvmDYsqAtpuZgkz5KioSj67
         h1AsRAhTXbMC5iMTvhZnAuwPEYFGrEGqTFQ92VoFcfNTJh3P3wL4pmwYS8iVtt+swgWn
         afuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768406701; x=1769011501;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nx4cso8JKXz4+IkdqytKL9xo1PB9+mVGs/GL7KoflBE=;
        b=A1lW62VKmBNH+3IVdUZ6jAEEFM6oSvS2HplZQjjb6KP8OR3i6Z8vPNv+jgIUzgPWe5
         mr8H1jSVxkA+LE7c8KtAthKKVVyDqi9o6GWe0MeewYajfDFk1y/0A/b5PHYR5h7NmavH
         Yy4ms4tB5rLzTKZlozIYpuwqOtAWaCD9r+Wb+Z2Up+RkVrMnuSvBmKOHCXXGtesB0kb2
         Es29DCrn9bHVeY/cFYAdN1h5Q3ufcnAord/fgGqqi939kW3aL8P/W1WvnOciYffrn0Zw
         7TaqnoR9xR8ZbLOkKUHPfptl3Czc+rubqFTtGUlfuj17N7QpRcJUcv0sExsPG1c1xkbh
         ZiDg==
X-Gm-Message-State: AOJu0Yy9SNf6C72NjKPZ4ggqAebkAXYHGvx2JZrGtWtZdaOG4IQg2kGj
	k8inxpw1wzZviPFdnrpaXOXV4s0tVQTQ/VHe73rtFP8zAtXFAY12JEs2
X-Gm-Gg: AY/fxX64CQS2BkhB5caihdSojfUNZqtPpK3zfZ5fgVr4d3u2DDVQu6009qMZZAVH9sQ
	jrsvl2yTjsHtpTYiXtXldOVPcGQ9955XM1lcFpEH1R0dz6EKfWo4pulFtS33bu5gDRH7ZVlQ2IE
	jq9y0VzzMveBlW6TieZBAyLTw4yDgGrDD4za+VY6RHubuoxXM5Z41RWu9kVFXOd2Vfm8BMigU9O
	2T77uVuqJECqQ0NJSyhb9x7VS36jDg3/5Q8QuEpaSmlZlNT4/uwvUEiL8/LVod9rxWtH5UUSGM3
	kh2xOaU18V/MV7RW77NzFSf661rSaXlFoLbC0d560lDUSrIgKBNfoquwfT93UMCoq+wBEvpWFP7
	dFhCcZl3HqPhJaHcmO0gYwUHttOvmm7z3SpBgolRwfhhL/NPucSkDaT7yxBmqdsbpK6Bx7Sru/T
	2rUqKt+cuUAoFGEKK5jbjt/Ska6JqoYVxZG7v8eqS29bD4/293pVTTW0Y/PGTbwvGQ5fQZr42th
	JFcD3Uzt/dqjl7Lgh59fyXyOzHn8K+xTaJLqCIDCDCpDQcFq7s9eHXmm90BVC6Cxw==
X-Received: by 2002:a05:600c:548a:b0:477:58:7cf4 with SMTP id 5b1f17b1804b1-47ee32e09b5mr36987145e9.4.1768406700341;
        Wed, 14 Jan 2026 08:05:00 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-434af6b2a61sm55266f8f.20.2026.01.14.08.04.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 08:04:59 -0800 (PST)
Message-ID: <c805f085-2e13-40ee-a615-e002165996c6@gmail.com>
Date: Wed, 14 Jan 2026 16:04:56 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/1] man: add io_uring_register_region.3
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <6ba5f1669bfe047ed790ee47c37ca63fd65b05de.1768334542.git.asml.silence@gmail.com>
 <87ldi12o91.fsf@mailhost.krisman.be>
 <d3a4a02e-0bcc-41fd-994e-1b109f99eeaa@kernel.dk>
 <9f032fbc-f461-4243-9561-2ce7407041f1@gmail.com>
 <5f026b78-870f-4cfd-b78b-a805ca48264b@gmail.com>
Content-Language: en-US
In-Reply-To: <5f026b78-870f-4cfd-b78b-a805ca48264b@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/26 14:54, Pavel Begunkov wrote:
> On 1/14/26 14:42, Pavel Begunkov wrote:
>> On 1/13/26 22:37, Jens Axboe wrote:
>>> On 1/13/26 2:31 PM, Gabriel Krisman Bertazi wrote:
>>>> Pavel Begunkov <asml.silence@gmail.com> writes:
>>>>
>>>>> Describe the region API. As it was created for a bunch of ideas in mind,
>>>>> it doesn't go into details about wait argument passing, which I assume
>>>>> will be a separate page the region description can refer to.
>>>>>
>>>>
>>>> Hey, Pavel.
>>>
>>> I did a bunch of spelling and phrasing fixups when applying, can you
>>> take a look at the repo and send a patch for the others? Thanks!
>>
>> "Upon successful completion, the memory region may then be used, for
>> example, to pass waiting parameters to the io_uring_enter(2) system
>> call in a more efficient manner as it avoids copying wait related data
>> for each wait event."
>>
>> Doesn't matter much, but this change is somewhat misleading. Both copy
>> args same number of times (i.e. unsafe_get_user() instead of
>> copy_from_user()), which is why I was a bit vague with that
>> "in an efficient manner".
> 
> Hmm, actually the normal / non-registered way does make an extra
> copy, even though it doesn't have to.

And the compiler is smart enough to optimise it out since
it's all on stack.

-- 
Pavel Begunkov


