Return-Path: <io-uring+bounces-7279-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9853A74F29
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 18:20:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBB2B3B5195
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 17:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC53DDDC5;
	Fri, 28 Mar 2025 17:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S6s+Ueqi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A631DDA0E
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743182253; cv=none; b=NdBdyEJ1+adkk9x39AHCU6Hm9LuX07fXswrNmQpbfrBxT4AEOWJrQiVGJ8+1HV4oq+swTDraZxQCkxNTbHYVgQN3y/fVsdqUMfNpnbLM5cipP6ZOFPFFo/vacg8DNN2McHFQEOCBDAjLebjZUjJMASH+8Baz4a9pnPQ1t9TMtEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743182253; c=relaxed/simple;
	bh=MMSoHF8K8evUlXh2bnms3L6Jpg+BgcGLAuu1sg+wuSI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=plwFvctCF2maLIff0U1ySYMoCqdgVk6gYPkCQvG5MzZ5luMILu5BHMI8YN/kFPj6aa6BY0zcHs2AbyFVoKKkPRpoqJJd9MKBVhGFCGCpDxs6soXP9zygkLylVKasjUbRTJMGzDx6TYC4X9QJbbGlcWI4yqTgceZGMc7kZaXc8gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S6s+Ueqi; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac2a089fbbdso433685766b.1
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 10:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743182250; x=1743787050; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pZMplH2Y8kOtm0nIS7sQEe2+Im4C9cst7jX70q8WsLM=;
        b=S6s+UeqiPxlH7AbTTy/JL4f0qvZlGqJBsMB9ETNt2aoRYXYcz67FINWdd5farxtOhL
         o+tLT7vNXE0tRm7st98QtFzFiBMfGonj5o2zPmAmcJHDIy0fQsEU/AcYCnkkNFtsMof9
         0PfFlLUHRyVfYvAf7ISRudr3DB5xpgFrEbCEsVIBOvuBoOJnJ3RqQF5ADbw1ALM0Adou
         be9wzt1k2bVHnz16ESe8j8etbqibQznxg+7V+sdBAtF0krgr1u1jNZktpGfONwZMTDZR
         s+7uYLrtH7O03eXosiIQn/msK9I+S+cgUO5B/gNhDBmymtQnohHGPbCtdQqxF7SWMd1a
         VRtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743182250; x=1743787050;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pZMplH2Y8kOtm0nIS7sQEe2+Im4C9cst7jX70q8WsLM=;
        b=tbKcFmFMBIhmt+2IPnJuSxsFpPjBcW57wBVpcACjXiwqNgjcASEAUAeQeTB6aB3RMo
         B/kw3zvqnZZvT4eUZGaUHvBGgGAuH8kFKk8MVZ4ZSRVGGH55P61oYeL06m17K5Z1tuPl
         GgZmKvW/+frHMtxckhghCSDi8lcb8/Dg5YphbDXRd/VlwY/vWHfhzFQv77P81Uv9gILg
         9RCxw6DOoa8KsdBseDXTlCZljhaAxnqtKfuiIkE2MluQ/iaexO1lCHG4baUdfWZP19fN
         bJBvB53oWmSKgz/cSstD87XYeQW1vJK2OiHMyUlkipReoD/0AX9omyKivuPosFkDIcvO
         yISg==
X-Gm-Message-State: AOJu0YzDTRAbsu9IhVN/1NNAK0BSM3H8Bu4A+OUQbKqMFKaD4iPzOw7U
	9MXlSYJ4Vhs89jzWLz75WkmQZFJgVTI2H8IojbGNzZPYRna+pA4X
X-Gm-Gg: ASbGncv1CRu6I+1k5dUZ/a+Q7uZyoUAUuIAwwfRV2bm0uZEW/pehPx8AyxUSNXSyIZH
	YiCMtvG9hMwPfN4V2uYq74LE2N0c2ibTyuetuFs531XbGZRy7mUb3dv1lCWnwn8Hu3xhEqrLDv/
	HQblEpP6zDedKXFsl2NN9k0RV6Sv+nPLraph12sEZZwMYmdgdbrk9zd0CDAuBmCjP6IHREzkquE
	weNxitkJVXVILTGJ+ufQqiCmOwtY3Qkyjxswojh0q1nsb50s3y94fnbja5eW9ChSFfrY1BeGuIX
	oR1ieRSkcF2nHzTISN6C2ebcE1B9xct54nLuPVX36sIgYNmJGg1voDI=
X-Google-Smtp-Source: AGHT+IF4lCS9f+WkZ39nu+qt/sjy4/XfuKyaCbisgF7Hpf6BmO4Xh6zFMW65NSVcjuKRPID2geJ3Pg==
X-Received: by 2002:a17:907:3da7:b0:ac3:cbbf:1d1b with SMTP id a640c23a62f3a-ac71ee5959amr281949566b.21.1743182249659;
        Fri, 28 Mar 2025 10:17:29 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.129.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7196988edsm190501366b.145.2025.03.28.10.17.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Mar 2025 10:17:28 -0700 (PDT)
Message-ID: <e5cac037-f729-4d3a-9fe6-2c9ba9d55894@gmail.com>
Date: Fri, 28 Mar 2025 17:18:15 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SOCKET_URING_OP_GETSOCKOPT SOL_SOCKET restriction
To: Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>
Cc: io-uring <io-uring@vger.kernel.org>, Breno Leitao <leitao@debian.org>
References: <a41d8ee5-e859-4ec6-b01f-c0ea3d753704@samba.org>
 <272ceaca-3e53-45ae-bbd4-2590f36c7ef8@kernel.dk>
 <8ba612c4-c3ed-4b65-9060-d24226f53779@gmail.com>
 <3b59c209-374c-4d04-ad5d-7ad8aa312c0b@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3b59c209-374c-4d04-ad5d-7ad8aa312c0b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/25 16:34, Jens Axboe wrote:
> On 3/28/25 9:02 AM, Pavel Begunkov wrote:
>> On 3/28/25 14:30, Jens Axboe wrote:
>>> On 3/28/25 8:27 AM, Stefan Metzmacher wrote:
>>>> Hi Jens,
>>>>
>>>> while playing with the kernel QUIC driver [1],
>>>> I noticed it does a lot of getsockopt() and setsockopt()
>>>> calls to sync the required state into and out of the kernel.
>>>>
>>>> My long term plan is to let the userspace quic handshake logic
>>>> work with SOCKET_URING_OP_GETSOCKOPT and SOCKET_URING_OP_SETSOCKOPT.
>>>>
>>>> The used level is SOL_QUIC and that won't work
>>>> as io_uring_cmd_getsockopt() has a restriction to
>>>> SOL_SOCKET, while there's no restriction in
>>>> io_uring_cmd_setsockopt().
>>>>
>>>> What's the reason to have that restriction?
>>>> And why is it only for the get path and not
>>>> the set path?
>>>
>>> There's absolutely no reason for that, looks like a pure oversight?!
>>
>> Cc Breno, he can explain better, but IIRC that's because most
>> of set/get sockopt options expect user pointers to be passed in,
>> and io_uring wants to use kernel memory. It's plumbed for
>> SOL_SOCKET with sockptr_t, but there was a push back against
>> converting the rest.
> 
> Gah yes, now I remember. What's pretty annoying though, as it leaves the
> get/setsockopt parts less useful than they should be, compared to the
> regular syscalls.
> 
> Did we ever ponder ways of getting this sorted out on the net side?

I remember Breno looking at several different options.

Breno, can you remind me, why can't we convert ->getsockopt to
take a normal kernel ptr for length while passing a user ptr
for value as before?

-- 
Pavel Begunkov


