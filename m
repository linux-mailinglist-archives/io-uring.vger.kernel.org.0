Return-Path: <io-uring+bounces-512-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4A9084492C
	for <lists+io-uring@lfdr.de>; Wed, 31 Jan 2024 21:52:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E57531F24F18
	for <lists+io-uring@lfdr.de>; Wed, 31 Jan 2024 20:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAAAF31A61;
	Wed, 31 Jan 2024 20:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wDluApGO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30AC383AA
	for <io-uring@vger.kernel.org>; Wed, 31 Jan 2024 20:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706734355; cv=none; b=TL7wYO29a0iVRBes8XYoEd/m2LIJtFTt6lS4EpcYOO6OBztH3zqiDYOm6ksKSqikhc+PSgn47+aoKf7jnMkcNniSTyvG9kSYRlgAj+AVfdsDMMs98NVg9bZLiPYJfGkZMDve9KciX6V/osUonHYlStn1ZxNc1io4cz8uomvkc3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706734355; c=relaxed/simple;
	bh=mM38yJOGprULAWqOAyKxt7s6w9Ts5ZUiEmKDPRE5i/A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bNC1IGF9hRyZJ+o6LCLSJQ7D7se9n+u+CNiFPU24RtsueXnT9KdzAPWG2qbvh1zvAJZff19hxoAkgmw6dy2bTsRUjX+0NGtIWxOuDHHG873K9N1QRSLBswLlGIcnSyDchNbzU33dadMiOgnK0tuIUu8iFzondCv+VkzBA+5jf0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wDluApGO; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so118539f.0
        for <io-uring@vger.kernel.org>; Wed, 31 Jan 2024 12:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706734353; x=1707339153; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MI0I/5jRbDxq7FwBjs6xuJmbHSVPqwZgw/qW33Xrh84=;
        b=wDluApGOhpPiON+Cbkr4ighAt2PxU2hNtkbVOGVBdUeGMtcB1qQ3Ypz4oIPtTHpvx6
         3HBHio1HtN9R4svEhaLVVicQyYpKtg8GdoNlv0zP1tckwj1y+b5/v4aHWVansvskyt2+
         EoT/Q4ySCJb4DieyENX+Dy4DsvK+hc/Y9NbSaXMWzt6XDVS5LSZKNEyIchLM3UC/IgrQ
         PFnzozmoC9vHEXNRnaA5NMNMgDhcFozl0DqSPoW6uVeucm8B1IKqNcm+k0DjGy/UwliJ
         Mol8mXAXK/nbuaP8rZxdR1zz7hJ4ZdfdXQdg134eErdKfIcGxSpyMfBtjxDSIpS51mTg
         /LQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706734353; x=1707339153;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MI0I/5jRbDxq7FwBjs6xuJmbHSVPqwZgw/qW33Xrh84=;
        b=w48iQy8hZgG4BlWyXlB15v236IBGS3cotS5Ml4w40QmQtP2sug3t/dlfx37JH36jn7
         SWW4lTX9SZAMP/3mGUV0CGlz1dtt83JcoStHa6y97xdcRqKvhJ2GdzJ5VnjZL0r+NIk/
         wvUbfSAviyf2n+cHaNNlm+xePR1svn8EXWS19+Is/KfPEzSCOxXlVOqKGz4OLZufXi3S
         mkjwO7+kS/lKWbjnaVc3Mhlj/u0GPxElVBxTPVx+UZAFFMKutMwy7C55lEWjoHbDePYk
         vTWUKwaeL5dZBQl+BbTlb6Eo0jj+XRFbwsKF/9feIS8GXEUcHOCAawca+liq0HQ9islf
         L1oQ==
X-Forwarded-Encrypted: i=0; AJvYcCVH2PNEahln0aDNX2+gkc/RdTwheYlHI2GA/TNjb4TT203FtntSxMWUIsrEIU3X9jbRS27AoastlACZ6s/L4M0e2CU7By05k9s=
X-Gm-Message-State: AOJu0YzlH0/lbqP91yadfzYxF+ynFvTLcg8tDKTx0PieMOkO0fQ4F52U
	X7buJlNzT8gezKChCBZ+S0kOlKByrG1zdmDfVCq8V7Ip6Vd5xhgPgK1BpkjVoG4=
X-Google-Smtp-Source: AGHT+IEfDXi59Ug1vRfRMmzi/X72aeu+HqhllvotGt3n45I8J7MYRS47ZWMvJsF4BtYk33GazNprbg==
X-Received: by 2002:a05:6e02:1bce:b0:360:7937:6f7 with SMTP id x14-20020a056e021bce00b00360793706f7mr754911ilv.3.1706734352752;
        Wed, 31 Jan 2024 12:52:32 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id fj53-20020a056638637500b00470fb0b1af2sm80523jab.10.2024.01.31.12.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jan 2024 12:52:32 -0800 (PST)
Message-ID: <a0f5b96b-c876-4c0a-a7b5-3809c26077d6@kernel.dk>
Date: Wed, 31 Jan 2024 13:52:31 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 0/7] io_uring: add napi busy polling support
Content-Language: en-US
To: Olivier Langlois <olivier@trillion01.com>,
 Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
 kernel-team@fb.com
Cc: ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org
References: <20230608163839.2891748-1-shr@devkernel.io>
 <58bde897e724efd7771229734d8ad2fb58b3ca48.camel@trillion01.com>
 <2b238cec-ab1b-4160-8fb0-ad199e1d0306@kernel.dk>
 <45a21ffe4878d77acba01ec43005c80a83f0e31a.camel@trillion01.com>
 <b6dc538a-01eb-4f87-a9d4-dea17235ff85@kernel.dk>
 <34560e193660122ea142daa0fbeb381eb7b0eb6d.camel@trillion01.com>
 <c28b3f5f40ed028ba9d74e94e3cc826c04f38bf7.camel@trillion01.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c28b3f5f40ed028ba9d74e94e3cc826c04f38bf7.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/31/24 12:56 PM, Olivier Langlois wrote:
> On Wed, 2024-01-31 at 12:59 -0500, Olivier Langlois wrote:
>> On Wed, 2024-01-31 at 10:32 -0700, Jens Axboe wrote:
>>>
>>> Thanks for testing!
>>>
>>> Any chance that you could run some tests with and without NAPI that
>>> help
>>> validate that it actually works? That part is what I'm most
>>> interested
>>> in, not too worried about the stability of it as I have scrutinized
>>> it
>>> pretty close already.
>>>
>>
>> There is maybe a test that I can perform. The data that I receive is
>> timestamped. I have a small test program that checks the age of the
>> updates on their reception...
>>
>> I would expect that it should be possible to perceive the busy
>> polling
>> effect by comparing the average update age with and without the
>> feature
>> enabled...
>>
>> A word of warning... The service that my client is connecting to has
>> relocated recently. I used to have an RTT of about 8mSec with it to
>> about 400-500 mSec today...
>>
>> because of the huge RTT, I am unsure that the test is going to be
>> conclusive at all...
>>
>> However, I am also in the process of relocating my client closer to
>> the
>> service. If you can wait a week or so, I should able to do that test
>> with a RTT < 1 mSec...
>>
>> Beside that, I could redo the same test that Stefan did with the ping
>> client/server setup but would that test add any value to the current
>> collective knowledge?
>>
>> I'll do the update age test when I restart my client and I'll report
>> back the result but my expectations aren't very high that it is going
>> to be conclusive due to the huge RTT.
>>
>>
> As I expected, the busy polling difference in the update age test is so
> small compared to the RTT that the result is inconclusive, IMHO...
> 
> The number of collected updates to build the stats is 500.
> 
> System clocks are assumed to be synchronized and the RTT is the
> difference between the local time and the update timestamp.
> Actually, it may be more accurate to say that the displayed RTT values
> are in fact TT...
> 
> latency NO napi busy poll:
> [2024-01-31 11:28:34] INFO Main/processCollectedData rtt
> min/avg/max/mdev = 74.509/76.752/115.969/3.110 ms
> 
> latency napi busy poll:
> [2024-01-31 11:33:05] INFO Main/processCollectedData rtt
> min/avg/max/mdev = 75.347/76.740/134.588/1.648 ms
> 
> I'll redo the test once my RTT is closer to 1mSec. The relative gain
> should be more impressive...

Also happy to try and run it here, if you can share it? If not I have
some other stuff I can try as well, with netbench.

-- 
Jens Axboe


