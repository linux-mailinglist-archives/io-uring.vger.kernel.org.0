Return-Path: <io-uring+bounces-4426-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 090F79BBA00
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 17:17:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8BD11F228E7
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:17:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93A821C1ADE;
	Mon,  4 Nov 2024 16:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ss99cpcR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8E9224F6
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 16:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730737012; cv=none; b=JxGnW3vc9vvo7RKC7tYz81vCN784C1RSdSs1R2EMEfLV6nnxUTJGMCDQZ02tQFRPa9WUOanM2VY4qBykqMrFxEku4UEKeaSn/Dkf++NpZxMpfuNM4l59RzhahL3ZqV6BO69k1bdAlUQNs6vDnpk/EmjZdUrDRU6Frtpf4g5Ibas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730737012; c=relaxed/simple;
	bh=y0uOUq234ldWL3z6Ea+dQDwB0XlUPi+U1mEpXo44f3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rdvAlBkgzAytw2DxPyxcaoyYsooamGJkcOuoNjhJQ/+Nt3riZJOwUcWHvyYoH6j3cUdSC7xZbMWsKQHNYLvfK7ju6/sKihB0+HYIms+bKmuzB5MmEJpiAz0asgelLMghyC0qjT0DOFFckOJ3BAcghUKI+FsA9/IkPckD65N8Hrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ss99cpcR; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-83ab21c269eso167111439f.2
        for <io-uring@vger.kernel.org>; Mon, 04 Nov 2024 08:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730737009; x=1731341809; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BNptXqIVzgInq4GPdAgDKcgD1UpO1H+iAxsVlodZeLM=;
        b=ss99cpcRXB+kOVKAzNCuZ5xcllr1yymm4f8EiIHnjNHNBh858sCrEaN3kGliaWrVZR
         IR6b6rxLq5FNzyQywhre6kXQ1cdcydPw69TWb+3JgbuW7eZC0iPqtpJ19NsfQkYsTgR2
         36nvw9VZchpteMe4+T3hZmhGJEVCVRiMYOVJ04cF4gHEbCSyplvkDBPzgp0kLJbmyQ61
         STtjiEDIKbAeXojLKOmsB8j1rCIFfhjP14ZHI8NC0iYBoNqM6B1xgtDjgYCHcnxIUHdW
         XGwIel0FQqxBb7UFcEa2wc3UKwBENv40R2a6BdleBCXOYyAWlZ2/xNuJGTm4U3x4nA36
         9gZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730737009; x=1731341809;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BNptXqIVzgInq4GPdAgDKcgD1UpO1H+iAxsVlodZeLM=;
        b=ZTtWNogT0CTTDmi8iH9gAWKCErZZGtP3PfM6Lxlu+G8CPb2mGqTSt5NrHcpNUwyfyS
         QXy2+Ji+NuA/dY2WaRHpTjbO2P9I/sI0um9y9gG1m+/f3dyahF+NNaSqccHaD8rXqVml
         zNhE168HXRMd0tppdOofKLpX/uwNy//S3b+6zYjeoOsszIRD9M+lzV4wtMyt8k/mVK9w
         eI0DaSZPGqkwaiLrxGVpsumdcANLa4rB0OHBBWadwJ0SCmfCTYoBI6naBUkIIvjDkJOW
         Rid9FcdzvPday/LErHpUURCzcC+FaBgnhPHWLM5XfRrVfM3SM0n28AsVE8UnQS5uLKFE
         VwoA==
X-Forwarded-Encrypted: i=1; AJvYcCUHc/jIjt1kKy3PUrI+KJ9sD4QqEcIdQF3oB4kxxRtWulGZkwh/ybLBD6sv8pLSR7xVZp74M6swwg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9/wlzyNyvPwMrz7htgHjqBw9YI7wBI9fjjhaAOOmEe4T54Ehj
	WK2rXVrcJoHenccUGguQWGzb3KqrMVP0M8g1PW76w6KM0az33MYvXzYwoZdCxVMUGMcoxRjkvM1
	+7Ew=
X-Google-Smtp-Source: AGHT+IEWoidbU4pmEIuu99c4Np++b8q4r+LQBPx3HjnAgEsOpxF0Q4GpXUz3yvca47vmtWBbpo0Gaw==
X-Received: by 2002:a05:6e02:1d9e:b0:3a2:7592:2c5 with SMTP id e9e14a558f8ab-3a6b031a2e7mr125886805ab.17.1730737007468;
        Mon, 04 Nov 2024 08:16:47 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a6bd51f610sm15003375ab.73.2024.11.04.08.16.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 08:16:46 -0800 (PST)
Message-ID: <8e84b4ee-e94f-4b78-bb94-89ea2ad00996@kernel.dk>
Date: Mon, 4 Nov 2024 09:16:46 -0700
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
 <573a63c4-0cb7-4ecf-a4b1-b1b0e208020e@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <573a63c4-0cb7-4ecf-a4b1-b1b0e208020e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/4/24 8:41 AM, Pavel Begunkov wrote:
> On 11/3/24 17:49, Jens Axboe wrote:
>> Rather than store the task_struct itself in struct io_kiocb, store
>> the io_uring specific task_struct. The life times are the same in terms
>> of io_uring, and this avoids doing some dereferences through the
>> task_struct. For the hot path of putting local task references, we can
> 
> Makes me wonder, is __io_submit_flush_completions() the only hot
> place it tries to improve? It doesn't have to look into the task
> there but on the other hand we need to do it that init.
> If that's costly, for DEFER_TASKRUN we can get rid of per task
> counting, the task is pinned together with the ctx, and the task
> exit path can count the number of requests allocated.
> 
> if (!(ctx->flags & DEFER_TASKRUN))
>     io_task_get_ref();
> 
> if (!(ctx->flags & DEFER_TASKRUN))
>     io_task_put_ref();
> 
> But can be further improved

Avoid task refs would surely be useful. For SINGLE_ISSUER, no?

-- 
Jens Axboe

