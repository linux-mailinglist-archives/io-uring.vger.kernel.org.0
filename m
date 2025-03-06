Return-Path: <io-uring+bounces-6974-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E7AE0A549AC
	for <lists+io-uring@lfdr.de>; Thu,  6 Mar 2025 12:41:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD8B218993B7
	for <lists+io-uring@lfdr.de>; Thu,  6 Mar 2025 11:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9031120AF78;
	Thu,  6 Mar 2025 11:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="M5jvLfee"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7650D20AF85
	for <io-uring@vger.kernel.org>; Thu,  6 Mar 2025 11:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741260815; cv=none; b=KjbR+266ZCeatuMEdln7qtsiejU3VJN15owLLN+w3X9aFENDXJ2yQTzBnW9NDS91pyepjUT0zpklVQQpIrP/KhZ6Ez2ktJhuVMXZq2hfAIIG2f7QidsAUwMcK/5FXKAeVGA+Plw62sIvqERApPIxPfRDS18oh4ABA7ZfAnygKtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741260815; c=relaxed/simple;
	bh=jpJuJ7BdKXTi//Py4zishwVckod2X5rc6SNAPGR4Og4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=V0jmHa+Ws/I1y/m8wd3R1FhCZ8f48IC5FE2NTDsyAn+RzKwWrBMbkzIXypU8yCOnnpi2RAsjqY1Xi733BvyKESgUiIaYF1JqSklfTTFlNBJixJQt5NvHsX9Kv9dN0JrB5RWyI4sDoWJzs+CoIQkna8/4JBtR3NuycvDOpzmDA/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=M5jvLfee; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-854a682d2b6so33148239f.0
        for <io-uring@vger.kernel.org>; Thu, 06 Mar 2025 03:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741260811; x=1741865611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+q5KnvQ6y++/8ihQFMngwD7T1DJ6t22L9frlZ3s9cso=;
        b=M5jvLfeeFum9qqQ7ig99ws/UnLtf3Yv30KwbeBisog1gkr1cnbCc43YY51yFsONBme
         hYDdMc2BIFZL8yBjNyEqCtDvJaGJYhBb73UTkzydLcUKewcLL+7aKDtpiJvTnBHdLOrJ
         mYUeBCmGwV3M61ALUNbysh179oUrNKJefE/UoXX2qACjheeoXzpSbLAY9O50/U/FcM41
         bsOvv3JeUjk93MG7+M7cE4jiUJAyawAEUI4747N/JB+17uNKRHLVeuPS5lZGGxpd7AKP
         u3rL2adHcfJ5lW1RWIkdSIhm3JZ6/O11jKy5lCmIuuxr0AUItWuLdyzzMe5yA+xtDwhs
         qpbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741260811; x=1741865611;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+q5KnvQ6y++/8ihQFMngwD7T1DJ6t22L9frlZ3s9cso=;
        b=Njf/rfLXWNtK4yMJiXLuhp1NcZmaTJMiwR4PfxY23bqgO+fR3FEZnM4IYkaT3gTdG7
         Ls0cnYzOAWVst2dlOEUgwUNhXQWPc6jWNvfT11co2cdHh8SHOEOyUN6AcH9Ah70VqbVm
         jOe1P7e4FHYDWsB1P2gg+lD8cMwVQUdFizch8nMXQDQ9zNvoC//my9MHMSobLvW41ilS
         pnibQMleUigfm9E8hHND7ilMfOcxLXGTo5Fox8W+mGn6PpGH6vcBwUqPqczer/uXNMYG
         /rZWq5ZZxCXldzUrbTS+RQNCHpZXX0Q5wcJjuvhG7gKNsYepjGZv+DeM2YyuPGuxsEyQ
         vH8Q==
X-Forwarded-Encrypted: i=1; AJvYcCW/+X01cTRsPqU/ylq1ZXDnyh6MTwABZ2cLOnWvqiDnjhUr8LRyvJQ6Soo5Mje2NAttiScGEXqtcg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwEcixZYDEVTu1YA+obNMqcuK5INGIL3zRUi11vI83zbTgMf8OJ
	mIvSzK0w/DW7VMiBgfjUE3+z2lTsSokxVuP/U/w7REHLK25KTpDTfNnGR/CLJLQ=
X-Gm-Gg: ASbGncsfy/dp18T8JtAzk2PBDvrbnVK98+MJcHtQ1ZPo24/6FkwkD+PUGBD8P+2xXQx
	VCUSpg2EA3js2M5INnOD74MXUHJ+WmfxOhbCSrW4jjm+BxCVNaBw2W3sdld32Fvv5W/eSY1YT2t
	FL0xBkOmz1wnyLV/4hS94P+8Mc1Okqe6kB1BJznslF/OJXRoEeFQbB6AXkvAMXvUIpXh00xwrq6
	1ZkPUpzOiZwCSTtrk3npH4ZeyqbRgB9S/JfBnCjaftENbpPE8z1qjqws4DWhT3ZfOtmyVH5G+0p
	aPuZuKsPkluF7vWmFswrBWTzKNmIQa3u/I4L8rstQQ==
X-Google-Smtp-Source: AGHT+IEnA3p3k5WeCD9avky4OCKyX7RLbxCqTYIv4bgDcqVHxHvBJcHiv2bQUpVfeB4VgjGDZ+3vXw==
X-Received: by 2002:a05:6602:3e81:b0:85a:f86e:fb1 with SMTP id ca18e2360f4ac-85aff876380mr1003900739f.3.1741260811472;
        Thu, 06 Mar 2025 03:33:31 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85b119cfe71sm21535439f.23.2025.03.06.03.33.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 03:33:30 -0800 (PST)
Message-ID: <f8389fda-ca5d-46ec-adce-66793f386605@kernel.dk>
Date: Thu, 6 Mar 2025 04:33:30 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rw: ensure reissue path is correctly handled for
 IOPOLL
To: John Garry <john.g.garry@oracle.com>, io-uring <io-uring@vger.kernel.org>
References: <92b0a330-4782-45e9-8de7-3b90a94208c2@kernel.dk>
 <c57d06f8-b9b7-48f8-bb8d-05e2c40ef254@oracle.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c57d06f8-b9b7-48f8-bb8d-05e2c40ef254@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/6/25 3:12 AM, John Garry wrote:
> On 05/03/2025 21:06, Jens Axboe wrote:
>> The IOPOLL path posts CQEs when the io_kiocb is marked as completed,
>> so it cannot rely on the usual retry that non-IOPOLL requests do for
>> read/write requests.
>>
>> If -EAGAIN is received and the request should be retried, go through
>> the normal completion path and let the normal flush logic catch it and
>> reissue it, like what is done for !IOPOLL reads or writes.
>>
>> Fixes: d803d123948f ("io_uring/rw: handle -EAGAIN retry at IO completion time")
>> Reported-by: John Garry<john.g.garry@oracle.com>
>> Link:https://urldefense.com/v3/__https://lore.kernel.org/io- uring/2b43ccfa-644d-4a09-8f8f-39ad71810f41@oracle.com/__;!! ACWV5N9M2RV99hQ!J4rCZomS7jntxigOWFGkQC3hFMb5EZf3-aZG4hZCB6n_quTKHse9g- WSxf46gMXpEfyzjaAQKTff2J9o0pg$ Signed-off-by: Jens Axboe<axboe@kernel.dk>
> 
> This solves the issue which I was seeing, so:
> 
> Tested-by: John Garry <john.g.garry@oracle.com>

Great, thanks for testing!

-- 
Jens Axboe


