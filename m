Return-Path: <io-uring+bounces-1595-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EA428AAE66
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 14:27:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D28311F21DFE
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 12:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE5837F489;
	Fri, 19 Apr 2024 12:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kC5t+hTr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C2F1851;
	Fri, 19 Apr 2024 12:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713529663; cv=none; b=CuGI0TEdfQjqptAWu13jC7pmSLWaHPVsReHArPHE3N+F3QNhaTNzcNXrBkcwjZuIjDRwNjjbtnkVQ4rqHHLxfrUPqnuS8HtrLmqQEXcz4IkPbA6nWjF7DllDHZeX93kbnVd9hS7pEofL5Fuf9Kz94DTIQO39j44ZpMpH38GiYUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713529663; c=relaxed/simple;
	bh=qbpCOSUhac7hbCTMY2k92AtDrGNQoiSByrraKF6nKF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MVLUfRo0csSKaVe9j+fthqgiHcxBMaQOzyzjNu4IeutcycUSHc5acU4i5NQbMN9X3OjEmI+4Newv5IyQsRVpxEsiBRWaebdr0bhI27pNcnwIhzljgqEqdW8xKzIeU8uktdhZmOli61dYBxjU3mv4d3rj3gPpMBE2DehNQRjdVWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kC5t+hTr; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-571bddd74c1so1683710a12.0;
        Fri, 19 Apr 2024 05:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713529660; x=1714134460; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P6ZuVRuhyT1S3RvylFkXxFU7KCh/27+wnHdBbKG6iRs=;
        b=kC5t+hTr5VsoubVpNdctKinZJxmRT6Bc2NGkuLQjseTErgOdzPHCNfGdhxjKdxOAFE
         1DwPCLCWyC/n3CAfYhHf6PeDqeUZxZcEjv1jaLf96htO1mVHjdMBqjb849++vg8KXD9E
         h0mBJekYzdfB7yCfS/scw9b6cNRCTPrA57J1JTb4VrPfg3rWvLPFoaxnYUjZwI+T84rT
         r+qsL8mo7vzu1ARS4Xp85ye3eWbfMO4coD52jdK/SPauipHfCK09zbAjIkJwO98ogbQe
         TPUT07o/vdqXz9fh66Nyj8eJJ3iq5qGfkx/ju35RwVIvLkpptZ5elkuid1XZYTfNtZsR
         ZwCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713529660; x=1714134460;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P6ZuVRuhyT1S3RvylFkXxFU7KCh/27+wnHdBbKG6iRs=;
        b=NYPVeEbvDLszPW7MrCJjYzPrue/BXDU6K2ECOA+2DX2pREMD+NntGxOROgUBb9BLF6
         C2iNKFu0wy/AEXJS6oXyjT5XwO/gXiVZiZsuRlqpM2L81BCXlMeZDAo8MT9XpG7ZrGX7
         qdV8tz3BQsejsYdw8Aurq0D1TCP4goV5HJYh43eV+45gOwA66BWKjXgfCAEPO2/hAbHb
         5TP34DW/L3x7rP7qNMv3gZN4vnE0Zdrf51ehdr0/Yu1aoI8tO+kNKpsV54vjW4izJqa7
         KdpCmR3KNrhsP7QNZw4FKufnhyUno/lwOlThpb64OpBuF6hlQNErkBUs/XZGcyvQJG6b
         xLbg==
X-Forwarded-Encrypted: i=1; AJvYcCVuhvd+UtTB9uWk9KBu7kRswQNV3cAUUjRXCETfNVogIcLGGQ0EiE1aAbkXpd953pORkrrdQGebRddR/WDunv/UfKRH8HeFqeQ=
X-Gm-Message-State: AOJu0Yz9I5hoJ+DdtDp3n47AvW3Fj7xu7kJrn8NzUzH47ah+zVaIPX5u
	p2RAEJCBssKZGwsliB3vEJ6LUcvXkPJ4rNqkR0fHWa7jDLbuBPeA/WxyFA==
X-Google-Smtp-Source: AGHT+IHZz5uNUmO+LR2PlWdDrqi/NXiA7dBMen/S2O4UgEunhvhGlOxZN4bIveBP3wBjI28ZRzuOAQ==
X-Received: by 2002:a50:c355:0:b0:566:2f24:b063 with SMTP id q21-20020a50c355000000b005662f24b063mr1338393edb.23.1713529660396;
        Fri, 19 Apr 2024 05:27:40 -0700 (PDT)
Received: from [192.168.42.238] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id d6-20020a05640208c600b0056e72c4a330sm2063090edz.41.2024.04.19.05.27.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Apr 2024 05:27:40 -0700 (PDT)
Message-ID: <26e38785-4f48-4801-a8c1-895bf8d78f7a@gmail.com>
Date: Fri, 19 Apr 2024 13:27:45 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: releasing CPU resources when polling
To: hexue <xue01.he@samsung.com>, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 peiwei.li@samsung.com, joshi.k@samsung.com, kundan.kumar@samsung.com,
 anuj20.g@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
 xiaobing.li@samsung.com, cliang01.li@samsung.com
References: <CGME20240418093150epcas5p31dc20cc737c72009265593f247e48262@epcas5p3.samsung.com>
 <20240418093143.2188131-1-xue01.he@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240418093143.2188131-1-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/24 10:31, hexue wrote:
> This patch is intended to release the CPU resources of io_uring in
> polling mode. When IO is issued, the program immediately polls for
> check completion, which is a waste of CPU resources when IO commands
> are executed on the disk.
> 
> I add the hybrid polling feature in io_uring, enables polling to
> release a portion of CPU resources without affecting block layer.

So that's basically the block layer hybrid polling, which, to
remind, was removed not that long ago, but moved into io_uring.

> - Record the running time and context switching time of each
>    IO, and use these time to determine whether a process continue
>    to schedule.
> 
> - Adaptive adjustment to different devices. Due to the real-time
>    nature of time recording, each device's IO processing speed is
>    different, so the CPU optimization effect will vary.
> 
> - Set a interface (ctx->flag) enables application to choose whether
>    or not to use this feature.
> 
> The CPU optimization in peak workload of patch is tested as follows:
>    all CPU utilization of original polling is 100% for per CPU, after
>    optimization, the CPU utilization drop a lot (per CPU);

The first version was about cases that don't have iopoll queues.
How many IO poll queues did you have to get these numbers?


>     read(128k, QD64, 1Job)     37%   write(128k, QD64, 1Job)     40%
>     randread(4k, QD64, 16Job)  52%   randwrite(4k, QD64, 16Job)  12%
> 
>    Compared to original polling, the optimised performance reduction
>    with peak workload within 1%.
> 
>     read  0.29%     write  0.51%    randread  0.09%    randwrite  0%
> 
> Reviewed-by: KANCHAN JOSHI <joshi.k@samsung.com>

Kanchan, did you _really_ take a look at the patch?

> Signed-off-by: hexue <xue01.he@samsung.com>
> ---
>   include/linux/io_uring_types.h | 10 +++++
>   include/uapi/linux/io_uring.h  |  1 +
>   io_uring/io_uring.c            | 28 +++++++++++++-
>   io_uring/io_uring.h            |  2 +
>   io_uring/rw.c                  | 69 ++++++++++++++++++++++++++++++++++
>   5 files changed, 109 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 854ad67a5f70..7607fd8de91c 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -224,6 +224,11 @@ struct io_alloc_cache {
>   	size_t			elem_size;
>   };


-- 
Pavel Begunkov

