Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E294323389
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 23:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhBWWBc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 17:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbhBWWBc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 17:01:32 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8980BC061574
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 14:00:51 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id w7so120065wmb.5
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 14:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gfJrAbrLybmT34/Ci3DRsOlABW36D3Uc/YhM3NgGDDM=;
        b=YsEP6YIfsfDxCuW3gnUpT1LZ3VxW+JAfr+CGjib1a2Cw3r5KCZsUqIXxgDvF0DvkLP
         rrI/bGuBwlsxFjmYmthMGNoMurapi+rLMmC6X3qB3mNU9TfaNW0qI3mvcJH0h3IBydjf
         R1cWG3zeKUt+qZFKRE+YVsPPNdsdMsBDRuY9pyYbBFGCjhCk7CV1Wl4aGuK+K2Xl6fSO
         jrqrPKtKTbDH6d7y17HygBiM40D8EeBVkHp6BY24BmkSdd/hXkPoOHEAetLFT6cqqYgH
         h8A+TeTRrFNkaTPxsc25i/SZOFflPzcDKDD3FARXEJnxnsYgXRz1vSWQdoAkLs9koM9A
         u1zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gfJrAbrLybmT34/Ci3DRsOlABW36D3Uc/YhM3NgGDDM=;
        b=ZIzzFMwm6sizEAn/ptGRu0C7Xf65wQwxrMIaR3PfNYkaQaknltPOgOqmAxOJ5WtOXb
         e2UBfFVLKFdJgTviLlJ0fpMEfgquifffEeY8q0k94MeZZjUrxU1ucIpmNFegTBNdPg3t
         k81qOMSfS9ba/nTySX/8ECNN88vsp8LLOmprn7uGENVRPD1vha9haNAXJ5oKtwDSzTIG
         jHGhSoerO+zC4QYcttiV0XEerLNLyJ2nYu4D8HoSzvvDfBNgY9uMBycV9IMfJNhygFbC
         1bTty0hIlk3RTVfXFT5Qaxwh3ZqQB+6dsyFHDtSnNM7wW55a+bpMsd4UWxyBqAETpoU7
         zq1A==
X-Gm-Message-State: AOAM531ZJMZpi1w1bHboVWvcqL0n+fv27EzQc3VIfqCrwBd1A/Ohos/R
        XeYrspcW3QLCgoIqADuWYgJOq95F5+kk0A==
X-Google-Smtp-Source: ABdhPJy+6pZ2zK0klqqJfuAZx4Xr0WoBAqHsIwo2NiSEqUiVwciI9FqRphQ+/0PnX0dsD0gn0ixpDQ==
X-Received: by 2002:a7b:c94a:: with SMTP id i10mr115538wml.36.1614117650110;
        Tue, 23 Feb 2021 14:00:50 -0800 (PST)
Received: from [192.168.8.161] ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id h22sm444418wmb.36.2021.02.23.14.00.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 14:00:49 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: fix locked_free_list caches_free()
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <3375ffb5767effcf8792e8425e189e78eb843431.1614117221.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <c08d9903-b7e1-f52b-9a99-5518e84fe785@gmail.com>
Date:   Tue, 23 Feb 2021 21:56:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3375ffb5767effcf8792e8425e189e78eb843431.1614117221.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 23/02/2021 21:53, Pavel Begunkov wrote:
> Don't forget to zero locked_free_nr, it's not a disaster but makes it
> attempting to flush it with extra locking when there is nothing in the
> list. Also, don't traverse a potentially long list freeing requests
> under spinlock, splice the list and do it afterwards.

Err, it gone totally wrong, will resend

> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index bf9ad810c621..dedcf971e2d5 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8710,12 +8710,13 @@ static void io_req_caches_free(struct io_ring_ctx *ctx, struct task_struct *tsk)
>  		submit_state->free_reqs = 0;
>  	}
>  
> -	io_req_cache_free(&submit_state->comp.free_list, NULL);
> -
>  	spin_lock_irq(&ctx->completion_lock);
> -	io_req_cache_free(&submit_state->comp.locked_free_list, NULL);
> +	list_splice_init(&cs->locked_free_list, &cs->free_list);
> +	cs->locked_free_nr = 0;
>  	spin_unlock_irq(&ctx->completion_lock);
>  
> +	io_req_cache_free(&submit_state->comp.free_list, NULL);
> +
>  	mutex_unlock(&ctx->uring_lock);
>  }
>  
> 

-- 
Pavel Begunkov
