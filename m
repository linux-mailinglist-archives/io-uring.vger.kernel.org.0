Return-Path: <io-uring+bounces-1440-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B92F989B426
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 23:49:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAE3A1C208F5
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 21:49:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 104EE40877;
	Sun,  7 Apr 2024 21:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bUS56lmt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5532582
	for <io-uring@vger.kernel.org>; Sun,  7 Apr 2024 21:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712526549; cv=none; b=K/FtsZ2lpJi+Rq2vy9k7eVlbyZlw53DB2RTAudXDpW/tYmxfWAfx90NsfwodDd5oJ14NlvLXWnt/LmqJdsZ7EoPZO6TuP7bri3nZJM0U7fKjM3rU+XUbFA0ESbactcK8xVSbSgx2kJmCc40gqzmDADhhgaDj2Q7n5+lEDDdJHms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712526549; c=relaxed/simple;
	bh=DMK8aOgHRwrbP0JfaSXi6aFi+iYSGE5f8zhU32uqU68=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uvyRtxtkT4HsCj8FeDYTW0+bkqeR0P0Wb4JRjExjDXFeT3LNelWhB9JbAqnyhIndHYULx1uePpl7lbIDzG73lNGDSDOR4Ey7rqoRFKRq1UKqfFuyBNp+oq8vaKtgYZC8CuofRqDphvyCgLANi2H6nXCyXCECjBpOXYuqeEVuyIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bUS56lmt; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so86342839f.1
        for <io-uring@vger.kernel.org>; Sun, 07 Apr 2024 14:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712526545; x=1713131345; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lgD4Kkdontvv7mkgqkP3PlTBGqm9lSrHCrBMgR0KaLM=;
        b=bUS56lmta4h+Ugbc3/gv1IFaib3UAAOW7r4f9kPfoP9flLa/1oGfd+Si/8ABxFrCeq
         vahW3bFqCZR8t0FKwZ8ujRC6+EefWJF6EEnzpRO0WGG8POyr/Flx/uAAvBUXSE6mx9d7
         3c3Gw13rFxGnH8MBnpXAB3Wg7AHbC2J+lYen8aV9MZmcWHAiepis6Ye6V3mMG3J8WWvf
         ngfgPXehQh44rlYuwolj/TY2U/7kyCczWWxVRzSm0e4Zo84e67+m8sgD6BY0TCSOcZgY
         unR09K3jAuuduV+E/b53efk3vSdGRKpUTautn5KnUFYfgeyTp2TsbqcdJqrvPBgRAjte
         SRsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712526545; x=1713131345;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lgD4Kkdontvv7mkgqkP3PlTBGqm9lSrHCrBMgR0KaLM=;
        b=UHov0L5C0Sf72uI4azNFdLR8ZrFNxLNBkc+kFtSp4TLqVxhz/yFPDuKycQ3k9D79gg
         zQBN6Fa3q3FyUzdU7HlYM12X4k41UW3Y8gd1ph2zRvUhS3IYquybapphqVamg2SECOn7
         gM43tzL2dFSGPF+hud4BRPIQL7XVzeSMecRStOPSedWMQcyG/3QYqt4avNKwBFIWB3AG
         UainrMFyH43Paz2HSOSP4KiM/FHvocLO4BW+VDKjMvt4e2xjyTX6N9EF2OpIsjRyRC6p
         VnuR+TS9V1GF8RvisEDoNN9UZiD9BQQTJwlPbkMSAZb5yC80+GAxa4mP5WwIjvMOftew
         /epw==
X-Forwarded-Encrypted: i=1; AJvYcCVJNpUCoxK0J2aJ4m+Mbx8gccacKyLMenVlCXv+JJwSS/W8jMDCxlbUE3F3bOhHsNQn2KwxuTDFJHMywvt/Dh2OUC2Lqwu8n1Y=
X-Gm-Message-State: AOJu0YxYVeSz38isk42GtJqFv5FISYe6tvHKeloLvpk9DpngBGjeAIAc
	Kbi402gSbjJLXekWJdObZpREG7yBA7XQOQEvC7kKmilXbhSOT9tuMOhnQXcN2Vc8UE03vQGHcwL
	y
X-Google-Smtp-Source: AGHT+IF/QH+QFUjJ3gv2/as7wPTQzV7jMlYCPDtrui02/z4AC4jHLceWKgld2RVPCrHd8cGtLvfVJQ==
X-Received: by 2002:a92:d809:0:b0:36a:1275:4aeb with SMTP id y9-20020a92d809000000b0036a12754aebmr4470579ilm.1.1712526545610;
        Sun, 07 Apr 2024 14:49:05 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z6-20020a92d186000000b0036a11e2f01asm1344126ilz.36.2024.04.07.14.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Apr 2024 14:49:04 -0700 (PDT)
Message-ID: <c6da71a8-8d3b-4bda-a8da-a45ae6c9e501@kernel.dk>
Date: Sun, 7 Apr 2024 15:49:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] io_uring: return void from io_put_kbuf_comp()
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
References: <20240407132759.4056167-1-ming.lei@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240407132759.4056167-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/7/24 7:27 AM, Ming Lei wrote:
> The only caller doesn't handle the return value of io_put_kbuf_comp(), so
> change its return type into void.
> 
> Also follow Jen's suggestion to rename it as io_put_kbuf_drop().

Thanks Ming, applied.

-- 
Jens Axboe



