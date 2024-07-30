Return-Path: <io-uring+bounces-2611-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEA1294218F
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 22:25:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93FE828419E
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 20:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E8518CC0A;
	Tue, 30 Jul 2024 20:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UbDXEimg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7C518CC1E;
	Tue, 30 Jul 2024 20:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722371130; cv=none; b=bP/K8g3SwfbaLSRNjxkD74JztXQoTyzmPuDukj2n60hr9042BinuGrcoqhTbEVaYpim7KllvELdaVo0VY7ssta+Wjkf7dYQPkbSfwgRXFSLeQv7xon7UBoR/ph24BZpuwie6LM+i+vPQ28VscnPIkw5P5GZwebzt48IgmPDFHTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722371130; c=relaxed/simple;
	bh=pFghqGCwi9GVvsa1byGymLUEjccvQihFcKXgKFH7FUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dO5Fj0TmjNViOys4DBsO22cl49IWA2tIEe8cG1dbw7lUVEOiZXk0eXfBoNd3R9XcdViWUQQYsMgRRly4Z+e29uuwfv9YdCQyL5JiAeRP3jvVlZlO7eYMZIeabs4mYU9CcRWxK+l7utzuwO/JtyFKtq3eHZXJcOfWw9mG3Ai0rcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UbDXEimg; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-428085a3ad1so31444565e9.1;
        Tue, 30 Jul 2024 13:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722371126; x=1722975926; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mu0A8I/a0mxq+DH13s2tKTCQz+serozmbBC+eEPyZFs=;
        b=UbDXEimgMskN97cLIRxT6grvIqS4/Jykd36d6lLATfd345s9hB0jjA1+HHazErbK5S
         ITTSD1Emy8fD7iMWJM4jr10orPtqEL9qDSTIhMMDoxURqzSKy2rdA4GycyfT8L4Fld9S
         kmxZDjy7fm5tTEzvU84LOak6U4Xpgia/kWFeXXKJzhEmb9pIvU0KYSN09omzOSN9U0/I
         GT0LHjpo1R1Pn2OznFTajuMry8lCuj+tvHyn5QUYgar1Mg/+LihgD4ktp+V80k4JaAnd
         UckKCF7gWBUuQ/jthaZL6+QV0Jca0pMkNp95ygqUunlBJWTJZChKQ/UZ4EWAr4jFMap6
         Zpsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722371126; x=1722975926;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mu0A8I/a0mxq+DH13s2tKTCQz+serozmbBC+eEPyZFs=;
        b=W+98QNK+H98Q4pHPCxMRYgMVyI+4P/NeMdXQgHGqsTXAHA7IP7aZm+I806V7563wnJ
         6czVR+/dTK9RuveuINN5kbIKRcPCQ9vOmUjBp9gX+eCP40e+mEOnh49/GVVh2UlA3Og4
         ElUXPnpzChjU2fuFV3o+vCjiAJGm7Hy5U/1SjQfpvnkAihwhRLJYhmJOkoCB56Pc+Bn2
         lOvygKnz4588vBmZ5C3pREIc2c2HLD+FdP46mjjD0x5g41jprS4zKB5Tq34ur8HpyTgz
         0BC2pM9FHxl3ePGDKJ7Pn+wVdFYDX91135yYVPhmbl/PqP6eVEgYdV7NuxK9jeXI9J1n
         irHQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2bTZE6tZ5qaCeOMHbrSc9EqCtY2Mww5LIwkhXf2xUWKU5qkbY/eAVnq6IPgi3r35LE0kGSuww3WFruImfU557IGHcDjw1ow8=
X-Gm-Message-State: AOJu0YyKrfRcV5SU+iu6IwZ4O/Zc9nw2wDXX0Z9j/qF14m4z4SRpLUwT
	VfSXwOUBo6I6v6NKDC74ZUUWlo1v425SArhndSftu+ci+waf5U16t0jtnw==
X-Google-Smtp-Source: AGHT+IEJvY6uFlWkWJygSkxD4nIZqzriJKPf+Sv7ZTpQ1o510qkypdwVmwV5ehyKPzNa5ODOwJpKKA==
X-Received: by 2002:a05:600c:5124:b0:426:6921:e3e5 with SMTP id 5b1f17b1804b1-42811dcd2a9mr79398295e9.24.1722371126061;
        Tue, 30 Jul 2024 13:25:26 -0700 (PDT)
Received: from [192.168.8.113] ([85.255.235.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-428057a6307sm227163525e9.36.2024.07.30.13.25.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 13:25:25 -0700 (PDT)
Message-ID: <00918946-253e-43c9-a635-c91d870407b7@gmail.com>
Date: Tue, 30 Jul 2024 21:25:58 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring NAPI busy poll RCU is causing 50 context switches/second
 to my sqpoll thread
To: Olivier Langlois <olivier@trillion01.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
References: <b1ad0ab3a7e70b72aa73b0b7cab83273358b2e1d.camel@trillion01.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b1ad0ab3a7e70b72aa73b0b7cab83273358b2e1d.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 21:05, Olivier Langlois wrote:
> if you are interested into all the details,
> 
> they are all here:
> https://github.com/axboe/liburing/issues/1190
> 
> it seems like I like to write a lot when I am investigating a problem.
> Pavel has been a great help in assisting me understanding what was
> happening.
> 
> Next, I came to question where the integration of RCU came from and I
> have found this:
> https://lore.kernel.org/all/89ef84bf-48c2-594c-cc9c-f796adcab5e8@kernel.dk/
> 
> I guess that in some use-case being able to dynamically manage hundreds
> of NAPI devices automatically that can suddenly all be swepted over
> during a device reconfiguration is something desirable to have for
> some...
> 
> but in my case, this is an excessively a high price to pay for a
> flexibility that I do not need at all.

Removing an entry or two once every minute is definitely not
going to take 50% CPU, RCU machinery is running in background
regardless of whether io_uring uses it or not, and it's pretty
cheap considering ammortisation.

If anything it more sounds from your explanation like the
scheduler makes a wrong decision and schedules out the sqpoll
thread even though it could continue to run, but that's need
a confirmation. Does the CPU your SQPOLL is pinned to stays
100% utilised?


> I have a single NAPI device. Once I know what it is, it will pratically
> remain immutable until termination.
> 
> For that reason, I am thinking that offering some sort of polymorphic
> NAPI device tracking strategy customization would be desirable.
> 
> The current one, the RCU one, I would call it the
> 
> dynamic_napi_tracking (rcu could be peppered in the name somewhere so
> people know what the strategy is up to)
> 
> where as the new one that I am imagining would be called
> 
> static_napi_tracking.
> 
> NAPI devices would be added/removed by the user manually through an
> extended registration function.
> 
> for the sake of conveniance, a clear_list operation could even be
> offered.
> 
> The benefits of this new static tracking strategy would be numerous:
> - this removes the need to invoke the heavy duty RCU cavalry
> - no need to scan the list to remove stall devices
> - no need to search the list at each SQE submission to update the
> device timeout value
> 
> So is this a good idea in your opinion?

I believe that's a good thing, I've been prototyping a similar
if not the same approach just today, i.e. user [un]registers
napi instance by id you can get with SO_INCOMING_NAPI_ID.

-- 
Pavel Begunkov

