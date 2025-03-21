Return-Path: <io-uring+bounces-7182-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 96F09A6C445
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 21:34:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64B767A69E4
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 20:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A741EB5FD;
	Fri, 21 Mar 2025 20:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zd3H4N/J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08CE1514F6;
	Fri, 21 Mar 2025 20:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742589275; cv=none; b=hVXjx+Xda19LPSIS3XXNp1PNBSU1BybFjfnTv9PMIyTxMa7BdK9T/RSXYpUkdzOq+jYaCp2lcwxEYTGbBjZS8VUFmqBE3bzGxYn2GFC4vI8mB9iJdZ3HnNBsZAQ1ry3ZrG+eL6eepqMeiD+fZ/HJDDKtaroWQTd/IBOjDcGIfV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742589275; c=relaxed/simple;
	bh=iCZM/QPOsaDdQuWoHdp6prHpqwO/Q1AO5B5ynak4sa8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OK4GbqSpWS6IgBjnSmbX0R6pt6HLq6IexIkcOqgNcMACRGyaclY5C+xdDM7HLzvKwJG4WommBhxBtu5dKUKlm2HlXVd361Ku2Mtc/if2taQimkkvJ1/U7sqvuzG0IPK+yhlE22V+PjAblzO3pCBLKeSSgcYMbtKDH+clxvn6wGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zd3H4N/J; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ac345bd8e13so432420566b.0;
        Fri, 21 Mar 2025 13:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742589272; x=1743194072; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9ulaGf9MEDtrRMzJbsiLum2mRDwlhlX8TSKnkfT/XEQ=;
        b=Zd3H4N/JXLWkjehMFUYS7ZHBt5IjPsXQU1NjHhKT93MU03VKVzk+km6Zj+F2DVGxHw
         haCtvMrrZjBTG7obNCykTIJg9JD8HRkqGsYK7K4vN3hoQRbbKxtqIjoUyHx8ryn2Xbs8
         NYHGMIn0J/EPo+zTTKOQ4jfAeNqou4iCJQHZFYLj1uDBi/fXlIkRoOTZMrB9fxnhxoNd
         Y5zMcROg8ASBQ66pZ01HGW2YsXK8UsnC40uoEDHJCMlbruF0rBvgumWWw7OqwO/6dp91
         atmlApnGfFaUlU0E3uNZHCdTbCs3M2ol0hXQmk5Di1oXQ2RrifCiTypAjWuGkkZ2lC6P
         h8RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742589272; x=1743194072;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ulaGf9MEDtrRMzJbsiLum2mRDwlhlX8TSKnkfT/XEQ=;
        b=tdIohhr7F5AsHddjQbYs4JS6nB5sPpQLonU8ylwcV6ugcCwfVkuYwbN0OJBdYVBIVX
         1hRrHh/BKIKUUGO2WHuEj+i+i44Q7St/BBRJsMBkx4MziWjAuysqvd3uziopkVwfVqUy
         67Wn26IICLcXdU6Y5/difeEa5VM9SoZlY/gxxDX3QNsOQtWNTMjikk8V3LCbDw6cIvkE
         3Yhngrij4NvYHorjlpAdyAB5W18Y8YUZIvauZJ3ujwFd8Alzqu/p8AI1Mp4Tmk9eqW+a
         91odC3lChIBB2xKZl7NN/GwLtKn9VTfpFagTh9HWinj8DBqGDxX0vwIswrmkqoZbcfq9
         urTA==
X-Forwarded-Encrypted: i=1; AJvYcCUo04DLfSzeOINQS9d7U7yhqcZxpP1/vmH7UYd8Z6gkaXc/OmfRjvOIG2bQiQx6Gr2pE5ElcVQlJQ==@vger.kernel.org, AJvYcCX3h6P7eqySgf/1rWjm+ogkJWmY4c1UPYxM/2MBPQucqgdJRih6ZvtdlPH6NYKGDuyr5NzTMlKt//fs+j57@vger.kernel.org
X-Gm-Message-State: AOJu0Yy06Y/JqJmzZ6gTB6m8o++yaMCZTD+2NjRJqG6hkuWb5itIy2dD
	6H1jbqQ7lTiut2IhRsadF0yRbGLSkzknJd5o0ukuyLHtkHlT93oe
X-Gm-Gg: ASbGnctY0/x4h3X8RMqOsu9l2P1a0aTiac8jgd2KI9hdVSpi+ED5sMn6oIlDKitfSMs
	4eRCPGpzcqneej5i+BlqNM33GD8ORCoazQEXnujODSHHdiYkZJzShMf08XUdS395U2poNUm8M7r
	YvGZ4ztw2PDJEvaJOkDnzKkfJ0dtT6qlTjXe8gUQKvc/YwNCumsfGSxZruFciKr9MPzmlnpYRbI
	JACc17vhqdGYmNembx6gE3SHulug5jdtlciOt9jNOQ+gRzFKuy19pt1EZzqRoqDWoIZnvkGrH7W
	+ZDhKZqNMVId83EmyTMky3yGmcK/guk+sX7NoraQS56RtzBK4OKgjQ==
X-Google-Smtp-Source: AGHT+IFQFUoFZr+OweqQjp9ANhksXIbIFtn48qnP/QqrNnrWbtvNBVSyJNR6P8eMfXTiAoQVCDhJIw==
X-Received: by 2002:a17:907:3f10:b0:ac1:fb60:2269 with SMTP id a640c23a62f3a-ac3f22a59a0mr480301566b.27.1742589271626;
        Fri, 21 Mar 2025 13:34:31 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.236.254])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efb658b4sm208614166b.118.2025.03.21.13.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 13:34:30 -0700 (PDT)
Message-ID: <8338ac70-ed0b-4df5-a052-9ab1dfec9e26@gmail.com>
Date: Fri, 21 Mar 2025 20:35:24 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring/uring_cmd: import fixed buffer before going
 async
To: Caleb Sander Mateos <csander@purestorage.com>,
 Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>
Cc: Xinyu Zhang <xizhang@purestorage.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
References: <20250321184819.3847386-1-csander@purestorage.com>
 <20250321184819.3847386-4-csander@purestorage.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250321184819.3847386-4-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/21/25 18:48, Caleb Sander Mateos wrote:
> For uring_cmd operations with fixed buffers, the fixed buffer lookup
> happens in io_uring_cmd_import_fixed(), called from the ->uring_cmd()
> implementation. A ->uring_cmd() implementation could return -EAGAIN on
> the initial issue for any reason before io_uring_cmd_import_fixed().
> For example, nvme_uring_cmd_io() calls nvme_alloc_user_request() first,
> which can return -EAGAIN if all tags in the tag set are in use.

That's up to command when it resolves the buffer, you can just
move the call to io_import_reg_buf() earlier in nvme cmd code
and not working it around at the io_uring side.

In general, it's a step back, it just got cleaned up from the
mess where node resolution and buffer imports were separate
steps and duplicate by every single request type that used it.

> This ordering difference is observable when using
> UBLK_U_IO_{,UN}REGISTER_IO_BUF SQEs to modify the fixed buffer table.
> If the uring_cmd is followed by a UBLK_U_IO_UNREGISTER_IO_BUF operation
> that unregisters the fixed buffer, the uring_cmd going async will cause
> the fixed buffer lookup to fail because it happens after the unregister.
> 
> Move the fixed buffer lookup out of io_uring_cmd_import_fixed() and
> instead perform it in io_uring_cmd() before calling ->uring_cmd().
> io_uring_cmd_import_fixed() now only initializes an iov_iter from the
> existing fixed buffer node. This division of responsibilities makes
> sense as the fixed buffer lookup is an io_uring implementation detail
> and independent of the ->uring_cmd() implementation. It also cuts down
> on the need to pass around the io_uring issue_flags.
> 
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> Fixes: 27cb27b6d5ea ("io_uring: add support for kernel registered bvecs")
> ---
>   drivers/nvme/host/ioctl.c    | 10 ++++------
>   include/linux/io_uring/cmd.h |  6 ++----
>   io_uring/rsrc.c              |  6 ++++++
>   io_uring/rsrc.h              |  2 ++
>   io_uring/uring_cmd.c         | 10 +++++++---
>   5 files changed, 21 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
> index fe9fb80c6a14..3fad74563b9e 100644
> --- a/drivers/nvme/host/ioctl.c
> +++ b/drivers/nvme/host/ioctl.c
> @@ -112,12 +112,11 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
-- 
Pavel Begunkov


