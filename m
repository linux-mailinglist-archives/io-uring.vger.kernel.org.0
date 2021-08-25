Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D1C3F75E0
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 15:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240053AbhHYN3r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 09:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239992AbhHYN3r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 09:29:47 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C30C061757
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 06:29:01 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id q11so9519233wrr.9
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 06:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Eip0HZ7B8mRN5IDUIKroqnmX2f7qpWifMm0o5Wnr42Q=;
        b=iwuDOJZLCx+wX7zRh0xy/qAqReJr5O2ITlVVBrcNV7a/I0BESZ0ZxI6Nagbxko2ADn
         MtNElOD+tI7Z1tHlBygDNlUUyzmEdrNYQHl9TWIKrrSb2js0anZmCE+jbyDWBSiCivkk
         T2ZP7E1daKb1kRk8n4Y09ipmBRo+CNTT7eajNLGfjryezDYLhlMD4zytcbDtnFnPwSfs
         B42t7LK+kzw95rcvDrZs1sPyXhRyI55uI45WyWcRCdRTvsOUdmw9dR02IpluxPqzXekl
         Vxuf5ugDkDI69o/q4PIMoKsb792J+eB/jx7FuD86FEM21Ccpj1p8WjUOATZeqxGWJpy6
         qCyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Eip0HZ7B8mRN5IDUIKroqnmX2f7qpWifMm0o5Wnr42Q=;
        b=emuZT/7ev4LzpITOmxMhwyH5+SMG+jvZag9RanbbJihQ+LEz7tBGy30t65kIuvdl0A
         Jj3uXrqTPsiKn0ORTSVYSczJOSg6B7QJLNC5AhEsMj6kFRFrPc9utBcOD5RCAtBJYcMU
         UUb8sUx9T6RJgJG2sYKnXjL0QB45DVF+8KU5xKK34/s3wEUcUys7MPH4Au5qTEjmBnWe
         To1WbdMGbtRY71mhRmEu7Lb9XfTZZvrdcBTBNWywYzLMqVBZ2tTFgtz0yS4VnzEZpH+U
         VElg5hSZdWkMEgP8a7XxEk2IsTascQi+R9DAjFm2X6GJ+IQeba8qRdgBVLAA/nDujLem
         GV+A==
X-Gm-Message-State: AOAM533bsGv0F4mYgHWizKrt1gYKekaFR5SdLV+o4Mj0Fm2DQyl6TWIr
        yUPg0xMNGYYRyGXYX4XYzw0=
X-Google-Smtp-Source: ABdhPJxRISQ/fZFh0lvpD/8dPn7jpHNiL5Vll821OMRHZXZcKf+2CGn4OMHMmBj4jbnme30M9uNDBQ==
X-Received: by 2002:adf:f88d:: with SMTP id u13mr24728691wrp.297.1629898140028;
        Wed, 25 Aug 2021 06:29:00 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id q11sm5316776wmc.41.2021.08.25.06.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 06:28:59 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210825114003.231641-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: don't free request to slab
Message-ID: <03767556-ac49-b550-6e73-3b00b3b66753@gmail.com>
Date:   Wed, 25 Aug 2021 14:28:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210825114003.231641-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/21 12:40 PM, Hao Xu wrote:
> It's not neccessary to free the request back to slab when we fail to
> get sqe, just update state->free_reqs pointer.

It's a bit hackish because depends on the request being drawn
from the array in a particular way. How about returning it
into state->free_list. That thing is as cold as it can get,
only buggy apps can hit it. 


> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 74b606990d7e..ce66a9ce2b43 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6899,7 +6899,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
>  		}
>  		sqe = io_get_sqe(ctx);
>  		if (unlikely(!sqe)) {
> -			kmem_cache_free(req_cachep, req);
> +			ctx->submit_state.free_reqs++;
>  			break;
>  		}
>  		/* will complete beyond this point, count as submitted */
> 

-- 
Pavel Begunkov
