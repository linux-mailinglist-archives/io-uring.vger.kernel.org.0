Return-Path: <io-uring+bounces-7367-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2287FA78F72
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 15:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93480188C985
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 13:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FE3B1E7C02;
	Wed,  2 Apr 2025 13:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2ILEED3d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C131E531
	for <io-uring@vger.kernel.org>; Wed,  2 Apr 2025 13:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743599363; cv=none; b=cOGKnvQz5krE+dEiZq/wUXsJFS52yHNm+cZkBueF3tpqorfVEAPNTf5YaugUVZwMmaXH+5VKEFtDyFCaL/fXJk0jB7PNxSqYneTbZxv2K7Xh52FdC0/DFcBoqCHe2bi94uVYGpCiqzd0X3rUmK1669yPWcJut2nAJocMInjec8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743599363; c=relaxed/simple;
	bh=sNjR0CRqAnvkocf66oSnlPXOpr3EBsQ/8ZUdgMX8/Vc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=av0qHS5Lpq4zDqbt/I7pdY11rZVxR9sA1l5EAeyutL/gcKg4DrcdWL3Toc60gq6IoncQtq5a6xAwVLfLGRVH4fSNe25oY0oYYPM14XhbnSc2YrkkStfajLwWQyoFZo8spdw87QkIHsDemBaPRcZBUHvGlmBWcerCxf5btoIOjmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2ILEED3d; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-85d9a87660fso556955839f.1
        for <io-uring@vger.kernel.org>; Wed, 02 Apr 2025 06:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743599359; x=1744204159; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o1fVAFHTqzr2gWH2s+any4ojp9ZI2YUOvRqlJ6hGIxQ=;
        b=2ILEED3d3eCV+S+oyFZ8CzdKF3OgCufn3ZF289BOnZOT3pUTOMnDjCI3MFjPKc3jW0
         W2SRH+y8GsDBuCb4kPoPtvESQZxOKAmMvQmC7UFKeG6rodLJNtaDi7JHk196LkgWcjhX
         WbJXriHkFNgger7ZUXFjb19p+q9e7zTfuPNN7dTPcTCQ1bUl/FKbPhqh2GWDLkSF7W/z
         J9Hk9iHUs51E0PKCzydXQ1CY/s440KfrSW3d4bXGUShgrZk6OA8NLe06ZCQKQ6zLJjNE
         RRKimWMg3VqSf3J+4WxyeEjr/05yBK4uwa2RdGOpcSeDAa7CQRQw1D1yARO6X/rUbpHx
         3hrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743599359; x=1744204159;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o1fVAFHTqzr2gWH2s+any4ojp9ZI2YUOvRqlJ6hGIxQ=;
        b=DGcpI0zJP/OlFp4rrYy02iVIsTKRaq9JrPUD18x/JUkzrj1bxdc2YIciMwm21aT5Uv
         bzM393eHIs+Ais5TkNjg1mo/4YtYoSlP/ctWGmF/rCgETyoqO5dF0RqxiuPfa7y0rSy2
         npRse5SN8jOfKSvXWjQjlM+/B8T+KE9xWtTDLay+XooBPljgXhTPlYACQ0BG0jE8wLgF
         0NnK2CV0xbx++64yFWmmg7lHUeJbz4PAso32kKlAEYocu3kd07MvtkPTw1sz0gHnGI4s
         cY2UoiDdWHh9I6SUU/B4eUZWifLahGG4GrpkbElXd9BeYeb/qbTQ5hqLSnBNxoe2TRRI
         gDqw==
X-Forwarded-Encrypted: i=1; AJvYcCV59Gxw3ixjTkiXRfGQRpsYXxVOIlJPx/OjE+VazBZwZ0uoW3G0xMh6lJrghtPCQJK1v+kHbf698Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyh7J9S0BaQW+45J/KM/iasLMdVwtvACpsq+9BkwZWgkIOm3sAG
	pth76keu26qKriKNyxfZqg5m7JzdcMrJBUffYJCUIQVqgvIvWEcXjutBFMU2RfU=
X-Gm-Gg: ASbGncuGOd/yY4HAcRr19vLvr3/FERxJtWjsCNGwSfunG5NCl+vTIgVVi14uxPM7B1D
	aWBxAd1YQBA3EjJpvesSOJackoBKZa+dRbQ6XdXIpbu49350jTzWXo5OjD2oJFzD7L4vbCR5K33
	HlCtjT+qOAPiY/vf8G95DSVejLk3n10Qgb4OaIuE3b/V+2sS8Z2HGltkh0McJrcgGaq29n7K3i0
	/oUt+pu6e/No1udIXa4z9d78p17V5zToj24Tj1O9ujI1tsNuKneC0Aczns+5o+5K6b25VTFI3Bq
	2VkPu12H2gyxsIWcpPopsmMAA0xThmIiN0Bp54kZmckARsajeeg=
X-Google-Smtp-Source: AGHT+IFUuTM1KZqiQdqT+SrEy1NlRT7sU+Ztq3WLwqutpqfbdioNq5+jrHrIJ8EXOSvUjcrPeLHyrA==
X-Received: by 2002:a05:6602:3a09:b0:85c:96a5:dc2c with SMTP id ca18e2360f4ac-85e9e939846mr2013627339f.14.1743599358804;
        Wed, 02 Apr 2025 06:09:18 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f464780ca6sm2975579173.71.2025.04.02.06.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Apr 2025 06:09:18 -0700 (PDT)
Message-ID: <c62f99d0-184b-4158-b609-d1e687ba4121@kernel.dk>
Date: Wed, 2 Apr 2025 07:09:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] io_uring: support vectored fixed kernel buffer
To: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>,
 io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>
References: <20250325135155.935398-1-ming.lei@redhat.com>
 <Z-zt3YraxRSHVIWv@fedora> <c252ec4e-aa97-4831-8062-43fcd1065324@kernel.dk>
 <26767f79-4ed3-487e-aba8-aa6ff124b2c3@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <26767f79-4ed3-487e-aba8-aa6ff124b2c3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/2/25 6:13 AM, Pavel Begunkov wrote:
> On 4/2/25 12:59, Jens Axboe wrote:
>> On 4/2/25 1:57 AM, Ming Lei wrote:
>>> On Tue, Mar 25, 2025 at 09:51:49PM +0800, Ming Lei wrote:
>>>> Hello Jens,
>>>>
>>>> This patchset supports vectored fixed buffer for kernel bvec buffer,
>>>> and use it on for ublk/stripe.
>>>>
>>>> Please review.
>>>>
>>>> Thanks,
>>>> Ming
>>>>
>>>>
>>>> Ming Lei (4):
>>>>    io_uring: add validate_fixed_range() for validate fixed buffer
>>>>    block: add for_each_mp_bvec()
>>>>    io_uring: support vectored kernel fixed buffer
>>>>    selftests: ublk: enable zero copy for stripe target
>>>
>>> Hello,
>>>
>>> Ping...
>>
>> Looks fine to me and pretty straight forward, but it was in the merge
>> window. Anything that makes this important for 6.15? We can still
>> include it if so. If not, let's take a look for 6.16 when the merge
>> window closes.
> 
> fwiw, I looked through it, looks correct, but it'd be a good
> to test it aside from ublk. I guess I'll just extend a kernel
> hack I used before.
> 
> No opinion on 6.15 vs 6.16, but the argument might be to have
> it in the same release with ublk zc, and have less probing
> for the user.

That's a good argument for 6.15 actually, rather than split the vectored
feature over two releases... I'll queue it up.

-- 
Jens Axboe

