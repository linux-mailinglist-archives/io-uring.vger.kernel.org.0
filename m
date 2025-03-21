Return-Path: <io-uring+bounces-7181-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DCE6A6C41D
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 21:24:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A842484655
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 20:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FBA3230BD1;
	Fri, 21 Mar 2025 20:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lQ9fjajj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8C62309A6;
	Fri, 21 Mar 2025 20:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742588638; cv=none; b=Gyz6ZxFEfcOeFQuacW/vX/P1XhB1z1moGZDfatGHBeONKWpdxAs5Wo2NUEYt1Nl7l1GjCJY4Q4A1ymWEjrqEdwXKGitrRjLyONXkD92Adxpgl8CabSSr7LskZUo9j0ixLvYb/UseUaKzBMkBmZaT7BDQRRBe3fFzsggIzW9EkIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742588638; c=relaxed/simple;
	bh=FZPVNC1hAlqDTDyrlm9WoSjlmfBUINapL7lp89sBvQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sXW+mR01pgEHDeyFAn+uYieLJHeZaytY69cg2Lrvv4GAp8p3aM3IBxdoaObcTqMIHXqGi/jpsCFAIQvryFPnRCl6frQOW2vGqSYZurr/I7R3bDXLZpw/KV7PihLGUCb+S4J0wW42dxSiry+9qh7w+xHKDU/YOVGUgO0BlCWfsn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lQ9fjajj; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ac3eb3fdd2eso261972066b.0;
        Fri, 21 Mar 2025 13:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742588631; x=1743193431; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=98i6jddSp1LUQoUVE86JTvhDACCODQSOsoi4JvJF9ns=;
        b=lQ9fjajjf76ESxzMJ7vcAs8JaWQqr0OaHQLADrrS9IBtv+AVtbjD6GywOtGP7rdFoW
         AUQ4itqQsYNSNAIprTDKSgyC4sruled7yhbWnAJm+Cit88nYbYL1XUYz55sAKv7ZoUvv
         S1ipGjKDiqyeF/XbcdtXThRMX/N7zPKH7UIKr3YBel9VN06nQVy4f5zLao5XLBHBBuOy
         FUSC3vyo0LqjMkNY6unJSJQO35vuPxY3NhA4tBqmYz3JcgL5suce9EJKBzHtpztTvfE2
         lOx/lRGds7FFsAo8Coxi3Cnav7dQtRZJ3mToVujdgPCujWmBv2fGK0P8dyh5DYHBv20J
         QoDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742588631; x=1743193431;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=98i6jddSp1LUQoUVE86JTvhDACCODQSOsoi4JvJF9ns=;
        b=trKkVfI1fsTIK4XtTYLyl/vfLRy5Ko+3p6+eUtS+YxQe6lG8jJCPYZV8KSFx66zFMN
         FNoi1U0u0I6VdmV8MmNxXy9blgbzVpQuwyepDyo7kusiluKgALzESO3Py67hC8oZ318i
         PvdRKwS0s3o7zKKhK6FseDkS9z9y6GMPgoUOPWFmNTCRW0HnQyiWnmTsrneY2tTlW+77
         75i+Ei1wqdd+KcRkrBONDcTTUQ9l7XJRtJ5RHvcVLS00FhHuncxrgwd+WjCwGM0VReL0
         P5pQhotQuozr0FudbE+SYRG1plPKsfAT/FqPA/vbWpudo1VOUr3bpKUws5wEYVGM9qbU
         vj6w==
X-Forwarded-Encrypted: i=1; AJvYcCUl6NOIyS1tC3M3LONqi+F/+DF7Sc/xeXgUKUA4i/oWfcqRfFCaZM1v0tW12SoXGksSGJBPVJqNgBfKia8y@vger.kernel.org, AJvYcCV0YiA3yRRx28I8sHsthayjHWxSw5QdZOcNLXK1+AGkP76Ol1HYBgLxftf3qqHluMJLsIX3gXnbgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxupUPhJ21dZuvr/bbOs1uSx3Gi2+9r377vQQpKw/su+vZYLF59
	bQx95NCdRLGagmTyPM1qAp2+0/NHuunWJQ2wE1NVCoUTHDXN9gKN
X-Gm-Gg: ASbGncsMQ6uHenrL1qSyp97Ct2dpoJfJnNs7s3ylIZ1gwMxkydKWJY+PBiienh4VBoR
	4fyaFx53/47NVfrgYXH1yrC2JdGi28Wpo8xeJ/7P9WAQI6jiaz1yEtxYJPNardrqPAhaPGsTrhy
	NI5ooLW2l+ljefc7x3G0I2t/RjKn4skmSf/dGBnnk/GtTeouB1S+VH/UZheSh2bMSFWu2Q7SDsw
	lm1OsZfo39sHZ/GJbrNhijaw8aUa3A1yi/KA/kgdzjfxFPMrenOTzQS4nCcrogoMZydmOWCmJin
	ulwX6OZkjwa60Q0aEjRK8+ZI3018wR9OpNCxogkPOmf7Rnnoiv3v8w==
X-Google-Smtp-Source: AGHT+IHUOzcwaXlpNWBFMCvXm29GsUaXBZabenP63aTlTLUFy9HWP8Is4hA3JffnNo7TVQo1z8BGCw==
X-Received: by 2002:a17:907:3e8b:b0:ac3:d0e4:3a9e with SMTP id a640c23a62f3a-ac3f251f1fbmr460422266b.43.1742588631294;
        Fri, 21 Mar 2025 13:23:51 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.236.254])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efb64b06sm210671766b.94.2025.03.21.13.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 13:23:50 -0700 (PDT)
Message-ID: <5588f0fe-c7dc-457f-853a-8687bddd2d36@gmail.com>
Date: Fri, 21 Mar 2025 20:24:43 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Consistently look up fixed buffers before going async
To: Caleb Sander Mateos <csander@purestorage.com>,
 Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>
Cc: Xinyu Zhang <xizhang@purestorage.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
References: <20250321184819.3847386-1-csander@purestorage.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250321184819.3847386-1-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/21/25 18:48, Caleb Sander Mateos wrote:
> To use ublk zero copy, an application submits a sequence of io_uring
> operations:
> (1) Register a ublk request's buffer into the fixed buffer table
> (2) Use the fixed buffer in some I/O operation
> (3) Unregister the buffer from the fixed buffer table
> 
> The ordering of these operations is critical; if the fixed buffer lookup
> occurs before the register or after the unregister operation, the I/O
> will fail with EFAULT or even corrupt a different ublk request's buffer.
> It is possible to guarantee the correct order by linking the operations,
> but that adds overhead and doesn't allow multiple I/O operations to
> execute in parallel using the same ublk request's buffer. Ideally, the
> application could just submit the register, I/O, and unregister SQEs in
> the desired order without links and io_uring would ensure the ordering.
> This mostly works, leveraging the fact that each io_uring SQE is prepped
> and issued non-blocking in order (barring link, drain, and force-async
> flags). But it requires the fixed buffer lookup to occur during the
> initial non-blocking issue.

In other words, leveraging internal details that is not a part
of the uapi, should never be relied upon by the user and is fragile.
Any drain request or IOSQE_ASYNC and it'll break, or for any reason
why it might be desirable to change the behaviour in the future.

Sorry, but no, we absolutely can't have that, it'll be an absolute
nightmare to maintain as basically every request scheduling decision
now becomes a part of the uapi.

There is an api to order requests, if you want to order them you
either have to use that or do it in user space. In your particular
case you can try to opportunistically issue them without ordering
by making sure the reg buffer slot is not reused in the meantime
and handling request failures.

-- 
Pavel Begunkov


