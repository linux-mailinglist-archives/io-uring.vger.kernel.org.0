Return-Path: <io-uring+bounces-420-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73B1D830B5B
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 17:45:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BCB71F2240B
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 16:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE40520335;
	Wed, 17 Jan 2024 16:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mQgYYxBB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6462224D3
	for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 16:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705509907; cv=none; b=pxh9+wayMM8r/Zs5iJqel++ekt67lAF6TmtVBkQyq2u36PehufIQRddEG8oLFQbZ3bvXNRmKmDCWNM3eJcjBzcgKm/o0LmctgChuf24ArXgcp2m997Qb4W1LyFxD73Ygvk33h6ZNclEpfH5eWkRXaJfNhWvN/0CBmzK4lt1hSU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705509907; c=relaxed/simple;
	bh=kcGkY7l9P5DWB5Y3rj6bBkTdRWlHXyZ+DrN5ktQEOAw=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:Content-Language:
	 To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding; b=nSgGTk0z/xpGdxHRyG5s7CeUyxqR3od1OVnWTokdIoCnfFzb2rbd0wZD7WF81KNE0/OEiWNoX+38itu7T+RrwotzlNxb0cWx8rpnL6Y69ndYFdx24fZ1A7qXlVMCxapbtu6j+s00LHsBE1J7c9pZQ3ejYKvk3dYPRUQjs/kyLnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mQgYYxBB; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-360630beb7bso8328045ab.0
        for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 08:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705509904; x=1706114704; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ayaKfcoeTgKkePOxDKKHz15Pl4/Bpdp67EzYIoy5h4A=;
        b=mQgYYxBBKUmAdhuuxOlAz9onu2TBXeUSXDg+Q4mP78FUuebt5GiG9liyUxLU34dIZ9
         QB0DpOvLv5mN0cijntj4Rt7EZeThecxE9Odv9gx0cMJ0ZJlwS3JOJ8qZ0sVxh7yoA2HG
         ZaPIivPNP9mw3mZZNMM8wUtGQtl/kXTIKqQbrP2r3+5oLrcYGQpvNRsultKQzfQVkYJK
         z9HVL5IfCamXKj4qsjOfNiyrDKmacyNbIHfmZAD5YQVJ8vF9CBDUq1KkfXLaZBlSq4El
         b9kkq/N9Dmpmyu/tT3w7P8qEQ1mbIBZObS70nmGp5LkEhRURDEWvBNHxMrkhtFYxw+Po
         FzwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705509904; x=1706114704;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ayaKfcoeTgKkePOxDKKHz15Pl4/Bpdp67EzYIoy5h4A=;
        b=qPUViRKS3PHkFzqdZPtRLMPASz2g7P6LhbxAjrB/Lytx0QPs/4B1bkEF+lyuZYbqgx
         k3Ws6vVnfQN5JXANhiqII+oM+nMb/YF+13dB2ZQm49oYSdNtxAcCqf/cl5cThR6FakxQ
         qXXIMkc4LpOwMw4WvHZOI9pm0wBSiy20uwvIpy1JAE+EiBOUFsyNxtigMa9QvD4ab+Jl
         k9eGdWl5fPzy5k0ffWd9j/pBe3466f79cfyUpcA+16SiyJxhtE/ExWdxhUptwBVNribC
         1zURtAg2afCEkBk+gkSQQLj0K2YSVOa1Es4fKw/hjQ1X71rcPIAipCiU3XjBrw8erKdV
         Lqvw==
X-Gm-Message-State: AOJu0YzlnLcZuNckTl3ovbV0J+RoO5M8dNHeqaUgfPH600M53YGQUPDc
	fQJ/aigZPlJH67tW0fqprmUWVuplHcTjx4gFq5lh+UpnRTw2ng==
X-Google-Smtp-Source: AGHT+IHe4VTFJZuOa/UsjeY3rKqQiDrPENPUUTc59tZVReIEFUbhZILn6AANqQtsF6EmWfmZgzR27g==
X-Received: by 2002:a05:6e02:1bcb:b0:360:968d:bf98 with SMTP id x11-20020a056e021bcb00b00360968dbf98mr17012682ilv.1.1705509903802;
        Wed, 17 Jan 2024 08:45:03 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y7-20020a92d0c7000000b0035fffb69deasm4275276ila.81.2024.01.17.08.45.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 08:45:03 -0800 (PST)
Message-ID: <1f772dd8-e181-4ee5-a22b-03053bf0d69a@kernel.dk>
Date: Wed, 17 Jan 2024 09:45:02 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/register: guard compat syscall with
 CONFIG_COMPAT
Content-Language: en-US
To: Jeff Moyer <jmoyer@redhat.com>
Cc: io-uring <io-uring@vger.kernel.org>
References: <80eceef8-b2d7-47e8-9ef9-7264249dedbb@kernel.dk>
 <x49il3suf1q.fsf@segfault.usersys.redhat.com>
 <80491979-03ce-412e-b7d7-719f3cf18566@kernel.dk>
 <x49edegudwb.fsf@segfault.usersys.redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <x49edegudwb.fsf@segfault.usersys.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/17/24 9:24 AM, Jeff Moyer wrote:
>>>> @@ -278,13 +279,14 @@ static __cold int io_register_iowq_aff(struct io_ring_ctx *ctx,
>>>>  	if (len > cpumask_size())
>>>>  		len = cpumask_size();
>>>>  
>>>> -	if (in_compat_syscall()) {
>>>> +#ifdef CONFIG_COMPAT
>>>> +	if (in_compat_syscall())
>>>
>>> I don't think this is needed.
>>>
>>> linux/compat.h:
>>> ...
>>> #else /* !CONFIG_COMPAT */
>>>
>>> #define is_compat_task() (0)
>>> /* Ensure no one redefines in_compat_syscall() under !CONFIG_COMPAT */
>>> #define in_compat_syscall in_compat_syscall
>>> static inline bool in_compat_syscall(void) { return false; }
>>>
>>> Isn't the code fine as-is?
>>
>> It probably is, but this makes it consistent with the other spots we do
>> compat handling. Hence I'd prefer to keep it like that, and then perhaps
>> we can prune them all at some point.
> 
> I see one other spot.  :)  But if you are happy with it, that's fine by
> me.

I already shipped it internally like that, which is another reason why
I'd like to just keep it consistent and then we can do a cleanup on top
for 6.9 once tested.

>> Thanks for taking a look!
> 
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Thanks!

-- 
Jens Axboe


