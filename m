Return-Path: <io-uring+bounces-8867-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0B7AB176D3
	for <lists+io-uring@lfdr.de>; Thu, 31 Jul 2025 21:56:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A5B27AED69
	for <lists+io-uring@lfdr.de>; Thu, 31 Jul 2025 19:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A9DC24EF90;
	Thu, 31 Jul 2025 19:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AaN4qjFB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8889C1990D8;
	Thu, 31 Jul 2025 19:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753991767; cv=none; b=Ap4erzSB81OSKb4Ro9OZ8SIToQI7aldv61S97mzYtZp4KT0YUy0YhfHXserEO/VTDZg87rAyuJ3tKiKiRzDzU5Ya81g+2tSJiwzFkVeraWtqMAixWmKhqkAwDpz66YYU6QkqjgTwglXnlazbmQztpLATyw4YVA/dyHb9edDs6n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753991767; c=relaxed/simple;
	bh=rXfHp0slHz04T6fQwjIqVlFimNs92roGN1EA1G0xttA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D1YyJRcx4RxTkGr0j1Y0A0mO2WUkyUxrE+zAxvk/jAbzgW3JvuCw3wsROM6Vj7/JZqzaUbDXH/nh+K1DpT+8Pzc/vjwHrxM0dSZfLYj6rAeKxgXHZZPTZB1JO479Cm3n1mFRkxZ3Cllte7wJlkjE8+9NQf1/BOHSYr11uB5Y0ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AaN4qjFB; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b780bdda21so75821f8f.3;
        Thu, 31 Jul 2025 12:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753991764; x=1754596564; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EIPKOFRTx5RXKSxKA7TRJnFWgmX4Bg8OQ60/5TQCAQg=;
        b=AaN4qjFBluFdYGXI6u0b1YyTlu3jOF9MUrkZnfpQ3mim7ROu1xntgVJuTMsqNw111o
         2C051QRj3YPzfRIrshNJOUKiUJX8dCrLuOiNGk+FKU8B4yo7ywfXuzeA9xmijmxUelhf
         8DFSCVtDzo4a8WIZYy+zywmT/cGrjgQkiwPJJw8GfMJI7Gw2aXvWQocLGkaq5bs4q5wX
         G1VuKShkGN5QSWg3aYf+NjNxLPJa5FDIHSw4mWsUMwf7USGffXV+vSX9KjYJCAscEE+P
         rrVyhMk/UiMLg2tg8HM+iVheQ3m56JTG4HVDH2WZmr+LsW+v3y21zgZ+s3OE7aX35YQY
         oB9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753991764; x=1754596564;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EIPKOFRTx5RXKSxKA7TRJnFWgmX4Bg8OQ60/5TQCAQg=;
        b=vwZyGdzKpvuW5oheJeQe9sucT6UKXO6lwQRPu1WxM94g5vjaemCcdzL92KNeWHtxVV
         rtkvLFYz1V2quZHP7HxVL5U8ZZ1WlN7dyUDZ08gh0q+LocWBuYAB7cO4R0FzRem1aZq3
         CH0dhe7TWO4Xiq9bUnYMORGr8gE5pJJwKa9SEMJ4OIjNq++noGRs8GzgHh1VBmsckGHZ
         z247p9sTHZ/Gz8IsKXWbOD3l1k80wIPPO21Nyvby/iVZgCo100KYCz/2XuvCCgISpZKj
         AMreFrh0zgcN+dWqm7RMwIxtLjRVfL6Flg7ore1LyiICzoOD73djJe7ab0Lj8C7YBmYA
         RGQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUC4rpoymsD5I2TFKDzr2muD0E2Z6PBnBgvsVxZVm9WABJqo2XwPaWZGoZRRGFXdr+y469xGTWIsw==@vger.kernel.org, AJvYcCXdtIY3UCZIQHUHG/po3U75Nj3rPLPMWLeToZ8Im/kAsJejx8WobqGfahGhrYIj+XBTuNVJE9I9@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0noMn0ENkgKsmWdSWA8hJhfIip3PFc0idC/jf4EDtk04rcdw8
	pChk7XIg7b6Y9HPXBxinsKQTFLGJWcqZ8rB8/a0O8FqCQm7eXfzsYK7i
X-Gm-Gg: ASbGncubmuYwbIMnPWN0afr5le6N3wSuhZwF4REv7ZrOT+hXR5immZPJk3LqNIx843A
	6V7TXKLp6+79w8KvI/i0aUdSBn3uM4Tba2gqJuzjFjmGmrl4+IAVf9RctXSnaPHdt7CPbUoojIE
	F1gji4Ks1C1STgHb+OlnA91LrQV27mnGeDajkVQ8eazsU9nwtaRhr5kaJdqyzioBYDRc07+AO1P
	+vkRT9cPuKq0bLzxzbyd4AIokqsFbFwzdTlpQLbKvscyEvRf5ft5kUfxxmuYmb/uuDRvihdGEXS
	zzYeYe+vwwK1GegG0rXMMRPjSJO7yV7nwnQ9dCGMkxgO2xC7n56URgSKrQbaEvuH6sGl01/tTms
	ouSK7zxlntGZHSHpGkhy96f0ntLenWqIY
X-Google-Smtp-Source: AGHT+IFsfp9HW4DDdLEkosiJoyYBFZzO7hO+LHbAdg/uUXVbvSXHrVURRd9XrGMpN2w8nLppaCDvHg==
X-Received: by 2002:a5d:5f96:0:b0:3b7:8d70:dac5 with SMTP id ffacd0b85a97d-3b794fc1907mr7463270f8f.2.1753991763625;
        Thu, 31 Jul 2025 12:56:03 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.133.150])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9160sm3405041f8f.21.2025.07.31.12.56.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 12:56:03 -0700 (PDT)
Message-ID: <364568c6-f93e-42e1-a13c-f55d7f912312@gmail.com>
Date: Thu, 31 Jul 2025 20:57:28 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 00/22] Large rx buffer support for zcrx
To: Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izPYahW_GkPogatiVF-eZFRGV-zqH3MA=VNBjw4jfgCzug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/31/25 20:34, Mina Almasry wrote:
> On Wed, Jul 30, 2025 at 8:50 AM Stanislav Fomichev <stfomichev@gmail.com> wrote:
>>
>> On 07/30, Pavel Begunkov wrote:
>>> On 7/29/25 17:33, Stanislav Fomichev wrote:
>>>> On 07/28, Pavel Begunkov wrote:
>>>>> On 7/28/25 23:06, Stanislav Fomichev wrote:
>>>>>> On 07/28, Pavel Begunkov wrote:
>>>>>>> On 7/28/25 21:21, Stanislav Fomichev wrote:
>>>>>>>> On 07/28, Pavel Begunkov wrote:
>>>>>>>>> On 7/28/25 18:13, Stanislav Fomichev wrote:
>>>>>>> ...>>> Supporting big buffers is the right direction, but I have the same
>>>>>>>>>> feedback:
>>>>>>>>>
>>>>>>>>> Let me actually check the feedback for the queue config RFC...
>>>>>>>>>
>>>>>>>>> it would be nice to fit a cohesive story for the devmem as well.
>>>>>>>>>
>>>>>>>>> Only the last patch is zcrx specific, the rest is agnostic,
>>>>>>>>> devmem can absolutely reuse that. I don't think there are any
>>>>>>>>> issues wiring up devmem?
>>>>>>>>
>>>>>>>> Right, but the patch number 2 exposes per-queue rx-buf-len which
>>>>>>>> I'm not sure is the right fit for devmem, see below. If all you
>>>>>>>
>>>>>>> I guess you're talking about uapi setting it, because as an
>>>>>>> internal per queue parameter IMHO it does make sense for devmem.
>>>>>>>
>>>>>>>> care is exposing it via io_uring, maybe don't expose it from netlink for
>>>>>>>
>>>>>>> Sure, I can remove the set operation.
>>>>>>>
>>>>>>>> now? Although I'm not sure I understand why you're also passing
>>>>>>>> this per-queue value via io_uring. Can you not inherit it from the
>>>>>>>> queue config?
>>>>>>>
>>>>>>> It's not a great option. It complicates user space with netlink.
>>>>>>> And there are convenience configuration features in the future
>>>>>>> that requires io_uring to parse memory first. E.g. instead of
>>>>>>> user specifying a particular size, it can say "choose the largest
>>>>>>> length under 32K that the backing memory allows".
>>>>>>
>>>>>> Don't you already need a bunch of netlink to setup rss and flow
>>>>>
>>>>> Could be needed, but there are cases where configuration and
>>>>> virtual queue selection is done outside the program. I'll need
>>>>> to ask which option we currently use.
>>>>
>>>> If the setup is done outside, you can also setup rx-buf-len outside, no?
>>>
>>> You can't do it without assuming the memory layout, and that's
>>> the application's role to allocate buffers. Not to mention that
>>> often the app won't know about all specifics either and it'd be
>>> resolved on zcrx registration.
>>
>> I think, fundamentally, we need to distinguish:
>>
>> 1. chunk size of the memory pool (page pool order, niov size)
>> 2. chunk size of the rx queue entries (this is what this series calls
>>     rx-buf-len), mostly influenced by MTU?
>>
>> For devmem (and same for iou?), we want an option to derive (2) from (1):
>> page pools with larger chunks need to generate larger rx entries.
> 
> To be honest I'm not following. #1 and #2 seem the same to me.
> rx-buf-len is just the size of each rx buffer posted to the NIC.
> 
> With pp_params.order = 0 (most common configuration today), rx-buf-len
> == 4K. Regardless of MTU. With pp_params.order=1, I'm guessing 8K
> then, again regardless of MTU.

There are drivers that fragment the buffer they get from a page
pool and give smaller chunks to the hw. It's surely a good idea to
be more explicit on what's what, but from the whole setup and uapi
perspective I'm not too concerned.

The parameter the user passes to zcrx must controls 1. As for 2.
I'd expect the driver to use the passed size directly or fail
validation, but even if that's not the case, zcrx / devmem would
just continue to work without any change in uapi, so we have
the freedom to patch up the nuances later on if anything sticks
out.

  > I think if the user has not configured rx-buf-len, the driver is
> probably free to pick whatever it wants and that can be a derivative
> of the MTU.
> 
> When the rx-buf-len is configured by the user, I assume the driver
> puts aside all MTU-related heuristics (if it has them) and uses
> whatever the userspace specified.
> 
> Note that the memory provider may reject the request. For example
> iouring and pages providers can only do page-order allocations. Devmem
> can in theory do any byte-aligned allocation, since gen_pool doesn't
> have a restriction AFAIR.
> 

-- 
Pavel Begunkov


