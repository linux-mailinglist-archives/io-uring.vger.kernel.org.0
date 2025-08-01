Return-Path: <io-uring+bounces-8869-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25612B17F93
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 11:47:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EBA116D64C
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 09:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC4D22FDFF;
	Fri,  1 Aug 2025 09:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L4yEzCXD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9CF227B8E;
	Fri,  1 Aug 2025 09:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754041657; cv=none; b=ngkFfG6KKCyXHQTaH+WbHOv1HvZkFAw2xcOpV1qdTNmflBgIMphEhk1HdE3GZZbfHKSzIzwrUhnpx8eqIP7V4XmP9/Tj/wogwJoktY0M9OLNoRmbEoD2xe2iYIvviIpf/SPiwQqhHv9GiZpM4xp+mg7GyIhCtOA0cH+Dou7jGP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754041657; c=relaxed/simple;
	bh=6DyjhgNLifkrdFza5N8xAoj6ArULOKmGBFWuEIRzalQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T4WCypUV/lfvg/QfrIgPoBhBhgQUfM0XWyjDLT98ZfCeyasXoJlPrSvJ6tjayY3T0OTjcCMSKMzB6XeQivXS9jg6qdkZxqgdpT+34LpPxbQdR1xeRNzQwFTfPenx+2K4owrChI4nZEQSca/uaANA08NbDAMW9tkmzDQ37UIP3PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L4yEzCXD; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4589b3e3820so19072395e9.3;
        Fri, 01 Aug 2025 02:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754041653; x=1754646453; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zecUtrDYIwPD8n4jDgHWgxxJ5RrGHaY2/DknBkuIeTs=;
        b=L4yEzCXD3mmkVo8mkNFGBALSu++k6IO3xeLPlcjiFvIxYThlG7JiaVe+Iw2U9Zndws
         8E9OVpRbjnkRC9ym5y25upT3bIoFOYzzX16nvVEiegfLlqugKE9Ro84nvX+JqKbHbYQf
         FxA8CD+olHUUt/AiFc6GW+om1W0GBhBqnwhEFQEAYc1frQZXk3bZG10MjGNhEv7CUYf1
         aMPbWJXv9WI2YfThd8OZ09CCoGq67HSaqYQKAStXwSwpWnGln+nS2w8f923L3TREMrO5
         eV0FUmrfsqz/XNlTLkhQrgA7MmeWu/JoMuHWsGtev2YbciOH2pIvrS2hfA0bV7IDiz0E
         vkBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754041653; x=1754646453;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zecUtrDYIwPD8n4jDgHWgxxJ5RrGHaY2/DknBkuIeTs=;
        b=QCgZIiUXC0Bi7FQKl1VGJJsEwUN1c6zp/hjWSR8kobESTt9RZBp0jpQIcq3YerX8Kc
         9oTsAze3b9w4UT4ezwvX0Dd9d8VQOI2+0s3dP6eQ7pU+8qu8i3/JaaY3sB5ZjRLYCYaU
         YC+Bnl8Zj6Mtnr/jWCS17PaWILmXe0+MHvKrmdQ5FwlwSjPpk+Hb2LCVhstV5lMm1Ha9
         gH8tWcyEiqv5X6HThyoc+rJTQ1AR0DA//38qlHIRNr787ERfTE2Iog6wGkU0vUTqxKjs
         34LwwZBO3o02ZbQhgjDioGjn533bW6u0QRG3kpXlnUKLo5j//vcWGs8Y69lbEofdhk8V
         zPEw==
X-Forwarded-Encrypted: i=1; AJvYcCWHEnGUue/VRmuOPc5ixy73My19LRmo/VpagkFxrnP9HQqcwp1P3MT8IVoNKKHMXyvjAVQqdAJPEA==@vger.kernel.org, AJvYcCX/4MO4YUnhnHs7KcfAW1l6jOs3emKFxCDVXTD+Hc1hLxQG3cOOotNt9e3S5pca09mmuAm+evt6@vger.kernel.org
X-Gm-Message-State: AOJu0YyVZznWcKXSiTSCKoFMOkUDaYSH9t6V/iDd0mUARnb6fJNnWZX/
	0eRByfCJ2ngf008g7aZbbFZ9lS9c6rECBawPOQZyrA9VrpUsutA+o3re
X-Gm-Gg: ASbGnctAE0i6SQ6pfs3mc3kg00yWftypL0tBspGfWoX6yfrjvq5McP3CYxUpi8dG6A5
	jTyiYJ8BGPdEbyzHu65RIz4UiypD2sZsOqUTOsyHHz2pbdVjQZNO+JJWJ3R3dtuqF+1C0nDZYdX
	auXfR9husEezUnmOtSAVMkk8jKCn/b+MdV8toMvIZnprOeS+OjfE+VrKLjmdf1tmUNCS1Uaxe56
	6zsYATTO6wRKdDviELgcHWJf4EgFsfZ2iDb6r4VHFmrfRZAShmM89eeKsSWrNRryP/hgnTMd9SW
	dz7MyeYn2+QKOBvc2r0iyNk6vWsBaWU54AN5JGs8a1IrfwRVY+zHe4txZ5JKXF4OFTyN95Zc3Zi
	2JJ707PCCacxTsqqArCbcChG9rJmzM9kHZpc=
X-Google-Smtp-Source: AGHT+IHnVdWY07jWG0I30roHvL1+woy1pHD7k4Clu4evEVt6d0GyMELVNVA57fF7wg1ImDwPwbYt8A==
X-Received: by 2002:a05:600c:1d19:b0:43d:4686:5cfb with SMTP id 5b1f17b1804b1-45892bd6f7fmr95313575e9.27.1754041652323;
        Fri, 01 Aug 2025 02:47:32 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::26f? ([2620:10d:c092:600::1:9c1e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458a22365c0sm56966435e9.3.2025.08.01.02.47.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 02:47:31 -0700 (PDT)
Message-ID: <58a592bf-3e88-4ad4-8a6e-37dd9319da99@gmail.com>
Date: Fri, 1 Aug 2025 10:48:57 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 00/22] Large rx buffer support for zcrx
To: Mina Almasry <almasrymina@google.com>
Cc: Stanislav Fomichev <stfomichev@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Willem de Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, dw@davidwei.uk, michael.chan@broadcom.com,
 dtatulea@nvidia.com, ap420073@gmail.com
References: <cover.1753694913.git.asml.silence@gmail.com>
 <aIevvoYj7BcURD3F@mini-arch> <df74d6e8-41cc-4840-8aca-ad7e57d387ce@gmail.com>
 <aIfb1Zd3CSAM14nX@mini-arch> <0dbb74c0-fcd6-498f-8e1e-3a222985d443@gmail.com>
 <aIf0bXkt4bvA-0lC@mini-arch> <52597d29-6de4-4292-b3f0-743266a8dcff@gmail.com>
 <aIj3wEHU251DXu18@mini-arch> <46fabfb5-ee39-43a2-986e-30df2e4d13ab@gmail.com>
 <aIo_RMVBBWOJ7anV@mini-arch>
 <CAHS8izPYahW_GkPogatiVF-eZFRGV-zqH3MA=VNBjw4jfgCzug@mail.gmail.com>
 <364568c6-f93e-42e1-a13c-f55d7f912312@gmail.com>
 <CAHS8izM9238zKuFy1ifyigXmG8sbB8h=A=XqtLz-i0U2WM3vqw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izM9238zKuFy1ifyigXmG8sbB8h=A=XqtLz-i0U2WM3vqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/31/25 21:05, Mina Almasry wrote:
> On Thu, Jul 31, 2025 at 12:56 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
...>>>>>> If the setup is done outside, you can also setup rx-buf-len outside, no?
>>>>>
>>>>> You can't do it without assuming the memory layout, and that's
>>>>> the application's role to allocate buffers. Not to mention that
>>>>> often the app won't know about all specifics either and it'd be
>>>>> resolved on zcrx registration.
>>>>
>>>> I think, fundamentally, we need to distinguish:
>>>>
>>>> 1. chunk size of the memory pool (page pool order, niov size)
>>>> 2. chunk size of the rx queue entries (this is what this series calls
>>>>      rx-buf-len), mostly influenced by MTU?
>>>>
>>>> For devmem (and same for iou?), we want an option to derive (2) from (1):
>>>> page pools with larger chunks need to generate larger rx entries.
>>>
>>> To be honest I'm not following. #1 and #2 seem the same to me.
>>> rx-buf-len is just the size of each rx buffer posted to the NIC.
>>>
>>> With pp_params.order = 0 (most common configuration today), rx-buf-len
>>> == 4K. Regardless of MTU. With pp_params.order=1, I'm guessing 8K
>>> then, again regardless of MTU.
>>
>> There are drivers that fragment the buffer they get from a page
>> pool and give smaller chunks to the hw. It's surely a good idea to
>> be more explicit on what's what, but from the whole setup and uapi
>> perspective I'm not too concerned.
>>
>> The parameter the user passes to zcrx must controls 1. As for 2.
>> I'd expect the driver to use the passed size directly or fail
>> validation, but even if that's not the case, zcrx / devmem would
>> just continue to work without any change in uapi, so we have
>> the freedom to patch up the nuances later on if anything sticks
>> out.
>>
> 
> I indeed forgot about driver-fragmenting. That does complicate things
> quite a bit.
> 
> So AFAIU the intended behavior is that rx-buf-len refers to the memory
> size allocated by the driver (and thun memory provider), but not
> necessarily the one posted by the driver if it's fragmenting that
> piece of memory? If so, that sounds good to me. Although I wonder if

Yep

> that could cause some unexpected behavior... Someone may configure
> rx-buf-len to 8K on one driver and get actual 8K packets, but then
> configure rx-buf-len on another driver and get 4K packets because the
> driver fragmented each buffer into 2...

That already can happen, the user can hope to get whole full buffers
but shouldn't assume that it will. hw gro can't be 100% reliable in
this sense for all circumstances. And I don't think it's sane for
driver implementations to do that. Fragmenting PAGE_SIZE because the
NIC needs smaller chunks or for some other compatibility reasons?
Sure, but then I don't see a reason for validating even larger buffers.

> I guess in the future there may be a knob that controls how much
> fragmentation the driver does?

Probably, but hopefully it'll not be needed

-- 
Pavel Begunkov


