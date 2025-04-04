Return-Path: <io-uring+bounces-7396-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98EDDA7C0A5
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 17:36:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A96C97A851D
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 15:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E841F4E59;
	Fri,  4 Apr 2025 15:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kCAEnmPU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0E8145B0B
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 15:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743780959; cv=none; b=jJgBJTVGmgN+iI2ledPAtzeLIj1G/RcSiqHXKgmi52SRx4q7yoOQyTCD+4+GqsSXXW8bHCxZIH8cW5hARUfWbZwq/Mi/v7BT7TgKb8WbLqQ2BH1NQcX796hi2HoBCaKNULcdd9VtESG4HrV2PBumbKjE5nPV8rJVNEQl6iumSMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743780959; c=relaxed/simple;
	bh=MHIrcmY2aV0B6pOIbGnjg75VX48g6KZ+318BlINTrJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FhCxfQ86zAdsom0cR7BTN7rLJsAuWvwcifPtpaUaIy/stEwR+B1d617sQy2dPzbRR3a1O+Qy6DHYN/NSbZo4UJb6/ibVO4nyxUOcMrtRzu/WMwJdJH5npRDFQ7G7wgdDxOw+9rVqkprPqxIaXddHiAxhpPa+KwaEEM1EdQsUDa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kCAEnmPU; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac2c663a3daso413532366b.2
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 08:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743780956; x=1744385756; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PYg2XfycQVjPfmmMZotRn4FMjZYauHp3r+Ae7cVVb/c=;
        b=kCAEnmPUa32jE+4SkL59z+CL03lQRZXl2CjlUm8dp2WesgDmjGLKKOvISHPmanrAjY
         zL28eoRIWt3whlzr7Wx9M7a4KQODdNpmvxQcUFRIpNrgWH1RhScGgwt7Fbs+OQ0h/Pnu
         Sxq4bfoXT6USbXIar9oMdDxxyxVB2e4Qiy4Arbr9KPwlhME8eTMhc9D7o4rb9zbOaC3Y
         YafhKGMd2gSnvWTeDO/FUTNxuUu7NtXUlrs6VIfN2wEHStxl05PCZdGn1WpzAjr9qldG
         tjIZ+2XYb6Bq77S1xV9Pe9WFMhW2NRProCTmCU+bQYU4pTMi968cXH8Of2rU1KE86aJP
         1ZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743780956; x=1744385756;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PYg2XfycQVjPfmmMZotRn4FMjZYauHp3r+Ae7cVVb/c=;
        b=VVNoIY732aY2aiEO9Wot/IjnbH6zhCL2LwousWv0QVHuAoNxt6r1SRequH/T4reTY5
         zRMEUYyb2RfqaJFEyvxVa/RDDNguT1hzRUFB8rhn9+nSkZqrAt7CfY5sE8spl1YkTbwM
         RyuiL+mUsoVxAkYhtsgY86rmE4dkgjd6hGhaRCq8pI1IbToWGzeafqi14kU/r1Wda6Mw
         7ZMhqzsr+A0Spm1SJTGjG+QpJzHwbBSg+F90HdMISuOdEFjnC+1G9GZUFK5JD5qvxub4
         2pHCGyqntywZTydCprVAaYn9BO4ta7I9Cbg7g9NTY74NYYJB4nZm1GX4lWQ/JZYuv8/7
         42ag==
X-Forwarded-Encrypted: i=1; AJvYcCVGqbFmH71w9U6vgzKOQgGYg5ctMG49De0dHysWTfpC6S6h7A9bscRrvsRNq/Qec2I0WUuib6qezw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3O70Ro3usz6SPk/5LrEcHnr7PxhiH1o2BTHUvQlt4GpdT2r7m
	UvSS9LsARqiAiliOmG7XX/3PrQX8kjHUhpK63Msga5Wnjtm1aBo9d7bQeA==
X-Gm-Gg: ASbGncuAeOdQL+k51DzzqoKgVoMHONbVFhtX35+VOpdmrVMC87gJ7jryVKPUTD1CUO/
	gTKAdWAh0TmTF5hIqBfXqy2sT2w7bVXEGtNtxqN/lNARDk8Plc5f3yQYjybZFn7gCJBVBVltqE3
	x/ZIL+92238AlaszQfjN1ewZEAnNPSukfgZgWfMq8JBpgbCdRRj/qBhrVQbIYlVQEWpSiTMNR40
	QWLlezzhzdkjNVL+QMbpbBUHnLsoNFWmyf4LM0nAAbmpptPz4lEadlurR0IeLKdT/KPjmxoWeDG
	yc/cqCMXpPvAmhLeBXvbjG/EdkDuFRsuN+YrkcK+jbzyTwAYcblOYkvO
X-Google-Smtp-Source: AGHT+IEcfPFBJHqtP8pam6ZOabZ84IbSh/JJQEIRfRGI25FMLR7e7x4hoT+kZLQEHhmN/n8zDlBw0w==
X-Received: by 2002:a17:906:c156:b0:ac7:1ec1:d8bd with SMTP id a640c23a62f3a-ac7d190dcd8mr384931466b.29.1743780955716;
        Fri, 04 Apr 2025 08:35:55 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::6c? ([2620:10d:c092:600::1:ce28])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfe996f5sm277128066b.64.2025.04.04.08.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 08:35:55 -0700 (PDT)
Message-ID: <2b3d9c22-fcd6-4422-8834-73f87d4c3df2@gmail.com>
Date: Fri, 4 Apr 2025 16:37:11 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: fix rsrc tagging on registration failure
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <c514446a8dcb0197cddd5d4ba8f6511da081cf1f.1743777957.git.asml.silence@gmail.com>
 <655729ed-7950-4b8b-baa6-5615eb11b8c4@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <655729ed-7950-4b8b-baa6-5615eb11b8c4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/4/25 15:55, Jens Axboe wrote:
> On 4/4/25 8:46 AM, Pavel Begunkov wrote:
>> Buffer / file table registration is all or nothing, if fails all
>> resources we might have partially registered are dropped and the table
>> is killed. When that happens it doesn't suppose to post any rsrc tag
>> CQEs, that would be a surprise to the user and it can't be handled.
> 
> Needs a bit of editing, but I can do that.
> 
>> Cc: stable@vger.kernel.org
> 
> We should either put a backport target on this, or a Fixes tag.
> I guess a 6.1+ would suffice?

Fixes: 7029acd8a9503 ("io_uring/rsrc: get rid of per-ring io_rsrc_node list")

Looks like this one. Recent enough, I thought I'd be worse.

-- 
Pavel Begunkov


