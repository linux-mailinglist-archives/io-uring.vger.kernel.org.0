Return-Path: <io-uring+bounces-5988-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D3DA15410
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 17:18:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 496B17A3355
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 16:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6474319ABAB;
	Fri, 17 Jan 2025 16:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="msbZ6pG3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D369443;
	Fri, 17 Jan 2025 16:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737130709; cv=none; b=Y8QJPsZANcyoew/j/Wykl8JsHjQQ0o3EAPuiI+NNC8wl5F/Yl3aVOmMmxd9pEiHlEd0xiUt5y4N6eEVrBxI3R+wPbOUBYCO+W/c1PcVUJ3BhF3AVM8+eCoTF2bV7x2RV4BJ47GTtIlabPNLYpezUr46k8iByhgvaoBbb0NXcbiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737130709; c=relaxed/simple;
	bh=H30YAu54q3FjWz55Z5MS665Mz7D7iGOCU9G8Q8djKPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BTLD78xT/8sJ3sMRNyoT8h1AnbFtGfrSbUvKABlKmxdr2jXd6wraUVETRNteRdRM9zIe49OHgKk/3aJ7qGZg2WWbWnWu5U4pn5SSnZ+VlbpL7giTCBjRW1WXuGSzQzDWmeEx1I276fKiL4BFh4NePwj3Vu7+lERKGIfaZGNtRHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=msbZ6pG3; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ab39f84cbf1so38549266b.3;
        Fri, 17 Jan 2025 08:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737130706; x=1737735506; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8co1a7wv4+Y2VVTmsu7Jr8NcJfElBwN78vRge4ydYT8=;
        b=msbZ6pG3lLUnzSkBmACQScShnLDdjxRVY4KCAhvE/MSPdamteiS+mAfyo0/XN5G/vX
         4Cnrht63Rr126j9V9U5GHMw5fwQvqjZjQnwhQYjm7vku7xYGEjReHaRXy8qg/PlwiNbk
         BKAHVT/2BVV8loDaejPOb9lMBHZ5OB9FNI7AFGUnKxL0Y2oBzjV2prl/56LgYqAeVyrJ
         pjVmIebXtMOipFBriJA9VjtkO3QoDl8bVhwMvB4tb6ArpS2A2y2YIGBYpR55unD7Yiw8
         918JF3Z2LG1qp+wobGindU50JoQ98Pi54WE5Ljr6NjHtciDVAnSbkaqboeZPe2qmW++X
         lTFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737130706; x=1737735506;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8co1a7wv4+Y2VVTmsu7Jr8NcJfElBwN78vRge4ydYT8=;
        b=CrkwvMISpVzhzHEyrxyXoeVWE+rQem7XoHWtTgLs2ifk5JF4l53TIyqgyzGGqsOKVT
         +xWQYgg2f5kThFHbxx7c54f7uLEP/X2xZFVWM+2bbFA9wHo4Do/h7cm2DJfe7criBsyI
         Xv6zOb4BYeTzafQn4jZ+IJ5gsKG3Fasag1nLfzclIgFLcxlswb7fR/GwLJNcoCGSlFP8
         ACi1kNL+5GlafIwjy+6BTgaTBbluNzn491+DCdjyOgdeO8AhxAkwFEGY/cXgr2MSeqe6
         LW+xJiSo5TeQOiYJZspPy9cSepo7iPy8U0Uu0tVxPciiEYsgFqUIB8S4ww7Ufzwexy1/
         JZ2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUbZXklcMvep+3huqO8RjsbRYCbkto8JxQvgv1HGpHDzNpQivN6AQorrahZSbmOt8C3f5xiNnCQIg==@vger.kernel.org, AJvYcCWOY9Yl3RGYqeUWeLOJoCcum9GWnZB3WhjpU6L9ee/yy2r0VoJK8Bt8ujopYqqJTFqnhnIimJv0@vger.kernel.org
X-Gm-Message-State: AOJu0YzymIuAINjOhES+24EQMlMPjTgn1iZSPckNcZ3JsnXXXKDkJ1YH
	Hhn3ZrZP0ozMp5fw3TWCkuvg07sh+4QEhaizHptb3gw4HU+hUe0A
X-Gm-Gg: ASbGncvI32Z6FYMNc7VP+Agy7dhlt9HEpwExNy5R2e3FSksKwprym7Lshj4g35PLfir
	Vhm5ES4tVRiWaSN74fEtLcwKCa661xl98/WKW8wyDoHm9sYU+qcnwwvHxFx60Ua/n3w71XNb2cZ
	sw9KkZgTt3ZzwcSExcH8YmMS9L+sAhpNxiQ8rq6bOODw0wsxRFlIjRgKSsn0gZangweIEeD0/nN
	zq2v33ulIuKlkjSrWojQnQYY0b5f7PtguziHPEPFEfmYg1v2tX08x2zZVNcflTR8AXO7T6FcuXz
	wpMCXqPEH/9Phw==
X-Google-Smtp-Source: AGHT+IGo7pRyf6/gnIgkcTwwx90nAh1ndHVKLlnZo67jxd++rcz5yWQb77oRDz4SsXn1vUQCuJqUfw==
X-Received: by 2002:a17:907:940d:b0:aa6:a05c:b068 with SMTP id a640c23a62f3a-ab38b3d6ec1mr297745766b.56.1737130705975;
        Fri, 17 Jan 2025 08:18:25 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384c61388sm192232566b.20.2025.01.17.08.18.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 08:18:25 -0800 (PST)
Message-ID: <dfa31033-c4c1-4430-81b2-5df41afc33a2@gmail.com>
Date: Fri, 17 Jan 2025 16:19:09 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v11 00/21] io_uring zero copy rx
To: Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <20250116231704.2402455-1-dw@davidwei.uk>
 <406fcbd2-55af-4919-abee-7cd80fb449d3@redhat.com>
 <ce9caef4-0d95-4e81-bdb8-536236377f81@gmail.com>
 <c25f6c3f-e576-4c56-ba4b-328dfecbfb35@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c25f6c3f-e576-4c56-ba4b-328dfecbfb35@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/17/25 16:05, Paolo Abeni wrote:
> On 1/17/25 3:42 PM, Pavel Begunkov wrote:
>> On 1/17/25 14:28, Paolo Abeni wrote:
>>> On 1/17/25 12:16 AM, David Wei wrote:
>>>> This patchset adds support for zero copy rx into userspace pages using
>>>> io_uring, eliminating a kernel to user copy.
>>>>
...
>>>> Broadcom bnxt support:
>>>> [1]: https://lore.kernel.org/netdev/20241003160620.1521626-8-ap420073@gmail.com/
>>>>
>>>> Linux kernel branch:
>>>> [2]: https://github.com/spikeh/linux.git zcrx/v9
>>>>
>>>> liburing for testing:
>>>> [3]: https://github.com/isilence/liburing.git zcrx/next
>>>>
>>>> kperf for testing:
>>>> [4]: https://git.kernel.dk/kperf.git
>>>
>>> We are getting very close to the merge window. In order to get this
>>> series merged before such deadline the point raised by Jakub on this
>>> version must me resolved, the next iteration should land to the ML
>>> before the end of the current working day and the series must apply
>>> cleanly to net-next, so that it can be processed by our CI.
>>
>> Sounds good, thanks Paolo.
>>
>> Since the merging is not trivial, I'll send a PR for the net/
>> patches instead of reposting the entire thing, if that sounds right
>> to you. The rest will be handled on the io_uring side.
> 
> I agree it is the more straight-forward path. @Jakub: do you see any
> problem with the above?

I couldn't cleanly base it onto linus' branch, so after talking it
over with Jens, I sent it as a normal patchset. Jens will help to
handle the rest if the net patches are merged.

-- 
Pavel Begunkov


