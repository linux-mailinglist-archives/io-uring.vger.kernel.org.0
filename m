Return-Path: <io-uring+bounces-3586-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CCA4999C79
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 08:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E910B21CF9
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 06:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE4BE1CCB40;
	Fri, 11 Oct 2024 06:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="H04W7HKC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2B219923C
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 06:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728627332; cv=none; b=Ugr5QgfKFYhPEZ20raqhc/VvCUaAKHymU1SCaOguJvAtqcOnUvn2s6U7qXENIz8oi1tfveKF0ym/kYHzz0IyVHol58HE5czGqLgWPaSNZIDMHEr0r7y2wv3BUpXHxzJPd7LAtWsOz94lUDNXkUzuNsJoGrnzusVpqFoAMFeHwgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728627332; c=relaxed/simple;
	bh=cWndFxD9+i6+o7VKRHZXEVet608yqtvjE1X2colHVHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=etHh0sBlZjnYkVsHV/BZYU81ag4zGJsa04tnoQpHQ+b3T2VpSTFVWN50ODhZq5gxWU5KfHwwgi4z9IEQbWEEN6YYFE6o43flYqdBmSbZ16lThFQ4fSCr5Gsi01bKD09SAPDp67a4sFzKfbXLR4sN16SWT7jgFBtUO4cmj84yT7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=H04W7HKC; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-71def715ebdso1183085b3a.2
        for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 23:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728627331; x=1729232131; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mmaeyX3vpGaL8HuyG+ubgvAZ5sFwbFygc6Y/CXKcjWA=;
        b=H04W7HKCxSHJf+LD4NA/f96wWXkFI7qMYq0papwcEMeBRm42wAG7dGiJjtfD2fTOWC
         +xfKY8HlurDjmVo2N1ygXvHvi5Oi8mt5Gt/g9hqYmUwyf5jt3ZVkJbrwWDFW3ty8cjo/
         WXyPVH2jqyuW6277+xnSWtbZlIpxBJZEfSV/dXabf8RIVRw/Llk+0udT2HqVK5Nbl8WY
         rVUEbs3OrP+nKHgHqufAP7sePAI/2cWwT7689VLm9XPG9MnveXmx9IyNWMijpmEU/Jju
         mu1/4oaxovKPqI/L2iK3WHqNsk9UoH7yyngACqnbsY7KL5viSubHcGEoPpBRz0fWRurg
         J+HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728627331; x=1729232131;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mmaeyX3vpGaL8HuyG+ubgvAZ5sFwbFygc6Y/CXKcjWA=;
        b=P93PzUMLaVlOJ6XvB+VJms06sFAZIUxZcS/EtOAGdGkKAHitmVnS9Y7zr4tEPmSFSP
         3NhJF0fKl5FpKjzBPZLytxmRmj8uQswdZJbOciiZY2eQOpdWFhzGre2zmR2nP2cJt+tJ
         VoDyT12s5RPMgJqD4FIxOXnHEZkhiA0fOstxwocqD7C0Zn38gSoBS1keDV+BuWgN8XDV
         5Ox2i3V+VjMJ80bjyTK+edbCchRAbglorNIiBE1CgEArAPSZlKnUWA/azMm0iVKWt3Et
         qxjaHeU3FA+wAxQWB1ojVRJSrRuih84lprrkU+ulXqNKuGQ0qDzS41NCNAmDJrZ0sGAL
         8EeQ==
X-Forwarded-Encrypted: i=1; AJvYcCWltpBYn3/W98PY/fSU3CS0I1IKSKPI36xg67kGefhr2FEnDxftaeZIZeNrxHHhrfIdj+RLK+0iPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwDsiY1GZL81JmG/n6lTUtmFRsqwZLT38GXcaiEyF/dcFeARw7T
	As2oUzeh7ZN1aA0i6PFVK8B4TjFmpN3etn3M6CZIo8QQATFndrL41tM/JyMvUGg=
X-Google-Smtp-Source: AGHT+IEYVYm/SdeQXDP0ZXZ+auF3+i+IUf9a1y4JeSOo/NLQnRKaD4rFyDYRpkkQTAyOHi4NKMRd3A==
X-Received: by 2002:a05:6a00:228c:b0:71e:165c:2359 with SMTP id d2e1a72fcca58-71e38083fb7mr2447904b3a.26.1728627330535;
        Thu, 10 Oct 2024 23:15:30 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21e1::116b? ([2620:10d:c090:400::5:ebf3])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aa93882sm1978849b3a.103.2024.10.10.23.15.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 23:15:29 -0700 (PDT)
Message-ID: <550cf666-ea4f-4dac-9acf-fad448324e87@davidwei.uk>
Date: Thu, 10 Oct 2024 23:15:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Joe Damato <jdamato@fastly.com>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <ZwW7_cRr_UpbEC-X@LQ3V64L9R2>
 <6a45f884-f9d3-4b18-9881-3bfd3a558ea8@gmail.com>
 <4e285394-3a07-4946-b7a4-c4e503f9a964@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <4e285394-3a07-4946-b7a4-c4e503f9a964@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-10-09 09:12, Jens Axboe wrote:
> On 10/9/24 9:07 AM, Pavel Begunkov wrote:
>> On 10/9/24 00:10, Joe Damato wrote:
>>> On Mon, Oct 07, 2024 at 03:15:48PM -0700, David Wei wrote:
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
>>>
>>> This looks super cool and very useful, thanks for doing this work.
>>>
>>> Is there any possibility of some notes or sample pseudo code on how
>>> userland can use this being added to Documentation/networking/ ?
>>
>> io_uring man pages would need to be updated with it, there are tests
>> in liburing and would be a good idea to add back a simple exapmle
>> to liburing/example/*. I think it should cover it
> 
> man pages for sure, but +1 to the example too. Just a basic thing would
> get the point across, I think.
> 

Yeah, there's the liburing side with helpers and all that which will get
manpages. We'll also put back a simple example demonstrating the uAPI.
The liburing changes will be sent as a separate patchset to the io-uring
list.

