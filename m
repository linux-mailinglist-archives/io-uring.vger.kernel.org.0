Return-Path: <io-uring+bounces-2387-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72F1091C7EF
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 23:14:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A25511C210AF
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 21:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 271DC7F7C6;
	Fri, 28 Jun 2024 21:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vab+LJqV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33937D3E4
	for <io-uring@vger.kernel.org>; Fri, 28 Jun 2024 21:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719609233; cv=none; b=Xt/9NFtqzJfTWFORA00J5JBVX4/atpHrod9/V9CjpRTW+1L2umPZXn/JJ5/xkXUcMT86FTP+z22mfZvhVZPjZ6/mi7+gq5tks3KLBNHT0C0Hp8LAbHdyAZ+gg4vDH7UvY0j/IIKN11ZUxv7lHbmisLKBq+XmvX4THjHAXHHTklI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719609233; c=relaxed/simple;
	bh=zV4pkETVos7mygeCy7sHp//PwV6id82xYtw1zyuxhy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mPpRkmuCnRA0mN34EBuywcALoVwS+wDlxwR2KYnzOOPHm57u/G/F1RzdDrBxbX+bX6gy+N5A31GV9PnIFFzzTK+GCQ2iBliAU3RqtuvWWMRnQAibQ8y8f8tBNG3Obdn1XW1ifLN+faN2xZPTLajHNMCEXt9UwDsJLnjdccygDVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vab+LJqV; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-25d0f8d79ebso169308fac.0
        for <io-uring@vger.kernel.org>; Fri, 28 Jun 2024 14:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719609230; x=1720214030; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1opPjfxzRNYhaFc4zfC4K05/aDcuAuAsxn2PwxmqbCY=;
        b=vab+LJqVL0piUZTEy/QtPqRxb9I1OgDJH5YuBzdNwZpYCHWr9fe39fHQX8kvz0SaVA
         mDaCUNBgELmR8e5usODWyCTkhO3AQt4Z+fTDrMqWaaep3rOUfpjK+uMDQMq1oMZbCkgq
         panc7ZMC22HtN7jxW9NvNNmrHH3XO6k9xamukBd+ZJPhQh7YIecAzVSlQFbU015Hz7nZ
         u1l+55j6okJX/KnbW/vnPEWhBl51gxyVPLkYD40eIxbuz6uOHMzHxT+AZf9kegDlVV9A
         MTPbRgpzxwVmrXf9Qhhl2DhSH0rMk/hSBg4Mk2p1COt6HO/42FQljFaJlYQqH7V3BJY5
         9myA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719609230; x=1720214030;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1opPjfxzRNYhaFc4zfC4K05/aDcuAuAsxn2PwxmqbCY=;
        b=rnqVVRvX9dvkq67hr0NY4aZjnqTJXB4izGJkqIDffqiYtlINDnLQo/avWIq6OlFzwY
         NrT873E+12FUpEKmeoW/SHg6xdLDA9uRSqaXQQn7iPjVm2g0LvSBeHz2IyrfP1znkKXU
         E6YL2MGT56gpcuaipd4B2pL1lHGqim7Yy/mKM5hVVBA6t0mI6t77Y6XJu/N/vqttOepo
         HinLQebpsT5Hz5YX3Cm5xXctT643IGgUGxKMuEOC+/yiosG0UwlJG8wo7qRdb0g1/zwx
         oLPbg9ptkIHxuZZsBlXJ9EbVPxThc9D+gfFrBJ1XZHT/KfKh/czKTYdQumS5t2Vn2snL
         1FkA==
X-Forwarded-Encrypted: i=1; AJvYcCVHgdHfuDgtskSSptK5QIEI408MHjGFdE/Qj733HsHHnhrtVNnMgqyn1UCWcQE8VUHyG9ztznK0/iJZOJ+27fyNfC1YUuG9bLM=
X-Gm-Message-State: AOJu0YxMla4HesjfAdjzono/1Pkbxlk64+dhj52rW3V4H4sFYVAc/yql
	9pIIg4g7wWkeiU86irCdxmgHdyp+6KyPZJFD+wGyA+T10QxkfOb8/V1JqOXdij5nZ9VIfpR3rpw
	YvpY=
X-Google-Smtp-Source: AGHT+IFwkXoIYVW6y9Jw9T61bn2Du3Gw2/Q6w11UWmyKNcE/MNML+HaT91WINndiaX/L39S3nfQPaQ==
X-Received: by 2002:a05:6870:17a8:b0:254:7dbe:1b89 with SMTP id 586e51a60fabf-25cf3c23288mr20593998fac.1.1719609229804;
        Fri, 28 Jun 2024 14:13:49 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-25d8e33729bsm599135fac.39.2024.06.28.14.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jun 2024 14:13:49 -0700 (PDT)
Message-ID: <75791526-98d4-4750-8775-9c6ddfea07eb@kernel.dk>
Date: Fri, 28 Jun 2024 15:13:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] Subject: io_uring: releasing CPU resources when
 polling
To: hexue <xue01.he@samsung.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <5146c97b-912e-41e3-bea9-547b0881707a@kernel.dk>
 <CGME20240625083927epcas5p4b9d4887854da457946504e98f104e3c2@epcas5p4.samsung.com>
 <20240625083921.2579716-1-xue01.he@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240625083921.2579716-1-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/24 2:39 AM, hexue wrote:
> On 6/19/24 15:51, Jens Axboe wrote:
>> On 6/19/24 08:18, hexue wrote:
>>
>> While I do suspect there are cases where hybrid polling will be more
>> efficient, not sure there are many of them. And you're most likely
>> better off just doing IRQ driven IO at that point? Particularly with the
>> fairly substantial overhead of maintaining the data you need, and time
>> querying.
> 
> I rebuilt the test cases based on your information, that is, each drive has
> only one thread with high pressure, there is a significant performance loss.
> I previously provided test data for a single drive with multi-threaded, which
> can achieve performance stable and CPU savings.
> 
> Thanks for your data, I will reduce the cost of each IO and submit the next
> version.

Sounds good, thanks. I don't doubt it's useful for some cases as-is, but
I think there's the potential for it to be more useful.

-- 
Jens Axboe


