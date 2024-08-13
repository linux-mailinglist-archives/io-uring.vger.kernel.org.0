Return-Path: <io-uring+bounces-2756-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA308950F40
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 23:45:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 057221C21EA9
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 21:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E25198A2F;
	Tue, 13 Aug 2024 21:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tolv8h94"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB831E498
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 21:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723585529; cv=none; b=kHe4kOrckArT5CWHRUV3zNxxMVrcDEy1TI5zxtsP5foCzdyoXTmrvnRW+yQA0lFgkyeQM7T5YSKh2AC8/IKgE/9UrANIVSqDOWcIpIcaxIg4zgygVtNAx2RI/FDUqdC0MaaKmLBSPPNykj1yWQlq6VwESr/yURkI2Abd1/sLOAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723585529; c=relaxed/simple;
	bh=ZPSed74eIxvtsiZxQ1cHvk5tof6hAO7AlAbhl9FUw2A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=coOMS40Z84wegGHHwUE63PjXpUvKanx3PtieX897R0KsYJQU6X4xnzeD0vuagNFl94rCqwSagS4zKYjoRFX1+R1e6p9y0KFBGK7lD/JE0AdN4SzdRKAxz4S+XWaKtdOs1n/dfXh7PGafDPfIH2AFSMeb0vyjHdgUcNrX/VxvRCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tolv8h94; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7c3d415f85eso2381a12.0
        for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 14:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723585526; x=1724190326; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eFmOBK+KHjdqqXEAyv3wDgbDNcnein+cwz+yHJTrexg=;
        b=tolv8h94nUarQzTaavV3bo3wRUg+Dnelo6sX2Sz5srL7yU9d99yWMfTHE26fUo09nb
         BPeLblsAsCEnf2xo5nin1awrJ6xsAajoShiw2SmqJh/RD7BwMi7+Q9yNRqS5uOLuzBxF
         UpMOuQu5KvMHvEI99h15cy8ccGzfwM/cuv8yVdGt9hbIm3D5ak9zQibXVt/ZdSJl4N2I
         wSyT+FAaKBAhEJHmjYYasqUfTGeqmo1Rb9nftR5cKFhJ0URw5pjwT2oOqFYq+dy6kyRk
         IQ4vEyoYxsdnfY5NWL3iR3qakarvlm23wWl/UCSOrM7V5wiCXsB0xGGFAwcbBcku253a
         JQBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723585526; x=1724190326;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eFmOBK+KHjdqqXEAyv3wDgbDNcnein+cwz+yHJTrexg=;
        b=FjxIukzL8F0/x/7dDSXydY2tU/7lebmRKoJZvdWb7uWL0J0ZqnHmbXK/t330RXPtdZ
         DWIkbMJkRTUnAeXRBdtd6Y9ryzRxHWlMeIZN3GVqhS8xzfFMoFTmCci5TWdZSjQ51ax0
         Km7Lv/zCZ/+4pBejnG47T8rkhakg6dzr3FKzMT027u3XVVdKq6YllXYqRc29gNZky+pf
         d2s/gQzCLq/vp+MrCdeSdwWZSL8w5gUdEP/aMTHsQRIQ5trCjzw0Kfb4VMYvVLJ/dwGO
         HrQ5K+V5l+QH9ls2QaTuilvO2RYXDCNtbyLBhX6bUdmFRRquC9Jsdmm2Z8+AMdshDwXp
         dK2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVtZLgJppdsA/Eg/pPiz+ncgpJf+Kr0jgGajb3gfm5W7SP1TvfpQ8wiWMoVawJrxxFA+QFH7Sgr0LZ2hd5f7gAUImzg7KqSn+I=
X-Gm-Message-State: AOJu0Yx9Q3NpcBEZYmIrqhoBVxiq5S6hyq8ISVjnKl6gfy8YxFcyJlNv
	ch4KXnsQeIRSbAmJFWAEHQhVK6URz6AaSCigN+Q50f7OqVQBmwHp3wvmJNI+7uU=
X-Google-Smtp-Source: AGHT+IH3gENS5X9E75U+qK1Is8Dqs/1qtfmQC6C3PEJ6RiDjXm5PizoXUsJYUguW7ijuvhYXaISzWQ==
X-Received: by 2002:a05:6a20:6a28:b0:1c6:bed1:bbd0 with SMTP id adf61e73a8af0-1c8ead660e3mr806420637.0.1723585525636;
        Tue, 13 Aug 2024 14:45:25 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e5a435b9sm6221090b3a.117.2024.08.13.14.45.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 14:45:25 -0700 (PDT)
Message-ID: <661dcdfc-faa0-4324-aa3f-1f88536e562b@kernel.dk>
Date: Tue, 13 Aug 2024 15:45:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] abstract napi tracking strategy
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1723567469.git.olivier@trillion01.com>
 <c614ee28-eeb2-43bd-ae06-cdde9fd6fee2@kernel.dk>
 <a825ae96ea73b74ffd278ba33fa513a6914ec828.camel@trillion01.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a825ae96ea73b74ffd278ba33fa513a6914ec828.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/13/24 3:34 PM, Olivier Langlois wrote:
> On Tue, 2024-08-13 at 12:33 -0600, Jens Axboe wrote:
>> On 8/13/24 10:44 AM, Olivier Langlois wrote:
>>> the actual napi tracking strategy is inducing a non-negligeable
>>> overhead.
>>> Everytime a multishot poll is triggered or any poll armed, if the
>>> napi is
>>> enabled on the ring a lookup is performed to either add a new napi
>>> id into
>>> the napi_list or its timeout value is updated.
>>>
>>> For many scenarios, this is overkill as the napi id list will be
>>> pretty
>>> much static most of the time. To address this common scenario, a
>>> new
>>> abstraction has been created following the common Linux kernel
>>> idiom of
>>> creating an abstract interface with a struct filled with function
>>> pointers.
>>>
>>> Creating an alternate napi tracking strategy is therefore made in 2
>>> phases.
>>>
>>> 1. Introduce the io_napi_tracking_ops interface
>>> 2. Implement a static napi tracking by defining a new
>>> io_napi_tracking_ops
>>
>> I don't think we should create ops for this, unless there's a strict
>> need to do so. Indirect function calls aren't cheap, and the CPU side
>> mitigations for security issues made them worse.
>>
>> You're not wrong that ops is not an uncommon idiom in the kernel, but
>> it's a lot less prevalent as a solution than it used to. Exactly
>> because
>> of the above reasons.
>>
> if indirection is a very big deal, it might be possible to remove one
> level of indirection.

It's not that it's a huge deal, it's just more that if we're dealing
with a single abstraction, then I think it's somewhat overdesigning for
the use case. And I'd prefer to avoid that.

> I did entertain the idea of making copies of the io_napi_tracking_ops
> structs instead of storing their addresses. I did not kept this option
> because of the way that I did implement io_napi_get_tracking()...
> 
> but if this would be an acceptable compromise, this is definitely
> something possible.

Doesn't really change it, I think. See above.

-- 
Jens Axboe


