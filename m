Return-Path: <io-uring+bounces-7269-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D08E5A74D45
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 16:02:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6D031899BAF
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 15:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D84CF4409;
	Fri, 28 Mar 2025 15:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mw8ewJtl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A5279E1
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 15:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743174129; cv=none; b=Z7z7KbIzKncj8nY24N02CPXx+GvbJ7W5ssrHWk79lun5YoHPWz9j1rOwPOUMbVT75xdd+PwM6c9RbdJKXKZhxZ+iBb/Z1NYo9s4Jf1pRQ2FghsXqTtd/7lePQPRYxpk06+x6X7m6NfkawjFeiahRmLr3aZ9me/AUwgCoGv3YOIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743174129; c=relaxed/simple;
	bh=XTSsXcFannF/BIxQtZL4nDPBbbv+XAq0RPc3PNZRuV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LwsjV1G++731fSTPpfzn18Y3PR6XFqmbfF2LlLMOPq0t5XjbsiI5K0m3/TIgRJPeNej2/EIAyi8JihduiyDJTA/CgRbS1J8VCB1BL5FdW0dCjrAjvZ+7UtzOoxGIMd7baXJIMmLdT4u59GSN+JUItg9VM4TI1QMkd4h7nZcENv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mw8ewJtl; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ac6e8cf9132so390152466b.2
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 08:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743174126; x=1743778926; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3ByANrFK5N4KC13Pk9VM7QdpX0qYk8EWhkB9LzZPrLk=;
        b=Mw8ewJtl4jDz9Mcj6LBx+rK4QSTeGKP2QrxdQHUhK6q77BPKbbd2lRxYxneQAYlgBq
         18pJUb5bjOMEWQV7EPo9BvKh0VlkeHgeyLaii6Wu3yne+EiTpDKBZIYCcoba8Tj55cVU
         zkF0mvh7tWCMkPEHix+I69I1rJI9/bIdrDBr77QXX5EaRkRoz9UCI8LDEoEu5SGoCZHD
         NIiMH9gpeS2TB8D2ff0UnpClRupMZsJGUfnyPOSTBcJI0YlOSHA4xXR58fJeFknAbfJv
         8c1pqgwGCRbWLvbfR+9ExVwqWYaIJV+KiBH18g+MlCnqIz0/bI8biwXAo9NHvGeQFZ2X
         zs6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743174126; x=1743778926;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ByANrFK5N4KC13Pk9VM7QdpX0qYk8EWhkB9LzZPrLk=;
        b=EYsyXrz2SJl+fofXDBASmqdKjI/hUg1Dp5/n+GQOSitxuySKnp/dho2GwrqP1Dd7fd
         9/7MXjFyKqbTNVnDjgljTrWN4ym+/3a8kegcJ8PYD9jyiceUj5XG/+l77xMHZmB+k8BV
         3SFpngpBkSSRG7vZfA8QE6ArMhF8PVqLi2OwSfA6lk2Hrqjn4r/sy6jqvd8BF8FICUUN
         0RS/EBf7XGPLNc05VVhnzRJMj+I6IqtgZjSl1yLaU2c9SMgrUGenq3+nMVt41CYyhLp8
         1EKt/aiLMd12oRS5nlC1J2hAqqPM71iIrK9MRpyADAhc9ZbSDTtH70ESUwGLipgayIYt
         N9NA==
X-Gm-Message-State: AOJu0YwOtPPhMEmIXfW2JAzcu/LEPad5RiNWqPR9uUbeq93/LqFYuNdx
	3VIabRHXRoMcYoo7G1iyXF5MN3iFFNC/l9bNwUnbm/MSDDw/wVkQ
X-Gm-Gg: ASbGnctqjPaTc/3pPLGlVu97i5QhPQ+jhpPPCE6IClDMukFAvUu87C87DNHZ5WJ3U7b
	EYyGsdLiknMBT/Bp0qPsdta2S6xP3zsoVCg0vk4skIAD9dW3BvyoBdHt0U8zMCjej00Adp2OZiU
	h8/6Gd4DV8n4Ln58JZeZi61A3TGnFVFI1J0gSHyEDXmyjM0FcQfyOwdggfJXU+5e1J1brfei1fB
	rcjnLzvT1h13jL7fEbWi66a0QoJjSoOBvLD8U4N1rajA4+yIU/3UyTtrZ3GQtpuOubNmkN5G1o9
	UqO3jd9Kc3P9rNERTLah4/aDUXftndV4VksYUni0QQ4RZGipQ1aiv/sa2dBZi/S7HSg=
X-Google-Smtp-Source: AGHT+IGPprN2SP0gaCxi4Crjo08pEHE6ylqx6OcFWb8jzng7sxsOSVDmpSaykYf+LhKtJkhCNHLH7g==
X-Received: by 2002:a17:906:f58a:b0:ac4:491:1549 with SMTP id a640c23a62f3a-ac6fae6d0b3mr781614566b.1.1743174126047;
        Fri, 28 Mar 2025 08:02:06 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::ee? ([2620:10d:c092:600::1:f2cb])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac719220358sm171525966b.36.2025.03.28.08.02.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Mar 2025 08:02:05 -0700 (PDT)
Message-ID: <8ba612c4-c3ed-4b65-9060-d24226f53779@gmail.com>
Date: Fri, 28 Mar 2025 15:02:50 +0000
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <272ceaca-3e53-45ae-bbd4-2590f36c7ef8@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/25 14:30, Jens Axboe wrote:
> On 3/28/25 8:27 AM, Stefan Metzmacher wrote:
>> Hi Jens,
>>
>> while playing with the kernel QUIC driver [1],
>> I noticed it does a lot of getsockopt() and setsockopt()
>> calls to sync the required state into and out of the kernel.
>>
>> My long term plan is to let the userspace quic handshake logic
>> work with SOCKET_URING_OP_GETSOCKOPT and SOCKET_URING_OP_SETSOCKOPT.
>>
>> The used level is SOL_QUIC and that won't work
>> as io_uring_cmd_getsockopt() has a restriction to
>> SOL_SOCKET, while there's no restriction in
>> io_uring_cmd_setsockopt().
>>
>> What's the reason to have that restriction?
>> And why is it only for the get path and not
>> the set path?
> 
> There's absolutely no reason for that, looks like a pure oversight?!

Cc Breno, he can explain better, but IIRC that's because most
of set/get sockopt options expect user pointers to be passed in,
and io_uring wants to use kernel memory. It's plumbed for
SOL_SOCKET with sockptr_t, but there was a push back against
converting the rest.

The implications are not the uapi side. For example, io_uring
get/setsockopt returns err / len in a cqe->res. We can't do
that for SOL_SOCKET without the kernel pointer support, otherwise
io-uring uapi would need to get hacky. E.g. you'd need to
pass another user pointer is an SQE for socklen and read it
after completion.

-- 
Pavel Begunkov


