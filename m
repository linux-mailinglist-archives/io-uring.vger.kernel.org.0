Return-Path: <io-uring+bounces-6564-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62DE1A3C60D
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 18:22:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3480E3A942C
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 17:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F56F1FDE01;
	Wed, 19 Feb 2025 17:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GENvHTbS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AF8286284;
	Wed, 19 Feb 2025 17:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739985765; cv=none; b=Sg3DGvbDPSD6MRCRheAeFHzhxWhve5Bn/tD64p3hYKPLPscnvBzEcEIwxtOpls9Hi+lKU9QwfUwLguoSttLwLjIwLSg6qDg19QAjyuIrpHwn11gLx7Kie60ztrqFEWhElYcF+kV23DhAGb/N15b8IOGJzBsafnL0fwfBsIVejl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739985765; c=relaxed/simple;
	bh=X7aHfb6fbZQPpfHEvxh75ezvzfG8laBjMbILc9YwfTc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Snyz2L3AFNA4giRHn5UdvNRwX18jx+FqtuIfGA/T+ZKH2gEvKhm1lgXeqtHwQPueK0oouVTcjRsbA18cwCXF+u1fi3/kwk8UwwOtfhsNzMZOdThDFxhZ1vbv7segyIaRFLPmebK2Il1koiBjT3hmkqejGk/AGH8NMYJ/Ou9Ubnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GENvHTbS; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4398ec2abc2so27132305e9.1;
        Wed, 19 Feb 2025 09:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739985762; x=1740590562; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=liOzWWaQBCDbAVuZ3wSA5gHYo8iwVTkcoCw+gLwOAJU=;
        b=GENvHTbS0XWaZj5aNGOPbTJYsUgfgPwfEYE8cGt/d60uMaLWVhIobecywp5IN/+BRN
         m7k/duIooF8tTXUWcepYOjseDbbi7Go59vgdB51f5Orb979nnNpLHmCh/+k0dzgqgN4y
         BIRR5Yzg85qOfdd8SDjTsFxrF0zu7Yzwyh4C+du1kA241g0Z/M6pRGKmckpnFiHMOwLd
         uZ+vG7YpMY8g601J0IutzcNWcuMVa+BbDKPy3wzoOpPj8kmccFU6CsaWEHWh+jdahaB3
         S2/T1xHTWMLwHTpm8LK3eY5gdMxbDmMMpOEJSHLhYKZshYoxc+vPri6A2NE7XdQEDCV5
         IWVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739985762; x=1740590562;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=liOzWWaQBCDbAVuZ3wSA5gHYo8iwVTkcoCw+gLwOAJU=;
        b=WYs/zF4rI/icuDe2cO09RpVSxnqEKHHmautyLdNMhnNWhqMZ4z9Qoc3UkmjJJgUoTD
         15m+kPZrKKKA2iICgMD9wf8S6zOjwz7v3rwMOA2R1PU/0r4vJa1Ug42LxrsgW93yzA/O
         AhvaTcUBkR+/c3bTjA2BZ233jnWR4afEBhRMs7p9EWH+ZGDnyqU35PkesGi+VAjt+H1d
         R31Z+HWXwhDc7fkt/GOdsAuVlWqdhbOk3fUUXqfZRdhnmULU+Y06EXZrXoBKhqmWzXBU
         Vy7+w6TU8fjnUNbkBccepLaNo3hnO62rKgYkiPA/eW2DNYNM7F9PGnvFlSHImsgKpYV4
         5gLA==
X-Forwarded-Encrypted: i=1; AJvYcCUqawS/ROYOG6zA4o9VMnLmlyY5GaFj6hQ+7XzeqEw6WxW0vIv7OMtlPyNjS5LmmzQmuJOHTZHaKg==@vger.kernel.org, AJvYcCUvqfqFhY1uDiWlJTZ8t8oeoQr0ZUNKP22mgC46cIWoeZVONtMRc3Vg05MOVo/DeZZz0ZX6y1gknGHUxoI=@vger.kernel.org
X-Gm-Message-State: AOJu0YynJCpy2doJBJutfZyM5bowo6kdI0qyYj9pLBXsJPZLh9YrCEpJ
	9IhxaV5uVT87SnUiCksofOuI9tM/xeeUu1afyKEvVZplEnNSCpvf
X-Gm-Gg: ASbGncuVBkh9VcZL4bCjLe/W11Xe5cIBx3DKUbNfnZOUbKilR6SIS0lrJCT9bKBlIMU
	2uyaRkC0QbglNuXzQUKPC0S36sNiiDZdwXnBKKI0mbjlLHmkedS+7tcv4xhnkR2PfhPnLtIPqgv
	hrz6s9YrueXYezWpZ7mWt8gaKRFq3j6tahUiaZ4JTB8wLf0hPtY01Fem6Xg/gIOlQacVEp6j8BN
	lGrqOOia2uLJvKGK0ZPDl9wpIS+phzSoThylVWvQPchl8Ryu0Lf90yuCtBRZnaRK/hkPYzYnDYz
	4e8q7I3gB5y0S1pQHWxFqKoV
X-Google-Smtp-Source: AGHT+IGXj6EOXwWhSSEpywwZDcbMJAOX2IpW9ZnvqvVf371rVSwxrmF+EmDhzCied6UVGCzzeVAe7Q==
X-Received: by 2002:a05:600c:190c:b0:439:65f0:c9ce with SMTP id 5b1f17b1804b1-43999ddac3bmr37044115e9.25.1739985761664;
        Wed, 19 Feb 2025 09:22:41 -0800 (PST)
Received: from [192.168.8.100] ([148.252.145.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43982bcc607sm97991315e9.16.2025.02.19.09.22.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2025 09:22:40 -0800 (PST)
Message-ID: <87c5fc22-a1cc-4f7b-9638-207d4b9d1159@gmail.com>
Date: Wed, 19 Feb 2025 17:23:45 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv4 2/5] io_uring: add support for kernel registered bvecs
To: Caleb Sander Mateos <csander@purestorage.com>,
 Keith Busch <kbusch@meta.com>
Cc: ming.lei@redhat.com, axboe@kernel.dk, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org, bernd@bsbernd.com, Keith Busch <kbusch@kernel.org>
References: <20250218224229.837848-1-kbusch@meta.com>
 <20250218224229.837848-3-kbusch@meta.com>
 <CADUfDZr=8VPEtftPtqaQdr5hjsM4w_iADEAL6Xp06kk42nZfVg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZr=8VPEtftPtqaQdr5hjsM4w_iADEAL6Xp06kk42nZfVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/19/25 01:54, Caleb Sander Mateos wrote:
> On Tue, Feb 18, 2025 at 2:42 PM Keith Busch <kbusch@meta.com> wrote:
...
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 0bcaefc4ffe02..2aed51e8c79ee 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -709,4 +709,10 @@ static inline bool io_ctx_cqe32(struct io_ring_ctx *ctx)
>>          return ctx->flags & IORING_SETUP_CQE32;
>>   }
>>
>> +int io_buffer_register_bvec(struct io_ring_ctx *ctx, struct request *rq,
>> +                           void (*release)(void *), unsigned int index,
>> +                           unsigned int issue_flags);
>> +void io_buffer_unregister_bvec(struct io_ring_ctx *ctx, unsigned int index,
>> +                              unsigned int issue_flags);
> 
> Hmm, io_uring_types.h seems like a strange place for these. The rest
> of this file consists of types and inline functions. Maybe
> io_uring/rsrc.h would make more sense?

There is linux/io_uring/cmd.h for that

And it should be taking struct io_uring_cmd. ublk shouldn't
know anything about ctx, and this line from the following
patch in not allowed.

struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;

-- 
Pavel Begunkov


