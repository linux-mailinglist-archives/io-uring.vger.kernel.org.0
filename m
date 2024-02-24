Return-Path: <io-uring+bounces-699-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F4668626DA
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 19:51:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B5B01F21747
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 18:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2621CD14;
	Sat, 24 Feb 2024 18:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1h8mJrGz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968692907
	for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 18:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708800697; cv=none; b=YaLI9lrXeUhcmvujQVh2NnZNkpjC7OAUIjfPOp/E8xIJj31/7pwICzXP0OS98CPZ2XkaFCYO2rMVVsKFTsAi2v1Zlv+csLLSA1PkxIujnPVKaHZtCyt5Tyd9JI0JA+p88w24Ho2Y1vAEH6fkzmb1xlffe9JvwAfbZUaMb/oWN98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708800697; c=relaxed/simple;
	bh=zqRjFFSBCwwqnWWG45JWJYTbaxUKv+7ePkY/GZt86Ws=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ITitFDCi8VFLqjFDe3sY8YAgyp94HDmPVUbaRQFF7tam/8BJdrp14IjUhrG7R7mALp4QQbpZAFonlj3vz3UOQjQg69oBAMWQEaOl1uJ1LvROK3dp10UmJhGo76fX1uLo/fxmfBxznXP1iX4Qd4c7/C/tbwMqFRGmRu49LFSnHrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1h8mJrGz; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5cdbc42f5efso778946a12.0
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 10:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708800693; x=1709405493; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eZVY3cFTPWmQcBclN/88rkWNiNkEwIj0Z9C+57z47Z8=;
        b=1h8mJrGzDVxTIpOezGutyc6Fl2UUQ79DrQCFCGX9sMbFokm2Yh6j0ZyXzwg/Lpobax
         QuE7QBc6R0uAhZBF4GZketS3o4RgJUhrDhTFmG5Qcl+3ttbmYRJSqbGjNt/0HAwx+S+x
         qRYXt/xbmQdR8HDBp+iwL50Ct5L1ALKVmPAuv9xSzMMiL8f5AbwyMDo0Cg12mEgWKOfZ
         hsxmmKccczK4KO9ye4DTBATE5EIb5RIW2mMSgZBdQslVUk78FaETGf8vuxsCKbfMp/wz
         qFMnHpXKTCEBWzFe6bqUIjj1T2Dw+ktv+7pA058Dlez72r6jmQk/Ab4kp4OlIRfkGOGr
         cmuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708800693; x=1709405493;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eZVY3cFTPWmQcBclN/88rkWNiNkEwIj0Z9C+57z47Z8=;
        b=oDykqAyjFrNOLb35vw4GC0g6n1eBu1UlzRCqS3px+LbaGCXVPj12tuyOJR1bS3nZkM
         qUNeuRaxab4wUjfB3OSt5sM5qUQqrnYSbmwWFZQd+b8DMBOGKs5HuBmQMnbaO/7+RomF
         z6fSI11WE07mWVqPaf76XSKB7VCO0Rr/Ro8Wbqd4LaRxwUV1v7C2kjkPjkmtGjzymHyq
         EfmGhEr0xannacmPAdMpZsZ7JiUTU1q01cfZe8Rcz8gvCAdOSEbta17TLeTqNOJyTEGQ
         ctfTP6FzEgg9zlsOQKIOoZsq+iWsAcH7E9JZGCNxR7FCgh4a2aLVAOhau5gawfDR73+E
         nCgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFme5oOgtAPSBlgFJW2KYDyIBLRmVJ0u2L6wAtqp5aS5spseaSFSlAQrasAtdrLosPfQJeI+SZ8mynDbxqc9U3nTTm3+ODXLs=
X-Gm-Message-State: AOJu0YxnPuH2ymBG8iE7mqAWnjmybRelOoc2y7JaeDTAGTpu8rOlkeJ5
	NDvOl2Wj92GaeRIVNQeMBNgkhCrhFFh5zD+KX237bdkPPL9HZu2Pvp/+OZaV3+o=
X-Google-Smtp-Source: AGHT+IG9me/7QOEi8EbQ/f3VJYVcy+E+eQGvcwN7nz/xpKK1m2CWSp986ThwUlQ1/T3/V5bveD/POQ==
X-Received: by 2002:a05:6a20:94c4:b0:1a0:ea4b:1857 with SMTP id ht4-20020a056a2094c400b001a0ea4b1857mr3783668pzb.2.1708800692901;
        Sat, 24 Feb 2024 10:51:32 -0800 (PST)
Received: from ?IPV6:2600:380:7472:2249:6d10:d981:9c6f:5d24? ([2600:380:7472:2249:6d10:d981:9c6f:5d24])
        by smtp.gmail.com with ESMTPSA id w8-20020a17090a15c800b00296f2c1d2c9sm3841570pjd.18.2024.02.24.10.51.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Feb 2024 10:51:32 -0800 (PST)
Message-ID: <ce348f24-8e11-49e9-aebb-7c87f45138d0@kernel.dk>
Date: Sat, 24 Feb 2024 11:51:30 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] io_uring: only account cqring wait time as iowait
 if enabled for a ring
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20240224050735.1759733-1-dw@davidwei.uk>
 <678382b5-0448-4f4d-b7b7-8df7592d77a4@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <678382b5-0448-4f4d-b7b7-8df7592d77a4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/24/24 8:31 AM, Pavel Begunkov wrote:
> On 2/24/24 05:07, David Wei wrote:
>> Currently we unconditionally account time spent waiting for events in CQ
>> ring as iowait time.
>>
>> Some userspace tools consider iowait time to be CPU util/load which can
>> be misleading as the process is sleeping. High iowait time might be
>> indicative of issues for storage IO, but for network IO e.g. socket
>> recv() we do not control when the completions happen so its value
>> misleads userspace tooling.
>>
>> This patch gates the previously unconditional iowait accounting behind a
>> new IORING_REGISTER opcode. By default time is not accounted as iowait,
>> unless this is explicitly enabled for a ring. Thus userspace can decide,
>> depending on the type of work it expects to do, whether it wants to
>> consider cqring wait time as iowait or not.
> 
> I don't believe it's a sane approach. I think we agree that per
> cpu iowait is a silly and misleading metric. I have hard time to
> define what it is, and I'm sure most probably people complaining
> wouldn't be able to tell as well. Now we're taking that metric
> and expose even more knobs to userspace.

For sure, it's a stupid metric. But at the same time, educating people
on this can be like talking to a brick wall, and it'll be years of doing
that before we're making a dent in it. Hence I do think that just
exposing the knob and letting the storage side use it, if they want, is
the path of least resistance. I'm personally not going to do a crusade
on iowait to eliminate it, I don't have the time for that. I'll educate
people when it comes up, like I have been doing, but pulling this to
conclusion would be 10+ years easily.

> Another argument against is that per ctx is not the right place
> to have it. It's a system metric, and you can imagine some system
> admin looking for it. Even in cases when had some meaning w/o
> io_uring now without looking at what flags io_uring has it's
> completely meaningless, and it's too much to ask.
> 
> I don't understand why people freak out at seeing hi iowait,
> IMHO it perfectly fits the definition of io_uring waiting for
> IO / completions, but at this point it might be better to just
> revert it to the old behaviour of not reporting iowait at all.
> And if we want to save the cpu freq iowait optimisation, we
> should just split notion of iowait reporting and iowait cpufreq
> tuning.

For io_uring, splitting the cpufreq from iowait is certainly the right
approach. And then just getting rid of iowait completely on the io_uring
side. This can be done without preaching about iowait to everyone that
has bad metrics for their healt monitoring, which is why I like that a
lot. I did ponder that the other day as well.

You still kind of run into a problem with that in terms of when short vs
long waits are expected. On the io_uring side, we use the "do I have
any requests pending" for that, which is obviously not fine grained
enough. We could apply it on just "do I have any requests against
regular files" instead, which would then translate to needing further
tracking on our side. Probably fine to just apply it for the existing
logic, imho.

-- 
Jens Axboe


