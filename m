Return-Path: <io-uring+bounces-2746-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5AE8950643
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 15:19:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 244F61C21BFF
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 13:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A19519ADAD;
	Tue, 13 Aug 2024 13:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MXKiW91z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CA619B3C4;
	Tue, 13 Aug 2024 13:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723555137; cv=none; b=ikaj0mevCauwFbJYIQX3vxK5i0iIOvEshMWRJTeEHevzR96G1+2uORb5n+8AJycIPRoHgc+3ojHgFKc3dP0lMi5jCy57YWw9wtAOQ2+YCOVfywS0imJr7R6vnxDljvr2SuaPLkEiRRrtJKDi2upORps3w4QjGkFP6KRlV8FOQno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723555137; c=relaxed/simple;
	bh=nj9WIj9PsaDS9hjlGSd2Xp2zVfSnB703wX0ciFGOUWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MQ6bcFTPXO6doV06nC5DkDZm2mnjpxdr5IecsuahcKwmnvFbj2gvpKaiBwY9/SHkMmEUiA7mGcb3A4vcm7TvfcEKZgi5BypHrP/E5QS+hUspmVsoP+vvh1bCTzm2ueXQG3/TAkMDlgrBfJDsSVR/0kJVK3hz0nK09le0zH4q89s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MXKiW91z; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a7a9185e1c0so414963966b.1;
        Tue, 13 Aug 2024 06:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723555134; x=1724159934; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HPR5mlciumKWlIa6TShcrh39dYVxLo3iT9ymS47VzxA=;
        b=MXKiW91z8YL5Om9ZGRfna1RlXO6SI/DQel26TmspBI7egqQaHwfvidWoSyqRCfFYaa
         BX93WNf7lG1unwIju9hvy1Tfd+G7kOPWgf4XalT1LClGkEvpsUBGLS/hydpty/6RRcN8
         h74nuf26WxKdBUdQjaBGTBsBJsfVOoV5/ekkYyCNpxZkJPPrqv/EtVt4Yv60mZLufToI
         q1jZ2bPM77UEkoUOuKB2w0vQGKuvLIVJPD7rC0YObTuceBxA5Fld4jU6GFJcjJjCywkV
         F9Shp6iKRbSphZ3xhHbsaP0w/ns0Fuq+sXfz651A8cxJ0QMo03qxSUqBcylMUnhGkCyT
         2Ubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723555134; x=1724159934;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HPR5mlciumKWlIa6TShcrh39dYVxLo3iT9ymS47VzxA=;
        b=aQJoobUh9CM1vCm6tpvnwA4Imi2dpSJfCyDdxFkEGAVecLkuxscFsf1pYiAkZIFgLp
         yEnJsl2SBhT3DHGwUwzsTYt/bxP9Ff4A7cpQCrkCxfW5GMPX4XMxiS3JtSr9OxxzUQfC
         axUF/AuyVTE2E5yTv+ivIkazj07ctjqcrQ6Dsbp3OoHBwmM5CmarYV8DZgZlGQa+HA5x
         wA9Jc8v7AxKBPfC1JnIQhq6GVKUIe/e+nM1TjfweAT4PXiWtfByoJTmyjAVYz0XNwwvp
         lF49aJ4bbTQMfwWYMnvviqxkzxAJOspECb0D25KkjPAXwzjlogus6c8IGrgj4qrryza0
         QndQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1TOvr58N6ljJF4ky9VcBhWS+SKs8zpjG1owPTx3U5zU1lJybSNXjWnGL44K5C9ENmgUGeBRUu3iMt31ZCg+W1CIscH3HAIWUxiTnq
X-Gm-Message-State: AOJu0Yxvt1ljLDYE3+1q15RVMDJTtZSXLuXv7N/ZXw0a8IPBaLrNUteE
	A1kxvF4s1GEnIIPPSpho5z9kPyV56KoK1Tpf/OohCrB+FreZgVfE60CLwtzf
X-Google-Smtp-Source: AGHT+IHoLmtgT5Yu34k1+GShoPzKAE2DGAvgrCYcNGWnM5grTF+T4PiXT4JKlYQocF33z60HaLNczg==
X-Received: by 2002:a17:907:d15:b0:a7a:93c9:3925 with SMTP id a640c23a62f3a-a80ed1aafd5mr283462766b.6.1723555133306;
        Tue, 13 Aug 2024 06:18:53 -0700 (PDT)
Received: from [192.168.42.52] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80f411aee8sm68807966b.138.2024.08.13.06.18.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 06:18:53 -0700 (PDT)
Message-ID: <e23dd6a3-fe1f-48e0-8d05-2b5c1e87f3a3@gmail.com>
Date: Tue, 13 Aug 2024 14:19:22 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/fdinfo: add timeout_list to fdinfo
To: Ruyi Zhang <ruyi.zhang@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 peiwei.li@samsung.com
References: <CGME20240812020140epcas5p3431842ed5508ffb5ae9f1d1812cae4d5@epcas5p3.samsung.com>
 <20240812020052.8763-1-ruyi.zhang@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240812020052.8763-1-ruyi.zhang@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/24 03:00, Ruyi Zhang wrote:
> io_uring fdinfo contains most of the runtime information,
> which is helpful for debugging io_uring applications;
> However, there is currently a lack of timeout-related
> information, and this patch adds timeout_list information.
> 
> Signed-off-by: Ruyi Zhang <ruyi.zhang@samsung.com>
> ---
>   io_uring/fdinfo.c  | 16 ++++++++++++++--
>   io_uring/timeout.c | 12 ------------
>   io_uring/timeout.h | 12 ++++++++++++
>   3 files changed, 26 insertions(+), 14 deletions(-)
> 
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index b1e0e0d85349..33c3efd79f98 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -14,6 +14,7 @@
>   #include "fdinfo.h"
>   #include "cancel.h"
>   #include "rsrc.h"
> +#include "timeout.h"
>   
>   #ifdef CONFIG_PROC_FS
>   static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
> @@ -54,6 +55,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
>   {
>   	struct io_ring_ctx *ctx = file->private_data;
>   	struct io_overflow_cqe *ocqe;
> +	struct io_timeout *timeout;
>   	struct io_rings *r = ctx->rings;
>   	struct rusage sq_usage;
>   	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
> @@ -219,9 +221,19 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
>   
>   		seq_printf(m, "  user_data=%llu, res=%d, flags=%x\n",
>   			   cqe->user_data, cqe->res, cqe->flags);
> -
>   	}
> -
>   	spin_unlock(&ctx->completion_lock);
> +
> +	seq_puts(m, "TimeoutList:\n");
> +	spin_lock(&ctx->timeout_lock);

_irq

> +	list_for_each_entry(timeout, &ctx->timeout_list, list) {
> +		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
> +		struct io_timeout_data *data = req->async_data;
> +

I'd argue we don't want it, there should be better way for
reflection.

And we also don't want to walk a potentially very long list
under spinlock without IRQs, especially from procfs path,
and even more so with seq_printf in there doing a lot of
work. Yes, we already walk the list like that for cancellation,
but it's lighter than seq_printf, and we should be moving in
the direction of improving it, not aggravating the situation.


> +		seq_printf(m, "  off=%d, target_seq=%d, repeats=%x,  ts.tv_sec=%lld, ts.tv_nsec=%ld\n",
> +			   timeout->off, timeout->target_seq, timeout->repeats,
> +			   data->ts.tv_sec, data->ts.tv_nsec);

We should be deprecating sequences, i.e. target_seq, not exposing
it further to the user.

> +	}
> +	spin_unlock(&ctx->timeout_lock);
>   }
>   #endif

-- 
Pavel Begunkov

