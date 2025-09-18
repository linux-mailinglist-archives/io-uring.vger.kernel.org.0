Return-Path: <io-uring+bounces-9837-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72888B87643
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 01:35:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32A4E2A2C23
	for <lists+io-uring@lfdr.de>; Thu, 18 Sep 2025 23:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47D4E34BA4E;
	Thu, 18 Sep 2025 23:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RK+fPian"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638161B394F
	for <io-uring@vger.kernel.org>; Thu, 18 Sep 2025 23:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758238552; cv=none; b=EcnZ5K9C90Y8I9XvaIT4s9YaSXRl8kpiWnm55PZ0ApIi5ONebJ4sOqKRxYqAVkxmAvw28v2jcgJhiPvGoZq82KtLsQ0GtsQcdnkqdP+Rk4EswmousirKz0TYJ8yjEdwIEOzW0lz+ksuY9QoxB7XFvBOQggOuAKDa9yfCjjlCJDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758238552; c=relaxed/simple;
	bh=20u0B6xmGhNJ7bnzjnhWcAwVuOTNNS2Ihd+UFd7ZnRY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QQOJNysC1yiisyj55W8IbTIUuiVwz+rNJfJab4cRZRfekpq8FdxXJqmnv//eNtwuFpGVOE0f5WjoOfrY8lOe89kxL9czfeBYhMVHicWa6ifwbtiU9IYrgXCjoNawhtXHc81EBaN2jhKDqcy4H/TixmLzxRw7mINTARQyz7pedSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RK+fPian; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-88432e60eebso41842139f.3
        for <io-uring@vger.kernel.org>; Thu, 18 Sep 2025 16:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758238548; x=1758843348; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oxT0O7JcOSehGWMpesCt13DoOvNrQRrZV4HAusoAxSk=;
        b=RK+fPianB+L6cnGhdJx36c1lAJMW6X4od/IrF8FZNsFU8Zxs5JVa6CgFGh5QFwGqCZ
         +11W0y3VN4vYfVsLZYdGPDOIbPGJZRbwOofrZsFpWitq2LOI/2x0yHVQoBX7alL1rtPV
         2expNhfwKXvl4YpuTAb5K9gmNps3O2HhEFa/7gYzye80+1KaZtKxAYsxwSmB10rfUacp
         1I0qLu3JpXUYqb9+BVaKAPcUxmHhq5mNc6EFPRRlKqD+5i+4XGn7Vtao4+YwwQp1xtsE
         mt5agjQmPE2id+hRvmQnLlIMX7kubPIOLWvl41UdXYU+sDYLfHVGfd8QnYRQLJ1NzXfX
         bnLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758238548; x=1758843348;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oxT0O7JcOSehGWMpesCt13DoOvNrQRrZV4HAusoAxSk=;
        b=NsMrGGsDLAahQFD/bfCtajU/lvD8GxXymEDgjNLthmEVqqxPhGEjag3xKjwn4TT4+8
         PjZtb7aSc4JheC6ft7pPnni7xHNdNLjm0NN3/QokYHsX9JZWOlAQQajUOTI21TcAmbYg
         yJjNvWc+dTU0ppOwn+6PSw6m8x7OIIlyzdvx1xgZb5+3zuhjp6gh6/uD4gdInMzqF2ZU
         /kPs0Wgk7jGJeymgLBN28E4/TW41hQBKi/qzRT+cf18vwB7VpX9/9mTq1OmaLzH/tCKA
         W3f66ADdEmSzZU2+eabWzkQ3hSVW4VVA4fTItoZP4nwYiyhk6sAhMxrmaLS2QZIAJOuc
         Hi3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUh88Gjq+SZPfQeJZaHOjVlH6d8Lc/DJomJhhH5uclAv+VbcGNGivXV8vD5pH3SZD24KOyN+9Z6Tw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZ3pDIaLVhlAZs14D1OPMCTUABT2CGe+hHQWYdcSOX7iYTV39F
	4umUy1IQOI2aEJAk9TMuTbwDXyof/x6Z0ar88hhBkcEiSNdKxwF3Uo02b1N8Kg/RE9c=
X-Gm-Gg: ASbGnct1lz4A3Six0FS6VXV/u/0IRzD2hwEl+SFscR7GsMjbv70G2pzMy3OlFYH2Ltq
	/uRvxS5EMG2JSOLbKmMSFmyCpn/Eq+aiLOdX2tsa7zzwEr14VBBAah10hCcwK1bg+aNpjRmN4ND
	YtV26H8DA5GVfxbRvyzn6c0dC3U0zgMi5VLmNAtzaDptPjEyhybz/zOWZ/LuRVjO+q1Oa3DsF7p
	tzS9MvBdZn2tmIN5gBv4UGvTZzBSahtmKyZMt0Cdoc66Wt0S8gzx26MT61tmrN4FgFDd8AJiP5v
	u4L9GqXI2A48bZCpuAY2rqfSg1K8uBybHKkoQ9gzJ00irGwJRU/riz4nV69AhzVByZv3Ov5MxYR
	WuQH6Gg1I2aCzvraoeg//hTGl1tEHX1mT2IlFaHE=
X-Google-Smtp-Source: AGHT+IHFhCkN2EgbvKlzJH99aavj3D3bSD1+gk9VDJTxY6BMSRGPTmRnlCGRyC3AP0p0iKYWktRE7A==
X-Received: by 2002:a05:6602:2748:b0:887:1e15:85b4 with SMTP id ca18e2360f4ac-8ade6ee28bcmr188342039f.18.1758238548192;
        Thu, 18 Sep 2025 16:35:48 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8a46b2f3405sm125471139f.1.2025.09.18.16.35.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 16:35:47 -0700 (PDT)
Message-ID: <9a4f5d50-b235-4621-a21d-be8ea0b2c9d1@kernel.dk>
Date: Thu, 18 Sep 2025 17:35:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCHv2 1/1] io_uring: add support for
 IORING_SETUP_SQE_MIXED
To: Keith Busch <kbusch@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>,
 Caleb Sander Mateos <csander@purestorage.com>, Keith Busch
 <kbusch@meta.com>, io-uring@vger.kernel.org
References: <20250904192716.3064736-1-kbusch@meta.com>
 <20250904192716.3064736-3-kbusch@meta.com>
 <CADUfDZrmuJyqkBx7-8qcqKCsCJDnKTUYMk4L7aCOTJGSeMzq6g@mail.gmail.com>
 <8cb8a77e-0b11-44ba-8207-05a53dbb8b9b@kernel.dk> <aMIv4zFIJVj-dza5@fedora>
 <aMIxmiGv5D0GvSro@fedora> <aMLIU19CfgOAuo8i@kbusch-mbp>
 <CAFj5m9Kbg_S_rES1BXRXpaGGnatiEmwEsN+-f4t6zGUH79LPCg@mail.gmail.com>
 <c68af2c8-4b2f-4676-8e0a-d3593e462986@kernel.dk>
 <aMx4AeMtiyUoC8-X@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aMx4AeMtiyUoC8-X@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/18/25 3:22 PM, Keith Busch wrote:
> On Wed, Sep 17, 2025 at 08:44:13AM -0600, Jens Axboe wrote:
>> On 9/11/25 7:07 AM, Ming Lei wrote:
>>> On Thu, Sep 11, 2025 at 9:02?PM Keith Busch <kbusch@kernel.org> wrote:
>>>>
>>>> On Thu, Sep 11, 2025 at 10:19:06AM +0800, Ming Lei wrote:
>>>>> On Thu, Sep 11, 2025 at 10:11:47AM +0800, Ming Lei wrote:
>>>>>> SQE128 is used for uring_cmd only, so it could be one uring_cmd
>>>>>> private flag. However, the implementation may be ugly and fragile.
>>>>>
>>>>> Or in case of IORING_SETUP_SQE_MIXED, IORING_OP_URING_CMD is always interpreted
>>>>> as plain 64bit SQE, also add IORING_OP_URING_CMD128 for SQE128 only.
>>>>
>>>> Maybe that's good enough, but I was looking for more flexibility to have
>>>> big SQEs for read/write too. Not that I have a strong use case for it
>>>> now, but in hindsight, that's where "io_uring_attr_pi" should have been
>>>> placed instead of outide the submission queue.
>>>
>>> Then you can add READ128/WRITE128...
>>
>> Yeah, I do think this is the best approach - make it implied by the
>> opcode. Doesn't mean we have to bifurcate the whole opcode space,
>> as generally not a lot of opcodes will want/need an 128b SQE.
>>
>> And it also nicely solves the issue of needing to solve the flags space
>> issue.
>>
>> So maybe spin a v3 with that approach?
> 
> Yep, almost got it ready. I had to introduce NOP128 because that's a
> very convenient op for testing. I hope that's okay.

Yep that's fine, I'm assuming they'd basically use the same opcode
handler anyway.

-- 
Jens Axboe

