Return-Path: <io-uring+bounces-8041-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D95C8ABAABB
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 16:33:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8B159E20E7
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 14:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 129A81E519;
	Sat, 17 May 2025 14:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uH6eXfUf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFEA4B1E73
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 14:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747492398; cv=none; b=ZAWIEgT3WIOHO6xfarJmsF+VakW3GrXQ9pjzmBsRlR2R7SGldLKimBHycB0yCZsJ72GR6gCv7RoOqJV9uGfxUTKrykRYwxTJIUb+/Ma+Q829IDRvcH2xHdQnGcjfyhCW9iXOGd7knZpPfOiKyh+Og98QBWOQIHIpYpoagXwJ1cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747492398; c=relaxed/simple;
	bh=ZiljTln8bGXG1pfz5crYSJuM17kEg9P+1JAQWzbgVks=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=F6gTUUBreWgLfdvkB3+KdDPH+hr1PJwt2UZaSt5hvBO+dAt3QpqmAYIcQyjIwK5MQiBX/H7Cut8jmdgZjMy9ZYR6QPOPdFfeCHRJAXlbkY2ZwBqmbuC4kyjIHU7+Ky6OYQlSt5xL1TkLx4mv1YdzMjfPg567cAl1ORPXMvo3WC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uH6eXfUf; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d812103686so9723155ab.0
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 07:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747492383; x=1748097183; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZPMDNVMsWm6T9RdR6nKCIAtbM+AcBMTaxWpg9iRovTw=;
        b=uH6eXfUfpZJO/OKUbpTSZ2JgegZpi3G7ESiBUBauXrTlvC3mBM5n/H4gS95TPyQNCY
         MR5wx7c80lIT1VGjTFPrAejkuaJEq3sE3L307bT3ySp7qugc7XtFxSzI5voCbTCVjKpq
         THPC1O7puZJIOYc7mspLOHtJ8I9oPOOGMf/9CR8DXc4foxtb5g7yDaO5pGD0X1Od4WrX
         ZEAQUnbhgmKk/8LVMPe2Hfz1fEtkd3wXP44ESTkj6md7GCZpGgvcndZc8JbBBSyIC6w6
         Hn+0c95IH4qh2Q5UUeIIwksRF3oBTcacX3yUTfUs/5SmUq1cvwJR/2AYDR+mq4m44+kH
         EoiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747492383; x=1748097183;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPMDNVMsWm6T9RdR6nKCIAtbM+AcBMTaxWpg9iRovTw=;
        b=EBUAduSBljiheqKq7ZKFL5OtJ7TwhXfl/tLJjHsZVnntBoWJBjBhKkuRFVo87G1l6+
         a9x5xRYkN6D1Zvj4D6Qe0oes0cp+RE7Wn6Z1v5Z4LqMKWQzS8uxe40l8qvdvv50ccp10
         b5Ar69Kgwm4RdtE8pf90WevH+b7/skdD2UObwDkx9eNcpbnvwn2wZqAaOUmU3SOScL0X
         5NoJwyD+scNOE8kyIX6WPLkyX7aOPrwkpMa9jD5P8JrqUNhQlzNHJ+/AbRh3DdCUWW+a
         qofauKPKU+WFzdV7t1vpjCcEAm/59qisXgydXInpf2OKxJierh91Qu0SVNdp0wRRqvCe
         zfgA==
X-Forwarded-Encrypted: i=1; AJvYcCXuMrtQy5u+LTgTEOmsL803H/laLSfhKeWayrWFOOM+J8aU4iHIYmuWwbzDTjeMj+lel98zPcgKdw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrm8vFY+Nr7nbGyU028jU1BbYWsv63XaPdo0arc+l5FRhCJAGf
	3APvW/nECbrAvy973ke+kAf4I8ajxF/mIEkTdsTKlSuOaFCiKZUdNVx7nFQSNhy0ezgFpic104i
	uh92S
X-Gm-Gg: ASbGncsFo3t7Jn/peXsQ+B/beaQSIMoQHWGmxm1piDwY9utp+l0lv/QbWqe6m7SJNWU
	quJRgUWQSpNggfev96KZ1oyOq6ENNVcUvGGTAuP6mlfucv/D1CpWSgxTLTm5TsFfjoGRmZT5t3G
	kiaknAZyHuIUENl2XZK3H3Z2kH4qmindgifGWmzSc8AV5DcSXImlhz3+GDltBvvogcZSWe8IWxX
	7tRV2D9CBD6+PbLmEZhNUPr+ZydwZd23XywCJL1+BO8M38c6SxhaukFji5HmxtwVVYwDb1MCyS8
	dPIC0ieApNZjZR5hMiLDO8Czkewz7H33oq+VPrQvHs+ks+sg
X-Google-Smtp-Source: AGHT+IGR1MXma3XA8GTcRHxcuQg8O2x9U2RnP4fz9PIb8CfNf3AYpmTN9hICgECiwMNvdVnDxS1zRw==
X-Received: by 2002:a05:6e02:1a0d:b0:3dc:64b4:4246 with SMTP id e9e14a558f8ab-3dc64b44e39mr6059445ab.9.1747492383680;
        Sat, 17 May 2025 07:33:03 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4aa701sm925091173.115.2025.05.17.07.33.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 May 2025 07:33:02 -0700 (PDT)
Message-ID: <1c9d0a4e-d615-4a12-b2e1-cb3bb6030e77@kernel.dk>
Date: Sat, 17 May 2025 08:33:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1] register: Remove old API
 io_uring_register_wait_reg
To: Haiyue Wang <haiyuewa@163.com>, io-uring@vger.kernel.org
References: <20250517140725.24052-1-haiyuewa@163.com>
 <80d92472-402b-407c-8e39-ce39b8ef46ed@kernel.dk>
 <e6efc1d8-f317-4475-b33e-0027d4c4d140@163.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e6efc1d8-f317-4475-b33e-0027d4c4d140@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/17/25 8:31 AM, Haiyue Wang wrote:
> 
> 
> On 2025/5/17 22:20, Jens Axboe wrote:
>> On 5/17/25 8:07 AM, Haiyue Wang wrote:
>>> The commit b38747291d50 ("queue: break reg wait setup") just left this
>>> API definition with always "-EINVAL" result for building test.
>>>
>>> And new API 'io_uring_submit_and_wait_reg' has been implemented.
>>
>> You can't just remove symbols from a previously released
>> version of the library...
> 
> Cna only remove during the development cycle ?

Once a symbol is in a released version, it can't go away or you'd
break both compile and runtime use of it. The only symbols that can get
modified/removed are the ones that haven't been released yet, which
right now would be the 2.10 symbols.

-- 
Jens Axboe

