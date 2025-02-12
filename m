Return-Path: <io-uring+bounces-6364-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D18D4A32B1A
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 17:06:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 781EF163199
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 16:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9A7D1B21AD;
	Wed, 12 Feb 2025 16:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GYnENakA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244F11D9688;
	Wed, 12 Feb 2025 16:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739376360; cv=none; b=RxugnQKQw+PTS1AJGFyzNeHonrUGn4pajffVDxhil8cPUZZA1ONkTsTkPE0djmjgZQ5QoZBk7dGlPS1u0RZ7ZkSlKPE//w5B0XITsoPWXk++gz7NBSyiytTs8NFytKr+3nWRoPABSSn2gQ0WbWZay0c6kJ/ydFg+8dntNVgkBLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739376360; c=relaxed/simple;
	bh=4zT98nURrcYCSnu/QAr0HTaGSn7Qs/AkdT74plg5IyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oTqnwA9Hq2gF0kWcaN8P2bc1EbFkgSwSCc355Fnf7+E4+CM1q1sHRChSIPiyzUzs1uGIliArt1ttjzG+y0bg1sk32HyEsZ2MYZcUieKQ3Wt9lZjKTpQ/MWOygGV7M/9LsNX6ehxZpU9TkX9Ar7uencMX8tHtR2UZQ2xEBLuPQ8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GYnENakA; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43948f77f1aso21657575e9.0;
        Wed, 12 Feb 2025 08:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739376357; x=1739981157; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5Bh/Lzvv0T2Z2sVmiPrfAZTD+pCnZOjvNxqCAuKSISo=;
        b=GYnENakAx5cHEmBAiF599JOn/tYRAM1wCbjMsMjPSJotIdhS2l4yNqq+oni7PEljVZ
         Ss0T7GGAFZFw2VgslUxY1HB2AJpMi5PBoiQ1HSyDqsqQPXa7wiI7fXEFKjQnnhBkI+1I
         yrKC/GWHBo5SjkdvIKbZj343EklPrRuZNkjQSxAcx8bW2kI9/8YcRgeuij433sZrTud2
         TCiLebvoG/cG3wGrQeFrZvdbflyLDHJc/lBc6pshjXhM3CJL5+41y46qJn6Rb3HYGIeF
         TZWI8R8bBYOtM8YcrshiV7IiB3l7j5F+NNOYeJEXViyeBWaJN1Bueq/2eKzWsgdPMDii
         KGsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739376357; x=1739981157;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Bh/Lzvv0T2Z2sVmiPrfAZTD+pCnZOjvNxqCAuKSISo=;
        b=wuOxCUyNBAhIFPgtMmtlWKUSBLmX2oRHxpgXUcdCmK9eCLX25FB1bNcJ3g/4Agc5HS
         LrQjB89Qc7fawSrelUZazY6mZJwZb2QjR4Fb5B+gTFT3DUoWTRURqpFnHLCk4xjhocC0
         OUXSmiygdZuV4oz3x6dDqBjMQrA1FN/PqS8baq1vSrS1fFQNSs1ITAsK/CbbMK8+3Gj1
         26b9AuU/Z7urie6fPGSXQWYKOmp9CQnLXeZsc7K4Z5qeJt9D+n3cEh3gsY9WyH1etZC+
         mvkqGkIeZQm8IGppfIY3xzHtXgH+txud3PEOTSNRm+RCFZOCX5LwxgjL6MfEb8+cXH9O
         vyDA==
X-Forwarded-Encrypted: i=1; AJvYcCUT0pgWA2Q5ftEAiTpsg28qQGh5YDy5juTCzYGhu8NkS0pManeowFbGzRcEKQkwUGeRC1M/DVq8GuT0Dlg=@vger.kernel.org, AJvYcCWYjut5jE5U+Q4jKjyN3DP8jziOEzbzV3oZ1Y7aiDU+tDCTVHnltXrW5NNefE1p3HUjQqz/Nm0aIA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyIxcwwufEhR8YMKJcd4lpYoKkp+zYp0Rkvt2BzLAb2aCY5f8jV
	KduIv387639b1U3cAudgHLYSW7NaBYSqj1Zx2WFZOm00lizqJ3Fo
X-Gm-Gg: ASbGncs8/watKtdQYad05jw8SjHFnOVWMJ+6sVcyQhhClZG8F2rWPQNIe6Hi5Kj79Qh
	bnlXG1T0AZKeTFKRK70LSqMm9sxfXhQR9JEMOplUjpRN0HeaxujWoIToEBvOhYSciVs/v/J6BNJ
	jJavsavXFo+llQBUM1Wnw9+AVOOB+xVjDGmvcXz46C4SpO3fkUoH1gLIb+FbvQwgVrCoD+mXVq9
	R1g9j/okNVHAJxOytVuEm1H3E9kV9mIW+2nbPfg3qjOVsA3l+W3Wi81nJGT+qsBTaJsk6DWPSlW
	O55QcJjdSqXbQz3vkrgRwSDo
X-Google-Smtp-Source: AGHT+IG31S/oui78PD9y27yJzLnEClhwYcwqi+H4yOTKd6kKxoGUJ0oZu30c7ojakE/agJbP8QkUyQ==
X-Received: by 2002:a05:600c:4fc6:b0:439:5b36:b4e3 with SMTP id 5b1f17b1804b1-4396018484fmr800285e9.12.1739376356921;
        Wed, 12 Feb 2025 08:05:56 -0800 (PST)
Received: from [192.168.8.100] ([148.252.128.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f24094b38sm41534f8f.16.2025.02.12.08.05.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 08:05:56 -0800 (PST)
Message-ID: <7c2c2668-4f23-41d9-9cdf-c8ddd1f13f7c@gmail.com>
Date: Wed, 12 Feb 2025 16:06:58 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 0/6] ublk zero-copy support
To: Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com
References: <20250211005646.222452-1-kbusch@meta.com>
 <Z6wHjGFcFCLMnUez@fedora> <Z6y-M7cby-ZAoLzY@kbusch-mbp>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z6y-M7cby-ZAoLzY@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/12/25 15:28, Keith Busch wrote:
> On Wed, Feb 12, 2025 at 10:29:32AM +0800, Ming Lei wrote:
>> It is explained in the following links:
>>
>> https://lore.kernel.org/linux-block/b6211101-3f74-4dea-a880-81bb75575dbd@gmail.com/
>>
>> - node kbuffer is registered in ublk uring_cmd's ->issue(), but lookup
>>    in RW_FIXED OP's ->prep(), and ->prep() is always called before calling
>>    ->issue() when the two are submitted in same io_uring_enter(), so you
>>    need to move io_rsrc_node_lookup() & buffer importing from RW_FIXED's ->prep()
>>    to ->issue() first.
> 
> I don't think that's accurate, at least in practice. In a normal flow,
> we'll have this sequence:
> 
>   io_submit_sqes
>     io_submit_sqe (uring_cmd ublk register)
>       io_init_req
>         ->prep()
>       io_queue_sqe
>         ->issue()
>     io_submit_sqe (read/write_fixed)
>       io_init_req
>         ->prep()
>       io_queue_sqe
>        ->issue()
> 
> The first SQE is handled in its entirety before even looking at the
> subsequent SQE. Since the register is first, then the read/write_fixed's
> prep will have a valid index. Testing this patch series appears to show
> this reliably works.

Ming describes how it works for links. This one is indeed how
non links are normally executed. Though I'd repeat it's an
implementation detail and not a part of the uapi. Interestingly,
Keith, you sent some patches changing the ordering here quite a
while ago, just as an example of how it can change.


>> - secondly, ->issue() order is only respected by IO_LINK, and io_uring
>>    can't provide such guarantee without using IO_LINK:
>>
>>    Pavel explained it in the following link:
>>
>>    https://lore.kernel.org/linux-block/68256da6-bb13-4498-a0e0-dce88bb32242@gmail.com/
>>
>>    There are also other examples, such as, register buffer stays in one
>>    link chain, and the consumer OP isn't in this chain, the consumer OP
>>    can still be issued before issuing register_buffer.
> 
> Yep, I got that. Linking is just something I was hoping to avoid. I
> understand there are conditions that can break the normal flow I'm
> relying on regarding  the ordering. This hasn't appeared to be a problem
> in practice, but I agree this needs to be handled.

-- 
Pavel Begunkov


