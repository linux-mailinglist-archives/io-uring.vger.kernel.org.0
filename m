Return-Path: <io-uring+bounces-716-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 544AC862BCB
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 17:40:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A54A6B20DE8
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 16:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977C6175A6;
	Sun, 25 Feb 2024 16:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="W/x5FX/l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9746812E71
	for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 16:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708879200; cv=none; b=MY5ld534CztcYQIcq+3udh7ATYPsErAADcPNSKOuC8HBCSzGsg7gRyKkynTTiR5f60OvR/KwW3KeLz735tabnIOxkBHjzTrMxKwG+YqtPcCAj+7TCuZGZzuttN9jBiPDM2DfgFV8LRLBTkaogUUd6nCHLRCltL18xRw+w6Eu0fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708879200; c=relaxed/simple;
	bh=p8FTr3UlrVsV1y0aih9b/oj3XKadBL5aC8JWsqKCsSU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Qkm4sChHotKqL66BoCzPJ63DHKtgfpCLkRdDpgKzqNMUQqErr50ZXHU5NmuasVnB69rYDCc1X6j2KBManEzM/1apjYDd2Kd7ZNRDbIs1ZpKV10u7OjEGLNCQzZPGpusexAbW50ZArvgDT/0aVhrkROD6VBr5zD+oKqivzFhyuk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=W/x5FX/l; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1dca3a5cb9eso4985ad.0
        for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 08:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708879195; x=1709483995; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=px6roWKnRWepFtRhUlFIJTv2P7o70OR0jCkqCw6+4+0=;
        b=W/x5FX/lENZ0dgWU/P5mx5Bg/T/tubEtQnsNNzqnS6jMVV0ye7EJjUdhCHAO93Hqsr
         lTojdrd5d2Hro6mHc4eaXS9kYh5j2HbYwDNsfpuEPMlDylGI2nMEcm4G2Xe1MoKUN+gE
         lgC4rVg1Gx9FIbXKqONAm7grovpwd6BBMRaJtoT9J8tgAX7WZN/+MNpa5JwTldQXbm3E
         fv7NvnAhA4ENu83oMaVQDRnImmdYZQJ6zXWTPDtZBpKLro23gkoaFr98cQsUazS09XIp
         Up0ZzP5fBi+uMt5aMLZ5z6dIUHO24ss4SWP54U6a9KzUJHLbwRuKnecMEEBIyBhD03Gk
         /OTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708879195; x=1709483995;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=px6roWKnRWepFtRhUlFIJTv2P7o70OR0jCkqCw6+4+0=;
        b=vXCgYtl8BunWRLx18INEQr9He6PfBAaZphjskhN6mj8VE0iEaXK27XRxtvRJkJcffz
         dq/Uy2DUl0JivL3EyT1Rh3+wC+QqRuwOkP6EgJS0Iz7ruVSDW24M5ryiWh4DG0wwPq+y
         7tERNnc5h2PFvCoVULJpI3MZ9ddFHlZsJxc7RrwWfzASmhYeM0RuOUP/NNhWQL17KHnP
         012e4JgkwnY5dzbKq4TaW+NC4lzQytFaxNlCor1L2XewWjaWVnpcsdnrCIF13aoCHcZM
         UtjrXDx9T3ZbZe1IakZbfPs25ZitFxo8EJyCPk3FmhUcB1ZiBarDf+Yk8B/jeLBNpqp3
         eg6g==
X-Forwarded-Encrypted: i=1; AJvYcCU3Cb8TLmtVLE3M2qlPbSj9HojxjWoPuuYNeJEUV7oLIezNKTe4PteFwmNAVrEpHCM4q0pMdlKOfyGwxruQvH9eIF1WGkP4VLU=
X-Gm-Message-State: AOJu0YwJjt9xGJpVZs0xcf+hDhBydam3peD34LB0hR4+UjkKDmR3yGlI
	gjsH/gDDX/IYP0PPaLEZPUXiL7lugfq3z6kTy5sL22y2SJqJIvKfMgiOb2x3JOgR5LCIrx5Kr44
	O
X-Google-Smtp-Source: AGHT+IFtzYwYsZJ+Z6os7SP5/LaW87p/I/7sEdvbIp/gBOjCEUsBFzr7EwGWJEp3SND8U+nxezb5Hg==
X-Received: by 2002:a17:902:a717:b0:1dc:a28f:646e with SMTP id w23-20020a170902a71700b001dca28f646emr508226plq.6.1708879195556;
        Sun, 25 Feb 2024 08:39:55 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id ji15-20020a170903324f00b001db7599aba0sm2431915plb.24.2024.02.25.08.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Feb 2024 08:39:55 -0800 (PST)
Message-ID: <05dc2185-2935-4eac-a8e7-f407035f9315@kernel.dk>
Date: Sun, 25 Feb 2024 09:39:54 -0700
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
 <ce348f24-8e11-49e9-aebb-7c87f45138d0@kernel.dk>
 <2bdf6fa7-35d8-438b-be20-e1da78ca0151@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2bdf6fa7-35d8-438b-be20-e1da78ca0151@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/24/24 5:58 PM, Pavel Begunkov wrote:
> On 2/24/24 18:51, Jens Axboe wrote:
>> On 2/24/24 8:31 AM, Pavel Begunkov wrote:
>>> On 2/24/24 05:07, David Wei wrote:
>>>> Currently we unconditionally account time spent waiting for events in CQ
>>>> ring as iowait time.
>>>>
>>>> Some userspace tools consider iowait time to be CPU util/load which can
>>>> be misleading as the process is sleeping. High iowait time might be
>>>> indicative of issues for storage IO, but for network IO e.g. socket
>>>> recv() we do not control when the completions happen so its value
>>>> misleads userspace tooling.
>>>>
>>>> This patch gates the previously unconditional iowait accounting behind a
>>>> new IORING_REGISTER opcode. By default time is not accounted as iowait,
>>>> unless this is explicitly enabled for a ring. Thus userspace can decide,
>>>> depending on the type of work it expects to do, whether it wants to
>>>> consider cqring wait time as iowait or not.
>>>
>>> I don't believe it's a sane approach. I think we agree that per
>>> cpu iowait is a silly and misleading metric. I have hard time to
>>> define what it is, and I'm sure most probably people complaining
>>> wouldn't be able to tell as well. Now we're taking that metric
>>> and expose even more knobs to userspace.
>>
>> For sure, it's a stupid metric. But at the same time, educating people
>> on this can be like talking to a brick wall, and it'll be years of doing
>> that before we're making a dent in it. Hence I do think that just
>> exposing the knob and letting the storage side use it, if they want, is
>> the path of least resistance. I'm personally not going to do a crusade
>> on iowait to eliminate it, I don't have the time for that. I'll educate
> 
> Exactly my point but with a different conclusion. The path of least

I think that's because I'm a realist, and you are an idealist ;-)

> resistance is to have io_uring not accounted to iowait. That's how
> it was so nobody should complain about it, you don't have to care about
> it at all, you don't have to educate people on iowait when it comes up
> with in the context of that knob, and you don't have to educate folks
> on what this knob is and wtf it's there, and we're not pretending that
> it works when it's not.

I don't think anyone cares about iowait going away for waiting on events
with io_uring, but some would very much care about losing the cpufreq
connection which is why it got added in the first place. If we can
trivially do that without iowait, then we should certainly just do that
and call it good. THAT is the main question to answer, in form of a
patch.

>> people when it comes up, like I have been doing, but pulling this to
>> conclusion would be 10+ years easily.
>>
>>> Another argument against is that per ctx is not the right place
>>> to have it. It's a system metric, and you can imagine some system
>>> admin looking for it. Even in cases when had some meaning w/o
>>> io_uring now without looking at what flags io_uring has it's
>>> completely meaningless, and it's too much to ask.
>>>
>>> I don't understand why people freak out at seeing hi iowait,
>>> IMHO it perfectly fits the definition of io_uring waiting for
>>> IO / completions, but at this point it might be better to just
>>> revert it to the old behaviour of not reporting iowait at all.
>>> And if we want to save the cpu freq iowait optimisation, we
>>> should just split notion of iowait reporting and iowait cpufreq
>>> tuning.
>>
>> For io_uring, splitting the cpufreq from iowait is certainly the right
>> approach. And then just getting rid of iowait completely on the io_uring
>> side. This can be done without preaching about iowait to everyone that
>> has bad metrics for their healt monitoring, which is why I like that a
>> lot. I did ponder that the other day as well.
>>
>> You still kind of run into a problem with that in terms of when short vs
>> long waits are expected. On the io_uring side, we use the "do I have
>> any requests pending" for that, which is obviously not fine grained
>> enough. We could apply it on just "do I have any requests against
>> regular files" instead, which would then translate to needing further
>> tracking on our side. Probably fine to just apply it for the existing
>> logic, imho.
> 
> Let's say there are two problems, one is the accounting mess, which
> is IMHO clear. The second is the optimisation, which is not mentioned
> in the patch and kind of an orthogonal issue. If we want a knob to
> disable/enable the cpufreq thing, it should be separate from iowait
> accounting, because it sounds like a really unfortunate side effect
> when you enable the optimisation and the iowait goes pounding the roof.
> Then people never touch it, especially in a framework, because an
> system admin will be pretty surprised by the metric.

Fully agree, it's all about not losing the short sleep high latency
wakeup, which is what caused the performance to drop for low QD IOs.

> Not like I'm a fan of the idea of having a userspace knob for the
> optimisation, it'd be pretty complicated to use, and hopefully there
> is a more intelligent approach.

That would certainly be nice.

-- 
Jens Axboe


