Return-Path: <io-uring+bounces-525-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5084847C28
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 23:20:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A02428BFEC
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 22:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B07C785957;
	Fri,  2 Feb 2024 22:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XoRWusfa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952E78595D
	for <io-uring@vger.kernel.org>; Fri,  2 Feb 2024 22:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706912431; cv=none; b=jyLlhDPCMxrGgrFO9hZxh6y1joegQdaEMP22IQ/4KiJcDFFHBNhMblw1F/I3zOx7Ra3VVMEExLGt5HVbDcfQuTLebcjSLbRwwp6OsppFOMoNxhE9kAgBizVaIBekljw5J5WJXe6zyqjP1AW0/LRzpNNugLgfkFvfmlLgAjMIfEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706912431; c=relaxed/simple;
	bh=w+V9ZmA+LPV0EmrPRhr03A0Yh9ONU6FHeWd6O5URamU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rsLZDKf+UMocvj8F5Wfk7pijyShPtzOvt1LCVAFXBzCG1y8wmpZVm8K3o4R3Gfcur3NBYd8Preip8Sum3MMG1ESTpeEW0EZ2ZDABrFsbdkxM0YE7Xgt2LsNnD7ZkUZCNyCKXa9zSpI/slk7iQ1oVm9u5q7iitHeGWhu3/Ms9y+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XoRWusfa; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-42a9c3f31e0so3933651cf.1
        for <io-uring@vger.kernel.org>; Fri, 02 Feb 2024 14:20:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706912427; x=1707517227; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bINHpK3j+2e/WHzFpcbXKwpCCJukYiEuoOqLa4fg3ak=;
        b=XoRWusfayPo1Uersa2KZuudT1epPsasE2we3aduQPjLPwPXoFjnk48UPLgdOrPp43y
         fTnUqlMwECp7EWRv3BdrTEo67EmpBT2Z3/7vQpohDvYHhcuDYg8iZLI5tXqlYJVkFevg
         EVpk7/4eIGlUWuf6kbw+XE3bmdnh4rSkamBemLB/M1DDTTeG7dODUpWIIzLTBNrup8JM
         OiiGDszpZApgaIa9xhQOiIstxroQ8bDI5TSAkFu7lG9jdmpgItQqFRiAwvtOkVH+DmAM
         zmrYxt1Zk7aS0vlI4VazGS6hmBHtQmK5t+wcen0fsOzEZqIFvHOXu1nhLypC10VLY9u6
         yNqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706912427; x=1707517227;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bINHpK3j+2e/WHzFpcbXKwpCCJukYiEuoOqLa4fg3ak=;
        b=r3mbLOJT+ruRdjTthwDm2i1AQxfWNMnu8Nk9TtCLV5pVe01FJyzmcxEOwNbeBcVMqL
         3C0Tw1o+12ySoZavwU5ou9tVPxtSrONYcy1B+VawT59iV/4ETVSkXZWfiGlczrOgQCgq
         6tRGfPOmYmo5g1sF7gqBCJFEQ44qLMek7szf2uAicla676M2dd3OCPtACeXeD3OFSAs4
         5NKWj7zJ3MbdM+bg/13xqxVlbRZV8ZAJk1a1WsSRQy9dtKb6AJujqz6mZTP07a0h8Aou
         OGfbGoJTud7kyMbDyqiX1F19mxGEPD6SFKBloDhReUCEmHkpHiGpLWq237izMrRY3ScC
         PABg==
X-Forwarded-Encrypted: i=0; AJvYcCU8NYfvrxqV/xymGmmwAF8Ijq9bjpW955lSTwAOdWP/LN1Cr5ztRAVNhwLyqcNyDcnKjsOpCp4wJ1GYT8T2NVBGu0+/pD7P7VI=
X-Gm-Message-State: AOJu0YyPECdNjbjL/K5nyPLL9aX60oZLcMhQF+bsTSm4OACKwfMhpMc0
	ZVcyMUevWnmMO9Twy7GCZQelQ1tbRumxbct32IfknFXADNq+TDV3hXON41tn5QU=
X-Google-Smtp-Source: AGHT+IHHeiJ5cEC0fqgcQ7pi++yuTaibgeILJdOl8IFxOgJ8iYzWVQQmJ/q4VsJvxuJXe+krIQLUPw==
X-Received: by 2002:a05:6214:226e:b0:68c:6b19:f73d with SMTP id gs14-20020a056214226e00b0068c6b19f73dmr9738755qvb.6.1706912427142;
        Fri, 02 Feb 2024 14:20:27 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVnvUgFWQm6ALqcIkpR+aJ6VNf/5tGzome6B5eJawgwxeLQHKVcrQj2h+H5T20eEPbhRheFtWo54y10bz1CThsB3s0187ohw7ywjsCjfSnADTXUcNglpqhrQtzqUC049NnEXr0sc+9ngWWru6n00hmMakBP7a0=
Received: from [172.19.131.115] ([216.250.210.90])
        by smtp.gmail.com with ESMTPSA id lz8-20020a0562145c4800b006837a012417sm1189341qvb.51.2024.02.02.14.20.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Feb 2024 14:20:26 -0800 (PST)
Message-ID: <948ec12c-9601-4e96-b9b6-d97a6cebbde6@kernel.dk>
Date: Fri, 2 Feb 2024 15:20:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/4] liburing: add api to set napi busy poll settings
Content-Language: en-US
To: Olivier Langlois <olivier@trillion01.com>
Cc: Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
 kernel-team@fb.com, ammarfaizi2@gnuweeb.org
References: <3b32446d8b259219d69bff81a6ef51c1ad0b64e3.camel@trillion01.com>
 <07EEF558-8000-436B-B9BD-0E0BAC40C2C3@kernel.dk>
 <a6bd8fc18d15bf1be4ccf0a8cd4f5445cd849fa2.camel@trillion01.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a6bd8fc18d15bf1be4ccf0a8cd4f5445cd849fa2.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/2/24 1:23 PM, Olivier Langlois wrote:
> On Fri, 2024-02-02 at 13:14 -0700, Jens Axboe wrote:
>>
>> Ah gotcha, yeah that?s odd and could not ever have worked. I wonder
>> how that was tested?
>>
>> I?ll setup a liburing branch as well.
>>
> It is easy. You omit to check the function return value by telling to
> yourself that it cannot fail...
> 
> I caught my mistake on a second pass code review...

Oh I can see how that can happen, but then there should be no functional
changes in terms of latency... Which means that it was never tested. The
test results were from the original postings, so probably just fine.
It's just that later versions would've failed. Looking at the example
test case, it doesn't check the return value.

> C++ has a very useful [[nodiscard]] attribute that can help to catch
> this simple error... I am not sure if there is something similar to the
> [[nodiscard]] in the ISO C standard...

You can use __attribute__((__warn_unused_result__)) - the kernel does
that, for example.

-- 
Jens Axboe


