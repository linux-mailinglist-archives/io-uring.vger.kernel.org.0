Return-Path: <io-uring+bounces-3525-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E3589975F5
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 21:51:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B4B92829FE
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 19:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2B721714A4;
	Wed,  9 Oct 2024 19:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="R2Nx/QM4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203661D318A
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 19:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728503463; cv=none; b=MUpHydsRht2CAyWYT+YDNdKfRTe6y7QceqZqzPJR4IhpH58cK8kjP564YtSJ+qL8hWJ4oESOG8x6/z9ECxFQDzMCdw2IVc1x1S+Afzg2NUrHwZf/MY1Ld7wZ2oQb2dbeg89I40MYtRfU4xJRTlTD0ppGBpX5wont/5PfQZbdjqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728503463; c=relaxed/simple;
	bh=K3Sin6HsrhzRRP2HgMTVeCGgTRTQpKHKA+ETtOJS1ms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XB99FUNK5XhVT84oCshiK1ddpvCRL7Z1J3LuTVkmBhJIBgRHIDQTJ6Y0jPIl3zkbj04Bc4tc3XZF48krwBzF7+IazU9m8ChsexK58f/SIrlfCkJJ8zuJW2ME/LVf27G72v5uMSWLfX1jQLoMkKJFLTPT3bE8PhohJXUPuRrTgiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=R2Nx/QM4; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3a34ccc6a9aso1095255ab.1
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 12:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728503461; x=1729108261; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hyzeTwQWm4QHExZgx/HQ8cPQRRp2JJMriJXGeys4Vd0=;
        b=R2Nx/QM4GYFd/yEcKVat7fuhEAM13FpJ6BVnprCf5AdGFE9ov7KP4qLszjL1ZeacMA
         /4mBKBQJZptZUg5pS7V7GT0zTPbW2pcAcLoevBLydTZr/CLBCUfXt1yvLz0B8FuXitpe
         YGpzsLxGVgMao+lDavmqN/DMg3QqMddroMuCzL7RkFHFUwaopbj67/Cl+sGkIVbSvsrX
         iWcEGSIsQoHLH/XLcCwsYd35dC6nKUJr2ALcISpq3TnugwdJ+iNnnSF508V4K7ZiqvOg
         kR2fx8XF+I0p72BVCxbetEIEcBztMQFPfqLjgbIFxbhDeomVkTV2MPpyxuOeFx/naUhk
         M6Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728503461; x=1729108261;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hyzeTwQWm4QHExZgx/HQ8cPQRRp2JJMriJXGeys4Vd0=;
        b=jV4OZ0z1Ltwz8grnL9Qe98FK8y2HQ9Vqr9soMaXTIERi1ybMEN0jYI1L4hL1iXmxrN
         y/Tu2D6F4XgPnvTDiej2u/0/lXWuL/IWzVo29QZOYbiz2IpsBRjmlMnjPmar5WqjouhT
         RVIbhgcp+4tj8RjkwZ/h/rabMyKHBMuHYXwvNNkKIAg20uJgOJ4M7zYpStp2cbJBeJwO
         ntl+TdGDk3ttWC7ztLr+wAsFlG7aefDKP3+DB5fCdLjEj76EKJso4FYa9I5eNYwBnJN/
         USfJW+fOqtWWcITZfE32VeVwqoztQNFazYawFZ46cf2TGztKBxzbXlWfIHoZpo1XwHKU
         bJFA==
X-Forwarded-Encrypted: i=1; AJvYcCUUm0hA62+t8wPik+LsFfYRkumK73LiUtNnb1s8vLMbrM2adihtUefdVR5VzWNpfT5ZISUaN1XjAg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx37TJbgdhVo/pXFR68URs2GBJvW8ZRZDfo68s0t4I0Os9dLveI
	KpHLPwgavFeu3E5Pf5vc4N8EoWgPk8sexfSa9FVhvOwJVngLtN1+ZjMvsPUkb6M=
X-Google-Smtp-Source: AGHT+IEDtXerx531mxi3pVoSP4s1yifrJRdu3yBQSw7xZ3r6OWX3zbsW/0ceQm4MVFLJHpDyf3mzGA==
X-Received: by 2002:a05:6e02:1fcc:b0:3a3:9792:e9e8 with SMTP id e9e14a558f8ab-3a397ce8583mr33498195ab.5.1728503461140;
        Wed, 09 Oct 2024 12:51:01 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dba90f4166sm162232173.159.2024.10.09.12.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 12:51:00 -0700 (PDT)
Message-ID: <32a05d6b-1b82-467f-ac3e-f3cd2e5c0e22@kernel.dk>
Date: Wed, 9 Oct 2024 13:50:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 12/15] io_uring/zcrx: add io_recvzc request
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-13-dw@davidwei.uk>
 <703c9d90-bca1-4ee7-b1f3-0cfeaf38ef8f@kernel.dk>
 <f2ab35ef-ef19-4280-bc39-daf9165c3a51@gmail.com>
 <af74b2db-8cf4-4b5a-9390-e7c1cfd8b409@kernel.dk>
 <7cee82f7-188f-438a-9fe1-086aeda66caf@gmail.com>
 <177d164a-2ebc-483a-ab53-7741974a59c4@kernel.dk>
 <d5be304b-0676-4f4e-adbc-eea3f7b161de@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d5be304b-0676-4f4e-adbc-eea3f7b161de@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 1:47 PM, Pavel Begunkov wrote:
> On 10/9/24 20:42, Jens Axboe wrote:
>> On 10/9/24 1:27 PM, Pavel Begunkov wrote:
>>>>>>> +    /* All data completions are posted as aux CQEs. */
>>>>>>> +    req->flags |= REQ_F_APOLL_MULTISHOT;
>>>>>>
>>>>>> This puzzles me a bit...
>>>>>
>>>>> Well, it's a multishot request. And that flag protects from cq
>>>>> locking rules violations, i.e. avoiding multishot reqs from
>>>>> posting from io-wq.
>>>>
>>>> Maybe make it more like the others and require that
>>>> IORING_RECV_MULTISHOT is set then, and set it based on that?
>>>
>>> if (IORING_RECV_MULTISHOT)
>>>      return -EINVAL;
>>> req->flags |= REQ_F_APOLL_MULTISHOT;
>>>
>>> It can be this if that's the preference. It's a bit more consistent,
>>> but might be harder to use. Though I can just hide the flag behind
>>> liburing helpers, would spare from neverending GH issues asking
>>> why it's -EINVAL'ed
>>
>> Maybe I'm missing something, but why not make it:
>>
>> /* multishot required */
>> if (!(flags & IORING_RECV_MULTISHOT))
>>     return -EINVAL;
>> req->flags |= REQ_F_APOLL_MULTISHOT;
> 
> Right, that's what I meant before spewing a non sensible snippet.

ok phew, I was scratching my head there for a bit... All good then.


-- 
Jens Axboe

