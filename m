Return-Path: <io-uring+bounces-5483-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADA2E9F140C
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 18:41:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FCA428245D
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 17:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B6B81E5707;
	Fri, 13 Dec 2024 17:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BEur1q54"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E2F17B505
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 17:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734111664; cv=none; b=QBGa6lLrdjHfkg/aEwylYSQeqS2SVO8MYvcTFlrJRaHLH/AWjkJjLHf9QA1rEPzh2HiJOqWNatt3UlXYDiTVApLTmUow29PHG8Lyklf4+3SYs/mla0t8ofclZlqj1pHdosm7q1QvNKO9v1QoickXS9Kwdc/JS5O7dyVeeZeIcig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734111664; c=relaxed/simple;
	bh=mS5remZZ47Xsdl54gElc1+pdGXZZqNxO4fVKAY0Gq88=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bWxerrysRIOadyf7lS/k+Z+MDGov0r0kg0OKLvVv3soAVK1pRuPTPtqeMHV2z8Yfo4jSNLaOjxaF8h+gu9PCLBoprZrtMZXO7+x8l8up/K6MY3rrEtAjDbTICPmH0Vrdv7FZlLKc6fBCjouMAWoF7SNCjr1nkPTM1O9OCKua38Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BEur1q54; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3a7deec316aso7203025ab.1
        for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 09:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734111660; x=1734716460; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nfoQCPAYwIf25kFxsXANckD/Z6DcaeKiLRaR2xCd30Y=;
        b=BEur1q54cUU1UPEgVdNz0FHe+UksJRVqsNn29mxIhZJTd1fbJEJrI0c3ClE2rcXtiA
         I70vB3dy3VbqERlwM1a6ugpvXpAYXjsJyG31weJxWUYfO3ilZbCGUAJxZetxgLnNTZO4
         HkSpHV+/E8wmbZWaGRvQxtNUsmFwltSbBVfTvD4qSOLPh2aCUJNsk8Gime/DDwAN+iAQ
         8Hgir955iAmkIwjWcGdUQdhM8gmOihC4XoaMbQh+xbTsYoyxR+1dt2ywuRlVb0hArgcb
         bS1/WyGj/eATTFN7d+kB9q4dix0k+MmakIuHqqXYUBxT5Yqs+2NdDrjOqczL4OMX9u0I
         BiiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734111660; x=1734716460;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nfoQCPAYwIf25kFxsXANckD/Z6DcaeKiLRaR2xCd30Y=;
        b=dkDZFMtQ+IMnBVc74cXVjhjEX+zy65uTDfSioU0EpJtVr4lldOoEKpeMx0P8pg/DuC
         NT8zNVOwt2GqCXqNmrxTKSqeC9Bf42LlnFhLsN+ftj37Hr0LniCP6BbJ+sdgtBvYWZBS
         vgY8fPTOAmjrJB6Tb+6eS1ZpJFn8I+oQGGRSQmo6Cbs6X2dIoKCPQjERroRYS8koqSQt
         29dkIj67fVhV5h4+DU6th1Tdei+MMrDNSjt4hv/Z+Nu2zch3yzaDI5HopUGWHZpgOAIj
         Ov9pJN5FYbZTxQXoDyORpzAPdoKcGmLueUVPJQzi8nrLziQMPRppkIIAZDkHxYNZG89v
         /DWA==
X-Forwarded-Encrypted: i=1; AJvYcCV4FV58cgkt+xDUBTBA1zC4NajZyFdE/ZNvyaDi8shQJktJt2YY9TmtLMHSbg/g+Hmi2HUL3emPXw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzHYz/C5JNTsOsKumEQAyNQg8SM/RE6lAtk05Af0rY6TfR4SlRh
	Q+LQXKTdsV5mB9NFS16c0AvTpG3vmoXoYILyrlchKCTY9TjhlDtZxPUJX0j8dnI=
X-Gm-Gg: ASbGncv6Lhe9WbFbP9cOG1e3GXS57UgvgskAzO2fc1OmU818Wd6fSqMpTFxsd2LjoHd
	Kw7tH1OcdLS6PFsNf3O3H1o7iXHXhArBQhTsj6/GL5vvxYwg5+CDM7i3rGBloyCj2VOLuWuyjps
	DzomxOkfA8uEjCRd0WHAn3sUmsmQwiOmW5BhFaL1Q1f1u5XAS89TwTRRnuqGlZ7j6HU5J1vPot3
	RGdbn4l9jotcsPlVOdY8ipK4pWg8dWdj/VrPT7deAa+JXQqPD4k
X-Google-Smtp-Source: AGHT+IFMakr8bU6f3YZSO/+eHvp/KKhselD2XlkHsnfbAosDkYcEJnpYHg/228UJMmGvVKljs/oVHg==
X-Received: by 2002:a05:6e02:12e8:b0:3a7:e592:55ee with SMTP id e9e14a558f8ab-3aff8b9d0admr46064905ab.20.1734111660696;
        Fri, 13 Dec 2024 09:41:00 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3b2425c4b3dsm262605ab.0.2024.12.13.09.40.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 09:40:59 -0800 (PST)
Message-ID: <ca3b85d6-ddbf-48b9-bdf5-7962ef3b46ed@kernel.dk>
Date: Fri, 13 Dec 2024 10:40:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in get_pat_info
To: chase xd <sl1589472800@gmail.com>, Pavel Begunkov
 <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CADZouDQpNvEd7ntUgOAQpU18PErENx2NsMMm05SXXODik6Vmtw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADZouDQpNvEd7ntUgOAQpU18PErENx2NsMMm05SXXODik6Vmtw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/13/24 10:35 AM, chase xd wrote:
> Hi, when I tested io-uring on lts 5.15 I found this bug, do you think
> this is a bug from io-uring or mm subsystem?

See this discussion:

https://lore.kernel.org/io-uring/f02a96a2-9f3a-4bed-90a5-b3309eb91d94@intel.com/

-- 
Jens Axboe


