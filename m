Return-Path: <io-uring+bounces-4386-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A93BB9BA9AC
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 01:06:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 41692B20B97
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 00:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E52D7382;
	Mon,  4 Nov 2024 00:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hnwcvuIR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CCB17C
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 00:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730678781; cv=none; b=OkOdPorwWVYxcYrQukSU8Gv9ugXTFRboodjqcaMIerx7o16pxfQziX/m/HDa8gLaxMhoXKlpLm4FbYTw4FqB/wF0liPnf+s+vAMddyLa1dJ8EYGx0G5T1NTQHuFKSzESmzsJt5JzrvXAxkRnAYALrVuqTCsUN9XQl2nbVV+Bj/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730678781; c=relaxed/simple;
	bh=iPlxKOOHWo7eLQua1eSVg/d0HLlfCtIEI8Jz6UTlgY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GXAspAm9VhZOnZs37UxzIhuKij3hpGB+NrANieSLQc5DMPwIHUzZZbDEwUZRArEsK1T+LdSsVPCePeHQJFBnC42MkbJ/g0msL8zCwfCTFmQrhGmApoli/RYor8wv2bA1x36eZwAwrlOp5yczzyVSEYY7stZXeQqz8MXiJHbvWqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hnwcvuIR; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7eab7622b61so2853703a12.1
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 16:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730678779; x=1731283579; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HlqKjiv8mwDNX+sFfiUbiDCmCdN9kHhOAK5lcdxFJ3Q=;
        b=hnwcvuIRsAoImLU+6J3p8sLSMxl66CqAGPIoPsaoDupxxmNd5InuaS6J8160uQgyI/
         zS6eNa520oC/AuqgZysJJBFpDYnNkH0LcEdtUSmupEL//CoOIu7Wb053RF24RtQBGcvY
         Z8O04/EZfsmGNRChPb9bckYhvAYKbOMk+ZB36K7fWuqAk13VAAcoysc6FSLkQCa0/TCO
         evkrHYgHCBMnvI2G+diwMphOllnTPmoxnOrFp6PRA2TSF0QwMd9RiCTiIpW2c3t74rkl
         bDLTRCVGNIg1meUPorqWhspdL/fP9f4BNJ1QU37Kg/fpZ5uAK7Exa6OxAc7pM+XchH6t
         AfgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730678779; x=1731283579;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HlqKjiv8mwDNX+sFfiUbiDCmCdN9kHhOAK5lcdxFJ3Q=;
        b=f3M2PR7ICkkluy6GztQCavAGKct3rMeOTly8aDSxY2LDvtbSBhcDcR4EZlHd74j8vJ
         pZzofgjzFWhcLpy1eiwvqKeU4tknv1PmmpoOGgzr5a2aebBXvGefcbwvTU67BD/h5LmH
         iudHBsedDVr9tcsbcVmL2ALJvzENvAtPcFB/6RSs9da5qOkJFfhgRUi15tiUqTVouomz
         +IolVt1m1MrqVra9zm6EZELTCrESxT8I3y1+y9ZlYFcz3Mvzi0OSvurdf8eVWzATrRPX
         sYy4Jp56sdLabm4uUHtkmQ+JPWplFkHH5cevU8xW5GDDBEdWpDdbeIwD412e7mxuI3bX
         umAA==
X-Forwarded-Encrypted: i=1; AJvYcCXeUrksI6QqiyUjuxizfzwHeRA9Ty1Y46A7OT3qOtI/59r3QIbgGFCWG2uF7RQ12jonUKSmX2mZeg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/Bujtkj0QXguFJJve5mSUtXBAAhf/MzTmcENNqUWqzSDgTX2t
	FyR+32GHUoNxCGCy+FhcfpX+kJgxmm5uFpjc/Mm8ZRFEcUcbX4uEWGvmMnRWqH04sBquwBehUjL
	L+kM=
X-Google-Smtp-Source: AGHT+IE+0d+9fGCc5U9J56yaM/jJLc/0+bC7qkImikT4sJcCLuw4WmkKV9tLYZWxUTof+rESLi29ag==
X-Received: by 2002:a17:902:f642:b0:210:e6d7:765 with SMTP id d9443c01a7336-210e6d70d99mr335206165ad.59.1730678778827;
        Sun, 03 Nov 2024 16:06:18 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211056ee3b3sm51261865ad.13.2024.11.03.16.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 16:06:18 -0800 (PST)
Message-ID: <25c4c665-1a33-456c-93c7-8b7b56c0e6db@kernel.dk>
Date: Sun, 3 Nov 2024 17:06:17 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: PROBLEM: io_uring hang causing uninterruptible sleep state on
 6.6.59
To: Keith Busch <kbusch@kernel.org>
Cc: Andrew Marshall <andrew@johnandrewmarshall.com>, io-uring@vger.kernel.org
References: <3d913aef-8c44-4f50-9bdf-7d9051b08941@app.fastmail.com>
 <cc8b92ba-2daa-49e3-abe6-39e7d79f213d@kernel.dk>
 <ZygO7O1Pm5lYbNkP@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZygO7O1Pm5lYbNkP@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/3/24 5:01 PM, Keith Busch wrote:
> On Sun, Nov 03, 2024 at 04:53:27PM -0700, Jens Axboe wrote:
>> On 11/3/24 4:47 PM, Andrew Marshall wrote:
>>> I identified f4ce3b5d26ce149e77e6b8e8f2058aa80e5b034e as the likely
>>> problematic commit simply by browsing git log. As indicated above;
>>> reverting that atop 6.6.59 results in success. Since it is passing on
>>> 6.11.6, I suspect there is some missing backport to 6.6.x, or some
>>> other semantic merge conflict. Unfortunately I do not have a compact,
>>> minimal reproducer, but can provide my large one (it is testing a
>>> larger build process in a VM) if needed?there are some additional
>>> details in the above-linked downstream bug report, though. I hope that
>>> having identified the problematic commit is enough for someone with
>>> more context to go off of. Happy to provide more information if
>>> needed.
>>
>> Don't worry about not having a reproducer, having the backport commit
>> pin pointed will do just fine. I'll take a look at this.
> 
> I think stable is missing:
> 
>   6b231248e97fc3 ("io_uring: consolidate overflow flushing")

I think you need to go back further than that, this one already
unconditionally holds ->uring_lock around overflow flushing...

-- 
Jens Axboe


