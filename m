Return-Path: <io-uring+bounces-5873-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C82BA12431
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 13:55:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27529169673
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 12:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34C442459A9;
	Wed, 15 Jan 2025 12:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h7awR7Ny"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6402459A1
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 12:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736945709; cv=none; b=mQ2SswE5tDApS/l6dZ/onIKEjlAuZ4DaFOLSANRSAJC7Mwh6g45swKSThfFneMWRGspWGQqH8faVbS4KBlOfVEQolCne7sYzbUYN/NdaffJEr2LnmTf5b2Jv+GprD0KhRxG0NPIcGQvZxyjhDkSWWTqVqOFqOqHw4PSxgUjvwsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736945709; c=relaxed/simple;
	bh=2ETBJ9R0VXX0vNF/SecuIXPRy+KC1FhnsrfU2DJbvh8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RIFPN6Hkgdi2EiHYPNsxLKsysF/69WSh5WDm5jb3mw74+ROq9cx9wsd+dNdq16KxRjcfCktPkOpt7HPs/w+s7PORf/lDbvcPY3UyVQHyHptmfMf8bost3v/XnB84J3Objpcr34x86vNAi4Uz2L1XbWHdn2uGUptJIsZ6iwVFZRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h7awR7Ny; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aa679ad4265so171094466b.0
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 04:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736945705; x=1737550505; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N1iHONOCza+os8UxbeFa/qAOR/we0+yHQ3rLJfNaRPo=;
        b=h7awR7Nyr2oxIiOkUdFMzPzHluV1JfHklMUXEuh1izXT7r6T69PUalmIBqbsVKUBpv
         bbALcLwtCYi0fNGlfGGqZYGAxuoE7yZGwRBUsdhOiXeRmKw6MOFqc6tEyO6Fe86PJKtS
         mCrsyXzOcKhhsB62Lb4wRFap+Tv+maioEKTDSUlr95T/khjfd4yBG6ABMwLewi9F/h5I
         bgDYjK9tgThhgBeI2wZZs7LIJgPIddvvKucTMFjLM8NwLphsNdktFKbzBiXYJUeMA0jc
         od9TdRfuoc5kpOkbsy3wAoOZQGbFJ3GMzLbKorq5asMe7Prtx+W3XVV9E/mKo/Vr6XJg
         +aNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736945705; x=1737550505;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N1iHONOCza+os8UxbeFa/qAOR/we0+yHQ3rLJfNaRPo=;
        b=fLcZflz/s0fyHJ+aq28N7x8nQ3+L/2EQWferfGj4vmYbYttCGzZVEA4j+zo3l30YSJ
         je4YGSp0ekJrvCj6L6nhURGwmVDO7gqx9d75yQ1ghxE2m+ug7qj3eEIUp8zSA54OE3T8
         Lr0j4EwSVYBvynQuXPSHtl6Oj8pC42ze8rGdgE1lThgsMaAuVXKddfReAJWb4HTZ7nga
         VCfb5ssXFSFjSP7oG6gSU+jthrmE7u7IJl5jJvJktzgKo+/G1ptH9lIyXRd8vLMDxEEw
         P7Vrnch2aJ3GoMMGwYX7Ga6bi8RQAiDleH6V0fMIfCTJRJVEmKX6YcDqSoQYvx0+8W7M
         mcuw==
X-Gm-Message-State: AOJu0YxUWS5YDog/hOr0pMnk3Yqq4c7YfePYuQtA7PalTHs7seA+GJEB
	ZHcI9Mr80v9YLo8mYYhKP/dDyh1r3m8gB5CDWS82OIeWr9SFzFtn
X-Gm-Gg: ASbGnct1+Bcpgq8SrAVKF60TuEvN2JlEWReTQT8hZutIdLhsDaoARGb8sVHXT8FMkBe
	vt5ZDM6D0ev7A8F7wdFttjW8kcKJsnrG8b+QYVjfSxKM/FBzpVaGCZVCMa780KCWG0A70bUUvkJ
	ZfuA+Ipt+v2/YL+yuExqhi5BwQBNf7Ej+PCu+MjWs3iotinawp2g8rmK9TQeaOkdgSmAdGtQDwN
	aUSm6Ham9SUmlt2cUIko1NVmhnyYH8BkBcpgMqIcxULisUfwtzqcYUyNEWJyJn21xA8HnGfID0u
	gE3fLAEzs1chEQ==
X-Google-Smtp-Source: AGHT+IFGwbFBNFMyOQ/FbBTI7ym+oI9LAiQoAAIXNW9x9+i36cRiYdOGga/wrIY91AdXDHszX/j1pw==
X-Received: by 2002:a17:907:7282:b0:a9a:6c41:50a8 with SMTP id a640c23a62f3a-ab2c3c79cf5mr2278139166b.17.1736945705172;
        Wed, 15 Jan 2025 04:55:05 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:66c0])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c95ae536sm751890466b.139.2025.01.15.04.55.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 04:55:04 -0800 (PST)
Message-ID: <1a849a84-0866-4b38-a1ba-1b2810948ceb@gmail.com>
Date: Wed, 15 Jan 2025 12:55:53 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/io-wq: Fix a small time window for reading
 work->flags
To: lizetao <lizetao1@huawei.com>, Jens Axboe <axboe@kernel.dk>
Cc: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <5fd306d40ebb4da0a657da9a9be5cec1@huawei.com>
 <0993bb5e-debd-4513-9481-a7d93f8c3c25@gmail.com>
 <6d68ba2ae0d74895aec47379e94997cb@huawei.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6d68ba2ae0d74895aec47379e94997cb@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/25 01:50, lizetao wrote:
> Hi,
> 
>> -----Original Message-----
>> From: Pavel Begunkov <asml.silence@gmail.com>
>> Sent: Wednesday, January 15, 2025 12:22 AM
>> To: lizetao <lizetao1@huawei.com>; Jens Axboe <axboe@kernel.dk>
>> Cc: io-uring@vger.kernel.org
>> Subject: Re: [PATCH] io_uring/io-wq: Fix a small time window for reading work-
>>> flags
>>
>> On 1/14/25 02:06, lizetao wrote:
>>> There is a small time window that is modified by other tasks after
>>> reading work->flags. It is changed to read before use, which is more
>>
>> Can you elaborate on what races with what? I don't immediately see any race
>> here.
> 
> There is such a race context:
> 	
> 	worker												process
> io_worker_handle_work:										IORING_OP_ASYNC_CANCEL
> 	io_wq_enqueue										__io_wq_worker_cancel
> 		work_flags = atomic_read(&work->flags);	// no IO_WQ_WORK_CANCEL		
> 													atomic_or(IO_WQ_WORK_CANCEL, &work->flags);

													^^^

That can't happen, the request is not discoverable via iowq yet.

> 		if (work_flags & IO_WQ_WORK_CANCEL)	// false

This check is for requests that came with the flag already set.

-- 
Pavel Begunkov


