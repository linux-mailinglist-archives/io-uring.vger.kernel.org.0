Return-Path: <io-uring+bounces-4381-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDCBA9BA990
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 00:25:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A15A280E23
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 23:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE90D18BB9A;
	Sun,  3 Nov 2024 23:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FB811II8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7AB18991E
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 23:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730676335; cv=none; b=eVtG1MOnrbAOv1yUEBVyvlszctGxEm5/oL9QoXIx9ccZyooUzm7GV++NikAtBcfSvWN7T2/lpWtqOdyPEB9DXYDJHppRacIE/IYTLql3jbxT20TNJxhT4l5QjWDP+a8O0zPTDT3kkX2sa2IDz15MVM17aAYbEur+CVOOSJTthZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730676335; c=relaxed/simple;
	bh=0cZ6lPl9Yy2iiDS7CzgrXZaVFPkCC8z/Lj95IZkTehs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=d4QvI9jE2pN0Yrx/9j5tikNPCosX8agb9e6YRyJ7/yh06nYhvfj/uVBqOapJv/0Z8Ur5v2Oq1G5rFQCrL6d6uE4Hu8BO07cGY9mehiTszb2lR9WpKKl1StpO+1GoPkvKtFqDNd4mWSbSyCTPTza/SrLc7a5nJ/fK4+pXkpjUD+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FB811II8; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7ee386ce3dfso2880118a12.1
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 15:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730676332; x=1731281132; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NiujqGz4bmSzpm3iB5c/AblNIXOyV7T1D0ZKCz2SI1c=;
        b=FB811II8twkALG7P7TeG6d2gFG1Jy8gQy5pWNBh7pwbFJOCMpCTjjAGRFy6/lc8Lcx
         afWtFNS3XLm3ERPaM3WhSa8vh81bjZV8FMDfPItdNcZ2LGnO8Qbk3ZE5B3Yyo/5QdjnV
         eRV743//VJZPZLXdQzohxNhCImlkKiW8DlVy5iQ0Wg+GUyc6+9Fw8FUJHYw3gXo/t5eq
         S/3NVO5PdOdrQCuJ+Ex3abZNgA6nwyFO5DRlJqfheKJpTUlEg8pr/8oOqlezDtBOPiSS
         LbEC5bSFbCO30kbZyZVyTjxB2b9KUkr7I0ojIJU2ZHqpdL5IXpdVoF3llAaXA9v0HpLJ
         9gQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730676332; x=1731281132;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NiujqGz4bmSzpm3iB5c/AblNIXOyV7T1D0ZKCz2SI1c=;
        b=VNLg5/p46wPvb58P4iQWyLncJNPwPIjekR0HWZRD9ih550HXnKxkUBkaG/5YDk1D59
         gYGLxd3KPEiWKXwpZmCkKPDIuSVe3xejQgC4HP5i+2bJjsa3w05VVcgiEFwHjVGOV+Hg
         i6+q3zj1o/i/g5JbTi0PU0rzTziL6+kLxxRvBp/LfKHOnN1gleZnVWTvd9D/T2V/GJS0
         JnwrUuZ8mbmrtrrNsPxO1yF1jPxPCvT6OsUeAIixMYhSCizPDxU/G1Mqtj1N98adZZIn
         /7eM509yDywDbHkUIgQIyldcZNwCLfE7CJmYKgtNr0Qbp7Eiu/ZJmLZ+3R4JVnlWLVjh
         g8iA==
X-Forwarded-Encrypted: i=1; AJvYcCUWIXput7kklvhxejeFgrHqCQp2nQ5bHEoqCV5NccVaO6wq6hQwpLkxkEt6qFWxrlac3IBZZpYmEA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLcHuCvAJP6V4eH4ea5CQdD+iID39egeVNZe0OPvvsTewYq6D4
	6fulMt3fdBGVwQYEfitDSUgP9j46VvCRswV16TV5+evmeilp0aeKkdalneKU5lFenEO1f1t4orc
	l57g=
X-Google-Smtp-Source: AGHT+IEsedsq4/7PMx74iRBrKh/Qt7fJIirUfVZKpVCGkHt6USGVFPMUmxjCAGWP3pPnBk23ADiarQ==
X-Received: by 2002:a17:90b:1807:b0:2e0:7b03:1908 with SMTP id 98e67ed59e1d1-2e94bdfd782mr16888490a91.10.1730676331975;
        Sun, 03 Nov 2024 15:25:31 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e93dac04a1sm6332952a91.34.2024.11.03.15.25.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 15:25:31 -0800 (PST)
Message-ID: <a6f1befe-515d-4317-8165-7e2f79f5b394@kernel.dk>
Date: Sun, 3 Nov 2024 16:25:30 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring: move struct io_kiocb from task_struct to
 io_uring_task
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20241103175108.76460-1-axboe@kernel.dk>
 <20241103175108.76460-4-axboe@kernel.dk>
 <8025a63c-6e3c-41b5-a46e-ff0d3b8dd43b@gmail.com>
 <639914bc-0772-41dd-af28-8baa58811354@kernel.dk>
 <69530f83-ea01-4f06-8635-ce8d2405e7ef@gmail.com>
 <d4077350-ac9e-49ac-8720-ee861b626cb8@kernel.dk>
 <03d7e082-259a-4063-8a98-5a919ce0fe3e@gmail.com>
 <40c07820-e6e2-4d90-a095-31bb59cedb8d@kernel.dk>
 <4cd58a90-2cbb-443c-84ab-9a9e0805e72b@gmail.com>
 <81330ac7-6c9b-4515-8dce-6294fcd45641@kernel.dk>
 <099ea61e-b36c-4b87-9897-8265e3a6b6c1@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <099ea61e-b36c-4b87-9897-8265e3a6b6c1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/3/24 4:17 PM, Pavel Begunkov wrote:
> On 11/3/24 22:51, Jens Axboe wrote:
>> On 11/3/24 3:47 PM, Pavel Begunkov wrote:
>>> On 11/3/24 22:40, Jens Axboe wrote:
> ...
>>>> Right, but:
>>>>
>>>> if (current->flags & (PF_EXITING | PF_KTHREAD))
>>>>      ...
>>>>
>>>> should be fine as it'll catch both cases with the single check.
>>>
>>> Was thinking to mention it, it should be fine buf feels wrong. Instead
>>> of directly checking what we want, i.e. whether the task we want to run
>>> the request from is dead, we are now doing "let's check if the task
>>> is dead. Ah yes, let's also see if it's PF_KTHREAD which indirectly
>>> implies that the task is dead because of implementation details."
>>>
>>> Should be fine to leave that, but why not just leave the check
>>> how it was? Even if it now requires an extra deref through tctx.
>>
>> I think it'd be better with a comment, I added one that says:
>>
>> /* exiting original task or fallback work, cancel */
>>
>> We can retain the original check, but it's actually a data race to check
>> ->flags from a different task. Yes for this case we're in fallback work
>> and the value should be long since stable, but seems prudent to just
>> check for the two criteria we care about. At least the comment will be
>> correct now ;-)
> 
> I don't think whack-a-mole'ing all cases is a good thing,
> but at least it can get moved into a helper and be reused in
> all other places.
> 
> if (io_tw_should_terminate(req, tw))
>     fail;
> 
> should be more readable

There's only 3 spots, but yeah we can add a helper for this with a bit
more of a fulfilling comment. Will do that.

-- 
Jens Axboe

