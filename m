Return-Path: <io-uring+bounces-9792-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00D17B58028
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 17:15:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 636D6169AED
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 15:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47FA531AF31;
	Mon, 15 Sep 2025 15:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aLGCf9TO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BC430E856
	for <io-uring@vger.kernel.org>; Mon, 15 Sep 2025 15:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757949177; cv=none; b=PuRBQ8kNZFQpt/c57reMlAJ3veVScxT6djHjQFN4ZR3l8d6x/2xLat5y+jxvj0AZ0frxnzFxHc8QPQQvXNg7b9U5gJQLfv8I38FICCNzChNsFyT+ydd9Y3hO6DifAhm3THnSnDmMF+rmpQU6f8x+Aap6Ae4fCqs8weE3Z0vc2Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757949177; c=relaxed/simple;
	bh=JZsnQjbSavjo4iRyY0Jsfu5oNgRLIQnYQ6ozW8ZCMos=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WBvtCDT1PU6Du7rZgd7h8h/d6/vG8XrKFkeEExqnMO/CseNtfwiH9IiNyho9+g2f+cZ42/psaNjP1Y3D7F0WMx1NQo/iGNnKZKi3lxmkhBrJlNxGtcysp+ZgMWJspk3Eo6U39IDsblZGwXsj4hluw7xDy/xyCilbHuWcsL1+BhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aLGCf9TO; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3e98c5adbbeso745813f8f.0
        for <io-uring@vger.kernel.org>; Mon, 15 Sep 2025 08:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757949174; x=1758553974; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gYASgt88NcGmMcWlF6HmYxlmhj+ofg/BJ5SXgUevRck=;
        b=aLGCf9TOp8R/5uUHXdpUW61X18s/nfI/bKh/twz5g8Mv6LSoCLpvzjI4D22Aa2EUrr
         uem2q3cO+g6w9xad+qaLMcSM4geJLGOTVTy5AlKPgacfQZT7yEgf80nf/8RCYqXzwVOp
         oEMGCj6PA0IR7QUlFQgHamatSZqJKChk5/G025nPDUIkKiylDsazpwrpy/zFLHwM9b7y
         bavij3zAm3l5hZr8NwbDjC3Mk6FyAO4F74rwr3vwUmCwPmslw+ByGTCTzHaUsEShLVTo
         4KJnBkCduYhVzLbQsr1GqftSWr2BgnStAAFiP8jdtRsNaKST6Zm9/g11Ng9seoMqR0py
         if/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757949174; x=1758553974;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gYASgt88NcGmMcWlF6HmYxlmhj+ofg/BJ5SXgUevRck=;
        b=k7VXcCdXMr9wVN5qaFLuKs7qmAMOZPrCs3Qnx5+M76MPjAWu8NH6zXobusP/Z8EG5i
         6gJO+kio817caDeQsNPlw0EugkJImjhMUsOHnFfEKIWIdL+t6r+k9yG6zzqb7xAVGZkv
         ehf8B8JYbNz+T4vWaP4SnMgqMDEeqb6FWYpKlhoBXVeOuvLxqqgjxx9HPEIs/EMW5UQS
         pTPdk6aLpjEO0IZWsWCaqRv2qj4h8Uwj4vvmgf3Fun1k4n9Q5D5KYbXmcrk0oLADi27Z
         Nl27JHq8ozvfbjgWXjLBNd0LzeF1wYrb3C5xZyLGg9nh9eRjncEQd9B+KlvxGouRaqu/
         62iw==
X-Forwarded-Encrypted: i=1; AJvYcCVzp+MPTTrWN/OKZjSjJnuff5cy0ktg0pgyN/tAu5Zd3SyICV2RWW0zLbz49hAUhBmlShWySCmu+A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyTyaKDyslvDkzkG3zCzS/yYeEZmabkni6uEjS6Iw4HGBseW2N7
	NX8e86BuoWCcUR0a8c1+06XeX7LhywjRtSr3kK/qQxlXkYW32ln9JSts
X-Gm-Gg: ASbGncvgeSiOBQloA12zPu+6YXz/1YHPzxkoXA4fFoDdPzdArhQFlXueoWzArAAtcJO
	XMp0p0U9/6FyR8KJZdMeZlRo8pBEUFMuEY7Ib6678fSTuYkuTFqmTf4u2621yOZv8GCOenqzOAH
	s4kEF7iIQVOOe21DJDKpraMC+c50DpwBMYPaQQ3vktRZ/pFfvvxNJ3j4wMZxmDVAKi7RXuFNU1F
	hEQCthe6g5ZeKydH1xM7WXXgLpxXaFi/LGXO81z5tDMtFm+rtIU7BB/XvIT7YHjiPv7KbsCnOdM
	W1G1hJAk87plil1G7INmCiTY/5dqfNVte6F84n17Wv3HMT3UdKA1CKyPfXnnZjdpEbhT7h5Qtzp
	rYu+8xjGa/cDHHOEy1Zjlj4pEgqqCtrIznNJsYvKwW2E=
X-Google-Smtp-Source: AGHT+IFQ6qmP6lhN+miezSHUvoqgK6PL3UztubUPwCE/xaA47jcdO+kWsn2hah9mUl3xrLFUWQbU+A==
X-Received: by 2002:a05:6000:420a:b0:3e7:63c5:9a9d with SMTP id ffacd0b85a97d-3e7655941c3mr10223551f8f.6.1757949173481;
        Mon, 15 Sep 2025 08:12:53 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.145.229])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e8c7375fb7sm10001858f8f.14.2025.09.15.08.12.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 08:12:52 -0700 (PDT)
Message-ID: <d11d3f5d-ab0c-4028-a6e9-5cbf2f2aaec6@gmail.com>
Date: Mon, 15 Sep 2025 16:14:25 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] io_uring/zcrx: fix ifq->if_rxq is -1, get
 dma_dev is NULL
To: Jakub Kicinski <kuba@kernel.org>
Cc: Feng zhou <zhoufeng.zf@bytedance.com>, axboe@kernel.dk,
 almasrymina@google.com, dtatulea@nvidia.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangzhenze@bytedance.com,
 wangdongdong.6@bytedance.com
References: <20250912083930.16704-1-zhoufeng.zf@bytedance.com>
 <58ca289c-749f-4540-be15-7376d926d507@gmail.com>
 <20250912072232.5019e894@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250912072232.5019e894@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/25 15:22, Jakub Kicinski wrote:
> On Fri, 12 Sep 2025 13:40:06 +0100 Pavel Begunkov wrote:
>> On 9/12/25 09:39, Feng zhou wrote:
>>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>>
>>> ifq->if_rxq has not been assigned, is -1, the correct value is
>>> in reg.if_rxq.
>>
>> Good catch. Note that the blamed patch was merged via the net tree
>> this time around to avoid conflicts, and the io_uring tree doesn't
>> have it yet. You can repost it adding netdev@vger.kernel.org and
>> the net maintainers to be merged via the net tree. Otherwise it'll
>> have to wait until 6.18-rc1 is out
> 
> If only we had a maintainers entry that makes people automatically
> CC both lists, eh? :\

It's caused by a patch being taken not through the designated tree,
which is fine, but CC wouldn't have prevented from the same
dependency management.

-- 
Pavel Begunkov


