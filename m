Return-Path: <io-uring+bounces-11223-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D53BCCDA96
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 22:18:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 33749302ED80
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 21:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB9D6296BDB;
	Thu, 18 Dec 2025 21:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Hmc1ZZRx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f67.google.com (mail-ot1-f67.google.com [209.85.210.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0032BDC03
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 21:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766092735; cv=none; b=u0LdllUJStnwIJqi/EusnCsMGQXiG9uIIAFTVVP90br6tsvJno/lADOn61TdErMpcHG4CfYjfJAIXdT4E+Y7O2cQSjakIj6WkkvBnnys1CJxxAc4+9FXzZXvx7TJP/3pIsnYik3gAViiUf0MXKTcrqWyM3+yT8DvACiBKeuzQVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766092735; c=relaxed/simple;
	bh=RhOEEMWeBR2NrmvwByQcIXLGBf3QLOVJPYB7vjo3TAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jwwdcM8guRdQTn6GbXKMIoIGKh1IFqaGwgFHuHifW4bSLC8crezyXmmY3pWzt5ZLB74LsHYfmEYQUctDAkuRpLdFN4xrN8w9wWwnYrWRcUXYvbB33mV21BLWUBEgteFvacz1pv7aJMX9YIuFMGtkzCdqYXxgh1uKOpicaAXIxuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Hmc1ZZRx; arc=none smtp.client-ip=209.85.210.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f67.google.com with SMTP id 46e09a7af769-7caf5314847so706111a34.0
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 13:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1766092732; x=1766697532; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZhC2CbqMJRNT4ZU/m5rZ+f9MoR9/53yP9aHufxjViRE=;
        b=Hmc1ZZRxaAkPwdMEmQ0P9SNdZ2RAaF3oU8GbfR8kvl4QzuRe8wDlUFWBu8b3m6L4yc
         q4fFeLemYOSbT0U3NUNw1Kk7ozDS79Fl9U/x2deXKHVUNCxSyG5a/lZ1xu2wOANRRX63
         XLzw8mU1QtsXnG/3BmTq3gbDB2lp1JKejf88nsXeqQ8PE3049HjJYXgDrQgn0iQoLrZP
         n3JqbODcHbZ6nPq/scpWyPrBCZvur4VHxxcChEgfRndD+wsFcWHTgMZz0T3KdsL30DGw
         4VAwazATlTjpdA4CtOVummTWN9EmcouFaoWu6rk4yY9gQs3BnFR1JXwjAcUcMH+F6rQ2
         KdcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766092732; x=1766697532;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZhC2CbqMJRNT4ZU/m5rZ+f9MoR9/53yP9aHufxjViRE=;
        b=DbnXPsNHPXLEnxBI0rDxTvpoB/MZGss7QCQJD/w8lDQ190+3zoKpAXxSy9UrZ3aIKZ
         JOPVaA7+cWZLFLtt6tnVgkns0xJd2Jry/Rq0hY30nuGgSG57G4fPdU2KQESFu74WEMAW
         IUXL3NSlqJ/qYXGAge5YpUbfMWBbOtFYQ9J071m4ADwRgEXjGY2UZYMhMR/eHi9+lKZC
         MoSJPiXHTsaw8W+DtnJZrwT8SfVlbuEUvvUxT7UU6XpgMd1+nAoErDP+i0E96QeeN61B
         JYoMuKcXwTAt1sUHjySDWuxeWmOskGUeKrneeUE5ijYziF+19qO8igY764yw/PU1sgcM
         HqQw==
X-Gm-Message-State: AOJu0YwK8HXKifACkHt8aZ6YhPaETcNZ13Tz1dUAcaI9MnzyZ2bvbpEf
	TwjSK0gSUMMoi1KlAX2+/CRXC3338i7G4EgKk54yfJSeMiWce/J/I31wKVviZ3FiTlgxWdjXLTe
	IN07Orm37aA==
X-Gm-Gg: AY/fxX6Ii1P6avkmwLa3BbqKMw/Cjx6tLEBHPcf2IaSZs6nyS7VLNAqfnUIIZazb704
	qXUdA1uHKZcBRCMFJ8SHrRUnH+3MPpyB/4/gTfpqrkZ8grM+OcJUhG1cLzZX/8ctVkgnLvd1STA
	T4WZNN2OuQKetYLm/5SjSBSa9XknQ6JHir2+xZhG+PFOiHv/EDp+yQJIAHjrBqQJIa38ytBqRsH
	XMgKrgDLWHrujTPyqoZtXH8ZWT8fsBCmMd3mHWQLvjC7xjUKZxVIZ1EFy8rZhpTrh59m5Q88yvi
	pIPWfLFvbEKgiCElkR/VnEJojJPytu05SG9zkYSVDTfjkLLbhcuhU03wX/ebD6X4Xn0evdRg2Bd
	LuI5YF1uQL2HLCB2pRn02qMe8UJsswUgBzSAU5cRYoPTDlushuo73rMS1w8cHeH2spvY6Zbj5yF
	wo/vzdx2lXRa/0xsEHguI=
X-Google-Smtp-Source: AGHT+IFMNG6QuMm04WSPEQ+o5Wdf5snjMsZNR47hVm1DJmrERY17Z8C2J7I/9B/wSXr1tvKICfXRtg==
X-Received: by 2002:a05:6808:1591:b0:450:474b:2736 with SMTP id 5614622812f47-457b2261c78mr539829b6e.45.1766092731801;
        Thu, 18 Dec 2025 13:18:51 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-457b3edb117sm160663b6e.16.2025.12.18.13.18.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Dec 2025 13:18:50 -0800 (PST)
Message-ID: <77e0636b-b7d4-4bbc-b4bf-a05bccb343d0@kernel.dk>
Date: Thu, 18 Dec 2025 14:18:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] af_unix: don't post cmsg for SO_INQ unless explicitly
 asked for
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>, netdev@vger.kernel.org
Cc: io-uring@vger.kernel.org, kuba@kernel.org, kuniyu@google.com,
 willemb@google.com, stable@vger.kernel.org, Julian Orth <ju.orth@gmail.com>
References: <20251218150114.250048-1-axboe@kernel.dk>
 <20251218150114.250048-2-axboe@kernel.dk>
 <willemdebruijn.kernel.2e22e5d8453bd@gmail.com>
 <2ed38b2d-6f87-4878-b988-450cd95f8679@kernel.dk>
 <willemdebruijn.kernel.164466b751181@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <willemdebruijn.kernel.164466b751181@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/18/25 2:15 PM, Willem de Bruijn wrote:
> Jens Axboe wrote:
>> On 12/18/25 1:35 PM, Willem de Bruijn wrote:
>>> Jens Axboe wrote:
>>>> A previous commit added SO_INQ support for AF_UNIX (SOCK_STREAM), but
>>>> it posts a SCM_INQ cmsg even if just msg->msg_get_inq is set. This is
>>>> incorrect, as ->msg_get_inq is just the caller asking for the remainder
>>>> to be passed back in msg->msg_inq, it has nothing to do with cmsg. The
>>>> original commit states that this is done to make sockets
>>>> io_uring-friendly", but it's actually incorrect as io_uring doesn't
>>>> use cmsg headers internally at all, and it's actively wrong as this
>>>> means that cmsg's are always posted if someone does recvmsg via
>>>> io_uring.
>>>>
>>>> Fix that up by only posting cmsg if u->recvmsg_inq is set.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: df30285b3670 ("af_unix: Introduce SO_INQ.")
>>>> Reported-by: Julian Orth <ju.orth@gmail.com>
>>>> Link: https://github.com/axboe/liburing/issues/1509
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>  net/unix/af_unix.c | 10 +++++++---
>>>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>>>> index 55cdebfa0da0..110d716087b5 100644
>>>> --- a/net/unix/af_unix.c
>>>> +++ b/net/unix/af_unix.c
>>>> @@ -3086,12 +3086,16 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>>>>  
>>>>  	mutex_unlock(&u->iolock);
>>>>  	if (msg) {
>>>> +		bool do_cmsg;
>>>> +
>>>>  		scm_recv_unix(sock, msg, &scm, flags);
>>>>  
>>>> -		if (READ_ONCE(u->recvmsg_inq) || msg->msg_get_inq) {
>>>> +		do_cmsg = READ_ONCE(u->recvmsg_inq);
>>>> +		if (do_cmsg || msg->msg_get_inq) {
>>>>  			msg->msg_inq = READ_ONCE(u->inq_len);
>>>> -			put_cmsg(msg, SOL_SOCKET, SCM_INQ,
>>>> -				 sizeof(msg->msg_inq), &msg->msg_inq);
>>>> +			if (do_cmsg)
>>>> +				put_cmsg(msg, SOL_SOCKET, SCM_INQ,
>>>> +					 sizeof(msg->msg_inq), &msg->msg_inq);
>>>
>>> Is it intentional that msg_inq is set also if msg_get_inq is not set,
>>> but do_cmsg is?
>>
>> It doesn't really matter, what matters is the actual cmsg posting be
>> guarded. The msg_inq should only be used for a successful return anyway,
>> I think we're better off reading it unconditionally than having multiple
>> branches.
>>
>> Not really important, if you prefer to keep them consistent, that's fine
>> with me too.
>>
>>>
>>> It just seems a bit surprising behavior.
>>>
>>> That is an entangling of two separate things.
>>> - msg_get_inq sets msg_inq, and
>>> - cmsg_flags & TCP_CMSG_INQ inserts TCP_CM_INQ cmsg
>>>
>>> The original TCP patch also entangles them, but in another way.
>>> The cmsg is written only if msg_get_inq is requested.
>>
>> The cmsg is written iff TCP_CMSG_INQ is set, not if ->msg_get_inq is the
>> only thing set. That part is important.
>>
>> But yes, both need the data left.
> 
> I see, writing msg_inq if not requested is benign indeed. The inverse
> is not true.
> 
> Ok. I do think it would be good to have the protocols consistent.
> Simpler to reason about the behavior and intent long term.

Sure, I can do that. Would you prefer patch 1 and 2 folded as well, or
keep them separate? If we're mirroring the logic, seems like 1 patch
would be better.

-- 
Jens Axboe

