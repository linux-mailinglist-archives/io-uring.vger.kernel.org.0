Return-Path: <io-uring+bounces-3255-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D3B297DD62
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 15:46:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ACC2DB211ED
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 13:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 199F916EB4B;
	Sat, 21 Sep 2024 13:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zF1xCLwD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE6E16DC01
	for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 13:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726926394; cv=none; b=GpHTCwoFVg5vZuKGeYoVjmkap/XiiU4Q88kelBHnD50mTRHf1l2hRmHvcEppjC+CaK0Wp/AFMcgR6u4H4RIHhmmiGVyFFHrRBUMzCK7oc1M20DPX3CsvS66f+1ZQYa1P803RSAPUO4KQPoB+9HddxqqjhdY/CajGFv8A2YplkCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726926394; c=relaxed/simple;
	bh=zd9YFm1ClWhgZ2jmgTAcVZl4XyINt/Ao5Bks3esXC2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RNd+g0bDfhYSp7YkcPcdzmmRGFF+Sp+p0zDhy+ct1DgoqZj3+qFHQBJ5y4HRqZoW7JlghuCRZew5SSDx3XqT8SzFplKrkVUj2m0GAvKJmkucxaNOILPiP5+qpPi/sWGGxJ0qZctwtEI1V4C+ZeHXYH8ZVcED+kYW4RR2dXznxuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zF1xCLwD; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-719b17b2da1so145810b3a.0
        for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 06:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726926390; x=1727531190; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oIQjm+NP4qKVhC47K1Cb9c28vttlQJ2H/n2dYBdGbRU=;
        b=zF1xCLwDsbjRKRZwFGlRU2IXsuARHnTcKHLc0TOrPBvaxJOq68Aj1Mex8wNdy2T6BG
         RcE8waTZBcJXTiefR6leXjQ5x9dHyxSWmQshpahYIIv8itrhaq9ps4A3lFMYPA65SDd0
         pQ0+m6dB/JISTlVl3Y9cheuOErz/0y/FwRnGtMnkwB2E+5EdTKzaCvzk2I3IM77QjnOy
         X6OseA7cwCFYmfyj8Zoz0bIv/JC+nURKfmq3G9nEx++zRcDaEyEC+zvasewUWaj45Oo/
         NMBMvod+bFvIWy2aFoUyLCjSLCvFWx8EYzSKqxZmPSoTmoVaG+GEbnQWe7hTn3uTv7mA
         1zCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726926390; x=1727531190;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oIQjm+NP4qKVhC47K1Cb9c28vttlQJ2H/n2dYBdGbRU=;
        b=iEfbFmAQQJd8te0Wi5QkvClDfr1wZpTzxQsmZAz39sN0Xl7o1XJbgA7DKa1iLUMMmB
         8bvMx0+tcRAp1xRihHAAfooi1WDjk9eUiHnm2urHoZevrin25W07iPJEw/oPpbfJKHq8
         ZFBSS29j/bzKEpeY7EnauPPzS8SlIytOiSp8ldoiI9jMfrzhn4ejj0nxpiv8WnTWZgUJ
         +maHO0EwuBqxIymhk3l2aIvHT18lcE6YHQmbP7LtQmT35H+/Io3l5xUVn0RctJR/mCFV
         PfJFRtZboBZJvBrBpad+4Ipi2sEg/kkGLQyAPNcRuaKsbHaQ9LZGdBdrtQ5cnmen9Noa
         r/xw==
X-Forwarded-Encrypted: i=1; AJvYcCX5CsT86Tr0pJ8qkeu7oc1kgazldrWpHTK6wsEwLR5oAkr+KP1MH6t01SpTGYffYP2MZ7+CzYgNuQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoIODmc1bCVxnPiR9eUwQ/30zoIupXqh1JH8SN3i4vFMCoVMtr
	dZ0/749uBrqDKQMybXPPdn8rrcom7dHnY6nWbDkXjwNPevb3cXThlU6sDOg2rkg=
X-Google-Smtp-Source: AGHT+IGaQHIwZVp1ozVQvtkl2wrcawT9cNHTH2uJXqoEQtjvYHpMcZe6WDFMm1vDwVbhVF7Nrmj7yA==
X-Received: by 2002:a05:6a21:178a:b0:1cf:37bd:b548 with SMTP id adf61e73a8af0-1d30a9b1af3mr8377876637.37.1726926390095;
        Sat, 21 Sep 2024 06:46:30 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21c1::1021? ([2620:10d:c090:400::5:2ca6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944b7b21csm11254085b3a.123.2024.09.21.06.46.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Sep 2024 06:46:29 -0700 (PDT)
Message-ID: <c1787233-92e5-4698-8731-c2bfdf19dbdd@kernel.dk>
Date: Sat, 21 Sep 2024 07:46:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] napi tracking strategy
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1726589775.git.olivier@trillion01.com>
 <ea764e4c-0255-480f-949f-c67e7fe79e29@kernel.dk>
 <f5c561079c87e0bb6ec2675f1c3b6b7783b61120.camel@trillion01.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f5c561079c87e0bb6ec2675f1c3b6b7783b61120.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/21/24 7:32 AM, Olivier Langlois wrote:
> On Wed, 2024-09-18 at 20:36 -0600, Jens Axboe wrote:
>> On 9/18/24 6:59 AM, Olivier Langlois wrote:
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
>>
>> This paragraph seems to be a remnant of the v1 implementation?
>>
> you are right. At least the last sentence is. Is the cover letter
> injected somewhere in any way once the patch is accepted? Would that
> detail alone justify the creation of a v4?
> 
> I am taking note of the detail and I will correct this if there is a
> need for a v4.

Right just make a note of it if you need to send a v4 for other reasons,
cover letter doesn't go anywhere in the git log - but is, however,
linked off the git commits in terms of the Link in there. But since we
now have this discussion in there as well clarifying it, that is fine.

Doing conferences in Europe until end of next week, I'll see if I can do
some thorough looking at this version during that, or worst case end of
that.

-- 
Jens Axboe

