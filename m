Return-Path: <io-uring+bounces-3346-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D947B98BDE0
	for <lists+io-uring@lfdr.de>; Tue,  1 Oct 2024 15:35:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B78C1C2215E
	for <lists+io-uring@lfdr.de>; Tue,  1 Oct 2024 13:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62BF61C461C;
	Tue,  1 Oct 2024 13:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BrFBQV5X"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BE21C460C
	for <io-uring@vger.kernel.org>; Tue,  1 Oct 2024 13:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727789738; cv=none; b=deiec0sSCFhKe4DImUGlZ4KJr6q6h1LrdxG8G+B4dJScgP1vVKtown90nREKE/HYKOSGtOqmEiez2odDi0C6UoCnjI60MASTd2Mejv719rd0P9TN7H2ZT/EbO0KV+vywYlK50W6f26+rX572UF6jl9dCzCEnkM2Q73IQz42mB/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727789738; c=relaxed/simple;
	bh=+KoryTco6wBMzsWP6v3K3MzAAYCO8/g5hNEdQ/inc2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z7AlwgApTGyom9gpQ15zgLxLdmf7+Fx1k9XTNJ91721aBzbDUhaTewYa5J/fz2VZAUVT8pqGIp8ZWI2z0lOJ56Yv9+K29OYh8drcXsz6jFxLsKht2c7SuQFNRqptLU+1Kv53nJkq8Ck+d3otOeq1PVPJ+8xYiqlVesSEEpWlVB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BrFBQV5X; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-8324124a172so271169239f.2
        for <io-uring@vger.kernel.org>; Tue, 01 Oct 2024 06:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727789735; x=1728394535; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OgL5rd3KvxVTO/uJOqBplF7gKZBP1S9mwJ5BPmOEOSk=;
        b=BrFBQV5XgWm016xr/nZni++dQ2KFWys3YAiOKRKmyUFTyf3awNZHP4g40ekH4o5eCO
         i+9atbHNcDnIBY5x7FS7pURc5SfkXocIcKQRf9ySzxGMprjlfO0r+FB0mYUxgoNs8eDn
         9rT3PcbwLPA02bqFvB8O5oWsM/Tl+p9EOHsblepMiGeeSkNNuDcrMY4VmtQHw4El8Gbe
         zsxLm2RvQoz+uKKgoCql2pqxDl+nk44K0JH448y0mucjAn8NeR93vihbIwFYNSH0LRWs
         0PJbG+t6x13uvPtPlwpjI0D7n24T3jxY4j4n449k8qjihnjNFwGji7ltF1YlezECf6Wz
         iivA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727789735; x=1728394535;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OgL5rd3KvxVTO/uJOqBplF7gKZBP1S9mwJ5BPmOEOSk=;
        b=mTRD8yH3bvi5qrzjDa6+uVB8J9yKeU7+y8XtWoKuGUc5blBlXOKan+qDEVvWlw59hN
         CH+gBE5bXsBy3js7HxQacLy09dLYyrWXRawvWLBxNk7Oy05OjYUifEWUDhCI0n7z4kXo
         vV5Sfmwiyagel/iw2fOS3ajjXuyH+R5MUIXVV84NoSoE5LSmtn6zlmk3unrGEvM2a3mX
         eaiBwFr0dXLWJXdyh7DqN4HDT1LSG133wuiPIme7MUDFFqew+dnCiRYLLLYrXwXU7YWj
         JmX0R8/4vEBTSxEqqlJ0IKIUJF5OB4FtxN46JbMQlmPm+UwCBvyTQcgSEe6UPAjFqavg
         /bAA==
X-Forwarded-Encrypted: i=1; AJvYcCWLWMS+F0GGJOmb5cSIeQ9GNbX0OeiiVi7GjBunBUoyVsNI05NrQSGQm3WXluwgFkkFtykvvchCFg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ8MO2WQOsEajJPBNlFlX9KnJs/IChVMFREOUciAyCQLlKKR9g
	FsFcjCMw30ua1Oxt3FUR8DIdYTAcEWeZN418x8tIjwNi70iblZf515CuqbODFI0=
X-Google-Smtp-Source: AGHT+IHG5lToJh8LSYS16u7mBh+qtGBfzo1ovi31Kf1FK7684UVjTXOg2EW6WyrZ9o/eP4/O5KtDjg==
X-Received: by 2002:a05:6602:2b04:b0:82d:96a:84f4 with SMTP id ca18e2360f4ac-8349318d38amr1668545339f.1.1727789734880;
        Tue, 01 Oct 2024 06:35:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d88883518bsm2673695173.20.2024.10.01.06.35.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2024 06:35:34 -0700 (PDT)
Message-ID: <f588a1dc-590f-46aa-8d0c-ac792606c662@kernel.dk>
Date: Tue, 1 Oct 2024 07:35:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0/2] io_uring/io-wq: respect cgroup cpusets
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
Cc: "Schmidt, Adriaan" <adriaan.schmidt@siemens.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
 "Bezdeka, Florian" <florian.bezdeka@siemens.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "longman@redhat.com" <longman@redhat.com>,
 "asml.silence@gmail.com" <asml.silence@gmail.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "dqminh@cloudflare.com" <dqminh@cloudflare.com>
References: <20240911162316.516725-1-felix.moessbauer@siemens.com>
 <2024093053-gradient-errant-4f54@gregkh>
 <db8843979322b9a031b5d9523b6b07dca9c13546.camel@siemens.com>
 <2024100108-facing-mobile-1e4a@gregkh>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2024100108-facing-mobile-1e4a@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/1/24 1:50 AM, gregkh@linuxfoundation.org wrote:
> On Tue, Oct 01, 2024 at 07:32:42AM +0000, MOESSBAUER, Felix wrote:
>> On Mon, 2024-09-30 at 21:15 +0200, Greg KH wrote:
>>> On Wed, Sep 11, 2024 at 06:23:14PM +0200, Felix Moessbauer wrote:
>>>> Hi,
>>>>
>>>> as discussed in [1], this is a manual backport of the remaining two
>>>> patches to let the io worker threads respect the affinites defined
>>>> by
>>>> the cgroup of the process.
>>>>
>>>> In 6.1 one worker is created per NUMA node, while in da64d6db3bd3
>>>> ("io_uring: One wqe per wq") this is changed to only have a single
>>>> worker.
>>>> As this patch is pretty invasive, Jens and me agreed to not
>>>> backport it.
>>>>
>>>> Instead we now limit the workers cpuset to the cpus that are in the
>>>> intersection between what the cgroup allows and what the NUMA node
>>>> has.
>>>> This leaves the question what to do in case the intersection is
>>>> empty:
>>>> To be backwarts compatible, we allow this case, but restrict the
>>>> cpumask
>>>> of the poller to the cpuset defined by the cgroup. We further
>>>> believe
>>>> this is a reasonable decision, as da64d6db3bd3 drops the NUMA
>>>> awareness
>>>> anyways.
>>>>
>>>> [1]
>>>> https://lore.kernel.org/lkml/ec01745a-b102-4f6e-abc9-abd636d36319@kernel.dk
>>>
>>> Why was neither of these actually tagged for inclusion in a stable
>>> tree?
>>
>> This is a manual backport of these patches for 6.1, as the subsystem
>> changed significantly between 6.1 and 6.2, making an automated backport
>> impossible. This has been agreed on with Jens in
>> https://lore.kernel.org/lkml/ec01745a-b102-4f6e-abc9-abd636d36319@kernel.dk/
>>
>>> Why just 6.1.y?  Please submit them for all relevent kernel versions.
>>
>> The original patch was tagged stable and got accepted in 6.6, 6.10 and
>> 6.11.
> 
> No they were not at all.  Please properly tag them in the future as per
> the documentation if you wish to have things applied to the stable
> trees:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

That's my bad, missed that one of them did not get marked for stable,
the sqpoll one did.

-- 
Jens Axboe

