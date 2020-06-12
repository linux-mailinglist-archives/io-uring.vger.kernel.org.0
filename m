Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5681F7A37
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 16:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgFLO6q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Jun 2020 10:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgFLO6p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Jun 2020 10:58:45 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727E8C03E96F
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 07:58:45 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 10so4410725pfx.8
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 07:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oU3pj1X7KfvwzF0ORN55xGE9DSgv6JYAi+NYr3brL1g=;
        b=aaBEEs9HxtKIMIfQwyKGVdzwaVsrT7dGPUV+EGeFvW/IWU8sJfLMUFJ+9kpTxNiVzW
         XPdE0Tz0fiKrFYyP7MHM20FOP+wWEoVuAZys0xgVUqsx/XHk48ucck/JU3g2wszEUuIc
         v4pxCk/fmMfipM3vkWWIKhh2ecyImX9kaoVrVuxoNCf9G1KU6jtuyjq81gzy4DG//Hlp
         S6+dItcYttN0GN+zPIzQdjnavuCcWGWIJ3lyXReH3QphLSalHoXpQfawXRhKDOmDt41M
         Tk9BuUkwbRCQY4c/JCmkFLzxPTDq3iTeXjmb8c516ksgLml5bSTu7n0lOmtStUKbZDEI
         OQBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oU3pj1X7KfvwzF0ORN55xGE9DSgv6JYAi+NYr3brL1g=;
        b=VaVxt+b8J2HCW6RXx0GQ04a7+YB43jl7y3nbQdbgkbDvB9r4FhF1t+QzJSvean1zPk
         4Tdq5AtxQGxpjvbtKHSDTTleWzaS/pniGfKruR+xMZsWzSzspMZIZ4vcTxR3R9PgzJ5r
         egNtoyFMTHzlV/i7ec+r9NqtMehp35ElX89GRHDb1DnABDUPpdHLwybxiBcd1KnZAR7e
         TGh7ie8WoPAFPB/zXYdRDB87DTe68vyz3VKOVdstwGP+lyHXNXKMwhShzPposA1+WpBg
         QZR2EsNhj3CxdtkH7QFQNGTVE8/16zZRqy35x6COrXTka9tBitf2VsUmUMi9EQGmW2g8
         X8Qw==
X-Gm-Message-State: AOAM532kL88WmRQ7sEikWPpzBQtqFF9JfkoAJyWSxIs+WgpJdQC/1m0D
        gsNOkr4VWLLiNKlejSXbZ3VwAskdQCCrpw==
X-Google-Smtp-Source: ABdhPJzZJY5B/1yRHBVHVX3f44gJ25/L71faMj+Us21OSQBANRC5pwFluWW0xg5zk9lE5uxHLg10WQ==
X-Received: by 2002:a63:f413:: with SMTP id g19mr10121237pgi.200.1591973924763;
        Fri, 12 Jun 2020 07:58:44 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 207sm6316801pfw.190.2020.06.12.07.58.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 07:58:44 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] io_uring: change the poll events to be 32-bits
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <1591929018-73954-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1591929018-73954-2-git-send-email-jiufei.xue@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9e251ae9-ffe1-d9ea-feb5-cb9e641aeefb@kernel.dk>
Date:   Fri, 12 Jun 2020 08:58:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1591929018-73954-2-git-send-email-jiufei.xue@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/11/20 8:30 PM, Jiufei Xue wrote:
> poll events should be 32-bits to cover EPOLLEXCLUSIVE.
> 
> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
> ---
>  fs/io_uring.c                 | 4 ++--
>  include/uapi/linux/io_uring.h | 2 +-
>  tools/io_uring/liburing.h     | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 47790a2..6250227 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4602,7 +4602,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
>  static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	struct io_poll_iocb *poll = &req->poll;
> -	u16 events;
> +	u32 events;
>  
>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>  		return -EINVAL;
> @@ -8196,7 +8196,7 @@ static int __init io_uring_init(void)
>  	BUILD_BUG_SQE_ELEM(28, /* compat */   int, rw_flags);
>  	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
>  	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
> -	BUILD_BUG_SQE_ELEM(28, __u16,  poll_events);
> +	BUILD_BUG_SQE_ELEM(28, __u32,  poll_events);
>  	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
>  	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
>  	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 92c2269..afc7edd 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -31,7 +31,7 @@ struct io_uring_sqe {
>  	union {
>  		__kernel_rwf_t	rw_flags;
>  		__u32		fsync_flags;
> -		__u16		poll_events;
> +		__u32		poll_events;
>  		__u32		sync_range_flags;
>  		__u32		msg_flags;
>  		__u32		timeout_flags;

We obviously have the space in there as most other flag members are 32-bits, but
I'd want to double check if we're not changing the ABI here. Is this always
going to be safe, on any platform, regardless of endianess etc?


-- 
Jens Axboe

