Return-Path: <io-uring+bounces-10109-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 824D2BFC969
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 16:38:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3DB0434DA75
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 14:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E5A2ED161;
	Wed, 22 Oct 2025 14:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jFcfKjpA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5BC21D3F6
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 14:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761143695; cv=none; b=P4msHkdC74gmtwn8w2l9EfGCkeIM89nCf7J0d7RT2MdUDu94rPhwZV07RM3s+aJeT2dGtoeyx4Za/tmbfTxq2Xml9zKXQvdym4EVwf5wVXjOEGaZwZpDF9XaM1CiUXTLd4vqeqr1uU0E5N634ntzx/gsRVwpezrhkufKfj3l5cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761143695; c=relaxed/simple;
	bh=bhx4JIMOsOLyxoh5iaw6fY2106oxPWu40Tk17S5ixiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uv3oLSBCuVd4iwba3bqFp89V713qI5NO1ygPiFGrUZU0f1ZtZduYZgi9ybPxegx/PjrmsVbumrEe424EoG58c64WW2IRkSaSTRsq6RbszgmZNF3pmUUmyhI7PBaOcNwibXNbLftGN9EsU+c6sUhkaRTh8yWPMCO10wfJ2AlUS+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jFcfKjpA; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-9379a062ca8so297371839f.2
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 07:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761143692; x=1761748492; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zXKn3DvJBAZ9GweZX6DfWOhob/lcdXEQubsOfEnxg9Q=;
        b=jFcfKjpA+K748glxno7Hh7iGr87X2zo72FHrhDO2yLngXchqmTHRiVgEmgmIIsV40K
         I51PWjYsQ49oRW3R6aEwb8tevqfeJmJrRQI4Bh652UQjhMdE6WWS/Yf5EjkkBmEffNYo
         cv7XPJ5/p40tc/XSfV9xZ1DTyBIU6QL1sZuog5JeymMfjWIst4eB0NaMKMKPCi15Wzsw
         igYxchOloLQwJ+uJUFba/+Se+B+pZpKE01B9zVWDRrydZqO0OiJSX/NfzJcFzME1ux86
         coTwghW/Ib24LLLeAMQBXOzJGUqGwX6FqxQu7PbzgoN5gjOXjjtqNlgsTeGYmxVEt6h+
         7cGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761143692; x=1761748492;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zXKn3DvJBAZ9GweZX6DfWOhob/lcdXEQubsOfEnxg9Q=;
        b=MQc2Vuw+ORUD/yFkqE4dDR08m0B11/E7KJzV6qoa1223YrYL1NJH0LA+ANO7DQtdon
         JH2CtE9XhqjEGK0Kfg67H6b+E5vEXx01zdygUQVVnVUamJw8rqJ4Bx2m6w4QoEd8QzTR
         mXq+OXTZINIfXk530MGuXkkIiuhxk9GKUChtDUzyG1Gx/Ch9QAGFiJdeAQ5viYQumb9R
         NPUv3Y5AvyQJB0rljlgMia5FE3kq96NgYt/939kMBMOAbQ0y2RKh8AhH7+N21nrJSkBr
         n8nNgIsET1jw/6iY5Rpep4mDbGylb6dD+w0EngFmMgBL1xith/m48QW2pBKCOORykpG9
         U4/w==
X-Forwarded-Encrypted: i=1; AJvYcCXmBjuObT2rGfb/lf31B6DmEOroe42wA6Ljfkh6Rexn7CTrXMCBlBqLlGiTJ1jHT3f5bBvqg/OO7Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4scZ1GTfGpcSm4RWzODXXcpsQj4twue5xXkVqMbXE94yRJxyO
	+su4jNWKHMgyTo21WFPMHrYUfbW657FkccaUMLMngNZlfOTPt0viI6L9FmT8kzqqKKc7wJX5hy+
	Jn2QVAX8=
X-Gm-Gg: ASbGncuLfWMo0njzrpKEGVlAErlyquhMFiZ2XO/cze/iM+xjULBlcY94BC6iQFTBza2
	ucMaWAXi8ePb76gxbuW9a/u/oZg3wJI+cJUHqrsGgDuV4+S6ciVxXC5WXgORMmAl9S5KFwcQ4tz
	Yz9saw+ZqnpJY48ONyHtrpS6ELo9ylH9xltP5osUuzBglnWmnFnr2yIf86I7ECPd3XeY5ZKD8SW
	z69SxFhH1dZvupwtDK0coLyhknjPXO2HRGluPNK2UWkc8xOQGt9TLBFzQNNgk0alYmQUlm8iJ3w
	RGuFfV6MIJM92wm8Sq1HfC+xn0HR8xLgen8ld3eDlElBXRPR8WG3YCX3959l0vZSjzyc3RLoIRj
	mpkv2gShsE4f/GHXfjABZeZGwtfJvvMQ/pWV5tBCVAD+FnSUXOccphGEvEoiIo9eE4pN/kTK7
X-Google-Smtp-Source: AGHT+IE10HHz3yYmx/uffRuhbNijBKwCmDk4nFNFl6cPcdopzfDt0ksJsMbZUdbdsJqXHbK4drp8pQ==
X-Received: by 2002:a92:c26c:0:b0:431:d864:3658 with SMTP id e9e14a558f8ab-431d864382dmr11809555ab.20.1761143691536;
        Wed, 22 Oct 2025 07:34:51 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a973f39esm5060663173.40.2025.10.22.07.34.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 07:34:51 -0700 (PDT)
Message-ID: <8486dc74-44a3-4972-9713-2e24cefced22@kernel.dk>
Date: Wed, 22 Oct 2025 08:34:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring zcrx: add MAINTAINERS entry
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Mina Almasry <almasrymina@google.com>
References: <20251021202944.3877502-1-dw@davidwei.uk>
 <60d18b98-6a25-4db7-a4c6-0c86d6c4f787@gmail.com>
 <832b03de-6b59-4a07-b7ea-51492c4cca7e@kernel.dk>
 <3990f8ee-4194-4b06-820e-c0ecbcb08af1@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3990f8ee-4194-4b06-820e-c0ecbcb08af1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/22/25 8:25 AM, Pavel Begunkov wrote:
> On 10/22/25 14:17, Jens Axboe wrote:
>> On 10/22/25 5:38 AM, Pavel Begunkov wrote:
>>> On 10/21/25 21:29, David Wei wrote:
>>>> Same as [1] but also with netdev@ as an additional mailing list.
>>>> io_uring zero copy receive is of particular interest to netdev
>>>> participants too, given its tight integration to netdev core.
>>>
>>> David, I can guess why you sent it, but it doesn't address the bigger
>>> problem on the networking side. Specifically, why patches were blocked
>>> due to a rule that had not been voiced before and remained blocked even
>>> after pointing this out? And why accusations against me with the same
>>> circumstances, which I equate to defamation, were left as is without
>>> any retraction? To avoid miscommunication, those are questions to Jakub
>>> and specifically about the v3 of the large buffer patchset without
>>> starting a discussion here on later revisions.
>>>
>>> Without that cleared, considering that compliance with the new rule
>>> was tried and lead to no results, this behaviour can only be accounted
>>> to malice, and it's hard to see what cooperation is there to be had as
>>> there is no indication Jakub is going to stop maliciously blocking
>>> my work.
>>
>> The netdev side has been pretty explicit on wanting a MAINTAINERS entry
> 
> Can you point out where that was requested dated before the series in
> question? Because as far as I know, only CC'ing was mentioned and
> only as a question, for which I proposed a fairly standard way of
> dealing with it by introducing API and agreeing on any changes to that,
> and got no reply. Even then, I was CC'ing netdev for changes that might
> be interesting to netdev, that includes the blocked series.

Not interested in digging out those other discussions, but Mina had a
patch back in August, and there was the previous discussion on the big
patchset. At least I very much understood it as netdev wanting to be
CC'ed, and the straight forward way to always have that is to make it
explicit in MAINTAINERS.

>> so that they see changes. I don't think it's unreasonable to have that,
>> and it doesn't mean that they need to ack things that are specific to
>> zcrx. Nobody looks at all the various random lists, giving them easier
>> insight is a good thing imho. I think we all agree on that.
>>
>> Absent that change, it's also not unreasonable for that side to drag
>> their feet a bit on further changes. Could the communication have been
>> better on that side? Certainly yes. But it's hard to blame them too much
>> on that front, as any response would have predictably yielded an
>> accusatory reply back.
> 
> Not really, solely depends on the reply.

Well, statistically based on recent and earlier replies in those
threads, if I was on that side, I'd say that would be a fair assumption.

>> And honestly, nobody wants to deal with that, if
> 
> Understandable, but you're making it sound like I started by
> throwing accusations and not the other way around. But it's
> true that I never wanted to deal with it.

Honestly I don't even know where this all started, but it hasn't been
going swimmingly the last few months would be my assessment.

My proposal is to put all of this behind us and move forward in a
productive manner. There's absolutely nothing to be gained from
continuing down the existing path of arguing about who did what and why,
and frankly I have zero inclination to participate in that. It should be
in everybody's best interest to move forward, productively. And if that
starts with a simple MAINTAINERS entry, that seems like a good place to
start. So _please_, can we do that?

-- 
Jens Axboe

