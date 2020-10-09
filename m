Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BF8288BEB
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 16:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389038AbgJIO6D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Oct 2020 10:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389029AbgJIO6A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Oct 2020 10:58:00 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82327C0613D2
        for <io-uring@vger.kernel.org>; Fri,  9 Oct 2020 07:57:58 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o25so7395600pgm.0
        for <io-uring@vger.kernel.org>; Fri, 09 Oct 2020 07:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=naLP2X5I9g+bYi2NX0HGEbL0Y2mLcduh6jJ59cFCp50=;
        b=jJ287B22+BBCohsKfzN1eBMlh7TPMTxSHpjlZTV7jIwxxKi1czatfwzCNMHdrl9K8W
         K4lbiOPZ23zEwDtxUfAICrZu4zAgwqGZOREmt61Cgk4VXVwZy1fv1Hy4wfujEbrou5LG
         Nz9vNYgktAzzzagV0qE0ByB6LTEh0YmbUfgl/77vbClVm+oTFxbLjneOGHZMWP1ZmdnP
         oa1vsg08TFe1c2c9gUSkzHkuFBH0iU2mkKBVGm+okVTz2pYExYZwGGQbeEnyZQs/V9Sl
         SVDvf7DQY37wKAV4hKL02UJ5HLJXeZ8fMcMhBjQtkvDvKLTA3Dp3vOaSJ4SGMwpRH+oO
         xCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=naLP2X5I9g+bYi2NX0HGEbL0Y2mLcduh6jJ59cFCp50=;
        b=pxAyZH2n4cxie1zV9o+o6ESEX48SV6GEJRtv5GRt+hDfjRibNazI4zRo8twTSjGRke
         6t1FGzaQ+18WUemfPbNEMFq/4kXJma+ZFUqfyZy9ZObY8duPqdlBvbZDrncs5D2Y88Lv
         zxzg5XLNiLkcYY5IzCxK8K5SDB2kSzP7gG6S4goi7vIGCy/OpuG091yvSAol8Sgxt1vY
         N+e2cXgszWsr8PVp5qC1vq3yS9WnQDSZaZ+aelgMCnwJu7frojCC/RSi7PahDNob8tYP
         DzYbfQg9neiMg1YPNgQM9kytJ12obVhrW7tGWHeDuQ2F2DpnpYDPAvLJCE9k2T1WZGM3
         B6Hg==
X-Gm-Message-State: AOAM532Sd/9gbmObc8zUTJV3RurE/a6V6Ao853ABPz3GNgolb9FhFOJo
        SgaxzssgDA2Igpzm/JPonCTrvw==
X-Google-Smtp-Source: ABdhPJyp69hQ2foCcgYmyYM6EbJ2fD2UC/aoMd3Incifq58OYlYKldBTmOSi98f3SnOrwwW80trX5w==
X-Received: by 2002:a17:90a:14a4:: with SMTP id k33mr5016963pja.236.1602255477936;
        Fri, 09 Oct 2020 07:57:57 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id i2sm11893818pjk.12.2020.10.09.07.57.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 07:57:57 -0700 (PDT)
Subject: Re: [PATCH 2/3] io_uring: Fix XArray usage in io_uring_add_task_file
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20201009124954.31830-1-willy@infradead.org>
 <20201009124954.31830-2-willy@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0746e0aa-cb81-0fde-5405-acb1e61b6854@kernel.dk>
Date:   Fri, 9 Oct 2020 08:57:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201009124954.31830-2-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/9/20 6:49 AM, Matthew Wilcox (Oracle) wrote:
> The xas_store() wasn't paired with an xas_nomem() loop, so if it couldn't
> allocate memory using GFP_NOWAIT, it would leak the reference to the file
> descriptor.  Also the node pointed to by the xas could be freed between
> the call to xas_load() under the rcu_read_lock() and the acquisition of
> the xa_lock.
> 
> It's easier to just use the normal xa_load/xa_store interface here.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/io_uring.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2978cc78538a..bcef6210bf67 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8586,27 +8586,24 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
>   */
>  static int io_uring_add_task_file(struct file *file)
>  {
> -	if (unlikely(!current->io_uring)) {
> +	struct io_uring_task *cur_uring = current->io_uring;
> +
> +	if (unlikely(!cur_uring)) {
>  		int ret;
>  
>  		ret = io_uring_alloc_task_context(current);
>  		if (unlikely(ret))
>  			return ret;
>  	}

I think this is missing a:

	cur_uring = current->io_uring;

after the successful io_uring_alloc_task(). I'll also rename it to tctx
like what is used in other spots.

Apart from that, series looks good to me, thanks Matthew!

-- 
Jens Axboe

