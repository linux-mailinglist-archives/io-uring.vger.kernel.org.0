Return-Path: <io-uring+bounces-10069-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 22A0CBF29B8
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 19:07:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A9F4A348C71
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 17:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E44B2D77F7;
	Mon, 20 Oct 2025 17:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Agb5Wfad"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5832D1F44
	for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 17:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760980052; cv=none; b=glZlU9Hf1J3ZTRjRn+Ekk1WzcvixkKYidPlhS/IxOcvJgOW/GLPXwn2SpnUZD5Cx0RRtkkJDfllA2l6YabeUX761inAnNWelel/hxVEyhExJolb7mBBWOw5NoE7fEmHU2VZTWLF+rAqN5yePH+QS5Wyu75O2/tiOx4QBlFOUXBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760980052; c=relaxed/simple;
	bh=UP8ju3oLyGam9o3Jwxndelzmwp0/8cWAGBECcyPgGa8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FZXtwAdK3VvtxppeGd5wzaKRVxb75BHetiUYsT9Nkrclq02wxJgdVlbP7Rx6Oe1b3xrCmQPEJ8paqyYV0lTaBCTC+nxcdeJVWoLAJGwsX1YQjuA3DziC5LU1kp+QPN6IPQUSig+VTwEXY1kb2IfXNI2Y+zLFOeBWzaRtHXVvSHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Agb5Wfad; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-93e2c9821fcso401908639f.3
        for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 10:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760980047; x=1761584847; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l9oLb02CHdpCCQ1nY7ZQqFz7AP1qlEf+hc2vQIe69fQ=;
        b=Agb5WfadpJKTmY7L3zMz/8U5SMRMbZc3zMKkhBL5ZfWlZivtq3K98sS8lPTPxzJmfG
         WEbIUYCBYUgl9tEQwpki/HvAgMOkbqZzsA9HrRAlqN0ivpHI9nvvZWunUDoSoYHkEuwq
         vfNELLH4XTqwOzTtT8drq4kHzXCtfa7G2YT9Y92hahxPr3XOyzOyzeHhWhVplS3Zaxsj
         WoM2IoDRMBeL/dN0zk+D+0yaVBINh+izrZ+MThmcnkGArtOdt55PaGz1TMj/PNgHTciD
         s349u9mVRakTt8h9fha+rdbeqeS2MrpQv0X/s4EJLiNtpdONjoXR24WlzGb/yO3WnmYP
         4y3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760980047; x=1761584847;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l9oLb02CHdpCCQ1nY7ZQqFz7AP1qlEf+hc2vQIe69fQ=;
        b=H3WGJYdLkoTcg6wNK89iBueu0InhjdzQHxc8e7Bd4FEPkJB+36mL6D/f1ybH4HwrSS
         uef/uf0u7OVRmy4xKj3n262PLb+O7BM6CpzI/ikUo6awjWJ5htZRtGc4MK/SRXNF9dUc
         QHe9Is73dXvFSm/zAWGdjACoo0gn+mSJuNsrU2kjF1FwXjd4+mbQXnlud/Y8zf6af/4j
         1UmV3zLkE22D0bJ2VqO6DRZACFIWzRCmY8hMw2yzaUbDFYTPlLIhNtqRlKOK6sJFlym+
         F20VSStiVycqAW62Q+i3BnI39f/7KuBlgMPXfrZBefVi0LOV6amkKcriXPf1gUWOzMNx
         FfAA==
X-Forwarded-Encrypted: i=1; AJvYcCWqY3mJtbjOwNYeHCS1Xnk1GQzkoGhfEvZC/ln8lLRn7GfY4bwQVt+a5GqVnKu5Xv7B4iFngm4PQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr5W8e+s5s0isOQ9sMkFJqheCagjN3+NRFLmjGVdi2WWslX8Lz
	KX22X1HKtHBlcgMF97mzMu8zl1xDrjXfPztJ+KoBiYd1SzEA0WnOWS1ADXocSqTNdJG/l6EDzkB
	sbISDgpY=
X-Gm-Gg: ASbGncuaYCQrys9aA3cnUylEDCnc0tSBs9hDg6XWvtvsGmD+G5H5/caOPimRWZiepuB
	EbVVrhji0EbNK04UCwJodQHRsaRn9ghjhpZRyefAI/lQHvn7ybxWnnW5yKhIJ+VzkkFylXMHFZg
	0Zv1cqILB9M1/ZzKmex/IwcROQJWx4s31iUjj2y1HNdmd6e8jUlpzXc1gO/KqinfXgUnfG2ofuf
	zeGZL/UcYq++9jBu0pqz/um4S/zG61N0hoMAETJBVBgDzg3HnJsX3qebtxKRuya+XHOzV1LF/KK
	bi6qb2fGFlyl0vcYl4xHSvuYlCUMPFcOki8hs+50o7Py6fgRVokGTHvdnWe6GfzPuetHd33uPUj
	Dwgt0yPwwUXS314Re0U4wy3L8MtmbsW1tzeN3zEsfIPM+kfSCTTiGD804sDL3oudH5v1AhV8z
X-Google-Smtp-Source: AGHT+IFQFjKYAl+qIlgNUr7L9f3P3hjqiC1+8tkNX2rrsqGslTrmWV5MGCA2OSzMe5yGCVPoh739Jw==
X-Received: by 2002:a05:6e02:1fca:b0:42f:946f:8eb4 with SMTP id e9e14a558f8ab-430c527bca5mr187995955ab.21.1760980047423;
        Mon, 20 Oct 2025 10:07:27 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a962f04fsm3110479173.21.2025.10.20.10.07.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 10:07:26 -0700 (PDT)
Message-ID: <7a8c84a4-5e8f-4f46-a8df-fbc8f8144990@kernel.dk>
Date: Mon, 20 Oct 2025 11:07:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: move zcrx into a separate branch
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <989528e611b51d71fb712691ebfb76d2059ba561.1755461246.git.asml.silence@gmail.com>
 <175571404643.442349.8062239826788948822.b4-ty@kernel.dk>
 <64a4c560-1f81-49da-8421-7bf64bb367a0@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <64a4c560-1f81-49da-8421-7bf64bb367a0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/17/25 6:37 AM, Pavel Begunkov wrote:
> On 8/20/25 19:20, Jens Axboe wrote:
>>
>> On Sun, 17 Aug 2025 23:43:14 +0100, Pavel Begunkov wrote:
>>> Keep zcrx next changes in a separate branch. It was more productive this
>>> way past month and will simplify the workflow for already lined up
>>> changes requiring cross tree patches, specifically netdev. The current
>>> changes can still target the generic io_uring tree as there are no
>>> strong reasons to keep it separate. It'll also be using the io_uring
>>> mailing list.
>>>
>>> [...]
>>
>> Applied, thanks!
> 
> Did it get dropped in the end? For some reason I can't find it.

A bit hazy, but I probably did with the discussions on the netdev side
too as they were ongoing.

-- 
Jens Axboe

