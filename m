Return-Path: <io-uring+bounces-3492-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8373A997134
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:24:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4431D2834F1
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 16:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AAE71EF953;
	Wed,  9 Oct 2024 16:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BkdffbjI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C831EF95A
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728490346; cv=none; b=PV5EgoEpsCUdaI/2exDUxxOnXvfzXSl+BTHiSshLL1rQnM/Ih7Gcm1vRD7pCfaXQBkUkVXemldlSGTtkoSEk/zNOVkTBrui/YFirfZN6NSORkmPmeaM07AnSyMwNNBqw4XsUZ7XCDxgownJKT440ESU68cNNU8NKgKkshQ97vcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728490346; c=relaxed/simple;
	bh=2/449nv6Z8d1fs0P8CsWazVQNwMwmSnTu0mwfAfQTp8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=h9edN2mXVYmkA5VX9/MQW/981TSw54BIhRMALDD4h3N2/m8ZCu5E3sZ0jCSTDgosEBo/k3LzJMLizO9xeygJe6hMgWf5Bg9D3GGRGX6PC/HL+xseMNohHTfuwbTu/UsS4v6tt3Vn1cS7PNJLT5WuBqjaTR7WaeqL78vFNtDyWd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BkdffbjI; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3a274ef3bdeso84235ab.2
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 09:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728490344; x=1729095144; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ypdbOnq03K8zB/BMpNatlqc15a91nVgbkFIt4prHA3c=;
        b=BkdffbjIJKdVEQ+KtezANdLyfJv5R3DTJT5sHU+RfiEcikhXalTY/GDuJQbLVyBCIm
         vUEhHf1vMwJPV3V1FlZMXBIhc9iNfARk12ir8FESMpPRHOkwqr49gEAAxx3iXuA2Oceq
         QQDevd4x/5Wrh7rHj7klJxb5ziysa67SVZVrHEJMJt5k/1Z3/lf4J9i3fOEM4xaMwWg4
         ff0VbUKdCAVqJ2Hjl9FqoL1Xta25s2VIWTEAcPG3k8UxqI9MWtKbt+UyUveQLAaAQ5aD
         RP8r7JS52soBvh6QkqANBkSQ59PRtsejAmE/ZxJgxd9kzG/yI8xBhR0i4k42qUzzmKk9
         QzZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728490344; x=1729095144;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ypdbOnq03K8zB/BMpNatlqc15a91nVgbkFIt4prHA3c=;
        b=NBlYUlp85MUJiiMcRO21uXr2go+lVPeG7Fh9+sJlfuqD8guAIQh03MeNKOEUitwqOL
         KuO+fRNSLCqzP+knT7k7NyBlyHEDDDjdhyO21fmsLkYdWjOuJwdkvtoXcH8iTtpV7u2h
         S+jiYbE/jOYo1S/jp81Zl72Fg1crI8/628rOJDhjSNXEkkOjELA8IgYeEkATgxKKC5Ob
         9hPdZU72Xoy3XhawHnC66w/fsyZ2cDjyegVDWwY1rdVXDCq6o0N4ZrOKppk1mDlSlrRl
         KQkXJJbDLqo4SJVwe4pn0Pb5ITkJVgUrm9rnL+CJ1GXyo6nNTpw56X83aTsqX48X+6W7
         dLDQ==
X-Forwarded-Encrypted: i=1; AJvYcCU79fPGVA01X9vwJO2V+tKu66ld8162klsyiUs2TS1g6CP+DUFoSRBCnyr2Iiehs1ID6j7TRX1z6g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy87+01/WhZiRS08AQevxePWKV62+jq2KnGo2X9dRuRFBmDBPXl
	pWA0RfiqHvvAYxd7fKYG0IYfi+dk0PXNa18oRs8Jjmy1ekgl3kvbEh9tHdSbuXEK/XGtn+qYL1s
	Pxts=
X-Google-Smtp-Source: AGHT+IG/Qv3PJ++ptVRD9eqi50eCXlsUBJJwWjJBIny0JwyvooG4qrB89lQiMxJZaHsEsXYec8B+ug==
X-Received: by 2002:a05:6e02:1caf:b0:39f:53b3:ca63 with SMTP id e9e14a558f8ab-3a397cd8a7fmr25801405ab.3.1728490343684;
        Wed, 09 Oct 2024 09:12:23 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a396c271f1sm4666975ab.53.2024.10.09.09.12.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 09:12:23 -0700 (PDT)
Message-ID: <4e285394-3a07-4946-b7a4-c4e503f9a964@kernel.dk>
Date: Wed, 9 Oct 2024 10:12:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
To: Pavel Begunkov <asml.silence@gmail.com>, Joe Damato <jdamato@fastly.com>,
 David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <ZwW7_cRr_UpbEC-X@LQ3V64L9R2>
 <6a45f884-f9d3-4b18-9881-3bfd3a558ea8@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6a45f884-f9d3-4b18-9881-3bfd3a558ea8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 9:07 AM, Pavel Begunkov wrote:
> On 10/9/24 00:10, Joe Damato wrote:
>> On Mon, Oct 07, 2024 at 03:15:48PM -0700, David Wei wrote:
>>> This patchset adds support for zero copy rx into userspace pages using
>>> io_uring, eliminating a kernel to user copy.
>>>
>>> We configure a page pool that a driver uses to fill a hw rx queue to
>>> hand out user pages instead of kernel pages. Any data that ends up
>>> hitting this hw rx queue will thus be dma'd into userspace memory
>>> directly, without needing to be bounced through kernel memory. 'Reading'
>>> data out of a socket instead becomes a _notification_ mechanism, where
>>> the kernel tells userspace where the data is. The overall approach is
>>> similar to the devmem TCP proposal.
>>>
>>> This relies on hw header/data split, flow steering and RSS to ensure
>>> packet headers remain in kernel memory and only desired flows hit a hw
>>> rx queue configured for zero copy. Configuring this is outside of the
>>> scope of this patchset.
>>
>> This looks super cool and very useful, thanks for doing this work.
>>
>> Is there any possibility of some notes or sample pseudo code on how
>> userland can use this being added to Documentation/networking/ ?
> 
> io_uring man pages would need to be updated with it, there are tests
> in liburing and would be a good idea to add back a simple exapmle
> to liburing/example/*. I think it should cover it

man pages for sure, but +1 to the example too. Just a basic thing would
get the point across, I think.

-- 
Jens Axboe

