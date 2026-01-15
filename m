Return-Path: <io-uring+bounces-11749-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B7583D2897F
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 22:03:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6213A30123C6
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 21:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484112C08AB;
	Thu, 15 Jan 2026 21:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pMhresQK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEBE2D6E5A
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 21:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768510929; cv=none; b=Gm0QU+9S2hyfCc90iC4NrI9a/yl8m3qDMcGQe6P07/LqKajuFsno9jvGL72Mr51clX9gwetlg9mb+Zwi1dJy1VVVGIjad9Vq3hth/w5k6C/H9oR5Mjxs5FUk8pnjkKW31v+pXji8U/gLNMUUsaRHQbSRXzz+kWAZMFuszdIAJ/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768510929; c=relaxed/simple;
	bh=w2H+s5Bx/hAkhVSag7QUZfuLjfQ6TFnjep97Ewq+MqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=J5V5w1MWFShapxs2u4I/LX30f+qct9rgbU9s/JcSBvzoFH+UtuJQPlCZToxwvbeaWX4tIqLonLVG3sGqcLa8lOVnPejymYTYVL3HJ7XTRA2PYB51s/iAscQL1tY97K13LanrHu1GKMK4qaaTHR76lGtYDzDNjifNZxv+h7uSnuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pMhresQK; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-4042cd2a336so862353fac.0
        for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 13:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768510925; x=1769115725; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eQVgQv5DQnf5Nj48T3VgMfUROKCCThXAuP41EW6Nraw=;
        b=pMhresQK3IgBHAgqT7u3LGVjGNwC0/MtJ0NVQ8oCLc2ujVcUdLuQVVh7G5HAHFtwe+
         /R4gscMRIrJLtylbjXuy9npRI9c+KcdjCLKVYh1E9+RY8uFptDk/QaLuA/AHWujq0eXD
         YUxaXVk+F43mgXxiEwZkGdsgSynpRn9pIAkmS4DHsa2zCJ9bmNALNJkviTyPJ5reh4Zs
         RB1a5mPnk0a4WsSKDKJZ18NvVuj3a219a57eVf8fxz8fEjyGipobMNCeKgacSr9xyy6D
         z0G43HzTLFtJQNe7N7kJ4htfsZ7Oyu863XS+P5sliFn6PPzG+WpkeFfKD14nt+F/IIzE
         YaCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768510925; x=1769115725;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eQVgQv5DQnf5Nj48T3VgMfUROKCCThXAuP41EW6Nraw=;
        b=AszfoKi/6jEBuV4EQrsuEvCF/s10BZeiv3rQmPJTa6CyPZl9PgbIpoLXWRDwXHyEOs
         9Up8DvPJDh/DFEVwqBFlbs182/pVBtbNUWLz1aVLOqjPCiPcgRJDKqaMxSZJWNZw/49c
         pF5e2TzSjUPjMrSzAU/PLAVCDlXkZzRMg8uIoO13APWRSFJyPOcZwTcf88o9PcJzO3gK
         rv/TUXf55ZGqezoscaKgfN4CByPaSBIVQ67ZJaBzjuPcbNsQz/TufDOOUOXbkuHWzkH8
         scne3ETH+tVgKm8Xpa2+0TMgyBSrLqtZbAtF/dfs6K3osjriNm1pq4FqEZ4+mLi54V1x
         8Pmw==
X-Forwarded-Encrypted: i=1; AJvYcCUyj1tF08DLCT9YugW6AGceqVHtWZhwY7r0Hu94KPKVtd9Bx7JvAN1Udy/7cK2azS2jOMKHRAqtFg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/kpWU6R5qoj44pzHvn9NzxpOUHRILPXlJN4QDomTI4YnZ4GfZ
	BxP8eX0K9tW2N1RLQ2y40J5VeVPdvZn7KEmRwav+1qjECjacWif8sqlSmc1zd5z4C9wo+t18vmA
	G5h4j
X-Gm-Gg: AY/fxX4Sr2ACTH4wDeh7I/hsVKCutiiRfMhvUUCbUQ364lWcrQCH8XwxjXRBUB9Rfpt
	1HZvvUcN5/BnpwbKvPLoLtno3wU2s+pznY4/PyHc4Hq2eW03+iUimkLo1ESZhvD1W5aq48qVLHY
	BdbbyJOLU7u0lOgmR4n1JonZpwDf/Tkzu2vy3VktPxrKeiC/lzB1fDQ64Lhh8nU5QUi851+3qbr
	fkOCeMAPR+6YgmaTMyZnZ4ZDvT/B0HBLCKMA4E8Rm819RcOFUjGQIaIqLDTTJHL7nwbgVjkDUpq
	JHLCf9/U50tICFSHCsxFh4HtlvsAeAVmx/1PsqKIY/PanXUZmkj/yuxCwxjIjPTjL/D6c3vEDpJ
	2McTPQS9POJjc1YavyweA63hLgz57ELwn6F8yJpl58nOdDqwDnV8xx9ncqVrr9jtofrrIVJCijl
	az+jSlRPA=
X-Received: by 2002:a05:6870:f71b:b0:404:352:72c1 with SMTP id 586e51a60fabf-4044c1cecedmr429344fac.20.1768510925305;
        Thu, 15 Jan 2026 13:02:05 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bd150dasm502261fac.14.2026.01.15.13.02.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 13:02:04 -0800 (PST)
Message-ID: <9c57ec11-bd72-4caf-8c4b-b46c84f67ef3@kernel.dk>
Date: Thu, 15 Jan 2026 14:02:03 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring: add support for BPF filtering for opcode
 restrictions
To: Jonathan Corbet <corbet@lwn.net>, io-uring@vger.kernel.org
References: <20260115165244.1037465-1-axboe@kernel.dk>
 <20260115165244.1037465-3-axboe@kernel.dk> <874iomskkh.fsf@trenco.lwn.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <874iomskkh.fsf@trenco.lwn.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/26 1:11 PM, Jonathan Corbet wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> This adds support for loading BPF programs with io_uring, which can
>> restrict the opcodes performed. Unlike IORING_REGISTER_RESTRICTIONS,
>> using BPF programs allow fine grained control over both the opcode
>> in question, as well as other data associated with the request.
>> Initially only IORING_OP_SOCKET is supported.
> 
> A minor nit...
> 
> [...]
> 
>> +/*
>> + * Run registered filters for a given opcode. Return of 0 means that the
>> + * request should be allowed.
>> + */
>> +int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req)
>> +{
> 
> That comment seems to contradict the actual logic in this function, as
> well as the example BPF program in the cover letter.  So
> s/allowed/blocked/?

Are you talking about __io_uring_run_bpf_filters() or the filters
themselves? For the former, 0 does indeed mean "yep let it rip", for the
filters it's 0/1 where 0 is deny and 1 is allow. I should probably make
the comment more explicit on that front...

-- 
Jens Axboe

