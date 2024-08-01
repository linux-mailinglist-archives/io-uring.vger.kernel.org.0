Return-Path: <io-uring+bounces-2633-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CEAA9453D7
	for <lists+io-uring@lfdr.de>; Thu,  1 Aug 2024 22:51:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4FE4287AAC
	for <lists+io-uring@lfdr.de>; Thu,  1 Aug 2024 20:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C4B13DDA3;
	Thu,  1 Aug 2024 20:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="20AePVhm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37876101EE
	for <io-uring@vger.kernel.org>; Thu,  1 Aug 2024 20:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722545475; cv=none; b=KaNwJ6WH3ffibqyjC49nPGU8CVBTyibSV2EIjreJ2sAO15BjAu882JCBpcWtZei5eKlfI0eAMj/AdV/GytarAlzLna09mcHzfx8VNO3RrhNn+KcwXImiZgNFnNItE26NKn6GeLn1+ifk7J5myVwq2ttPiNQv8TRpE0fz0c1/jBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722545475; c=relaxed/simple;
	bh=arOZwEf3/DJ20vlU8sYSHzjnEWADbhyKkhILpyn9Jgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B5XUSPpl5do4Xli11EZHGi9YXjKJAbhF1+Dh2xJ/qrPbJ0cQ64AD57MXMtHHXKihu6RlASpVuUOqKU8+7zLXvSTx5s0fmBaXeFsfb2voTfDygxB+aU/ok54zgwstFGdZUjAp6Ax339he0am4eWPFj6wW6oDXc6wiJfSIlseENVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=20AePVhm; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-39b0826297bso1090485ab.2
        for <io-uring@vger.kernel.org>; Thu, 01 Aug 2024 13:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1722545470; x=1723150270; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gbVidXHb/uk7Uion7jqtruMFSJQY1UX+G3tHGj1eSHw=;
        b=20AePVhmlfXCzsuO28NBgbsuwlztX+ccI6RB5ba14woS8CV0EDozQJTfFcKD6zPp4P
         ofNWFfbCorSciH4wOy3aXK7Zrg3QODkvteHLjcph0Fq+5A4yMwvG1/dUe2tJZY2CBOf6
         RoA/YPPxmliYHUKAR8C3NfeaJ2IUpGs9/bcBPUxNJO5Maq3RJQZyIw8RtmyvRpTns+YH
         ouVrnznk+79N2PqD8eVU9BUR2wFpxHA1zzVbgT8/XIksjtNlvNeXrYggfXNW8lQO9NOo
         /C61gAcX4KJYx2FumNNFypy5P3FfT7m2/KcQ1e1xU4NKpxONmjXzP22BOtK+coBzo+05
         jPmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722545470; x=1723150270;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gbVidXHb/uk7Uion7jqtruMFSJQY1UX+G3tHGj1eSHw=;
        b=TK6PFCCGz6JNPPzTxaYjrZi7NzoitcT5jWHInaMTxnwksSmO0ZC4Fw5JOA0aELaPC/
         C+D12Be6Jvw9gFi5jMlCODWgGTlhNsbfahfFLwe0gZjvhyYHi018T7jFgt60TIH6krlH
         co+0NQwLmfutPffHysG/w+GfDsWjpJREi3V7EJRae8bR00Ax6Ryuy7m4X9QERrqBXL0o
         rN5o5FEZd07Jm+A4QVZk222P3r/Fwdc4UkrFcNmkr2iU1doSC3cO2Yj7CpxA/xOlsd8x
         96QXrAgtLXkKSiGiupPynnvPXOa1IFK1GdUaOMr3o1hYgIm5WbOceRsyl16UCEvZiImV
         Wh3Q==
X-Forwarded-Encrypted: i=1; AJvYcCW99i1ls+nttQija4wjep4yn61syseSZxwS5HvDxxAmOxvD3wz0U+4fT7aJb+Aau5aLiIe5523KWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvjvzXC4tXPrMsPW5+rWk08sCEZn9qXGBM+Bd63t5cVCvGhDFw
	xMGmqQ6XXzfzo9JkOB/Isc3aUXTygRSrW4ss7B8eLiY/aQG5bnAg0Ssy2dYIuw2tXObQC8jjank
	l
X-Google-Smtp-Source: AGHT+IFXrQyWw76POrIOSb+MsCyMJhB/z8bkg2s9r4Bd/LU+38gIqimN++PPhDMzRPBsMFTioemrsg==
X-Received: by 2002:a05:6e02:1a49:b0:383:17f9:6223 with SMTP id e9e14a558f8ab-39b1fb79763mr10957085ab.2.1722545469814;
        Thu, 01 Aug 2024 13:51:09 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39b20a9aa5esm1997545ab.8.2024.08.01.13.51.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Aug 2024 13:51:09 -0700 (PDT)
Message-ID: <c92fcb87-b8ef-4f86-b7bc-b09188e33ac3@kernel.dk>
Date: Thu, 1 Aug 2024 14:51:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v3] test: add test cases for hugepage registered
 buffers
To: Chenliang Li <cliang01.li@samsung.com>, asml.silence@gmail.com
Cc: anuj20.g@samsung.com, gost.dev@samsung.com, io-uring@vger.kernel.org,
 joshi.k@samsung.com, kundan.kumar@samsung.com, peiwei.li@samsung.com
References: <2b0e7ae1-ac02-4661-b362-8229cc68abb8@gmail.com>
 <CGME20240801010122epcas5p3ea76168da6d5dd9ba6d8fe54537591d8@epcas5p3.samsung.com>
 <20240801010115.4936-1-cliang01.li@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240801010115.4936-1-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/31/24 7:01 PM, Chenliang Li wrote:
> On Thu, 1 Aug 2024 00:13:10 +0100, Pavel Begunkov wrote:
>> On 5/31/24 06:20, Chenliang Li wrote:
>>> Add a test file for hugepage registered buffers, to make sure the
>>> fixed buffer coalescing feature works safe and soundly.
>>>
>>> Testcases include read/write with single/multiple/unaligned/non-2MB
>>> hugepage fixed buffers, and also a should-not coalesce case where
>>> buffer is a mixture of different size'd pages.
>>
>> lgtm, would be even better if you can add another patch
>> testing adding a small buffer on the left size of a hugepage,
>> i.e. like mmap_mixutre() but the small buffer is on the other
>> side.
> 
> Sure, will add that.

I'll queue up this v3, but please do send that as an incremental
patch as I agree it's a good addition.

-- 
Jens Axboe



