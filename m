Return-Path: <io-uring+bounces-7521-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C5585A91F15
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 16:06:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3849C19E695A
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 14:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 926D222A1CB;
	Thu, 17 Apr 2025 14:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YeiCT1US"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982D715A8
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 14:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744898756; cv=none; b=kX+83B1kWBr+kk/a1x7W/W8MNhxIMDBnx3fPrtEeg3L3aw9iwcrF0O15UdfD/3yzGm9nRHk+RwhYHfp9vepbksR5UQYenc5bUFMI4M9eBa652WLimSmtlWxsEq5jDsTuqMqWLkYINjN9ZZom+ueRn21sHqzeRoaVy6UXBxVNRa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744898756; c=relaxed/simple;
	bh=rQuH3kiytCIdCkQQLu6fGQfDMkeA+aTYWGxZqI6KbHk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=THRneUsMs4KmEUFOF5uAcuhL1x33vPqA9fpK3HjC69VF19rVa/+cWMqlUB9X9D6v7EXvEK/YGB5IkaPqK3dWWqDauQSG6+x03qu4D8o95hZVT9O923nRfOr83A57+7X8TWTTZOMulqAbVoGmCnI+W9/9bI92cl/775ldDrpfw30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YeiCT1US; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-85b43b60b6bso24322739f.0
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 07:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744898750; x=1745503550; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qIjewrVkl0xqvS85fNuGSkGDg650bk18SldcIxmH+ik=;
        b=YeiCT1USmFXNhM/M8buT8RE7Fi1sbh1dzPNoUg7/2eiKsQAlYe7v0G91+i1FvGdWxZ
         ciNySvQWe7NB58Nw5e3hCsRe7vCmnLICEh+O8rtkA9VgK2/mWFJlQfmoyffaeqkwXSF+
         PzZIA3OAtsrhZET0XKpMaukkDA5LdAo1pQ+7htBRUKFLBsL6QkYPSjuRFPJtnBdA31YP
         meoFxm3C9Ibp5uB0S48cOrOqS4L16mP6/jK5Zh5Px4+YsspchLH2mkDK5CZSv16eX8BU
         rwWdxed7ymSMUrYVsrQWYqRkdaRfHvVkRMww9qejUUzTM1O3e/Zw7x8VXdxrXhGdndB+
         hSjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744898750; x=1745503550;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qIjewrVkl0xqvS85fNuGSkGDg650bk18SldcIxmH+ik=;
        b=boEoKuSnlDknm+WIbIc/z10ijsfVK2hYeQlOBShnD0VKdvN0Z+XUTCzVV+ynxD6cwt
         K+u8UzEk8IASVm75yD9ySKhcslitCpX87AYCW3aTdS4rQFwaqH+81TOhBsu/sM3wHnOM
         16wQq01aotGV2DQd4FKjZqDq9WhpkqK1ftBLPgLR8Lyjzam2dr9NhfEe6hJzz/Ygs6uq
         23QblWpth+vsXZeIF+0/eLqFIQGjBGPa5ysS6Ymv1PnXYuFsPQKZ5r9G/CZkDmQ3YUSq
         XQNKnkZnrf0OpEu8LFzcdmPSNG7swh/Lv6k6e0iEoke/Ix+tn/3s46dglSAAque+imaS
         GYJw==
X-Gm-Message-State: AOJu0YyweZiSz6j5wCRBhYapkmO96BTvveyhYpw2WBG6uY8N6vpce4eH
	uU2EZxj0NeoxNNuJJR2B2QCLMhyzqAM+H2eDxFOEenx+pK+TFN+X0q9c8bpwqcQu070yIPzY3Dy
	S
X-Gm-Gg: ASbGncuOygZVXtzv2gYAHUZC/YBczlPhZg28bL/n43ExvNW8ksMdNfeaMGAcjVBSA/c
	ImwnHqRKtD1Ympk6meoVJYZQPMxVLMR7McT4xRpdZn3Nuz5I4rZmMPcX/u6+6EM+cPIUuZ9AJxl
	P/02iMSEcEDauP2Rh5F/LqkDG5XQjLBehf88PIvn26q8Z/heLL0uTYgdmylaA9SqOjTf6r0T60q
	HJ5/EEu5j3H28F2k5kGbArnErG+DCkLRShjvkalE1Zw4p8OZCXu33IYPU7IrzsDYn8ySzuBMihF
	YNEtM8e0JaWRxHwIT1vMQpqC/e2c7BXnjd0qsw==
X-Google-Smtp-Source: AGHT+IELhAIWQIcHuSUPIBXP0UlReqxdY4WO6unPV1aSP0+O5zTLB84MeqsuDqw4Mu7cQT6Utevq1A==
X-Received: by 2002:a5e:9705:0:b0:85e:dbe3:137f with SMTP id ca18e2360f4ac-861d86f97e1mr3561339f.0.1744898750688;
        Thu, 17 Apr 2025 07:05:50 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505cf81bcsm4095521173.10.2025.04.17.07.05.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 07:05:50 -0700 (PDT)
Message-ID: <b79ce02d-3bb9-4de2-815d-b4ca35aa6832@kernel.dk>
Date: Thu, 17 Apr 2025 08:05:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring/rsrc: send exact nr_segs for fixed buffer
To: Pavel Begunkov <asml.silence@gmail.com>,
 Nitesh Shetty <nj.shetty@samsung.com>
Cc: io-uring@vger.kernel.org
References: <cover.1744882081.git.asml.silence@gmail.com>
 <7a1a49a8d053bd617c244291d63dbfbc07afde36.1744882081.git.asml.silence@gmail.com>
 <d699cc5b-acc9-4e47-90a4-2a36dc047dc5@gmail.com>
 <CGME20250417103133epcas5p32c1e004e7f8a5135c4c7e3662b087470@epcas5p3.samsung.com>
 <20250417102307.y2f6ac2cfw5uxfpk@ubuntu>
 <20250417115016.d7kw4gch7mig6bje@ubuntu>
 <ca357dbb-cc51-487c-919e-c71d3856f915@gmail.com>
 <603628d3-78ec-47a3-804a-ee6dc93639fd@kernel.dk>
 <f8e4d7d9-fb06-4a1b-9cba-0a42982bce48@kernel.dk>
 <167282a3-7b78-4692-8e8e-261a964b3556@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <167282a3-7b78-4692-8e8e-261a964b3556@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/17/25 8:02 AM, Pavel Begunkov wrote:
> On 4/17/25 14:57, Jens Axboe wrote:
>> On 4/17/25 7:41 AM, Jens Axboe wrote:
>>> I'll turn the test case into something we can add to liburing, and fold
>>> in that change.
>>
>> Here's what I tested, fwiw, and it reliably blows up pre the fixup. I'll
>> turn it into a normal test case, and then folks can add more invariants
>> to this one if they wish.
> 
> Awesome, thanks!

Done:

https://git.kernel.dk/cgit/liburing/commit/?id=d700f83631a780182c3a3f1315e926d5547acedb

-- 
Jens Axboe


