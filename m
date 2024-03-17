Return-Path: <io-uring+bounces-1049-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A4A187E00D
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 21:57:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5374D1C20E5B
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 20:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B26871BC4F;
	Sun, 17 Mar 2024 20:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TViVc01l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F298D1BF35;
	Sun, 17 Mar 2024 20:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710709027; cv=none; b=EOAvrbcmB9DGd4kUfZgEiirOQvPol64HccsBS9T1wcG8pS9eaf+rwp/D7Mic17Q9XIY2T9EqBX66k/o/bH73HjAxlrivPW1KxJEfFSS0MjGZRD+IFjxPvYYmB0SWVU4p0oBkjvKrtUDUCdw/mSyijQQiT11uCwHaCnslt2qQ8jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710709027; c=relaxed/simple;
	bh=QNk2bP6tuxgxyhxKMh59iq3nnhUgpBT/M9NelX5ewoc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LZ6Z5OZaw43NuNqPO8BwgCkjFpT1NHHP1HqEwTJHWZSjD8Qvg619gTCopPES+2SKgeIBusFiH3UlUK9h+L5ZoNwmf9Fs23Sj1ZDGDPaw11EuCWPjrVszlmgtBLpatYiTLeli/LDfrdFwt6wwFaV2g11+RoTtIUiOXE3tFCP4sFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TViVc01l; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5131316693cso4591479e87.0;
        Sun, 17 Mar 2024 13:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710709024; x=1711313824; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S/+Nc2Orbx6px95GeK+1tBNKhyCOmkwArXj0XsdHT/o=;
        b=TViVc01lT0EhvDC/sdZw5ZtfHeWj0j7xJXRoo2EOve89l7bWK4eMJbHPKnjZ11oEOM
         QesNuvVcWZCUH9uogeUKYdt0CqHOo3r+WaopKuVChtmz/C32C9i/xLkQ+v47Fawf358L
         AxAbnaqR8B2t8Sl2/2g+QlIcKNjdY5tl79QeTrwvjw2sFn2ss8Iux0+Ll1TOZqloGg0/
         J6MTMBOU5Ph+Oj4EwAGr0Wm3aPnHxCVYezi9jpI/A/8dQ5bDV/taoUqwrsjD9cxXrLeQ
         0u4loet/1ZRX3ZOXH6uCEmr9oGN/9UU/ilm3pAHbrP05tONHXuBSYxqJZLBVh+mjweye
         TY3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710709024; x=1711313824;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S/+Nc2Orbx6px95GeK+1tBNKhyCOmkwArXj0XsdHT/o=;
        b=L1PynvinO3urGAhRBalLw0x8TZ/Sd5ZTQ/gDehu63n8dGKixnR+livrFS3dngaHjDY
         MDRUrlv51r+Wi7L57803g2202HJitF/S+IT6da47JyJr0d0ueuM4RFvcxGkYg0271+cq
         vhh9Vuf9NAnmJSjG8CnDUr3jKVQVWlXZ1wHAS4AlpkEXp6/L6aGWBcu6WfOXcC19++ns
         AMUY51Nmj1A99gp8HGpHd1rqO43nWBe6RcSq+LFc5Y6HO5L917IXHR2IpyBiX5kSyP0t
         IzzL9StjYDyfx/GdKz2tnsmH6COOC+bGlXASBO00g1ayM7gW4im/QnwQnqypQAkY79lJ
         6hfA==
X-Forwarded-Encrypted: i=1; AJvYcCUdjElrADv1g69n80bhXOSYAcEMMBiSV5dGDxWdg3CxMB/OVeW3EhdieNoNIxrly0+HJMiUJYNu8BlmMgST7GwEQaotpUWRmM4arjYeQHolLO1UD8fBaJGMGEpxcGF2uNwc960zfg==
X-Gm-Message-State: AOJu0YwZvpznRPjON/IjxZAaCA2g7wYQLrQBHvBbSTElx8I9j2Y5X78Q
	zAhF4mGdkW9qIFHKxljfFKrqZGiFkcMvfMwtbOk5gC5hNRWZxOuv
X-Google-Smtp-Source: AGHT+IGMRkiTEEix32U38apRcMOdNklk4H4zou1M515NIdW2yLZr+/J857j4bNYv9Ei+e1ZkNLxfMw==
X-Received: by 2002:ac2:4890:0:b0:513:33ac:fe61 with SMTP id x16-20020ac24890000000b0051333acfe61mr6402584lfc.60.1710709023844;
        Sun, 17 Mar 2024 13:57:03 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id e14-20020a1709062c0e00b00a455d78be5bsm4070180ejh.9.2024.03.17.13.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 13:57:03 -0700 (PDT)
Message-ID: <1132db8f-829f-4ea8-bdee-8f592b5e3c19@gmail.com>
Date: Sun, 17 Mar 2024 20:55:52 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
 <ZfWIFOkN/X9uyJJe@fedora> <29b950aa-d3c3-4237-a146-c6abd7b68b8f@gmail.com>
 <ZfWk9Pp0zJ1i1JAE@fedora>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZfWk9Pp0zJ1i1JAE@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/24 13:56, Ming Lei wrote:
> On Sat, Mar 16, 2024 at 01:27:17PM +0000, Pavel Begunkov wrote:
>> On 3/16/24 11:52, Ming Lei wrote:
>>> On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
> 
> ...
> 
>>> The following two error can be triggered with this patchset
>>> when running some ublk stress test(io vs. deletion). And not see
>>> such failures after reverting the 11 patches.
>>
>> I suppose it's with the fix from yesterday. How can I
>> reproduce it, blktests?
> 
> Yeah, it needs yesterday's fix.
> 
> You may need to run this test multiple times for triggering the problem:

Thanks for all the testing. I've tried it, all ublk/generic tests hang
in userspace waiting for CQEs but no complaints from the kernel.
However, it seems the branch is buggy even without my patches, I
consistently (5-15 minutes of running in a slow VM) hit page underflow
by running liburing tests. Not sure what is that yet, but might also
be the reason.

I'll repost it with the locking fix for reference, would make more
sense retesting ublk after figuring out what's up with the branch.


> 1) git clone https://github.com/ublk-org/ublksrv.git
> 
> 2) cd ublksrv
> 
> 3) make test T=generic/004

-- 
Pavel Begunkov

