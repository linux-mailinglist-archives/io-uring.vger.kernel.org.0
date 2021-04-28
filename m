Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEAD36D9A2
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 16:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbhD1Oe5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 10:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235864AbhD1Oe5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 10:34:57 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C569C061573
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:34:10 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x7so63277385wrw.10
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XSphu27pumn6nx/Hg3UPMrOrVZL9ufQInaazixLiEJs=;
        b=mgeK2l2dLZ8mibw6k+/8/QkVHC/n5ISZ9DsE5HVnYCNP2CIudUdF4TsH8kMMkcI0wo
         pBHHza3qxw6knzGCKdXKOjj7/ucm9ndlQi6o2040Wxaa05N+K03cH7blRKVKhnKkvUGe
         H60D7lDwsFSBKpV0qJ7TwObZgNDx66vUgZSy/HH3iVyiRaTC6VICm70YlYTS1p+KMxtW
         ByXEZ7KBvMfvNbS5mgRG5B4Z3sqJJiU4/OEPPZXp+PYF3EdzqJuRssbtjWzt4zt7lWW2
         eCBqrcw+N+uNgdilt6BZfB7ZiNqucQqNwDhVIJ2xRChXDhN9QlI8BEXkVbuzK++d6qqQ
         1piQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XSphu27pumn6nx/Hg3UPMrOrVZL9ufQInaazixLiEJs=;
        b=bFvyzNrLr1Y21ENpa+gPgnyKBsfdIcFkWdcRN/r98ZGtBGXRQcMJHufI50rtvZVAtV
         hgfOoIparAOm+OZhp1LOqj1TJo/F+3HCUcYRjifDOKRFUU5fkdlwaRJvfuevcx1fmgCA
         eMLaft4U5L6btOeeEf1EhuCA0SBFP70UXGQYbO73FHU63hjz17eADThdOgRL8mnQ7Oyz
         qj+uQywZ7CJpP5rAKyLsw5oZvX3Xsx6uD2dRO58fL9lq4XO5sEZw8DqrXkMZqEdGKOnP
         p+2SaM0QhW9Ey5aPtgLeIMzJQLU4NYv4o8ErFe+3jrMozbVMJN8OiMzQ2K6lJgt9v3Xh
         K5Hw==
X-Gm-Message-State: AOAM531F8tpYaBOJXRPMZz3PhGL2MP1VA5MROktSPeuoNNOenV26icSb
        9iHTUzjve7JjRp02F5b2kKGJALg4/V0=
X-Google-Smtp-Source: ABdhPJyEWftJJmbayYZz5VhoXU/Qgf38WMeW7DftzDe5Sm9uFvZGDuvzDpm8mUN+Sum2cvcN08cHGw==
X-Received: by 2002:a05:6000:1449:: with SMTP id v9mr10344684wrx.82.1619620448999;
        Wed, 28 Apr 2021 07:34:08 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.35])
        by smtp.gmail.com with ESMTPSA id v13sm164911wrt.65.2021.04.28.07.34.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 07:34:08 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 2/2] io_uring: submit sqes in the original
 context when waking up sqthread
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <571b5633-3286-feba-af6b-e388f52fc89b@gmail.com>
Date:   Wed, 28 Apr 2021 15:34:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/21 2:32 PM, Hao Xu wrote:
> sqes are submitted by sqthread when it is leveraged, which means there
> is IO latency when waking up sqthread. To wipe it out, submit limited
> number of sqes in the original task context.
> Tests result below:

Frankly, it can be a nest of corner cases if not now then in the future,
leading to a high maintenance burden. Hence, if we consider the change,
I'd rather want to limit the userspace exposure, so it can be removed
if needed.

A noticeable change of behaviour here, as Hao recently asked, is that
the ring can be passed to a task from a completely another thread group,
and so the feature would execute from that context, not from the
original/sqpoll one.

Not sure IORING_ENTER_SQ_DEPUTY knob is needed, but at least can be
ignored if the previous point is addressed.

> 
> 99th latency:
> iops\idle	10us	60us	110us	160us	210us	260us	310us	360us	410us	460us	510us
> with this patch:
> 2k      	13	13	12	13	13	12	12	11	11	10.304	11.84
> without this patch:
> 2k      	15	14	15	15	15	14	15	14	14	13	11.84

Not sure the second nine describes it well enough, please can you
add more data? Mean latency, 50%, 90%, 99%, 99.9%, t-put.

Btw, how happened that only some of the numbers have fractional part?
Can't believe they all but 3 were close enough to integer values.

> fio config:
> ./run_fio.sh
> fio \
> --ioengine=io_uring --sqthread_poll=1 --hipri=1 --thread=1 --bs=4k \
> --direct=1 --rw=randread --time_based=1 --runtime=300 \
> --group_reporting=1 --filename=/dev/nvme1n1 --sqthread_poll_cpu=30 \
> --randrepeat=0 --cpus_allowed=35 --iodepth=128 --rate_iops=${1} \
> --io_sq_thread_idle=${2}
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c                 | 29 +++++++++++++++++++++++------
>  include/uapi/linux/io_uring.h |  1 +
>  2 files changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 1871fad48412..f0a01232671e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1252,7 +1252,12 @@ static void io_queue_async_work(struct io_kiocb *req)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
>  	struct io_kiocb *link = io_prep_linked_timeout(req);
> -	struct io_uring_task *tctx = req->task->io_uring;
> +	struct io_uring_task *tctx = NULL;
> +
> +	if (ctx->sq_data && ctx->sq_data->thread)
> +		tctx = ctx->sq_data->thread->io_uring;

without park it's racy, sq_data->thread may become NULL and removed,
as well as its ->io_uring.

> +	else
> +		tctx = req->task->io_uring;
>  
>  	BUG_ON(!tctx);
>  	BUG_ON(!tctx->io_wq);

[snip]

-- 
Pavel Begunkov
