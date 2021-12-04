Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B616B46880E
	for <lists+io-uring@lfdr.de>; Sat,  4 Dec 2021 23:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhLDWYs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Dec 2021 17:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhLDWYs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Dec 2021 17:24:48 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400D1C061751
        for <io-uring@vger.kernel.org>; Sat,  4 Dec 2021 14:21:22 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id p65so8415377iof.3
        for <io-uring@vger.kernel.org>; Sat, 04 Dec 2021 14:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=gydqimBLXZTGURoYT6UdIAJV4qAgq/RQk7A9IemrMps=;
        b=Pnr1CwdYhc+8kRQbKovKY016Ypx0ooK754YSisso3BpWjmtIIAA8nyiy7YVBNmkosJ
         iT7aDzrUncGY1ulnd3PLpkf2vu/N7kHEUQC/kT6fW5rcVde2ki044hA64itWH/8FuKYA
         KhPOQAkoJ/y7Kb/CdpjJV9uLJAyaqUXw7dpXpkrJ7RFimhWwCyTN7MPyE9GLEeGAdkGg
         eccPmXktvwqfO0ry3xvO7jjs1kN/XLbTEncmbqfT3zuTAE0SWfUQ5Txxalo5Pfyo7h9A
         fVkl5uO1WM46ICSgNuM2YU68JscqaptQWioD4Ztc/K0qqpI+opl5tR8bpc89re7hyV4r
         pi7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gydqimBLXZTGURoYT6UdIAJV4qAgq/RQk7A9IemrMps=;
        b=4gcuS8tXgzxzak5syA64JfLPXAjEpwR6NOwiQwF7/9Bh9rgCipCNIg7/pfwCylMJtJ
         7I/vZcBMxskIbIFsp/WTq8jwxfhQben0JkTX6R5N7LG1xwZKTH1SxQK9hWCdRlFy81QS
         NvxVuGb4h55Ap1+2GGrzRfyN9FzmqSs46o61Bx14HmGfwRXxqqEqjQWuWpIeLjMvplbO
         cT0i3+UMjpj8+uIYgufvzoMuNmN8BuYmFfmVrI4xgEbzhfTFYrHffY2EXt1iY0rWfNN1
         mVNpqy3B6BWRNwU+oUaWHTKDuj6TxaDTJtOZ9ZJXmc7ZW47qQme0/sKrib54jSaucOlH
         C3tw==
X-Gm-Message-State: AOAM530YTp9SKX3oTaPUewvhvSJxlnVJutyf/z8DZK2lEOzxKziIq1QM
        wFw7MJqvx0q75/XpfSnyy9n4EGos7fNL8xDp
X-Google-Smtp-Source: ABdhPJwgcVzz30a/fdYL3dSsRM4rfETKnUa/T5sNRZuEZdJYE6uVao9sRMwGA8X4Q2CHigVAHapiZg==
X-Received: by 2002:a05:6638:24ca:: with SMTP id y10mr31795641jat.109.1638656481275;
        Sat, 04 Dec 2021 14:21:21 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id i8sm1692452ils.50.2021.12.04.14.21.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Dec 2021 14:21:20 -0800 (PST)
Subject: Re: [PATCH 3/4] io_uring: tweak iopoll return for REQ_F_CQE_SKIP
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1638650836.git.asml.silence@gmail.com>
 <416acc6e18b03bf41009e5ae3765737201e7c87c.1638650836.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <797fbd8a-ea46-091d-0d26-0103026295f2@kernel.dk>
Date:   Sat, 4 Dec 2021 15:21:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <416acc6e18b03bf41009e5ae3765737201e7c87c.1638650836.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/4/21 1:49 PM, Pavel Begunkov wrote:
> Currently, IOPOLL returns the number of completed requests, but with
> REQ_F_CQE_SKIP there are not the same thing anymore. That may be
> confusing as non-iopoll wait cares only about CQEs, so make io_do_iopoll
> return the number of posted CQEs.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 64add8260abb..ea7a0daa0b3b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2538,10 +2538,10 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>  		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
>  		if (!smp_load_acquire(&req->iopoll_completed))
>  			break;
> +		if (unlikely(req->flags & REQ_F_CQE_SKIP))
> +			continue;
>  
> -		if (!(req->flags & REQ_F_CQE_SKIP))
> -			__io_fill_cqe(ctx, req->user_data, req->result,
> -				      io_put_kbuf(req));
> +		__io_fill_cqe(ctx, req->user_data, req->result, io_put_kbuf(req));
>  		nr_events++;
>  	}
>  

Not sure I follow the logic behind this change. Places like
io_iopoll_try_reap_events() just need a "did we find anything" return,
which is independent on whether or not we actually posted CQEs or not.
Other callers either don't care what the return value is or if it's < 0
or not (which this change won't affect).

I feel like I'm missing something here, or that the commit message
better needs to explain why this change is done.

-- 
Jens Axboe

