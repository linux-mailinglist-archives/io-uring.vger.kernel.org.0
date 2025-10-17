Return-Path: <io-uring+bounces-10048-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07481BE89BA
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 14:36:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC1446272E7
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 12:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA9F2DC328;
	Fri, 17 Oct 2025 12:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gqb93swk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371952D641D
	for <io-uring@vger.kernel.org>; Fri, 17 Oct 2025 12:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760704564; cv=none; b=ATH94VJQHYoDuKUxsrke99Kf+v1DD+lUyMkuQHBy8BRcI0xr4h7FS0EAgzjpZ8WX9dIwjWkefyvvOxhr9FLsLoXf2ctBB1ZNpEJ95T38UVPFMpBrqwzemBlibtnfqBgAitR/rQkJ5k4x7pGpoxg5TDJaT7HxXP1KmPY3o+awZ8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760704564; c=relaxed/simple;
	bh=Hw1aO9jDvxq8JhLY4Z0Pv1IVk4UFy+G5IqFSLcdjKIY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OvEyboAk9pEworuDZUgWArWI/r97vke1fkDDQiZCtdoglsoN3vyExtBacVOEgj+0XdIXbc3/fjEz/YTdv5OA1lzKh6MkYYO04wFYmjRXiGGfYiP7qmwnEnh19zNEdrcH8vAZ+WwZnyxYiJY3VTPElVXGEWIIE59Ccepx7Anu1yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gqb93swk; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4711b95226dso5861825e9.0
        for <io-uring@vger.kernel.org>; Fri, 17 Oct 2025 05:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760704562; x=1761309362; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mMHvAkdNpCY5aCq1LhxmVwY+O9OU3TEnHfTGvltmJBc=;
        b=gqb93swkS/FqBqkZEEecFmt9yYVeNfO5uxkutyOH9gChVGvQGh6pMiytuF3Vr8uvls
         6DEnFPeOXnrN40igMZRSqtL9k9L556uIJ/GS2EAc8v3+eEXVfXl/a7btKJb1YrMHV4o/
         +TqKM0KMkRj0bl84vjbJM+rSlbgQnNypK/4r/toUS/oOtmpCSs/TXl54DedG0XIqGa4n
         bJ0KgapQbERKWuJCnxmPyInDSa9Yn2kxascT0bnEAn+Dleb80l2R0CbFUnkgxwK8tMDy
         K9J6smaIOdkihnc0hmXbTnvMG84UuM4YM88N8tFZYgbiVkIQjhuhzP5JQRRZDDWK3Upu
         xhWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760704562; x=1761309362;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mMHvAkdNpCY5aCq1LhxmVwY+O9OU3TEnHfTGvltmJBc=;
        b=duoSs98zgP+5tGIB3BO5Ge3fecp1aSrwprgnfG1t+OZHuqaiiBUDeoWD+LFhqjGKY7
         IbGyWVBZOnOHdXwMNrA9CL93zdsTlfXe5/HtMHk4PYA7gMeGIUT5aUkES6ogQRVksOrw
         XG8YcTRaZfMS4i6uhgJ6zPK7psyfzv4khc/f7PlwdY17e8VlnRzca/9A67BYKAbrvOlY
         78/ks7k7XIkiWkLSkPf0eBddP9yiXqfAIGSFCEJxDy6blbZAwN54Ip1hNh1UTXwD7eee
         hJB4gZiZBNWd8ecBi3cDJFVRrOhreNgwNeKPytsi2VK87Ntf7IhSNHzeQMTh7WzqJPxn
         4sBA==
X-Forwarded-Encrypted: i=1; AJvYcCVk0YVLM+C71TbIKmpG7PyM6e6CmjA0Nfbq8DWbRiNshu6oV/8YBmtQMvEFbk8DSeS43XVl3RkYpQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8G+91kzG9x5G9uI6i6AElvULVC2fRwg+MssIBFEXVMirdcL+u
	nbAtYWfGMP3gMkB0ZN+DaC+9T0tLHyGl61lfMplvrKq7ic0aFaiYJZDR
X-Gm-Gg: ASbGncuihX7kRZYvQ23obEH4w3J3w5iEmo0Ya83Bd2EZb+Fit9gcyE9/fGx/YT/nthE
	D5PSg+1bCBhSned2xMKyfFxzl4QNpPVwO+2P3SdG/Pqi74QfkT+Dt1soGg24ic1qrTirDixsK5m
	iMCHBknHBYLp5XqhQcaVjm9/Iu7ddo0QZ2PZyYcdHxl37SgkfIHQUHtsSYvRpZBoYVE8Q9MsDY4
	+f6QAxkXja3EFUvsBaZQywk+XL4zHXQRpImyAXNYwODSWbvVLr5E2G1CyW75Rh96fNnrrO1zbaq
	ZI3KlfA6X3+VCDM4I8dv7Sja+Hd7E1/3OvmozltR25yYmR4BDPY71jgqXOYVP9gE+nIpijcUKyd
	V0kNLtnYztQGyHALgv2pU6iIDhppAlhMZ4f+PqSEKl9iFGmVLND2ALelgAp0HM4B2yDZFOW3IS1
	d1E7VGibvfdU1Bdka8XDl/C1IBn3/DEVfp
X-Google-Smtp-Source: AGHT+IF95AlIBrdcr0LHd4Wj35e/tPXJEutqE9ruUscgmXuvAZY0oky+qe3Ds8aAN+J3IZTC6XS8cg==
X-Received: by 2002:a05:600c:3b8d:b0:45d:f81d:eae7 with SMTP id 5b1f17b1804b1-471179176b9mr33261665e9.28.1760704561423;
        Fri, 17 Oct 2025 05:36:01 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:e18a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144b5d48sm82004275e9.9.2025.10.17.05.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 05:36:00 -0700 (PDT)
Message-ID: <64a4c560-1f81-49da-8421-7bf64bb367a0@gmail.com>
Date: Fri, 17 Oct 2025 13:37:24 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: move zcrx into a separate branch
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <989528e611b51d71fb712691ebfb76d2059ba561.1755461246.git.asml.silence@gmail.com>
 <175571404643.442349.8062239826788948822.b4-ty@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <175571404643.442349.8062239826788948822.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/25 19:20, Jens Axboe wrote:
> 
> On Sun, 17 Aug 2025 23:43:14 +0100, Pavel Begunkov wrote:
>> Keep zcrx next changes in a separate branch. It was more productive this
>> way past month and will simplify the workflow for already lined up
>> changes requiring cross tree patches, specifically netdev. The current
>> changes can still target the generic io_uring tree as there are no
>> strong reasons to keep it separate. It'll also be using the io_uring
>> mailing list.
>>
>> [...]
> 
> Applied, thanks!

Did it get dropped in the end? For some reason I can't find it.

> 
> [1/1] io_uring: move zcrx into a separate branch
>        commit: 6d136abdd1bdfce0c7108c8e0af6fd95e3d353ad
> 
> Best regards,

-- 
Pavel Begunkov


