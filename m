Return-Path: <io-uring+bounces-7222-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5BF9A6E002
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 17:41:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F5D73B26D7
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 16:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E605263F20;
	Mon, 24 Mar 2025 16:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RaSRj5k4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5661263F45;
	Mon, 24 Mar 2025 16:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742834436; cv=none; b=rwy3FUvCDHXl+5O5keNIsdDlABI4Af0D2XtcyvRNYihcJeXylbdCUJWE4NmibTfY+qwsDeF4rRYut42W1SyV6YrFTHBUFAeIVyN+NAlggMHIN6USSL57WXjpnc6Ffq1T8fEF0RhJNkDhSdMQr2HTkM1L4IoLF7x2BGAwgnbzlvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742834436; c=relaxed/simple;
	bh=x8PABQrsDgCOX+uyTUN4FJ1Yl1ns+zOT/16l9ioHqrw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pk4z/+OOpGdzQKpfYUi45bHpuWRORuGMXIe76R54Uoz9ojAJtpB40MpUZkQx7OfkHd0MYASqE4LrvtPWDwGqik/glWNS5cT1uUQSm+i9vuXAl+NomwLBNo8OUMDAYHtEZmC+yKWOLG8OlzWwR9BLy8mC9a9xyMGeWQbq6n2GCfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RaSRj5k4; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ac25313ea37so598585266b.1;
        Mon, 24 Mar 2025 09:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742834433; x=1743439233; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oDtho8Qg5tUXMdbdaSokB13XskC1ao9tVGk4/on+IUU=;
        b=RaSRj5k4R/+5GgxAxa51TggLc3i95AoB6ZBluIMnvXcjSoKUonP+o8CI5AwFz0uZCd
         AQqqR8GsD5DIlnLRPrAINqWvArHCO6GhfBPTo4vVZCuDyGBP3H2cmam+hBZUbcdBrPM0
         ZrILgtmLvEK3XBZYTohpjUiwWxGoUhAQryFv0Mb3S0JC8xYmMYZTG4UZjC+C9tgeIE3f
         r5zwQzA5+gaSUFeNOBD7lDSQiEomYSSO2JhPyHgjU+u8j+XyAXIFHYhPpb6sSFi1ey7n
         zOfB04KiR3RxBl5IVevoSlBSSGDc8213a7ZqK9cyCuIzsQtRzsATG2jalmoYzm0siklS
         s7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742834433; x=1743439233;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oDtho8Qg5tUXMdbdaSokB13XskC1ao9tVGk4/on+IUU=;
        b=rhu2IwkiESF31AER4oAYM49VT4Z1ztTIs37XoYb9R/2f6y4ttEyQWGX5GwkdYUmnO6
         w04P0BEv+qTM6d3MS/dsGjbtFXWiF6xIo1Bcsv5GRh8Y7UP9K7GqDtt2iSASZmOxJ+TI
         hru8YdxiUwFdDp4HuFNXhLQ9q/hI7f4U1cCvUmQdrfJa7QTsahTHCxybXNDUsXxtDWx1
         5CAPLeK0wI/Jq7ui72hkVKzlVKMOkvIbvaWJ+RVJJYGy2rHGi6Jt/f1JeYz9p7wPMAed
         9keU3ZSEr4KCVTCKOK145GaRzUosZ7wI6pIeNGnnhkGdui84SS5f3lumGGjLxxEKuvQG
         hCkg==
X-Forwarded-Encrypted: i=1; AJvYcCUZ7anEFemMIGpbL4yT0ouIp8p1JqVi98OjyEjDz/ocxfIRPTnoKSj3+O3Kw2Th5Zidcb42pdxfNQ==@vger.kernel.org, AJvYcCViqmR3yAi9tIAznj/Mkf3yxGQA5M9WjY+ZnGeLeCwhQewnvjsFd92ryfQwTb+bGi//Y5d31a5v+3wm06Ys@vger.kernel.org
X-Gm-Message-State: AOJu0YwrxP+j/e2MlLrZBW/7OMc3rdtqll/fnBwQE+NMZBt4/ss7V/iC
	HefpGzCm/XLNQ72MhnrzbsUhK5sYTtDH7Zfxxz6gdN8kBy/Y73MD
X-Gm-Gg: ASbGncvqpBiY4FMwz/EA2rKxNYNWM2yVFpv2Bcg5HVsZeBR+LX7Rlz0QhQGA1kVphoJ
	Zo0MhMYvdwhOoKYLDmBI+s9WrcgD9tHEque6Sd27UX65u8v5aguw1Ap6LZe5GmsmpFfLqjzC2rZ
	4iEaz/8/zNi/vpI0GMof30YC5aIHN5RX+LdRs7cGbMs7HSdIjiDVoPpBbw4Jjtfh9gY7tv62zIQ
	XrgtxfC411Y7TZMItI4Gh4y3MCCNTX3RzKUAskTFqXQnKWVYySXM7He3sMYntX6WlfstQVJoWpm
	kvK+r8xTrecjX8mYw+mbY/N02GhASL9QeSnAfmy7mfxXM1DYFyoXJH47WhEnE3rdiQoX
X-Google-Smtp-Source: AGHT+IH2sbshgb2g3hA15gaE0qcsgQIFZkzMtI/lI5+qTLW5Thn45LTleHIoJg+SzEbs//cdhPE69g==
X-Received: by 2002:a17:907:3e8c:b0:ac1:ffde:7706 with SMTP id a640c23a62f3a-ac3f2285fb7mr1136848666b.25.1742834432587;
        Mon, 24 Mar 2025 09:40:32 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::25f? ([2620:10d:c092:600::1:5023])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efd23c7bsm712400566b.150.2025.03.24.09.40.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Mar 2025 09:40:32 -0700 (PDT)
Message-ID: <a548f318-9809-4d9f-bac9-a4b83fd6bdff@gmail.com>
Date: Mon, 24 Mar 2025 16:41:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Consistently look up fixed buffers before going async
To: Ming Lei <ming.lei@redhat.com>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Xinyu Zhang <xizhang@purestorage.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
References: <20250321184819.3847386-1-csander@purestorage.com>
 <Z95nyw8LUw0aHKCu@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z95nyw8LUw0aHKCu@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/22/25 07:33, Ming Lei wrote:
> On Fri, Mar 21, 2025 at 12:48:16PM -0600, Caleb Sander Mateos wrote:
>> To use ublk zero copy, an application submits a sequence of io_uring
>> operations:
>> (1) Register a ublk request's buffer into the fixed buffer table
>> (2) Use the fixed buffer in some I/O operation
>> (3) Unregister the buffer from the fixed buffer table
>>
>> The ordering of these operations is critical; if the fixed buffer lookup
>> occurs before the register or after the unregister operation, the I/O
>> will fail with EFAULT or even corrupt a different ublk request's buffer.
>> It is possible to guarantee the correct order by linking the operations,
>> but that adds overhead and doesn't allow multiple I/O operations to
>> execute in parallel using the same ublk request's buffer. Ideally, the
>> application could just submit the register, I/O, and unregister SQEs in
>> the desired order without links and io_uring would ensure the ordering.
> 
> So far there are only two ways to provide the order guarantee in io_uring
> syscall viewpoint:
> 
> 1) IOSQE_IO_LINK
> 
> 2) submit register_buffer operation and wait its completion, then submit IO
> operations
> 
> Otherwise, you may just depend on the implementation, and there isn't such
> order guarantee, and it is hard to write generic io_uring application.
> 
> I posted sqe group patchset for addressing this particular requirement in
> API level.
> 
> https://lore.kernel.org/linux-block/20241107110149.890530-1-ming.lei@redhat.com/
> 
> Now I'd suggest to re-consider this approach for respecting the order
> in API level, so both application and io_uring needn't play trick for
> addressing this real problem.

The group api was one of the major sources of uneasiness for previous
iterations of ublk zc. The kernel side was messy, even though I
understand that the messiness was necessitated from the choice of
the API and the mismatch with existing io_uring bits.

The question is whether it can be made simpler and more streamlined
now, internally and from the point of uapi as well. E.g. can it
extend traditional links paths without leaking into other core io_uring
parts where it shouldn't be? And to be honest, I can't say I like the
idea, just as I'm not excited by links we already have. They're a
pain to keep around, the abstraction is leaking in all unexpected
places, and it's not flexible enough and needs kernel changes for
every new simple case, not to mention something more complicated
like reading a memory and deciding about the next request from that.

I'd rather argue for letting the user to do that in bpf and make
it responsible for all error parsing and argument inference, as
in patches I sent around December, though they need to be extended
to go beyond cqe-sqe manipulation interface.


> With sqe group, just two OPs are needed:
> 
> - provide_buffer OP(group leader)
> 
> - other generic OPs(group members)
> 
> group leader won't be completed until all group member OPs are done.
> 
> The whole group share same IO_LINK/IO_HARDLINK flag.
> 
> That is all the concept, and this approach takes less SQEs, and application
> will become simpler too.

-- 
Pavel Begunkov


