Return-Path: <io-uring+bounces-10982-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C49C7CA8727
	for <lists+io-uring@lfdr.de>; Fri, 05 Dec 2025 17:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B5D71300D5EE
	for <lists+io-uring@lfdr.de>; Fri,  5 Dec 2025 16:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BE1C33AD94;
	Fri,  5 Dec 2025 16:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="r8AYxVvQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4E933970C
	for <io-uring@vger.kernel.org>; Fri,  5 Dec 2025 16:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764953811; cv=none; b=EsKaHaVPaMfpWAUNWE78vdrJkqfHCdYc61AjKR1nIeQfRLGHfssn+bvw+X05+Ic5s1/7kffkRCDMOumNVCMsaEAgbWQY5E75t6AeoQOTGGvq7XfvjcUBSt3ORtY+zeanLDuv4ykhKD9MC4VqVFnp1kRJRXd8u//VmQR/z+fgEHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764953811; c=relaxed/simple;
	bh=fj7yFZxJjIXrS/LxlqCmuGUXGDwKEwAiv/wZ4Avdm5U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FgtdwquXtXlUFX0aiZve0+ZLWSp+EQICLb5MijBrqUmH2rIk3OSxXCdd5XLDw38k/udVT5ur3ZmWHdcOjwekKiQBB+0+DRUfZR80JKJKROU/QjfE0aaYYlLo2QPDdJ5pWTIBbzp/UprHnTkUfhq0gxcW7nBjSdr4OQiFmQLKScM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=r8AYxVvQ; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6574d7e451dso1405419eaf.0
        for <io-uring@vger.kernel.org>; Fri, 05 Dec 2025 08:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764953803; x=1765558603; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9VcIfIqkBfNtDq7nYd7Ilr8KlFO2GAN+ZOUFJXyYqYk=;
        b=r8AYxVvQffmFTnogBbPK1n1cHU/8hzLRhx/AJw4pMH4BeyAdaxb7EZXaJlUUCV1lDW
         OFQI6+v+O7DNsohCHYrZ5hJdQFGO1nOUtY+F8nU6i9/TT+widf6tbPuLKC0CC6Ch4id0
         /9VoTHhmbaQCr4UQLjLWZeQIJjl10Bd4SyyFKm8OssZdDsSXZ+HFJwEJwmzQBSdA5hCE
         DkmUuf1iPyolVziC4tjNuHYBy9aiDKJbimIdRuNhyXU19RDqcb/zeucTsQWi7CLpWLAT
         sm2WDsOhvKfT2XG99wdkhyatvkFeQZjRGl4SrxsokMPmZQQ0qlKHrII6GNJJSOZTeclC
         o3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764953803; x=1765558603;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9VcIfIqkBfNtDq7nYd7Ilr8KlFO2GAN+ZOUFJXyYqYk=;
        b=LDBRsKGqMAeXYbftm/yLhYcI2yELqEbJwRi4i5FPN2TTIPHY6RPJ1tZxlWrbso1cPy
         nxa5Uciif6V6vEDnAyeIlSWDAabQmfmdEV4NlhGxDZYsGyqAqMvdYLZKx7yau3HtFyIW
         j4xHHAgDr84X2otd/CUjQ0WTarfq5zA7No9M1SZrHR4gaIfuBZjBUIPpNma1J9DgM2j8
         9Gl3HmnDfqRONMmVECG9bub6fYuWwPyRxneb6MS00ikolwa3zY1lkgGp3EJEwrC6/NVY
         s+W9ccKcSHqjXLXgYNZESVFEu1qKWoMSfHDW4UeGZXQGxso1nLYyAz9OFFq3sjnHAX3h
         aTmw==
X-Gm-Message-State: AOJu0YyIrVepHUEbJLb2znXDpkauvjnmxHFnd8kWqS4IRP6KzFZgmZKg
	oMCFXhH5fzzELVRvnDSOGyFrpxJ31eBmLFBiCQlAS515wOxk6Blvnd4yyzCot1X3QEJVBRHMog0
	mJPJ8i34=
X-Gm-Gg: ASbGncuSsg8yzfnEQ+Sn1E8Ugk493Fgex+RpG9I6y+UkUZ4mAJ8LirOQpl4Ns4SdDtX
	kKWBAEPJQ7U/5+CJ7w8XTKtNRmc0UV4ckGMmjm60jkSpQm8L5QltQBR7s1uoi7iKxgjTDsT9X03
	tJF62kNTnIIMcNq0HT1mUl1Dphy+TOv8xm4b3K9LlDO0bKOF8IuXKL3Tt7grVO4+fnVtFZgj/S2
	AiIrI2QRJE96lglH4cC9gDIPmBwLPWDvnIj0OU5VEMOHB5v8ihkIXPUlBRVCp5suhy4YcHv9lKV
	Im2zTQxmFZUIeAum0VNTZA4Yq4GloHIFlTOl0BkHfl56A9Lpmnzh86xIG5/PNEIKwx3CuJsEMY1
	cLu3bAmFOuKXv/oLhJBuDkCRW8I2jlKzqWlqMrB6nzN2Vp2orovN4jTyTLM60ImtgfpPLwWN32U
	PFSGdxHe4=
X-Google-Smtp-Source: AGHT+IEyqkZMEi8r1z1Nl2B4gYD1zPnB8cGhsXu55Iy2Bw20cTaW+/CG2Js4pn8gxCQduYT/Jz/8rw==
X-Received: by 2002:a05:6820:81c5:b0:659:9a49:8f53 with SMTP id 006d021491bc7-6599a49afe3mr1294eaf.24.1764953803486;
        Fri, 05 Dec 2025 08:56:43 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6597ec61d03sm2446593eaf.8.2025.12.05.08.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 08:56:42 -0800 (PST)
Message-ID: <423d79a4-a825-4e5e-b695-099ec7e6c883@kernel.dk>
Date: Fri, 5 Dec 2025 09:56:42 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] io_uring/kbuf: use WRITE_ONCE() for userspace-shared
 buffer ring fields
To: Caleb Sander Mateos <csander@purestorage.com>,
 Joanne Koong <joannelkoong@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20251204235450.1219662-1-joannelkoong@gmail.com>
 <CADUfDZrbZj+fqqzHddWVjHvhwS2GmUzKTWgknhDLdRt2_ufr=A@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZrbZj+fqqzHddWVjHvhwS2GmUzKTWgknhDLdRt2_ufr=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/5/25 9:55 AM, Caleb Sander Mateos wrote:
> On Thu, Dec 4, 2025 at 3:55?PM Joanne Koong <joannelkoong@gmail.com> wrote:
>>
>> buf->addr and buf->len reside in memory shared with userspace. They
>> should be written with WRITE_ONCE() to guarantee atomic stores and
>> prevent tearing or other unsafe compiler optimizations.
> 
> I considered this too, but I'm not sure it's necessary. A correctly
> written userspace program won't access these fields concurrently with
> the kernel, right? I'm not too familiar with the buffer ring UAPI, but
> I would assume userspace is notified somehow (via a posted CQE?) that
> the io_uring_buf slots have been consumed and are available to reuse.
> In that case, a torn store here would only be observable to a buggy
> userspace program, so I don't think we need to add WRITE_ONCE().

I agree, see my reply from a few minutes ago. But I do think it serves a
documentation purpose ("shared memory is always read/write once"), which
is why I applied it.

-- 
Jens Axboe

