Return-Path: <io-uring+bounces-2643-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2323094605E
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 17:23:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8BAD5B2524C
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 15:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE63A13632B;
	Fri,  2 Aug 2024 15:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZhWwvlhU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D31136329;
	Fri,  2 Aug 2024 15:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722612128; cv=none; b=sFNaj6LQ7CaLIftK08d764Gv+M7eNTVKUKLJQxN3EJZgK9RS0rxB5B0UsgitPlgMac5kd/LP2j85TIGWAjymr2E9ZYud+dAFC5h5R50Rp1gPABA7wGK0xwLguGtIOcxlo0fLkQrKcgubmNeokX9FFF/lzmeZa9adHlFUvvl1eHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722612128; c=relaxed/simple;
	bh=w7jHXFzuZUNLzlt3vckGyTI+i0LMaKmdzdx6Oqj8rWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G2Y1IRUbRzxsS+EW5xEptl7y4glmSCRhuM6bjRJYVcXoo38C2sx1N4j7es8f33vHDqZAPxJ1VCNXOqGSeA7F81FKi5NtzEqMKJ/6XHOSIxS4d6VClRayO3s3vh3PMSLYVzJB3ML5cEtybI5H6dCrLvK5O089nbaD+3jsX4oKfGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZhWwvlhU; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a7aa4bf4d1eso185421266b.0;
        Fri, 02 Aug 2024 08:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722612125; x=1723216925; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HHq5n4pOvIBj0IwJkG9wUTHb160eU569skCvZMsn1SA=;
        b=ZhWwvlhUhxrXYQ5yeUFF2v9397MABzUSRi9Tr/p0BP0H4Zol5l8Vhm93q5zvsldpC7
         cq+vqkYP3unZg94bi8GGVGOJ//uEFRYySVlFImfbW3TMtXbSFSzfyczBkQq3TXEpEcgq
         rg3n4VkU4I6B3sSJ3mMOCHayU+L+VPorFbG3zvBoe5o4tle2s78YvN1rSNZxIM6cRomA
         9bdXxTvM2Y74Mvz7NFnih3S0NB7CKcWpGBsGOeBrMktpkL+zm8htJpM6doyYyXWmXEXs
         TfOr0BI5mf/Wmutr/03gsPcwnLX7YRm0+NATuRcaheTjWhHekvGOyuEa7yi3vXXLRwVa
         1aTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722612125; x=1723216925;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HHq5n4pOvIBj0IwJkG9wUTHb160eU569skCvZMsn1SA=;
        b=P9vTt5QYIHCNG04WMX14Ekx4JDlASxiYetzT5Jm2EprzPoeIl5HvlxV+unHZ8btlNm
         crg0f0CKSrnZ7Oo5/6XR04xDg2IG4XxyW5hZUv34cUpysDKX3PL8WH1GTu9iatkpBPzA
         OxKnrBurKBstNqc3RNzVyfJgWUIiqVhuCpxtzZLVKnOIN76Iaf1pSKx8MVw9JSCeSuAw
         P02+h12dpS0QusY3gg4QQyOYXtGi+hr1mRW463oJCvk/jrWYssGSrzzh2Lsp59lw9FI7
         wq4op+EjzSPh+AD2jtGq7UWczmQ9vvJxnUhIPQWd2Z7my/kNFtjpTcBwkH3mqN7c3ps7
         Tu9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVNk5XeeTnVtx6VXAB4rGU8zsCzTvKvzwOgxFkSOTYT3n2EKYiAJUwAz5HqaBQjYZ6z6CPd+VDfptLSvnPZKWYNkTCsQYBI/zI=
X-Gm-Message-State: AOJu0Yy3fcTXsHXk0f+PKHV+odpI0k0Q3al/V0rQDcgJrW05iO1GQDqR
	1nreodtFg4tekjgiGELsrVpS0ci2iIt8gf0YjxTw7r0Vn0wjYG3AmS8nGw==
X-Google-Smtp-Source: AGHT+IEIiamWmpPeaP5QLw613ukzHxEzdmQQc8SDYi0N4OQCmCymjoH54KcfzMrRH1SF/8KyZRYJrg==
X-Received: by 2002:a17:907:d92:b0:a7a:b9dd:7757 with SMTP id a640c23a62f3a-a7dc4fd8a6cmr364696466b.12.1722612124776;
        Fri, 02 Aug 2024 08:22:04 -0700 (PDT)
Received: from [192.168.42.144] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9e8c732sm110830766b.187.2024.08.02.08.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Aug 2024 08:22:04 -0700 (PDT)
Message-ID: <93b294fc-c4e8-4f1f-8abb-ebcea5b8c3a1@gmail.com>
Date: Fri, 2 Aug 2024 16:22:37 +0100
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
 <00918946-253e-43c9-a635-c91d870407b7@gmail.com>
 <bcd3b198697e16059ec69566251ad23c4c78e7a7.camel@trillion01.com>
 <43c27aa1-d955-4375-8d96-cd4201aecf50@gmail.com>
 <4dbbd36aa7ecd1ce7a6289600b5655563e4a5a74.camel@trillion01.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4dbbd36aa7ecd1ce7a6289600b5655563e4a5a74.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/1/24 23:02, Olivier Langlois wrote:
> On Wed, 2024-07-31 at 01:33 +0100, Pavel Begunkov wrote:
>>
>> You're seeing something that doesn't make much sense to me, and we
>> need
>> to understand what that is. There might be a bug _somewhere_, that's
>> always a possibility, but before saying that let's get a bit more
>> data.
>>
>> While the app is working, can you grab a profile and run mpstat for
>> the
>> CPU on which you have the SQPOLL task?
>>
>> perf record -g -C <CPU number> --all-kernel &
>> mpstat -u -P <CPU number> 5 10 &
>>
>> And then as usual, time it so that you have some activity going on,
>> mpstat interval may need adjustments, and perf report it as before.
>>
> First thing first.
> 
> The other day, I did put my foot in my mouth by saying the NAPI busy
> poll was adding 50 context switches/second.
> 
> I was responsible for that behavior with the rcu_nocb_poll boot kernel
> param. I have removed the option and the context switches went away...
> 
> I am clearly outside my comfort zone with this project, I am trying
> things without fully understand what I am doing and I am making errors
> and stuff that is incorrect.
> 
> On top of that, before mentioning io_uring RCU usage, I did not realize
> that net/core was already massively using RCU, including in
> napi_busy_poll, therefore, that io_uring is using rcu before calling
> napi_busy_poll, the point does seem very moot.
> 
> this is what I did the other day and I wanted to apologize to have said
> something incorrect.

No worries at all, you're pushing your configuration to extremes,
anyone would get lost in the options, and I'm getting curious what
you can squeeze from it. That's true that the current tracking
scheme might be an overkill but not because of mild RCU use.

> that being said, it does not remove the possible merit of what I did
> propose.
> 
> I really think that the current io_uring implemention of the napi
> device tracking strategy is overkill for a lot of scenarios...
> 
> if some sort of abstract interface like a mini struct net_device_ops
> with 3-4 function pointers where the user could select between the
> standard dynamic tracking or a manual lightweight tracking was present,
> that would be very cool... so cool...
> 
> I am definitely interested in running the profiler tools that you are
> proposing... Most of my problems are resolved...
> 
> - I got rid of 99.9% if the NET_RX_SOFTIRQ
> - I have reduced significantly the number of NET_TX_SOFTIRQ
>    https://github.com/amzn/amzn-drivers/issues/316
> - No more rcu context switches
> - CPU2 is now nohz_full all the time
> - CPU1 local timer interrupt is raised once every 2-3 seconds for an
> unknown origin. Paul E. McKenney did offer me his assistance on this
> issue
> https://lore.kernel.org/rcu/367dc07b740637f2ce0298c8f19f8aec0bdec123.camel@trillion01.com/t/#u

And I was just going to propose to ask Paul, but great to
see you beat me on that

> I am going to give perf record a second chance... but just keep in
> mind, that it is not because it is not recording much, it is not
> because nothing is happening. if perf relies on interrupts to properly
> operate, there is close to 0 on my nohz_full CPU...
> 
> thx a lot for your help Pavel!
> 

-- 
Pavel Begunkov

