Return-Path: <io-uring+bounces-4734-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B35569CF33A
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 18:46:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAD54B3CB66
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 17:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 928B015573A;
	Fri, 15 Nov 2024 17:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ev2qYX19"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815C01D79B7
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 17:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731691924; cv=none; b=KjlBuW8Mn2Le7D25JgWntaNCVGK2lnRJOAbVJKYXLEkEjwH+fMPT0mJkZCVRIWK9W7d4qK+G/lsirdBkICHXUkjTlTKEzD3jot+leW1oJYDGPo2/7Tl5OemYMbj1Qa4inSxy+Tc2fVP86ySZRBhKnQjUvu7gDLmVQHjoTAzLdzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731691924; c=relaxed/simple;
	bh=U7CETRQmgmYPKFp0X+Joka9NfaC5pYo6pQU5BH+P8Oo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=PeeUEIdNQ+pgFILxad2qfABqfI0TAsDcTOpjfEDvFdJeTJD2FuliQ9zcvqsumBoVvgcyyvWJ3Y1zJrNTgbOVUfEXrqPOhO67MeISBmWoKFcxUq1wHIdmaKi48qVqmPq5WfN+CH9Y4e2AoJoCHyGpnR8iO6iIoLh2Rl3FAgNzu5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ev2qYX19; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-296252514c2so867279fac.3
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 09:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731691921; x=1732296721; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xh1mJNoFGU0WuZ7of+t18mpX/6DjxlJepWTUJh/0b50=;
        b=ev2qYX19U+8xOiWWwBSR5K8ZpFWL1ySiT1X24/Rt5ZH4tJkN+mMDzOE8cShp5zlzLg
         xeAJ1OtQEq5pp+g98dewFPfLtp+RhxPogVYAH1Lpz20M6+e+QMwNXFV6cHHio6WzhRri
         dJLo3+SEnSQn6NgFEEQin6zMNyE3vTX9zi7US4mSDvbY87LWdsOlJwF889uXqQqbRcPj
         7VWMQQnDXInfdd1U1RywHEK35215IDdV8eDsmopQ2uQEydO3lvQD7xSdiO+SlLc1pwTL
         rh7B16xwzqRkONc3g0SJe6kH3hzrf+33sBaDQdteiNhAPWaZrZ31C/JFmYRe50xxnzjW
         1WuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731691921; x=1732296721;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xh1mJNoFGU0WuZ7of+t18mpX/6DjxlJepWTUJh/0b50=;
        b=lbYmQpwDQ0LlxHWq5R30eDPSzPWwnkPUyGGRy1fN+IV1OnzYG9Rm0JgRvwLsiZjEoB
         xZlbjBFdnrA0Zw+enYdLZpGgSeWJgUkDJfl5BfAQgGuNZ3rix0RIMXI7nEXCuiyZl/bA
         +R50KE95arYw62tOJ1HlcjUKIHf6E0vpOhCMrybX2nedXgqFwSb3byygCeLqQN1PqccF
         LjcGx5qXhKDie2376CGQJTfGA3K4PDMmrPVbgViPuOkp1jasAHsYkWhcSNMCLTBXt4zf
         Gc/8fiQYN4Dg6WeNSWkhgB1M2EDi4ulRM59EoP/AOUYMuzlZn7gaNTQ+Q93h7hvKi/Y3
         6tHw==
X-Gm-Message-State: AOJu0YzVOVWRpQUJ9VsX/E3aBJ/BP3NAMrwJlMgF79XdjPgSUGrC+rrO
	FVTvlY+62+0KRntKu9d9PvsLO6WYWoAmVjo/HsQNvWe5HAf9L3pSe6ZuzXm6yaa9KHIWCD9Sjf3
	tcIg=
X-Google-Smtp-Source: AGHT+IGFiGoJmIPIeuwgIRlZq9chS8RAgHmbjGXth5p1TBdh2fRuThQkklNKwwOf11P2RqwbRGRIgA==
X-Received: by 2002:a05:6870:ab0b:b0:287:1b05:297d with SMTP id 586e51a60fabf-2962e01ad0dmr3777744fac.33.1731691919646;
        Fri, 15 Nov 2024 09:31:59 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-296107fe2cdsm1633024fac.3.2024.11.15.09.31.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 09:31:59 -0800 (PST)
Message-ID: <64a0f298-35c5-462d-9a03-d14bf6cfbebc@kernel.dk>
Date: Fri, 15 Nov 2024 10:31:58 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] regions, param pre-mapping and reg waits extension
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
References: <cover.1731689588.git.asml.silence@gmail.com>
 <173169181217.2520456.13381974829148736459.b4-ty@kernel.dk>
Content-Language: en-US
In-Reply-To: <173169181217.2520456.13381974829148736459.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/15/24 10:30 AM, Jens Axboe wrote:
> 
> On Fri, 15 Nov 2024 16:54:37 +0000, Pavel Begunkov wrote:
>> A bit late but first we need a better and more generic API for
>> ring/memory/region registration (see Patch 4), and it changes the API
>> extending registered waits to be a generic parameter passing mechanism.
>> That will be useful in the future to implement a more flexible rings
>> creation, especially when we want to share same huge page / mapping.
>> Patch 6 uses it for registered wait arguments, and it can also be
>> used to optimise parameter passing for normal io_uring requests.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/6] io_uring: fortify io_pin_pages with a warning
>       (no commit info)
> [2/6] io_uring: disable ENTER_EXT_ARG_REG for IOPOLL
>       (no commit info)
> [3/6] io_uring: temporarily disable registered waits
>       (no commit info)
> [4/6] io_uring: introduce concept of memory regions
>       (no commit info)
> [5/6] io_uring: add memory region registration
>       (no commit info)
> [6/6] io_uring: restore back registered wait arguments
>       (no commit info)

Manual followup - normally I would've let this simmer until the next
version, but it is kind of silly to introduce fixed waits and then be
stuck with that implementation for eternity when we could be using the
generic infrastructure. Hence why it's added at this point for 6.13.

Caveat - this will break the existing registered cqwait in liburing,
but there's time to get that sorted before the next liburing release.

-- 
Jens Axboe

