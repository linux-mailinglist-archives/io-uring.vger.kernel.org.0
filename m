Return-Path: <io-uring+bounces-4927-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 434719D4F7A
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 16:11:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52524B241D3
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 15:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BEA61D959E;
	Thu, 21 Nov 2024 15:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3C+cTEYp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21741D86F1
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 15:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732201383; cv=none; b=B8Cm4Nh36TLAmv5eRwJ4Em8lkBp5quoAJar/ROR6j9sko35bCqcTwB3zDxmxSdXDYs7jj4O4ZDPkRKYcV/SHSX4uezUZOipzN6VbASFlmf4LefbdxraoXVMYbPD5Yb9uJj3bRUByschGoh1KnyahgxRLXymBGd/F7w1u/pE4+ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732201383; c=relaxed/simple;
	bh=pEpTTTakRCWGPZNlyMMqnpktY5BCTmIy1t/HnLA5ukw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=b7zSiCsWzDUC3MagdlOenS/WZWm/DqOAr1plcOOwYsndri8iDO5OONVTGs4UASdlBqplZ4VAVeoveIg8t0lmWVBNBSXEQ9BrqkFrw0WCojfCn8PMASZ7SCvjkpAUPfsgK1eQVqmIVj7LFZ+w2nFANDU5VOgy523vExrMRnnVes0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3C+cTEYp; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5eb67d926c4so495649eaf.0
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 07:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732201380; x=1732806180; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PMnatNUBW8KxEgYw/Q+bCQworHDJ1e8+UIN2+Ow1EEY=;
        b=3C+cTEYp3caQgGJoCyMV9l8RNr0+XEKaXRo4ARcchOid7PaWgvbvjilBQW7shAmVcu
         sAAk4eBNkqEQIt8eEQVOCP6Tu/ZOYcEq4EXwnyIeZaFsVIeEQMJnuviebTb19AV/08ie
         Pq6D1bcmCQsVFfQW0BXtZIdgy2dQpExKLAiPq49Y+w7A/aPDG74rxJtGO5lQ+dl27YWN
         J5WtO6N+PLJLdqkvTpZGKX9p6qi5cnmzYrKnJV8os3e6HT6RJh+8BlSG3UYfb1i6Mzxn
         hj55iLnNAmALRqgFk6uOtECJVhlfTXM+LMNO002EK9hD3puzCnhR8kFxIluhr1oZEZXa
         IBeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732201380; x=1732806180;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PMnatNUBW8KxEgYw/Q+bCQworHDJ1e8+UIN2+Ow1EEY=;
        b=svWWQTHKoW6GwLrTUEsyIOtcypdjHyeh6L/TGTe96pTQ1ZuLiEPVStpWUpmEQoLWz4
         Cf8VAeKqcqhiK8yt64Oc1QleNN/++cJ6NiPmJWkdgaIjYUKQ6QljhPCbMvmSUreJOfJZ
         o7eVFZqmeWIYGoIyGdb679D5xemhkW9PK1L1iMdg4z34AHA5/5NixDZ1ky/1aV9BGcHi
         dLDJOWNP/Li4BGR6kcloMDT2aby/k7OpCNNzwVt++dUskjcPjxhPgvNchsdX12KQB8r8
         lCa0KeRq4l3qqLguq07ZY4Wotb06mqODCUKCbW1FGxqOVO9GNODeQ1rCx6dbHZk9do4S
         fUIA==
X-Forwarded-Encrypted: i=1; AJvYcCXM3xRTowcXNFJ1gtGlKfRg0FdBbuSEdF7J1z5D3NXeyUgypU8ef0weGZm9bx7Fco5gxxiHkfsYCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzvGRU1EF8zGo70n3fWLM66ZBKqwiY3HaL5xNafzge/TBkgA4x7
	3lIjR6+/uY30GRgtPldJ/7y+6FwoujOEhkxrJGgWAwsoYZjvjp8dTI3xq9mgDJ8=
X-Gm-Gg: ASbGncvy9mJko5MbPo68PBAczv0Fk1Wc+xIRLacV3BYTLgyJlp37modfzEhyAMGuL01
	Owip8sLDjCRqobPIkegP3zsat1Tsa36rEU9yJtG6W3+//HyNEnRfDac9491Y6bW0rjPKKjawE5T
	ni8zi3DOUE1Ip8Cz9TeeBLyei4B/47rs7aiKawefbZs0YCne4z3Yvoc/rP7/zjB+NDbrVeAoDSb
	WeMbQroVCTQOX1CVh4//dLn7oYvP3s0nTB9HJUEXZQV9A==
X-Google-Smtp-Source: AGHT+IGsndwog8F86x1LgWB1VnFLoc81ujvMlgTLVWzsKJ7rmI7fjxBpW803DEiwz1odqRN9yyCmfA==
X-Received: by 2002:a4a:bf04:0:b0:5eb:5eff:afbb with SMTP id 006d021491bc7-5ef3c4c4d7dmr2028800eaf.1.1732201379951;
        Thu, 21 Nov 2024 07:02:59 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f064e078afsm154069eaf.34.2024.11.21.07.02.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 07:02:57 -0800 (PST)
Message-ID: <1a04c07c-29e6-444c-87cd-a5ba0e4426c9@kernel.dk>
Date: Thu, 21 Nov 2024 08:02:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
 <4d71017c-8a88-40bb-a643-0efb92413d3d@davidwei.uk>
 <1d98f35c-d338-4852-ac8c-b5262c0020ac@gmail.com>
 <7e7243ae-db29-4a96-aece-d66897080a41@kernel.dk>
 <cf1648f0-28fd-43c9-9e12-6dbcb38f38ce@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cf1648f0-28fd-43c9-9e12-6dbcb38f38ce@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/21/24 7:58 AM, Pavel Begunkov wrote:
> On 11/21/24 14:34, Jens Axboe wrote:
>> On 11/21/24 7:29 AM, Pavel Begunkov wrote:
>>> On 11/21/24 00:52, David Wei wrote:
>>>> On 2024-11-20 15:56, Pavel Begunkov wrote:
>>>>> On 11/20/24 22:14, David Wei wrote:
> ...
>>>> There is a Memcache-like workload that has load shedding based on the
>>>> time spent doing work. With epoll, the work of reading sockets and
>>>> processing a request is done by user, which can decide after some amount
>>>> of time to drop the remaining work if it takes too long. With io_uring,
>>>> the work of reading sockets is done eagerly inside of task work. If
>>>> there is a burst of work, then so much time is spent in task work
>>>> reading from sockets that, by the time control returns to user the
>>>> timeout has already elapsed.
>>>
>>> Interesting, it also sounds like instead of an arbitrary 20 we
>>> might want the user to feed it to us. Might be easier to do it
>>> with the bpf toy not to carve another argument.
>>
>> David and I did discuss that, and I was not in favor of having an extra
>> argument. We really just need some kind of limit to prevent it
>> over-running. Arguably that should always be min_events, which we
>> already have, but that kind of runs afoul of applications just doing
>> io_uring_wait_cqe() and hence asking for 1. That's why the hand wavy
>> number exists, which is really no different than other hand wavy numbers
>> we have to limit running of "something" - eg other kinds of retries.
>>
>> Adding another argument to this just again doubles wait logic complexity
>> in terms of the API. If it's needed down the line for whatever reason,
>> then yeah we can certainly do it, probably via the wait regions. But
>> adding it to the generic wait path would be a mistake imho.
> 
> Right, I don't like the idea of a wait argument either, messy and
> too advanced of a tuning for it. BPF would be fine as it could be
> made as a hint and easily removed if needed. It could also be a per
> ring REGISTER based hint, a bit worse but with the same deprecation
> argument. Obviously would need a good user / use case first.

Sure I agree on that, if you already have BPF integration for other
things, then yeah you could add tighter control for it. Even with that,
I doubt it'd be useful or meaningful really. Current case seems like a
worst case kind of thing, recv task_work is arguably one of the more
expensive things that can be done out of task_work.

We can revisit down the line if it ever becomes needed.

-- 
Jens Axboe

