Return-Path: <io-uring+bounces-6667-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 129E0A41F97
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:51:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C2E777A7BC8
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 12:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 584362571B3;
	Mon, 24 Feb 2025 12:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QnMTVboq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E931B041E
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 12:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740401322; cv=none; b=QBs22UPwLl8ZS5/kkMjUzwl7UmIKP4clht/sFHDZfExQvjuF6kvdHJKMJbTlljeOlVA0mUPlrfe7TJk4M+oefhI8jgHPki8fuBqIOmlTJXsuikcvi1A+q0+/DNHjXdqyR/GRz/5zC+Ezrppfx52bF7vLxqUm6C/f52+fCBcXGNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740401322; c=relaxed/simple;
	bh=Z51mADYhibXoZIW0TFPAyUgslp6cGPym9xmKegzbR7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SOub/O5gUOg9lxJDT8BDoaI7/8LuRJfXobBETdIiKDYs7dy8heHIYQfnC0qmzwbM7OooTobY/zuuROi2VUljUEIGoBpwILA3M3CPY1oljH3hm/evW2hK1ztY9qrQaUgveH75kXTQrgq7d3LqOnfoMBaUbz96GmSD8u/zGZ2ubLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QnMTVboq; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-abb7f539c35so845091366b.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 04:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740401319; x=1741006119; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jKnH97Ev0pYMra8+fhIlgaQEn0q+rdcJBV8s7jrq+es=;
        b=QnMTVboqj/26Rr96cpnGAk2VNhXIzulZABVkvjAAdYzuw0BsFVRb5Yhfjq4GAqI67f
         eG9WGTuDoN91C6DnUeJDI2y7FByR1DbO5UFdyb4Wz3RgQBSdzFsmEFraJ6UyFj4cj/BI
         mUQZDt6zFptMh4eBmC+NcsHb0YQf/PG0AEp/k9sZFDlFX5EJJDneynKwcfBGC9U8IMZi
         EI1Cy8MqnImz80lBBegIFD/00ZkLeD9jt7GM3KJA8A0CrxjxQDU4egNRlmEa7yYVrxQi
         aRmLb7/30/GUyNjsZfhssNIvf61udonEvDxTegfSrvoBogNkJElFihLTe+Nxl3LcsYDh
         Z4sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740401319; x=1741006119;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jKnH97Ev0pYMra8+fhIlgaQEn0q+rdcJBV8s7jrq+es=;
        b=j+c1BEXVYUcRIIuUOeiEl/RtgZxOq0gwx922ScOhcLFMEAA8g1WCGETHhsrsOeu+Vv
         b77mZ4QC8bOeDoKKtLmdaFI3CesJpvrB0szfi6vEUdr5Hxy7Crzq+8Tib2EXUdQp6JUS
         GpC/vY8a3pF2W6DadMpv8UKNiH/EwYi652R+z5mW8xKTdkKTN79bMFbXTIOCoTqD6grT
         d36Xya9Q8BTecMTxsAkgZmsoCBRbWOnpnF14Vc1iWkEo4c+qBPKmbMzbkR9dJU/PCrXM
         kGx9EGIRM0FAR5R6aj65k4Z742AlxZ4idu1k/KpsLLsxs5+GUzCMC774r92kOT3ojJQo
         R9eA==
X-Forwarded-Encrypted: i=1; AJvYcCVgsOFHRlqKkQeOSxl44ZJxWkHLtv/yVYg8PWBFxnKnzI/Foxnn2CHXMZLAgQrbS7ErwoSpD/iR/A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxQb4joXF39t7kJES2b7JsbkivVrj2HVRX/SRxiYo0ZYYro6RTt
	56TUEekJHnYM0d0coEebGV621cZjHX7PMr8lNPp0Wasm7qdORXUD
X-Gm-Gg: ASbGnctYhy50C28f576cV5GRHzcevTWkX2uwzm8wh4blstMbMNTkwdPyk+JrbnpQK2A
	7ZvTZEpnWBBXDPQ5j1naypvYx8MdmpVztAFR2zz/C4hRIpmZcodPp58H0/XVNwTspcyD8//wtht
	J+P42eCeBod8Vk2Zw114nzCi2RGYfsMBmOev5A7qFb91zJ/viKMXq3l3lfVY7Yz1oncuAwJz2jI
	79cKG3D/IsQfudBN+kkrbbW02SWUPpnQNYBy2XOQyMhwS/HQmHpM9OfNxGYQH2JspioleXWg/5i
	ktSfnu/HC4qahapvcCr2kqEzGw6ZRHGNganEW6hZTNdKCOTwwyTz7q6gONI=
X-Google-Smtp-Source: AGHT+IGhB74Mw4mPXpEeWu739bMApUFLpJ8zD8mNZrpx5f8hSpfZrx/svLbPJ312/UET6cvYf5qoQQ==
X-Received: by 2002:a17:907:7ea0:b0:ab7:d179:2496 with SMTP id a640c23a62f3a-abc099b8422mr1471066766b.6.1740401318559;
        Mon, 24 Feb 2025 04:48:38 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abbaf6ec730sm1357604666b.163.2025.02.24.04.48.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 04:48:38 -0800 (PST)
Message-ID: <ab419fb3-7081-474d-ad06-c0aa7c3df2a0@gmail.com>
Date: Mon, 24 Feb 2025 12:49:39 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
To: David Wei <dw@davidwei.uk>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <20250221205146.1210952-1-dw@davidwei.uk>
 <20250221205146.1210952-2-dw@davidwei.uk>
 <9d081ae3-6f9d-48d2-a14c-f53430a523d0@kernel.dk>
 <f8409430-a83d-4bda-a654-3f9bedb36bbc@gmail.com>
 <16aef2a7-d20e-48a1-aa5d-747619c8a2c9@kernel.dk>
 <a9b1f507-91d6-4e9e-baee-f8dcb4e1a48c@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a9b1f507-91d6-4e9e-baee-f8dcb4e1a48c@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/25 22:35, David Wei wrote:
> On 2025-02-21 17:07, Jens Axboe wrote:
>> On 2/21/25 6:01 PM, Pavel Begunkov wrote:
>>> On 2/22/25 00:08, Jens Axboe wrote:
>>>> Just a few minor drive-by nits.
>>>>
>>>>> @@ -1250,6 +1251,12 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>        zc->ifq = req->ctx->ifq;
>>>>>        if (!zc->ifq)
>>>>>            return -EINVAL;
>>>>> +    zc->len = READ_ONCE(sqe->len);
>>>>> +    if (zc->len == UINT_MAX)
>>>>> +        return -EINVAL;
>>>>> +    /* UINT_MAX means no limit on readlen */
>>>>> +    if (!zc->len)
>>>>> +        zc->len = UINT_MAX;
>>>>
>>>> Why not just make UINT_MAX allowed, meaning no limit? Would avoid two
>>>> branches here, and as far as I can tell not really change anything in
>>>> terms of API niceness.
>>>
>>> I think 0 goes better as a special uapi value. It doesn't alter the
>>> uapi, and commonly understood as "no limits", which is the opposite
>>> to the other option, especially since UINT_MAX is not a max value for
>>> an unlimited request, I'd easily expect it to drive more than 4GB.
>>
>> Yeah that's certainly better, and as you say also has the same (forced)
>> semantics for multishot.
>>
> 
> I thought about using 0 originally, but needed a way to distinguish 0
> meaning no limit vs a limited read hitting 0 and completing. I could
> store a flag in the request at recvzc_prep() time as an alternative.

FWIW, either option is probably fine if it's for internal
handling and not uapi.

-- 
Pavel Begunkov


