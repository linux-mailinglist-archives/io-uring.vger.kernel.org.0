Return-Path: <io-uring+bounces-5720-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13756A03540
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 03:39:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A85491882F90
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21C0C4C97;
	Tue,  7 Jan 2025 02:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2ILQY7fz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3452BD04
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 02:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736217578; cv=none; b=fVZDaJuKFpAyATOrKI9we/iwd8USouAV8DQf1X46XHM5jqpXEtwz1wWWFJjTMC5GhnqQRsSp6tuB/svCeWJ2STtxSMZCRJETepUaKHK7ECHdAKMgYxPfF3VlmUTT6xXq66lUwvpsFB+ELTuqFCxLivzafFqleENQ8nb+o5to/dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736217578; c=relaxed/simple;
	bh=bBH1LhIoiYd+1SVkDivrFnsFnGvm+hQDebERWIXnOTE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=Fbn3tWhcaLYhp8OHsrL8lHlBLEy8mWKAlYuKqINULpNkCXIIJHDCJY2WjFBNzOjnNues4s0SXLSOeHWnJ8KjGsVwWhxKaOIa11+4QtHW8/IdJ/iXC+LfLbX6pNYlgN+EktDiI9s1LS/UzmT6FY12J7WgoST9VuiczwFzPygPoxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2ILQY7fz; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3cdce23f3e7so22144755ab.0
        for <io-uring@vger.kernel.org>; Mon, 06 Jan 2025 18:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736217573; x=1736822373; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2PMP9NcTzDDoX/J93/BM15vwN7ZdgvILVx5B4TbzqNc=;
        b=2ILQY7fzogZMFX+dDsgAiEkytkfwrMU0pwFbRhiAw0LBWGurDPcRIJjh5EGInZRVfr
         05ONkQY2wOeBuDwITTS/qRcRMhEiEapKl+9PjZZQ9/wLfiYxSLMT+Tyv7OzEVqYzt1lt
         gppZM2GCJWuFOF2TBhEkMyrRrK3Nv0i+mAkD/+8yPT1HTdTRQl2NnzoNk2wTJ53eivBD
         O2enqmyuPjpJa2qCYI9qIL60jsFITknbuBUjV6lEAt3DRqxg0hZU90NizGhrA/v60Wmu
         8yxlkkOPoJSryM48xQ4eMbSVuNsZr8gtw8iWdINzKxqyyR8QaDRwYQo6Wceb7jNAEw4D
         bWjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736217573; x=1736822373;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2PMP9NcTzDDoX/J93/BM15vwN7ZdgvILVx5B4TbzqNc=;
        b=d7arwLgn8M75W5bE9WLMjcOBKZ63U2uR25N8Wt1zeB2V2G/hGN6hDNiSSQhpkjxAbl
         VWSEZ1pMKEXbo7c+Uu/PXvfd2tR49CP/QYRV4IdYKx+XOEo77R+jIIW0+74tV3DH1yFx
         suHy6YpdoEVN+Dd8FSVlpwW877syJJYdOqJy1UXJ0aoLJrU5Yq/PZ/skc/oxZ2SD5YsY
         7Lof1coqZzuBusXzA8uWNdESQdjyYFQnb3957DUmS4YkOyruodyR+YnlAcqPD3A3yKTh
         e96uhskSzEE/SrwSGBFcmOY7j22nbIJh+eP1VVD+FwXEmD7iqAaQ7iqi4KvOOlWOahJA
         GEzg==
X-Forwarded-Encrypted: i=1; AJvYcCW9UgaW9VWBgHQaDHAY5zqR8b0McOp4SNrk4lOQM5uw21gWJIfLW4kP7iC8xPCTX+dE380bLrRH0Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyyhOe5hkAYrgtt9W+rt8SbbCS/WAGqLLjp/j1Y2OlWIelQlhBW
	XKzgUYyHTz11puhV0VnnkauUs/XXg+26+64efnw8CfIlxHcrHUWvCKc8HF5qdIh0eF03hcY7nUL
	G
X-Gm-Gg: ASbGnctOkrf9585pjfZ5UQNmvoL+LfDjycgumcThre4EsAET+jVj+Thi5vW2Y1lKIvH
	ofZM3rj3uFEIDZjkFD3VZ/QgAQVVyQe6S2JzO1mY3egRGz2sZQ/VpszrElWGSSeIuynpsubKTQr
	CCXV3krxswQ30uhPTJuWZ5WooN2yy1GV1Qu1kF1obasB7V3S4LMlEnQeg/2djbEgxAyGuqojd7o
	Hzs2F2MjQhh2HGeIklq6l3DI+OwWJm1nDfTnGE80zxc/Ins7RUcTw==
X-Google-Smtp-Source: AGHT+IHH6n82Rq+POuy2hkeo3MheNNGAAi8eUH2zV9ZQ/17Uxw5g0hTC7T75mKvzE4mcG0U7ptVTWA==
X-Received: by 2002:a05:6e02:1a44:b0:3a7:e86a:e803 with SMTP id e9e14a558f8ab-3c2d25673f5mr475650515ab.8.1736217573075;
        Mon, 06 Jan 2025 18:39:33 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce34f9be57sm100745ab.19.2025.01.06.18.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 18:39:32 -0800 (PST)
Message-ID: <8330be7f-bb41-4201-822b-93c31dd649fe@kernel.dk>
Date: Mon, 6 Jan 2025 19:39:31 -0700
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
 <da6375f5-602f-4edd-8d27-1c70cc28b30e@kernel.dk>
Content-Language: en-US
In-Reply-To: <da6375f5-602f-4edd-8d27-1c70cc28b30e@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/6/25 7:33 PM, Jens Axboe wrote:
> On 1/6/25 4:53 PM, Jens Axboe wrote:
>> On 1/6/25 1:03 PM, Haeuptle, Michael wrote:
>>> Hello,
>>>
>>> I?m using the nvme multipath driver (NVMF/RDMA) and io-uring. When a
>>> path goes away, I sometimes get a CQE.res = -EAGAIN in user space.
>>> This is unexpected since the nvme multipath driver should handle this
>>> transparently. It?s somewhat workload related but easy to reproduce
>>> with fio.
>>>
>>> The multipath driver uses kblockd worker to re-queue the failed NVME
>>> bios
>>> (https://github.com/torvalds/linux/blob/13563da6ffcf49b8b45772e40b35f96926a7ee1e/drivers/nvme/host/multipath.c#L126).
>>> The original request is ended. 
>>>
>>> When the nvme_requeue_work callback is executed, the blk layer tries
>>> to allocate a new request for the bios but that fails and the bio
>>> status is set to BLK_STS_AGAIN
>>> (https://elixir.bootlin.com/linux/v6.12.6/source/block/blk-mq.c#L2987).
>>> The failure to allocate a new req seems to be due to all tags for the
>>> queue being used up.
>>>
>>> Eventually, this makes it into io_uring?s io_rw_should_reissue and
>>> hits same_thread_group(req->tctx->task, current) = false (in
>>> https://github.com/torvalds/linux/blob/13563da6ffcf49b8b45772e40b35f96926a7ee1e/io_uring/rw.c#L437).
>>> As a result, CQE.res = -EAGAIN and thrown back to the user space
>>> program.
>>>
>>> Here?s a stack dump when we hit same_thread_group(req->tctx->task,
>>> current) = false 
>>>
>>> kernel: [237700.098733]  dump_stack_lvl+0x44/0x5c
>>> kernel: [237700.098737]  io_rw_should_reissue.cold+0x5d/0x64
>>> kernel: [237700.098742]  io_complete_rw+0x9a/0xc0
>>> kernel: [237700.098745]  blkdev_bio_end_io_async+0x33/0x80
>>> kernel: [237700.098749]  blk_mq_submit_bio+0x5b5/0x620
>>> kernel: [237700.098756]  submit_bio_noacct_nocheck+0x163/0x370
>>> kernel: [237700.098760]  ? submit_bio_noacct+0x79/0x4b0
>>> kernel: [237700.098764]  nvme_requeue_work+0x4b/0x60 [nvme_core]
>>> kernel: [237700.098776]  process_one_work+0x1c7/0x380
>>> kernel: [237700.098782]  worker_thread+0x4d/0x380
>>> kernel: [237700.098786]  ? _raw_spin_lock_irqsave+0x23/0x50
>>> kernel: [237700.098791]  ? rescuer_thread+0x3a0/0x3a0
>>> kernel: [237700.098794]  kthread+0xe9/0x110
>>> kernel: [237700.098798]  ? kthread_complete_and_exit+0x20/0x20
>>> kernel: [237700.098802]  ret_from_fork+0x22/0x30
>>> kernel: [237700.098811]  </TASK>
>>>
>>> Is the same_thread_group() check really needed in this case? The
>>> thread groups are certainly different? Any side effects if this check
>>> is being removed?
>>
>> It's their for safety reasons - across all request types, it's not
>> always safe. For this case, absolutely the check does not need to be
>> there. So probably best to ponder ways to bypass it selectively.
>>
>> Let me ponder a bit what the best approach would be here...
> 
> Actually I think we can just remove it. The actual retry will happen out
> of context anyway, and the comment about the import is no longer valid
> as the import will have been done upfront since 6.10.
> 
> Do you want to send a patch for that, or do you want me to send one out
> referencing this report?

Also see:

commit 039a2e800bcd5beb89909d1a488abf3d647642cf
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Apr 25 09:04:32 2024 -0600

    io_uring/rw: reinstate thread check for retries

let me take a closer look tomorrow...

-- 
Jens Axboe

