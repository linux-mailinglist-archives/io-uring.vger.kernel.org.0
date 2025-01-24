Return-Path: <io-uring+bounces-6116-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16C73A1BC41
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 19:40:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E760318867C9
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 18:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F22F41D88BF;
	Fri, 24 Jan 2025 18:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="coVV+ZPW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158BC1DB122;
	Fri, 24 Jan 2025 18:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737744023; cv=none; b=HOcFHdvb9Co5EjTMIWJKGpokIyAuw/wwr2bfMBY2EWbuWqc/+6IuCPTUrQlO7EoKTB+OjHqQYZKsM8Q5QCH1RO3FZzz4BNmicTePpRarZ+Fe0bpjajSjLCC8jpLTNI4812RlUp1dUcOG2srE45uRCuS3HWxE+OvOGUuYavK10MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737744023; c=relaxed/simple;
	bh=Jn4sq8QYfDDdqZjleFzmMkjSek8LxhH2w81Sql2/Y+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I5eOXI17aTDcVuUIrnMu/2sOQ0mEqqDGQrJknhwVMTyGK/9gtja6uvgILn8xX4bcJyovKV2+d2jc9Y1+t48f8hRuXWWjgMdkaGXCPPdd2DuZjSExXyB2RWFGTLrqIyiyYg4a1admq2p8hPjxhi/VfROFchavFOmuHH3lsjGKup0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=coVV+ZPW; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4361dc6322fso16678665e9.3;
        Fri, 24 Jan 2025 10:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737744020; x=1738348820; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KdA+LLz7Vq6hdgYs/uajeJJwJz783s0a+wxdJnlffCQ=;
        b=coVV+ZPWAaWakACgKaAmaK5U1oKbLeFXoVfLO352jdT3pwFqwbQrv1I4XK1m/Cmkv4
         WejjiAxG7fEpoxIboFtSjyCHFiu6xWOn7Ir19Jbj4Ssvub+Z97ZV7pQcBB7sVsEEOSeR
         GWGL0zad4LYY5mLi/PO86BdTuNMWMIj2vXbJV7lN+1ccbdu66ASvMOkvInCZm3cPCp6U
         o9h6jYvAXGrZy4Z5QJVK2fiitzpc1x0yIHVbJ+WX8yCQZlCqIPyghXGLuWn0dA2wcBUY
         TCdG1FJQJs1nBVNQYVAx5/pDk1tGtzBJjppaXfmhCdzlu9CR2JImAe5+vfrl/dAKkz1u
         LAMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737744020; x=1738348820;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KdA+LLz7Vq6hdgYs/uajeJJwJz783s0a+wxdJnlffCQ=;
        b=feZqVlc4yebEa5bhYyrubd9IQ79euP98i/HbUSOJd7hTs+YUQnJtwlWRSACvv9HaXs
         G4cef/1hNMhzf36D86nj+q4lJflq/T9u2iPNt0pHUc2+TK343MzXzB02n1tH64vdqwEW
         l+uWWLNRlu+K08j2yoyYPY81hyEIv0oHZsGLB+Hlg3ZV2OpiVWlGXhG9SJ41Z8ctmD/x
         S2lkhBCuPGnndTyjavpt91f4Tvis5GOXSRB6Nc/8Bg3BCImMMDN1/d1gfoj/j1j9M9/f
         NlCoug8gpp720Yjsc0C9HN1kJjkviC6ymer46IriqM7I26nHxzWd9ywUvQ6D4fGNMjDm
         itPA==
X-Forwarded-Encrypted: i=1; AJvYcCVgc6jHF1+alSDX2tAk3z4KopttX7nED1RtqR7m2SFX1KVcY7DrXvlfZ0Rvs/ulOYyM3pV3P1jMTw==@vger.kernel.org, AJvYcCX9Ua3cGT3p3+SZDz9keHNRSw/PJKzvXdu2a5XUAK7FwH96kMTEVAXhC9ZktS8YYMp38dIrzbpKWd2suabS@vger.kernel.org
X-Gm-Message-State: AOJu0YyXfGP05I2daQqv0KRnN5aaMTyuFux9SozxdycNx6HT/FlpNYJf
	jvRQFrEpEpy5LMiyKi4vxWjGl2l9eq79ZhywynYhWXy8sWAt/i2F38D0Gw==
X-Gm-Gg: ASbGncsKQyPn/jUBWHlOqhjzpqNklYTcS/jOMtrqAw4hJRs5RqnEQaI9jhSANZpj+dH
	XGrrf/ld7vTG2Wj9Jbuwb2LOfKy7wNoLkn8hasLvoUZ91UiiYm4v43O9upvWWN+CBP9v1mFC3Ab
	+OMsalNTFyEThbxyJrs8qqPyUwLwo1bi0fv2lOGEK9thgWEktg07yll4JvFqNL2vrnwhmHvptH5
	PaGoIGpY/372MvvJyzXGU+Qr0jPMrDOGzcwFDhX2kUxpM3Jn7rn2+6UzFs39bYIst/suNxTUqxr
	oJJtYdayuDm5lg==
X-Google-Smtp-Source: AGHT+IFSb5JjSPcL0vlCdzIoe643xrylFtZY8KwIa+Kyt45vClxULRJwU55cC815zmNeICSY9pj82g==
X-Received: by 2002:a05:600c:1e02:b0:438:ad4d:cf09 with SMTP id 5b1f17b1804b1-438ad4dd134mr161851565e9.9.1737744020057;
        Fri, 24 Jan 2025 10:40:20 -0800 (PST)
Received: from [192.168.8.100] ([148.252.128.79])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd4b9990sm37046365e9.29.2025.01.24.10.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2025 10:40:19 -0800 (PST)
Message-ID: <8af1733b-95a8-4ac9-b931-6a403f5b1652@gmail.com>
Date: Fri, 24 Jan 2025 18:40:51 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug#1093243: Upgrade to 6.1.123 kernel causes mariadb hangs
To: Xan Charbonnet <xan@charbonnet.com>,
 Salvatore Bonaccorso <carnil@debian.org>
Cc: 1093243@bugs.debian.org, Jens Axboe <axboe@kernel.dk>,
 Bernhard Schmidt <berni@debian.org>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <dde09d65-8912-47e4-a1bb-d198e0bf380b@charbonnet.com>
 <Z5KrQktoX4f2ysXI@eldamar.lan>
 <fa3b4143-f55d-4bd0-a87f-7014b0fad377@gmail.com>
 <Z5MkJ5sV-PK1m6_H@eldamar.lan>
 <a29ad9ab-15c2-4788-a839-009ca6fdd00f@gmail.com>
 <df3b4c93-ea70-4b66-9bb5-b5cf6193190e@charbonnet.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <df3b4c93-ea70-4b66-9bb5-b5cf6193190e@charbonnet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/24/25 16:30, Xan Charbonnet wrote:
> On 1/24/25 04:33, Pavel Begunkov wrote:
>> Thanks for narrowing it down. Xan, can you try this change please?
>> Waiters can miss wake ups without it, seems to match the description.
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 9b58ba4616d40..e5a8ee944ef59 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -592,8 +592,10 @@ static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
>>        io_commit_cqring(ctx);
>>        spin_unlock(&ctx->completion_lock);
>>        io_commit_cqring_flush(ctx);
>> -    if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
>> +    if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
>> +        smp_mb();
>>            __io_cqring_wake(ctx);
>> +    }
>>    }
>>    void io_cq_unlock_post(struct io_ring_ctx *ctx)
>>
> 
> 
> Thanks Pavel!  Early results look very good for this change.  I'm now running 6.1.120 with your added smp_mb() call.  The backup process which had been quickly triggering the issue has been running longer than it ever did when it would ultimately fail.  So that's great!
> 
> One sour note: overnight, replication hung on this machine, which is another failure that started happening with the jump from 6.1.119 to 6.1.123.  The machine was running 6.1.124 with the __io_cq_unlock_post_flush function removed completely.  That's the kernel we had celebrated yesterday for running the backup process successfully.
> 
> So, we might have two separate issues to deal with, unfortunately.

Possible, but it could also be a side effect of reverting the patch.
As usual, in most cases patches are ported either because they're
fixing sth or other fixes depend on it, and it's not yet apparent
to me what happened with this one.

> This morning, I found that replication had hung and was behind by some 35,000 seconds.  I attached gdb and then detached it, which got things moving again (which goes the extra mile to prove that this is a very closely related issue).  Then it hung up again at about 25,000 seconds behind.  At that point I rebooted into the new kernel, the 6.1.120 kernel with the added smp_mb() call.  The lag is now all the way down to 5,000 seconds without hanging again.
> 
> It looks like there are 5 io_uring-related patches in 6.1.122 and another 1 in 6.1.123.  My guess is the replication is hitting a problem with one of those.
> 
> Unfortunately, a replication hang is much harder for me to reproduce than the issue with the backup procedure, which always failed within 15 minutes.  It certainly looks to me like the patched 6.1.120 does not have the hang (but it's hard to be 100% certain).  Perhaps the next step is to apply the extra smp_mb() call to 6.1.123 and see if I can get replication to hang.

Sounds like it works as expected with mb(), at least for now. I agree,
it makes sense to continue testing with the patch, and I'll send it to
stable in the meantime. Thanks for testing!

-- 
Pavel Begunkov


