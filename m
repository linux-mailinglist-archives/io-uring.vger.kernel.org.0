Return-Path: <io-uring+bounces-10666-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CE9BC7106C
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 21:22:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id D61FF296BE
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 20:22:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7850E32039E;
	Wed, 19 Nov 2025 20:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="G4Wk9cw7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA36130FC19
	for <io-uring@vger.kernel.org>; Wed, 19 Nov 2025 20:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763583770; cv=none; b=bGG7FmIOjSXNrTCNTc8w15R5igFWTxIlt8HTiQsMHayo33o41JkstyKqz2YLxQZsrjVPfOuwyHLu0rak7bbAiCYD5IkXC1zjteC4u9R48TZOYZ0k3umo+frOxZgGFZthJzmeh8MLPK9Hw9Gh14a+6CercuhIrdHS0qybQrA2wgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763583770; c=relaxed/simple;
	bh=M9+x8+hQNC7Wd3ZDtpRdjtYM3uD7Ft+L2zSKNevifpQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bCdG4/iVakOmNFZashQPYwWn81MncDivjGylFvcCi40qoNGD94umzam/7VAbFFUHRm0POsn2dKBIVRC0j0/Kx2rw6lwlzGiOyQ4stalZR1X2aVmhJsV4TEokGSGMPYm+qJ5kW4Q7dE+8cEF6cBAjRMjVaq8LGKMPKF6VK81KZQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=G4Wk9cw7; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-9486251090eso4906539f.2
        for <io-uring@vger.kernel.org>; Wed, 19 Nov 2025 12:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763583766; x=1764188566; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0gBqn+A17GqBlojnXnmlIq9IFdstwg3lrXajrvRFr8M=;
        b=G4Wk9cw7KvmMC5ktSOeBKIpjBWaziAIpj0OZ13YIjAyyH2nl1XmmihGJ2NheuTAWZY
         9JywMpJYZLal5pC32nxiGdspYvXg1GE/UpGSQ5qRYEtZog5Vfx9X7KROyVbcAk75DLgz
         sHOftvf6rIargL05TLTL5qWRKecOU86s02w5k2d9V2GXrePr0Se6BchpX4A0TXupGQLx
         oMup7+7qI5yxLb7av7jNmM6YTJ8ErXYo7UWvfpDNYtfrkpE3qRPCvEMpq5EF9ojtPgLO
         MAlULdx8zkQMCGYoJKjzVeBQ2WXoqJXdZRM2cQ7EqjCNlwEsvl5bNy0iB/We3kmmhy/u
         J93A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763583766; x=1764188566;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0gBqn+A17GqBlojnXnmlIq9IFdstwg3lrXajrvRFr8M=;
        b=dyHb4iMNHJ2AZt9UahCyiBPHMSQbNyYVoy8nINy+XZCyZ9GSt/+38Yks7U/4RbyyZH
         teyfvfUh1AMeYYF+eXLIIc9I+QcvpwjYF/u4MFW1YB56tuAzfK5pN0epulx0J3hf8OY8
         jruxHI5jEcjBbhfAaxJs/+6rf0pcnYGYJExL/PFb4SdHUN6H+0Yqyg+Pp83n4wVSrh2p
         fzeMT14VAifHQNdvwwyHm5grtOVU7SlTKRh8vzRQ/07NPO0losI8v2NwtkzqiFwvr3tA
         tUyemtjxOUD+HCrm7MfoxOXeLwrFkhCBfIS2UypMgoPhAF3ZI7q5+Lf4Mg0+fIMX44Zg
         bK0A==
X-Forwarded-Encrypted: i=1; AJvYcCWS5XE6UMo3jDytkQsRTx+SRzRVOqZamv1Q7+L/Ley2LxyI7Pcn97Nmn8I9qNBtXzCFRyWF+soXbA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8kcO6Meyo33Nl+Io7JX6ef0HJZRdyPuMDlKC5WKeq1ik+4FUo
	fiZJAifsg3/8sB9zl9fIdMlED1J9b/bQ+s1jupte/tWstpWuZxaX6/GlPILMAnwBpKhfUNSQw7l
	tNWZ9
X-Gm-Gg: ASbGnctWxDeoFjmLnrr6OA09zYsk89ijZtAIT1jdRN5VlWOLTAvVS2VOMMNyXMxle43
	3ZKQpDJw0dk1DiH5YBEtHv14BvBikyTWFnXh1dllqhRvs0vJHev5RQLPnUYXpJXorw39LiKiVps
	U28nqcyLDO1PsfgSSuzjAQ7KiCI3MXa3dF2zZ0/Xz1T4TbfGgmaKAO6cOhH9gOtMuxRkKUrfMRb
	bifoBo3T9plvKNG3eGji2VHum3uc5jB1EY6L/hHptUqtKzlgIVfnrtiOHH7ESSrq7AVg+lMQMcd
	r/RJuTEtY54ciCxSXHioTc0XQbshj/Dqe7b5AbE9Ym0zIRjeXv+mbRGo9iKR575bE0gd/j3tjxZ
	QmP/0EwQDO3wIrf/Ts4+zRsK2pnLwIsKSs0i/E9/8XLYg/idg90jjHtbtQK3Ja4s/zbqokgqSW7
	0+pnXspJW5kvI1MhSSEQ==
X-Google-Smtp-Source: AGHT+IGbvqxNYkc0JkikGMUMPW7dk6s2v5tFPpSI1I8G8MYcAdObik/XpHGk+tUtymtqnRHinwVTaA==
X-Received: by 2002:a05:6638:4485:b0:5b7:d710:6627 with SMTP id 8926c6da1cb9f-5b955e23bcemr1211173.22.1763583765983;
        Wed, 19 Nov 2025 12:22:45 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b954b48efcsm99254173.47.2025.11.19.12.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Nov 2025 12:22:45 -0800 (PST)
Message-ID: <335af53b-034e-4403-b5e9-5dab46064a1e@kernel.dk>
Date: Wed, 19 Nov 2025 13:22:44 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/register: use correct location for
 io_rings_layout
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <64459921-de76-4e5c-8f2b-52e63461d3d4@kernel.dk>
 <7febd726-8744-4d3a-a282-86215d34892f@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7febd726-8744-4d3a-a282-86215d34892f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/25 10:18 AM, Pavel Begunkov wrote:
> On 11/19/25 02:36, Jens Axboe wrote:
>> A previous consolidated the ring size etc calculations into
>> io_prepare_config(), but missed updating io_register_resize_rings()
>> correctly to use the calculated values. As a result, it ended up using
>> on-stack uninitialized values, and hence either failed validating the
>> size correctly, or just failed resizing because the sizes were random.
>>
>> This caused failures in the liburing regression tests:
> 
> That made me wonder how it could possibly pass tests for me. I even
> made sure it was reaching the final return. Turns out the layout was
> 0 initialised, region creation fails with -EINVAL, and then the
> resizing test just silently skips sub-cases. It'd be great to have
> a "not supported, skip" message.

Looks like the test runs into -EINVAL, then tries the DEFER case,
and then doesn't check for SKIP for that. And then it returns
success. I've added a commit for that now, so it'll return 77/SKIP
if it does skip.

I try to avoid having tests be verbose, unless they fail. Otherwise
it's easy to lose information you actually want in the noise. But
it certainly should return T_EXIT_SKIP, when it skips!

-- 
Jens Axboe


