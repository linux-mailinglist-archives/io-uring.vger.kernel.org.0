Return-Path: <io-uring+bounces-5719-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C54E5A0352B
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 03:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A479B164498
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228322AE90;
	Tue,  7 Jan 2025 02:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="l9SopVA9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB7A39FF3
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 02:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736217192; cv=none; b=W9M6A4dXlX1UGB4Ebg1K0Pu1mXVMoHkMpzQb7AHUaHl61V2dPJciEAu6Hr0kvOa5srrASQK97YiSSdImAyvx1XucqYoBGNjoBg0RgSGJVTSRLw894xoc70ZrwleHTzoC1M2ujJE5VlXnvjMMisn4hCVsI/7a1irXmaPjD/LhdxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736217192; c=relaxed/simple;
	bh=ZsSsEZKHRdnIi511g/rJS0yTgjwUV3K3oAj+xrlPOyU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=gP65eJjHsngXeRNU2RiNCAIY3XhvZS0V+Vp3Sq5ksVaHtpH1CsWh/8nH6TK1fRynP5EHKW/XPuYVRqUndHUKARqcMTENBXlYDU7upejMP6W7fQoAOW7jffnx1p6+KR9MYQ/OTgtv+F9qv0xCm41XJg79c0lR1zp6azRCVS597U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=l9SopVA9; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3a813899384so58042105ab.1
        for <io-uring@vger.kernel.org>; Mon, 06 Jan 2025 18:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736217186; x=1736821986; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rNiBYrsHAL6YWEURVoXDaY/TAujYtnLraBnR91xzwjI=;
        b=l9SopVA9LShxahMWHyTi2OneOIMJyRq4+hDOkdniv6gMh5QHPuP19NdLrU09kNhtnI
         LEJ/mRc86cSuggcx8RLI3wc1RQSRv5ZrGXop1SYsHZ5ubb1bpe9NvqQCebWm70NkpnLB
         oSKQJ07XpPKspnp9Jvl9Ilx9+L8hwK16tFB5e/yveyH18Gzl6knIIztThLAnePYOxEnT
         rxyIqB5pAjArs8ZX3Anwckfn77Eudd/0GDyAsLvCPkits4MlmHwLEt9JypfoRtcVp3Mz
         4xzHHa2AV83g3SGo7CvUOAFLgD9iLNurhpAx8w3g2aCcoA1zPTczNU0ifS1ck+mucDBm
         B1kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736217186; x=1736821986;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rNiBYrsHAL6YWEURVoXDaY/TAujYtnLraBnR91xzwjI=;
        b=KmVnGeSNKZBvKps4RKpDNoTLB4X608SoNiPnGUBFT2zKnb7//QuQYl0IDYyzo8oBUb
         zHtJfOl0rFbpLZvl2wnCkI99a/iZXMors4JtgHfMkdxr9nz9Wt15cW5rMBNQ0gqAZawj
         vQqk+8bVeBIb5WuMjLgJvJPDtU2XQUQipB5hlgLnn94GMNzR/zlaE2nphr2NhKBMz/GH
         T+Uc/6kXYs1XQ8C7wWEzUgA9AlKsEGiv99dAX+lpAvuj2w4laL25OgbYyHzeZYyBgaFq
         7xjkwv+dZwXisY08qRolP4g0M70Mk/ZUSjrxdniDzjezJb+0wW2yVF3w0a/aS4XQDMJz
         EHpA==
X-Forwarded-Encrypted: i=1; AJvYcCVifsnobn/XZYZ6DEsMAyfBz/gWk0nZMcOTeLKlDNM+bJ42LumjMnUQXbEo2NfMmwficn/ECZxo1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3boApzBSn9Sl7nC84YJKKH6xpi8K2oSzmelmpmPnpz/S79/UO
	4lvutr2ZO+4jpnyXPEmhZmz3qrXtA6z3UQUyDI2Cnx62IU7n33Q9V+gSy6zY3g0=
X-Gm-Gg: ASbGncsWAmWz7x4OGSwT+Q+E/JIJkURs44A6KuKBHSiZ+rqDTTEJ0r6GO16RSgW9PNm
	x/WvxwPXJ02PUUHIe8I7zn0rLXJQqXzhnEtUca7ss8xkUk/keNKVDLwoFU94XMhMGPsct+EK71j
	9MyGqAmeecpccBDq/8WJ8cYko/JU0bieCJhcul0DXvdsYAOnMkh9c8VGkK/7jwn0CYF/JAdOHk0
	bEC526ciWdoe+uz8ri9mJIXt4XPoTY8XcIBzP/DFwJPH/ZCaNqOag==
X-Google-Smtp-Source: AGHT+IHctLqwmFsbcK6ASUJEd75OoaVBuDOBmJvGZE79ukigdQ8KGKkiwpkibOgJcgb15C78ftLBZg==
X-Received: by 2002:a05:6e02:3d03:b0:3a7:d84c:f2a0 with SMTP id e9e14a558f8ab-3c2d25669e3mr445866135ab.7.1736217186392;
        Mon, 06 Jan 2025 18:33:06 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3c0df949b6bsm99961885ab.39.2025.01.06.18.33.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 18:33:05 -0800 (PST)
Message-ID: <da6375f5-602f-4edd-8d27-1c70cc28b30e@kernel.dk>
Date: Mon, 6 Jan 2025 19:33:05 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug? CQE.res = -EAGAIN with nvme multipath driver
From: Jens Axboe <axboe@kernel.dk>
To: "Haeuptle, Michael" <michael.haeuptle@hpe.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <DS7PR84MB31105C2C63CFA47BE8CBD6EE95102@DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM>
 <fe2c7e3c-9cec-4f30-8b9b-4b377c567411@kernel.dk>
Content-Language: en-US
In-Reply-To: <fe2c7e3c-9cec-4f30-8b9b-4b377c567411@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/6/25 4:53 PM, Jens Axboe wrote:
> On 1/6/25 1:03 PM, Haeuptle, Michael wrote:
>> Hello,
>>
>> I?m using the nvme multipath driver (NVMF/RDMA) and io-uring. When a
>> path goes away, I sometimes get a CQE.res = -EAGAIN in user space.
>> This is unexpected since the nvme multipath driver should handle this
>> transparently. It?s somewhat workload related but easy to reproduce
>> with fio.
>>
>> The multipath driver uses kblockd worker to re-queue the failed NVME
>> bios
>> (https://github.com/torvalds/linux/blob/13563da6ffcf49b8b45772e40b35f96926a7ee1e/drivers/nvme/host/multipath.c#L126).
>> The original request is ended. 
>>
>> When the nvme_requeue_work callback is executed, the blk layer tries
>> to allocate a new request for the bios but that fails and the bio
>> status is set to BLK_STS_AGAIN
>> (https://elixir.bootlin.com/linux/v6.12.6/source/block/blk-mq.c#L2987).
>> The failure to allocate a new req seems to be due to all tags for the
>> queue being used up.
>>
>> Eventually, this makes it into io_uring?s io_rw_should_reissue and
>> hits same_thread_group(req->tctx->task, current) = false (in
>> https://github.com/torvalds/linux/blob/13563da6ffcf49b8b45772e40b35f96926a7ee1e/io_uring/rw.c#L437).
>> As a result, CQE.res = -EAGAIN and thrown back to the user space
>> program.
>>
>> Here?s a stack dump when we hit same_thread_group(req->tctx->task,
>> current) = false 
>>
>> kernel: [237700.098733]  dump_stack_lvl+0x44/0x5c
>> kernel: [237700.098737]  io_rw_should_reissue.cold+0x5d/0x64
>> kernel: [237700.098742]  io_complete_rw+0x9a/0xc0
>> kernel: [237700.098745]  blkdev_bio_end_io_async+0x33/0x80
>> kernel: [237700.098749]  blk_mq_submit_bio+0x5b5/0x620
>> kernel: [237700.098756]  submit_bio_noacct_nocheck+0x163/0x370
>> kernel: [237700.098760]  ? submit_bio_noacct+0x79/0x4b0
>> kernel: [237700.098764]  nvme_requeue_work+0x4b/0x60 [nvme_core]
>> kernel: [237700.098776]  process_one_work+0x1c7/0x380
>> kernel: [237700.098782]  worker_thread+0x4d/0x380
>> kernel: [237700.098786]  ? _raw_spin_lock_irqsave+0x23/0x50
>> kernel: [237700.098791]  ? rescuer_thread+0x3a0/0x3a0
>> kernel: [237700.098794]  kthread+0xe9/0x110
>> kernel: [237700.098798]  ? kthread_complete_and_exit+0x20/0x20
>> kernel: [237700.098802]  ret_from_fork+0x22/0x30
>> kernel: [237700.098811]  </TASK>
>>
>> Is the same_thread_group() check really needed in this case? The
>> thread groups are certainly different? Any side effects if this check
>> is being removed?
> 
> It's their for safety reasons - across all request types, it's not
> always safe. For this case, absolutely the check does not need to be
> there. So probably best to ponder ways to bypass it selectively.
> 
> Let me ponder a bit what the best approach would be here...

Actually I think we can just remove it. The actual retry will happen out
of context anyway, and the comment about the import is no longer valid
as the import will have been done upfront since 6.10.

Do you want to send a patch for that, or do you want me to send one out
referencing this report?

-- 
Jens Axboe

