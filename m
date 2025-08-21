Return-Path: <io-uring+bounces-9182-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0340CB3016C
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 19:49:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 515AA600253
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 17:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BEE21FE44A;
	Thu, 21 Aug 2025 17:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3Er/EGEQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21E631DD90
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 17:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755798458; cv=none; b=KUj5GZlJ3YaOmcKWAnNUoNxoTnfW19JnHvgHOvevzVmEH0KhwsOQSEU66HzSxQVSDDPZ5Ke5ESOJ0kEvbOxWa/z/gaNftT6iwUL5O+HDguRu/qYCZ78FkeSXY3U8faL7RjdmvXiOMCy49iG97sCWKZJgK+ab1W33BMxDIeFHkaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755798458; c=relaxed/simple;
	bh=/YkTer0t30j9gNYuuAxlZjdPlmTckp6oGl3mU9GH3NQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iTpOC6dGKVTVNWtpgqyfD24cw8TXrK723muxjU4OpAeU7jMxrFESYUHfPCLaaqAl+4o4cz10CKO6EV/PRRCKz1nihL/cLH27nKchhJnR1dJ4ydfFUTTNXsSdOs1oLRt2dM98b9JSgjGiZ+7lIbHL+9TbGpWP3GON+585qQARoqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3Er/EGEQ; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3e854d14bdaso5712415ab.1
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 10:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755798455; x=1756403255; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GOxxZSKEDQ8FoZEpirUvSizmTU7Xmjt2/atdWAtJaWw=;
        b=3Er/EGEQ4zMcyMmGbX4F9TrVHh/MiXhfN9GQzGPHQj/VFZ3Lluvvm51l7R9p2j5fRb
         C5meXHdnUGvfPqQ3eupOeNhdMvnWtNtf/SUO1EDB3TgEr8qs40j0meXLAi9cpk+I3NqH
         V7fdh1O1TYyVJ3nzkY8+/KBDWNYjqN7/SmCfGCPY+Ik00eG0DT5k1ehtHg+BZqDL8jiJ
         9ge/7A4jWR2b1s4goQEvbuPF69I2abVZwx+3jfqBmKqogKy2cLemwbUyhTfYFxFV8pu1
         s6+bOi8C0yMjyaulhZnWvQs5CDEiO4PaxTgvlkfbsja5nhQhnFBzY6qOE99IIwxEcsbc
         J5Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755798455; x=1756403255;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GOxxZSKEDQ8FoZEpirUvSizmTU7Xmjt2/atdWAtJaWw=;
        b=HBUpqVKhWCgndwG50vIgmEVCmyODVQS1ZWkc0W/xyxxy7cFaRVJhrIJMUVcLrB3+RP
         WyPO7NXfKLSyzBTF4bsTp4d7UjyeU2fNuURE9M0U1XY9ASMF7YEtqNWcU/qNfhtaAHrD
         xQu5B3bLCOwb107oSm1q45h/8l0yzfouj0BNt+rpI4lTZWKGdnwopr0fARCJf/Bwdr+p
         ney6usvDXFdxEf27FOcCU2R6B2WRv6W6szXMQmFUWcxCI1h+Qmq2xMo9fhMVw15JkzxJ
         ND0H4NPw+zyBmTKQQxmFzFN4caWTYrRuQN/mN/l/WJkfFtNFkTfYxkxVV25Qa+xJj2mr
         Pipg==
X-Forwarded-Encrypted: i=1; AJvYcCV71MfseAqUWQIPS/+/NmG31p3VEsk/msgtCl1613rD57C4+hl8enyMhGzxEC1CVFR3Tdj+m1GOIQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzXvMDkGJ+njgbSJnkvwEixhI2rj3ZOVbiswi6rulVJKUnw26+q
	IcbuoCikhyYNXySdmzp7szI07EJzPo0QJ1lf7Jg3Eud+Qd9oRbMZi3bty/nN35qR43er9aDq/e9
	Jp6ZT
X-Gm-Gg: ASbGncsf87m7Qq5Y1gzn+erEe3mwAdtZvvqusyoOzK7CK5krwcCoPWc5xAgGQbIAE92
	BuBeMWG8bnZ610aNK57ooLeTrmN/+HsMIyj1D8Gu12uFG3JIpfg7X8DXZtM1EQfErVjo8lqna9p
	Eh/rYSoiRwiTyh/guz3q3S8BJdVChQ5eg2M+3T7JgmCI6QrITg6kLDDHfP/tIQqiCX2XMmjpnyM
	JVyy9p+blOVSSNBZaXFWKu8IYuQedPsb4Sz1r9dFEGqifV0fSp0wMvz/6b1qUt6JhTobMT1iYzn
	bXQJy21W2021NFrNFN2qq/RXqdblPRnkU+cb7cKhLAVxRzKI35+lr40UlItwp2As+fEz8VRmrHl
	ezG0dYsdRMEuDGSnE9tR01QpsGe7WxQ==
X-Google-Smtp-Source: AGHT+IEdj6L/Bf+whQ75I30VwLG1YSWcMSTlZN8ExBNZmUyXQWFB+ZYRYXU703WGyGCLp2eRYKp5Rw==
X-Received: by 2002:a05:6e02:184c:b0:3e8:cd52:4ccf with SMTP id e9e14a558f8ab-3e922125000mr4531505ab.18.1755798454690;
        Thu, 21 Aug 2025 10:47:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e59b951sm76392915ab.13.2025.08.21.10.47.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 10:47:34 -0700 (PDT)
Message-ID: <1bbb3425-557d-4c6b-be41-2ae67336e413@kernel.dk>
Date: Thu, 21 Aug 2025 11:47:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v2 0/8] Add support for mixed sized CQEs
To: Keith Busch <kbusch@kernel.org>
Cc: Caleb Sander Mateos <csander@purestorage.com>, io-uring@vger.kernel.org
References: <20250821141957.680570-1-axboe@kernel.dk>
 <CADUfDZragMLiHkkw0Y+HAeEWZX8vBpPpWjgwdai8SjCuiLw0gQ@mail.gmail.com>
 <6145c373-d764-480b-a887-57ad60f872e7@kernel.dk>
 <aKdZ8TUE811CBrSn@kbusch-mbp>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <aKdZ8TUE811CBrSn@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/21/25 11:40 AM, Keith Busch wrote:
> On Thu, Aug 21, 2025 at 11:12:28AM -0600, Jens Axboe wrote:
>>
>> For the SQE case, I think it's a bit different. At least the cases I
>> know of, it's mostly 100% 64b SQEs or 128b SQEs. I'm certainly willing
>> to be told otherwise! Because that is kind of the key question that
>> needs answering before even thinking about doing that kind of work.
> 
> The main use case I can think of is if an application allocates one ring
> for uring_cmd with the 128b SQEs, and then a separate ring for normal
> file and network stuff. Mixed SQE's would allow that application to have
> just one ring without being wasteful, but I'm just not sure if the
> separate rings is undesirable enough to make the effort worth it.

Indeed! And like Caleb mentioned, their use case already does this in
fact, just passthrough with housekeeping buffer commands.

>> But yes, it could be supported, and Keith (kind of) signed himself up to
>> do that. One oddity I see on that side is that while with CQE32 the
>> kernel can manage the potential wrap-around gap, for SQEs that's
>> obviously on the application to do. That could just be a NOP or
>> something like that, but you do need something to fill/skip that space.
>> I guess that could be as simple as having an opcode that is simply "skip
>> me", so on the kernel side it'd be easy as it'd just drop it on the
>> floor. You still need to app side to fill one, however, and then deal
>> with "oops SQ ring is now full" too.
> 
> Yep, I think it's doable, and your implementation for mixed CQEs
> provides a great reference. I trust we can get liburing using it
> correctly, but would be afraid for anyone not using the library.

That's the same with the mixed CQEs though - as you can see from the
liburing changes, it's really not hard to support. If you're using the
raw interface, well then things are already a bit more complicated for
you. Not too worried about that use case.

-- 
Jens Axboe

