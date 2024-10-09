Return-Path: <io-uring+bounces-3522-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E9969975D4
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 21:43:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C06151C20B7E
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 19:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726C41E1C09;
	Wed,  9 Oct 2024 19:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MqAnHW29"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DDC17F505;
	Wed,  9 Oct 2024 19:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728502957; cv=none; b=lPQgeKfUaAYpSFh89oH4go0MOpeWg8vGp3H6BtEM8v9ryxNb9pr2lOkT2cYovxq6Ma4WMHwtBAr9LUFLyTkZRV3U/iKp+EysmY7bFZkHOlrp0dnczCezDtSfS34ErfcoJcI8wnsoMTrfSCwBWHLBptlAXf7yJ87qgExXPqBBc1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728502957; c=relaxed/simple;
	bh=bG+uisWcp4goLrBjGPWdGlfGxzFXSVzCFmKx7O7LLrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A3X7eKxVg5+McHF8G7TsWc1iObT63ger88gfAM5/OBCDI+FA/TXQshqeDRFZAdafOIf/V50efmyla0KoIyuhg87L/X9LQIl2qdNEN46VCpnbRqAJOHEL+NjxQhkxiGO8gwvdlYtU8LaEapXaHiSduObzK5vdQeZlayOmSSDNTo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MqAnHW29; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5c718bb04a3so99841a12.3;
        Wed, 09 Oct 2024 12:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728502954; x=1729107754; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wd8PzFBjoTdbpvgyVJwRFjEbCfUgmfHjWSfi3XVJtEk=;
        b=MqAnHW29IpEW1Xw1Agg+pKuxJ92XHIhNvIyZrXe1yMs7mtcYWE7Wwjz5m6Q6EhgjQq
         mrYATYxNp5DvIBwIqQLNpAJ7zyF8OPxo/zxCla3X5rAiXotf8OUuf0HY3IC9jD4xnx53
         Tc4NqWaXYmcHjNgrhORCuY7INrsXndm+m8vqOapdtF9A2YPTwH1ZwLYWKe2WrzjdJvVE
         Xmn6dn5Zl96ZzJo6vptQAm6XpQwT4HNsHqb6KynbEVI9f7LNYii2i7ZLXwgs0ph8POW7
         eTATldS71EughkEIQiZYkDN060QnyVjTaF5Dw7X/24/DkWKS57tpvIKmMUClcHsEoHBI
         +bYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728502954; x=1729107754;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wd8PzFBjoTdbpvgyVJwRFjEbCfUgmfHjWSfi3XVJtEk=;
        b=HaRrx8Gm1TWzxTRYEvgbmiF+uwvOf9V1fnncEdFYHjJF8lMrDVJaDKFfCqPRLK1lbS
         tGujhEDchdJzSLI8tswT70o6+zwlZI8uJi2ot5y3wFjLiJf+EXhJnt6rovCiNiOF9OAf
         ahWpwE/NPoTD/bBRibZ1/RFpsvUamNZB0/HAz566jgvgkBD88XC9fr+bhyz2bYpED1j+
         rZfc7dhkMShms73c1LVw2k2hwXLJ0sKkSGShleuY5B5y1KMKWusEzHa60AKz4Zf5k805
         WUfhuwAj4Thbivsl8EgBBPgQpom81hn1DzfnGcUkNStBVYHnRZL2qodb3wctvqNzf2+U
         GR6w==
X-Forwarded-Encrypted: i=1; AJvYcCVBiLhcMoA4v5BQY3NdQK/w3N5cRoP83XPghpYN5HLQuvAdbhUysDY7PCHenVjaoYzZ4wex0W4gGA==@vger.kernel.org, AJvYcCVr07D8/a/JK2BwbKYttH+lo2jtmw8w8q7s0/QpT4L+2s+kThZ+O8lGEpU6S/3inOipXySvpahM@vger.kernel.org
X-Gm-Message-State: AOJu0YwIQEc64xUMzi9DARq+jT2EfV7Nmzr6AXxLEwAkojgHZZBtTJha
	WHMFsLlOCImcDc1JObeCvaNali+/w1u2Y7/HWKDqTTS08wNl+Zmm
X-Google-Smtp-Source: AGHT+IHsytZIylDr3QwalSXlM5QvOVtLzYQ69u4F9drUatsMVHIg0QCjnAxUVXfh8KbCStUHkozCag==
X-Received: by 2002:a05:6402:27d0:b0:5c8:9f81:43e4 with SMTP id 4fb4d7f45d1cf-5c91d53f989mr2513842a12.7.1728502953858;
        Wed, 09 Oct 2024 12:42:33 -0700 (PDT)
Received: from [192.168.42.9] ([148.252.145.180])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c92d2a63f3sm525260a12.18.2024.10.09.12.42.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 12:42:32 -0700 (PDT)
Message-ID: <b96b1602-6f76-4624-91f0-68d4f43756ce@gmail.com>
Date: Wed, 9 Oct 2024 20:43:08 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
To: Mina Almasry <almasrymina@google.com>, Jens Axboe <axboe@kernel.dk>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <CAHS8izOv9cB60oUbxz_52BMGi7T4_u9rzTOCb23LGvZOX0QXqg@mail.gmail.com>
 <016059c6-b84d-4b55-937c-e56edbedc53a@kernel.dk>
 <CAHS8izOF5dM7WUrzDhGrR_UP7t_Mg7=sgti_TSbqG4x00UBfXA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izOF5dM7WUrzDhGrR_UP7t_Mg7=sgti_TSbqG4x00UBfXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/9/24 20:32, Mina Almasry wrote:
> On Wed, Oct 9, 2024 at 9:57 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 10/9/24 10:55 AM, Mina Almasry wrote:
>>> On Mon, Oct 7, 2024 at 3:16?PM David Wei <dw@davidwei.uk> wrote:
>>>>
>>>> This patchset adds support for zero copy rx into userspace pages using
>>>> io_uring, eliminating a kernel to user copy.
>>>>
>>>> We configure a page pool that a driver uses to fill a hw rx queue to
>>>> hand out user pages instead of kernel pages. Any data that ends up
>>>> hitting this hw rx queue will thus be dma'd into userspace memory
>>>> directly, without needing to be bounced through kernel memory. 'Reading'
>>>> data out of a socket instead becomes a _notification_ mechanism, where
>>>> the kernel tells userspace where the data is. The overall approach is
>>>> similar to the devmem TCP proposal.
>>>>
>>>> This relies on hw header/data split, flow steering and RSS to ensure
>>>> packet headers remain in kernel memory and only desired flows hit a hw
>>>> rx queue configured for zero copy. Configuring this is outside of the
>>>> scope of this patchset.
>>>>
>>>> We share netdev core infra with devmem TCP. The main difference is that
>>>> io_uring is used for the uAPI and the lifetime of all objects are bound
>>>> to an io_uring instance.
>>>
>>> I've been thinking about this a bit, and I hope this feedback isn't
>>> too late, but I think your work may be useful for users not using
>>> io_uring. I.e. zero copy to host memory that is not dependent on page
>>> aligned MSS sizing. I.e. AF_XDP zerocopy but using the TCP stack.
>>
>> Not David, but come on, let's please get this moving forward. It's been
>> stuck behind dependencies for seemingly forever, which are finally
>> resolved.
> 
> Part of the reason this has been stuck behind dependencies for so long
> is because the dependency took the time to implement things very
> generically (memory providers, net_iovs) and provided you with the
> primitives that enable your work. And dealt with nacks in this area
> you now don't have to deal with.

And that's well appreciated, but I completely share Jens' sentiment.
Is there anything like uapi concerns that prevents it to be
implemented after / separately? I'd say that for io_uring users
it's nice to have the API done the io_uring way regardless of the
socket API option, so at the very least it would fork on the completion
format and that thing would need to have a different ring/etc.

>> I don't think this is a reasonable ask at all for this
>> patchset. If you want to work on that after the fact, then that's
>> certainly an option.
> 
> I think this work is extensible to sockets and the implementation need
> not be heavily tied to io_uring; yes at least leaving things open for
> a socket extension to be done easier in the future would be good, IMO

And as far as I can tell there is already a socket API allowing
all that called devmem TCP :) Might need slight improvement on
the registration side unless dmabuf wrapped user pages are good
enough.

> I'll look at the series more closely to see if I actually have any
> concrete feedback along these lines. I hope you're open to some of it
> :-)

-- 
Pavel Begunkov

