Return-Path: <io-uring+bounces-3499-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC8F997262
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:54:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D74D2B21907
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 16:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62ED01922FD;
	Wed,  9 Oct 2024 16:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="osSTszMx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12501547CF
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 16:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728492838; cv=none; b=nNbFL7pJuCHsYJBHeGzDH4T/ftqG8N4Ojl/oS/gr9x99niihTI94QBZCDWK+3elzv1Fw91TEZu4sXdvcaOOuBlrI8IbAxXOqLdfsiImiIfBtAoqwsMDtGu6U+XURrosQOyNH0GnmdbXqPCYhQy+rXA146aYA6vIryNwU3b8Ft4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728492838; c=relaxed/simple;
	bh=d/8oqFXh2BTGhvKwu9I/gZz9taXnlBYeWf9yQ3Zd72E=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=mwaFU65xGRdjM6j3LtA9qFlKADh7WUG6bUQfJgPGtpbYBrTksVTfLXSrFGXcA8Juof/D8p7/urCMHpTlpr3IgkpvDsLms6bKLz/werNMAk1VmALPLD0QI1dRAVWGj/x/aNdhYnFJU11ZGrrs/c2D3zZwSdd1kWAHp6hybbdiMYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=osSTszMx; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3a0c8b81b4eso318695ab.0
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 09:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728492836; x=1729097636; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ERwNH1evYH36DiY8JTCBnNjust6zk+bErbU2HMLuIrE=;
        b=osSTszMxbxIaBZg5QsskjuYc1lok57hmrE/9aFim5P0aTmmvINNKMRMUVwE9QqasfK
         JUIwVXzIPBnAjcpqIMbVPD2IInkQ4L6D1Oom95157kPbAUCBmd0odNgQS/adXoGAuZ+R
         XXgOc7Jrm7FK/Dl9TdxJrrWzitjqTc9gZL21yIxsDVyjdR3ukd/GiZ14fc72nK7AeSwq
         tyP2+t4hFJZlZPlBcMOfGBaM9OTFQat33xZIjBvDqmTymaii6pZ1JOy1XjF7oOqDwbe7
         IIZfXxZcEa3wQ/N+i7OYppQvI/17/BcXUM459uVazIkyPJrLmYq3BmdxzNQBvcDJIKAa
         eJrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728492836; x=1729097636;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ERwNH1evYH36DiY8JTCBnNjust6zk+bErbU2HMLuIrE=;
        b=jo9eo+OZ3v9QVSsLf/TPIZ9dO42ef5ZtHdwTrS26cWarNVMP93/ZskBGZwGoqJPq91
         ycWbA+Z3ke8FOyBj0nI59o8QmMopoAF3DMhVfO0evmbDqJbWQKnOMJ8gtayI0bhNpxi3
         +dAE2rj7PEDFBsoNASSOi82XvqNJ5hQXju4bmwbKuKr1055+wDMUk5bNhBZIr3YOFSLU
         XqpxVd065RhoFWzIhvx9DLUZCQ1KxstTFsE0nEROmg8V6/bY1OPajgK23t7yRApKxBWO
         tKIyIJOHJJPW8v31M0JS8AhqGZe+InT/cmd3NxsRiFGolBQCv2/CanRqmPfIVkzOiwEE
         jl3A==
X-Forwarded-Encrypted: i=1; AJvYcCUWLNESRrz8kUIeDRQKzCfhtLxc/4mkSq0qvoliyM7igoRlAYy+3e5MbDRcfu+RxFXBfVPECppnAw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyMTgI5p+lFNA7d8kBARQmCSFP70l88gD+77t8zRLCUGcqyfy+R
	ZWj59R4TVW8TKbKm+Oc6oiubBoERnVWc9B6Y11zK3AO3gBfOw3VS44j2fRZYwnk=
X-Google-Smtp-Source: AGHT+IF7xylDbYghBabw0F9xsuxJ+tbjFpSJe56k1O1PvWRw9lV44xClniMDQpwp8icCljwenlP9Lg==
X-Received: by 2002:a05:6e02:20c7:b0:3a2:74f8:675d with SMTP id e9e14a558f8ab-3a3a5d3bf5cmr4855205ab.20.1728492835981;
        Wed, 09 Oct 2024 09:53:55 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a37a87510csm23664175ab.79.2024.10.09.09.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 09:53:55 -0700 (PDT)
Message-ID: <d0ba9ba9-8969-4bf6-a8c7-55628771c406@kernel.dk>
Date: Wed, 9 Oct 2024 10:53:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
From: Jens Axboe <axboe@kernel.dk>
To: David Ahern <dsahern@kernel.org>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <2e475d9f-8d39-43f4-adc5-501897c951a8@kernel.dk>
 <93036b67-018a-44fb-8d12-7328c58be3c4@kernel.org>
 <2144827e-ad7e-4cea-8e38-05fb310a85f5@kernel.dk>
 <3b2646d6-6d52-4479-b082-eb6264e8d6f7@kernel.org>
 <57391bd9-e56e-427c-9ff0-04cb49d2c6d8@kernel.dk>
Content-Language: en-US
In-Reply-To: <57391bd9-e56e-427c-9ff0-04cb49d2c6d8@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 10:50 AM, Jens Axboe wrote:
> On 10/9/24 10:35 AM, David Ahern wrote:
>> On 10/9/24 9:43 AM, Jens Axboe wrote:
>>> Yep basically line rate, I get 97-98Gbps. I originally used a slower box
>>> as the sender, but then you're capped on the non-zc sender being too
>>> slow. The intel box does better, but it's still basically maxing out the
>>> sender at this point. So yeah, with a faster (or more efficient sender),
>>
>> I am surprised by this comment. You should not see a Tx limited test
>> (including CPU bound sender). Tx with ZC has been the easy option for a
>> while now.
> 
> I just set this up to test yesterday and just used default! I'm sure
> there is a zc option, just not the default and hence it wasn't used.
> I'll give it a spin, will be useful for 200G testing.

I think we're talking past each other. Yes send with zerocopy is
available for a while now, both with io_uring and just sendmsg(), but
I'm using kperf for testing and it does not look like it supports it.
Might have to add it... We'll see how far I can get without it.

-- 
Jens Axboe

