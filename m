Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 992EB11ECEB
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2019 22:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbfLMVc4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Dec 2019 16:32:56 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38094 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfLMVcz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Dec 2019 16:32:55 -0500
Received: by mail-wm1-f65.google.com with SMTP id u2so245358wmc.3;
        Fri, 13 Dec 2019 13:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VMUpcAkZBc/3hcg5ji+Dj7UkVJADZCSszth3iskQpEM=;
        b=o3Z/izHZCjNfFVfVm8doXR0ARkwNOzoCeEuKPdB3PNRW8Gen+2qZI5SYK57ReaREdw
         pac8ijJNfQIqM+NqMezzwStedtpVQHP1omiKLqFVHD599TR4/elJaEJo8IHSauT+EyIa
         I4hwrBg+MHwLZ35+TTYc00Q6dAq0J/YEZZNvuU6DjVK0YTcW5ZgiyhbXF6aSaqVpZNFD
         JXJWZgIpWJLct8jmuR2YRjD8E7oCuZngYIQ9DT+12xaLfd6/Y3kRYbRl/qRaXDNlWzST
         AKu+NWp6DkDzWFXFj0ppawhad/fXahVRSboZaKZY8x59aNg8bHi1RVxGkz8wEgNK+pdr
         +k2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VMUpcAkZBc/3hcg5ji+Dj7UkVJADZCSszth3iskQpEM=;
        b=WmytR/7YOfBGZ+CT8hjnVZH0yRLGC2ogw0ttzuOeK5IH+YZBXKuHrC+Ik2ERvTsYib
         MQt4KOX+XYqf2+QjzKPPKVOm5wXEzDlTHxRbXJaLBZu9sVGd092xig2gHtgjlhuVy9dN
         uCe/mkWfRwyYw+Lw5hCUXEdOQl3u2VqUS71eo7B1Qs7onlVsKn/xB/IwB7QgnmYIWWGG
         HoK24upqqyB7mc5/IdEsM7mzLd9/r1zLbxUDDqCOmzIAxSQld6O0rYbcExeyAxQ5hmC0
         5oSKh2IzPjIsEZ/cK+6b2eyg4Baa9URtCMfvlJZe6JHJoEZyNRAW98KBj2NANfh0MBJC
         3hxw==
X-Gm-Message-State: APjAAAV9qwW5zvLrkQF+wRoBSyHCIvXWALMUDdi8kNs7uwHiPYSR7mgR
        84DVzi7XGaom12mn83tntm3Pgja8
X-Google-Smtp-Source: APXvYqxaoJm5XuC25S5FXSgPrhvzwen4ehJtxggPn8VuvrMFcDdqWKJkbNfgeHPGO7qVeXh+mffUfg==
X-Received: by 2002:a1c:7205:: with SMTP id n5mr16222550wmc.9.1576272772712;
        Fri, 13 Dec 2019 13:32:52 -0800 (PST)
Received: from [192.168.43.233] ([109.126.143.152])
        by smtp.gmail.com with ESMTPSA id k8sm11595537wrl.3.2019.12.13.13.32.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 13:32:52 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: don't wait when under-submitting
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <5caa38be87f069eb4cc921d58ee1a98ff5d53978.1576223348.git.asml.silence@gmail.com>
 <21ca72b0-c35d-96b7-399f-d4034d976c27@kernel.dk>
 <9fbb03f4-6444-04a6-4cfb-ee4b3aa0bcd1@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <47a5641b-af81-0edf-1d71-4e3063ce8517@gmail.com>
Date:   Sat, 14 Dec 2019 00:32:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <9fbb03f4-6444-04a6-4cfb-ee4b3aa0bcd1@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 13/12/2019 21:32, Jens Axboe wrote:
> On 12/13/19 11:22 AM, Jens Axboe wrote:
>> On 12/13/19 12:51 AM, Pavel Begunkov wrote:
>>> There is no reliable way to submit and wait in a single syscall, as
>>> io_submit_sqes() may under-consume sqes (in case of an early error).
>>> Then it will wait for not-yet-submitted requests, deadlocking the user
>>> in most cases.
>>
>> Why not just cap the wait_nr? If someone does to_submit = 8, wait_nr = 8,
>> and we only submit 4, just wait for 4? Ala:
>>

Is it worth entangling the code? I don't expect anyone trying to recover,
maybe except full reset/restart. So, failing ASAP seemed to me as the
right thing to do. It may also mean nothing to the user if e.g.
submit(1), submit(1), ..., submit_and_wait(1, n)

Anyway, this shouldn't even happen in a not buggy code, so I'm fine with
any version as long as it doesn't lock up. I'll resend if you still prefer
to cap it.

>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 81219a631a6d..4a76ccbb7856 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -5272,6 +5272,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>>  		submitted = io_submit_sqes(ctx, to_submit, f.file, fd,
>>  					   &cur_mm, false);
>>  		mutex_unlock(&ctx->uring_lock);
>> +		if (submitted <= 0)
>> +			goto done;
>> +		if (submitted != to_submit && min_complete > submitted)
>> +			min_complete = submitted;
>>  	}
>>  	if (flags & IORING_ENTER_GETEVENTS) {
>>  		unsigned nr_events = 0;
>> @@ -5284,7 +5288,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>>  			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
>>  		}
>>  	}
>> -
>> +done:
>>  	percpu_ref_put(&ctx->refs);
>>  out_fput:
>>  	fdput(f);
>>
> 
> This is probably a bit cleaner, since it only adjusts if we're going to
> wait.
> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 81219a631a6d..e262549a2601 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5272,11 +5272,15 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>  		submitted = io_submit_sqes(ctx, to_submit, f.file, fd,
>  					   &cur_mm, false);
>  		mutex_unlock(&ctx->uring_lock);
> +		if (submitted <= 0)
> +			goto done;
>  	}
>  	if (flags & IORING_ENTER_GETEVENTS) {
>  		unsigned nr_events = 0;
>  
>  		min_complete = min(min_complete, ctx->cq_entries);
> +		if (submitted != to_submit && min_complete > submitted)
> +			min_complete = submitted;
>  
>  		if (ctx->flags & IORING_SETUP_IOPOLL) {
>  			ret = io_iopoll_check(ctx, &nr_events, min_complete);
> @@ -5284,7 +5288,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>  			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
>  		}
>  	}
> -
> +done:
>  	percpu_ref_put(&ctx->refs);
>  out_fput:
>  	fdput(f);
> 

-- 
Pavel Begunkov
