Return-Path: <io-uring+bounces-10106-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B9E7BFC6BC
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 16:15:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B29F5E7AD1
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 13:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE9D342146;
	Wed, 22 Oct 2025 13:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GAKMa8nG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9414426ED20
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 13:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761141369; cv=none; b=HE2wHxFusNV8i2PIi+h9K0zjCgSpiGDGWoVIfjesuev6jby/Oci0USgBwVKLnPeLzC4uFfZfkkkXR9leHQOj0DlCpHHixrbnnKqcgrBZZKV52YxOsTz+3f1crIDBTHu06R8bluNlYEV81iUDbklcaC9FWsKpjkBRfyf92b5QDxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761141369; c=relaxed/simple;
	bh=q1ki8CD4ekrzwYx4pxL9oVk7SvLipatLHZsgTCrTRA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hTrljkSjFPvHBX3MAP/+puAbTWgS+Vobq66S750StL1YD9BulKhnFSAwCBN1aeyg4lNh8cdL+McRBYLKYMvnRn0+elcyfIxfqGbhbtEebPwSWPxMhEPLAMMoQZMLA0oaP4ZquviVcL2OoFgrZD8eOdImSIx/tEWk6FI7a70fmUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GAKMa8nG; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-93e7ece3025so49714839f.1
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 06:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761141366; x=1761746166; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4j8OyvK6t30KOQVtEJkqYDEQ/5UHSwAhZ/4iCsZyPjY=;
        b=GAKMa8nGSMnO++8exO5sasXK9+HsH2orGXN3gHKIyiD9UVoykXjx1LfOCH+IR6u6+k
         PBewa/1atnD2avjKi3Ovt9/jwex83IN0VU78zMQZt0qqknz2IoYEIa+lx4edIxYauD/5
         s/2EX1qN6GvrMFYXZIvaaTIjofNeSpV5HEBWUu0iZt0jfS+/LDf9TxQ4tOYglqTPxILn
         s66+yAbiZeVylRPd0GfMIYdOVA484YiQmF1VQjPXBjtflAFR6MUP2TpLlngfu4Nb4/4h
         WmDNP11NYY8dlRgPmc8wfwnflvT4eQUZuAyOzSYthC0CZCWoJ3yS/g/J5Bqd3+CRjJyJ
         +fxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761141366; x=1761746166;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4j8OyvK6t30KOQVtEJkqYDEQ/5UHSwAhZ/4iCsZyPjY=;
        b=uHAcSXP0qkTa+p/WZBbG6QX+q01assxRgQfFcerquV80GshGI2A4eSizsIJWSJA6ON
         RGDv2JNVTOBXodcIzUMl2MtJg2TEcAHWTrAQrczS2erWJy0pgCBSzGeaaZIJ46Cmkf2z
         neuwSW6682onM8YP/FxjdW1vRizREL65w00WEFo3zilpS3G3rm6APwT3Imgf172hjusn
         0Z6I4DGFkmhyiL1OxSTgfEYsNZYkXwnS30nXGT81bABpsaB5XVIjuxFg7HF7qWo2N5kE
         9V2gnBOwFY/gBAMS6Fo9mtVAdEsxhz++UVeXnr8IpkH4Oqn9QA2JzJfgusVbhyQOKptC
         PQRg==
X-Forwarded-Encrypted: i=1; AJvYcCXYkST5L5biEUeB1rp9hZnljdMWwekAlb5Tta1lm1DZUziGCbpzbizREVmTe3CErBQDaPzSIMOBnA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz5gTB8ukDH3q+UjAcoC9Ns/JeGTmofYbHzTNu2or4j+CCkxYc
	yXNlVgzXZKoM2b1TSyyVQby6aUtzcQWgVUuq5XAhBFwn0XY+hFkr7rEtfPx824exso8=
X-Gm-Gg: ASbGnctlxFNCH5+ldor5fUTa6xrQeSQBXjglXUwtR7DtyXYkIipHu2GrclLAzEr9Mkc
	YtXU/mn/EHKN5a0XHLS70Rv8CdQAu8D/8rRw9SLCjkfmFloaA9HMZtw5v3xKC7Ep1xQnlFs7IhJ
	Gp+eZkmqQllTz8bAU9gutUtGWWShNTwdOIKvgOAk+PUqOhXn6gpSbRUXzTOURwIv7Jw8WHXoIz2
	rYHyRaCih2jWeyB3VNNgomHeywfjgT70NeA4+lEOtZHj9Crpq4xJIZoWNTXXTej3e2YFQYIWEA5
	HD9G7WFi1K7QAHN6paOHvJxXbU6Yh4EC/G/uMTTaJDrLcsRDv5yAmUnD0gBReYnoSY6dYFubF4k
	lqHvS9WXpYoHdXUIiBQ25uWwXfudxjSlzdbYuqos2FV9ttLHPHFri7IZZnvQHqiucSAl0XV0P
X-Google-Smtp-Source: AGHT+IGqifK929VZxtAIG4ZTGbov9xEtXX9LbfMYUADx3IoiuG6LKNs/gy7l9IYfTZVTiCEg3F0B7A==
X-Received: by 2002:a05:6602:3058:b0:93e:8b7f:5af5 with SMTP id ca18e2360f4ac-940f9a7ae60mr143932139f.7.1761141366423;
        Wed, 22 Oct 2025 06:56:06 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93e866df2eesm528069539f.19.2025.10.22.06.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 06:56:05 -0700 (PDT)
Message-ID: <6a3f7489-5003-4fe4-839f-f06019ba2f6c@kernel.dk>
Date: Wed, 22 Oct 2025 07:56:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6] io_uring: add support for IORING_SETUP_SQE_MIXED
To: Keith Busch <kbusch@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, io-uring@vger.kernel.org,
 csander@purestorage.com, Keith Busch <kbusch@meta.com>, llvm@lists.linux.dev
References: <20251016180938.164566-1-kbusch@meta.com>
 <176108414866.224720.11841089098235254459.b4-ty@kernel.dk>
 <20251022120030.GA148714@ax162>
 <4ea25979-4fc2-4db7-8656-6c262af2cbee@kernel.dk>
 <aPjhwxTf0wAw_eaW@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aPjhwxTf0wAw_eaW@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/22/25 7:53 AM, Keith Busch wrote:
> On Wed, Oct 22, 2025 at 07:34:22AM -0600, Jens Axboe wrote:
>> On 10/22/25 6:00 AM, Nathan Chancellor wrote:
>>> On Tue, Oct 21, 2025 at 04:02:28PM -0600, Jens Axboe wrote:
>>>>
>>>> On Thu, 16 Oct 2025 11:09:38 -0700, Keith Busch wrote:
>>>>> Normal rings support 64b SQEs for posting submissions, while certain
>>>>> features require the ring to be configured with IORING_SETUP_SQE128, as
>>>>> they need to convey more information per submission. This, in turn,
>>>>> makes ALL the SQEs be 128b in size. This is somewhat wasteful and
>>>>> inefficient, particularly when only certain SQEs need to be of the
>>>>> bigger variant.
>>>>>
>>>>> [...]
>>>>
>>>> Applied, thanks!
>>>>
>>>> [1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
>>>>       commit: 31dc41afdef21f264364288a30013b538c46152e
>>>
>>> This needs a pretty obvious fix up as clang points out:
>>>
>>>   io_uring/fdinfo.c:103:22: error: variable 'sqe' is uninitialized when used here [-Werror,-Wuninitialized]
>>>     103 |                 opcode = READ_ONCE(sqe->opcode);
>>>         |                                    ^~~
>>>
>>> I would have sent a formal patch but since it is at the top, I figured
>>> it would get squashed anyways.
>>
>> Indeed - I'll fold this in. Keith, can you add an fdinfo test case for
>> mixed as well?
> 
> Thanks, and will do. Any quick hints on how to ensure fdinfo finds some
> entries to report? I assume I can just put some entries on the queue,
> but don't call io_uring_enter.

Yep that should do it. You probably want to do something similar to
__io_uring_flush_sq() since it needs to be visible on the kernel side,
by having the SQ tail written too. io_uring_submit() does this, but
you'd want to do it without calling io_uring_enter() to submit the
entries.

And then probably do that with various states of mixed sized SQEs in the
SQ ring and verify it looks correct, too.

-- 
Jens Axboe

