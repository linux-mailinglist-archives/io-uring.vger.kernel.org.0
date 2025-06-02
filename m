Return-Path: <io-uring+bounces-8180-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ECF9ACACA6
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 12:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CEED1641DE
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 10:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F3171DED5C;
	Mon,  2 Jun 2025 10:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LDquWFAt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725BC1FF1A6
	for <io-uring@vger.kernel.org>; Mon,  2 Jun 2025 10:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748860640; cv=none; b=GXyLbyhulLUREb4e4wKTIURh+DVWT66aO7J9Y1R6/bw1YxTf/0/oxGF60hHk0hhWQiLKY7Kzolv2Bo3Pdbg42FrSylCHeNB2yxsR0PA2gCGo+TDjiJ8TZM5iscP1nISD85+UG8ON7NvXTD5hl+lFfpkCN6Stb+SLEX0GDZilHdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748860640; c=relaxed/simple;
	bh=qTGjlPqHoNurYybDaas4YrQaDXW5KxMrKqgKLPtnZms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FCEdq2mS/Jr2OehTbtKqzBH3QeTkHs6AdWFHeEuVGISpVHOIKYKUngkIM69o6XWQE+N1u8Ey45GC2PE1qHU4lRtvUwr5db4z5bTK/4CnuvxXUiODlv564Y/4ZkKDF5UhiaEnP5g0QxFY8UfDeIj4jgs79LaZFbIWfOW6Ni9vSx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LDquWFAt; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-adb47e0644dso342275466b.0
        for <io-uring@vger.kernel.org>; Mon, 02 Jun 2025 03:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748860636; x=1749465436; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pFY420lcXTluDNokxth8T/lwrYk+vp4SLjRwKp6NGA4=;
        b=LDquWFAtlYcBCspVhn4V0eDdx5Q1TQBqO2ltvmcSozV1h6xTfq/F0NCza4L5eaoza5
         95CBsToyX1fj1iw8sI8bJxc0cttmPIQI0b9c3UAdRKb5LgFu4dZyP3ctLAfR3Rc5tYMC
         I0xjtYIo1t+OhusZzdyA5lqJlkAM6PB9LMRltcNPDK6yr4cuE+iTS7M1TsNXIe/iLJJR
         rqStGNSwCaDTUxvm4diVRhZyGbk5DpHM2fEd0o/FutCzsrW1q4oiWvdArmpKqj4tZmFH
         wj1a444dmiVs9GF46QoOb7sj6wJNI+XtRPqfJufsuwDmE4tizRpSn0g3eJaKctweXC9f
         BLrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748860636; x=1749465436;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pFY420lcXTluDNokxth8T/lwrYk+vp4SLjRwKp6NGA4=;
        b=n/i9Zr8wz7GWAdJPfpnQKpwyzm6bYomNoQ4JoZ/C+8sdB3Fy2YlZsiee2KZk6f58z2
         urD+Ul1FeHWaFoqrvIKLqfrxL15Bi0r+Sz2rBulKHHQ8qovZ73AJJ5gPamHtYRi1N/uV
         LIt8YHCoalUBvWZ2ToyzknMsuBpXg9OlegIAaocQSMiU6/HDbcRSZt1aZZ5NPDmYoMVZ
         YsAJxdt4A/3Bq80XG41tWUksL73yz7Nezd4gX4dfMViQ5H4EguFP0B+JZTnFO7SO56Wk
         UFjt9ziN5ahLKrKDQBy4l0+4EkpSTK2jugZC62klXgq+vOzyUcXQcx4kPD1o+YpT/Gsk
         OtXA==
X-Gm-Message-State: AOJu0YypH+iiX7avxwozXC7K4wde0/mFNLliqLziAc9xTKyBiEP0wq8A
	E3Xm/7dvAiXgUdYwdC8U/t40XyC5HMiNKgDbz4BIa6S5JcsGVlWUs5YfSsTzgQ==
X-Gm-Gg: ASbGncscPgZpkPO7sp/oHOdJ1MBH2c71vpP8lKV2GDUegSr00aJDPvAQLpF+IkhexzP
	yl+Ye/TkdK3pwa/MA3Ptz7kFaOpKP0rzzQiFz6HY2dEtebfOkMPTRya3iMD5E9ShDb7qMLpi6or
	HqzNlL4GjQMyioOKFuIQgsn4ugnveqNDwzZQ2t5FU/iPGoz+0LuIpcmfdzmuF4LpM41p7w5F5Ek
	YKEJogaLWKlcXvOtf19Y6csMzV+BuMBWo1AWpM9SOQmHazPSOb3L/jefjxu1A4ELrPLQEbV6g5Y
	KpFeeOwM9LALbJsojYJQdUnsKmu9hQHhrcdDtp3T8CsNBBCmjNZ5VmDwLz4Bv7F5
X-Google-Smtp-Source: AGHT+IFtgYFYZQmcaUOiPxFZX1jOB5lNI3zY1zXUir//09T086rukgtsNmYF02bDuDFzzcxRMYiExg==
X-Received: by 2002:a17:907:3f0e:b0:ad8:9257:5723 with SMTP id a640c23a62f3a-adb3292295cmr1250303266b.8.1748860636038;
        Mon, 02 Jun 2025 03:37:16 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::26f? ([2620:10d:c092:600::1:8317])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad394b9sm783704966b.132.2025.06.02.03.37.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 03:37:15 -0700 (PDT)
Message-ID: <966108d8-1c22-432f-a70b-c76447c9e474@gmail.com>
Date: Mon, 2 Jun 2025 11:38:41 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] MAINTAINERS: remove myself from io_uring
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk
References: <814ec73b73323a8e1c87643d193a73f467fb191f.1748034476.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <814ec73b73323a8e1c87643d193a73f467fb191f.1748034476.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/25 23:37, Pavel Begunkov wrote:
> Disassociate my name from the project over disagreements on development
> practices.

I think the patch accidentally slipped through the cracks


> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   MAINTAINERS | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fa1e04e87d1d..692bf3671214 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12459,7 +12459,6 @@ F:	include/linux/iosys-map.h
>   
>   IO_URING
>   M:	Jens Axboe <axboe@kernel.dk>
> -M:	Pavel Begunkov <asml.silence@gmail.com>
>   L:	io-uring@vger.kernel.org
>   S:	Maintained
>   T:	git git://git.kernel.dk/linux-block

-- 
Pavel Begunkov


