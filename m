Return-Path: <io-uring+bounces-853-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7C9B875114
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 14:58:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 546C41F244DA
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 13:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE3712BF12;
	Thu,  7 Mar 2024 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CFyqtnpT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CDD84FAF
	for <io-uring@vger.kernel.org>; Thu,  7 Mar 2024 13:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709819903; cv=none; b=PR8Z3ScDY0YnPvS5ZRW62F6NM0xUZOt5wCw/ak6cxbCfqGNZ5AqMlVz1R5b0vOqRudWZh93kYluWgyBXc3icr5RztFTWeePIe4gtxvFoUku2K24oW2ureM//tYOp2DaAUmNXSHkzFIP/qC12M2vNpeNiWMiis9qVuTDJWAucrf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709819903; c=relaxed/simple;
	bh=3/lZBqUM8rjPzLazSHa2T4IxQfhpCv1RUmHnpvpwz9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ng17QkobiaaAGXywLG8oFQmgUBSiRv3Jec3jtkol5PUD5u7PNutmNEnO1yb0YYwzGCNTzJ4qs+SqzoboO6x1GUS3ndDAkscpshSljxqKxOzqSV/dIlf0gKFONUmdXjXYvmuXFgyDZzSOxBdjDfAZo5PL0woNgZubM8WahJ4gmek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CFyqtnpT; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dc9d4a81eeso810305ad.0
        for <io-uring@vger.kernel.org>; Thu, 07 Mar 2024 05:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709819900; x=1710424700; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ypawj+asZOwfvObys4buQk7+81EAdVNvBP47YHvovic=;
        b=CFyqtnpTLkDQ6Q0ITRVes0ncwPCw6WjCVhAq5hxAWcKkbxCleoBpL7UjNfOSi/wlht
         uVfFWI8/5d1TO+bggU1Rw0deGLhOOQTsxFs2pA4BcQmIMxkoQ/Kl9nsOvthtYMGBzGOV
         65/TX+6GxhtJGb7T9+GizHHg8GgGLHtg5LKPmr7KbZ+TpRPOK394o3LN6O3nCOVpjdfk
         UoXrp/wthn5aPlDtmWN/akYiTOPL14vHx45qNJtA5CQgbINh2RKW19CpJyVxNZl8iBsF
         +XZUqpYKm2Y6TPZaDfopFsEL4lkqIpGHrn+wNwkwukQLmrdP8gGZHH4I7Zck7Ffkwhd2
         PvuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709819900; x=1710424700;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ypawj+asZOwfvObys4buQk7+81EAdVNvBP47YHvovic=;
        b=WhhLrWTcH5eJNRNKt7dP1tyTnE2FfRaR2CqPTlAXqjFRtjce34n5r3R8Hz1/9ILP27
         550ji072/FRaNr4Xtc6fpY7U/PSD/U75QVyuRekE8lNT0LO2NoxTcifeRv0u2bsoIhji
         FpjFYxhuSpVzpbM8YofxSg6gdi93sdLRsKoRgx6h/EdLsNmIimWg8hNJdB2552jFmVx9
         TUulkEkN2CDVf3SAdAPVIze5V3G4BdKo0gPLEPZAoXaXEEyhAWnmOGlUEbpWnbdiQgQ5
         jhtNbAyqe3pSlr2KHR3Eyl/DYdUIgPLVi36RvreOquSZsy69Hhc38YwR7ae/zQdm7DfT
         VZyw==
X-Forwarded-Encrypted: i=1; AJvYcCX3jPvD/2TlLCZth1cDmuTy7leYQEpfqw6rn3ZD3j98s7p4ezn+7kG2yBiTau+6cCfAAHMChosjbUIWFrnLtKeKh7iYJbTJS7A=
X-Gm-Message-State: AOJu0Yyhsdr8UaXshILwlex3Rct2WCFzd4AzMNCM8QI11KdzB4FDUaS+
	vMjoOGqR4sY8G+33WZ/Y4pzkS/oebQNMwvRhUp4S9nRk3dIrbfXghWNm3VvymSwXIgDeT5AD71c
	3
X-Google-Smtp-Source: AGHT+IGyjAxA+gvCsYWReugk/n2PzBsl8KRr+kmr47kru6YSFNY8vDKdIFwkIwQU++rT/GrjyYJTGg==
X-Received: by 2002:a05:6a20:849c:b0:1a1:4534:bc45 with SMTP id u28-20020a056a20849c00b001a14534bc45mr5620567pzd.6.1709819899660;
        Thu, 07 Mar 2024 05:58:19 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id e21-20020a17090ab39500b0029a8e7db800sm1547322pjr.52.2024.03.07.05.58.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Mar 2024 05:58:19 -0800 (PST)
Message-ID: <84c98157-611a-4735-8818-94bb7ed2c5c9@kernel.dk>
Date: Thu, 7 Mar 2024 06:58:18 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: fix mshot read defer taskrun cqe posting
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <6fb7cba6f5366da25f4d3eb95273f062309d97fa.1709740837.git.asml.silence@gmail.com>
 <faf44f4f-1aa4-4d72-9a32-8038a6554a9a@kernel.dk>
 <99b95279-f90e-41ad-99a3-c7bb0aab973e@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <99b95279-f90e-41ad-99a3-c7bb0aab973e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/7/24 6:47 AM, Pavel Begunkov wrote:
> On 3/7/24 13:33, Jens Axboe wrote:
>> On 3/6/24 9:02 AM, Pavel Begunkov wrote:
>>> We can't post CQEs from io-wq with DEFER_TASKRUN set, normal completions
>>> are handled but aux should be explicitly disallowed by opcode handlers.
>>
>> Looks good - but I can't help but think that it'd be nice to handle this
>> from io_wq_submit_work() instead, and take it out of the opcode
>> handlers themselves (like this one, and the recv/recvmsg part). That'd
>> put it in the slow path instead.
> 
> I have a follow up cleanup patch, but I like this idea even more

Excellent, looking forward to that :)

-- 
Jens Axboe



